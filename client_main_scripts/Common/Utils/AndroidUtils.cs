using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityGameFramework.Runtime;

#if UNITY_ANDROID
public static class AndroidUtils
{
    public static void Quit()
    {
        GameEntry.Sdk.Android.Call("ExitGame");
    }

    //获取虚拟键盘高度
    public static int GetKeyboardHeight()
    {
        AndroidJavaObject View = GameEntry.Sdk.Android.Get<AndroidJavaObject>("mUnityPlayer").Call<AndroidJavaObject>("getView");

        using (AndroidJavaObject Rct = new AndroidJavaObject("android.graphics.Rect"))
        {
            View.Call("getWindowVisibleDisplayFrame", Rct);

            return Screen.height - Rct.Call<int>("height");
        }
    }
}
#endif
