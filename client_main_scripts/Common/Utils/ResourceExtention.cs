using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public static class ResourceExtention
{
    private const string DefaultUserHeadAtlasAsset = GameDefines.AtlasAssets.PlayerHeadIcons;
    private const string UserHeadPath = "Assets/Main/Sprites/UI/UIHeadIcon/";
    private const string DefaultUserHead = UserHeadPath + "g044.png";


    private static readonly Dictionary<Object, string> m_UrlInLoading = new Dictionary<Object, string>();

    public static void LoadHeadEx(this Image image, string uid, string pic, int picVer)
    {
        if (image == null)
        {
            return;
        }

        if (string.IsNullOrEmpty(uid) || !UrlUtils.IsUseCustomPic(picVer))
        {
            image.LoadSprite(UserHeadPath + pic, DefaultUserHead);
        }
        else
        {
            UrlUtils.GenCustomPicUrl(uid, picVer, out string url, out string cacheKey);
            
            m_UrlInLoading[image] = uid;
            DynamicResourceManager.Instance.LoadTextureFromURL(url, false, cacheKey, (key, obj, userdata) =>
            {
                if (image != null)
                {
                    if (m_UrlInLoading.ContainsKey(image) && m_UrlInLoading[image] == userdata.ToString()) // 回调的UID的记录的uid一致时才赋值
                    {
                        m_UrlInLoading.Remove(image);

                        if (obj != null && obj is Texture2D texture)
                        {
                            image.sprite = Sprite.Create(texture, new Rect(0, 0, texture.width, texture.height), Vector2.zero);
                            image.gameObject.SetActive(true);
                        }
                        else
                        {
                            image.LoadSprite(UserHeadPath + pic, DefaultUserHead);
                        }
                    }
                }
                else
                {
                    m_UrlInLoading.Remove(image);
                }
            }, "Images/heads", uid);
        }
    }
}
