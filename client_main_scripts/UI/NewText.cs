using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using GameFramework.Localization;
using UnityEngine;
using UnityEngine.Profiling;
using UnityEngine.UI;
public class NewText : Text
{

    [SerializeField] private bool _useTextWithEllipsis= true;
    [SerializeField] private bool _useTextBestFit= false;
    [SerializeField] private bool _useNoLineSpace= false;
    private const string no_breaking_space = "\u00A0";
    private string[] FixedText= new string[30];
    private string[] Holder= new string[5];
    private string TextHolder;
    private int startIndex;
    private int endIndex;
    private int length;
    public override string text
    {
        get
        {
            // Populate base text in rect transform and calculate number of lines.
            string baseText = m_Text;
            {
                return baseText;
            }
        }
        set
        {
            if (String.IsNullOrEmpty(value))
            {
                if (String.IsNullOrEmpty(m_Text))
                    return;
                m_Text = "";
                SetVerticesDirty();
            }
            else
            {
                if (_useNoLineSpace)
                {
                    if (value.Contains(" "))
                    {
                        value = value.Replace(" ", no_breaking_space);
                    }
                }
                if (_useTextWithEllipsis)
                {
                    value = GetTextWithEllipsis(value);
                }
// #if UNITY_ANDROID || UNITY_EDITOR
                if (IsRtl(value))
                {
                    value = FixText(value);
                }
// #endif

                if (m_Text != value)
                {
                    var tempFont =  GameEntry.Localization.GetFontByLanguage();
                    if (tempFont != null)
                    {
                        font = tempFont;
                    }
                    m_Text = value;
                    SetVerticesDirty();
                    SetLayoutDirty();
                }
            }
        }
    }
    
    static TextGenerator _generator = new TextGenerator();
    
    StringBuilder _stringBuilder = new StringBuilder(50);
    private bool _lock = false;
    private string _compareValue = "";
    private bool _needNewString = false;
    
    private string GetTextWithEllipsis(string value)
    {
        _stringBuilder.Clear();
        _needNewString = false;
        _compareValue = "";
        for (int i = 0; i < value.Length; ++i)
        {
            if (value[i] == '<')
            {
                _lock = true;
                _needNewString = true;
                continue;
            }
            if (value[i] == '>')
            {
                _lock = false;
                continue;
            }

            if (!_lock)
                _stringBuilder.Append(value[i]);
        }

        if (_needNewString)
        {
            _compareValue = _stringBuilder.ToString();
        }
        else
        {
            _compareValue = value;
        }

        var settings = GetGenerationSettings(rectTransform.rect.size);
        _generator.Populate(_compareValue, settings);
        var characterCountVisible = _generator.characterCountVisible;
        var updatedText = value;
        if (characterCountVisible>0 && _compareValue.Length > characterCountVisible)
        {
            _lock = false;
            _stringBuilder.Clear();
            int valueLength = value.Length;
            int visibleCharactorIndex = 0;
            int needRichTextNum = 0;
            for (int i = 0; i < valueLength; ++i)
            {
                if (value[i] == '<')
                {
                    _lock = true;
                    if (i < valueLength-1 && value[i + 1] == '/')
                    {
                        --needRichTextNum;
                    }
                    else
                    {
                        ++needRichTextNum;
                    }
                }
                else if (value[i] == '>')
                {
                    _lock = false;
                    if (needRichTextNum <= 0 && visibleCharactorIndex > characterCountVisible)
                    {
                        _stringBuilder.Append(value[i]);
                        break;
                    }
                }

                if (!_lock)
                {
                    ++visibleCharactorIndex;
                    if (visibleCharactorIndex > characterCountVisible)
                    {
                        if (needRichTextNum <= 0)
                        {
                            break;
                        }
                    }
                    else
                    {
                        _stringBuilder.Append(value[i]);
                        if (visibleCharactorIndex == characterCountVisible)
                        {
                            _stringBuilder.Append("...");
                        }
                    }
                }
                else
                {
                    _stringBuilder.Append(value[i]);
                }
            }
            updatedText = _stringBuilder.ToString();
        }
        return updatedText;
    }
    
        /// <summary>
    /// 当前可见的文字行数
    /// </summary>
    public int VisibleLines { get; private set; }
        
    private readonly UIVertex[] _tmpVerts = new UIVertex[4];

    private void _UseFitSettings()
    {
        TextGenerationSettings settings = GetGenerationSettings(rectTransform.rect.size);
        settings.resizeTextForBestFit = false;

        if (!resizeTextForBestFit)
        {
            cachedTextGenerator.PopulateWithErrors(text, settings, gameObject);
            return;
        }

        int minSize = resizeTextMinSize;
        int txtLen = text.Length;
        for (int i = resizeTextMaxSize; i >= minSize; --i)
        {
            settings.fontSize = i;
            cachedTextGenerator.PopulateWithErrors(text, settings, gameObject);
            if (cachedTextGenerator.characterCountVisible == txtLen)
            {
                break;
            }
        }
    }

    protected override void OnPopulateMesh(VertexHelper toFill)
    {
        if (null == font) return;

        m_DisableFontTextureRebuiltCallback = true;
        if (_useTextBestFit == false)
        {
            
            base.OnPopulateMesh(toFill);
            return;
        }
        _UseFitSettings();

        // Apply the offset to the vertices
        IList<UIVertex> verts = cachedTextGenerator.verts;
        float unitsPerPixel = 1 / pixelsPerUnit;
        int vertCount = verts.Count;

        // We have no verts to process just return (case 1037923)
        if (vertCount <= 0)
        {
            toFill.Clear();
            return;
        }

        Vector2 roundingOffset = new Vector2(verts[0].position.x, verts[0].position.y) * unitsPerPixel;
        roundingOffset = PixelAdjustPoint(roundingOffset) - roundingOffset;
        toFill.Clear();
        if (roundingOffset != Vector2.zero)
        {
            for (int i = 0; i < vertCount; ++i)
            {
                int tempVertsIndex = i & 3;
                _tmpVerts[tempVertsIndex] = verts[i];
                _tmpVerts[tempVertsIndex].position *= unitsPerPixel;
                _tmpVerts[tempVertsIndex].position.x += roundingOffset.x;
                _tmpVerts[tempVertsIndex].position.y += roundingOffset.y;
                if (tempVertsIndex == 3)
                    toFill.AddUIVertexQuad(_tmpVerts);
            }
        }
        else
        {
            for (int i = 0; i < vertCount; ++i)
            {
                int tempVertsIndex = i & 3;
                _tmpVerts[tempVertsIndex] = verts[i];
                _tmpVerts[tempVertsIndex].position *= unitsPerPixel;
                if (tempVertsIndex == 3)
                    toFill.AddUIVertexQuad(_tmpVerts);
            }
        }

        m_DisableFontTextureRebuiltCallback = false;
        VisibleLines = cachedTextGenerator.lineCount;
    }

    private bool IsRtl(string str)
    {
        var isRtl = false;
        if (GameEntry.Localization.Language == Language.Arabic)
        {
            foreach (var _char in str)
            {
                if ((_char >= 1536 && _char <= 1791) || (_char >= 65136 && _char <= 65279))
                {
                    isRtl = true;
                    break;
                }
            }
        }
        return isRtl;
    }

    private string FixText(string value)
    {
        m_DisableFontTextureRebuiltCallback = true;
        var tempText = "";
        var finalTxt = "";
        _lock = false;
        _stringBuilder.Clear();
        _compareValue = "";
        for (int i = 0; i < value.Length; ++i)
        {
            if (value[i] == '<')
            {
                _lock = true;
                continue;
            }
            if (value[i] == '>')
            {
                _lock = false;
                continue;
            }

            if (!_lock)
                _stringBuilder.Append(value[i]);
        }
        tempText = _stringBuilder.ToString();
        Holder = tempText.Split('\n');
        
        for (int i = 0; i < Holder.Length; i++)
        {
            int templinesCount = 0;
            finalTxt = ArabicSupport.ArabicFixer.Fix(Holder[i], true, false);
            cachedTextGenerator.PopulateWithErrors(finalTxt, GetGenerationSettings(rectTransform.rect.size), gameObject);
            for (int k = 0; k < FixedText.Length; k++)
            {
                FixedText[k] = "";
            }

            var showSplitLine = false;
            if (cachedTextGenerator.lines.Count > 0 && cachedTextGenerator.lines.Count < FixedText.Length)
            {
                for (int k = 0; k < cachedTextGenerator.lines.Count; k++)
                {
                    startIndex = cachedTextGenerator.lines[k].startCharIdx;
                    endIndex =(k == cachedTextGenerator.lines.Count - 1)
                        ? finalTxt.Length
                        : cachedTextGenerator.lines[k + 1].startCharIdx;
                    length = endIndex - startIndex;
                    if (length >2 )
                    {
                        showSplitLine = true;
                        break;
                    }
                }
            }

            if (showSplitLine)
            {
                for (int k = 0; k < cachedTextGenerator.lines.Count; k++)
                {
                    startIndex = cachedTextGenerator.lines[k].startCharIdx;
                    endIndex = (k == cachedTextGenerator.lines.Count - 1)
                        ? finalTxt.Length
                        : cachedTextGenerator.lines[k + 1].startCharIdx;
                    length = endIndex - startIndex;
                    FixedText[k] = finalTxt.Substring(startIndex, length);
                    templinesCount = k;
                }
                finalTxt = "";
                //如果是最后一个字段的最后一行的话不用换行。
                if (i == Holder.Length - 1)
                {
                    for (int k = FixedText.Length - 1; k >= 0; k--)
                    {
                        if (FixedText[k] != "" && FixedText[k] != "\n" && FixedText[k] != null)
                        {
                            if (templinesCount == 0)
                            {
                                TextHolder += FixedText[k];
                            }
                            else
                            {
                                if (templinesCount != 0)
                                {
                                    TextHolder += FixedText[k] + "\n";
                                    templinesCount--;
                                }
                                else
                                {
                                    TextHolder += FixedText[k];
                                }
                            }
                        }
                    }
                }
                else
                {
                    for (int k = FixedText.Length - 1; k >= 0; k--)
                    {
                        if (FixedText[k] != "" && FixedText[k] != "\n" && FixedText[k] != null)
                        {
                            TextHolder += FixedText[k] + "\n";
                        }
                    }
                }
            }
            else
            {
                TextHolder += finalTxt;
            }
           
        }
        finalTxt = TextHolder;
        TextHolder = "";
        m_DisableFontTextureRebuiltCallback = false;
        return finalTxt;
    }
}