using System.Collections;  
using System.Collections.Generic;  
using UnityEngine;  
using UnityEngine.UI;  
using GameFramework;  
  
public class ScreenSafeArea:MonoBehaviour  
{  
    public Rect phoneDelta = new Rect(50f, 0f, -100f, 0);//ios 官方给定的偏移量  
    [SerializeField]  
    private RectTransform Panel;  
    private Rect LastSafeArea = new Rect(0, 0, 0, 0);
    private float ScreenWidth, ScreenHeight;
    private void Awake()  
    {  
        Panel = GetComponent<RectTransform>();  
        Refresh();
        ScreenHeight = Screen.height;
        ScreenWidth = Screen.width;
    }  
  
    private void Update()
    {
        CheckSize();
    }

    private void CheckSize()
    {
        if (ScreenHeight != Screen.height || ScreenWidth != Screen.width)
        {
            Refresh();
            ScreenHeight = Screen.height;
            ScreenWidth = Screen.width;
        }
    }
    private void Refresh()  
    {  
        Rect safeArea = GetSafeArea();  
  
        if (safeArea != LastSafeArea)  
            SetSafeArea(safeArea);  
    }  
  
    public static Rect GetSafeArea()  
    {  
        var tempArea = Screen.safeArea;
#if UNITY_ANDROID
        var delta = GameEntry.Sdk.AndroidScreenNotch;
        if (!delta.IsNullOrEmpty())
        {
            var vec = delta.Split(';');
            if (vec.Length > 3)
            {
                var delta1 = vec[0].ToFloat();
                var delta2 = vec[1].ToFloat();
                var delta3 = vec[2].ToFloat();
                var delta4 = vec[3].ToFloat();
                var deltaX = Mathf.Max(delta1, delta2, delta3, delta4);
                tempArea = new Rect(deltaX,0,Screen.width- (deltaX*2), Screen.height);
                
            }
        }
#endif
        var deltaWidthX = tempArea.x;
        //
        // if (Screen.width > Screen.height)
        // {
        //     if (Screen.width * 750 > Screen.height * 1334)
        //     {
        //         if (deltaWidthX<= 0)
        //         {
        //             deltaWidthX = phoneDelta.x;
        //         }
        //     }
        // }
        var safeArea = new Rect((deltaWidthX/2), 0, Screen.width-(deltaWidthX), Screen.height);

// #if UNITY_EDITOR  
//         if((Screen.width == 2778 && Screen.height == 1284)//iphone12 pro max   
//            ||(Screen.width == 2532 && Screen.height == 1170)//iphone12 pro/iphone12  
//            ||(Screen.width == 2340 && Screen.height == 1080)//iphone12 mini  
//            ||(Screen.width == 2688 && Screen.height == 1242)//iphone11 pro max/iphoneXs max  
//            ||(Screen.width == 2436 && Screen.height == 1125)//iphone11 pro/iphone Xs/iphone X  
//            ||(Screen.width == 1792 && Screen.height == 828))//iphone11/iphone Xr  
//         {  
//             safeArea = new Rect(iphoneDelta.x, iphoneDelta.y, Screen.width+ iphoneDelta.width, Screen.height +iphoneDelta.height);  
//         }  
// #endif  
        return safeArea;  
    }  
  
    private void SetSafeArea(Rect r)  
    {  
        LastSafeArea = r;  
        Vector2 anchorMin = r.position;  
        Vector2 anchorMax = r.position + r.size;  
        anchorMin.x /= Screen.width;  
        anchorMin.y /= Screen.height;  
        anchorMax.x /= Screen.width;  
        anchorMax.y /= Screen.height;  
        Panel.anchorMin = anchorMin;  
        Panel.anchorMax = anchorMax;  
  
        Log.Debug("New safe area {0}: x={1}, y={2}, w={3}, h={4} screenSize w={5}, h={6}",  
            name, r.x, r.y, r.width, r.height, Screen.width, Screen.height);  
    }  
}