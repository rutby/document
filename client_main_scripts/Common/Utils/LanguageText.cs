using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityGameFramework.Runtime;

public class LanguageText : MonoBehaviour
{

    [SerializeField]
    private string key;
    

    private void Awake()
    {
        if (string.IsNullOrEmpty(key))
        {
            return;
        }
        GetComponent<Text>().text = GameEntry.Localization.GetString(key);

        // TODO 切换语言的时候发送事件，让所有关心的text脚本重新处理多语言文本显示 

    }
}
