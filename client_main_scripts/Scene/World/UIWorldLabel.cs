using System;
using BestHTTP.SecureProtocol.Org.BouncyCastle.Crypto.Engines;
using GameFramework;
using UnityEngine;

//
// 世界物体的名字UI
// 用于城市，资源，怪物，联盟等名称显示
//

public class UIWorldLabel : MonoBehaviour
{
    [SerializeField]
    private new SuperTextMesh name;

    [SerializeField]
    private SpriteRenderer nameTitle;
    
    [SerializeField]
    private SuperTextMesh level;
    

    [SerializeField]
    private SpriteRenderer nameBg;

    private int nameBGType;
    
    private SpriteRenderer _directionImage;
    private SuperTextMesh _directionLevel;

    private SpriteRenderer _campSprite;
    //建筑显示等级类型
    public enum LevelShowType
    {
        Normal, //100级以下
        Direction, //显示方向
    }
    private LevelShowType _levelShowType = LevelShowType.Normal;
    //称号相关
    private static readonly string DirectionImagePathName = "DirectionLevelLabel";
    private static readonly string DirectionLevelPathName = "DirectionLevelLabel/DirectionLevelText";
    private static readonly Vector3 TitleBgScale = new Vector3(0.3f, 0.3f, 0.3f);//称号缩放
    private static readonly float TitleBgMinSizeX = 3.13f;//称号最小尺寸x
    private static readonly float TitleBgMinSizeY = 1.09f;//称号固定尺寸Y
    private static readonly Vector3 TitleNamePos = new Vector3(0.4f, -0.08f, 0f);//称号名字位置偏移
    private static readonly float TitleBgSizeDeltaX = 1.5f;//称号图片尺寸偏移
    private static readonly string DefaultBgName = "appellation_icon_arena";//默认无称号背景板

    private void Awake()
    {
        var directionGo = transform.Find(DirectionImagePathName);
        if (directionGo != null)
        {
            _directionImage = directionGo.GetComponent<SpriteRenderer>();
            var directionLevelGo = transform.Find(DirectionLevelPathName);
            if (directionLevelGo != null)
            {
                _directionLevel = directionLevelGo.GetComponent<SuperTextMesh>();
            }
        }
        _campSprite = transform.Find("NameLabel/edenCampIcon")?.GetComponent<SpriteRenderer>();
        if (_campSprite != null)
        {
            _campSprite.gameObject.SetActive(false);
        }
    }

    public void SetLevel(int l)
    {
        _levelShowType = LevelShowType.Normal;
        SetCityLevelLabelActive(true);
        SetDirectionLevelLabelActive(false);
        if (level == null)
        {
            return;
        }
        
        level.text = l.ToString();
    }

    public void SetCamp(int camp)
    {
        if (_campSprite != null)
        {
            var path = "Assets/Main/Sprites/LodIcon/eden_camp_" + camp;
            _campSprite.gameObject.SetActive(true);
            _campSprite.LoadSprite(path);
        }
    }
    public void SetLevel(int l, Color color)
    {
        if (level == null)
        {
            return;
        }
        
        level.text = l.ToString();
        level.color32 = color;
    }

    public void SetName(string n)
    {
        if (name == null)
        {
            return;
        }
        name.text = n;
        name.SetCallBack(NameBgAutoFit);
    }
    
    public void SetName(string n, Color color)
    {
        if (name == null)
        {
            return;
        }
        
        name.text = n;
        name.SetCallBack(NameBgAutoFit);
        name.color32 = color;
    }


    public void SetLevel(bool visible)
    {
        SetCityLevelLabelActive(visible && _levelShowType == LevelShowType.Normal);
        SetDirectionLevelLabelActive(visible && _levelShowType == LevelShowType.Direction);
    }
    

    public void ShowNameTitle(bool s)
    {
        nameTitle.gameObject.SetActive(s);
    }

    private void NameBgAutoFit()
    {
        if (nameBg != null)
        {
            var textWidth = name.GetWidth();
            var size = nameBg.size;
            textWidth /= TitleBgScale.x;
            size.x = textWidth + TitleBgSizeDeltaX;
            if (size.x < TitleBgMinSizeX)
            {
                size.x = TitleBgMinSizeX;
            }
            size.y = TitleBgMinSizeY;
            nameBg.size = size;
            if (_campSprite != null)
            {
                var v3 = new Vector3((nameBg.size.x * 0.45f), 0, 0);
                _campSprite.transform.localPosition = v3;
            }
        }
    }
    
    public void SetDirectionLevel(int showLevel, string iconName)
    {
        _levelShowType = LevelShowType.Direction;
        SetCityLevelLabelActive(false);
        SetDirectionLevelLabelActive(true);
        if (_directionImage != null)
        {
            _directionImage.LoadSprite(iconName);
        }
        if (_directionLevel != null)
        {
            _directionLevel.text = showLevel.ToString();
        }
    }

    private void SetCityLevelLabelActive(bool visible)
    {
        if (level != null && level.transform.parent != null)
        {
            level.transform.parent.gameObject.SetActive(visible);
        }
    }
    
    private void SetDirectionLevelLabelActive(bool visible)
    {
        if (_directionImage != null)
        {
            _directionImage.gameObject.SetActive(visible);
        }
    }
    
    public void SetNameBgSkin(int skinId = 0)
    {
        if (nameBg != null)
        {
            float deltaX = 0;
            string bgName = DefaultBgName;
            if (skinId != 0)
            {
                bgName = GameEntry.ConfigCache.GetTemplateData(GameDefines.TableName.Decoration, skinId, "image");
                if (string.IsNullOrEmpty(bgName))
                {
                    //处理没有配置的情况下
                    bgName = DefaultBgName;
                }
                else
                {
                    deltaX =
                        GameEntry.Lua.CallWithReturn<float, string>("CSharpCallLuaInterface.GetTitleNameDeltaX", bgName);
                }
            }
            nameBg.transform.localScale = TitleBgScale;
            name.transform.localPosition = TitleNamePos;
            name.transform.SetLocalPositionX(deltaX);
            name.transform.localScale = new Vector3(1 / TitleBgScale.x, 1 / TitleBgScale.y, 1);
            nameBg.LoadSprite(GameDefines.SpritePath.UITitleTag + bgName);
        }
    }

    public void SetBuildData(string name, Color color, int level, int camp,int skinId=0)
    {
        SetNameBgSkin(skinId);
        SetName(name,color);
        SetLevel(level);
        if (camp > 0)
        {
            SetCamp(camp);
        }
        
    }
}