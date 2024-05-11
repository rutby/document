using System.Collections.Generic;
using Sfs2X.Entities.Data;
using UnityEngine;
using UnityGameFramework.Runtime;

#if true
public class GlobalDataManager
{
    public GlobalDataManager()
    {
        version = Application.version;
    }
    
    public struct LoginServerInfo
    {
        public int country;
        public int recommandCountry;
    }
    //
    // public bool m_loading_loginGP_success;
    //
    // #region LoginMessage Response
    // public int db_timezone_offset = 0;
    // public int db_utc_timestamp = 0;
    public string download_video_url = "";
    public string download_video_url2 = "";
    public string downloadurlcdn = "";
    public string downloadurl = "";
    public int eu_state = 0;
    public string fblikeutil = "";
    public int force_merge = 0;
    public int force_use_downloadxml = 0;
    private bool isCN = false;
    public string lua = "";
    public string luaCode = "";
    public string luaCode_v3 = "";
    public int luaSize = 0;
    public string luaVersion = "";
    public string luaVersion_v3 = "";
    public int luazipSize = 0;
    public int randKey = 0;
    public int reduce_init_data = 0;
    public string serverVersion = ""; //最新客户端版本号
    // public SFSArray update = null;
    public int updateType = 0; //0: 不更新；1:建议更新apk；2：强制更新apk; 3:更新xml 15s内下载不完也直接进游戏  4强更xml,必须下载完才能进入游戏。
    public string upload_video_url = "";
    public string xmlVersion = ""; //最新xml版本号
    // #endregion

    #region LoginMessage Request
    public LoginServerInfo loginServerInfo;
    public string gcmRegisterId = "";//GCM注册ID
    public string referrer = "";//广告来源数据
    public string deeplinkParams = "";//deep link params
    public string AndroidID = "";//android_id
    public string IMEI = "";//IMEI
    /// <summary>
    /// 好奇怪,analyticID = 渠道标识
    /// GlobalData::shared()->analyticID = cocos2d::extension::CCDevice::getPublishRegion();
    /// </summary>
    public string analyticID = "";//mycard 发布平台 91 google 360.
    /// <summary>
    /// 谷歌服务是否可用 是否支持谷歌支付
    /// </summary>
    public bool s_isGooglePlayAvailable;
    public string platformUID = "";//平台UID
    public string parseRegisterId = "";//Parse注册ID
    public string fromCountry = "US";//国家
    public string gaid = "";//adjust 发奖依据
    #endregion

    public bool isTodayFirstLogin; //是否今日第一次登陆
    // public bool isClickMonthCardPop;//月卡相关
    // public bool isLoginFlag;       //登陆login：true
    // public bool isInitFlag;        //是否解析PUSHINIT完成
    // public bool isPause;
    // public string isBind;//绑定状态
    // public string isPayBind;//绑定状态
    //
    // //public ForbidRemoveAllView forbidRemove;//购买完成后弹出支付
    // public bool historyPurchaseChecked;//历史订单每次开游戏只检查一次
    // public bool isXMLInitFromServerFlag;//是否初始化过下载的xml文件
    // public bool isFirstLoginGame; // 是否是新用户登录！
    // public bool translation;//是否开启自动翻译
    // public bool mail_translation;//是否开启邮件的自动翻译
    //
    // //public worldRewardList m_worldDiamondList;//世界刷新钻石矿数据
    // //public sRankInfo m_sRankInfo;//世界联盟数据
    public bool isNewServer;    //是否是新开的服务器
    // public bool showFaceBookUi;//是否显示facebook入口
    // public bool isBindAcount; //是否绑定了账号

    public string version;//前台版本号
    // public string usingXmlVersion;//正在使用的xml版本号
    // public string lang;//语言
    public string uuid;// uuid
    // public string platform;//系统平台 ios ad
    // public string GPPlayerID;//google的games的玩家登陆ID
    // public string GPPlayerName;//google的games的玩家登陆name
    // public string platformChannel;//warz渠道登陆平台
    public string gaidCache;//android读取到gaid以后缓存起来
    // public string deeplinkPostUid;//deep link post uid
    // public long pauseTime;//暂停时间
    // public int activityPop;  // 弹出活动标记
    // public bool isInDataParsing;
    public bool isUploadPic;//是否在上传照片
    // public bool isOpenTaiwanFlag;//大陆看台湾国旗开关1开0关
    // public bool isFinshArCameraState;
    public bool isOpenElvaChat;//是否在智能客服聊天中
    public bool isFAQVoteResp;//是否在回答问卷调查
    public int cityTileCountry;   // 当前城市地块的类型。
    //
    // public bool accFlag;
    public int serverType;
    public int serverMax;
    // public bool accFlagNow;
    // public bool statNewGame;
    // public int chinaSwitchFlag;//大陆显示国旗开关 0不变 1为将五星红旗显示为纯红色旗子 2为不显示国旗
    
    // public bool exchange_switch;//是否启用滑动GoldExchangeView
    // public bool m_3dworld_switch; //是否开启3d效果

    // public List<GotoUtilsInfo> gotoUtilsInfos = new List<GotoUtilsInfo>();//云打开之后调用
    // public List<GotoUtilsInfo> gotoUtilsInfosBefore = new List<GotoUtilsInfo>();//云打开之前调用
    //
    // public int[] fire = new int[3];
    // public int[] fire1 = new int[4];
    //
    // public bool showGMInfo;
    //
    public int nowGameCnt = 0; //当前设备创建的新账号的数量
    //
    public int freeSpdT;
    //
    public int TeleportLimitTime = 72;
    //
    public bool TransResForbiddenSwith;
    //
    public int NewTransKingdomLevel = 6;
    //
    public bool IsCityMoved = true;

    public bool pushOffWithQuitGame = false;//是否被踢标识
    
    public bool isInBackGround = false; //游戏是否在后台
    
    public void Init(ISFSObject dict)
    {
        if (dict.ContainsKey("gaid"))
        {
            gaid = dict.GetUtfString("gaid");
        }
    }

    public void SetAnalyticID()
    {
        analyticID = GameEntry.Sdk.GetPublishRegion();
    }

    public void SetCnFlagFromServer(bool isCn)
    {
        isCN = isCn;
    }

    Dictionary<string, object> gGlobalValue = new Dictionary<string, object>();

    public void Reset()
    {
        gGlobalValue.Clear();
    }

    // 获取一个Value的引用，有可能为Value::null
    public object GetGlobalValue(string key)
    {
        //Todo GetGlobalValue
        List<string> vPos = key.ToStrList('/');
        if (vPos == null || vPos.Count == 0)
        {
            return null;
        }
        int backIdx = vPos.Count - 1;
        string backStr = vPos[backIdx];//  vPos.back();
        vPos.RemoveAt(backIdx); //vPos.pop_back();
        if (gGlobalValue.ContainsKey(key))
        {
            return gGlobalValue[key];
        }
        return new object();

    }

    public bool SetGlobalValue(string key, object value)
    {
        //Todo SetGlobalValue
        List<string> vPos = key.ToStrList('/');

        if (vPos == null || vPos.Count == 0)
        {
            return false;
        }

        int backIdx = vPos.Count - 1;
        string backStr = vPos[backIdx];//  vPos.back();
        vPos.RemoveAt(backIdx); //vPos.pop_back();

        gGlobalValue[key] = value;
        return true;
    }

    public void recordGaid()
    {
        if (gaid.IsNullOrEmpty())
        {
            if (!gaidCache.IsNullOrEmpty() && !gaidCache.Equals("missed"))
            {
                gaid = gaidCache;
                UserBindGaidMessage.Instance.Send(new UserBindGaidMessage.Request(){gaid = gaid});
            }
            else
            {
                gaidCache = "missed";
            }
        }
    }

    // google
    public bool isGoogle()
    {
        if (analyticID == "market_global"/* && s_isGooglePlayAvailable*/)
            return true;
        return false;
    }
    // 检查是否是google包
    public bool isGoogleOnlyCheckAnalyticID()
    {
        return false;
    }
    // 中国包
    public bool isChina()
    {
        return isCN;
    }
    // 中东
    public bool isMiddleEast()
    {
        return false;
    }
    // 应用宝
    public bool isTencent()
    {
        return false;
    }
    // amazon
    public bool isAmazon()
    {
        return false;
    }
    // mol
    public bool isMol()
    {
        return false;
    }
    // mycard
    public bool isMycard()
    {
        return false;
    }
    // onestore
    public bool isOnestore()
    {
        return false;
    }
}

#endif

