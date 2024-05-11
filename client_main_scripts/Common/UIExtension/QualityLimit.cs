using System.IO;
using Sfs2X.Entities.Data;
using UnityEngine;
using UnityEngine.UI;

public class QualityLimit : MonoBehaviour
{
    [SerializeField]  
    GameObject obj;
    private void OnEnable()
    {
        GameEntry.Event.Subscribe(EventId.QualityChange, OnQualityChange);
    }

    private void OnDisable()
    {
        GameEntry.Event.Unsubscribe(EventId.QualityChange, OnQualityChange);
    }

    private void OnQualityChange(object data)
    {
        if (obj != null)
        {
            int graphicLv = SceneQualitySetting.GetGraphicLevel();
            obj.SetActive(graphicLv!=GameDefines.QualityLevel_Low);
        }
    }

    private void Awake()
    {
        OnQualityChange(null);
    }
}