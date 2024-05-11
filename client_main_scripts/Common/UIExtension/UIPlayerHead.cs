using System.IO;
using Sfs2X.Entities.Data;
using UnityEngine;
using UnityEngine.UI;

[AddComponentMenu("UI/UIPlayerHead")]
//[RequireComponent(typeof(CircleImage))]
public class UIPlayerHead : MonoBehaviour
{
    private const string UserHeadPath = "Assets/Main/Sprites/UI/UIHeadIcon/";
    private const string DefaultUserHead = "Assets/Main/Sprites/UI/Common/New/Common_icon_player_head_big";//UserHeadPath + "g044.png";
    private const string CACHE_FOLDER = "LocalImages";
    
    private CircleImage _circleImage;
    private SpriteRenderer _spriteRenderer;
    private string playerUid;
    private string playerPic;
    private int playerPicVer;
    private bool useBig;
    private bool needRelease;
    private System.Action customLoadCallback;//切换自定义头像完成后回调
    
    private void Awake()
    {
        _circleImage = GetComponent<CircleImage>();
        _spriteRenderer = GetComponent<SpriteRenderer>();

    }
    
    public void SetData(string uid, string pic, int picVer, bool useBig = false)
    {
        if (_circleImage == null && _spriteRenderer == null)
        {
            _circleImage = GetComponent<CircleImage>();
            _spriteRenderer = GetComponent<SpriteRenderer>();
        }
        //Debug.Log($"#UIPlayerHead# SetData uid:{uid}, pic:{pic}, picVer:{picVer}, useBig:{useBig}");
        playerUid = uid;
        playerPic = pic;
        playerPicVer = picVer;
        this.useBig = useBig;
        
        LoadHeadInternal();
    }

    public void SetCustomLoadCallback(System.Action action)
    {
        customLoadCallback = action;
    }

    private void LoadHeadInternal()
    {
        if (IsSystemHead() || ! GenCustomPicUrl(playerUid, playerPicVer, out var url, out var cacheKey, useBig))
        {
            UseSystemHead();
            return;
        }

        //本地没有时 先设为默认头像 下载完成后再切换为自定义头像
        var needSetDefaultFirst = !url.StartsWith("file://"); 
        
        //如果本地没有大图资源 检查本地是否有小图资源 如果有 则先显示小图同时开启大图下载 否则直接走大图下载逻辑
        if (useBig && ! url.StartsWith("file://"))
        {
            var ret = GenCustomPicUrl(playerUid, playerPicVer, out var smallUrl, out var smallCacheKey, false);
            if (ret && smallUrl.StartsWith("file://"))
            {
                //本地无大图有小图时 先用小图显示
                needSetDefaultFirst = false;
                DynamicResourceManager.Instance.LoadTextureFromURL(smallUrl, false, smallCacheKey, OnLoadCallBack, CACHE_FOLDER, playerUid);
            }
        }
        
        // string picVer = string.Format("{0}", playerPicVer);
        // UploadImageManager.Instance.DownloadHeadImage("http://10.7.88.22:89/img/", playerUid, picVer,
        //     (string ret, string reason) =>
        //     {
        //         int a = 0;
        //     });
        //
        //通过WebRequestTexture加载本地或远程的文件
        if (needSetDefaultFirst)
        {
            UseSystemHead();
        }
        
        DynamicResourceManager.Instance.LoadTextureFromURL(url, false, cacheKey, OnLoadCallBack, CACHE_FOLDER, playerUid);
    }
    
    private void OnLoadCallBack(string key, Object asset, object userdata)
    {
        if (playerUid != (string)userdata)
            return;

        if (_circleImage == null && _spriteRenderer == null)
        {
            return;
        }

    
        
        if (asset != null && asset is Texture2D texture)
        {
            ReleaseCurrentSprite();
            if (_circleImage != null)
            {
                _circleImage.sprite = Sprite.Create(texture, new Rect(0, 0, texture.width, texture.height), Vector2.zero);
            }
            else if (_spriteRenderer != null)
            {
                _spriteRenderer.sprite = Sprite.Create(texture, new Rect(0, 0, texture.width, texture.height), new Vector2(0.5f,0.5f));
            }
            
            needRelease = true;
            
            customLoadCallback?.Invoke();
        }
        else
        {
            UseSystemHead();
        }
    }

    //FiXME:上次通过Create生成的Sprite怎么释放
    private void ReleaseCurrentSprite()
    {
        if (needRelease)
        {
            //Destroy(image.sprite.texture); //Dynamic做了缓存，这里先不释放了
            if (_circleImage != null)
            {
                Destroy(_circleImage.sprite);
            }
            else if (_spriteRenderer != null)
            {
                Destroy(_spriteRenderer.sprite);
            }
            
            needRelease = false;
        }
    }
    
    public void UseSystemHead()
    {
        ReleaseCurrentSprite();
        if (playerPic.IsNullOrEmpty())
        {
            if (_circleImage != null)
            {
                _circleImage.LoadSprite(DefaultUserHead);
            }
            else if(_spriteRenderer!=null)
            {
                _spriteRenderer.LoadSprite(DefaultUserHead);
            }

            return;
        }
        if (_circleImage != null)
        {
            _circleImage.LoadSprite(UserHeadPath + playerPic, DefaultUserHead);
        }
        else if(_spriteRenderer!=null)
        {
            _spriteRenderer.LoadSprite(UserHeadPath + playerPic, DefaultUserHead);
        }
    }
    
    private bool IsSystemHead()
    {
        return !playerPic.IsNullOrEmpty() || playerPicVer <= 0 || playerPicVer > 1000000;
    }
    
    public static bool GenCustomPicUrl(string uid, int picVer, out string url, out string key, bool useBig = false)
    {
        url = "";
        key = "";
        string md5Str =  $"{uid}_{picVer}";
        string md5 = AESHelper.GetMd5Hash(md5Str);

        // 取uid末尾6位
        string tempStr = uid;
        if (tempStr.Length > 6)
        {
            tempStr = tempStr.Substring(tempStr.Length - 6);
        }

        var suffix = useBig ? "_big" : "";
        key = $"{tempStr}/{md5}{suffix}.jpg";
        
        string cachePath = Path.Combine(Application.persistentDataPath, CACHE_FOLDER, key);
        if (File.Exists(cachePath))
        {
            url = "file://" + cachePath;
            return true;
        }

        if (CommonUtils.IsDebug())
        {
            url = "http://10.7.88.22:89/img/" + key;
        }
        else
        {
            if (GameEntry.GlobalData.isMiddleEast())
            {
                const string HEAD_URL_MID = "http://10.7.88.22:89/img/";
                url = HEAD_URL_MID + key;
            }
            else
            {
                const string HEAD_URL = "https://cdn-ds.readygo.tech/img/";
                url = HEAD_URL + key;
            }
        }

        return true;
    }
    
    private void OnEnable()
    {
        GameEntry.Event.Subscribe(EventId.UpdateHeadImg, OnHeadInfoChanged);
    }

    private void OnDisable()
    {
        GameEntry.Event.Unsubscribe(EventId.UpdateHeadImg, OnHeadInfoChanged);
    }

    private void OnHeadInfoChanged(object userData)
    {

        if(!(userData is SFSObject param))
            return;
        
        var uid = param.GetUtfString("uid");
        var pic = param.GetUtfString("pic");
        var picVer = param.GetInt("picVer");

        //Debug.Log($"#UIPlayerHead# OnHeadInfoChanged uid:{uid}, pic:{pic}, picVer:{picVer}");
        if (playerUid != uid)
        {
            return;
        }

        playerPic = pic;
        playerPicVer = picVer;
        LoadHeadInternal();
    }
}
