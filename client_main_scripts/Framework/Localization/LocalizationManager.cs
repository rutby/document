using System;
using System.Collections.Generic;
using System.IO;
using GameFramework;
using GameFramework.Localization;
using UnityEngine;

public class LocalizationManager
{
    class DialogEntry
    {
        public string originDlg;
        public bool hasCRLF; // 是否有回车换行；初始都标记为true，扫描一次之后设置为false
    }

    class CacheEntry
    {
        public string cacheDlg;
        public object[] cacheParams;
    }

    private static readonly string[] ColumnSplit = new string[] { "=" };
    private const int ColumnCount = 2;

    private readonly Dictionary<string, DialogEntry> m_Dictionary = new Dictionary<string, DialogEntry>();
    private readonly Dictionary<string, CacheEntry> m_CacheDict = new Dictionary<string, CacheEntry>();
    private Language m_Language;

    public bool IsInitDone { get; private set; }

    // FIXME: 这个不应该放到这里；这个属于asset资源，应该有个专门的游戏资源管理器；那里包含一些常用字体资源，纹理资源等。
    public bool IsInitSuccess { get; private set; }
    private Font _font;
    private VEngine.Asset fontAsset;

    public LocalizationManager()
    {
    }

    public void Initialize(Language userLanguage)
    {
        if (userLanguage != Language.Unspecified)
        {
            m_Language = userLanguage;
        }
        else
        {
            m_Language = SystemLanguage;
        }
        
        InitFont();

    }

    public void Uninitialize()
    {
        if (fontAsset != null)
        {
            fontAsset.Release();
            fontAsset = null;
        }
    }

    public void LoadDictionary(string dictionaryName)
    {
        IsInitDone = false;
        IsInitSuccess = false;

        string languageName = IsSuported() ? Language.ToString() : "English";
        if (ApplicationLaunch.Instance.GetZipDataTable()._ConfigStatus == ConfigStatus.FinishUnzip)
        {
            string dictionaryAssetName =
                Application.persistentDataPath + string.Format("/ZipDocument/getnewlua/Localization/{0}/Dictionaries/{1}.txt",languageName, dictionaryName);
            Log.Info("LoadDictionary start {0}", dictionaryAssetName);
            if (File.Exists(dictionaryAssetName))
            {
                IsInitDone = true;
                IsInitSuccess = ParseTxtDictionary(File.ReadAllText(dictionaryAssetName));
            }
            else
            {
                dictionaryAssetName = Application.persistentDataPath + string.Format("/ZipDocument/getnewlua/Localization/English/Dictionaries/Dialog.txt");
                if (File.Exists(dictionaryAssetName))
                {
                    IsInitDone = true;
                    IsInitSuccess = ParseTxtDictionary(File.ReadAllText(dictionaryAssetName));
                }
                else
                {
                    IsInitDone = true;
                    IsInitSuccess = false;
                }
            }
        }
        else
        {
            string dictionaryAssetName = string.Format("Assets/Main/Localization/{0}/Dictionaries/{1}.txt",
                languageName, dictionaryName);
            Log.Info("LoadDictionary start {0}", dictionaryAssetName);
            var dialogAsset = GameEntry.Resource.LoadAssetAsync(dictionaryAssetName, typeof(TextAsset));
            if (dialogAsset != null)
            {
                dialogAsset.completed += (request) =>
                {
                    Log.Info("LoadDictionary completed {0}", dictionaryAssetName);
                    LoadDictionaryCallback(request.asset as TextAsset);
                    request.Release();
                };
            }
            else
            {
                dialogAsset = GameEntry.Resource.LoadAssetAsync(GameDefines.DefaultDialog, typeof(TextAsset));
                if (dialogAsset != null)
                {
                    dialogAsset.completed += (request) =>
                    {
                        Log.Info("LoadDictionary completed {0}", dictionaryAssetName);
                        LoadDictionaryCallback(request.asset as TextAsset);
                        request.Release();
                    };
                }
                else
                {
                    IsInitDone = true;
                    IsInitSuccess = false;
                }
            }
        }

    }

    void LoadDictionaryCallback(TextAsset asset)
    {
        IsInitDone = true;
        IsInitSuccess = ParseTxtDictionary(asset.text);
    }

    /// <summary>
    /// 解析字典。
    /// </summary>
    /// <param name="text">要解析的字典文本。</param>
    /// <returns>是否解析字典成功。</returns>

    bool ParseTxtDictionary(string text)
    {
        if (string.IsNullOrEmpty(text))
        {
            return false;
        }
        m_Dictionary.Clear();

        try
        {
            foreach (ReadOnlySpan<char> line in text.SplitLines())
            {
                if (line.Length <= 2 || line[0] == '#' || line[0] == '/')
                {
                    continue;
                }

                ReadOnlySpan<char> keySpan;
                ReadOnlySpan<char> valueSpan;
                if (line.Split_to_spanspan('=', out keySpan, out valueSpan) == false)
                {
                    continue;
                }

                keySpan = keySpan.Trim();
                valueSpan = valueSpan.Trim();

                if (keySpan.IsEmpty || valueSpan.IsEmpty)
                {
                    continue;
                }

                string key = keySpan.ToString();
                string value = valueSpan.ToString();

#if UNITY_EDITOR
                if (HasRawString(key))
                {
                    Log.Error("Can not add raw string with key '{0}' which may be invalid or duplicate.", key);
                }
#endif

                AddRawString(key, value);
            }


            // 这个地方是用来检测上面代码是否正确的
#if false //UNITY_EDITOR

            Dictionary<string, string> checkDict = new Dictionary<string, string>();
            string[] rowTexts = SplitToLines(asset.text);
            for (int i = 0; i < rowTexts.Length; i++)
            {
                if (rowTexts[i].Length <= 0 || rowTexts[i][0] == '#')
                {
                    continue;
                }

                string[] splitLine = rowTexts[i].Split(ColumnSplit, 2, StringSplitOptions.None);
                if (splitLine.Length != ColumnCount)
                {
                    Log.Error("Can not parse dictionary '{0}'.", rowTexts[i]);
                    //return false;
                    continue;
                }

                string key = splitLine[0];
                string value = splitLine[1];
                if (string.IsNullOrEmpty(key))
                {
                    //Log.Warning("Invalid Key at line:" + i);
                    continue;
                }
                // if (!AddRawString(key, value))
                // {
                //     Log.Error("Can not add raw string with key '{0}' which may be invalid or duplicate.", key);
                //     //return false;
                //     continue;
                // }
                
                checkDict.Add(key, value ?? string.Empty);
            }
            
            if (m_Dictionary.Count != checkDict.Count)
            {
                Log.Error("ParseDictionary count not same (%d/%d)", m_Dictionary.Count, checkDict.Count);
            }
#endif
            return true;
        }
        catch (Exception exception)
        {
            Debug.LogWarningFormat("Can not parse dictionary '{0}' with exception '{1}'.", text,
                string.Format("{0}\n{1}", exception.Message, exception.StackTrace));
            return false;
        }
    }

    /// <summary>
    /// 支持语言列表。
    /// </summary>
    private List<Language> SuportedLanguages = new List<Language>(){
            Language.English,
            // Language.French,
            // Language.German,
            // Language.Russian,
            // Language.Korean,
            // Language.Thai,
            // Language.Japanese,
            // Language.PortuguesePortugal,
            // Language.Spanish,
            // Language.Turkish,
            // Language.Indonesian,
            // Language.ChineseTraditional,
            Language.ChineseSimplified,
            // Language.Italian,
            // Language.Polish,
            // Language.Dutch,
            // Language.Arabic,
        };

    /// <summary>
    /// 获取或设置本地化语言。
    /// </summary>
    public Language Language
    {
        get
        {
            return m_Language;
        }
        set
        {
            if (value == Language.Unspecified)
            {
                Log.Error("Language is invalid.");
            }

            m_Language = value;
            //InitFont();
        }
    }

    /// <summary>
    /// 获取系统语言。
    /// </summary>
    public static Language SystemLanguage
    {
        get
        {
            switch (Application.systemLanguage)
            {
                case UnityEngine.SystemLanguage.Afrikaans: return Language.Afrikaans;
                case UnityEngine.SystemLanguage.Arabic: return Language.Arabic;
                case UnityEngine.SystemLanguage.Basque: return Language.Basque;
                case UnityEngine.SystemLanguage.Belarusian: return Language.Belarusian;
                case UnityEngine.SystemLanguage.Bulgarian: return Language.Bulgarian;
                case UnityEngine.SystemLanguage.Catalan: return Language.Catalan;
                case UnityEngine.SystemLanguage.Chinese: return Language.ChineseSimplified;
                case UnityEngine.SystemLanguage.ChineseSimplified: return Language.ChineseSimplified;
                case UnityEngine.SystemLanguage.ChineseTraditional: return Language.ChineseTraditional;
                case UnityEngine.SystemLanguage.Czech: return Language.Czech;
                case UnityEngine.SystemLanguage.Danish: return Language.Danish;
                case UnityEngine.SystemLanguage.Dutch: return Language.Dutch;
                case UnityEngine.SystemLanguage.English: return Language.English;
                case UnityEngine.SystemLanguage.Estonian: return Language.Estonian;
                case UnityEngine.SystemLanguage.Faroese: return Language.Faroese;
                case UnityEngine.SystemLanguage.Finnish: return Language.Finnish;
                case UnityEngine.SystemLanguage.French: return Language.French;
                case UnityEngine.SystemLanguage.German: return Language.German;
                case UnityEngine.SystemLanguage.Greek: return Language.Greek;
                case UnityEngine.SystemLanguage.Hebrew: return Language.Hebrew;
                case UnityEngine.SystemLanguage.Hungarian: return Language.Hungarian;
                case UnityEngine.SystemLanguage.Icelandic: return Language.Icelandic;
                case UnityEngine.SystemLanguage.Indonesian: return Language.Indonesian;
                case UnityEngine.SystemLanguage.Italian: return Language.Italian;
                case UnityEngine.SystemLanguage.Japanese: return Language.Japanese;
                case UnityEngine.SystemLanguage.Korean: return Language.Korean;
                case UnityEngine.SystemLanguage.Latvian: return Language.Latvian;
                case UnityEngine.SystemLanguage.Lithuanian: return Language.Lithuanian;
                case UnityEngine.SystemLanguage.Norwegian: return Language.Norwegian;
                case UnityEngine.SystemLanguage.Polish: return Language.Polish;
                case UnityEngine.SystemLanguage.Portuguese: return Language.PortuguesePortugal;
                case UnityEngine.SystemLanguage.Romanian: return Language.Romanian;
                case UnityEngine.SystemLanguage.Russian: return Language.Russian;
                case UnityEngine.SystemLanguage.SerboCroatian: return Language.SerboCroatian;
                case UnityEngine.SystemLanguage.Slovak: return Language.Slovak;
                case UnityEngine.SystemLanguage.Slovenian: return Language.Slovenian;
                case UnityEngine.SystemLanguage.Spanish: return Language.Spanish;
                case UnityEngine.SystemLanguage.Swedish: return Language.Swedish;
                case UnityEngine.SystemLanguage.Thai: return Language.Thai;
                case UnityEngine.SystemLanguage.Turkish: return Language.Turkish;
                case UnityEngine.SystemLanguage.Ukrainian: return Language.Ukrainian;
                case UnityEngine.SystemLanguage.Unknown: return Language.Unspecified;
                case UnityEngine.SystemLanguage.Vietnamese: return Language.Vietnamese;
                default: return Language.Unspecified;
            }
        }
    }

    /// <summary>
    /// 获取字典数量。
    /// </summary>
    public int DictionaryCount
    {
        get
        {
            return m_Dictionary.Count;
        }
    }

    /// <summary>
    /// 当前语言是否支持
    /// </summary>
    /// <returns>是否支持。</returns>
    public bool IsSuported()
    {
        return SuportedLanguages.Contains(Language);
    }

    public void SetSuportedLanguages(List<int> langList)
    {
        SuportedLanguages.Clear();
        foreach (var i in langList)
        {
            SuportedLanguages.Add((Language)i);
        }
    }

    /// <summary>
    /// 根据字典主键获取字典内容字符串。
    /// </summary>
    /// <param name="key">字典主键。</param>
    /// <param name="args">字典参数。</param>
    /// <returns>要获取的字典内容字符串。</returns>
    public string GetString(string key, params object[] args)
    {
        if (string.IsNullOrEmpty(key))
        {
            Log.Error("Key is invalid.");
#if DEBUG
            return "Key is invalid";
#endif
            return string.Empty;
        }

        DialogEntry entry;
        if (!m_Dictionary.TryGetValue(key, out entry))
        {
#if DEBUG
            return string.Format("<NoKey>{0}", key);
#endif
            Log.Error(string.Format("<NoKey>{0}", key));
            return string.Empty;
        }

        // 每个词条缓式处理一遍
        if (entry.hasCRLF)
        {
            if (entry.originDlg.Contains("\\n"))
            {
                entry.originDlg = entry.originDlg.Replace("\\n", "\n");
            }

            entry.hasCRLF = false;
        }

        try
        {
            if (args != null && args.Length > 0)
            {
                string ret = string.Format(entry.originDlg, args);

                // CacheEntry cache;
                // if (m_CacheDict.TryGetValue(key, out cache))
                // {
                //     if (m_CacheDict.Count == args.Length)
                //     {
                //         
                //     }
                // }
                return ret;
            }
        }
        catch (Exception exception)
        {
#if UNITY_EDITOR
            Log.Error("string format error - {0}!", key);
#endif
        }

        return entry.originDlg;
    }

    /// <summary>
    /// 是否存在字典。
    /// </summary>
    /// <param name="key">字典主键。</param>
    /// <returns>是否存在字典。</returns>
    private bool HasRawString(string key)
    {
        if (string.IsNullOrEmpty(key))
        {
            throw new Exception("Key is invalid.");
        }

        return m_Dictionary.ContainsKey(key);
    }

    /// <summary>
    /// 根据字典主键获取字典值。
    /// </summary>
    /// <param name="key">字典主键。</param>
    /// <returns>字典值。</returns>
    private string GetRawString(string key)
    {
//         if (string.IsNullOrEmpty(key))
//         {
//             throw new Exception("Key is invalid.");
//         }
//
//         string value = null;
//         if (m_Dictionary.TryGetValue(key, out value))
//         {
//             return value;
//         }
//
// #if DEBUG
//         return string.Format("<NoKey>{0}", key);
// #endif
//         Log.Error(string.Format("<NoKey>{0}", key));
        return string.Empty;
    }

    /// <summary>
    /// 增加字典。
    /// </summary>
    /// <param name="key">字典主键。</param>
    /// <param name="value">字典内容。</param>
    /// <returns>是否增加字典成功。</returns>
    private bool AddRawString(string key, string value)
    {
        // if (HasRawString(key))
        // {
        //     return false;
        // }
        //
        
        DialogEntry entry = new DialogEntry();
        entry.originDlg = value;
        entry.hasCRLF = true;
        m_Dictionary[key] = entry;

        // m_Dictionary.Add(key, value ?? string.Empty);
        return true;
    }

    /// <summary>
    /// 移除字典。
    /// </summary>
    /// <param name="key">字典主键。</param>
    /// <returns>是否移除字典成功。</returns>
    private bool RemoveRawString(string key)
    {
        if (!HasRawString(key))
        {
            return false;
        }

        return m_Dictionary.Remove(key);
    }

    //获取语言名称
    public string GetLanguageName()
    {
        switch (Language)
        {
            case Language.ChineseSimplified:
                return "zh_CN";
            case Language.ChineseTraditional:
                return "zh_TW";
            case Language.English:
                return "en";
            case Language.PortuguesePortugal:
                return "pt";
            case Language.Turkish:
                return "tr";
            case Language.French:
                return "fr";
            case Language.Norwegian:
                return "no";
            case Language.Korean:
                return "ko";
            case Language.Japanese:
                return "ja";
            case Language.Dutch:
                return "nl";
            case Language.Italian:
                return "it";
            case Language.German:
                return "de";
            case Language.Spanish:
                return "es";
            case Language.Russian:
                return "ru";
            case Language.Arabic:
                return "ar";
            case Language.Persian:
                return "pr";
            case Language.Thai:
                return "th";
            // case Language.Vietnamese:
            //     return "xh";
            // case Language.Polish:
            //     return "pl";
            case Language.Unspecified:
            default:
                return "en";
        }
    }
    
    /// 将文本按行切分。
    /// </summary>
    /// <param name="text">要切分的文本。</param>
    /// <returns>按行切分后的文本。</returns>
    private static string[] SplitToLines(string text)
    {
        List<string> texts = new List<string>();
        int position = 0;
        string rowText = null;
        while ((rowText = ReadLine(text, ref position)) != null)
        {
            texts.Add(rowText);
        }

        return texts.ToArray();
    }


    /// <summary>
    /// 读取一行文本。
    /// </summary>
    /// <param name="text">要读取的文本。</param>
    /// <param name="position">开始的位置。</param>
    /// <returns>一行文本。</returns>
    private static string ReadLine(string text, ref int position)
    {
        if (text == null)
        {
            return null;
        }

        int length = text.Length;
        int offset = position;
        while (offset < length)
        {
            char ch = text[offset];
            switch (ch)
            {
                case '\r':
                case '\n':
                    string str = text.Substring(position, offset - position);
                    position = offset + 1;
                    if (((ch == '\r') && (position < length)) && (text[position] == '\n'))
                    {
                        position++;
                    }

                    return str;
                default:
                    offset++;
                    break;
            }
        }

        if (offset > position)
        {
            string str = text.Substring(position, offset - position);
            position = offset;
            return str;
        }

        return null;
    }

    public int GetLanguage()
    {
        return (int) Language;
    }
    
    public void SetLanguage(int language)
    {
        Language = (Language)language;
        GameEntry.Setting.UserLanguage = Language;
    }

    //通过当前使用语言来获取对应字体
    public Font GetFontByLanguage()
    {
        if (Language == Language.Japanese)
        {
            return _font;
        } 
        return null; 
    }

    private void InitFont()
    {
        // return;
        _font = null;
        string path = "";
        switch (Language)
        {
            case Language.Japanese:
            {
                path = GameDefines.FontPath.Japanese;
                break;
            }
            default:
                path = "";
                break;
        }
        
        if (fontAsset != null)
        {
            fontAsset.Release();
            fontAsset = null;
        }

        if (path.IsNullOrEmpty() == false)
        {
            fontAsset = GameEntry.Resource.LoadAssetAsync(path, typeof(Font));
            fontAsset.completed += (request) =>
            {
                _font = request.asset as Font;
            };
        }
        
    }
}
