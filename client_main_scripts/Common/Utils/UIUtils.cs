using System;
using System.Collections.Generic;
using System.Text;
using GameKit.Base;
using Sfs2X.Entities.Data;
using Spine.Unity;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using Random = UnityEngine.Random;

public static class UIUtils
{

    /// <summary>
    /// 获取异形屏一边的宽度
    /// </summary>
    /// <returns></returns>
    public static float tmpWidth = -100.0f;
    public static float GetSpecialScreenWidth()
    {
        if (tmpWidth < -99.0)
        {
            int width = Screen.width;
            float newWidth = ScreenSafeArea.GetSafeArea().width;
            tmpWidth = (width - newWidth) / 2.0f;
        }

        return tmpWidth;
    }

    public static bool IsPhone()
    {
        bool isPhone = true;
#if UNITY_IPHONE && !UNITY_EDITOR
			string deviceInfo = SystemInfo.deviceModel.ToString();
			isPhone = deviceInfo.Contains("iPhone");
#else
        float physicscreen = 1.0f * Screen.width / Screen.height;
        isPhone = physicscreen > 1.5f; //(the ratio 4:3 = 1.33; 16:9 = 1.777;)
#endif
        return isPhone;
    }

    public static void AddChildManually(Transform parent, Transform child)
    {
        child.SetParent(parent);
        child.localScale = Vector3.one;
        child.localPosition = Vector3.zero;
    }

    public static bool CheckGuiRaycastObjects()
    {
        if (EventSystem.current == null)
        {
            return false;
        }

        PointerEventData eventData = new PointerEventData(EventSystem.current);
#if UNITY_EDITOR || UNITY_STANDALONE
        eventData.pressPosition = Input.mousePosition;
        eventData.position = Input.mousePosition;
#endif
#if UNITY_ANDROID || UNITY_IPHONE
        if (Input.touchCount > 0)
        {
            eventData.pressPosition = Input.GetTouch(0).position;
            eventData.position = Input.GetTouch(0).position;
        }
#endif
        List<RaycastResult> list = new List<RaycastResult>();
        EventSystem.current.RaycastAll(eventData, list);
        return list.Count > 0;
    }

    public static List<RaycastResult> GetGuiRaycastObjects(Vector2 mousePos)
    {
        List<RaycastResult> list = new List<RaycastResult>();
        if (EventSystem.current == null)
        {
            return list;
        }

        PointerEventData eventData = new PointerEventData(EventSystem.current);
        eventData.pressPosition = mousePos;
        eventData.position = mousePos;
        EventSystem.current.RaycastAll(eventData, list);

        return list;
    }

    public static bool CheckGuiRaycastObjects(Vector2 mousePos)
    {
        if (EventSystem.current == null)
        {
            return false;
        }

        PointerEventData eventData = new PointerEventData(EventSystem.current);
        eventData.pressPosition = mousePos;
        eventData.position = mousePos;
        List<RaycastResult> list = new List<RaycastResult>();
        EventSystem.current.RaycastAll(eventData, list);

        return list.Count > 0;
    }

    public static void ShowMessage(string message, int buttonCount = 1, string confirmText = GameDialogDefine.CONFIRM,
        string cancelText = GameDialogDefine.CANCEL, Action confirmAction = null, Action cancelAction = null, bool isChangeImg = false)
    {
        GameEntry.Lua.ShowMessage(message,buttonCount,confirmText,cancelText,confirmAction,cancelAction,cancelAction,"",isChangeImg);
        //UITipMessage.Instance.Show(message, buttonCount, confirmText, cancelText, confirmAction, cancelAction, isLocal);
    }
    
    public static void ShowMessages(string message, int buttonCount, string cancelText,
        string confirmText, Action confirmAction = null, Action cancelAction = null, bool isChangeImg = true)
    {
        GameEntry.Lua.ShowMessage(message,buttonCount,cancelText, confirmText,cancelAction,confirmAction,cancelAction,"",isChangeImg);
        //UITipMessage.Instance.Show(message, buttonCount, confirmText, cancelText, confirmAction, cancelAction, isLocal);
    }

    public static void ShowMessage(string message, Action confirmAction, Action cancelAction = null, bool isChangeImg = false)
    {
        GameEntry.Lua.ShowMessage(message,cancelAction == null ? 1 : 2,GameDialogDefine.CONFIRM,GameDialogDefine.CANCEL,confirmAction,cancelAction,cancelAction,"",isChangeImg);
    }
    //这个方法和上一个的区别是默认显示关闭按钮
    public static void NewShowMessage(string message, Action confirmAction, Action cancelAction = null, bool isChangeImg = false)
    {
        GameEntry.Lua.ShowMessage(message,cancelAction == null ? 2 : 3,GameDialogDefine.CONFIRM,GameDialogDefine.CANCEL,confirmAction,cancelAction,cancelAction,"",isChangeImg);
    }


    public static void ShowReloadMessage(string message,Action confirmAction, Action cancelAction,string rTxt = "",float countTime = 0)
    {
        //ShowMessage(message, 1, " 120952", GameDialogDefine.CANCEL, 
        //    delegate { ApplicationLaunch.Instance.ReloadGame(); },
        //    delegate { ApplicationLaunch.Instance.Quit();});

        //var para = new UINetError.Param { errMsg = message, onConfirm = confirmAction , cancelConfirm = cancelAction , time = countTime , rightTxt = rTxt };
        //GameEntry.UI.OpenUIForm(GameDefines.UIAssets.UINetError, GameDefines.UILayer.Dialog, para);
        GameEntry.Lua.ShowMessage(message, 2, GameDialogDefine.CONFIRM, rTxt, confirmAction, cancelAction, cancelAction, "",false);
    }

    public static void ShowLoadingMask()
    {
        //UILoadingMask.Instance.SetState(true);
    }

    public static void HideLoadingMask()
    {
        //UILoadingMask.Instance.SetState(false);
    }

    public static void ShowLoadingMask(bool animation, Color color, bool isAutoTimer = true)
    {
        //UILoadingMask.Instance.SetState(true, animation, color, isAutoTimer);
    }
    // 这个方法传进来的msgKey 是 本地化的id,直接用uitips内部方法解析id
    public static void ShowTips(string msgKey, float closeTime = 3f, params object[] args)
    {
        GameEntry.Lua.ShowTips(GameEntry.Localization.GetString(msgKey, args), "", "");
        // UITips.Param p = new UITips.Param()
        // {
        //     AutoCloseTime = closeTime,
        //     TextKey = msgKey,
        //     FormatParams = args,
        // };
        // GameEntry.UI.OpenUIForm(GameDefines.UIAssets.Tips, GameDefines.UILayer.Dialog, p);
    }


    /// <summary>显示资源缺少界面</summary>
    public static void ShowLackResource(string tipContent, Dictionary<ResourceType, long> resources, string actionName, Action actionCallBack, bool tipContentIsKey = true, bool actionNameIsKey = true)
    {
        // LackResources.Param p = new LackResources.Param()
        // {
        //     tipContent = tipContent,
        //     tipIsKey = tipContentIsKey,
        //     btnName = actionName,
        //     btnNameIsKey = actionNameIsKey,
        //     callback = actionCallBack,
        //     resources = resources,
        // };
        // UIPreAdd.OpenLackResources(p);
    }

    //显示排行榜
    public static void ShowRankView()
    {
        int configLv = GameEntry.Lua.CallWithReturn<int, string, string>("CSharpCallLuaInterface.GetConfigNum", "ranking", "k3");
        //if (GameEntry.Lua.CallWithReturn<int>("CSharpCallLuaInterface.GetMainLv") < configLv)
        if (GameEntry.Data.Building.GetMainLv() < configLv)
        {
            ShowTips("108111", 3, configLv);
            return;
        }
        
    }

    /// <summary>
    /// 世界坐标转UI屏幕坐标
    /// </summary>
    /// <param name="wordPosition"></param>
    /// <returns></returns>
    public static Vector2 WordToScenePoint(Vector3 wordPosition)
    {
        CanvasScaler canvasScaler = GameEntry.UIContainer.GetComponent<CanvasScaler>();

        float resolutionX = canvasScaler.referenceResolution.x;

        float resolutionY = canvasScaler.referenceResolution.y;

        float offect = (Screen.width / canvasScaler.referenceResolution.x) * (1 - canvasScaler.matchWidthOrHeight) +
                       (Screen.height / canvasScaler.referenceResolution.y) * canvasScaler.matchWidthOrHeight;

        Vector2 a = RectTransformUtility.WorldToScreenPoint(Camera.main, wordPosition);

        return new Vector2(a.x / offect, a.y / offect);
    }

    /// <summary>
    /// 屏幕坐标转UGUI坐标
    /// </summary>
    /// <param name="transform"></param>
    /// <param name="screenPos"></param>
    /// <returns></returns>
    public static Vector2 ScreenPointToLocalPointInRectangle(Transform transform, Vector2 screenPos)
    {
        Vector2 localPos;
        RectTransform rectT = transform.GetComponent<RectTransform>();
        if (rectT == null)
            return Vector2.zero;
        RectTransformUtility.ScreenPointToLocalPointInRectangle(rectT, screenPos, null, out localPos);
        return localPos;
    }
    

    public delegate void SkeletonDelegate(SkeletonDataAsset asset);

    // 动态创建一个 spine 动画数据
    public static void BuildSkeletonDataAsset(string skeletonPath, SkeletonDelegate handler)
    {
//        SkeletonDataAsset sda;
//        sda = ScriptableObject.CreateInstance<SkeletonDataAsset>();
//        sda.fromAnimation = new string[0];
//        sda.toAnimation = new string[0];
//        sda.duration = new float[0];
//        sda.scale = 0.01f;
//        sda.defaultMix = 0.2f;
//        AtlasAsset[] arrAtlasData = new AtlasAsset[1];
//        for (int i = 0; i < arrAtlasData.Length; i++)
//        {
//            AtlasAsset atlasdata = ScriptableObject.CreateInstance<AtlasAsset>();
//            atlasdata.materials = new Material[1];
//
//            GameEntry.Resource.LoadAssetAsync<TextAsset>(skeletonPath + ".atlas.txt",
//                (key, asset, err) =>
//                {
//                    atlasdata.atlasFile = asset as TextAsset;
//                    GameEntry.Resource.LoadAssetAsync<Material>(skeletonPath + "_Material.mat",
//                        (key2, asset2, err2) =>
//                        {
//                            atlasdata.materials[0] = asset2 as Material;
//                            arrAtlasData[0] = atlasdata;
//                            sda.atlasAssets = arrAtlasData;
//
//                            GameEntry.Resource.LoadAssetAsync<TextAsset>(skeletonPath + ".json",
//                                (key3, asset3, err3) =>
//                                {
//                                    sda.skeletonJSON = asset3 as TextAsset;
//                                    handler?.Invoke(sda);
//                                });
//                        });
//                });
//
//            // 没有释放，需要补充
//
//            //GameEntry.Resource.LoadAssetAsync<TextAsset>(skeletonPath + ".atlas.txt",
//            //new LoadAssetCallbacks((string assetName, object asset, float duration, object userData) =>
//            //{
//            //    atlasdata.atlasFile = asset as TextAsset;
//            //    GameEntry.Resource.LoadAssetAsync<Material>(skeletonPath + "_Material.mat",
//            //        new LoadAssetCallbacks((string assetName2, object asset2, float duration2, object userData2) =>
//            //        {
//            //            atlasdata.materials[0] = asset2 as Material;
//            //            arrAtlasData[0] = atlasdata;
//            //            sda.atlasAssets = arrAtlasData;
//            //            GameEntry.Resource.LoadAssetAsync<TextAsset>(skeletonPath + ".json",
//            //                new LoadAssetCallbacks(
//            //                    (string assetName3, object asset3, float duration3, object userData3) =>
//            //                    {
//            //                        sda.skeletonJSON = asset3 as TextAsset;
//            //                        if (handler != null)
//            //                        {
//            //                            handler(sda);
//            //                        }
//            //                    }));
//            //        }));
//            //}));
//        }
    }

    //检查用户名
    public static bool checkUserName(string userName)
    {
        bool ret = false;
        if (string.IsNullOrEmpty(userName))
        {
            //79010662=电子邮件地址不能为空
            ShowTips("280122");
        }
        else
        {
            ret = true;
        }

        return ret;
    }

    public static bool checkPwd(string pwd)
    {
        bool ret = false;
        if (string.IsNullOrEmpty(pwd))
        {
            //79010661=密码不能为空
            ShowTips("280121");
        }
        else if (pwd.Length < 8 || pwd.Length > 15)
        {
            ShowTips("280119");
        }
        else
        {
            ret = true;
        }

        return ret;
    }

    public static bool checkPwd(string pwd1, string pwd2)
    {
        bool ret = checkPwd(pwd1);
        if (ret && !string.IsNullOrEmpty(pwd1) && !string.IsNullOrEmpty(pwd2))
        {
            if (pwd1.Equals(pwd2))
            {
                ret = true;
            }
            else
            {
                //79010667=两次输入的密码不一致
                ShowTips("280126");
                ret = false;
            }
        }
        else
        {
            ret = false;
        }

        return ret;
    }

    public static string getAccountBindStateName()
    {
        string strBindState = "";
        string account = GameEntry.Setting.GetString(GameDefines.SettingKeys.IM30_ACCOUNT, "");
        //未绑定
        strBindState = GameEntry.Localization.GetString("280033");

        if (!string.IsNullOrEmpty(account))
        {
            //账号验证状态
            int status = GameEntry.Setting.GetInt(GameDefines.SettingKeys.ACCOUNT_STATUS, 0);
            if (status == 1)
            {
                //已验证、即已绑定
                strBindState = GameEntry.Localization.GetString("280057");
            }
            else
            {
                //未验证
                strBindState = GameEntry.Localization.GetString("280125");
            }
        }
        string _gpUid = GameEntry.Setting.GetString(GameDefines.SettingKeys.GP_USERID, "");
        if (_gpUid != "")
        {
            strBindState = GameEntry.Localization.GetString("280057");
        }
        string _fbUid = GameEntry.Setting.GetString(GameDefines.SettingKeys.FB_USERID, "");
        if (_fbUid != "")
        {
            strBindState = GameEntry.Localization.GetString("280057");
        }
        //微信绑定
        string _wxAppId = GameEntry.Setting.GetString(GameDefines.SettingKeys.WX_APPID_CACHE, "");
        if (_wxAppId != "")
        {
            strBindState = GameEntry.Localization.GetString("280057");
        }
        return strBindState;
    }
    public static string getIM30AccountBindStateName()
    {
        string strBindState = "";
        string account = GameEntry.Setting.GetString(GameDefines.SettingKeys.IM30_ACCOUNT, "");

        if (!string.IsNullOrEmpty(account))
        {
            //账号验证状态
            int status = GameEntry.Setting.GetInt(GameDefines.SettingKeys.ACCOUNT_STATUS, 0);
            if (status == 1)
            {
                //已验证、即已绑定
                strBindState = GameEntry.Localization.GetString("280057");
            }
            else
            {
                //未验证
                strBindState = GameEntry.Localization.GetString("280125");
            }
        }
        else
        {
            //未绑定
            strBindState = GameEntry.Localization.GetString("280033");

        }
        return strBindState;
    }

    public static int getAccountBindState()
    {
        int strBindState = -1;
        string account = GameEntry.Setting.GetString(GameDefines.SettingKeys.IM30_ACCOUNT, "");
        if (!string.IsNullOrEmpty(account))
        {
            //账号验证状态
            int status = GameEntry.Setting.GetInt(GameDefines.SettingKeys.ACCOUNT_STATUS, 0);
            if (status == 1)
            {
                //已验证、即已绑定
                strBindState = 2;
            }
            else
            {
                //未验证
                strBindState = 1;
            }
        }
        else
        {
            //未绑定IM30账号
            strBindState = 0;
        }
        //if (string.IsNullOrEmpty(GameEntry.Setting.GetString(GameDefines.SettingKeys.FB_USERID, "")) && string.IsNullOrEmpty(GameEntry.Setting.GetString(GameDefines.SettingKeys.GP_USERID, "")) && strBindState != 2)
        //{
        //    //所有方式未绑定
        //    strBindState = -1;
        //}
        //else
        //{
        //    //已绑定其他方式账号
        //    strBindState = 3;
        //}

        return strBindState;
    }


    public static bool AccountNeedBind()//账户是否需要绑定
    {

        string gpUid = GameEntry.Setting.GetString(GameDefines.SettingKeys.GP_USERID, "");
        string fbUid = GameEntry.Setting.GetString(GameDefines.SettingKeys.FB_USERID, "");
        string azName = GameEntry.Setting.GetString(GameDefines.SettingKeys.IM30_ACCOUNT, "");
        int azState = GameEntry.Setting.GetInt(GameDefines.SettingKeys.ACCOUNT_STATUS, 0);
        /*
        新的平台加进来在这里添加
        */
        bool accountNeedBind = true;
        if (!string.IsNullOrEmpty(gpUid) || !string.IsNullOrEmpty(fbUid) || azState == 1)//有一个绑定了，就返回不需要绑定了
        {
            accountNeedBind = false;
        }
        return accountNeedBind;
    }

    // 从origin开始到根的路径上，返回第一个类型为T的component，如果找不到返回null [2019/1/17 by wangrc]
    public static T GetAncestorComponent<T>(GameObject origin) where T : Component
    {
        if (origin == null)
            return null;

        Transform transform = origin.transform;
        while (transform != null)
        {
            T targetComponent = transform.GetComponent<T>();
            if (targetComponent != null)
                return targetComponent;
            else
                transform = transform.parent;
        }

        return null;
    }

    public static Transform GetFirstChild(Transform parent, string name)
    {
        if (parent == null)
        {
            return null;
        }

        Transform[] allChild = parent.GetComponentsInChildren<Transform>(true);

        for (int i = 0; i < allChild.Length; i++)
        {
            if (allChild[i].gameObject.name == name)
            {
                return allChild[i];
            }

        }

        return null;

    }

    //设置带图片的Text  例如： 消耗<quad/>水晶，<quad/>为水晶图片
        public static void SetTextWithImage(Text text, string des, Image image,int imageWidth = 0)
        {
            //实现思路是这样：用占位符使多语言空出图片大小，在计算占位符位置，设置图片位置  by shimin 2020.2.10
            string quad = "<color=#00000000><quad size={0} x=0 y=0 width=1 height=1 /></color>";
            if (imageWidth <= 0)
            {
                imageWidth = (int)image.rectTransform.sizeDelta.x;
            }
            quad = string.Format(quad, imageWidth);
            text.text = des.Replace("<quad/>", quad);
            //出来的点高度是0，手动算中点,加半个字的高度 这里不能直接+y 注意pos3和pos2的区别  

            image.transform.position = GetPosAtText(GameEntry.UIContainer.GetComponent<Canvas>(), text, quad);
            
            //还有个坑，占位符宽度大于字体，字会往下窜
            float fontSize = text.fontSize;
            float offset = fontSize > imageWidth ? 0 : imageWidth - fontSize;
            
            //这里有个坑英文的字体大小和需要显示的中点是不一样的 英文单词有4条线，显示在四分之三，实际中发现的 by shimin 2020.2.27
            image.rectTransform.anchoredPosition += new Vector2(0, offset + text.fontSize * 0.25f);
        }
        
        public static Vector3 GetPosAtText(Canvas canvas, Text text,string strFragment)
        {
            int strFragmentIndex = text.text.IndexOf(strFragment);//-1表示不包含strFragment
            Vector3 stringPos = Vector3.zero;
            if (strFragmentIndex>-1)
            {
                Vector3 firstPos = GetPosAtText(canvas, text, strFragmentIndex + 1);
                Vector3 lastPos= GetPosAtText(canvas, text, strFragmentIndex+strFragment.Length);
                stringPos = (firstPos + lastPos) * 0.5f;
            }
            else
            {
                stringPos= GetPosAtText(canvas, text, strFragmentIndex);
            }
            return stringPos;
        }

        /// <summary>
        /// 得到Text中字符的位置；canvas:所在的Canvas，text:需要定位的Text,charIndex:Text中的字符位置
        /// </summary>
        public static Vector3 GetPosAtText(Canvas canvas,Text text,int charIndex)
        {
            string textStr = text.text;
            Vector3 charPos = Vector3.zero;
            if (charIndex <= textStr.Length && charIndex > 0)
            {
                TextGenerator textGen = new TextGenerator(textStr.Length);
                Vector2 extents = text.gameObject.GetComponent<RectTransform>().rect.size;
                textGen.Populate(textStr, text.GetGenerationSettings(extents));

                int newLine = textStr.Substring(0, charIndex).Split('\n').Length - 1;
                int whiteSpace = textStr.Substring(0, charIndex).Split(' ').Length - 1;
                int indexOfTextQuad = (charIndex * 4) + (newLine * 4) - 4;
                if (indexOfTextQuad < textGen.vertexCount)
                {
                    charPos = (textGen.verts[indexOfTextQuad].position +
                               textGen.verts[indexOfTextQuad + 1].position +
                               textGen.verts[indexOfTextQuad + 2].position +
                               textGen.verts[indexOfTextQuad + 3].position) / 4f;
                    //0：左上 1：右上 2：右下 3：左下
                    //这里不取高度中点，取下方点
                }
            }
            charPos /= canvas.scaleFactor;//适应不同分辨率的屏幕
            charPos = text.transform.TransformPoint(charPos);//转换为世界坐标
            return charPos;
        }
        
        public static float PlayAnimationReturnTime(SimpleAnimation anim, string animName)
        {
            var aniState = anim.GetState(animName);
            if (aniState != null)
            {
                anim.Stop();
                anim.Play(animName);
                return aniState.length;
            }

            return -1;
        }

        public static float PlayAnimationReturnTime(Animator anim,string animName)
        {
            var clips = anim.runtimeAnimatorController.animationClips;
            for (int i = 0; i < clips.Length; ++i)
            {
                if (clips[i].name.EndsWith(animName))
                {
                    anim.Play(animName,0,0);
                    return clips[i].length;
                }
            }

            return -1;
        }

        public static float PlayAnimationReturnTime(GPUSkinningAnimator anim, string animName)
        {
            anim.Play(animName);
            return anim.GetClipLength(animName);
        }

        public static Vector2Int GetCurScreenMaxRadiusSize()
        {
            var posWorld = SceneManager.World.WorldToTile(SceneManager.World.ScreenPointToWorld(Vector3.zero));
            var cur = SceneManager.World.CurTilePos;
            return cur - posWorld;
        }
    
        //获取当前屏幕内可降落砸罩子的点（从内向外）
        public static BuildPointInfo GetBuildPointByMeteoriteHitGlass()
        {
            return null;
        }
}