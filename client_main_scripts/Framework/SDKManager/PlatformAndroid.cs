#if UNITY_ANDROID
using System;
using System.Collections;
using System.Collections.Generic;
using GameFramework;
using UnityEngine;
using UnityGameFramework.Runtime;

public class PlatformAndroid : AndroidJavaProxy, IPlatformNative
{
    AndroidJavaObject currentActivity;

#if OLD_PACK
    public const string GOOGLE_PUBLIC_KEY = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAiYVPWSTL1D2+Rbyx9uyAx6PlPuXGGufEqInq1LfN3Thu7g6XYniKB0zhUKElEhSHxKMHJSJYK7TpUx6NGmW075+VHngPNHa94wZakn/pUvwoumRad/FJUoTlk3JeNfemlcUHwSNyzrykt1tCYqakgsQzETZY/Bp0C+NjOVzZFqMqZkmHy+n7IJx1GVOU9AW9HHaUmqAvPDLsolpKDoPw5KN1XIw+Z04HDjgpG3m9p+YaDNuUUWcJu12oQ+2qTrwzZSwwLe/hlG6uFciD6aar7/rbXydFZjYGQVeMMj4YQhe4T7ROEq6tlobn2yEeeJw8JMj92K46XbVeCMnJK+Vv3wIDAQAB";
    public const string GOOGLE_PROJ_NUM = "571473307808"; //google project number com.im30.lsu3d
    public const string BUGLY_KEY = "f550d68ac8";
#else
    public const string GOOGLE_PUBLIC_KEY = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAr8Ldw9qyOp2M2S78H0znUckZTw+f7np8zK6YdHwJ++qwTnNCWZD/HciziQw5+E1Cf0WezzMXO70vs/iqiUH7AXXsLyktQkp+Na1yTQRCLE/dX31oa9apMEIvFX/oqqRw9Og9kH19VAz8Q4gnv14flPM0b5Ogigm7wIENwe19/bU7VbpHcTNeqJmmynt7iDbKg7y/2IvNKJifcvlmYEF5YGL0CzM8Ju4WGttzaSE6HFdgYvqoI/SFMCVSxH7hw7WWv9fQcggTfmN2HAkTov8QRYdBsX+lURgFojMZ6kXp9F9wIkFvBaHE3XXnHCgEA4xvI4ERagW8HIz9FD3UQCljWwIDAQAB";
    public const string GOOGLE_PROJ_NUM = "693151746025"; //google project number com.im30.lsu3d
    public const string BUGLY_KEY = "990dbf4cb8";
#endif

    public PlatformAndroid(string listenerClassName) : base(listenerClassName)
    {
        AndroidJavaClass unityClass = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
        currentActivity = unityClass.GetStatic<AndroidJavaObject>("currentActivity");
    }

    #region Android Native Call
    /// <summary>
    /// 从Activity中调用非静态方法
    /// </summary>
    /// <param name="funcName">Func name.</param>
    /// <param name="args">Arguments.</param>
    public void Call(string funcName, params object[] args)
    {
        try
        {
            if (currentActivity != null)
                currentActivity.Call(funcName, args);
        }
        catch (System.Exception e)
        {
            Debug.LogError(e);
        }
    }

    /// <summary>
    /// 从Activity中调用带返回值的非静态方法
    /// </summary>
    /// <returns>The call.</returns>
    /// <param name="funcName">Func name.</param>
    /// <param name="args">Arguments.</param>
    /// <typeparam name="T">The 1st type parameter.</typeparam>
    public T Call<T>(string funcName, params object[] args)
    {
        T ret = default;
        try
        {
            if (currentActivity != null)
                ret = currentActivity.Call<T>(funcName, args);
        }
        catch (System.Exception e)
        {
            Debug.LogError(e);
        }

        return ret;
    }

    /// <summary>
    /// 从ActivityClass中调用静态方法
    /// </summary>
    /// <param name="funcName">Func name.</param>
    /// <param name="args">Arguments.</param>
    public void CallStatic(string funcName, params object[] args)
    {
        try
        {
            if (currentActivity != null)
                currentActivity.CallStatic(funcName, args);
        }
        catch (System.Exception e)
        {
            Debug.LogError(e);
        }
    }

    /// <summary>
    /// 从ActivityClass中调用带返回值的静态方法
    /// </summary>
    /// <returns>The call.</returns>
    /// <param name="funcName">Func name.</param>
    /// <param name="args">Arguments.</param>
    /// <typeparam name="T">The 1st type parameter.</typeparam>
    public T CallStatic<T>(string funcName, params object[] args)
    {
        T ret = default;
        try
        {
            if (currentActivity != null)
                ret = currentActivity.Call<T>(funcName, args);
        }
        catch (System.Exception e)
        {
            Debug.LogError(e);
        }

        return ret;
    }

    /// <summary>
    /// 从Activity中获取非静态字段
    /// </summary>
    /// <returns>The get.</returns>
    /// <param name="fieldName">Field name.</param>
    /// <typeparam name="T">The 1st type parameter.</typeparam>
    public T Get<T>(string fieldName)
    {
        try
        {
            if (currentActivity != null)
                return currentActivity.Get<T>(fieldName);
        }
        catch (System.Exception e)
        {
            Debug.LogError(e);
        }

        return default;
    }

    /// <summary>
    /// 从Activity中获取静态字段
    /// </summary>
    /// <returns>The static.</returns>
    /// <param name="fieldName">Field name.</param>
    /// <typeparam name="T">The 1st type parameter.</typeparam>
    public T GetStatic<T>(string fieldName)
    {
        try
        {
            if (currentActivity != null)
                return currentActivity.GetStatic<T>(fieldName);
        }
        catch (System.Exception e)
        {
            Debug.LogError(e);
        }

        return default;
    }
    #endregion

    #region Listener from AndroidJavaProxy
    public void SendDataToGame(string funcName, string data)
    {
        Log.Debug("SendDataToGame, funcName = {0}, data = {1}", funcName, data);
        GameEntry.Sdk.SendDataToGame(funcName, data);
    }

    public object GetDataFromGame(string funcName, string data)
    {
        object ret = null;

        try
        {
            switch (funcName)
            {
                case "getPlatform":
                    ret = ID.ToString();
                    break;
                case "getGpk":
                    ret = GOOGLE_PUBLIC_KEY;
                    break;
                case "getBuglyId":
                    ret = BUGLY_KEY;
                    break;
            }
        }
        catch (Exception e)
        {
            Log.Error(e);
        }

        if (ret == null)
            Log.Error("GetDataFromGame: funcName = {0}, data = {1}, ret is null!", funcName, data);
        else
            Log.Info("GetDataFromGame: funcName = {0}, data = {1}, ret = {2}", funcName, data, ret);

        return ret;
    }
    #endregion

    #region Interface function

    public bool HasSignedIn { get; set; }

    public string UID { get; set; }

    public GamePlatform ID => GamePlatform.GooglePlay;

    public PaymentChannel PaymentChannel => PaymentChannel.GooglePay;

    public LoginPlatform LoginPlatform { get; set; }

    public void SendDataToNative(string funcName, string data)
    {
        Call("SendDataToNative", funcName, data);
    }

    public string GetDataFromNative(string funcName, string data)
    {
        string ret = Call<string>("GetDataFromNative", funcName, data);
        if (string.IsNullOrEmpty(ret))
            ret = "";

        return ret;
    }
    
    public string GetPermissionByType(string data)
    {
        return GetDataFromNative("PM_GetPermit",data);
    }

    public void InitPlatform(string proxyName)
    {
        Call("InitPlatform", proxyName, this);
    }

    public void SignIn(string json)
    {
        Call("SignIn", json);
    }

    public void SignOut()
    {
        Call("SignOut");
    }

    public void Pay(int channelId, string json)
    {
        Call("Pay", channelId, json);
    }

    public void QueryPurchaseOrder()
    {
        SendDataToNative("Pay_queryPurchase", "");
    }

    public void ConsumeProduct(string orderId, int status)
    {
        Call("ConsumeProduct", orderId, status);
    }
    #endregion

    public static class BillingResponseCode
    {
        /** The request has reached the maximum timeout before Google Play responds. */
        public const int SERVICE_TIMEOUT = -3;
        /** Requested feature is not supported by Play Store on the current device. */
        public const int FEATURE_NOT_SUPPORTED = -2;
        /**
         * Play Store service is not connected now - potentially transient state.
         *
         * <p>E.g. Play Store could have been updated in the background while your app was still
         * running. So feel free to introduce your retry policy for such use case. It should lead to a
         * call to {@link #startConnection} right after or in some time after you received this code.
         */
        public const int SERVICE_DISCONNECTED = -1;
        /** Success */
        public const int OK = 0;
        /** User pressed back or canceled a dialog */
        public const int USER_CANCELED = 1;
        /** Network connection is down */
        public const int SERVICE_UNAVAILABLE = 2;
        /** Billing API version is not supported for the type requested */
        public const int BILLING_UNAVAILABLE = 3;
        /** Requested product is not available for purchase */
        public const int ITEM_UNAVAILABLE = 4;
        /**
         * Invalid arguments provided to the API. This error can also indicate that the application was
         * not correctly signed or properly set up for In-app Billing in Google Play, or does not have
         * the necessary permissions in its manifest
         */
        public const int DEVELOPER_ERROR = 5;
        /** Fatal error during the API action */
        public const int ERROR = 6;
        /** Failure to purchase since item is already owned */
        public const int ITEM_ALREADY_OWNED = 7;
        /** Failure to consume since item is not owned */
        public const int ITEM_NOT_OWNED = 8;
    }
}
#endif