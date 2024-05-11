using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityGameFramework.Runtime;
using UnityGameFramework.SDK;
using LitJson;
using System.Threading;
using Sfs2X.Entities.Data;
using System;
using System.Collections.Concurrent;
using GameFramework;

public struct MailDialogStruct
{
    public string MailUid;
    public string DialogUid;
    public bool HadTranslate;
}

public struct ChatTranslateStruct
{
    public string roomId;
    public int seqId;
}

[Serializable]
public struct TranslateResult
{
    public int code;
    public string originalLang;
    public string targetLang;
    public string translateMsg;
}

//翻译系统
public class TranslateManager
{
    #region 单例
    private static TranslateManager _instance;
    public static TranslateManager Instance
    {
        get
        {
            if (null == _instance)
            {
                _instance = new TranslateManager
                {
                    version = GameEntry.Sdk.Version
                };
            }

            return _instance;
        }
    }

    public static void Purge()
    {
        _instance = null;

    }

    public string version;


    #endregion

    //mail翻译队列
    private string mTransMailID = null;
    private List<string> mTransMailQueue = new List<string>();

    // mailDialog
    private string mDialogMailID = string.Empty;
    private string mDialogID = string.Empty;
    //private List<MailDialogStruct> mMailDialogList = new List<MailDialogStruct>();
    //保证线程安全换为安全队列
    private ConcurrentQueue<MailDialogStruct> mMailDialogs = new ConcurrentQueue<MailDialogStruct>();
    private static object _dialoglock = new object();

    // chat
    private string mChatRoomId = string.Empty;
    private int mChatSeqId;
    private readonly List<ChatTranslateStruct> mChatDataList = new List<ChatTranslateStruct>();



    public string GetLangString(string str)
    {
        if (str == "zh-CN" || str == "zh_CN" || str == "zh-Hans" || str == "zh-CHS" || str == "cn")
        {
            return "zh-Hans";

        }
        else if (str == "zh-TW" || str == "zh_TW" || str == "zh-Hant" || str == "zh-CHT" || str == "tw")
        {
            return "zh-Hant";
        }
        return str;
    }

    //翻译语言
    public string TranslateLang(string originLang, string content, string targetLand, string scene = "private")
    {
#if OLD_PACK
        string url = "https://translate.im30app.com/v3/client.php";
        bool isMiddleEast = false;//GlobalData::shared()->isMiddleEast();
        if (isMiddleEast)
        {
            url = "http://app1.im.medrickgames.com:8083/v3/client.php";
        }
#else
        string url = "https://translate.im30app.com/v3/client.php";
        bool isMiddleEast = false;//GlobalData::shared()->isMiddleEast();
        if (isMiddleEast)
        {
            url = "http://app1.im.medrickgames.com:8083/v3/client.php";
        }
#endif

        //Debug.Log("TranslateLang url:" + url);

        string timeStamp = (GameEntry.Timer.GetServerTime() / 1000).ToString();
        string tarL = GetLangString(targetLand);
        string oriL = GetLangString(originLang);

        string sid = GameEntry.Data.Player.GetSelfServerId().ToString();
        string ui = "";
        ui += GameEntry.Data.Player.Uid;
        ui += ",";
        ui += sid;
        ui += ",";

        // 分线程中调用主线程方法会抛异常
        //string _version = MiddleManager.Instance.getVersionName();
        //string _version = version;
        ui += version;

        //string scene = "alliance";
        string pUid = GameEntry.Data.Player.Uid;

#if OLD_PACK
        string channel = "lastshelter";
#else
        string channel = "ds";
#endif

        string md5Str = "";
        md5Str += oriL;
        md5Str += tarL;
        md5Str += channel;
        md5Str += timeStamp;
        // md5Str += GameEntry.Data.Player.translateKey;
        md5Str += pUid;
        string md5 = AESHelper.GetMd5Hash(md5Str);

        string urlParams = "sc=" + content + "&sf=" + oriL + "&tf=" + tarL + "&ch=" + channel + "&t=" + timeStamp + "&ui=" + ui + "&scene=" + scene + "&sig=" + md5 + "&uid=" + pUid;
		Log.Debug("TranslateLang data:" + urlParams);

        return ""; // HttpHelperUtils.HttpPostData(url, urlParams);
    }

    //Google 翻译
    public void GoogleTransLateNormal(string originalLang, string content, string targeLand)
    {
        string result = TranslateLang(originalLang, content, targeLand);
		Log.Debug("TranslateLang resp:" + result);

        try
        {
            JsonData jsonData = JsonMapper.ToObject(result);
            if (jsonData == null)
            {
                return;
            }

            int code = (int)jsonData["code"];
            if (code != 0)
            {
                string errorMsg = "invalid account.";
                if (((IDictionary)jsonData).Contains("message"))
                {
                    errorMsg = (string)jsonData["message"];
                }
                UIUtils.ShowTips(errorMsg);
                return;
            }

            string final = "";
            if (((IDictionary)jsonData).Contains("translateMsg"))
            {
                final = (string)jsonData["translateMsg"];
            }

            string orgLan = "";
            if (((IDictionary)jsonData).Contains("originalLang"))
            {
                orgLan = (string)jsonData["originalLang"];
            }

            GameEntry.Event.Fire(EventId.Translate_Normal, final);
        }
        catch (System.Exception e)
        {
            Debug.LogWarning(e);
        }

    }

    //google translate Mail
    public void GoogleTranslateByMail()
    {
#if false
        if (string.IsNullOrEmpty(mTransMailID))
                {
                    return;
                }
        
                var curMailInfo = GameEntry.Data.Mail.GetMail(mTransMailID);
                if (curMailInfo == null)
                {
                    mTransMailID = "";
                    OnGoogleTranslateFail();
                    return;
                }
        
                string targeLand = GameEntry.Localization.GetLanguageName();
                string orgContent = curMailInfo.contents;
        		
                string orL = GetLangString(curMailInfo.translationId);
                Log.Debug("翻译： " + orL);
        		string result = TranslateLang(orL, orgContent, targeLand);
                try
                {
                    JsonData jsonData = JsonMapper.ToObject(result);
                    if (jsonData == null)
                    {
                        OnGoogleTranslateFail();
                        return;
                    }
        
                    int code = (int)jsonData["code"];
                    if (code != 0)
                    {
                        OnGoogleTranslateFail();
                        return;
                    }
        
                    OnGoogleTranslateSuccess(jsonData);
                }
                catch (System.Exception e)
                {
                    OnGoogleTranslateFail();
                    Debug.LogWarning(e);
                }
#endif
    }

    protected void OnGoogleTranslateSuccess(JsonData data)
    {
#if false
        if (string.IsNullOrEmpty(mTransMailID))
                {
                    GameEntry.Event.Fire(EventId.Translate_Mail);
                    return;
                }
        
                var curMailInfo = GameEntry.Data.Mail.GetMail(mTransMailID);
                if (curMailInfo == null)
                {
                    mTransMailID = "";
                    GameEntry.Event.Fire(EventId.Translate_Mail);
                    return;
                }
        
                if (!((IDictionary)data).Contains("translateMsg"))
                {
                    OnGoogleTranslateFail();
                    GameEntry.Event.Fire(EventId.Translate_Mail);
                    return;
                }
        
                string final = (string)data["translateMsg"];
                curMailInfo.translatedContents = final;
                //Debug.Log("翻译的内容：" + final);
                //curMailInfo.showOriginal = false;
                mTransMailID = "";
        
                GameEntry.Event.Fire(EventId.Translate_Mail);
#endif
    }

    protected void OnGoogleTranslateFail()
    {
        mTransMailID = "";
        GameEntry.Event.Fire(EventId.Translate_Mail);
    }

    public void GoogleTranslateByDialog()
    {
#if false
        if (string.IsNullOrEmpty(mDialogMailID) || string.IsNullOrEmpty(mDialogID))
                {
                    OnGoogleTranslateDialogFail();
                    return;
                }
        
        		ChatMergeMail curMailInfo = GameEntry.Data.Mail.GetMail(mDialogMailID) as ChatMergeMail;
                if (curMailInfo == null)
                {
                    OnGoogleTranslateDialogFail();
                    return;
                }
        
        		string targeLand = GameEntry.Localization.GetLanguageName();
                MailDialogInfo dialog = curMailInfo.dialogs.Find(p => p.uid == mDialogID);
                if (dialog == null)
                {
                    OnGoogleTranslateDialogFail();
                    return;
                }
                string orgContent = dialog.contents;
        ;
                string orL = GetLangString(curMailInfo.translationId);
                string result = TranslateLang(orL, orgContent, targeLand);
                try
                {
                    JsonData jsonData = JsonMapper.ToObject(result);
                    if (jsonData == null)
                    {
                        OnGoogleTranslateDialogFail();
                        return;
                    }
        
                    int code = (int)jsonData["code"];
                    if (code != 0)
                    {
                        OnGoogleTranslateDialogFail();
                        return;
                    }
        
                    OnGoogleTranslateDialogSuccess(jsonData);
                }
                catch (System.Exception e)
                {
                    OnGoogleTranslateDialogFail();
                    Debug.LogWarning(e);
                }
#endif
    }

    protected void OnGoogleTranslateDialogSuccess(JsonData jsonData)
    {

#if false
        if (string.IsNullOrEmpty(mDialogMailID) || string.IsNullOrEmpty(mDialogID))
                {
        			OnGoogleTranslateDialogFail();
                    return;
                }
        
        		ChatMergeMail curMailInfo = GameEntry.Data.Mail.GetMail(mDialogMailID) as ChatMergeMail;
                if (curMailInfo == null)
                {
        			OnGoogleTranslateDialogFail();
                    return;
                }
        
        		if (!((IDictionary)jsonData).Contains("translateMsg"))
                {
        			OnGoogleTranslateDialogFail();
                    return;
                }
        
        		string final = (string)jsonData["translateMsg"];
        
                MailDialogInfo dialog = curMailInfo.dialogs.Find(p => p.uid == mDialogID);
                if (dialog == null)
                {
        			OnGoogleTranslateDialogFail();
                    return;
                }
        
        		lock (_dialoglock)
        		{
        			Log.Debug("翻译成功 :" + jsonData.ToJson());
        
        			dialog.translationMsg = final;
        
        			MailDialogStruct temp = new MailDialogStruct();
        			temp.DialogUid = mDialogID;
        			temp.MailUid = mDialogMailID;
        			temp.HadTranslate = true;
                    mMailDialogs.Enqueue(temp);
        			//mMailDialogList.Add(temp);
        		}
#endif

    }

    protected void OnGoogleTranslateDialogFail()
    {
        GameEntry.Event.Fire(EventId.Translate_Dialog);
        mDialogID = string.Empty;
        mDialogMailID = string.Empty;
    }

    public void GoogleTranslateByChat()
    {
        if (string.IsNullOrEmpty(mChatRoomId) || mChatSeqId == 0)
        {
            OnGoogleTranslateByChatFailure();
            return;
        }
        

        OnGoogleTranslateByChatFailure();
    }

    void OnGoogleTranslateByChatSuccess(TranslateResult result)
    {
        if (string.IsNullOrEmpty(mChatRoomId) || mChatSeqId == 0)
        {
            OnGoogleTranslateByChatFailure();
            return;
        }

        if (string.IsNullOrEmpty(result.translateMsg))
        {
            OnGoogleTranslateByChatFailure();
            return;
        }
        

        mChatSeqId = 0;
        mChatRoomId = "";
    }

    void OnGoogleTranslateByChatFailure()
    {
        mChatSeqId = 0;
        mChatRoomId = "";
    }

    public void OnEnterFrame()
    {
        OnMailTranslate();
        OnDialogTranslate();
        OnChatTranslate();
    }

    //mail相关翻译
//    public void AddMailTranslate(MailInfo info)
//    {
//        if (info == null /*|| !string.IsNullOrEmpty(info.translatedContents)*/)
//        {
//            return;
//        }
//
//        mTransMailQueue.Add(info.uid);
//    }

    protected void OnMailTranslate()
    {
        if (!string.IsNullOrEmpty(mTransMailID) || mTransMailQueue.Count <= 0)
        {
            return;
        }

        mTransMailID = mTransMailQueue[0];
        mTransMailQueue.RemoveAt(0);
        TranslateUtils.OnThreadGoogleTranslateByMail();
    }


    public void AddMailMailDialog(MailDialogStruct mailDialog)
    {
        mMailDialogs.Enqueue(mailDialog);
		//mMailDialogList.Add(mailDialog);
    }

    protected void OnDialogTranslate()
    {
        //注意这里了使用isEmpty  而不是判断count == 0
        if (mMailDialogs.IsEmpty)
        {
            return;
        }

        MailDialogStruct dialog = new MailDialogStruct();

        if (mMailDialogs.TryDequeue(out dialog))
        {
            if (dialog.HadTranslate)
            {
                Log.Debug("OnDialogTranslate --finsh -- :"+ dialog.MailUid);
                GameEntry.Event.Fire(EventId.Translate_Dialog, dialog);
            }
            else
            {
                Log.Debug("OnDialogTranslate --begin -- :" + dialog.MailUid);
                Log.Debug("OnDialogTranslate --begin -- :" + dialog.DialogUid);
                mDialogMailID = dialog.MailUid;
                mDialogID = dialog.DialogUid;
                TranslateUtils.OnThreadGoogleTranslateByDialog();
            }  
        }
    }

    public void AddChat(ChatTranslateStruct chat)
    {
        mChatDataList.Add(chat);
    }

    private void OnChatTranslate()
    {
        if (mChatSeqId != 0 || mChatDataList.Count <= 0)
            return;

        mChatSeqId = mChatDataList[0].seqId;
        mChatRoomId = mChatDataList[0].roomId;
        mChatDataList.RemoveAt(0);
        TranslateUtils.OnThreadGoogleTranslateByChat();
    }
}

//翻译Utils - 多线程处理
public static class TranslateUtils
{
    //线成锁
    public static readonly object LockerNormal = new object();
    public static readonly object LockerByMail = new object();
    public static readonly object LockerByDialog = new object();
    public static readonly object lockerByChat = new object();

    public static void ThreadMethodNormal(object parameter)
    {
        lock (LockerNormal)
        {
            if (parameter != null)
            {
                ISFSObject dict = parameter as SFSObject;
                if (dict != null)
                {
                    string originalLang = dict.TryGetString("original");
                    string content = dict.TryGetString("content");
                    string targeLand = dict.TryGetString("land");

                    TranslateManager.Instance.GoogleTransLateNormal(originalLang, content, targeLand);
                }
            }
        }

        //终止当前线程
        Thread.CurrentThread.Abort();
    }

    public static void OnThreadGoogleTransLateNormal(string originalLang, string content, string targeLand)
    {
        Thread thread = new Thread(ThreadMethodNormal);

        ISFSObject dict = new SFSObject();
        dict.PutUtfString("original", originalLang);
        dict.PutUtfString("content", content);
        dict.PutUtfString("land", targeLand);

        //在此方法内传递参数，类型为object，发送和接收涉及到拆装箱操作
        thread.Start(dict);
    }


    //多线程，
    public static void ThreadMethodByMail()
    {
        lock (LockerByMail)
        {
            TranslateManager.Instance.GoogleTranslateByMail();
        }

        //终止当前线程
        Thread.CurrentThread.Abort();
    }

    public static void OnThreadGoogleTranslateByMail()
    {
        Thread thread = new Thread(ThreadMethodByMail);
        thread.Start();
    }


    //多线程，
    public static void ThreadMethodByDialog()
    {
        lock (LockerByDialog)
        {
			//Debug.Log("---ThreadMethodByDialog---");
            TranslateManager.Instance.GoogleTranslateByDialog();
        }

        //终止当前线程
        Thread.CurrentThread.Abort();
    }

    public static void OnThreadGoogleTranslateByDialog()
    {
        Thread thread = new Thread(ThreadMethodByDialog);
        thread.Start();
    }

    private static void ThreadMethodByChat()
    {
        lock (lockerByChat)
        {
            TranslateManager.Instance.GoogleTranslateByChat();
        }

        Thread.CurrentThread.Abort();
    }

    public static void OnThreadGoogleTranslateByChat()
    {
        Thread thread = new Thread(ThreadMethodByChat);
        thread.Start();
    }
}
