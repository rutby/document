using System;
using System.Collections.Generic;

public class ResourceUtils
{
    private static Dictionary<ResourceType, List<int>> resourceTargetBuildType = new Dictionary<ResourceType, List<int>>{
        {ResourceType.Oil, new List<int>(){GameDefines.BuildingTypes.FUN_BUILD_OIL}},
        {ResourceType.Metal, new List<int>(){GameDefines.BuildingTypes.FUN_BUILD_STONE}},
        {ResourceType.Water, new List<int>(){GameDefines.BuildingTypes.FUN_BUILD_WATER}},
        {ResourceType.Electricity, new List<int>(){GameDefines.BuildingTypes.FUN_BUILD_ELECTRICITY,
                GameDefines.BuildingTypes.FUN_BUILD_WIND_TURBINE, GameDefines.BuildingTypes.FUN_BUILD_SOLAR_POWER_STATION}},
    };

    public static Dictionary<ResourceType, List<int>> pairStorage = new Dictionary<ResourceType, List<int>>
    {
        {
            ResourceType.Oil,
        new List<int>()
            {
            GameDefines.BuildingTypes.FUN_BUILD_OIL_STORAGE,
        
            }
        },
        {
        ResourceType.Metal,
        new List<int>()
            {
          
            }
        },
        {
        ResourceType.Water,
        new List<int>()
            {
            GameDefines.BuildingTypes.FUN_BUILD_WATER_STORAGE,
         
            }
        },
        {
        ResourceType.Electricity,
        new List<int>()
            {
            GameDefines.BuildingTypes.FUN_BUILD_ELECTRICITY_STORAGE,
        
            }
        },
       
    };
    public static string GetResourceImagePath(ResourceType resType)
    {
        switch (resType)
        {
            case ResourceType.Oil:
                return "Assets/Main/Sprites/UI/Common/Common_icon_oil";
            case ResourceType.Metal:
                return "Assets/Main/Sprites/UI/Common/Common_icon_metal";
            case ResourceType.Water:
                return "Assets/Main/Sprites/UI/Common/Common_icon_water";
            case ResourceType.Electricity:
                return "Assets/Main/Sprites/UI/Common/Common_icon_electricity";
            case ResourceType.Money:
                return "Assets/Main/Sprites/UI/Common/Common_icon_money";
            case ResourceType.GOLD:
                return "Assets/Main/Sprites/UI/Common/Common_icon_gold";
            default:
                return "";
        }
    }

    public static string GetRewardTypeImagePath(int resType)
    {
        switch ((RewardType)resType)
        {
            case RewardType.FOOD:
                return "ui_food_max";
            case RewardType.OIL:
                return "ui_oil_max";
            case RewardType.METAL:
                return "ui_metal_max";
            case RewardType.NUCLEAR:
                return "ui_nuclear_max";
            case RewardType.WATER:
                return "ui_water_max";
            case RewardType.TRADE:
                return "ui_gold";
            case RewardType.ELECTRICITY:
                return "ui_electricity_max";
            case RewardType.PEOPLE:
                return "ui_people_max";
            case RewardType.MONEY:
                return "ui_money_max";
            case RewardType.HONOR:
                return "u_alliance_contributeicon02";
            case RewardType.ALLIANCE_POINT:
                return "u_alliance_contributeicon01";
            default:
                return "";
        }
    }

    public static string GetRewardTypeName(int resType)
    {
        switch ((RewardType)resType)
        {
            case RewardType.FOOD:
                return "107514";
            case RewardType.OIL:
                return "107511";
            case RewardType.METAL:
                return "107512";
            case RewardType.NUCLEAR:
                return "100088";
            case RewardType.WATER:
                return "100546";
            case RewardType.TRADE:
                return "100183";
            case RewardType.ELECTRICITY:
                return "100002";
            case RewardType.PEOPLE:
                return "100396";
            case RewardType.MONEY:
                return "100000";
            case RewardType.HONOR:
                return "390261";
            case RewardType.ALLIANCE_POINT:
                return "390266";
            default:
                return "";
        }
    }
    
    

    public static List<int> GetResourceTypeCityBuildingByType(int type)
    {

        ResourceType type1 = (ResourceType)type;
        if (resourceTargetBuildType.ContainsKey(type1))
        {
            return resourceTargetBuildType[type1];
        }
        return new List<int>();
    }

    public static int GetResourcesTypeByCityBuildingType(int type)
    {
        switch (type)
        {
            case GameDefines.BuildingTypes.FUN_BUILD_OIL:
                return (int)ResourceType.Oil;
            case GameDefines.BuildingTypes.FUN_BUILD_ELECTRICITY:
                return (int)ResourceType.Electricity;
            case GameDefines.BuildingTypes.FUN_BUILD_WIND_TURBINE:
                return (int)ResourceType.Electricity;
            case GameDefines.BuildingTypes.FUN_BUILD_SOLAR_POWER_STATION:
                return (int)ResourceType.Electricity;
            case GameDefines.BuildingTypes.FUN_BUILD_WATER:
                return (int)ResourceType.Water;
            case GameDefines.BuildingTypes.FUN_BUILD_STONE:
                return (int)ResourceType.Metal;

        }

        return 0;
    }
    
    

    public static ResourceType RewardType2ResourceType(RewardType rewardType)
    {

        switch (rewardType)
        {
            case RewardType.OIL:
                return ResourceType.Oil;
            case RewardType.WATER:
                return ResourceType.Water;
            case RewardType.ELECTRICITY:
                return ResourceType.Electricity;
            case RewardType.METAL:
                return ResourceType.Metal;
            case RewardType.MONEY:
                return ResourceType.Money;
            default:
                return ResourceType.Oil;

        }
    }

    
    public static UIMainBottomBuildType GetBuildTabTypeByResourceType(ResourceType type)
    {
        switch (type)
        {
            case ResourceType.Oil:
                return UIMainBottomBuildType.Oil;
            case ResourceType.Metal:
                return UIMainBottomBuildType.Metal;
            case ResourceType.Water:
                return UIMainBottomBuildType.Water;
            case ResourceType.Electricity:
                return UIMainBottomBuildType.Electricity;
            case ResourceType.Money:
                return UIMainBottomBuildType.People;
            default:
                return UIMainBottomBuildType.Build;
        }
    }
    
    public static ResourceType GetResourceTypeByBuildTabType(UIMainBottomBuildType type)
    {
        switch (type)
        {
            case UIMainBottomBuildType.Oil:
                return ResourceType.Oil;
            case UIMainBottomBuildType.Metal:
                return ResourceType.Metal;
            case UIMainBottomBuildType.Water:
                return ResourceType.Water;
            case UIMainBottomBuildType.Electricity:
                return ResourceType.Electricity;
        }

        return ResourceType.Money;
    }

    //public delegate void LoadSpriteCallback(Sprite spr);
    //public static string SetSpriteOfImage(string imageFilePathName,
    //    LoadSpriteCallback loadCallback = null)
    //{
    //    string imagePrefabPathName = imageFilePathName.Replace("png", "prefab");
    //    LoadAssetWithPath(imagePrefabPathName, new GameFramework.Resource.LoadAssetCallbacks(
    //        (string assetName, object asset, float duration, object userData) =>
    //        {
    //            GameObject prefab = asset as GameObject;
    //            var temp = prefab.GetComponent<SpriteRenderer>();
    //            loadCallback?.Invoke(temp.sprite);
    //        },
    //        (string assetName, GameFramework.Resource.LoadResourceStatus status, string errorMessage, object userData) =>
    //        {
    //            Log.Error("load {0} failed::{1}", assetName, errorMessage);
    //            loadCallback?.Invoke(null);
    //        }
    //    ));

    //    Debug.LogError("#########################Check memery leak! " + imagePrefabPathName);

    //    return imagePrefabPathName;
    //}

    //这个函数可以弃用了
    //public static string SetHeroIconColor(int color)
    //{
    //    if (color == 2) //蓝
    //    {
    //        return "free_color_icon_kuang_blue";
    //    }

    //    if (color == 3) //紫
    //    {
    //        return "free_color_icon_kuang_purple";
    //    }

    //    if (color == 4) //橙
    //    {
    //        return "free_color_icon_kuang_orage";
    //    }

    //    if (color == 0) //白
    //    {
    //        return "free_color_icon_kuang_white";
    //    }

    //    if (color == 1) //绿
    //    {
    //        return "free_color_icon_kuang_green";
    //    }

    //    return "";
    //}

    public static float ArmyConsume(int resourcesType) //士兵消耗
    {
        // var armys = GameEntry.Data.Army.Armys;
         float index = 0;
        // for (int i = 0; i < armys.Count; i++)
        // {
        //     int total = armys[i].free + armys[i].march + armys[i].hide;
        //     if (total <= 0)
        //     {
        //         continue;
        //     }
        //     ArmyTemplate xmlData = GameEntry.DataTable.GetArmyTemplate(armys[i].id);
        //     if (resourcesType == (int)ResourceType.Food)
        //     {
        //         if (xmlData.arm_1 == GameDefines.SoldierType.WARRIOR ||
        //             xmlData.arm_1 == GameDefines.SoldierType.SHOOTER) //1 3 消耗粮食
        //         {
        //             index += armys[i].upkeep * total;
        //         }
        //     }
        //     else if (resourcesType == (int)ResourceType.Oil)
        //     {
        //         if (xmlData.arm_1 == GameDefines.SoldierType.BATTLECAR) //2消耗油
        //         {
        //             index += armys[i].upkeep * total;
        //         }
        //     }
        // }

        return index;
    }
    

    public static long GetResourceItemCount(int type)
    {
        long sm_count = 0;
        // var type2 = type;
        // foreach (var sm_per in GameEntry.Data.Items.ItemInfos)
        // {
        //     var sm_xml = GameEntry.Data.Items.GetItemXmlById(sm_per.Key);
        //     if (sm_xml != null)
        //     {
        //         if (sm_xml.type == (int)ItemType.USE && sm_xml.type2 == type2)
        //         {
        //             if (sm_xml.para != null)
        //             {
        //                 sm_count += (sm_per.Value.count * sm_xml.para.ToLong());
        //             }
        //             else
        //             {
        //                 sm_count += sm_per.Value.count;
        //             }
        //         }
        //     }
        //
        // }
        return sm_count;
    }

    //通过资源类型获取可以急速的建筑id
    public static int GetOutBuildByResType(ResourceType resourceType)
    {
        if (resourceType == ResourceType.Electricity)
        {
            return GameDefines.BuildingTypes.FUN_BUILD_ELECTRICITY;
        }
        else
        {
            //先把资源类型转为世界资源类型
            if (resourceTargetBuildType.ContainsKey(resourceType))
            {
                List<int> buildTypes = resourceTargetBuildType[resourceType];
                if (buildTypes != null && buildTypes.Count > 0)
                {
                    return buildTypes[0];
                }
            }
        }
        return 0;
    }

    
}