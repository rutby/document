
using UnityEngine;

#if UNITY_EDITOR
using Sirenix.OdinInspector;
#endif

public class RenderSettingAuto : MonoBehaviour
{
    [SerializeField]
    private RenderSettingData _renderSettingData;
    
    private void OnEnable()
    {
        RenderSettingManager.PushSetting(_renderSettingData);
    }

    private void OnDisable()
    {
        RenderSettingManager.PopSetting();
    }
    
#if UNITY_EDITOR
    [Button("SaveLightingData")]
    public void SaveLightingData()
    {
        _renderSettingData = new RenderSettingData();
        _renderSettingData.LoadSettingData();
    }
#endif
}