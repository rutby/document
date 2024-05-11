using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Xml.Xsl;
using GameFramework;
using UnityEngine;

namespace Data.Csv
{
    //游戏
    public class CSVCacheder
    {
        /// <summary>
        /// 文件的编码。
        /// </summary>
        public Encoding CsvEncoding { get; set; } = Encoding.UTF8;

        /// <summary>
        /// 表示是否要进行列的裁剪操作。
        /// </summary>
        public bool TrimColumns { get; set; } = false;

        /// <summary>
        /// CSV的分隔符，默认为半角逗号（即,）。
        /// </summary>
        public char CsvSeparator { get; set; } = ',';

        /// <summary>
        /// 判断指定行列的单元格是否在范围内。
        /// </summary>
        /// <param name="row">指定的行编号。</param>
        /// <param name="column">指定的列编号。</param>
        /// <returns></returns>
        public bool IsInRange(int row, int column) { return row >= 0 && row < RowCount && column >= 0 && column < ColumnCount; }

        public string _name = string.Empty;
        private int _key = 0;

        //表头
        private readonly Dictionary<string, int> _cachedDicRow = new Dictionary<string, int>();
        //行索引
        private readonly Dictionary<string, int> _cachedDicClo = new Dictionary<string, int>();
        //详细信息
        public List<Row> Rows { get; private set; } = new List<Row>();
        //public CSVCacheder(string path)
        //{
        //    CsvEncoding = Encoding.Default;
        //    Data = GetListCsvData(path);
        //}
        public CSVCacheder(string tableName, string text, int keyIndex = 0)
        {
            _name = tableName;
            CsvEncoding = Encoding.Default;
            this._key = keyIndex;
            Rows = this.GetListRow(text);
        }

        public Row GetRow(string id)
        {
            if (string.IsNullOrEmpty(id)) return null;

            if (_cachedDicRow.TryGetValue(id, out int index))
            {
                if (index < Rows.Count)
                {
                    return Rows[index];
                }
            }
            else
            {
                Log.Error("no id {0} in table {1}", id, _name);
            }

            return null;
        }

        public Row this[string row]
        {
            get
            {
                return this.GetRow(row);
            }
        }


        //获得表头key在第几列从0开始
        public int GetColumnIndex(string key)
        {
            int index;
            if (!_cachedDicClo.TryGetValue(key, out index))
            {
                //Log.Debug("Table : " + _name + " no this key :" + key);
                index = -1;
            }
           
            return index;
        }

        public bool hasKey(string key){
            return _cachedDicClo.ContainsKey(key);
        }

        public string GetData(string id, string key)
        {
            if (string.IsNullOrEmpty(id) || string.IsNullOrEmpty(key)) return string.Empty;

            if (_cachedDicRow.TryGetValue(id, out int row))
            {
               return Rows[row].GetData(key);
            }
            return string.Empty;
        }


        /// <summary>
        /// 返回CSV二维数列的总行数。刨除表头
        /// </summary>
        /// <returns></returns>
        public int RowCount { get { return Rows.Count; } }

        /// <summary>
        /// 返回CSV二维数列的总列数。
        /// </summary>
        public int ColumnCount { get { return Rows != null && Rows.Count > 0 ? Rows[0].Count : 0; } }

        public List<Row> GetListRow(string csvData)
        {
            using (var ms = new MemoryStream(Encoding.UTF8.GetBytes(csvData)))
            {
                using (StreamReader reader = new StreamReader(ms, Encoding.UTF8))
                {
                    List<List<string>> tempListCsvData = new List<List<string>>();
                    List<Row> listCsvData = new List<Row>();

                    bool isNotEndLine = false;
                    int index = 0;
                    string tempCsvRowString = reader.ReadLine();

                    // 对每行进行读写
                    while (tempCsvRowString != null)
                    {
                        List<string> tempCsvRowList;
                        if (isNotEndLine)
                        {
                            tempCsvRowList = ParseContinueLine(tempCsvRowString);
                            isNotEndLine = (tempCsvRowList.Count > 0 && tempCsvRowList[tempCsvRowList.Count - 1].EndsWith("\r\n"));
                            List<string> myNowContinueList = tempListCsvData[tempListCsvData.Count - 1];
                            myNowContinueList[myNowContinueList.Count - 1] += tempCsvRowList[0];
                            tempCsvRowList.RemoveAt(0);
                            myNowContinueList.AddRange(tempCsvRowList);
                        }
                        else
                        {
                            tempCsvRowList = ParseLine(tempCsvRowString);
                            isNotEndLine = (tempCsvRowList.Count > 0 && tempCsvRowList[tempCsvRowList.Count - 1].EndsWith("\r\n"));
                            tempListCsvData.Add(tempCsvRowList);
                        }

                        if (!isNotEndLine)
                        {

                            if (index > 0)
                            {
                                //每一行的id，对应的index
                                List<string> tempList = tempListCsvData[tempListCsvData.Count - 1];
                                listCsvData.Add(new Row(this, tempList.ToArray()));
                                if (_cachedDicRow.ContainsKey(tempCsvRowList[_key]))
                                {
                                    Log.Error("Table: " + _name + " ID: " + tempCsvRowList[_key] + " ID Repetition");
                                    _cachedDicRow[tempCsvRowList[_key]] = index - 1;
                                }
                                else
                                {
                                    _cachedDicRow.Add(tempCsvRowList[_key], index -1);
                                }

                            }
                            else
                            {
                                //表头第一个字段必须是"id"
                                if (!string.Equals(tempCsvRowList[0], "id"))
                                {
                                    Log.Error("{} don't have id ", _name);
                                }
                                //第一行解析的时候，对应列的index,表头每个字段对应的列数量
                                for (int i = 0; i < tempCsvRowList.Count; i++)
                                {
                                    _cachedDicClo.Add(tempCsvRowList[i], i);
                                }
                            }

                            index++;
                        }

                        tempCsvRowString = reader.ReadLine();
                    }
                    reader.Close();
                    // 读取完成以后，可能不同的行有不同的数据个数，为了保证所有行的内容一样，添加以下内容：
                    // 找到最大列数。
                    int maxColumn = 0;
                    for (int i = 0; i < tempListCsvData.Count; i++)
                        maxColumn = tempListCsvData[i].Count > maxColumn ? tempListCsvData[i].Count : maxColumn;

                    // 使所有行的列数都是 maxColumn

                    foreach (Row item in listCsvData)
                        if (item.Count < maxColumn) Log.Error("Table :" + _name + " maxColumn > row.Count row : " + item.ToString());


                    //item.Add("");

                    return listCsvData;
                }
            }
        }


        /// <summary>
        /// 解析一行CSV数据。
        /// </summary>
        /// <param name="line">待分析的行。</param>
        /// <returns></returns>
        protected List<string> ParseLine(string line)
        {
            StringBuilder sb = new StringBuilder();
            List<string> Fields = new List<string>();
            bool inColumn = false;  //是否是在一个列元素里
            bool inQuotes = false;  //是否需要转义
            bool isNotEnd = false;  //读取完毕未结束转义
            sb.Remove(0, sb.Length);

            //空行也是一个空元素,一个逗号是2个空元素
            if (line == "")
                Fields.Add("");

            // 遍历一个行中的所有元素。
            for (int i = 0; i < line.Length; i++)
            {
                char c = line[i];
                if (!inColumn)
                {
                    inColumn = true;
                    if (c == '"')
                    {
                        inQuotes = true;
                        continue;
                    }
                }

                // 如果有引用 
                if (inQuotes)
                {
                    //这个字符已经结束了整行
                    if ((i + 1) == line.Length)
                    {
                        //正常转义结束，且该行已经结束
                        if (c == '"')
                        {
                            inQuotes = false;
                            continue;
                        }
                        isNotEnd = true;
                    }
                    //结束转义，且后面有可能还有数据
                    else if (c == '"' && line[i + 1] == CsvSeparator)
                    {
                        inQuotes = false;
                        inColumn = false;
                        i++;
                    }
                    //双引号转义
                    else if (c == '"' && line[i + 1] == '"')
                    {
                        i++;
                    }
                    //双引号单独出现（这种情况实际上已经是格式错误，为了兼容可暂时不处理）
                    else if (c == '"')
                    {
                        Log.Error(line);
                        throw new Exception("格式错误，错误的双引号转义");
                    }
                }
                else if (c == CsvSeparator)
                {
                    inColumn = false;
                }

                //结束该元素时inColumn置为false，并且不处理当前字符，直接进行Add
                if (!inColumn)
                {
                    Fields.Add(TrimColumns ? sb.ToString().Trim() : sb.ToString());
                    sb.Remove(0, sb.Length);
                }
                else
                {
                    sb.Append(c);
                }
            }

            // 标准格式一行结尾不需要逗号结尾，而上面for是遇到逗号才添加的，为了兼容最后还要添加一次
            if (inColumn)
            {
                if (isNotEnd)
                    sb.Append("\r\n");

                Fields.Add(TrimColumns ? sb.ToString().Trim() : sb.ToString());
            }
            //如果inColumn为false，说明已经添加，因为最后一个字符为分隔符，所以后面要加上一个空元素
            else
            {
                Fields.Add("");
            }

            return Fields;
        }

        /// <summary>
        /// 处理未完成的Csv单行
        /// </summary>
        /// <param name="line">数据源</param>
        /// <returns>元素列表</returns>
        protected List<string> ParseContinueLine(string line)
        {
            StringBuilder _columnBuilder = new StringBuilder();
            List<string> Fields = new List<string>();
            _columnBuilder.Remove(0, _columnBuilder.Length);
            if (line == "")
            {
                Fields.Add("\r\n");
                return Fields;
            }

            for (int i = 0; i < line.Length; i++)
            {
                char character = line[i];

                if ((i + 1) == line.Length)//这个字符已经结束了整行
                {
                    if (character == '"') //正常转义结束，且该行已经结束
                    {
                        Fields.Add(TrimColumns ? _columnBuilder.ToString().TrimEnd() : _columnBuilder.ToString());
                        return Fields;
                    }
                    else //异常结束，转义未收尾
                    {
                        _columnBuilder.Append("\r\n");
                        Fields.Add(_columnBuilder.ToString());
                        return Fields;
                    }
                }
                else if (character == '"' && line[i + 1] == CsvSeparator) //结束转义，且后面有可能还有数据
                {
                    Fields.Add(TrimColumns ? _columnBuilder.ToString().TrimEnd() : _columnBuilder.ToString());
                    i++; //跳过下一个字符
                    Fields.AddRange(ParseLine(line.Remove(0, i + 1)));
                    break;
                }
                else if (character == '"' && line[i + 1] == '"') //双引号转义
                {
                    i++; //跳过下一个字符
                }
                else if (character == '"') //双引号单独出现（这种情况实际上已经是格式错误，为了兼容暂时不处理）
                {
                    throw new Exception("格式错误，错误的双引号转义");
                }
                _columnBuilder.Append(character);
            }
            return Fields;
        }

        /// <summary>
        /// 以二维表的形式返回氖Data的内容，同一行的相邻数据使用\t\t分隔。
        /// </summary>
        /// <returns></returns>
        public override string ToString()
        {
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < Rows.Count; i++)
            {
                sb.AppendLine(string.Join("\t\t", Rows[i].ToString()));
            }
            return sb.ToString();
        }
    }
}