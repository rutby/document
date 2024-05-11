using System.Collections.Generic;
using UnityEngine;
using XLua;

//
// 世界格子数据管理
//
public class FakeBuilding
{
    public CityBuilding city;
    public InstanceRequest request;
}

public class FakeCityModelManager : CityManagerBase
{
    public FakeCityModelManager(CityScene scene)
        : base(scene)
    {

    }
    
    public override void OnUpdate(float deltaTime)
    {
    }
    
    #region UI Create building
    
    //建造相关（生成的假建筑）
    public FakeBuilding preCreateBuild;//拖出来的建筑
    public Queue<FakeBuilding> placeFalseBuild;//点击建造放下的建筑
    public GameObject attackRange;
    public bool isPaitai = false;
    //拖出建筑
    public void UICreateBuilding(int buildId, long buildUuid, int point,int buildTopType,LuaTable noBuildList = null)
    {
        var model = GameEntry.Lua.CallWithReturn<string, int, int>(
            "CSharpCallLuaInterface.GetCityBuildingModelName",
            buildId, 1);
        if (model.IsNullOrEmpty() == false )
        {
            preCreateBuild = new FakeBuilding();
            var request = GameEntry.Resource.InstantiateAsync(string.Format(GameDefines.EntityAssets.Building,model));
            preCreateBuild.request = request;
            request.completed += delegate
            {
                preCreateBuild.city = request.gameObject.GetComponent<CityBuilding>();
                preCreateBuild.city.CSInit(new CityBuilding.Param()
                {
                    buildId = buildId,
                    buildUuid =  buildUuid,
                    point = point,
                    BuildTopType = (PlaceBuildType)buildTopType,
                    noPutPoint = noBuildList,
                    buildSceneType = CityBuilding.BuildSceneType.Fake,
                    noDoAnim = true,
                    visible = true,
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
                placeFalseBuild = new Queue<FakeBuilding>();
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
            if (build != null)
            {
                build.city.CSUninit();
                build.request.Destroy();
            }
        }
    }
    //建造结束

    #endregion
    
}