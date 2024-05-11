
using System.Collections.Generic;
using GameFramework;
using UnityEngine;
using XLua;

public class WorldLodManager : WorldManagerBase
{
    private HashSet<AutoAdjustLod> adjusterSet;
    private HashSet<AutoAdjustLod> addingAdjusterSet;
    private HashSet<AutoAdjustLod> removingAdjusterSet;
    private int curLod;
    
    // Dict<LodType, Dict<path, LodConfig>>
    private static Dictionary<int, Dictionary<string, LodConfig>> lodConfigCache;
    
    public WorldLodManager(WorldScene scene) : base(scene)
    {
        adjusterSet = new HashSet<AutoAdjustLod>();
        addingAdjusterSet = new HashSet<AutoAdjustLod>();
        removingAdjusterSet = new HashSet<AutoAdjustLod>();
        lodConfigCache = new Dictionary<int, Dictionary<string, LodConfig>>();
    }

    public override void Init()
    {
        GameEntry.Event.Subscribe(EventId.ChangeCameraLod, OnLodChanged);
    }

    public override void UnInit()
    {
        GameEntry.Event.Unsubscribe(EventId.ChangeCameraLod, OnLodChanged);
    }

    public void AddLodAdjuster(AutoAdjustLod adjuster)
    {
        adjuster.UpdateLod(curLod);
        addingAdjusterSet.Add(adjuster);
    }

    public void RemoveLodAdjuster(AutoAdjustLod adjuster)
    {
        removingAdjusterSet.Add(adjuster);
    }

    public override void OnUpdate(float deltaTime)
    {
        base.OnUpdate(deltaTime);
    }

    private void OnLodChanged(object userdata)
    {
        curLod = (int) userdata;
        Debug.LogFormat($"Lod level: {curLod}");
        
        UpdateAutoAdjustLod();
        
        if (curLod >= 3)
        {
            if (GameEntry.Lua.UIManager.IsWindowOpen("UIWorldTileUI"))
            {
                GameEntry.Lua.UIManager.DestroyWindow("UIWorldTileUI");
            }
            GameEntry.Lua.Call("UIUtil.CloseWorldMarchTileUI");
            world.HideTouchEffect();
        }
    }

    private void UpdateAutoAdjustLod()
    {
        foreach (AutoAdjustLod adjuster in removingAdjusterSet)
        {
            adjusterSet.Remove(adjuster);
        }
        removingAdjusterSet.Clear();
        
        foreach (AutoAdjustLod adjuster in addingAdjusterSet)
        {
            adjusterSet.Add(adjuster);
        }
        addingAdjusterSet.Clear();
        
        foreach (AutoAdjustLod adjuster in adjusterSet)
        {
            if (adjuster != null)
            {
                adjuster.UpdateLod(curLod);
            }
        }
    }
    
    public Dictionary<string, LodConfig> GetLodConfigs(int lodType)
    {
        if (!lodConfigCache.ContainsKey(lodType))
        {
            Dictionary<string, LodConfig> configs = new Dictionary<string, LodConfig>();
            LuaTable templates = GameEntry.Lua.CallWithReturn<LuaTable, int>("CSharpCallLuaInterface.GetLodTemplates", lodType);
            for (int i = 1; i <= templates.Length; i++)
            {
                LodConfig config = new LodConfig();
                LuaTable template = templates.Get<LuaTable>(i);
                config.InitByTemplate(template);
                configs[config.path] = config;
            }
            lodConfigCache[lodType] = configs;
        }

        return lodConfigCache[lodType];
    }
}

public class LodConfig
{
    public string path;
    public int lodStart;
    public int lodEnd;
    public bool isMain;
    public bool noFading;

    public void InitByTemplate(LuaTable template)
    {
        path = template.Get<string>("path");
        lodStart = template.Get<int>("lodStart");
        lodEnd = template.Get<int>("lodEnd");
        isMain = template.Get<bool>("isMain");
        noFading = template.Get<bool>("noFading");
    }
}