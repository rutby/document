//#define PROTOBUF_OPTIMIZE
using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using GameFramework;

namespace SimpleProto
{
    public sealed class ProtoBufAttribute : System.Attribute
    {
        private int m_index;
        public int Index { get { return m_index; } set { m_index = value; } }
        public ProtoBufAttribute(int index)
        {
            m_index = index;
        }
    }

    internal class ProtoBufSerializer
    {
        protected enum WireType
        {
            LengthDelimited = 0,
            VarInt = 1,
            Data32 = 2,
            Data64 = 3,
            //Data8 =  4,
            //Data16 = 5,
        }

        // -------------- begin var int ---------------------
        private static bool USE_VAR_INT32 = true;
        private static bool USE_VAR_INT64 = true;

        public static void to_var_int(long n, OutStream outs)
        {
            ulong v = (ulong)((n << 1) ^ (n >> 63)); //zigzag
            for (; ; )
            {
                byte abyte = (byte)(v & 0x7f);
                v = v >> 7;
                if (v == 0)
                {
                    outs.Write(abyte);
                    break;
                }
                else
                {
                    abyte |= 0x80;
                    outs.Write(abyte);
                }
            }
        }

        public static long from_var_int(InStream ins)
        {
            long n = 0;
            int shift = 0;
            for (; ; )
            {
                byte abyte = 0;
                ins.Read(ref abyte);
                long bvar = ((long)abyte) & 0x7f;
                n += bvar << shift;
                shift += 7;
                if ((abyte & 0x80) == 0)
                {
                    break;
                }
            }

            return (long)(((ulong)n >> 1) ^ (ulong)(-(n & 1)));//unzigzag
        }
        // --------------  end var int ----------------------

        static ushort make_field_desc(int fsindex, WireType wire_type)
        {
            ushort desc = (ushort)((fsindex << 3) | (int)wire_type);
            return desc;
        }
        static int parse_field_index(ushort desc)
        {
            return (ushort)(desc >> 3);
        }
        static WireType parse_wire_type(ushort desc)
        {
            return (WireType)(desc & 0x0007);
        }
        static void save_field_desc(int fsindex, WireType wire_type, OutStream outs)
        {
            if (fsindex != -1)
            {
                ushort desc = make_field_desc(fsindex, wire_type);
                outs.Write(desc);
            }
        }

        static void save_protobuf_lenth_delimited(int fsindex, Buffer buff, OutStream outs)
        {
            save_field_desc(fsindex, WireType.LengthDelimited, outs);
            outs.Write(buff);
        }

        static void save_protobuf_string(int fsindex, string val, OutStream outs)
        {
            Buffer buff = new Buffer(1024);
            OutStream tempouts = new OutStream(buff);

            tempouts.Write(val);
            save_protobuf_lenth_delimited(fsindex, buff, outs);
        }

        static void save_protobuf_array(int fsindex, byte[] val, OutStream outs)
        {
            Buffer buff = new Buffer(1024);
            OutStream tempouts = new OutStream(buff);

            tempouts.Write(val);
            save_protobuf_lenth_delimited(fsindex, buff, outs);
        }

        static void save_protobuf_int32(int fsindex, int val, OutStream outs, WireType wire_type)
        {
            if (wire_type == WireType.VarInt)
            {
                save_field_desc(fsindex, WireType.VarInt, outs);
                to_var_int(val, outs);
            }
            else
            {
                save_field_desc(fsindex, WireType.Data32, outs);
                outs.Write(val);
            }
        }

        static void save_protobuf_int64(int fsindex, long val, OutStream outs, WireType wire_type)
        {
            if (wire_type == WireType.VarInt)
            {
                save_field_desc(fsindex, WireType.VarInt, outs);
                to_var_int(val, outs);
            }
            else
            {
                save_field_desc(fsindex, WireType.Data64, outs);
                outs.Write(val);
            }
        }

        static void save_protobuf_float32(int fsindex, float val, OutStream outs)
        {
            save_field_desc(fsindex, WireType.Data32, outs);
            outs.Write(val);
        }

        static void save_protobuf_float64(int fsindex, double val, OutStream outs)
        {
            save_field_desc(fsindex, WireType.Data64, outs);
            outs.Write(val);
        }

        static void save_type(Type ft, OutStream outs)
        {
            ValueType vt = get_value_type(ft);
            WireType wt = get_wire_type(vt);
            byte w = (byte)wt;
            outs.Write(w);
        }
        static WireType read_type(InStream ins)
        {
            byte w = 0;
            ins.Read(ref w);
            return (WireType)w;
        }

        static void save_protobuf_list(int fsindex, object listobj, OutStream outs)
        {
            Buffer buff = new Buffer(1024);
            OutStream tempouts = new OutStream(buff);

            IList list = listobj as IList;
            int count = list.Count;
            tempouts.Write(count);
            if (count > 0)
            {
                save_type(list[0].GetType(), tempouts);
                foreach (var item in list)
                {
                    _encode_item_to_stream(-1, item, tempouts);
                }
            }
            save_protobuf_lenth_delimited(fsindex, buff, outs);
        }
        static void load_protobuf_list(Type item_type, ref object listobj, InStream ins)
        {
            InStream tempins = load_protobuf_lenth_delimited(ins);
            IList list = listobj as IList;

            int count = 0;
            tempins.Read(ref count);
            if (count > 0)
            {
                WireType wt = read_type(tempins);
                for (int i = 0; i < count; ++i)
                {
                    object obj = DecodeItemRaw(item_type, wt, tempins);
                    list.Add(obj);
                }
            }
        }
        static void save_protobuf_dictionary(int fsindex, object dictobj, OutStream outs)
        {
            Buffer buff = new Buffer(1024);
            OutStream tempouts = new OutStream(buff);

            IDictionary dict = dictobj as IDictionary;
            int count = dict.Count;
            tempouts.Write(count);
            if (count > 0)
            {
                bool saveindex = true;
                foreach (var key in dict.Keys)
                {
                    if (saveindex)
                    {
                        save_type(key.GetType(), tempouts);
                        save_type(dict[key].GetType(), tempouts);
                        saveindex = false;
                    }

                    _encode_item_to_stream(-1, key, tempouts);
                    _encode_item_to_stream(-1, dict[key], tempouts);
                }
            }
            save_protobuf_lenth_delimited(fsindex, buff, outs);
        }
        static void load_protobuf_dictionary(Type key_type, Type value_type, ref object dictobj, InStream ins)
        {
            InStream tempins = load_protobuf_lenth_delimited(ins);
            IDictionary dict = dictobj as IDictionary;

            int count = 0;
            tempins.Read(ref count);
            if (count > 0)
            {
                WireType wt_k = read_type(tempins);
                WireType wt_v = read_type(tempins);

                for (int i = 0; i < count; ++i)
                {
                    object key = DecodeItemRaw(key_type, wt_k, tempins);
                    object value = DecodeItemRaw(value_type, wt_v, tempins);
                    dict.Add(key, value);
                }
            }
        }
        static InStream load_protobuf_lenth_delimited(InStream ins)
        {
            Buffer buff = new Buffer(1024);
            ins.Read(ref buff);

            InStream tempins = new InStream(buff);
            return tempins;
        }
        static object load_protobuf_string(InStream ins, WireType wire_type)
        {
            if (wire_type == WireType.LengthDelimited)
            {
                string val = "";
                InStream tempins = load_protobuf_lenth_delimited(ins);

                tempins.Read(ref val);
                return val;
            }
            return null;
        }
        static object load_protobuf_array(InStream ins, WireType wire_type)
        {
            if (wire_type == WireType.LengthDelimited)
            {
                byte[] val = new byte[0];
                InStream tempins = load_protobuf_lenth_delimited(ins);

                tempins.Read(ref val);
                return val;
            }
            return null;
        }
        static void load_protobuf_compound(object obj, InStream ins)
        {
            InStream tempins = load_protobuf_lenth_delimited(ins);
#if PROTOBUF_OPTIMIZE
            FieldInfo[] fields = GetProtobufFields(obj.GetType());
#endif
            while (tempins.BytesLeft() >= 2)
            {
                ushort field_desc = 0;
                tempins.Read(ref field_desc);

                int fsindex = parse_field_index(field_desc);
                WireType wire_type = parse_wire_type(field_desc);
#if PROTOBUF_OPTIMIZE
                bool res = DecodeItem(obj, fields, wire_type, fsindex, tempins);
#else
                bool res = DecodeItem(obj, wire_type, fsindex, tempins);
#endif
                if (!res)
                {
                    skip_buffer(wire_type, tempins);
                    GameFramework.Log.Warning("LoadItemFromStream " + obj.GetType().Name + "[" + fsindex + "] skiped!");
                }
                else
                {
                    //Log.Info("LoadItemFromStream " + fsindex + " ok");
                }
            }
        }

        static object load_protobuf_int32(InStream ins, WireType wire_type)
        {
            if (wire_type == WireType.VarInt)
            {
                long v = from_var_int(ins);
                return (int)v;
            }
            else if (wire_type == WireType.Data32)
            {
                int val = 0;
                ins.Read(ref val);
                return val;
            }
            return null;
        }
        static object load_protobuf_int64(InStream ins, WireType wire_type)
        {
            long val = 0;
            if (wire_type == WireType.VarInt)
            {
                val = from_var_int(ins);
                return val;
            }
            else if (wire_type == WireType.Data64)
            {
                ins.Read(ref val);
                return val;
            }
            return null;
        }
        static object load_protobuf_float32(InStream ins, WireType wire_type)
        {
            float val = 0f;
            if (wire_type == WireType.Data32)
            {
                ins.Read(ref val);
                return val;
            }
            return null;
        }
        static object load_protobuf_float64(InStream ins, WireType wire_type)
        {
            double val = 0f;
            if (wire_type == WireType.Data64)
            {
                ins.Read(ref val);
                return val;
            }
            return null;
        }

        static void skip_buffer(WireType wire_type, InStream ins)
        {
            int len = 0;
            switch (wire_type)
            {
                case WireType.LengthDelimited:
                    ins.Read(ref len);
                    ins.Skip(len);
                    break;
                case WireType.VarInt:
                    from_var_int(ins);
                    //ins.Skip(4);//这里需要等实际实现后改，现在没用到。
                    break;
                case WireType.Data32:
                    ins.Skip(4);
                    break;
                case WireType.Data64:
                    ins.Skip(8);
                    break;
                default:
                    break;
            }
        }
        static void save_protobuf_compound(int fsindex, object obj, OutStream outs)
        {
            Buffer buff = new Buffer(1024);
            OutStream tempouts = new OutStream(buff);

            _encode_compound_to_stream(obj, tempouts);

            save_protobuf_lenth_delimited(fsindex, buff, outs);
        }
        static void _encode_compound_to_stream(object obj, OutStream outs)
        {
#if PROTOBUF_OPTIMIZE
            Type type = obj.GetType();
            FieldInfo[] fields = GetProtobufFields(type);
            for (int index = 0; index < fields.Length; ++index)
            {
                FieldInfo field = fields[index];
                if (field == null)
                    continue;
                object val = field.GetValue(obj);
                if (val != null)
                {
                    _encode_item_to_stream(index, val, outs);
                }
                else
                {
                    GameFramework.Log.Error("value is null: " + type.Name + "." + field.Name);
                }
            }
#else
            Type type = obj.GetType();

            foreach (var field in type.GetFields())
            {
                object[] fieldattrs = field.GetCustomAttributes(false);
                foreach (ProtoBufAttribute pa in fieldattrs)
                {
                    int index = pa.Index;
                    object val = field.GetValue(obj);
                    if (val != null)
                    {
                        _encode_item_to_stream(index, val, outs);
                    }
                    else
                    {
                        Log.Debug("value is null: " + type.Name + "." + field.Name);
                    }
                }
            }
#endif
        }
        protected enum ValueType
        {
            NotSupported,
            Int32,
            Int64,
            Float32,
            Float64,
            String,
            ByteArray,
            List,
            Dictionary,
            Compound,
        }
        static ValueType get_value_type(Type ft)
        {
            if (ft == typeof(int)
                || ft == typeof(uint)
                || ft == typeof(byte)
                || ft == typeof(sbyte)
                || ft == typeof(short)
                || ft == typeof(ushort)
                || ft == typeof(bool)
                )
            {
                return ValueType.Int32;
            }
            else if (ft == typeof(char))
            {
                throw new NotImplementedException("char not supported");
            }
            else if (ft == typeof(long)
                || ft == typeof(ulong))
            {
                return ValueType.Int64;
            }
            else if (ft == typeof(float))
            {
                return ValueType.Float32;
            }
            else if (ft == typeof(double))
            {
                return ValueType.Float64;
            }
            else if (ft == typeof(string))
            {
                return ValueType.String;
            }
            else if (ft == typeof(byte[]))
            {
                return ValueType.ByteArray;
            }
            else if (ft.Name == "List`1")
            {
                return ValueType.List;
            }
            else if (ft.Name == "LinkedList`1")
            {
                throw new NotImplementedException("LinkedList not supported");
            }
            else if (ft.Name == "Dictionary`2")
            {
                return ValueType.Dictionary;
            }
            else
            {
                return ValueType.Compound;
            }
        }
        static WireType get_wire_type(ValueType vt)
        {
            if (vt == ValueType.Int32
                || vt == ValueType.Float32
                )
            {
                if (USE_VAR_INT32)
                    return WireType.VarInt;
                else
                    return WireType.Data32;
            }
            else if (vt == ValueType.Int64
                || vt == ValueType.Float64
                )
            {
                if (USE_VAR_INT64)
                    return WireType.VarInt;
                else
                    return WireType.Data64;
            }
            else
            {
                return WireType.LengthDelimited;
            }
        }

        static void _encode_item_to_stream(int index, object val, OutStream outs)
        {
            Type ft = val.GetType();
            ValueType vt = get_value_type(ft);
            WireType wt = get_wire_type(vt);
            //Log.Info("GetFields " + field.Name + " type=" + ft.Name + " val=" + val + " index=" + pa.Index);
            if (vt == ValueType.Int32)
            {
                int intval = Convert.ToInt32(val);
                save_protobuf_int32(index, intval, outs, wt);
            }
            else if (vt == ValueType.Int64)
            {
                save_protobuf_int64(index, (long)val, outs, wt);
            }
            else if (vt == ValueType.Float32)
            {
                save_protobuf_float32(index, (float)val, outs);
            }
            else if (vt == ValueType.Float64)
            {
                save_protobuf_float64(index, (double)val, outs);
            }
            else if (vt == ValueType.String)
            {
                save_protobuf_string(index, (string)val, outs);
            }
            else if (vt == ValueType.ByteArray)
            {
                save_protobuf_array(index, (byte[])val, outs);
            }
            else if (vt == ValueType.List)
            {
                save_protobuf_list(index, val, outs);
            }
            else if (vt == ValueType.Dictionary)
            {
                save_protobuf_dictionary(index, val, outs);
            }
            else
            {
                save_protobuf_compound(index, val, outs);
            }
        }

        private static object DecodeItemRaw(Type ft, WireType wire_type, InStream ins)
        {
            ValueType vt = get_value_type(ft);
            //WireType wt = get_wire_type(vt);
            object ret = null;
            if (vt == ValueType.Int32)
            {
                ret = load_protobuf_int32(ins, wire_type);
            }
            else if (vt == ValueType.Int64)
            {
                ret = load_protobuf_int64(ins, wire_type);
            }
            else if (vt == ValueType.Float32)
            {
                ret = load_protobuf_float32(ins, wire_type);
            }
            else if (vt == ValueType.Float64)
            {
                ret = load_protobuf_float64(ins, wire_type);
            }
            else if (vt == ValueType.String)
            {
                ret = load_protobuf_string(ins, wire_type);
            }
            else if (vt == ValueType.ByteArray)
            {
                ret = load_protobuf_array(ins, wire_type);
            }
            else if (vt == ValueType.List)
            {
                ret = System.Activator.CreateInstance(ft);
                Type[] args = ft.GetGenericArguments();
                load_protobuf_list(args[0], ref ret, ins);
            }
            else if (vt == ValueType.Dictionary)
            {
                ret = System.Activator.CreateInstance(ft);
                Type[] args = ft.GetGenericArguments();
                load_protobuf_dictionary(args[0], args[1], ref ret, ins);
            }
            else if (vt == ValueType.Compound)
            {
                //Log.Info("loading " + ft.Name);
                ret = System.Activator.CreateInstance(ft);
                load_protobuf_compound(ret, ins);
            }

            if (ret != null)
            {
                return Convert.ChangeType(ret, ft);
            }
            GameFramework.Log.Warning("type does not match " + ft + " vs " + wire_type);
            return null;
        }
#if PROTOBUF_OPTIMIZE
        // 要求ProtoBufAttribute索引>=0，可以是不连续的
        private static Dictionary<Type, FieldInfo[]> ProtoBufFieldCache = new Dictionary<Type, FieldInfo[]>();
        private static FieldInfo[] GetProtobufFields(Type type)
        {
            FieldInfo[] cached_fields;
            ProtoBufFieldCache.TryGetValue(type, out cached_fields);
            if (cached_fields != null)
                return cached_fields;
            Dictionary<int, FieldInfo> fields_dict = new Dictionary<int, FieldInfo>();
            int max_index = 0;
            foreach (var field in type.GetFields())
            {
                object[] fieldattrs = field.GetCustomAttributes(false);
                foreach (ProtoBufAttribute pa in fieldattrs)
                {
                    fields_dict.Add(pa.Index, field);
                    if (pa.Index > max_index)
                        max_index = pa.Index;
                }
            }
            var fields_array = new FieldInfo[max_index + 1];
            foreach (var pf in fields_dict)
            {
                fields_array.SetValue(pf.Value, pf.Key);
            }
            //加入缓存
            ProtoBufFieldCache.Add(type, fields_array);
            return fields_array;
        }
        private static bool DecodeItem(object obj, FieldInfo[] fields, WireType wire_type, int fsindex, InStream ins)
        {
            Type type = obj.GetType();
            if (fsindex < 0 || fsindex >= fields.Length)
                return false;
            FieldInfo field = fields[fsindex];
            if (field == null)
                return false;
            Type ft = field.GetValue(obj).GetType();
            object val = DecodeItemRaw(ft, wire_type, ins);
            if (val != null)
            {
                field.SetValue(obj, val);
                return true;
            }
            return false;
        }
#else
        private static bool DecodeItem(object obj, WireType wire_type, int fsindex, InStream ins)
        {
            Type type = obj.GetType();

            foreach (var field in type.GetFields())
            {
                object[] fieldattrs = field.GetCustomAttributes(false);
                foreach (ProtoBufAttribute pa in fieldattrs)
                {
                    if (fsindex == (ushort)pa.Index)
                    {
                        Type ft = field.FieldType;


                        object val = DecodeItemRaw(ft, wire_type, ins);
                        if (val != null)
                        {
                            field.SetValue(obj, val);
                            return true;
                        }
                    }
                }
            }
            return false;
        }
#endif
        public static void SaveStream(object obj, OutStream outs)
        {
            save_protobuf_compound(-1, obj, outs);
        }
        public static void LoadStream(object obj, InStream ins)
        {
            load_protobuf_compound(obj, ins);
        }
    }

    public abstract class ProtoBufMessage
    {
        public static void Encrypt(uint key, byte[] bytes, int length)
        {
            for (int offset = 0; offset < length; offset += 4)
            {
                bytes[offset + 0] ^= (byte)(key);
                bytes[offset + 1] ^= (byte)(key>>8);
                bytes[offset + 2] ^= (byte)(key>>16);
                bytes[offset + 3] ^= (byte)(key>>24);

                key = (uint)CRC32.GetCRC32(bytes, offset, 4);
            }
        }
        public static void Decrypt(uint key, byte[] bytes, int length)
        {
            for (int offset = 0; offset < length; offset += 4)
            {
                uint newkey = (uint)CRC32.GetCRC32(bytes, offset, 4);
                bytes[offset + 0] ^= (byte)(key);
                bytes[offset + 1] ^= (byte)(key >> 8);
                bytes[offset + 2] ^= (byte)(key >> 16);
                bytes[offset + 3] ^= (byte)(key >> 24);

                key = newkey;
            }
        }
        public static void ToStream(OutStream outs, ProtoBufMessage msg, uint key)
        {
            //uint security_flag = 0xacabdeaf;
            //int checksum = 0;

            //Buffer buff = new Buffer(256);
            //OutStream tempouts = new OutStream(buff);
            //ProtoBufSerializer.SaveStream(msg, tempouts);

            //Encrypt(key, buff.buffer, buff.length);

            //checksum = CRC32.GetCRC32(buff.buffer, 0, buff.length);
            //outs.Write(security_flag);
            //outs.Write(checksum);
            //outs.Write(buff);

          
            ProtoBufSerializer.SaveStream(msg, outs);
        }
        public static void FromStream(InStream ins, ProtoBufMessage msg, uint key)
        {
            //uint security_flag = 0xacabdeaf;
            //int checksum = 0;
            //ins.Read(ref security_flag);
            //ins.Read(ref checksum);

            //Buffer buff = new Buffer(256);
            //ins.Read(ref buff);

            //int c = CRC32.GetCRC32(buff.buffer, 0, buff.length);
            ////Log.Info("checksum of buffer len " + buff.length + " = " + c + " vs " + checksum);
            //if (checksum != c)
            //{
            //    Log.Error("checksum error", checksum);
            //}
            //else
            //{
            //    Decrypt(key, buff.buffer, buff.length);
            //    InStream tempins = new InStream(buff);

            //    ProtoBufSerializer.LoadStream(msg, tempins);
            //}


            ProtoBufSerializer.LoadStream(msg, ins);
        }

        public void ToStream(OutStream outs)
        {
            ToStream(outs, this, 12345678);
        }

        public byte[] SerializeToBytes(){
            SimpleProto.Buffer buffer = new SimpleProto.Buffer(1024);
            OutStream outStream = new OutStream(buffer);
            ToStream(outStream);

            byte[] tmpArray = new byte[outStream.Offset];
            Array.Copy(outStream.GetBuffer().buffer, tmpArray, outStream.Offset);
            return tmpArray;
        }

        public void DeSerializeFromBytes(byte[] data){
            SimpleProto.Buffer buffer1 = new SimpleProto.Buffer(data);
            InStream inStream = new InStream(buffer1);
            FromStream(inStream);
        }

        public void FromStream(InStream ins)
        {
            FromStream(ins, this, 12345678);
        }
    }
}
