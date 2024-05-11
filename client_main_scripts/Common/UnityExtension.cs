//------------------------------------------------------------
// Game Framework v3.x
// Copyright © 2013-2018 Jiang Yin. All rights reserved.
// Homepage: http://gameframework.cn/
// Feedback: mailto:jiangyin@gameframework.cn
//------------------------------------------------------------

using System;
using System.Collections.Generic;
using DG.Tweening;
using GameFramework;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using XLua;
using LuaAPI = XLua.LuaDLL.Lua;
/// <summary>
/// Unity 扩展。
/// </summary>
public static class UnityExtension
{

    public static void TryAddElement<T>(this Dictionary<long, List<T>> dic, long key, T t)
    {
        if (dic.ContainsKey(key))
        {
            dic[key].Add(t);
        }
        else
        {
            dic[key] = new List<T>();
            dic[key].Add(t);
        }
    }

    public static List<string> ToStrList(this string str, char splitChar)
    {
        List<string> strList = new List<string>(5);
        if (!string.IsNullOrEmpty(str))
        {
            string[] strs = str.Split(new char[] { splitChar }, StringSplitOptions.RemoveEmptyEntries);
            for (int i = 0; i < strs.Length; i++)
            {
                strList.Add(strs[i]);
            }
        }
        return strList;
    }
    public static List<int> ToIntList(this string str, char splitChar)
    {
        //Log.Error("ToIntList : {0}", str);
        List<int> iList = new List<int>(5);
        if (!string.IsNullOrEmpty(str))
        {
            string[] strs = str.Split(new char[] { splitChar }, StringSplitOptions.RemoveEmptyEntries);
            for (int i = 0; i < strs.Length; i++)
            {
                iList.Add(StringUtils.TryParseInt(strs[i]));
            }
        }
        return iList;
    }

    public static int ToInt(this string str)
    {
        if (string.IsNullOrEmpty(str))
        {
            return 0;
        }

        if (str.Equals(" "))
            return 0;

        // 我们数值中会有大量的0-9这样的数值处理，所以这简单处理一下
        if (str.Length == 1)
        {
            if (str[0] >= '0' && str[0] <= '9')
            {
                return str[0] - '0';
            }
        }

        int i = 0;
        if (int.TryParse(str, out i) == false)
        {
            // if (Log.Write)
            // {
            //     Log.Error("ToInt error!!!! str: {0}", str);
            // }
        }
        return i;
    }


    public static int ToInt(this object obj)
    {
        if (obj is string)
        {
            return ToInt((string)obj);
        }

        int i = 0;
        try
        {
            //int.TryParse(obj.ToString(), out i);
            //return i;
            i = Convert.ToInt32(obj);
        }
        catch (Exception e)
        {
            // if (Log.Write)
            // {
            //     Log.Error("ToInt exception !!!! try ToString");
            // }

            // FIXME: 有些obj不能直接ToInt32，必须要ToString之后再转
            // 理论来说，这属于一个调用问题，但是这里也得做一个兼容，毕竟这个接口的参数是object
            return ToInt(obj.ToString());
        }
        return i;
    }

    // 这个函数用来实现ReadOnlySpan.ToInt，因为int.Parse在后面版本才支持ReadOnlySpan，而我们用的是.Net 2.0
    // 但是为了这个函数去升级CLR，又显得臃肿，所以这里自己特殊处理一下；这个转化只支持10进制。
    // 目前这个代码支持前端有空格，但不支持数字中间有空格的情况。
    public static int ToInt(this ReadOnlySpan<char> str)
    {
        int sign = 1, Base = 0, i = 0;

        // if whitespaces then ignore.
        while (str[i] == ' ')
        {
            i++;
        }

        // sign of number
        if (str[i] == '-' || str[i] == '+')
        {
            sign = 1 - 2 * (str[i++] == '-' ? 1 : 0);
        }

        // checking for valid input
        while (
            i < str.Length
            && str[i] >= '0'
            && str[i] <= '9')
        {
            // handling overflow test case
            if (Base > int.MaxValue / 10 || (Base == int.MaxValue / 10 && str[i] - '0' > 7))
            {
                if (sign == 1)
                    return int.MaxValue;
                else
                    return int.MinValue;
            }
            Base = 10 * Base + (str[i++] - '0');
        }

//#if UNITY_EDITOR && !FINAL_RELEASE
//        int ttt = str.ToString().ToInt();
//        if (ttt != Base * sign)
//        {
//            Log.Error("BUGBUGBUG! ToInt() not same!");
//        }
//#endif

        return Base * sign;
    }

    public static float ToFloat(this string str)
    {
        if (string.IsNullOrEmpty(str))
        {
            return 0;
        }

        float i = 0f;
        try
        {
            i = Convert.ToSingle (str);
        }
        catch (Exception e)
        {
            // if (Log.Write)
            // {
            //     Log.Error("ToFloat error!!!! str: {0}", str);
            // }
        }
        return i;
    }

    // 为了直接从ReadOnlySpan -> float!
    public static float ToFloat(this ReadOnlySpan<char> str)
    {
        float f = (float)Strtod_CSharp.strtod(str);

// #if UNITY_EDITOR && !FINAL_RELEASE
//         float ttt = str.ToString().ToFloat();
//         if (!Mathf.Approximately(f, ttt))
//         {
//             Log.Error("BUGBUGBUG! ToFloat() not same!");
//         }
// #endif

        return f;
    }
    
    // ReadOnlySpan => ToULong
    public static ulong ToULong(this ReadOnlySpan<char> str)
    {
        ulong u = Strtoul_CSharp.strtoul(str);
        
// #if UNITY_EDITOR
//         ulong ttt = Convert.ToUInt64(str.ToString());
//         if (ttt != u)
//         {
//             Log.Error("BUGBUGBUG! ToULong() not same!");
//         }
// #endif
        return u;
    }

    public static float ToFloat(this object obj)
    {
        if (obj is string)
        {
            return ToFloat((string)obj);
        }

        float i = 0f;
        try
        {
            i = Convert.ToSingle(obj);
        }
        catch (Exception e)
        {
            // if (Log.Write)
            // {
            //     Log.Error("ToFloat exception !!!! try ToString");
            // }

            return ToFloat(obj.ToString());
        }
        return i;
    }

    public static long ToLong(this string str)
    {
        long i = 0;
        if (str.Contains("."))
        {
            List <string> strVec = new List<string>();
            StringUtils.SplitString(str, '.', ref strVec);
            long.TryParse(strVec[0], out i);
        }
        else
        {
            long.TryParse(str, out i);
        }

        return i;
    }

    public static GameObject Instantiate(this GameObject go)
    {
        if (go != null)
        {
            return GameObject.Instantiate(go);
        }
        return go;
    }

    public static void Destroy(this GameObject go)
    {
        if (go != null)
        {
            GameObject.Destroy(go);
        }
    }

    /// <summary>
    /// 获取 GameObject 是否在场景中。
    /// </summary>
    /// <param name="gameObject">目标对象。</param>
    /// <returns>GameObject 是否在场景中。</returns>
    /// <remarks>若返回 true，表明此 GameObject 是一个场景中的实例对象；若返回 false，表明此 GameObject 是一个 Prefab。</remarks>
    public static bool InScene(this GameObject gameObject)
    {
        return gameObject.scene.name != null;
    }

    /// <summary>
    /// 递归设置游戏对象的层次。
    /// </summary>
    /// <param name="gameObject"><see cref="UnityEngine.GameObject" /> 对象。</param>
    /// <param name="layer">目标层次的编号。</param>
    public static void SetLayerRecursively(this GameObject gameObject, int layer)
    {
        Transform[] transforms = gameObject.GetComponentsInChildren<Transform>(true);
        for (int i = 0; i < transforms.Length; i++)
        {
            transforms[i].gameObject.layer = layer;
        }
    }

    /// <summary>
    /// 取 <see cref="UnityEngine.Vector3" /> 的 (x, y, z) 转换为 <see cref="UnityEngine.Vector2" /> 的 (x, z)。
    /// </summary>
    /// <param name="vector3">要转换的 Vector3。</param>
    /// <returns>转换后的 Vector2。</returns>
    public static Vector2 ToVector2(this Vector3 vector3)
    {
        return new Vector2(vector3.x, vector3.z);
    }

    /// <summary>
    /// 取 <see cref="UnityEngine.Vector2" /> 的 (x, y) 转换为 <see cref="UnityEngine.Vector3" /> 的 (x, 0, y)。
    /// </summary>
    /// <param name="vector2">要转换的 Vector2。</param>
    /// <returns>转换后的 Vector3。</returns>
    public static Vector3 ToVector3(this Vector2 vector2)
    {
        return new Vector3(vector2.x, 0f, vector2.y);
    }

    // 编辑器模式下只能使用DestroyImmediate
    // 而运行模式使用DestroyImmediate又会有隐患。。。所以这个函数出现了
    public static void DestroyEx(this GameObject obj)
    {
        if (Application.isPlaying)
        {
            GameObject.Destroy(obj);
        }
        else
        {
            GameObject.DestroyImmediate(obj, false);
        }
    }
    #region Transform

    /// <summary>
    /// 设置绝对位置的 x 坐标。
    /// </summary>
    /// <param name="transform"><see cref="UnityEngine.Transform" /> 对象。</param>
    /// <param name="newValue">x 坐标值。</param>
    public static void SetPositionX(this Transform transform, float newValue)
    {
        Vector3 v = transform.position;
        v.x = newValue;
        transform.position = v;
    }

    /// <summary>
    /// 设置绝对位置的 y 坐标。
    /// </summary>
    /// <param name="transform"><see cref="UnityEngine.Transform" /> 对象。</param>
    /// <param name="newValue">y 坐标值。</param>
    public static void SetPositionY(this Transform transform, float newValue)
    {
        Vector3 v = transform.position;
        v.y = newValue;
        transform.position = v;
    }

    /// <summary>
    /// 设置绝对位置的 z 坐标。
    /// </summary>
    /// <param name="transform"><see cref="UnityEngine.Transform" /> 对象。</param>
    /// <param name="newValue">z 坐标值。</param>
    public static void SetPositionZ(this Transform transform, float newValue)
    {
        Vector3 v = transform.position;
        v.z = newValue;
        transform.position = v;
    }

    /// <summary>
    /// 增加绝对位置的 x 坐标。
    /// </summary>
    /// <param name="transform"><see cref="UnityEngine.Transform" /> 对象。</param>
    /// <param name="deltaValue">x 坐标值增量。</param>
    public static void AddPositionX(this Transform transform, float deltaValue)
    {
        Vector3 v = transform.position;
        v.x += deltaValue;
        transform.position = v;
    }

    /// <summary>
    /// 增加绝对位置的 y 坐标。
    /// </summary>
    /// <param name="transform"><see cref="UnityEngine.Transform" /> 对象。</param>
    /// <param name="deltaValue">y 坐标值增量。</param>
    public static void AddPositionY(this Transform transform, float deltaValue)
    {
        Vector3 v = transform.position;
        v.y += deltaValue;
        transform.position = v;
    }

    /// <summary>
    /// 增加绝对位置的 z 坐标。
    /// </summary>
    /// <param name="transform"><see cref="UnityEngine.Transform" /> 对象。</param>
    /// <param name="deltaValue">z 坐标值增量。</param>
    public static void AddPositionZ(this Transform transform, float deltaValue)
    {
        Vector3 v = transform.position;
        v.z += deltaValue;
        transform.position = v;
    }

    /// <summary>
    /// 设置相对位置的 x 坐标。
    /// </summary>
    /// <param name="transform"><see cref="UnityEngine.Transform" /> 对象。</param>
    /// <param name="newValue">x 坐标值。</param>
    public static void SetLocalPositionX(this Transform transform, float newValue)
    {
        Vector3 v = transform.localPosition;
        v.x = newValue;
        transform.localPosition = v;
    }

    /// <summary>
    /// 设置相对位置的 y 坐标。
    /// </summary>
    /// <param name="transform"><see cref="UnityEngine.Transform" /> 对象。</param>
    /// <param name="newValue">y 坐标值。</param>
    public static void SetLocalPositionY(this Transform transform, float newValue)
    {
        Vector3 v = transform.localPosition;
        v.y = newValue;
        transform.localPosition = v;
    }

    /// <summary>
    /// 设置相对位置的 z 坐标。
    /// </summary>
    /// <param name="transform"><see cref="UnityEngine.Transform" /> 对象。</param>
    /// <param name="newValue">z 坐标值。</param>
    public static void SetLocalPositionZ(this Transform transform, float newValue)
    {
        Vector3 v = transform.localPosition;
        v.z = newValue;
        transform.localPosition = v;
    }

    /// <summary>
    /// 增加相对位置的 x 坐标。
    /// </summary>
    /// <param name="transform"><see cref="UnityEngine.Transform" /> 对象。</param>
    /// <param name="deltaValue">x 坐标值。</param>
    public static void AddLocalPositionX(this Transform transform, float deltaValue)
    {
        Vector3 v = transform.localPosition;
        v.x += deltaValue;
        transform.localPosition = v;
    }

    /// <summary>
    /// 增加相对位置的 y 坐标。
    /// </summary>
    /// <param name="transform"><see cref="UnityEngine.Transform" /> 对象。</param>
    /// <param name="deltaValue">y 坐标值。</param>
    public static void AddLocalPositionY(this Transform transform, float deltaValue)
    {
        Vector3 v = transform.localPosition;
        v.y += deltaValue;
        transform.localPosition = v;
    }

    /// <summary>
    /// 增加相对位置的 z 坐标。
    /// </summary>
    /// <param name="transform"><see cref="UnityEngine.Transform" /> 对象。</param>
    /// <param name="deltaValue">z 坐标值。</param>
    public static void AddLocalPositionZ(this Transform transform, float deltaValue)
    {
        Vector3 v = transform.localPosition;
        v.z += deltaValue;
        transform.localPosition = v;
    }

    /// <summary>
    /// 设置相对尺寸的 x 分量。
    /// </summary>
    /// <param name="transform"><see cref="UnityEngine.Transform" /> 对象。</param>
    /// <param name="newValue">x 分量值。</param>
    public static void SetLocalScaleX(this Transform transform, float newValue)
    {
        Vector3 v = transform.localScale;
        v.x = newValue;
        transform.localScale = v;
    }

    /// <summary>
    /// 设置相对尺寸的 y 分量。
    /// </summary>
    /// <param name="transform"><see cref="UnityEngine.Transform" /> 对象。</param>
    /// <param name="newValue">y 分量值。</param>
    public static void SetLocalScaleY(this Transform transform, float newValue)
    {
        Vector3 v = transform.localScale;
        v.y = newValue;
        transform.localScale = v;
    }

    /// <summary>
    /// 设置相对尺寸的 z 分量。
    /// </summary>
    /// <param name="transform"><see cref="UnityEngine.Transform" /> 对象。</param>
    /// <param name="newValue">z 分量值。</param>
    public static void SetLocalScaleZ(this Transform transform, float newValue)
    {
        Vector3 v = transform.localScale;
        v.z = newValue;
        transform.localScale = v;
    }

    /// <summary>
    /// 增加相对尺寸的 x 分量。
    /// </summary>
    /// <param name="transform"><see cref="UnityEngine.Transform" /> 对象。</param>
    /// <param name="deltaValue">x 分量增量。</param>
    public static void AddLocalScaleX(this Transform transform, float deltaValue)
    {
        Vector3 v = transform.localScale;
        v.x += deltaValue;
        transform.localScale = v;
    }

    /// <summary>
    /// 增加相对尺寸的 y 分量。
    /// </summary>
    /// <param name="transform"><see cref="UnityEngine.Transform" /> 对象。</param>
    /// <param name="deltaValue">y 分量增量。</param>
    public static void AddLocalScaleY(this Transform transform, float deltaValue)
    {
        Vector3 v = transform.localScale;
        v.y += deltaValue;
        transform.localScale = v;
    }

    /// <summary>
    /// 增加相对尺寸的 z 分量。
    /// </summary>
    /// <param name="transform"><see cref="UnityEngine.Transform" /> 对象。</param>
    /// <param name="deltaValue">z 分量增量。</param>
    public static void AddLocalScaleZ(this Transform transform, float deltaValue)
    {
        Vector3 v = transform.localScale;
        v.z += deltaValue;
        transform.localScale = v;
    }
    

    #endregion Transform

    #region Text
    static object[] arrParam = new object[10];
    private static string GetParamString()
    {
        IntPtr L = GameEntry.Lua.Env.L;
        
        // top上至少有2个参数，即obj和dialogId
        int gen_param_count = LuaAPI.lua_gettop(L);
        if (gen_param_count < 2)
        {
            return "";
        }

        string dialogId = "";
        if (LuaAPI.lua_isinteger(L, 2))
        {
            int nDialog = LuaAPI.xlua_tointeger(L, 2);
            dialogId = StringUtils.IntToString(nDialog);
        }else if (LuaAPI.lua_isstring(L, 2))
        {
            dialogId = LuaAPI.lua_tostring(L, 2);
        }

        if (gen_param_count == 2)
        {
            string s = GameEntry.Localization.GetString(dialogId, null);
            return s;
        }

        if (gen_param_count > 10)
        {
            Log.Error("SetLocalText too much params! max count = 0");
            gen_param_count = 10;
        }

        int param_count = gen_param_count - 2;
        for (int i = 0; i < param_count; ++i)
        {
            int index = i + 3;
            if (LuaAPI.lua_isinteger(L, index))
            {
                arrParam[i] = LuaAPI.xlua_tointeger(L, index);
            }
            else if (LuaAPI.lua_isnumber(L, index))
            {
                arrParam[i] = LuaAPI.lua_tonumber(L, index);
            }
            else
            {
                arrParam[i] = LuaAPI.lua_tostring(L, index);
            }

            if (arrParam[i] == null)
            {
                arrParam[i] = "";
            }
        }
        
        // 其余置null
        Array.Clear(arrParam, param_count, arrParam.Length-param_count);
        return GameEntry.Localization.GetString(dialogId, arrParam);
    }
    
    public static void SetLocalText(this Text obj)
    {
        string result = GetParamString();
        obj.text = result;
    }
    
    public static void SetLocalText(this TextMeshProUGUI obj)
    {
        string result = GetParamString();
        obj.text = result;
    }
    
    public static void SetLocalText(this InputField obj)
    {
        string result = GetParamString();
        obj.text = result;
    }
    
    public static void SetLocalText(this TMP_InputField obj)
    {
        string result = GetParamString();
        obj.text = result;
    }
    
    public static void SetLocalText(this SuperTextMesh obj)
    {
        string result = GetParamString();
        obj.text = result;
    }

    #endregion


    #region 字符串优化
    public static void SetTimeStamp(this Text text, long leftMilliSecond)
    {
        text.text = GameEntry.Timer.MilliSecondToFmtString(leftMilliSecond);
    }
    
    public static bool PlayId(this SimpleAnimation ani, int stateNameToId)
    {
        var stateName = LuaStringLookupTable.Get(stateNameToId);
        return ani.Play(stateName);
    }

    public static void PlayQueuedId(this SimpleAnimation simpleAni, int stateNameToId)
    {
        var stateName = LuaStringLookupTable.Get(stateNameToId);
        simpleAni.PlayQueued(stateName);
    }
    
    public static void PlayId(this Animator ani, int stateNameToId, int layerIdx, float normalizedTime)
    {
        var stateName = LuaStringLookupTable.Get(stateNameToId);
        ani.Play(stateName, layerIdx, normalizedTime);
    }

    public static void SetTriggerId(this Animator ani, int triggerNameToId)
    {
        var triggerName = LuaStringLookupTable.Get(triggerNameToId);
        ani.SetTrigger(triggerName);
    }

    public static Transform FindId(this Transform tran, int pathToId)
    {
        var path = LuaStringLookupTable.Get(pathToId);
        return tran.Find(path);
    }
    
    #endregion

    #region GetComponent
    
    public static Component FindAndGetComponent(this Transform tran, string path, System.Type type)
    {
        var child = tran.Find(path);
        if (child == null)
        {
            return null;
        }
        
        var t = child.GetComponent(type);
        return t;
    }

    public static Component GetComponent_RectTransform(this Transform tran)
    {
        return tran.GetComponent<RectTransform>();
    }
    
    public static Component GetComponent_RectTransform(this GameObject obj)
    {
        return obj.GetComponent<RectTransform>();
    }
    
    public static Component GetComponent_Text(this Transform tran)
    {
        return tran.GetComponent<Text>();
    }
    
    public static Component GetComponent_Text(this GameObject obj)
    {
        return obj.GetComponent<Text>();
    }
    
    public static Component GetComponent_Image(this Transform tran)
    {
        return tran.GetComponent<Image>();
    }
    
    public static Component GetComponent_Image(this GameObject obj)
    {
        return obj.GetComponent<Image>();
    }
    
    public static Component GetComponent_Button(this Transform tran)
    {
        return tran.GetComponent<Button>();
    }
    
    public static Component GetComponent_Button(this GameObject obj)
    {
        return obj.GetComponent<Button>();
    }
    public static T GetComponentInParentExt<T>(this Transform rt, bool includeSelf = true) where T : Component
    {
        var t = typeof(T);
        if (includeSelf)
        {
            return rt.GetComponentInParent(t) as T;
        }

        Component ret = null;
        Transform parent = rt.parent;
        while (parent != null)
        {
            ret = parent.GetComponent(t);
            if (ret != null)
            {
                break;
            }
            
            parent = parent.parent;
        }

        return ret as T;
    }
    #endregion
    

}
