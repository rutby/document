using System.Collections.Generic;
using UnityEngine;
using XLua;

//
// 世界格子数据管理
//
public class FakeWorldBuilding
{
    public WorldBuilding city;
    public InstanceRequest request;
}

public class FakeAllianceBuilding
{
    public WorldAllianceBuilding allianceBuild;
    public InstanceRequest request;
}
public class FakeModelManager : WorldManagerBase
{
    public FakeModelManager(WorldScene scene)
        : base(scene)
    {

    }
    
    public override void OnUpdate(float deltaTime)
    {
    }
    
    #region UI Create building
    
    //建造相关（生成的假建筑）
    public FakeWorldBuilding preCreateBuild;//拖出来的建筑
    public Queue<FakeWorldBuilding> placeFalseBuild;//点击建造放下的建筑
    public GameObject attackRange;
    public bool isPaitai = false;
    //拖出建筑
    public void UICreateBuilding(int buildId, long buildUuid, int point,int buildTopType,LuaTable noBuildList = null)
    {
        var levelId = buildId + 1;
        var model = GameEntry.ConfigCache.GetTemplateData(GameDefines.TableName.Building,levelId,"model_world");
        if (model.IsNullOrEmpty() == false  && preCreateBuild == null)
        {
            preCreateBuild = new FakeWorldBuilding();
            var request = GameEntry.Resource.InstantiateAsync(string.Format(GameDefines.EntityAssets.Building, model));
            preCreateBuild.request = request;
            request.completed += delegate
            {
                preCreateBuild.city = request.gameObject.GetComponent<WorldBuilding>();
                preCreateBuild.city.CSInit(new WorldBuilding.Param()
                {
                    buildId = buildId,
                    buildUuid =  buildUuid,
                    point = point,
                    BuildTopType = (PlaceBuildType)buildTopType,
                    noPutPoint = noBuildList,
                    buildSceneType = WorldBuilding.BuildSceneType.Fake,
                });
               
                if (buildId == GameDefines.BuildingTypes.FUN_BUILD_ARROW_TOWER)
                {
                    isPaitai = true;
                    attackRange = request.gameObject.transform.Find("Range").gameObject;
                    if (!attackRange.activeSelf)
                    {
                        attackRange.SetActive(true);
                    }
                }
                GameEntry.Event.Fire(EventId.UICreateFakePlaceBuild);
            };
           
        }
    }
    
    //点击确定建造
    public void UIChangeBuilding(int index)
    {
        if (preCreateBuild.city != null)
        {
            if (placeFalseBuild == null)
            {
                placeFalseBuild = new Queue<FakeWorldBuilding>();
            }
            placeFalseBuild.Enqueue(preCreateBuild);
            if (isPaitai)
            {
                if (attackRange.activeSelf)
                {
                    attackRange.SetActive(false);
                }
                isPaitai = false;
            }

            preCreateBuild.city.ResetParam(index);
            preCreateBuild = null;
        }
    }
    //点击取消建造
    public void UIDestroyRreCreateBuild()
    {
        if (preCreateBuild != null && preCreateBuild.request != null && preCreateBuild.city != null)
        {
            if (isPaitai)
            {
                if (attackRange.activeSelf)
                {
                    attackRange.SetActive(false);
                }
                isPaitai = false;
            }
            preCreateBuild.city.CSUninit();
            preCreateBuild.request.Destroy();
            preCreateBuild = null;
        }
    }

    //返回建造数据（成功/失败都走）
    public void UIDestroyBuilding()
    {
        if (placeFalseBuild != null &&  placeFalseBuild.Count > 0)
        {
            var build = placeFalseBuild.Dequeue();
            build.city.CSUninit();
            build.request.Destroy();
        }
    }
    //建造结束

    #endregion

    #region UI Create alliance building
    
    //建造相关（生成的假建筑）
    public FakeAllianceBuilding preCreateAllianceBuild;
    public Queue<FakeAllianceBuilding> placeFalseAllianceBuild;
    //拖出建筑
    public void UICreateAllianceBuilding(int buildId, long buildUuid, int point,int buildTopType,LuaTable noBuildList = null)
    {
        var levelId = buildId + 1;
        var model = GameEntry.ConfigCache.GetTemplateData("alliance_res_build",buildId,"model");
        if (model.IsNullOrEmpty() == false  && preCreateBuild == null)
        {
            preCreateAllianceBuild = new FakeAllianceBuilding();
            var request = GameEntry.Resource.InstantiateAsync(string.Format("Assets/Main/Prefabs/AllianceBuilding/{0}.prefab", model));
            preCreateAllianceBuild.request = request;
            request.completed += delegate
            {
                preCreateAllianceBuild.allianceBuild = request.gameObject.GetComponent<WorldAllianceBuilding>();
                preCreateAllianceBuild.allianceBuild.CSInit(new WorldAllianceBuilding.Param()
                {
                    buildId = buildId,
                    buildUuid =  buildUuid,
                    point = point,
                    BuildTopType = (PlaceBuildType)buildTopType,
                    noPutPoint = noBuildList,
                    buildSceneType = WorldAllianceBuilding.AllianceBuildSceneType.Fake,
                });
                var stateIcon = request.gameObject.transform.Find("ModelGo/stateIcon")?.gameObject;
                if (stateIcon != null)
                {
                    stateIcon.SetActive(false);
                }
                GameEntry.Event.Fire(EventId.UICreateFakePlaceAllianceBuild);
                
            };
           
        }
    }
    
    //点击确定建造
    public void UIChangeAllianceBuilding(int index)
    {
        if (preCreateAllianceBuild.allianceBuild != null)
        {
            if (placeFalseAllianceBuild == null)
            {
                placeFalseAllianceBuild = new Queue<FakeAllianceBuilding>();
            }
            placeFalseAllianceBuild.Enqueue(preCreateAllianceBuild);

            preCreateAllianceBuild.allianceBuild.ResetParam(index);
            preCreateAllianceBuild = null;
        }
    }
    //点击取消建造
    public void UIDestroyRreCreateAllianceBuild()
    {
        if (preCreateAllianceBuild != null && preCreateAllianceBuild.request != null && preCreateAllianceBuild.allianceBuild != null)
        {
            preCreateAllianceBuild.allianceBuild.CSUninit();
            preCreateAllianceBuild.request.Destroy();
            preCreateAllianceBuild = null;
        }
    }

    //返回建造数据（成功/失败都走）
    public void UIDestroyAllianceBuilding()
    {
        if (placeFalseAllianceBuild != null &&  placeFalseAllianceBuild.Count > 0)
        {
            var build = placeFalseAllianceBuild.Dequeue();
            build.allianceBuild.CSUninit();
            build.request.Destroy();
        }
    }
    //建造结束

    #endregion
}