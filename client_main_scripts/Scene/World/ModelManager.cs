using System;
using System.Collections.Generic;
using DG.Tweening;
using GameFramework;
using UnityEngine;
using XLua;

//
// 模型管理
//
public class ModelManager : CityManagerBase
{
    private static readonly Vector2Int ObjSize = new Vector2Int(2, 2);

    #region Model Objects
    
    public enum ModelObjectType
    {
        Build = 1,
        Collect = 9,
    }

    public abstract class ModelObject
    {
        public InstanceRequest instance;
        public List<InstanceRequest> oldInstances;
        public int pointIndex;
        public ModelObjectType modelObjectType;
        public bool isVisible;
        public ModelManager parent;

        public ModelObject(ModelManager modelManager, int index, ModelObjectType modelType)
        {
            parent = modelManager;
            pointIndex = index;
            modelObjectType = modelType;
            oldInstances = new List<InstanceRequest>();
        }
        protected void AddOldObject()
        {
            if (instance != null)
            {
                oldInstances.Add(instance);
            }
        }
        
        protected void ClearOldObject()
        {
            if (oldInstances != null)
            {
                foreach (var per in oldInstances)
                {
                    if (per != null)
                    {
                        per.Destroy();
                    }
                }
                oldInstances.Clear();
            }
        }
        public virtual void Destroy()
        {
            ClearOldObject();
            oldInstances = null;
            if (instance != null)
            {
                instance.Destroy();
                instance = null;
            }
        }
        
        // LOD 变化时更新表现
        public abstract void UpdateLod(int lod);
        
        // Fog 变化时更新表现
        public abstract void UpdateFog(int fogId);
    
        // 创建游戏对象
        public abstract void CreateGameObject();
    
        // 数据变化时，更新游戏对象的表现
        public abstract void UpdateGameObject(object param = null);
        public virtual void OnUpdate(float deltaTime)
        {
        
        }
        
        public abstract void DoGuideStartAnim(int time);
        public abstract void SetIsVisible(bool visible);
        public virtual void SetLabelActive(bool visible)
        {
        
        }
        
    }

    public class BuildObject : ModelObject
    {
        public CityBuilding cityBuilding;
        public LuaBuildData luaBuild;

        public BuildObject(ModelManager parent, int pointId,ModelObjectType modelObjectType, LuaBuildData build) :base(parent, pointId, modelObjectType)
        {
            luaBuild = build;
        }
        
        public override void Destroy()
        {
            if (cityBuilding != null)
            {
                cityBuilding.CSUninit();
            }
            GameEntry.Event.Fire(EventId.BUILD_OUT_VIEW, luaBuild.uuid);
            base.Destroy();
        }

        public override void CreateGameObject()
        {
            var model = GameEntry.Lua.CallWithReturn<string, int, int>(
                "CSharpCallLuaInterface.GetCityBuildingModelName",
                luaBuild.buildId, luaBuild.level);
            if (model.IsNullOrEmpty() == false )
            {
                AddOldObject();
                instance = GameEntry.Resource.InstantiateAsync(string.Format(GameDefines.EntityAssets.Building,model));
                instance.completed += delegate
                {
                    ClearOldObject();
                    var gameObject = instance.gameObject;
                    if (gameObject != null)
                    {
                        gameObject.transform.SetParent(SceneManager.World.DynamicObjNode);
                        if (cityBuilding != null)
                        {
                            cityBuilding.CSUninit();
                        }
                        cityBuilding = gameObject.GetComponent<CityBuilding>();
                        if (cityBuilding != null)
                        {
                            CityBuilding.Param param = new CityBuilding.Param();
                            param.buildUuid = luaBuild.uuid;
                            param.buildId = luaBuild.buildId;
                            param.buildSceneType = CityBuilding.BuildSceneType.City;
                            param.visible = isVisible;
                            param.noDoAnim = parent.IsNoDoBuildAnim(param.buildUuid);
                            param.canShowBuildMark = parent.CanShowBuildMark();
                            param.point = luaBuild.pointId;
                            cityBuilding.CSInit(param);
                            GameEntry.Event.Fire(EventId.BUILD_IN_VIEW, luaBuild.uuid);
                        }
                    }
                };
            }
        }

        public override void UpdateGameObject(object param = null)
        {
            luaBuild = (LuaBuildData)param;
            CreateGameObject();
        }

        public override void UpdateLod(int lod)
        {
            
        }

        public override void UpdateFog(int fogId)
        {
            
        }

        public override void OnUpdate(float deltaTime)
        {
        }

        public override void DoGuideStartAnim(int time)
        {
        }

        public override void SetIsVisible(bool visible)
        {
            isVisible = visible;
            if (cityBuilding != null)
            {
                cityBuilding.SetVisible(visible);
            }
        }
    }

    public class CollectObject : ModelObject
    {
        private GameObject _go;
        private LuaTable _param;
        public CollectObject(ModelManager parent, int pointId,ModelObjectType modelObjectType, LuaTable param) :base(parent, pointId, modelObjectType)
        {
            _go = null;
            _param = param;
        }
        
        public override void Destroy()
        {
            _go = null;
            base.Destroy();
        }

        public override void CreateGameObject()
        {
            AddOldObject();
            string modelName = _param.Get<string>("modelName");
            instance = GameEntry.Resource.InstantiateAsync(modelName);
            instance.completed += delegate
            {
                ClearOldObject();
                var gameObject = instance.gameObject;
                if (gameObject != null)
                {
                    _go = gameObject;
                    gameObject.name = "Collect_" + pointIndex;
                    gameObject.transform.SetParent(SceneManager.World.DynamicObjNode);
                    gameObject.transform.position = SceneManager.World.TileIndexToWorld(pointIndex);
                    gameObject.transform.localScale = Vector3.one;
                    gameObject.SetActive(isVisible);
                }
            };
        }

        public override void UpdateGameObject(object param = null)
        {

        }

        public override void UpdateLod(int lod)
        {
            
        }

        public override void UpdateFog(int fogId)
        {
            
        }

        public override void OnUpdate(float deltaTime)
        {

        }

        public override void DoGuideStartAnim(int time)
        {
            
        }

        public override void SetIsVisible(bool visible)
        {
            isVisible = visible;
            if (_go != null)
            {
                _go.SetActive(visible);
            }
        }
        public GameObject GetObject()
        {
            return _go;
        }
    }
    
    #endregion

    public ModelManager(CityScene scene)
        : base(scene)
    {
        _modelObjects = new Dictionary<int, ModelObject>();
        _noDoAnimBuild = new HashSet<long>();
    }

    private Dictionary<int, ModelObject> _modelObjects;//坐标index 建筑
    
    private long formationUuid;//编队uuid
    private HashSet<long> _noDoAnimBuild;//不能做动画的建筑
    private bool _canShowMark = true;//是否可以显示建筑盖子
    
    public override void Init()
    {
        base.Init();
        GameEntry.Event.Subscribe(EventId.CreateFormationUuid, CreateFormationUuidSignal);
        GameEntry.Event.Subscribe(EventId.UPDATE_BUILD_DATA, UpdateBuildDataSignal);
        GameEntry.Event.Subscribe(EventId.UserCitySkinUpdate, UpdateBuildDataSignal);
        GameEntry.Event.Subscribe(EventId.ShowAllGuideObject, ShowAllGuideObjectSignal);
        GameEntry.Event.Subscribe(EventId.OpenFogSuccess, OpenFogSuccessSignal);
        GameEntry.Event.Subscribe(EventId.SetBuildCanDoAnim, SetBuildCanDoAnimSignal);
        GameEntry.Event.Subscribe(EventId.SetBuildNoDoAnim, SetBuildNoDoAnimSignal);
        GameEntry.Event.Subscribe(EventId.VitaFireStateChange, RefreshMainBuildFireSignal);
        GameEntry.Event.Subscribe(EventId.RefreshCityBuildModel, RefreshCityBuildModelSignal);
        GameEntry.Event.Subscribe(EventId.RefreshCityBuildMark, RefreshCityBuildMarkSignal);
        InitLoadModel();
    }

    public override void UnInit()
    {
        base.UnInit();
        GameEntry.Event.Unsubscribe(EventId.CreateFormationUuid, CreateFormationUuidSignal);
        GameEntry.Event.Unsubscribe(EventId.UPDATE_BUILD_DATA, UpdateBuildDataSignal);
        GameEntry.Event.Unsubscribe(EventId.UserCitySkinUpdate, UpdateBuildDataSignal);
        GameEntry.Event.Unsubscribe(EventId.ShowAllGuideObject, ShowAllGuideObjectSignal);
        GameEntry.Event.Unsubscribe(EventId.OpenFogSuccess, OpenFogSuccessSignal);
        GameEntry.Event.Unsubscribe(EventId.SetBuildCanDoAnim, SetBuildCanDoAnimSignal);
        GameEntry.Event.Unsubscribe(EventId.SetBuildNoDoAnim, SetBuildNoDoAnimSignal);
        GameEntry.Event.Unsubscribe(EventId.VitaFireStateChange, RefreshMainBuildFireSignal);
        GameEntry.Event.Unsubscribe(EventId.RefreshCityBuildModel, RefreshCityBuildModelSignal);
        GameEntry.Event.Unsubscribe(EventId.RefreshCityBuildMark, RefreshCityBuildMarkSignal);
        ClearReInitObject();
        _noDoAnimBuild.Clear();
    }
    
    
    public override void OnUpdate(float deltaTime)
    {
    }

    public void InitLoadModel()
    {
        _canShowMark = GameEntry.Lua.CallWithReturn<bool>("CSharpCallLuaInterface.IsShowBuildMark");
        ReInitObject();
    }
    private void CreateFormationUuidSignal(object userData)
    {
        var uuid = (long) userData;
        formationUuid = uuid;
    }
    public long GetFormationUuid()
    
    {
        return formationUuid;
    }

    public ModelObject LoadOneObject(int index, int modelObjectType, object param = null)
    {
        if (_modelObjects.ContainsKey(index))
        {
            if (_modelObjects[index].modelObjectType == (ModelObjectType)modelObjectType)
            {
                _modelObjects[index].UpdateGameObject(param);
                return _modelObjects[index];
            }
            else
            {
                RemoveOneObjectByPointType(index,(int)_modelObjects[index].modelObjectType);
            }
        }
        ModelObject obj = null;
            switch (modelObjectType)
            {
                case (int) ModelObjectType.Build:
                {
                    var luaBuild = (LuaBuildData)param;
                    if (luaBuild != null)
                    {
                        var buildId = luaBuild.buildId;
                        if (buildId != GameDefines.BuildingTypes.APS_BUILD_WORMHOLE_SUB &&
                            buildId != GameDefines.BuildingTypes.WORM_HOLE_CROSS)
                        {
                            obj = new BuildObject(this, index, ModelObjectType.Build,luaBuild);
                        }
                    }
                }
                    break;
                case (int) ModelObjectType.Collect:
                {
                    obj = new CollectObject(this, index, ModelObjectType.Collect, (LuaTable) param);
                }
                    break;
            }

            if (obj != null)
            {
                _modelObjects.Add(index, obj);
                obj.isVisible = IsCanShowBuild();
                obj.CreateGameObject();
            
                scene.AddOccupyPoints(scene.IndexToTilePos(index), ObjSize);
            }

            return obj;
    }
    
    public void RemoveOneObject(int index)
    {
        if (_modelObjects.ContainsKey(index))
        {
            _modelObjects[index].Destroy();
            _modelObjects.Remove(index);
            scene.RemoveOccupyPoints(scene.IndexToTilePos(index), ObjSize);
        }
    }

    public void RemoveOneObjectByPointType(int index, int pointType)
    {
        if (_modelObjects.ContainsKey(index))
        {
            if (_modelObjects[index].modelObjectType == (ModelObjectType)pointType)
            {
                _modelObjects[index].Destroy();
                _modelObjects.Remove(index);
            }
            scene.RemoveOccupyPoints(scene.IndexToTilePos(index), ObjSize);
        }
    }

    private void UpdateBuildDataSignal(object userData)
    {
        var uuid = (long) userData;
        int pointId = 0;
        foreach (var per in _modelObjects)
        {
            if (per.Value.modelObjectType == ModelObjectType.Build)
            {
                var buildObject = per.Value as BuildObject;
                if (buildObject != null && buildObject.luaBuild.uuid == uuid)
                {
                    pointId = buildObject.pointIndex;
                    break;
                }
            }
        }

        // var buildingData = GameEntry.Lua.CallWithReturn<LuaBuildData, long>(
        //     "CSharpCallLuaInterface.GetBuildingDataByUuid", uuid);
        var buildingData = GameEntry.Data.Building.GetBuildingDataByUuid(uuid);
        if (buildingData != null && buildingData.state != (int)BuildingStateType.FoldUp)
        {
            if (pointId == buildingData.pointId || pointId == 0)
            {
                LoadOneObject(buildingData.pointId, (int) ModelObjectType.Build, buildingData);
            }
            else
            {
                ChangePointId(pointId, buildingData.pointId);
            }
        }
        else
        {
            if (pointId != 0)
            {
                RemoveOneObject(pointId);
            }
        }
    }

    public ModelObject GetObjectByPointId(int index)
    {
        if (_modelObjects.ContainsKey(index))
        {
            return _modelObjects[index];
        }

        return null;
    }

    private void ChangePointId(int oldId,int newId)
    {
        if (_modelObjects.ContainsKey(oldId))
        {
            var temp = _modelObjects[oldId];
            temp.pointIndex = newId;
            temp.UpdateGameObject();
            _modelObjects.Remove(oldId);
            scene.RemoveOccupyPoints(scene.IndexToTilePos(oldId), ObjSize);
            if (!_modelObjects.ContainsKey(newId))
            {
                _modelObjects.Add(newId, temp);
                scene.AddOccupyPoints(scene.IndexToTilePos(newId), ObjSize);
            }
        }
    }

    //清理建筑，路，城市点的object
    public void ClearReInitObject()
    {
        var delList = new List<int>();
        foreach (var per in _modelObjects)
        {
            per.Value.Destroy();
            delList.Add(per.Key);
        }

        for (int i = 0; i < delList.Count; ++i)
        {
            _modelObjects.Remove(delList[i]);
        }

        delList = null;
    }

    //重新加载建筑，路，城市点的object
    public void ReInitObject()
    {
        //加载建筑模型
        List<LuaBuildData> result = new List<LuaBuildData>();
        var list = GameEntry.Lua.CallWithReturn<List<LuaBuildData>, List<LuaBuildData>>(
            "CSharpCallLuaInterface.GetAllLuaBuildWithoutFoldUp", result);
        if (list != null)
        {
            foreach (var per in list)
            {
                LoadOneObject(per.pointId, (int) ModelObjectType.Build, per);
            }
        }
        Log.Debug("ReInitObject build count {0}", list!=null ? list.Count : -1);
        
        //加载矿根
        var collectList = GameEntry.Lua.CallWithReturn<LuaTable>("CSharpCallLuaInterface.GetShowObjectModelParam");
        if (collectList != null)
        {
            for (int i = 1; i <= collectList.Length; ++i)
            {
                var temp = (LuaTable) collectList[i];
                if (temp != null && temp.ContainsKey("pointId"))
                {
                    int pointId = temp.Get<int>("pointId");
                    LoadOneObject(pointId, (int)ModelObjectType.Collect, temp);
                }

            }
        }
    }

    public bool IsCanShowBuild()
    {
        return GameEntry.Lua.CallWithReturn<bool>("DataCenter.GuideManager:IsStartCanShowBuild");
    }
    
    private void ShowAllGuideObjectSignal(object userData)
    {
        foreach (var per in _modelObjects.Values)
        {
            per.SetIsVisible(true);
            if (per.modelObjectType == ModelObjectType.Build)
            {
                var buildObj = per as BuildObject;
                if (buildObj != null)
                {
                    GameEntry.Event.Fire(EventId.BUILD_IN_VIEW, buildObj.luaBuild.uuid);
                }
            }
        }
    }

    private void OpenFogSuccessSignal(object fogIdObj)
    {
        long fogId = (long) fogIdObj;
        foreach (ModelObject modelObject in _modelObjects.Values)
        {
            modelObject.UpdateFog((int)fogId);
        }
    }
    
    //设置世界点类型显示/隐藏
    public void SetVisibleByPointType(int pointType,bool isVisible)
    {
        foreach (var per in _modelObjects.Values)
        {
            if ((int)per.modelObjectType == pointType)
            {
                per.SetIsVisible(isVisible);
            }
        }
    }
    
    private void SetBuildCanDoAnimSignal(object userData)
    {
        var uuid = (long) userData;
        RemoveOneNoDoAnimBuild(uuid);
        foreach (var per in _modelObjects)
        {
            if (per.Value.modelObjectType == ModelObjectType.Build)
            {
                var buildObject = per.Value as BuildObject;
                if (buildObject != null && buildObject.luaBuild.uuid == uuid)
                {
                    buildObject.cityBuilding.SetCanDoAnim(true);
                    break;
                }
            }
        }
    }
    
    private void SetBuildNoDoAnimSignal(object userData)
    {
        var uuid = (long) userData;
        AddOneNoDoAnimBuild(uuid);
        foreach (var per in _modelObjects)
        {
            if (per.Value.modelObjectType == ModelObjectType.Build)
            {
                var buildObject = per.Value as BuildObject;
                if (buildObject != null && buildObject.luaBuild.uuid == uuid)
                {
                    buildObject.cityBuilding.SetCanDoAnim(false);
                    break;
                }
            }
        }
    }
    
    private void AddOneNoDoAnimBuild(long uuid)
    {
        if (!_noDoAnimBuild.Contains(uuid))
        {
            _noDoAnimBuild.Add(uuid);
        }
    }
    private void RemoveOneNoDoAnimBuild(long uuid)
    {
        if (_noDoAnimBuild.Contains(uuid))
        {
            _noDoAnimBuild.Remove(uuid);
        }
    }
    
    public bool IsNoDoBuildAnim(long uuid)
    {
        return _noDoAnimBuild.Contains(uuid);
    }
    
    private void  RefreshMainBuildFireSignal(object userData)
    {
        //刷新大本
        foreach (var per in _modelObjects)
        {
            if (per.Value.modelObjectType == ModelObjectType.Build)
            {
                var buildObject = per.Value as BuildObject;
                if (buildObject != null && buildObject.luaBuild.buildId == GameDefines.BuildingTypes.FUN_BUILD_MAIN)
                {
                    if (buildObject.cityBuilding != null)
                    {
                        buildObject.cityBuilding.RefreshFireState();
                    }
                    break;
                }
            }
        }
    }
    
    private void RefreshCityBuildModelSignal(object userData)
    {
        int pointId = Convert.ToInt32(userData);
        var buildData = GameEntry.Lua.CallWithReturn<LuaBuildData, int>(
            "CSharpCallLuaInterface.GetBuildingDataByPointId",
            pointId);
        if (buildData == null)
        {
            RemoveOneObject(pointId);
        }
        else
        {
            LoadOneObject(pointId, (int)ModelObjectType.Build, buildData);
        }
    }
    
    private void RefreshCityBuildMarkSignal(object userData)
    {
        _canShowMark = (bool) userData;
        foreach (var per in _modelObjects)
        {
            if (per.Value.modelObjectType == ModelObjectType.Build)
            {
                var buildObject = per.Value as BuildObject;
                if (buildObject != null)
                {
                    if (buildObject.cityBuilding != null)
                    {
                        if (_canShowMark)
                        {
                            buildObject.cityBuilding.ChangeNearModel(false);
                        }
                        else
                        {
                            buildObject.cityBuilding.ChangeNearModel(true);
                        }
                    }
                }
            }
        }
    }
    
    public bool CanShowBuildMark()
    {
        return _canShowMark;
    }
    
    

}