using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityGameFramework.Runtime;

public class BuildingLabel : MonoBehaviour
{
    [SerializeField]
    private SuperTextMesh m_level;

    [SerializeField]
    private GameObject m_Upgrade;
    
    [SerializeField]
    private SuperTextMesh m_name;
    [SerializeField]
    private GameObject m_nameBg;

    private CityBuilding building;
    private Vector3 localPosition;

    public CityBuilding Building
    {
        get => building;
        set => building = value;
    }

    private void Awake()
    {
        localPosition = transform.localPosition;
    }

    public void SetData()
    {
        var info = building.GetBuildInfo();
        if (info == null)
        {
            gameObject.SetActive(false);
        }
        else
        {
            gameObject.SetActive(true);
            var playerType = info.GetPlayerType();
            var str = info.ownerUid;
            m_name.text = str;
            if (playerType == PlayerType.PlayerSelf)
            {
                m_name.color32 = GameDefines.CityLabelTextColor.Green;
            }
            else if (playerType == PlayerType.PlayerAlliance)
            {
                m_name.color32 = GameDefines.CityLabelTextColor.Blue;
            }
            else if (playerType == PlayerType.PlayerAllianceLeader)
            {
                m_name.color32 = GameDefines.CityLabelTextColor.Purple;
            }
            else
            {
                m_name.color32 = GameDefines.CityLabelTextColor.White;
            }
        }
    }

    public void UpdateUpgradeLabel()
    {
        
    }

    public void OnBuildingPositionChanged()
    {
        transform.position = building.transform.TransformPoint(localPosition);
    }

    public void BuildingEnterMoveState(bool isEnter)
    {
        //gameObject.SetActive(!isEnter);
    }
}
