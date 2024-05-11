using System;
using System.Text;
using GameFramework.Localization;
using TMPro;
using UnityEngine.EventSystems;

public class TextMeshProUGUIEx : TextMeshProUGUI, IPointerClickHandler
{
    public Action<PointerEventData> onPointerClick;
    private string[] Holder= new string[5];
    private string[] FixedText= new string[30];
    StringBuilder _stringBuilder = new StringBuilder(50);
    private string TextHolder;
    private int startIndex;
    private int endIndex;
    private int length;
    public void OnPointerClick(PointerEventData eventData)
    {
        onPointerClick?.Invoke(eventData);
    }

    public override string text
    {
        get { return base.text; }
        set
        {
            if (IsRtl(value))
            { 
                value = FixText(value);
            }

            base.text = value;
        }
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
        var tempText = "";
        var finalTxt = "";
        string[] Holder= new string[5];
        var _lock = false;
        _stringBuilder.Clear();
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
            var info = GetTextInfo(finalTxt);
            for (int k = 0; k < FixedText.Length; k++)
            {
                FixedText[k] = "";
            }

            var showSplitLine = false;
            if (info.lineCount > 0 && info.lineCount < FixedText.Length)
            {
                for (int k = 0; k < info.lineCount; k++)
                {
                    startIndex = info.lineInfo[k].firstCharacterIndex;
                    endIndex =(k == info.lineCount-1)
                        ? finalTxt.Length
                        : info.lineInfo[k + 1].firstCharacterIndex;
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
                for (int k = 0; k < info.lineCount; k++)
                {
                    startIndex = info.lineInfo[k].firstCharacterIndex;
                    endIndex =(k == info.lineCount-1)
                        ? finalTxt.Length
                        : info.lineInfo[k + 1].firstCharacterIndex;
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
        
        return finalTxt;
    }
}