using System;
using System.Collections.Generic;
using SimpleProto;

namespace ProtoBufNet
{
    public class NetOutStream
    {
        public NetOutStream(NetBuffer buffer)
        {
            m_buffer = buffer;
        }

        public void Write(bool val)
        {
            this.m_buffer.Resize(m_offset + 1);
            //byte[] array = BitConverter.GetBytes(val);
            //array.CopyTo(m_buffer.buffer, m_offset);
            SimpleBitConverter.GetBytes(val, m_buffer.buffer, m_offset);
            m_offset += 1;
            m_buffer.length += 1;
        }

        public void Write(double val)
        {
            this.m_buffer.Resize(m_offset + 8);
            byte[] array = BitConverter.GetBytes(val);
            array.CopyTo(m_buffer.buffer, m_offset);
            m_offset += 8;
            m_buffer.length += 8;
        }

        public void Write(short val)
        {
            this.m_buffer.Resize(m_offset + 2);
            byte[] array = BitConverter.GetBytes(val);
            array.CopyTo(m_buffer.buffer, m_offset);
            m_offset += 2;
            m_buffer.length += 2;
        }

        public void Write(ushort val)
        {
            this.m_buffer.Resize(m_offset + 2);
            byte[] array = BitConverter.GetBytes(val);
            array.CopyTo(m_buffer.buffer, m_offset);
            m_offset += 2;
            m_buffer.length += 2;
        }

        public void Write(int val)
        {
            this.m_buffer.Resize(m_offset + 4);
            byte[] array = BitConverter.GetBytes(val);
            array.CopyTo(m_buffer.buffer, m_offset);
            m_offset += 4;
            m_buffer.length += 4;
        }

        public void Write(uint val)
        {
            this.m_buffer.Resize(m_offset + 4);
            byte[] array = BitConverter.GetBytes(val);
            array.CopyTo(m_buffer.buffer, m_offset);
            m_offset += 4;
            m_buffer.length += 4;
        }

        public void Write(long val)
        {
            this.m_buffer.Resize(m_offset + 8);
            byte[] array = BitConverter.GetBytes(val);
            array.CopyTo(m_buffer.buffer, m_offset);
            m_offset += 8;
            m_buffer.length += 8;
        }

        public void Write(ulong val)
        {
            this.m_buffer.Resize(m_offset + 8);
            byte[] array = BitConverter.GetBytes(val);
            array.CopyTo(m_buffer.buffer, m_offset);
            m_offset += 8;
            m_buffer.length += 8;
        }

        public void Write(byte val)
        {
            this.m_buffer.Resize(m_offset + 1);
            m_buffer.buffer[m_offset] = val;
            m_offset += 1;
            m_buffer.length += 1;
        }

        public void Write(sbyte val)
        {
            Write((byte)val);
        }

        public void Write(float val)
        {
            byte[] array = BitConverter.GetBytes(val);
            this.m_buffer.Resize(m_offset + array.Length);
            array.CopyTo(m_buffer.buffer, m_offset);
            m_offset += array.Length;
            m_buffer.length += array.Length;
        }

        public void Write(string val)
        {
            //take care the encoding
            byte[] strval = System.Text.Encoding.Default.GetBytes(val);
            this.Write(strval.Length);
            this.m_buffer.Resize(m_offset + strval.Length);

            strval.CopyTo(m_buffer.buffer, m_offset);
            m_offset += strval.Length;
            m_buffer.length += strval.Length;

            byte eos = 0;
            this.Write(eos);
        }

        public void Write(NetBuffer buffer)
        {
            this.Write(buffer.length);
            this.m_buffer.Resize(m_offset + buffer.length);
            System.Array.Copy(buffer.buffer, 0, m_buffer.buffer, m_offset, buffer.length);
            m_offset += buffer.length;
            m_buffer.length += buffer.length;
        }

        private NetBuffer m_buffer;
        private int m_offset = 0;
    }
}
