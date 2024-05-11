using System.Collections;
using System.Collections.Generic;
using System.Text;
using GameFramework;
using UnityEngine;

namespace Data.Csv
{
    public class Row
    {
        public Row(CSVCacheder csv ,string[] value)
        {
            this._csv = csv;
            this._array = value;
        }

        public readonly CSVCacheder _csv;
        private readonly string[] _array;
        //private readonly Dictionary<string, string> _dic;

        public int Count
        {
            get
            {
                if (_array == null)
                    return 0;
                return _array.Length;
            }
        }

        public bool HasKey(string key)
        {
            return _csv.hasKey(key);
        }

        public string GetData(string key, bool log = true)
        {
            if (_csv == null || _array == null)
                return string.Empty;
            
            int index = _csv.GetColumnIndex(key);

            if (index >= 0 && index < _array.Length)
                return _array[index];
            //if (log)
                //Log.Debug("no column key in this row");
            return string.Empty;
        }

        public string GetString(string key)
        {
            return GetData(key);
        }

        public int GetInt(string key, int defalut = 0){
            return TryGetInt(key);
        }

        public int TryGetInt(string key, int defalut = 0){
            var tmp = GetData(key);
            int ret;
            if (!int.TryParse(tmp, out ret))
            {
                //Log.Error("Value with key [{0}] in table<[{1}]>:id({2}) is not a int", key, m_TableName, m_Id);
                return defalut;
            }
            return ret;
        }

        public float GetFloat(string key){
            var tmp = GetData(key);
            float ret;
            if (!float.TryParse(tmp, out ret))
            {
                //Log.Error("Value with key [{0}] in table<[{1}]>:id({2}) is not a int", key, m_TableName, m_Id);
                return 0;
            }
            return ret;
        }

        public string this[string key]
        {
            get { return GetData(key); }
        }

        public override string ToString()
        {
            StringBuilder builder = new StringBuilder();

            if (_array == null) return builder.ToString();
            foreach (var t in _array)
            {
                builder.Append( $"{t}" + ",");
            }
            
            return builder.ToString();
        }

        public string[] GetStringArray(string key, char spliter, bool copy = false)
        {
            var value = GetString(key);

            if (value == null)
            {
                return null;
            }
            var s = ((string)value).Split(spliter);
            if (copy)//复制一份
            {
                return s;
            }

            return s;
        }
        
        public long GetLong(string key){
            var tmp = GetData(key);
            long ret;
            if (!long.TryParse(tmp, out ret))
            {
                //Log.Error("Value with key [{0}] in table<[{1}]>:id({2}) is not a int", key, m_TableName, m_Id);
                return 0;
            }
            return ret;
        }
    }
}