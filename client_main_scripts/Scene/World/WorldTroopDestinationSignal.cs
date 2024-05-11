using System.Collections;
using UnityEngine;

public class WorldTroopDestinationSignal : MonoBehaviour
{
    [SerializeField] private Transform _transContainer;
    [SerializeField] private Transform _transCircleEffContainer;
    [SerializeField] private GameObject[] _goCircleEffs;
    [SerializeField] private SimpleAnimation[] _animCircleEffs;
    
    [SerializeField] private GameObject _goPointEff;
    [SerializeField] private GameObject _goHeadInfo;
    [SerializeField] private GameObject _goOperateIcon;
    [SerializeField] private SuperTextMesh _txtDistance;
    [SerializeField] private GameObject _imgDistance;
    [SerializeField] private SpriteRenderer _sprOperateType;

    private EnumDestinationSignalType _signalType;
    private Vector3 _signalPos;
    private int _cacheLastTile = -1;
    private Coroutine _corPlaySelectAnim;
    private Coroutine _corPlayPointAnim;
    private float _distance;
    
    private const string TARGET_TYPE_ICON_PATH = "Assets/Main/Sprites/UI/Common/New/{0}.png";

    /// <summary>
    /// 目标点为单位时
    /// 圈、详细信息、指向特效
    /// </summary>
    public void SetDestinationOver()//Vector3 localDestination, EnumDestinationSignalType signalType)
    {
        _goHeadInfo.SetActive(false);
        _transContainer.position = _signalPos;
        if (_signalType == EnumDestinationSignalType.EmptyGround)
        {
            ShowCircleEff(-1);
            if (_distance == 0)
                return;
            PlayPointAnim(-1);
        }
        else
        {
            gameObject.SetActive(false);
        }
    }

    private void ShowDestinationCircleEff(Vector3 targetPos, EnumDestinationSignalType signalType,int tileSize)
    {
        _signalType = signalType;
        _signalPos = GetFianlPos(targetPos, tileSize);
        if (_signalType == EnumDestinationSignalType.None)
        {
            gameObject.SetActive(false);
        }
        else if (_signalType == EnumDestinationSignalType.EmptyGround)
        {
            _transContainer.position = targetPos;
            ShowCircleEff(-1);//Hide All Circle
        }
        else if (_signalType == EnumDestinationSignalType.UnReachAble)
        {
            gameObject.SetActive(false);
            _transContainer.position = targetPos;
            ShowCircleEff(-1);//Hide All Circle
        }
        else if (_signalType == EnumDestinationSignalType.EnemyMarch)
        {
            _transContainer.position = targetPos;
            int effIndex = GetCircleEffIndex(_signalType);
            ShowCircleEff(effIndex);
            PlaySelectAnim(effIndex);
        }
        else
        {
            _transContainer.position = _signalPos;
            int effIndex = GetCircleEffIndex(_signalType);
            ShowCircleEff(effIndex);
            PlaySelectAnim(effIndex);
        }
    }

    public void SetDestinationForMarch(Vector3 localDestination, EnumDestinationSignalType signalType,int tileSize)
    {
        // int tileIndex = SceneManager.World.WorldToTileIndex(localDestination);
        // if (tileIndex == _cacheLastTile)
        // {
        //     return;
        // }
        // _cacheLastTile = -1;
        gameObject.SetActive(true);
        _goPointEff.SetActive(false);
        _goHeadInfo.SetActive(false);
        ShowDestinationCircleEff(localDestination, signalType, tileSize);
        // if (_signalType != EnumDestinationSignalType.None && _signalType != EnumDestinationSignalType.EmptyGround )
        // {
        //     _cacheLastTile = tileIndex;
        // }
    }
    
    public void SetDestination(Vector3 localDestination, EnumDestinationSignalType signalType,MarchTargetType targetType,int tileSize, float distance,bool isTower = false)
    {
        int tileIndex = SceneManager.World.WorldToTileIndex(localDestination);
        if (tileIndex == _cacheLastTile)
        {
            return;
        }
        _cacheLastTile = -1;
        gameObject.SetActive(true);
        _goPointEff.SetActive(false);
        if (isTower && targetType != MarchTargetType.ATTACK_ARMY)
        {
            _goHeadInfo.SetActive(false);
        }
        else
        {
            _goHeadInfo.SetActive(true);
        }
        ShowDestinationCircleEff(localDestination, signalType, tileSize);
        if (_signalType != EnumDestinationSignalType.None && _signalType != EnumDestinationSignalType.EmptyGround )
        {
            _cacheLastTile = tileIndex;
        }
        _distance = distance;
        _txtDistance.gameObject.SetActive(distance != 0);
        _imgDistance.SetActive(distance != 0);
        _txtDistance.text = (int)distance + GameEntry.Localization.GetString("100204");
        _goOperateIcon.SetActive(true);
        string operateIcon = GetOperateIcon(targetType);
        _sprOperateType.LoadSprite(operateIcon);
    }

    private string GetOperateIcon(MarchTargetType tempType)
    {
        string iconName = "";
        switch (tempType)
        {
            case MarchTargetType.ATTACK_CITY:
            case MarchTargetType.DIRECT_ATTACK_CITY:
            case MarchTargetType.ATTACK_BUILDING:
            case MarchTargetType.ATTACK_ARMY:
            case MarchTargetType.ATTACK_MONSTER:
            case MarchTargetType.DIRECT_ATTACK_ACT_BOSS:
            case MarchTargetType.ATTACK_ARMY_COLLECT:
            case MarchTargetType.ATTACK_ALLIANCE_CITY:
            case MarchTargetType.ATTACK_ALLIANCE_BUILDING:
            case MarchTargetType.DIRECT_ATTACK_NPC_CITY:
            case MarchTargetType.ATTACK_NPC_CITY:
            case MarchTargetType.ATTACK_ACT_ALLIANCE_MINE:
            case MarchTargetType.ATTACK_DRAGON_BUILDING:
            case MarchTargetType.TRIGGER_DRAGON_BUILDING:
            case MarchTargetType.TRIGGER_CROSS_THRONE_BUILDING:
            case MarchTargetType.TAKE_SECRET_KEY:
                iconName = "Common_icon_march_battle";
                break;
            case MarchTargetType.COLLECT:
            case MarchTargetType.PICK_GARBAGE:
            case MarchTargetType.SAMPLE:
            case MarchTargetType.COLLECT_ALLIANCE_BUILD_RESOURCE:
                case MarchTargetType.PICK_SECRET_KEY:
                iconName = "Common_icon_march_collect";
                break;
            case MarchTargetType.ASSISTANCE_CITY:
            case MarchTargetType.ASSISTANCE_BUILD:
            case MarchTargetType.ASSISTANCE_ALLIANCE_BUILDING:
            case MarchTargetType.ASSISTANCE_COLLECT_ACT_ALLIANCE_MINE:
                case MarchTargetType.ASSISTANCE_DRAGON_BUILDING:
            case MarchTargetType.TRANSPORT_SECRET_KEY:
                iconName = "Common_icon_march_assistance";
                break;
            case MarchTargetType.BUILD_ALLIANCE_BUILDING:
                iconName = "Common_icon_march_construct";
                break;
            case MarchTargetType.BACK_HOME:
                iconName = "Common_icon_march_return";
                break;
            default:
                iconName = "Common_icon_march_station";
                break;
        }

        return string.Format(TARGET_TYPE_ICON_PATH, iconName);
    }

    private int GetCircleEffIndex(EnumDestinationSignalType tempType)
    {
        int effType = 0;
        switch (tempType)
        {
            case EnumDestinationSignalType.My:
            case EnumDestinationSignalType.Other:
                effType = 0;
                break;
            case EnumDestinationSignalType.Alliance:
                effType = 1;
                break;
            case EnumDestinationSignalType.EnemyMarch:
            case EnumDestinationSignalType.EnemyBuild:
                effType = 2;
                break;
        }

        return effType;
    }

    private void ShowCircleEff(int effType = -1)
    {
        for (int i = 0; i < _goCircleEffs.Length; i++)
        {
            _goCircleEffs[i].SetActive(effType == i);
        }
    }

    private void PlayPointAnim(int effIndex = -1)
    {
        if (_corPlayPointAnim != null)
        {
            StopCoroutine(_corPlayPointAnim);
        }
        if (gameObject.activeSelf == true)
        {
            if (effIndex == -1)
            {
                _corPlayPointAnim = StartCoroutine(CorPlayPointAnim(effIndex));
            }
        }
        
    }

    IEnumerator CorPlayPointAnim(int effIndex)
    {
        if (effIndex == -1)
        {
            _goPointEff.SetActive(true);
        }
        yield return new WaitForSeconds(3.5f);
        gameObject.SetActive(false);
    }
    
    private void PlaySelectAnim(int effIndex)
    {
        _animCircleEffs[effIndex].Play();
    }

    public void HideDestination()
    {
        gameObject.SetActive(false);
    }


    private Vector3 GetFianlPos(Vector3 localPos, int tileSize)
    {
        int tileIndex = SceneManager.World.WorldToTileIndex(localPos);
        Vector3 finalPos = SceneManager.World.TileIndexToWorld(tileIndex);
        if (tileSize > 1 && _signalType!= EnumDestinationSignalType.Other)
        {
            if (_signalType != EnumDestinationSignalType.EnemyMarch)
            {
                if (tileSize == 2)
                {
                    finalPos = finalPos - new Vector3(1f, 0, 1f);
                }
                else if (tileSize == 3 || tileSize == 5)
                {
                    int modelCenter = GameEntry.Lua.CallWithReturn<int, int, int>("CSharpCallLuaInterface.GetBuildModelCenter",tileIndex, tileSize);
                    finalPos = SceneManager.World.TileIndexToWorld(modelCenter);
                }
                else if (tileSize == 7)
                {
                    finalPos = finalPos - new Vector3(6f, 0, 6f);
                }
            }
        }

        float localScale = 0.6f;
        if (tileSize > 1 && tileSize<=3)
        {
            localScale = 1f;
        }
        else if (tileSize>3)
        {
            localScale = (float)tileSize/2;
        }

        _transCircleEffContainer.localScale = Vector3.one * localScale;
        return finalPos;
    }
    
    
}

public enum EnumDestinationSignalType
{
    None,
    EmptyGround,
    My,
    Alliance,
    EnemyBuild,
    Other,
    UnReachAble,
    EnemyMarch,
}
