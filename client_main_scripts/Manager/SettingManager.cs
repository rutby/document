using System;
using System.Collections;
using System.Collections.Generic;
using GameFramework.Localization;
using UnityEngine;

public class SettingManager
{
    public Language UserLanguage
    {
        get
        {
            return (Language)GetInt(GameDefines.SettingKeys.USER_LANGUAGE, (int)LocalizationManager.SystemLanguage);
        }
        set
        {
            SetInt(GameDefines.SettingKeys.USER_LANGUAGE, (int)value);
        }
    }

    /// <summary>
    /// 加载配置。
    /// </summary>
    /// <returns>是否加载配置成功。</returns>
    public bool Load()
    {
        return true;
    }

    /// <summary>
    /// 保存配置。
    /// </summary>
    /// <returns>是否保存配置成功。</returns>
    public bool Save()
    {
        PlayerPrefs.Save();
        return true;
    }

    /// <summary>
    /// 检查是否存在指定配置项。
    /// </summary>
    /// <param name="settingName">要检查配置项的名称。</param>
    /// <returns>指定的配置项是否存在。</returns>
    public bool HasSetting(string settingName)
    {
        return PlayerPrefs.HasKey(settingName);
    }

    /// <summary>
    /// 移除指定配置项。
    /// </summary>
    /// <param name="settingName">要移除配置项的名称。</param>
    public void RemoveSetting(string settingName)
    {
        PlayerPrefs.DeleteKey(settingName);
    }

    /// <summary>
    /// 清空所有配置项。
    /// </summary>
    public void RemoveAllSettings()
    {
        PlayerPrefs.DeleteAll();
    }

    /// <summary>
    /// 从指定配置项中读取布尔值。
    /// </summary>
    /// <param name="settingName">要获取配置项的名称。</param>
    /// <returns>读取的布尔值。</returns>
    public bool GetBool(string settingName)
    {
        return PlayerPrefs.GetInt(settingName) != 0;
    }

    /// <summary>
    /// 从指定配置项中读取布尔值。
    /// </summary>
    /// <param name="settingName">要获取配置项的名称。</param>
    /// <param name="defaultValue">当指定的配置项不存在时，返回此默认值。</param>
    /// <returns>读取的布尔值。</returns>
    public bool GetBool(string settingName, bool defaultValue)
    {
        return PlayerPrefs.GetInt(settingName, defaultValue ? 1 : 0) != 0;
    }

    /// <summary>
    /// 向指定配置项写入布尔值。
    /// </summary>
    /// <param name="settingName">要写入配置项的名称。</param>
    /// <param name="value">要写入的布尔值。</param>
    public void SetBool(string settingName, bool value)
    {
        PlayerPrefs.SetInt(settingName, value ? 1 : 0);
    }

    /// <summary>
    /// 从指定配置项中读取整数值。
    /// </summary>
    /// <param name="settingName">要获取配置项的名称。</param>
    /// <returns>读取的整数值。</returns>
    public int GetInt(string settingName)
    {
        return PlayerPrefs.GetInt(settingName);
    }

    /// <summary>
    /// 从指定配置项中读取整数值。
    /// </summary>
    /// <param name="settingName">要获取配置项的名称。</param>
    /// <param name="defaultValue">当指定的配置项不存在时，返回此默认值。</param>
    /// <returns>读取的整数值。</returns>
    public int GetInt(string settingName, int defaultValue)
    {
        return PlayerPrefs.GetInt(settingName, defaultValue);
    }

    /// <summary>
    /// 向指定配置项写入整数值。
    /// </summary>
    /// <param name="settingName">要写入配置项的名称。</param>
    /// <param name="value">要写入的整数值。</param>
    public void SetInt(string settingName, int value)
    {
        PlayerPrefs.SetInt(settingName, value);
    }

    /// <summary>
    /// 从指定配置项中读取浮点数值。
    /// </summary>
    /// <param name="settingName">要获取配置项的名称。</param>
    /// <returns>读取的浮点数值。</returns>
    public float GetFloat(string settingName)
    {
        return PlayerPrefs.GetFloat(settingName);
    }

    /// <summary>
    /// 从指定配置项中读取浮点数值。
    /// </summary>
    /// <param name="settingName">要获取配置项的名称。</param>
    /// <param name="defaultValue">当指定的配置项不存在时，返回此默认值。</param>
    /// <returns>读取的浮点数值。</returns>
    public float GetFloat(string settingName, float defaultValue)
    {
        return PlayerPrefs.GetFloat(settingName, defaultValue);
    }

    /// <summary>
    /// 向指定配置项写入浮点数值。
    /// </summary>
    /// <param name="settingName">要写入配置项的名称。</param>
    /// <param name="value">要写入的浮点数值。</param>
    public void SetFloat(string settingName, float value)
    {
        PlayerPrefs.SetFloat(settingName, value);
    }

    /// <summary>
    /// 从指定配置项中读取字符串值。
    /// </summary>
    /// <param name="settingName">要获取配置项的名称。</param>
    /// <returns>读取的字符串值。</returns>
    public string GetString(string settingName)
    {
        return PlayerPrefs.GetString(settingName);
    }

    /// <summary>
    /// 从指定配置项中读取字符串值。
    /// </summary>
    /// <param name="settingName">要获取配置项的名称。</param>
    /// <param name="defaultValue">当指定的配置项不存在时，返回此默认值。</param>
    /// <returns>读取的字符串值。</returns>
    public string GetString(string settingName, string defaultValue)
    {
        return PlayerPrefs.GetString(settingName, defaultValue);
    }

    /// <summary>
    /// 向指定配置项写入字符串值。
    /// </summary>
    /// <param name="settingName">要写入配置项的名称。</param>
    /// <param name="value">要写入的字符串值。</param>
    public void SetString(string settingName, string value)
    {
        PlayerPrefs.SetString(settingName, value);
    }
    
    
    
    
    
    
    
    ///////////////////////////////////////////////////////////////////////
    private string _gameUid = "";
    //public new const string NAME = "SettingProxy";
    public string GameUid
    {
        get { return _gameUid; }
        set
        { 
            if (value.IsNullOrEmpty()) 
            {
                GameFramework.Log.Error("settingproxy uid is null");
            }
            else 
            {
                this._gameUid = value;
            }
        }
    }
    
    /// <summary>
    /// 从指定配置项中读取布尔值。
    /// </summary>
    /// <param name="settingName">要获取配置项的名称。</param>
    /// <returns>读取的布尔值。</returns>
    public bool GetPublicBool(string settingName)
    {
        return PlayerPrefs.GetInt(settingName) != 0;
    }

    /// <summary>
    /// 从指定配置项中读取布尔值。
    /// </summary>
    /// <param name="settingName">要获取配置项的名称。</param>
    /// <param name="defaultValue">当指定的配置项不存在时，返回此默认值。</param>
    /// <returns>读取的布尔值。</returns>
    public bool GetPublicBool(string settingName, bool defaultValue)
    {
        return PlayerPrefs.GetInt(settingName, defaultValue ? 1 : 0) != 0;
    }

    public bool GetPrivateBool(string settingName)
    {
        return GetPublicBool(settingName+GameUid);
    }

    public bool GetPrivateBool(string settingName, bool defaultValue)
    {
        return GetPublicBool(settingName+GameUid, defaultValue);
    }

    /// <summary>
    /// 向指定配置项写入布尔值。
    /// </summary>
    /// <param name="settingName">要写入配置项的名称。</param>
    /// <param name="value">要写入的布尔值。</param>
    public void SetPublicBool(string settingName, bool value)
    {
        PlayerPrefs.SetInt(settingName, value ? 1 : 0);
    }

    public void SetPrivateBool(string settingName, bool value)
    { 
        if (GameUid.IsNullOrEmpty())
        {
            GameFramework.Log.Info("<color=#ff0000> SetPrivateBool error, settingName: {0}", settingName);
        }
        SetPublicBool(settingName+GameUid, value);
    }

    /// <summary>
    /// 从指定配置项中读取整数值。
    /// </summary>
    /// <param name="settingName">要获取配置项的名称。</param>
    /// <returns>读取的整数值。</returns>
    public int GetPublicInt(string settingName)
    {
        return PlayerPrefs.GetInt(settingName);
    }

    /// <summary>
    /// 从指定配置项中读取整数值。
    /// </summary>
    /// <param name="settingName">要获取配置项的名称。</param>
    /// <param name="defaultValue">当指定的配置项不存在时，返回此默认值。</param>
    /// <returns>读取的整数值。</returns>
    public int GetPublicInt(string settingName, int defaultValue)
    {
        return PlayerPrefs.GetInt(settingName, defaultValue);
    }

    /// <summary>
    /// 向指定配置项写入整数值。
    /// </summary>
    /// <param name="settingName">要写入配置项的名称。</param>
    /// <param name="value">要写入的整数值。</param>
    public void SetPublicInt(string settingName, int value)
    {
        PlayerPrefs.SetInt(settingName, value);
    }

    public void SetPrivateInt(string settingName, int value)
    {
        SetPublicInt(settingName+GameUid, value);
    }

    public int GetPrivateInt(string settingName, int value)
    {
        return GetPublicInt(settingName+GameUid, value);
    }

    public void SetPrivateFloat(string settingName, float value)
    {
        SetPublicFloat(settingName+GameUid, value);
    }

    public float GetPrivateFloat(string settingName, float value)
    {
        return GetPublicFloat(settingName+GameUid, value);
    }
    
    /// <summary>
    /// 从指定配置项中读取浮点数值。
    /// </summary>
    /// <param name="settingName">要获取配置项的名称。</param>
    /// <returns>读取的浮点数值。</returns>
    public float GetPublicFloat(string settingName)
    {
        return PlayerPrefs.GetFloat(settingName);
    }

    /// <summary>
    /// 从指定配置项中读取浮点数值。
    /// </summary>
    /// <param name="settingName">要获取配置项的名称。</param>
    /// <param name="defaultValue">当指定的配置项不存在时，返回此默认值。</param>
    /// <returns>读取的浮点数值。</returns>
    public float GetPublicFloat(string settingName, float defaultValue)
    {
        return PlayerPrefs.GetFloat(settingName, defaultValue);
    }

    /// <summary>
    /// 向指定配置项写入浮点数值。
    /// </summary>
    /// <param name="settingName">要写入配置项的名称。</param>
    /// <param name="value">要写入的浮点数值。</param>
    public void SetPublicFloat(string settingName, float value)
    {
        PlayerPrefs.SetFloat(settingName, value);
    }

    /// <summary>
    /// 从指定配置项中读取字符串值。
    /// </summary>
    /// <param name="settingName">要获取配置项的名称。</param>
    /// <returns>读取的字符串值。</returns>
    public string GetPublicString(string settingName)
    {
        return PlayerPrefs.GetString(settingName);
    }

    /// <summary>
    /// 从指定配置项中读取字符串值。
    /// </summary>
    /// <param name="settingName">要获取配置项的名称。</param>
    /// <param name="defaultValue">当指定的配置项不存在时，返回此默认值。</param>
    /// <returns>读取的字符串值。</returns>
    public string GetPublicString(string settingName, string defaultValue)
    {
        return PlayerPrefs.GetString(settingName, defaultValue);
    }

    public string GetPrivateString(string settingName, string defaultValue)
    {
        return GetPublicString(settingName+GameUid, defaultValue);
    }

    /// <summary>
    /// 向指定配置项写入字符串值。
    /// </summary>
    /// <param name="settingName">要写入配置项的名称。</param>
    /// <param name="value">要写入的字符串值。</param>
    public void SetPublicString(string settingName, string value)
    {
        PlayerPrefs.SetString(settingName, value);
    }

    public void SetPrivateString(string settingName, string value)
    {
        SetPublicString(settingName+GameUid, value);
    }
}
