using UnityEngine;
using System.Collections;
using System.Collections.Generic;
[ExecuteAlways]
public class PrefabLightmapData : MonoBehaviour
{
    [System.Serializable]
    public struct RendererInfo
    {
        public Renderer renderer;
        public int lightmapIndex;
        public Vector3 position;
        public Vector4 lightmapOffsetScale;
    }

    [SerializeField]
    public RendererInfo[] m_RendererInfo;
    [SerializeField]
    Texture2D[] m_Lightmaps;
    private MaterialPropertyBlock matBlock;

    void Awake()
    {
        matBlock = new MaterialPropertyBlock();
        if (m_RendererInfo == null || m_RendererInfo.Length == 0)
            return;

        //var lightmaps = LightmapSettings.lightmaps;
        //var combinedLightmaps = new LightmapData[lightmaps.Length + m_Lightmaps.Length];

        //lightmaps.CopyTo(combinedLightmaps, 0);
        //for (int i = 0; i < m_Lightmaps.Length; i++)
        //{
        //    combinedLightmaps[i + lightmaps.Length] = new LightmapData();
        //    combinedLightmaps[i + lightmaps.Length].lightmapColor = m_Lightmaps[i];
        //}

        OnQualityChange(null);
        //ApplyRendererInfo(m_RendererInfo, m_Lightmaps.Length);
       // LightmapSettings.lightmapsMode = LightmapsMode.NonDirectional;
        //LightmapSettings.lightmaps = combinedLightmaps;
    }
    private void OnEnable()
    {
        if (GameEntry.Event != null)
        {
            GameEntry.Event.Subscribe(EventId.QualityChange, OnQualityChange);

        }
    
    }

    private void OnDisable()
    {
        if (GameEntry.Event != null)
        {
            GameEntry.Event.Unsubscribe(EventId.QualityChange, OnQualityChange);
        }
           
    }

    private void OnQualityChange(object data)
    {
        //Editor
        if (GameEntry.Setting == null)
        {
            ApplyRendererInfo(m_RendererInfo, m_Lightmaps.Length);
            return;
        }
        int graphicLv = SceneQualitySetting.GetGraphicLevel();

        if (graphicLv != GameDefines.QualityLevel_Low)
        {
            ApplyRendererInfo(m_RendererInfo, m_Lightmaps.Length);
        }
     

    }


    void ApplyRendererInfo(RendererInfo[] infos, int lightmapOffsetIndex)
    {
        for (int i = 0; i < infos.Length; i++)
        {
            var info = infos[i];
            if(info.renderer==null)
            {
                continue;
            }
            //info.renderer.material.SetVector("_LightMap_ST", info.lightmapOffsetScale);
            //info.renderer.material.SetTexture("_LightMap", m_Lightmaps[info.lightmapIndex]);


            matBlock.SetVector("_LightMap_ST", info.lightmapOffsetScale);
            matBlock.SetTexture("_LightMap", m_Lightmaps[info.lightmapIndex]);
            info.renderer.SetPropertyBlock(matBlock);
            //info.renderer.lightmapIndex = info.lightmapIndex + lightmapOffsetIndex;
            //info.renderer.lightmapScaleOffset = ;
        }
    }

#if UNITY_EDITOR
    [UnityEditor.MenuItem("Assets/Bake  Lightmaps Postion")]
     static void GeneratePosition()
    {
        var obj = GameObject.Find("Scene_prologue_38");
        var m_RendererInfo = obj.GetComponent<PrefabLightmapData>();
        for (int i = 0; i < m_RendererInfo.m_RendererInfo.Length; i++)
        {
            if (m_RendererInfo.m_RendererInfo[i].renderer == null)
            {
                continue;
            }
            m_RendererInfo.m_RendererInfo[i].position = m_RendererInfo.m_RendererInfo[i].renderer.transform.position;
        }

    }

    [UnityEditor.MenuItem("Assets/Bake Prefab Lightmaps")]
    static void GenerateLightmapInfo()
    {
        if (UnityEditor.Lightmapping.giWorkflowMode != UnityEditor.Lightmapping.GIWorkflowMode.OnDemand)
        {
            Debug.LogError("ExtractLightmapData requires that you have baked you lightmaps and Auto mode is disabled.");
            return;
        }
       // UnityEditor.Lightmapping.Bake();

        PrefabLightmapData[] prefabs = FindObjectsOfType<PrefabLightmapData>();

        foreach (var instance in prefabs)
        {
            var gameObject = instance.gameObject;
            var rendererInfos = new List<RendererInfo>();
            var lightmaps = new List<Texture2D>();

            GenerateLightmapInfo(gameObject, rendererInfos, lightmaps);

            instance.m_RendererInfo = rendererInfos.ToArray();
            instance.m_Lightmaps = lightmaps.ToArray();

            var targetPrefab = UnityEditor.PrefabUtility.GetPrefabParent(gameObject) as GameObject;
            if (targetPrefab != null)
            {
                //UnityEditor.Prefab
                UnityEditor.PrefabUtility.ReplacePrefab(gameObject, targetPrefab);
            }
        }
    }

    static void GenerateLightmapInfo(GameObject root, List<RendererInfo> rendererInfos, List<Texture2D> lightmaps)
    {
        var renderers = root.GetComponentsInChildren<MeshRenderer>();
        foreach (MeshRenderer renderer in renderers)
        {
            if (renderer.lightmapIndex != -1)
            {
                RendererInfo info = new RendererInfo();
                info.renderer = renderer;
                info.lightmapOffsetScale = renderer.lightmapScaleOffset;
                info.position = renderer.transform.position;
                Texture2D lightmap = LightmapSettings.lightmaps[renderer.lightmapIndex].lightmapColor;

                info.lightmapIndex = lightmaps.IndexOf(lightmap);
                if (info.lightmapIndex == -1)
                {
                    info.lightmapIndex = lightmaps.Count;
                    lightmaps.Add(lightmap);
                }

                rendererInfos.Add(info);
            }
        }
    }
#endif

}