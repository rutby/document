using Tayx.Graphy;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

public class ProfilerGFXPanel :BaseGFXPanel
{
    private InstanceRequest graphyRequest;

    private readonly GameObject _uiRoot;
    private readonly GameObject _dynamic;
    private readonly WorldScene _worldScene;
    private bool fogVisible = true;
    
    public ProfilerGFXPanel() : base("Profiler")
    {
        _uiRoot = GameObject.Find("UIContainer");
        _dynamic = GameObject.Find("World/dynamicObj");
        _worldScene = Object.FindObjectOfType<WorldScene>();
    }

    public override void DrawGUI()
    {
        if (graphyRequest == null)
        {
            if (GUILayout.Button("显示 Graphy"))
            {
                graphyRequest = GameEntry.Resource.InstantiateAsync(GameDefines.UIAssets.ProfileGraphy);
                graphyRequest.completed += delegate
                {
                    var graphyMgr = graphyRequest.gameObject.GetComponent<GraphyManager>();
                    graphyMgr.SetLuaMemoryGetter(() => GameEntry.Lua.Env.Memroy * 1024);
                };
            }
        }
        else
        {
            if (GUILayout.Button("隐藏 Graphy"))
            {
                graphyRequest.Destroy();
                graphyRequest = null;
            }
        }

        if (LuaClientProfiler.IsAttached)
        {
            if (GUILayout.Button("Detach Lua Profiler"))
            {
                LuaClientProfiler.Detach();
            }
        }
        else
        {
            if (GUILayout.Button("Attach Lua Profiler"))
            {
                LuaClientProfiler.Attach();
            }
        }
        
        bool loggerOn = GameEntry.Resource.Loggable;
        if (loggerOn)
        {
            if (GUILayout.Button("关闭资源日志"))
            {
                GameEntry.Resource.Loggable = false;
                GameEntry.Setting.SetBool(GameDefines.SettingKeys.RESOURCE_LOGGER, false);
            }
        }
        else
        {
            if (GUILayout.Button("打开资源日志"))
            {
                GameEntry.Resource.Loggable = true;
                GameEntry.Setting.SetBool(GameDefines.SettingKeys.RESOURCE_LOGGER, true);
            }
        }

        GUILayout.Space(30);
        GUILayout.Label("SRPBatch: " + GraphicsSettings.useScriptableRenderPipelineBatching);
        if (GUILayout.Button("开关SPRBatch"))
        {
            var pipelineAsset = QualitySettings.renderPipeline as UniversalRenderPipelineAsset;
            pipelineAsset.useSRPBatcher = !pipelineAsset.useSRPBatcher;
            GraphicsSettings.useScriptableRenderPipelineBatching = pipelineAsset.useSRPBatcher;
        }
        
        GUILayout.Space(30);
        if (GUILayout.Button("Toggle 地表"))
        {
            if (_worldScene)
            {
                _worldScene.ProfileToggleTerrain();
            }
        }
        GUILayout.Space(10);
        if (GUILayout.Button("Toggle 建筑"))
        {
            _dynamic.SetActive(!_dynamic.activeSelf);
        }
        GUILayout.Space(10);
        if (GUILayout.Button("Toggle UI"))
        {
            _uiRoot.SetActive(!_uiRoot.activeSelf);
        }
        
        GUILayout.Space(10);
        if (GUILayout.Button("Toggle Glass"))
        {
            if (_worldScene)
            {
                _worldScene.ProfileToggleGlass();
            }
        }
    }
}