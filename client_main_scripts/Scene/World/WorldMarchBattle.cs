
using Protobuf;
using System.Collections.Generic;
using Sfs2X.Entities.Data;
using UnityEngine;
using System;
using GameFramework;
using Google.Protobuf.Collections;

//
// 世界行军战斗
//
#if false
public partial class WorldMarchDataManager
{
    //普攻击ID
    public const int normalAttackId = 100000;
    private const string sheldPath = "Assets/_Art/Effect/prefab/hero/Shaonian/VFX_shaonian_hudun.prefab";
    enum BatleResult
    {
        DEFAULT = -1,
        SELF_WIN = 0,
        OTHER_WIN = 1,
        DRAW = 2,
    }
    public enum BattleWordType
    {
        Normal,
        Cure,
        Skill,
        CarSkill,
        CriticalAttack,
    }
    //判断是否为联合编队
    private static bool IsCombine(CombatUnitType type)
    {
        switch (type)
        {
            case CombatUnitType.RALLY_TEAM:
            case CombatUnitType.THRONE_ARMY:
            case CombatUnitType.CITY:
            case CombatUnitType.BUILDING:
            case CombatUnitType.TOWER:
            case CombatUnitType.Desert:
            case CombatUnitType.TRAIN_DESERT:
            case CombatUnitType.ALLIANCE_OCCUPIED_CITY:
            case CombatUnitType.ALLIANCE_BUILDING:
            case CombatUnitType.ACT_ALLIANCE_MINE:
            case CombatUnitType.NPC_CITY:
            case CombatUnitType.CROSS_WORM:
            case CombatUnitType.DRAGON_BUILDING:
            case CombatUnitType.CROSS_THRONE:
                
                return true;
        }
        return false;
    }
    //是否编队在视口内
    private bool IsArmyInView(long uuid, CombatUnitType combineType)
    {
        if (combineType == CombatUnitType.ALLIANCE_NEUTRAL_CITY
            || combineType == CombatUnitType.ALLIANCE_OCCUPIED_CITY
            || combineType == CombatUnitType.ALLIANCE_BUILDING
            || combineType == CombatUnitType.ACT_ALLIANCE_MINE
            || combineType == CombatUnitType.NPC_CITY
            ||combineType == CombatUnitType.CITY
            || combineType == CombatUnitType.BUILDING
            || combineType == CombatUnitType.TOWER
            || combineType == CombatUnitType.EXPLORE_POINT
            ||combineType == CombatUnitType.DRAGON_BUILDING
            || combineType == CombatUnitType.CROSS_THRONE
            || combineType == CombatUnitType.CROSS_WORM
        )
        {
            var pointInfo = world.GetPointInfoByUuid(uuid);
            if (pointInfo != null && IsInView(world.TileIndexToWorld(pointInfo.mainIndex)))
                return true;
        }
        else if (combineType == CombatUnitType.RALLY_TEAM 
                 || combineType == CombatUnitType.ARMY
                 ||combineType == CombatUnitType.MONSTER
                 ||combineType == CombatUnitType.BOSS
                 ||combineType == CombatUnitType.MONSTER_SIEGE
                 ||combineType == CombatUnitType.ACT_BOSS
                 ||combineType == CombatUnitType.PUZZLE_BOSS
                 ||combineType == CombatUnitType.THRONE_ARMY
                 ||combineType == CombatUnitType.CHALLENGE_BOSS
                 ||combineType == CombatUnitType.ALLIANCE_BOSS)
        {
            var march = GetMarch(uuid);
            if (march != null && IsInView(march.position))
                return true;
        }

        return false;
    }
    /// <summary>
    /// 战斗逻辑入口
    /// </summary>
    /// <param name="message"></param>
    public void UpdateBattleMessage(ISFSObject message)
    {
        var bytes = Convert.FromBase64String(message.GetUtfString("content"));
       
        var basePushInfo = BattleRoundPushInfo.Parser.ParseFrom(bytes);
        


        CombatUnitType combatType = (CombatUnitType)basePushInfo.Type;

        if(IsCombine(combatType))
        {
            if (basePushInfo.CombineArmyInfo != null)
            {
                UpdateCombineArmyInfo(basePushInfo.CombineArmyInfo, basePushInfo.OutRange,basePushInfo.RoundReports,combatType,basePushInfo.SelfBesieged,basePushInfo.TargetBesieged);
            }
            if (basePushInfo.SimpleArmyInfo != null)
            {
                UpdateSimpleArmyInfo(basePushInfo.SimpleArmyInfo, basePushInfo.OutRange,basePushInfo.RoundReports,combatType,basePushInfo.SelfBesieged,basePushInfo.TargetBesieged);
            }
        }
        else
        {
            if (basePushInfo.SimpleArmyInfo != null)
            {
                UpdateSimpleArmyInfo(basePushInfo.SimpleArmyInfo, basePushInfo.OutRange,basePushInfo.RoundReports,combatType,basePushInfo.SelfBesieged,basePushInfo.TargetBesieged);
            }
            
        }
    }
    
    /// <summary>
    /// 联合编队逻辑
    /// </summary>
    private void UpdateCombineArmyInfo(CombineSelfArmyInfo combineArmyInfo,bool outRange,RepeatedField<BaseRoundReportPush> roundReports,CombatUnitType combineType,bool selfBesieged,bool targetBesieged)
    {
        var armyMembers = combineArmyInfo.Members;
        var targetArmyInfo = combineArmyInfo.TargetInfo;
        long topUuid = 0;
        int topPointId = 0;
        if (outRange)
        {
            return;
        }
        var selfArmyUuidList = new Dictionary<long, bool>();
        //查找出最外层父节点uuid,以及所有的子Uuid
        foreach (var VARIABLE in armyMembers)
        {
            if (combineType == CombatUnitType.Desert || combineType == CombatUnitType.TRAIN_DESERT)
            {
                if (topPointId ==0 && VARIABLE.ArmyInfo != null)
                {
                    topPointId = VARIABLE.ArmyInfo.TopPointId;
                }
                if (VARIABLE.ArmyInfo != null && VARIABLE.ArmyInfo.ArmyInfo != null && VARIABLE.ArmyInfo.Type == (int)CombatUnitType.ARMY)//如果地块里面有驻扎编队，获取marchUuid
                {
                    selfArmyUuidList[VARIABLE.ArmyInfo.ArmyInfo.Uuid] = true;
                }
            }
            else
            {
                if (topUuid==0 && VARIABLE.ArmyInfo != null)
                {
                    topUuid = VARIABLE.ArmyInfo.TopUuid;
                }
                if (VARIABLE.ArmyInfo != null && VARIABLE.ArmyInfo.ArmyInfo != null)
                {
                    selfArmyUuidList[VARIABLE.ArmyInfo.ArmyInfo.Uuid] = true;
                }
            }

           
        }

        if (combineType == CombatUnitType.RALLY_TEAM)
        {
            topUuid = 0;
            foreach (var VARIABLE in selfArmyUuidList)
            {
                var marchData = GetMarch(VARIABLE.Key);
                if (marchData != null)
                {
                    var march = GetAllianceMarchesInTeam(marchData.allianceUid, marchData.teamUuid);
                    if (march != null)
                    {
                        topUuid = march.uuid;
                    }
                }
            }
        }
        else if (combineType == CombatUnitType.THRONE_ARMY)
        {
            topUuid = 0;
            foreach (var VARIABLE in selfArmyUuidList)
            {
                var marchData = GetMarch(VARIABLE.Key);
                if (marchData != null)
                {
                    var march = GetAllianceMarchesInTeam(marchData.allianceUid, marchData.teamUuid);
                    if (march != null)
                    {
                        topUuid = march.uuid;
                    }
                }
            }
        }
        
        if (combineType == CombatUnitType.Desert || combineType == CombatUnitType.TRAIN_DESERT)
        {
            if (IsInView(world.TileIndexToWorld(topPointId))== false)
            {
                return;
            }
            topUuid = 0;
            foreach (var VARIABLE in selfArmyUuidList)
            {
                var marchData = GetMarch(VARIABLE.Key);
                if (marchData != null)
                {
                    topUuid = marchData.uuid;
                }
            }
            // 治疗
            var heal = 0;
            //开罩
            var shield = -1;
            var normalHurt = 0;
            var skillHurt = 0;
            var showSelfSkillId = 0;
            var showHurtSkillId = 0;
            var carSkillHurt = 0;
            var damageEffectType = (int)APSDamageEffectType.DEFAULT;
            var criticalAttack = 0;//暴击伤害
            var isActiveAttack = false;//是否主动攻击
            var effectBuffList = new List<int>();
            var effectStr = "";
            for (int i = 0; i < roundReports.Count; i++)
            {
                var report = roundReports[i];
                foreach (var VARIABLE in selfArmyUuidList)
                {
                    CheckArmyDoSkill(VARIABLE.Key, report,ref showSelfSkillId, ref showHurtSkillId,ref skillHurt,ref normalHurt,ref carSkillHurt,ref isActiveAttack,ref effectBuffList,ref damageEffectType,ref criticalAttack);
                }
            }
            var health = 0;
            var initHealth = 0;
            var totalSoldierNum = 0;
            foreach (var VARIABLE in armyMembers)//只显示原守军血量
            {
                if (VARIABLE.ArmyInfo != null && VARIABLE.ArmyInfo.ArmyInfo != null)
                {
                    var armyInfo = VARIABLE.ArmyInfo.ArmyInfo;
                    health += armyInfo.Health;
                    initHealth += armyInfo.InitHealth;
                }
            }
            var march = world.GetMarch(topUuid);
            if (march != null)
            {
                var str = topPointId + ";" + health + ";" + initHealth + ";" + topUuid;
                GameEntry.Event.Fire(EventId.ShowDesertAttackHeadUI,str);
            }
            else
            {
                var str = topPointId +";"+ health +";"+ initHealth;
                GameEntry.Event.Fire(EventId.ShowDesertAttackHeadUI,str);
            }
            
            ShowDesertBloodHurt(topPointId, normalHurt, skillHurt, heal,carSkillHurt,criticalAttack);
        }
        else if (topUuid != 0)
        {
            if (!IsArmyInView(topUuid, combineType))
            {
                return;
            }
            // 治疗
            var heal = 0;
            //开罩
            var shield = -1;
            var normalHurt = 0;
            var skillHurt = 0;
            var showSelfSkillId = 0;
            var showHurtSkillId = 0;
            var carSkillHurt = 0;
            var damageEffectType = (int)APSDamageEffectType.DEFAULT;
            var criticalAttack = 0;//暴击伤害
            var isActiveAttack = false;//是否主动攻击
            var effectBuffList = new List<int>();
            var effectStr = "";
            for (int i = 0; i < roundReports.Count; i++)
            {
                var report = roundReports[i];
                foreach (var VARIABLE in selfArmyUuidList)
                {
                    CheckArmyDoSkill(VARIABLE.Key, report,ref showSelfSkillId, ref showHurtSkillId,ref skillHurt,ref normalHurt,ref carSkillHurt,ref isActiveAttack,ref effectBuffList,ref damageEffectType,ref criticalAttack);
                }
            }
            for (int i = 0; i < effectBuffList.Count; i++)
            {
                effectStr += effectBuffList[i].ToString();
                if (i < effectBuffList.Count - 1)
                {
                    effectStr += ";";
                }
            }
            if (combineType == CombatUnitType.ALLIANCE_OCCUPIED_CITY)
            {
                foreach (var VARIABLE in armyMembers)//只显示原守军血量
                {
                    if (VARIABLE.ArmyInfo != null && VARIABLE.ArmyInfo.SpecialArmyType!= (int)APSSpecialUnitType.ALLIANCE_CITY_POLICE_NPC &&  VARIABLE.ArmyInfo.ArmyInfo != null)
                    {
                        var armyInfo = VARIABLE.ArmyInfo.ArmyInfo;
                        if (armyInfo.Uuid == topUuid)
                        {
                            AllianceCityUpdateHeadUI(topUuid, armyInfo.Health, armyInfo.InitHealth);
                            break;
                        }
                    }
                }
                ShowAllianceCityBloodHurt(topUuid, normalHurt, skillHurt, heal,carSkillHurt,criticalAttack);
                ShowAllianceCityBuff(topUuid, effectStr);
            }
            else if (combineType == CombatUnitType.RALLY_TEAM)
            {
                long targetID = targetArmyInfo == null ? 0 : targetArmyInfo.TopUuid;
                SetTroopAttack(topUuid, targetID,isActiveAttack);
                // ShowShieldEffect(topUuid, shield);
                //飘字
                ShowTroopBloodHurt(topUuid, normalHurt, skillHurt,heal,carSkillHurt,criticalAttack);
                var anger = 0;
                var health = 0;
                var initHealth = 0;
                var carAnger = 0;
                foreach (var VARIABLE in armyMembers)//只显示原守军血量
                {
                    if (VARIABLE.ArmyInfo != null && VARIABLE.ArmyInfo.ArmyInfo != null)
                    {
                        var armyInfo = VARIABLE.ArmyInfo.ArmyInfo;
                        health += armyInfo.Health;
                        initHealth += armyInfo.InitHealth;
                    }
                }
                //头像变化
                TroopUpdateHeadUI(topUuid, anger, health, initHealth,carAnger);
                if (targetBesieged)
                {
                    ShowSiegeAttack(topUuid);
                }
                
                ShowTroopBuff(topUuid, effectStr);
                ShowTroopDamageDes(topUuid,damageEffectType);
            }
            else if (combineType == CombatUnitType.THRONE_ARMY)
            {
                //飘字
                ShowThroneBloodHurt(topUuid, normalHurt, skillHurt,heal,carSkillHurt,criticalAttack);
                var anger = 0;
                var health = 0;
                var initHealth = 0;
                var carAnger = 0;
                foreach (var VARIABLE in armyMembers)//只显示原守军血量
                {
                    if (VARIABLE.ArmyInfo != null && VARIABLE.ArmyInfo.ArmyInfo != null)
                    {
                        var armyInfo = VARIABLE.ArmyInfo.ArmyInfo;
                        health += armyInfo.Health;
                        initHealth += armyInfo.InitHealth;
                    }
                }
                //头像变化
                ThroneUpdateHeadUI(topUuid, health, initHealth);
                ShowThroneBuff(topUuid, effectStr);
            }
            else if (combineType == CombatUnitType.CITY || combineType == CombatUnitType.TOWER ||
                      combineType == CombatUnitType.BUILDING || combineType == CombatUnitType.CROSS_WORM)
            {
                var health = 0;
                var initHealth = 0;
                var totalSoldierNum = 0;
                foreach (var VARIABLE in armyMembers)//只显示原守军血量
                {
                    if (VARIABLE.ArmyInfo != null && VARIABLE.ArmyInfo.ArmyInfo != null)
                    {
                        var armyInfo = VARIABLE.ArmyInfo.ArmyInfo;
                        health += armyInfo.Health;
                        initHealth += armyInfo.InitHealth;
                    }
                }
                var str = topUuid +";"+ health +";"+ initHealth;
                GameEntry.Event.Fire(EventId.ShowBuildAttackHeadUI,str);
                ShowPlayerBuildBloodHurt(topUuid, normalHurt, skillHurt, heal,carSkillHurt,criticalAttack);
                ShowPlayerBuildBuff(topUuid, effectStr);
            }
            else if (combineType == CombatUnitType.ALLIANCE_BUILDING)
            {
                var health = 0;
                var initHealth = 0;
                var totalSoldierNum = 0;
                foreach (var VARIABLE in armyMembers)//只显示原守军血量
                {
                    if (VARIABLE.ArmyInfo != null && VARIABLE.ArmyInfo.ArmyInfo != null)
                    {
                        var armyInfo = VARIABLE.ArmyInfo.ArmyInfo;
                        health += armyInfo.Health;
                        initHealth += armyInfo.InitHealth;
                    }
                }
                var str = topUuid +";"+ health +";"+ initHealth;
                GameEntry.Event.Fire(EventId.ShowAllianceBuildAttackHeadUI,str);
                ShowAllianceBuildBloodHurt(topUuid, normalHurt, skillHurt, heal,carSkillHurt,criticalAttack);
                ShowAllianceBuildBuff(topUuid, effectStr);
            }
            else if (combineType == CombatUnitType.ACT_ALLIANCE_MINE)
            {
                var health = 0;
                var initHealth = 0;
                var totalSoldierNum = 0;
                foreach (var VARIABLE in armyMembers)//只显示原守军血量
                {
                    if (VARIABLE.ArmyInfo != null && VARIABLE.ArmyInfo.ArmyInfo != null )
                    {
                        var armyInfo = VARIABLE.ArmyInfo.ArmyInfo;
                        health += armyInfo.Health;
                        initHealth += armyInfo.InitHealth;
                    }
                }
                var str = topUuid +";"+ health +";"+ initHealth;
                GameEntry.Event.Fire(EventId.ShowActAllianceBuildAttackHeadUI,str);
                ShowAllianceBuildBloodHurt(topUuid, normalHurt, skillHurt, heal,carSkillHurt,criticalAttack);
                ShowAllianceBuildBuff(topUuid, effectStr);
            }
            else if (combineType == CombatUnitType.DRAGON_BUILDING)
            {
                var health = 0;
                var initHealth = 0;
                var totalSoldierNum = 0;
                foreach (var VARIABLE in armyMembers)//只显示原守军血量
                {
                    if (VARIABLE.ArmyInfo != null && VARIABLE.ArmyInfo.ArmyInfo != null)
                    {
                        var armyInfo = VARIABLE.ArmyInfo.ArmyInfo;
                        health += armyInfo.Health;
                        initHealth += armyInfo.InitHealth;
                    }
                }
                var str = topUuid +";"+ health +";"+ initHealth;
                GameEntry.Event.Fire(EventId.ShowDragonBuildAttackHeadUI,str);
                ShowDragonBuildBloodHurt(topUuid, normalHurt, skillHurt, heal,carSkillHurt,criticalAttack);
                ShowDragonBuildBuff(topUuid, effectStr);
            }
            else if (combineType == CombatUnitType.CROSS_THRONE)
            {
                var health = 0;
                var initHealth = 0;
                var totalSoldierNum = 0;
                foreach (var VARIABLE in armyMembers)//只显示原守军血量
                {
                    if (VARIABLE.ArmyInfo != null && VARIABLE.ArmyInfo.ArmyInfo != null)
                    {
                        var armyInfo = VARIABLE.ArmyInfo.ArmyInfo;
                        health += armyInfo.Health;
                        initHealth += armyInfo.InitHealth;
                        if (VARIABLE.ArmyInfo.Type == (int)CombatUnitType.ARMY)
                        {
                            var uuid = VARIABLE.ArmyInfo.ArmyInfo.Uuid;
                            var marchData = world.GetMarch(uuid);
                            if (marchData != null)
                            {
                                totalSoldierNum+= marchData.GetSoliderNum();
                            }
                        }
                    }
                }

                var str = topUuid + ";" + health + ";" + initHealth + ";" + totalSoldierNum;
                GameEntry.Event.Fire(EventId.ShowCrossThroneAttackHeadUI,str);
                ShowCrossThroneBloodHurt(topUuid, normalHurt, skillHurt, heal,carSkillHurt,criticalAttack);
                ShowCrossThroneBuff(topUuid, effectStr);
            }
            else if (combineType == CombatUnitType.NPC_CITY)
            {
                var health = 0;
                var initHealth = 0;
                var totalSoldierNum = 0;
                foreach (var VARIABLE in armyMembers)//只显示原守军血量
                {
                    if (VARIABLE.ArmyInfo != null && VARIABLE.ArmyInfo.ArmyInfo != null)
                    {
                        var armyInfo = VARIABLE.ArmyInfo.ArmyInfo;
                        health += armyInfo.Health;
                        initHealth += armyInfo.InitHealth;
                    }
                }
                var str = topUuid +";"+ health +";"+ initHealth;
                GameEntry.Event.Fire(EventId.ShowNPCBuildAttackHeadUI,str);
                ShowNPCBuildBloodHurt(topUuid, normalHurt, skillHurt, heal,carSkillHurt,criticalAttack);
                ShowNPCBuildBuff(topUuid, effectStr);
            }
        }
    }
    /// <summary>
    /// 单编队逻辑
    /// </summary>
    private void UpdateSimpleArmyInfo(SimpleSelfArmyInfo selfArmyInfo,bool outRange,RepeatedField<BaseRoundReportPush> roundReports,CombatUnitType combineType,bool selfBesieged,bool targetBesieged)
    {
        var armyInfo = selfArmyInfo.ArmyInfo;
        var targetArmyInfo = selfArmyInfo.TargetInfo;
        // 治疗
        var heal = selfArmyInfo.Heal;
        //开罩
        var shield = selfArmyInfo.Shield;
        
        if (armyInfo.TopUuid != 0 && !outRange)
        {
            if (!IsArmyInView(armyInfo.TopUuid, combineType))
            {
                return;
            }
            var normalHurt = 0;
            var skillHurt = 0;
            var showSelfSkillId = 0;
            var showHurtSkillId = 0;
            var carSkillHurt = 0;
            var damageEffectType = (int)APSDamageEffectType.DEFAULT;
            var criticalAttack = 0;//暴击伤害
            var isActiveAttack = false;//是否主动攻击
            var effectBuffList = new List<int>();
            var effectStr = "";
            for (int i = 0; i < roundReports.Count; i++)
            {
                var report = roundReports[i];
                CheckArmyDoSkill(armyInfo.TopUuid, report,ref showSelfSkillId, ref showHurtSkillId,ref skillHurt,ref normalHurt,ref carSkillHurt,ref isActiveAttack,ref effectBuffList,ref damageEffectType,ref criticalAttack);
            }
            for (int i = 0; i < effectBuffList.Count; i++)
            {
                effectStr += effectBuffList[i].ToString();
                if (i < effectBuffList.Count - 1)
                {
                    effectStr += ";";
                }
            }
            if (combineType == CombatUnitType.ALLIANCE_NEUTRAL_CITY)
            {
                if (armyInfo.SpecialArmyType != (int)APSSpecialUnitType.ALLIANCE_CITY_POLICE_NPC)
                {
                    AllianceCityUpdateHeadUI(armyInfo.TopUuid, armyInfo.ArmyInfo.Health, armyInfo.ArmyInfo.InitHealth);
                }
                ShowAllianceCityBloodHurt(armyInfo.TopUuid, normalHurt, skillHurt, heal,carSkillHurt,criticalAttack);
                ShowAllianceCityBuff(armyInfo.TopUuid, effectStr);
            }
            else if (combineType == CombatUnitType.ARMY
                     || combineType == CombatUnitType.MONSTER
                     || combineType == CombatUnitType.MONSTER_SIEGE
                     || combineType == CombatUnitType.BOSS
                     || combineType == CombatUnitType.ACT_BOSS
                     || combineType == CombatUnitType.PUZZLE_BOSS
                     || combineType == CombatUnitType.CHALLENGE_BOSS
                     || combineType == CombatUnitType.ALLIANCE_BOSS)
            {
                //攻击表现，状态机切换
                long targetID = targetArmyInfo == null ? 0 : targetArmyInfo.TopUuid;
                if (targetArmyInfo!=null && targetArmyInfo.Type == (int)CombatUnitType.RALLY_TEAM)
                {
                    targetID = 0;
                }
                SetTroopAttack(armyInfo.TopUuid, targetID,isActiveAttack);
                //护盾表现
                ShowShieldEffect(armyInfo.TopUuid, shield);
                //释放技能表现
                ShowTroopSkill(armyInfo.TopUuid, showSelfSkillId, showHurtSkillId);
                //飘字
                ShowTroopBloodHurt(armyInfo.TopUuid, normalHurt, skillHurt,heal,carSkillHurt,criticalAttack);
                
                //头像变化
                if (combineType == CombatUnitType.ACT_BOSS || combineType == CombatUnitType.PUZZLE_BOSS)
                {
                    ActBossUpdateHeadUI(armyInfo.TopUuid, selfArmyInfo.Anger, armyInfo.ArmyInfo.Health,
                        armyInfo.ArmyInfo.InitHealth);
                }
                else if(combineType == CombatUnitType.ALLIANCE_BOSS)
                {
                    AllianceBossUpdateHeadUI(armyInfo.TopUuid, selfArmyInfo.Anger, armyInfo.ArmyInfo.Health,
                        armyInfo.ArmyInfo.InitHealth);
                }
                else
                {
                    TroopUpdateHeadUI(armyInfo.TopUuid, selfArmyInfo.Anger, armyInfo.ArmyInfo.Health, armyInfo.ArmyInfo.InitHealth,selfArmyInfo.CarAnger);
                    if (targetBesieged)
                    {
                        ShowSiegeAttack(armyInfo.TopUuid);
                    }
                }
                
                ShowTroopBuff(armyInfo.TopUuid, effectStr);
                ShowTroopDamageDes(armyInfo.TopUuid,damageEffectType);
            }
            else if (combineType == CombatUnitType.TOWER)
            {
                if (targetArmyInfo != null && targetArmyInfo.ArmyInfo != null)
                {
                    BuildingAttack(armyInfo.ArmyInfo.Uuid, targetArmyInfo.ArmyInfo.Uuid);
                    ShowPlayerBuildBuff(armyInfo.ArmyInfo.Uuid, effectStr);
                }
            }
            else if (combineType == CombatUnitType.EXPLORE_POINT)
            {
                long targetID = targetArmyInfo == null ? 0 : targetArmyInfo.TopUuid;
                ExploreAttack(armyInfo.TopUuid, targetID, armyInfo.ArmyInfo.Health, armyInfo.ArmyInfo.Health, armyInfo.ArmyInfo.InitHealth);
                ExploreUpdateHeadUI(armyInfo.TopUuid, selfArmyInfo.Anger, armyInfo.ArmyInfo.Health, armyInfo.ArmyInfo.InitHealth);
                ShowExploreSkill(armyInfo.TopUuid, showSelfSkillId, showHurtSkillId);
                ShowExploreBloodHurt(armyInfo.TopUuid, normalHurt, skillHurt,heal,carSkillHurt,criticalAttack);
                ShowExploreBuff(armyInfo.TopUuid, effectStr);
            }
        }
    }

    /// <summary>
    /// 行军表现
    /// </summary>
    /// 
    private void ShowShieldEffect(long atkUuid,int shield)
    {
        var troop = world.GetTroop(atkUuid);
        if (troop == null)
            return;
        if (shield > 0)
        {
            troop.AddShield();
        }
        else
        {
            troop.DelShield();
        }
    }
    private void SetTroopAttack(long atkUuid,long defAtkUuid,bool isActiveAttack)
    {
        var troop = world.GetTroop(atkUuid);
        if (troop == null)
        {
            return;
        }
        troop.SetRotationRoot();
        troop.SetIsBattle(true);
        var marchInfo = troop.GetMarchInfo();
        if (marchInfo != null && (marchInfo.type == NewMarchType.ACT_BOSS || marchInfo.type == NewMarchType.PUZZLE_BOSS))//|| marchInfo.type == NewMarchType.ALLIANCE_BOSS
        {
            return;
        }
        if (marchInfo != null && (marchInfo.type == NewMarchType.BOSS || marchInfo.type == NewMarchType.MONSTER || marchInfo.type == NewMarchType.CHALLENGE_BOSS || marchInfo.type == NewMarchType.MONSTER_SIEGE || marchInfo.type == NewMarchType.ALLIANCE_BOSS))
        {
            troop.defAtkUuid = 0;
            troop.SetRotation(Quaternion.LookRotation(troop.GetDefenderPosition() - troop.GetPosition()));
            troop.ReSetEntityTarget();
            troop.Attack();
        }
        else if (isActiveAttack)
        {
            //回合战报的防守方ID，临时替换
            troop.defAtkUuid = defAtkUuid;
            var marchData = world.GetMarch(defAtkUuid);
            if (marchData != null)
            {
                if (marchData.ownerUid == GameEntry.Data.Player.Uid)
                {
                    GameEntry.Event.Fire(EventId.ShowBattleRedName,atkUuid);
                }
                
            }
            troop.SetRotation(Quaternion.LookRotation(troop.GetDefenderPosition() - troop.GetPosition()));
            troop.ReSetEntityTarget();
            troop.Attack();
            if (marchInfo != null &&(marchInfo.type == NewMarchType.DEFAULT || marchInfo.type == NewMarchType.NORMAL || marchInfo.type == NewMarchType.DIRECT_MOVE_MARCH || marchInfo.type == NewMarchType.EXPLORE))
            {
                troop.ShowAttack();
            }else if (marchInfo != null && marchInfo.type == NewMarchType.ASSEMBLY_MARCH)
            {
                troop.ShowRallyMarchAttack();
            }
        }
        
    }
    private void ShowTroopSkill(long skillTargetUuid, int selfSkillId, int hurtSkillId)
    {
        var troop = world.GetTroop(skillTargetUuid);
        if (troop == null)
        {
            return;
        }
        if (selfSkillId>0)//主动攻击技能
        {
            troop.DoSkill(selfSkillId,DamageType.USE_SKILL,0,null,0);
            
        }
        if (hurtSkillId>0)//受击技能
        {
            troop.DoSkill(hurtSkillId,DamageType.ATTACK,0,null,0);
        }

        if (selfSkillId > 0)
        {
            GameEntry.Event.Fire(EventId.ShowHeroIconByUseSkill,skillTargetUuid);
        }
        else if (hurtSkillId > 0)
        {
            GameEntry.Event.Fire(EventId.ShowHeroHitedUiEffect, skillTargetUuid);
        }
    }
    private void ShowTroopBloodHurt(long hurtTargetUuid, int normalHurt, int skillHurt,int heal,int carSkillHurt,int criticalAttack)
    {
        if (showBattleBlood == false)
        {
            return;
        }
        if (LOD >= 3)
        {
            return;
        }
        var troop = world.GetTroop(hurtTargetUuid);
        if (troop == null)
        {
            var march = world.GetMarch(hurtTargetUuid);
            if (march != null && march.status == MarchStatus.COLLECTING)
            {
                var pointIndex = march.targetPos;
                ShowCollectPointBloodHurt(pointIndex, normalHurt, skillHurt, heal,carSkillHurt,criticalAttack);
            }
            return;
        }
        if (normalHurt > 0)
        {
            troop.ShowBattleHurt(normalHurt, BattleWordType.Normal);
        }
        if (skillHurt > 0)
        {
            troop.ShowBattleHurt(skillHurt, BattleWordType.Skill);
        }
        if (heal > 0)
        {
            troop.ShowBattleHurt(heal * -1, BattleWordType.Cure);
        }

        if (carSkillHurt > 0)
        {
            troop.ShowBattleHurt(carSkillHurt,BattleWordType.CarSkill);
        }
        if (criticalAttack > 0)
        {
            troop.ShowBattleHurt(criticalAttack,BattleWordType.CriticalAttack);
        }
    }
    private void TroopUpdateHeadUI(long marchUuid, int anger, int hp, int hpMax,int carAnger)
    {
        var troop = world.GetTroop(marchUuid);
        if (troop == null)
        {
            var march = world.GetMarch(marchUuid);
            if (march != null && march.status == MarchStatus.COLLECTING)
            {
                var pointIndex = march.targetPos;
                ShowCollectUpdateHeadUI(marchUuid,pointIndex,anger,hp,hpMax,carAnger);
            }
            return;
        } 
        var str = marchUuid.ToString() +";"+ anger.ToString() +";"+ hp.ToString() +";"+ hpMax.ToString()+";"+carAnger;
        GameEntry.Event.Fire(EventId.ShowTroopBattleValue,str);
    }
    private void ActBossUpdateHeadUI(long marchUuid, int anger, int hp, int hpMax)
    {
        var str = marchUuid.ToString() +";"+ anger.ToString() +";"+ hp.ToString() +";"+ hpMax.ToString();
        GameEntry.Event.Fire(EventId.ShowActBossBattleValue,str);
    }
    private void AllianceBossUpdateHeadUI(long marchUuid, int anger, int hp, int hpMax)
    {
        var str = marchUuid.ToString() +";"+ anger.ToString() +";"+ hp.ToString() +";"+ hpMax.ToString();
        GameEntry.Event.Fire(EventId.ShowAllianceBossBattleValue,str);
    }
    private void ShowTroopBuff(long targetUuid,string effectStr)
    {
        if (!effectStr.IsNullOrEmpty())
        {
            var troop = world.GetTroop(targetUuid);
            if (troop == null)
            {
                var march = world.GetMarch(targetUuid);
                if (march != null && march.status == MarchStatus.COLLECTING)
                {
                    var pointIndex = march.targetPos;
                    ShowCollectPointBuff(targetUuid, pointIndex, effectStr);
                }
                return;
            }
            var str = targetUuid + "|" +world.WorldToTileIndex(troop.GetPosition())+"|"+ effectStr;
            GameEntry.Event.Fire(EventId.ShowBattleBuff,str); 
        }
    }
    
    private void ShowTroopDamageDes(long targetUuid,int damageAttackType)
    {
        if (damageAttackType>0)
        {
            var troop = world.GetTroop(targetUuid);
            if (troop == null)
            {
                return;
            }
            var str = targetUuid + "|" +world.WorldToTileIndex(troop.GetPosition())+"|"+ damageAttackType;
            GameEntry.Event.Fire(EventId.ShowBattleDamageType,str); 
        }
    }
    private void ShowSiegeAttack(long targetUuid)
    {
        var march = world.GetMarch(targetUuid);
        if (march != null && (march.type == NewMarchType.NORMAL || march.type == NewMarchType.ASSEMBLY_MARCH))
        {
            if (march.target == MarchTargetType.ATTACK_ARMY ||
                march.target == MarchTargetType.ATTACK_MONSTER ||
                march.target == MarchTargetType.RALLY_FOR_BOSS)
            {
                var armyInfo = march.GetFirstArmyInfo();
                if (armyInfo != null)
                {
                    var effectValue = armyInfo.GetMarchEffectValue(30296);//围攻作用号
                    if (effectValue > 0)
                    {
                        var targetMarchUuid = march.targetUuid;
                        var targetMarch = world.GetMarch(targetMarchUuid);
                        if (targetMarch != null)
                        {
                            var strDef = targetMarchUuid + "|" + world.WorldToTileIndex(targetMarch.position) + "|" + "1";
                            GameEntry.Event.Fire(EventId.ShowSiegeAttack, strDef);
                            var strAtk = march.uuid+"|"+world.WorldToTileIndex(march.position)+"|" + "2";
                            GameEntry.Event.Fire(EventId.ShowSiegeAttack, strAtk);
                        }
                    }
                        
                    
                }

            }
        }
    }
    
    
    /// <summary>
    /// 探测点表现
    /// </summary>
    ///
    private void ShowExploreSkill(long skillTargetUuid, int selfSkillId, int hurtSkillId)
    {
        var explorePointObject = world.GetObjectByUuid(skillTargetUuid) as WorldExploreObject;

        if (explorePointObject == null)
        {
            return;
        }
        if (selfSkillId>0)//主动攻击技能
        {
            explorePointObject.DoSkill(selfSkillId,DamageType.USE_SKILL,0,null,0);
        }
        if (hurtSkillId>0)//受击技能
        {
            explorePointObject.DoSkill(hurtSkillId,DamageType.ATTACK,0,null,0);
        }
    }
    private void ShowExploreBloodHurt(long hurtTargetUuid, int normalHurt, int skillHurt,int heal,int carSkillHurt,int criticalAttack)
    {
        if (showBattleBlood == false)
        {
            return;
        }

        if (LOD >= 3)
        {
            return;
        }
        var explorePointObject = world.GetObjectByUuid(hurtTargetUuid) as WorldExploreObject;

        if (explorePointObject == null)
        {
            return;
        }
        if (normalHurt > 0)
        {
            explorePointObject.ShowBattleHurt(normalHurt, BattleWordType.Normal);
        }
        if (skillHurt > 0)
        {
            explorePointObject.ShowBattleHurt(skillHurt, BattleWordType.Skill);
        }
        if (heal > 0)
        {
            explorePointObject.ShowBattleHurt(heal * -1, BattleWordType.Cure);
        }
    }
    private void ExploreAttack(long atkUuid, long defenderUid, int soliderNum, int hp, int hpMax)
    {
        var explorePointObject = world.GetObjectByUuid(atkUuid) as WorldExploreObject;
        if (explorePointObject == null)
        {
            return;
        }
        explorePointObject.DoWhenAttackExploreStart(defenderUid, soliderNum, hp, hpMax);
    }
    private void ExploreUpdateHeadUI(long marchUuid, int anger, int hp, int hpMax)
    {
        var explorePointObject = world.GetObjectByUuid(marchUuid) as WorldExploreObject;
        if (explorePointObject == null)
        {
            return;
        }

        explorePointObject.UpdateBattleHeadUI(anger, hp, hpMax);
    }
    private void ShowExploreBuff(long targetUuid,string effectStr)
    {
        if (!effectStr.IsNullOrEmpty())
        {
            var explorePointObject = world.GetObjectByUuid(targetUuid) as WorldExploreObject;

            if (explorePointObject == null)
            {
                return;
            }

            var trans = explorePointObject.GetTransform();
            if (trans == null)
            {
                return;
            }
            var str = targetUuid + "|" +world.WorldToTileIndex(trans.position)+"|"+ effectStr+"|"+(int)WorldPointType.EXPLORE_POINT;
            GameEntry.Event.Fire(EventId.ShowBattleBuff,str); 
        }
    }
    /// <summary>
    /// 联盟城表现
    /// </summary>
    ///
    private void AllianceCityUpdateHeadUI(long cityUuid,int hp, int hpMax)
    {
        var str = cityUuid + ";" + hp + ";" + hpMax;
        GameEntry.Event.Fire(EventId.ShowAllianceCitySoldierBlood, str);
    }
    private void ShowAllianceCityBloodHurt(long hurtTargetUuid, int normalHurt, int skillHurt,int heal,int carSkillHurt,int criticalAttack)
    {
        if (showBattleBlood == false)
        {
            return;
        }
        if (LOD >= 3)
        {
            return;
        }
        var pointInfo = world.GetPointInfoByUuid(hurtTargetUuid);
        if (pointInfo == null)
        {
            return;
        }
        var position = world.TileIndexToWorld(pointInfo.mainIndex) + new Vector3(-6f, 0, -6);
        if (normalHurt > 0)
        {
            string showPath = "Assets/Main/Prefabs/UI/BattleWord/BattleBuildNormalBloodTip.prefab";
            world.ShowBattleBlood(new BattleDecBloodTip.Param()
            {
                startPos = position,
                num = normalHurt,
                path = showPath,
            },showPath);
        }
        if (skillHurt > 0)
        {
            string showPath = "Assets/Main/Prefabs/UI/BattleWord/BattleBuildDecBloodTip.prefab";
            world.ShowBattleBlood(new BattleDecBloodTip.Param()
            {
                startPos = position,
                num = skillHurt,
                path = showPath,
            },showPath);
        }
        if (criticalAttack > 0)
        {
            string showPath = "Assets/Main/Prefabs/UI/BattleWord/BattleBuildCriticalDecBloodTip.prefab";
            world.ShowBattleBlood(new BattleDecBloodTip.Param()
            {
                startPos = position,
                num = criticalAttack,
                path = showPath,
            },showPath);
        }
        if (carSkillHurt > 0)
        {
            string showPath = "Assets/Main/Prefabs/UI/BattleWord/BattleBuildCarDecBloodTip.prefab";
            world.ShowBattleBlood(new BattleDecBloodTip.Param()
            {
                startPos = position,
                num = carSkillHurt,
                path = showPath,
            },showPath);
        }
    }
    
    private void ShowAllianceCityBuff(long targetUuid,string effectStr)
    {
        var pointInfo = world.GetPointInfoByUuid(targetUuid);
        if (pointInfo == null)
        {
            return;
        }
        var position = world.TileIndexToWorld(pointInfo.mainIndex) + new Vector3(-6f, 0, -6);
        if (!effectStr.IsNullOrEmpty())
        {
            var str = targetUuid + "|" +world.WorldToTileIndex(position)+"|"+ effectStr+"|"+(int)WorldPointType.WORLD_ALLIANCE_CITY;
            GameEntry.Event.Fire(EventId.ShowBattleBuff,str); 
        }
    }
    
        /// <summary>
    /// 王座表现
    /// </summary>
    ///
    private void ThroneUpdateHeadUI(long marchUuid,int hp, int hpMax)
    {
        var str = marchUuid + ";" + hp + ";" + hpMax;
        GameEntry.Event.Fire(EventId.ShowThroneArmyHeadUI, str);
    }
    private void ShowThroneBloodHurt(long hurtTargetUuid, int normalHurt, int skillHurt,int heal,int carSkillHurt,int criticalAttack)
    {
        if (showBattleBlood == false)
        {
            return;
        }
        if (LOD >= 3)
        {
            return;
        }
        var marchData = world.GetMarch(hurtTargetUuid);
        if (marchData == null)
        {
            return;
        }
        var position = world.TileIndexToWorld(marchData.targetPos);
        if (normalHurt > 0)
        {
            string showPath = "Assets/Main/Prefabs/UI/BattleWord/BattleBuildNormalBloodTip.prefab";
            world.ShowBattleBlood(new BattleDecBloodTip.Param()
            {
                startPos = position,
                num = normalHurt,
                path = showPath,
            },showPath);
        }
        if (skillHurt > 0)
        {
            string showPath = "Assets/Main/Prefabs/UI/BattleWord/BattleBuildDecBloodTip.prefab";
            world.ShowBattleBlood(new BattleDecBloodTip.Param()
            {
                startPos = position,
                num = skillHurt,
                path = showPath,
            },showPath);
        }
        if (carSkillHurt > 0)
        {
            string showPath = "Assets/Main/Prefabs/UI/BattleWord/BattleBuildCarDecBloodTip.prefab";
            world.ShowBattleBlood(new BattleDecBloodTip.Param()
            {
                startPos = position,
                num = carSkillHurt,
                path = showPath,
            },showPath);
        }
        if (criticalAttack > 0)
        {
            string showPath = "Assets/Main/Prefabs/UI/BattleWord/BattleBuildCriticalDecBloodTip.prefab";
            world.ShowBattleBlood(new BattleDecBloodTip.Param()
            {
                startPos = position,
                num = criticalAttack,
                path = showPath,
            },showPath);
        }
    }
    
    private void ShowThroneBuff(long targetUuid,string effectStr)
    {
        var marchData = world.GetMarch(targetUuid);
        if (marchData == null)
        {
            return;
        }
        var position = world.TileIndexToWorld(marchData.targetPos);
        if (!effectStr.IsNullOrEmpty())
        {
            var str = targetUuid + "|" +world.WorldToTileIndex(position)+"|"+ effectStr+"|"+(int)WorldPointType.WORLD_ALLIANCE_CITY;
            GameEntry.Event.Fire(EventId.ShowBattleBuff,str); 
        }
    }
    /// <summary>
    /// 建筑表现
    /// </summary>
    ///
    private void BuildingAttack(long atkUuid, long defUuid)
    {
        var city = world.GetBuildingByUuid(atkUuid);
        if (city == null)
        {
            return;
        }

        city.OnBattleAtkUpdate(defUuid);
    }
    private void ShowPlayerBuildBloodHurt(long hurtTargetUuid, int normalHurt, int skillHurt,int heal,int carSkillHurt,int criticalAttack)
    {
        if (showBattleBlood == false)
        {
            return;
        }
        if (LOD >= 3)
        {
            return;
        }
        var pointInfo = world.GetPointInfoByUuid(hurtTargetUuid) as BuildPointInfo;
        if (pointInfo == null)
        {
            return;
        }

        var tile = pointInfo.tileSize;
        if (tile <= 1)
        {
            tile = 0;
        }
        var position = world.TileIndexToWorld(pointInfo.mainIndex) + new Vector3(-(tile/2.0f)-0.5f, 0, -(tile/2.0f));
        if (normalHurt > 0)
        {
            string showPath = "Assets/Main/Prefabs/UI/BattleWord/BattleNormalBloodTip.prefab";
            world.ShowBattleBlood(new BattleDecBloodTip.Param()
            {
                startPos = position,
                num = normalHurt,
                path = showPath,
            },showPath);
        }
        if (skillHurt > 0)
        {
            string showPath = "Assets/Main/Prefabs/UI/BattleWord/BattleDecBloodTip.prefab";
            world.ShowBattleBlood(new BattleDecBloodTip.Param()
            {
                startPos = position,
                num = skillHurt,
                path = showPath,
            },showPath);
        }
        if (carSkillHurt > 0)
        {
            string showPath = "Assets/Main/Prefabs/UI/BattleWord/BattleCarDecBloodTip.prefab";
            world.ShowBattleBlood(new BattleDecBloodTip.Param()
            {
                startPos = position,
                num = carSkillHurt,
                path = showPath,
            },showPath);
        }
        if (criticalAttack > 0)
        {
            string showPath = "Assets/Main/Prefabs/UI/BattleWord/BattleCriticalDecBloodTip.prefab";
            world.ShowBattleBlood(new BattleDecBloodTip.Param()
            {
                startPos = position,
                num = criticalAttack,
                path = showPath,
            },showPath);
        }
    }
    private void ShowPlayerBuildBuff(long targetUuid,string effectStr)
    {
        if (!effectStr.IsNullOrEmpty())
        {
            var pointInfo = world.GetPointInfoByUuid(targetUuid) as BuildPointInfo;
            if (pointInfo == null)
            {
                return;
            }

            var tile = pointInfo.tileSize;
            if (tile <= 1)
            {
                tile = 0;
            }
            var position = world.TileIndexToWorld(pointInfo.mainIndex) + new Vector3(-(tile/2.0f), 0, -(tile/2.0f));
            var str = targetUuid + "|" +world.WorldToTileIndex(position)+"|"+ effectStr+"|"+(int)WorldPointType.PlayerBuilding;
            GameEntry.Event.Fire(EventId.ShowBattleBuff,str); 
        }
    }
    /// <summary>
    /// 联盟建筑表现
    /// </summary>
    ///
    private void ShowAllianceBuildBloodHurt(long hurtTargetUuid, int normalHurt, int skillHurt,int heal,int carSkillHurt,int criticalAttack)
    {
        if (showBattleBlood == false)
        {
            return;
        }
        if (LOD >= 3)
        {
            return;
        }
        var pointInfo = world.GetPointInfoByUuid(hurtTargetUuid);
        if (pointInfo == null)
        {
            return;
        }

        var tile = GameEntry.Lua.CallWithReturn<int,int>("CSharpCallLuaInterface.GetWorldPointTileSize",pointInfo.mainIndex);
        if (tile <= 1)
        {
            tile = 0;
        }
        var position = world.TileIndexToWorld(pointInfo.mainIndex) + new Vector3(-(tile/2.0f), 0, -(tile/2.0f));
        if (normalHurt > 0)
        {
            string showPath = "Assets/Main/Prefabs/UI/BattleWord/BattleNormalBloodTip.prefab";
            world.ShowBattleBlood(new BattleDecBloodTip.Param()
            {
                startPos = position,
                num = normalHurt,
                path = showPath,
            },showPath);
        }
        if (skillHurt > 0)
        {
            string showPath = "Assets/Main/Prefabs/UI/BattleWord/BattleDecBloodTip.prefab";
            world.ShowBattleBlood(new BattleDecBloodTip.Param()
            {
                startPos = position,
                num = skillHurt,
                path = showPath,
            },showPath);
        }
        if (carSkillHurt > 0)
        {
            string showPath = "Assets/Main/Prefabs/UI/BattleWord/BattleCarDecBloodTip.prefab";
            world.ShowBattleBlood(new BattleDecBloodTip.Param()
            {
                startPos = position,
                num = carSkillHurt,
                path = showPath,
            },showPath);
        }
        if (criticalAttack > 0)
        {
            string showPath = "Assets/Main/Prefabs/UI/BattleWord/BattleCriticalDecBloodTip.prefab";
            world.ShowBattleBlood(new BattleDecBloodTip.Param()
            {
                startPos = position,
                num = criticalAttack,
                path = showPath,
            },showPath);
        }
    }
    private void ShowAllianceBuildBuff(long targetUuid,string effectStr)
    {
        if (!effectStr.IsNullOrEmpty())
        {
            var pointInfo = world.GetPointInfoByUuid(targetUuid);
            if (pointInfo == null)
            {
                return;
            }

            var tile = GameEntry.Lua.CallWithReturn<int,int>("CSharpCallLuaInterface.GetWorldPointTileSize",pointInfo.mainIndex);
            if (tile <= 1)
            {
                tile = 0;
            }
            var position = world.TileIndexToWorld(pointInfo.mainIndex) + new Vector3(-(tile/2.0f), 0, -(tile/2.0f));
            var str = targetUuid + "|" +world.WorldToTileIndex(position)+"|"+ effectStr+"|"+(int)WorldPointType.WORLD_ALLIANCE_BUILD;
            GameEntry.Event.Fire(EventId.ShowBattleBuff,str); 
        }
    }
    
        /// <summary>
    /// 巨龙建筑表现
    /// </summary>
    ///
    private void ShowDragonBuildBloodHurt(long hurtTargetUuid, int normalHurt, int skillHurt,int heal,int carSkillHurt,int criticalAttack)
    {
        if (showBattleBlood == false)
        {
            return;
        }
        if (LOD >= 3)
        {
            return;
        }
        var pointInfo = world.GetPointInfoByUuid(hurtTargetUuid);
        if (pointInfo == null)
        {
            return;
        }

        var tile = GameEntry.Lua.CallWithReturn<int,int>("CSharpCallLuaInterface.GetWorldPointTileSize",pointInfo.mainIndex);
        if (tile <= 1)
        {
            tile = 0;
        }
        var position = world.TileIndexToWorld(pointInfo.mainIndex) + new Vector3(-(tile/2.0f), 0, -(tile/2.0f));
        if (normalHurt > 0)
        {
            string showPath = "Assets/Main/Prefabs/UI/BattleWord/BattleNormalBloodTip.prefab";
            world.ShowBattleBlood(new BattleDecBloodTip.Param()
            {
                startPos = position,
                num = normalHurt,
                path = showPath,
            },showPath);
        }
        if (skillHurt > 0)
        {
            string showPath = "Assets/Main/Prefabs/UI/BattleWord/BattleDecBloodTip.prefab";
            world.ShowBattleBlood(new BattleDecBloodTip.Param()
            {
                startPos = position,
                num = skillHurt,
                path = showPath,
            },showPath);
        }
        if (carSkillHurt > 0)
        {
            string showPath = "Assets/Main/Prefabs/UI/BattleWord/BattleCarDecBloodTip.prefab";
            world.ShowBattleBlood(new BattleDecBloodTip.Param()
            {
                startPos = position,
                num = carSkillHurt,
                path = showPath,
            },showPath);
        }
        if (criticalAttack > 0)
        {
            string showPath = "Assets/Main/Prefabs/UI/BattleWord/BattleCriticalDecBloodTip.prefab";
            world.ShowBattleBlood(new BattleDecBloodTip.Param()
            {
                startPos = position,
                num = criticalAttack,
                path = showPath,
            },showPath);
        }
    }
    private void ShowDragonBuildBuff(long targetUuid,string effectStr)
    {
        if (!effectStr.IsNullOrEmpty())
        {
            var pointInfo = world.GetPointInfoByUuid(targetUuid);
            if (pointInfo == null)
            {
                return;
            }

            var tile = GameEntry.Lua.CallWithReturn<int,int>("CSharpCallLuaInterface.GetWorldPointTileSize",pointInfo.mainIndex);
            if (tile <= 1)
            {
                tile = 0;
            }
            var position = world.TileIndexToWorld(pointInfo.mainIndex) + new Vector3(-(tile/2.0f), 0, -(tile/2.0f));
            var str = targetUuid + "|" +world.WorldToTileIndex(position)+"|"+ effectStr+"|"+(int)WorldPointType.WORLD_ALLIANCE_BUILD;
            GameEntry.Event.Fire(EventId.ShowBattleBuff,str); 
        }
    }
    
            /// <summary>
    /// 跨服王座
    /// </summary>
    ///
    private void ShowCrossThroneBloodHurt(long hurtTargetUuid, int normalHurt, int skillHurt,int heal,int carSkillHurt,int criticalAttack)
    {
        if (showBattleBlood == false)
        {
            return;
        }
        if (LOD >= 3)
        {
            return;
        }
        var pointInfo = world.GetPointInfoByUuid(hurtTargetUuid);
        if (pointInfo == null)
        {
            return;
        }

        var tile = GameEntry.Lua.CallWithReturn<int,int>("CSharpCallLuaInterface.GetWorldPointTileSize",pointInfo.mainIndex);
        if (tile <= 1)
        {
            tile = 0;
        }
        var position = world.TileIndexToWorld(pointInfo.mainIndex) + new Vector3(-(tile/2.0f), 0, -(tile/2.0f));
        if (normalHurt > 0)
        {
            string showPath = "Assets/Main/Prefabs/UI/BattleWord/BattleNormalBloodTip.prefab";
            world.ShowBattleBlood(new BattleDecBloodTip.Param()
            {
                startPos = position,
                num = normalHurt,
                path = showPath,
            },showPath);
        }
        if (skillHurt > 0)
        {
            string showPath = "Assets/Main/Prefabs/UI/BattleWord/BattleDecBloodTip.prefab";
            world.ShowBattleBlood(new BattleDecBloodTip.Param()
            {
                startPos = position,
                num = skillHurt,
                path = showPath,
            },showPath);
        }
        if (carSkillHurt > 0)
        {
            string showPath = "Assets/Main/Prefabs/UI/BattleWord/BattleCarDecBloodTip.prefab";
            world.ShowBattleBlood(new BattleDecBloodTip.Param()
            {
                startPos = position,
                num = carSkillHurt,
                path = showPath,
            },showPath);
        }
        if (criticalAttack > 0)
        {
            string showPath = "Assets/Main/Prefabs/UI/BattleWord/BattleCriticalDecBloodTip.prefab";
            world.ShowBattleBlood(new BattleDecBloodTip.Param()
            {
                startPos = position,
                num = criticalAttack,
                path = showPath,
            },showPath);
        }
    }
    private void ShowCrossThroneBuff(long targetUuid,string effectStr)
    {
        if (!effectStr.IsNullOrEmpty())
        {
            var pointInfo = world.GetPointInfoByUuid(targetUuid);
            if (pointInfo == null)
            {
                return;
            }

            var tile = GameEntry.Lua.CallWithReturn<int,int>("CSharpCallLuaInterface.GetWorldPointTileSize",pointInfo.mainIndex);
            if (tile <= 1)
            {
                tile = 0;
            }
            var position = world.TileIndexToWorld(pointInfo.mainIndex) + new Vector3(-(tile/2.0f), 0, -(tile/2.0f));
            var str = targetUuid + "|" +world.WorldToTileIndex(position)+"|"+ effectStr+"|"+(int)WorldPointType.WORLD_ALLIANCE_BUILD;
            GameEntry.Event.Fire(EventId.ShowBattleBuff,str); 
        }
    }
        /// <summary>
    /// NPC建筑表现
    /// </summary>
    ///
    private void ShowNPCBuildBloodHurt(long hurtTargetUuid, int normalHurt, int skillHurt,int heal,int carSkillHurt,int criticalAttack)
    {
        if (showBattleBlood == false)
        {
            return;
        }
        if (LOD >= 3)
        {
            return;
        }
        var pointInfo = world.GetPointInfoByUuid(hurtTargetUuid);
        if (pointInfo == null)
        {
            return;
        }

        var tile = GameEntry.Lua.CallWithReturn<int,int>("CSharpCallLuaInterface.GetWorldPointTileSize",pointInfo.mainIndex);
        if (tile <= 1)
        {
            tile = 0;
        }
        var position = world.TileIndexToWorld(pointInfo.mainIndex) + new Vector3(-(tile/2.0f), 0, -(tile/2.0f));
        if (normalHurt > 0)
        {
            string showPath = "Assets/Main/Prefabs/UI/BattleWord/BattleNormalBloodTip.prefab";
            world.ShowBattleBlood(new BattleDecBloodTip.Param()
            {
                startPos = position,
                num = normalHurt,
                path = showPath,
            },showPath);
        }
        if (skillHurt > 0)
        {
            string showPath = "Assets/Main/Prefabs/UI/BattleWord/BattleDecBloodTip.prefab";
            world.ShowBattleBlood(new BattleDecBloodTip.Param()
            {
                startPos = position,
                num = skillHurt,
                path = showPath,
            },showPath);
        }
        if (carSkillHurt > 0)
        {
            string showPath = "Assets/Main/Prefabs/UI/BattleWord/BattleCarDecBloodTip.prefab";
            world.ShowBattleBlood(new BattleDecBloodTip.Param()
            {
                startPos = position,
                num = carSkillHurt,
                path = showPath,
            },showPath);
        }
        if (criticalAttack > 0)
        {
            string showPath = "Assets/Main/Prefabs/UI/BattleWord/BattleCriticalDecBloodTip.prefab";
            world.ShowBattleBlood(new BattleDecBloodTip.Param()
            {
                startPos = position,
                num = criticalAttack,
                path = showPath,
            },showPath);
        }
    }
    private void ShowNPCBuildBuff(long targetUuid,string effectStr)
    {
        if (!effectStr.IsNullOrEmpty())
        {
            var pointInfo = world.GetPointInfoByUuid(targetUuid);
            if (pointInfo == null)
            {
                return;
            }

            var tile = GameEntry.Lua.CallWithReturn<int,int>("CSharpCallLuaInterface.GetWorldPointTileSize",pointInfo.mainIndex);
            if (tile <= 1)
            {
                tile = 0;
            }
            var position = world.TileIndexToWorld(pointInfo.mainIndex) + new Vector3(-(tile/2.0f), 0, -(tile/2.0f));
            var str = targetUuid + "|" +world.WorldToTileIndex(position)+"|"+ effectStr+"|"+(int)WorldPointType.WORLD_ALLIANCE_BUILD;
            GameEntry.Event.Fire(EventId.ShowBattleBuff,str); 
        }
    }
    /// <summary>
    /// 地块表现
    /// </summary>
    ///
    private void ShowDesertBloodHurt(int pointId, int normalHurt, int skillHurt,int heal,int carSkillHurt,int criticalAttack)
    {
        if (showBattleBlood == false)
        {
            return;
        }
        if (LOD >= 3)
        {
            return;
        }
        var tile = 1;
        var position = world.TileIndexToWorld(pointId);
        if (normalHurt > 0)
        {
            string showPath = "Assets/Main/Prefabs/UI/BattleWord/BattleNormalBloodTip.prefab";
            world.ShowBattleBlood(new BattleDecBloodTip.Param()
            {
                startPos = position,
                num = normalHurt,
                path = showPath,
            },showPath);
        }
        if (skillHurt > 0)
        {
            string showPath = "Assets/Main/Prefabs/UI/BattleWord/BattleDecBloodTip.prefab";
            world.ShowBattleBlood(new BattleDecBloodTip.Param()
            {
                startPos = position,
                num = skillHurt,
                path = showPath,
            },showPath);
        }
        if (carSkillHurt > 0)
        {
            string showPath = "Assets/Main/Prefabs/UI/BattleWord/BattleCarDecBloodTip.prefab";
            world.ShowBattleBlood(new BattleDecBloodTip.Param()
            {
                startPos = position,
                num = carSkillHurt,
                path = showPath,
            },showPath);
        }
        if (criticalAttack > 0)
        {
            string showPath = "Assets/Main/Prefabs/UI/BattleWord/BattleCriticalDecBloodTip.prefab";
            world.ShowBattleBlood(new BattleDecBloodTip.Param()
            {
                startPos = position,
                num = criticalAttack,
                path = showPath,
            },showPath);
        }
    }
    public void BattleFinish(ISFSObject message)
    {
        var uuid = message.GetLong("leaderUuid");
        var pointId = message.GetInt("pointId");
        var result = (BatleResult)message.GetInt("result");
        world.HideTroopDestination(uuid);
        GameEntry.Event.Fire(EventId.HideDesertAttackHeadUI,pointId);
        GameEntry.Event.Fire(EventId.CollectPointOut,uuid);
        GameEntry.Event.Fire(EventId.HideAllianceCitySoliderBlood, uuid);
        GameEntry.Event.Fire(EventId.HideBuildAttackHeadUI,uuid);
        GameEntry.Event.Fire(EventId.HideAllianceBuildAttackHeadUI,uuid);
        GameEntry.Event.Fire(EventId.HideBattleBuff,uuid);
        GameEntry.Event.Fire(EventId.HideNPCBuildAttackHeadUI,uuid);
        GameEntry.Event.Fire(EventId.HideThroneArmyHeadUI,uuid);
        GameEntry.Event.Fire(EventId.HideSiegeAttack, uuid);
        GameEntry.Event.Fire(EventId.HideActAllianceBuildAttackHeadUI,uuid);
        GameEntry.Event.Fire(EventId.HideDragonBuildAttackHeadUI,uuid);
        GameEntry.Event.Fire(EventId.HideCrossThroneAttackHeadUI,uuid);
        world.RemovePosAndRotationDataByMarchUuid(uuid);
        var troop = world.GetTroop(uuid);
        if (troop != null)
        {
            troop.defAtkUuid = 0;
            troop.SetIsBattle(false);
            var marchInfo = troop.GetMarchInfo();
            if (result == BatleResult.SELF_WIN)
            {
                if (world.IsSelfInCurrentMarchTeam(uuid))
                {
                    GameEntry.Sound.PlayEffect(GameDefines.SoundAssets.Music_Effect_Message);
                    troop.ShowBattleSuccess();
                    GameEntry.Event.Fire(EventId.MarchEndWithReward, uuid);
                }
            }
            else if (result == BatleResult.OTHER_WIN)
            {
                if (world.IsSelfInCurrentMarchTeam(uuid))
                {
                    GameEntry.Sound.PlayEffect(GameDefines.SoundAssets.Music_Effect_Message);
                    GameEntry.Event.Fire(EventId.MarchFail, uuid);
                    troop.ShowBattleFailed();
                }
                
            }
            troop.BackTroopUnits();
            troop.ClearEffect();
            troop.PlayAnim(WorldTroop.Anim_Idle);
            // battlePlayerList.Remove(uuid);
            // RemoveBattlefield(troop,true);
        }
        
        

    }
    
    /// <summary>
    /// 采集点表现
    /// </summary>
    ///
    private void ShowCollectPointBloodHurt(int pointIndex, int normalHurt, int skillHurt,int heal,int carSkillHurt,int criticalAttack)
    {
        if (showBattleBlood == false)
        {
            return;
        }
        if (LOD >= 3)
        {
            return;
        }
        var pointInfo = world.GetPointInfo(pointIndex) as ResPointInfo;;
        if (pointInfo == null)
        {
            return;
        }

        var tile = pointInfo.tileSize;
        if (tile <= 1)
        {
            tile = 0;
        }
        var position = world.TileIndexToWorld(pointInfo.mainIndex) + new Vector3(-(tile/2.0f), 0, -(tile/2.0f));
        if (normalHurt > 0)
        {
            string showPath = "Assets/Main/Prefabs/UI/BattleWord/BattleNormalBloodTip.prefab";
            world.ShowBattleBlood(new BattleDecBloodTip.Param()
            {
                startPos = position,
                num = normalHurt,
                path = showPath,
            },showPath);
        }
        if (skillHurt > 0)
        {
            string showPath = "Assets/Main/Prefabs/UI/BattleWord/BattleDecBloodTip.prefab";
            world.ShowBattleBlood(new BattleDecBloodTip.Param()
            {
                startPos = position,
                num = skillHurt,
                path = showPath,
            },showPath);
        }
        if (carSkillHurt > 0)
        {
            string showPath = "Assets/Main/Prefabs/UI/BattleWord/BattleCarDecBloodTip.prefab";
            world.ShowBattleBlood(new BattleDecBloodTip.Param()
            {
                startPos = position,
                num = carSkillHurt,
                path = showPath,
            },showPath);
        }
        if (criticalAttack > 0)
        {
            string showPath = "Assets/Main/Prefabs/UI/BattleWord/BattleCriticalDecBloodTip.prefab";
            world.ShowBattleBlood(new BattleDecBloodTip.Param()
            {
                startPos = position,
                num = criticalAttack,
                path = showPath,
            },showPath);
        }
    }
    private void ShowCollectPointBuff(long targetUuid,int pointIndex,string effectStr)
    {
        if (!effectStr.IsNullOrEmpty())
        {
            var pointInfo = world.GetPointInfo(pointIndex) as ResPointInfo;;
            if (pointInfo == null)
            {
                return;
            }

            var tile = pointInfo.tileSize;
            if (tile <= 1)
            {
                tile = 0;
            }
            var position = world.TileIndexToWorld(pointInfo.mainIndex) + new Vector3(-(tile/2.0f), 0, -(tile/2.0f));
            var str = targetUuid + "|" +world.WorldToTileIndex(position)+"|"+ effectStr+"|" + (int)WorldPointType.WorldResource;
            GameEntry.Event.Fire(EventId.ShowBattleBuff,str); 
        }
    }
    
    private void ShowCollectUpdateHeadUI(long marchUuid,int pointIndex, int anger, int hp, int hpMax,int carAnger)
    {
        var str = marchUuid.ToString() +";"+pointIndex.ToString()+";"+ anger.ToString() +";"+ hp.ToString() +";"+ hpMax.ToString()+";"+carAnger;
        GameEntry.Event.Fire(EventId.ShowCollectBattleValue,str);
    }
    
    
    
    #region 英雄使用技能UI表现
    private List<long>removeList = new List<long>();
    #endregion
    
    /// <summary>
    /// 当前回合战报
    /// </summary>
    /// <param name="roundReport"></param>
    private void CheckArmyDoSkill(long armyUuid,BaseRoundReportPush reportInfo,ref int showAttackSkillId,ref int showHurtSkillId, ref int skillHurt,ref int normalHurt,ref int carSkillHurt,ref bool isActiveAttack ,ref List<int> effectBuffList,ref int damageEffectType,ref int criticalAttack)
    {
        //技能的使用者
        long triggerUUID = reportInfo.TriggerUuid;
        long targetUUID = reportInfo.TargetUuid;
        var roundReport = reportInfo.RoundReport;
        //  UnityEngine.Debug.LogError("report=========="+roundReport.Type + ":" + roundReport.Value + ":" + targetUUID + ":" + roundReport.SkillId);
        DamageType damgeType =(DamageType)roundReport.Type;
        switch(damgeType)
        {
            
            //使用技能
            case DamageType.USE_SKILL:
               // UnityEngine.Debug.LogError("report=========="+ reportInfo.TriggerUuid+":" + roundReport.Type + ":" + roundReport.Value + ":" + roundReport.Type + ":" + roundReport.SkillId);
                //播放使用技能
                if (triggerUUID==armyUuid)
                {
                    if (showAttackSkillId <= 0)
                    {
                        var useSkillID = roundReport.SkillId;
                        var effectPath =  GameEntry.ConfigCache.GetTemplateData(GameDefines.TableName.SkillTab, useSkillID,"effect_path");
                        var tempPoint = GameEntry.ConfigCache.GetTemplateData(GameDefines.TableName.SkillTab, useSkillID, "effect_point_type");
                        var skillType = GameEntry.ConfigCache.GetTemplateData(GameDefines.TableName.SkillTab, useSkillID, "type").ToInt();
                        var effectPoint = 0;
                        if (!tempPoint.IsNullOrEmpty())
                        {
                            effectPoint = tempPoint.ToInt();
                        }
                        if ((skillType == (int)HeroSkillType.RAGE_SKILL ||
                             skillType == (int)HeroSkillType.START_BATTLE_SKILL) && !effectPath.IsNullOrEmpty() && damgeType == (DamageType)effectPoint && sheldPath != effectPath)
                        {
                            showAttackSkillId = useSkillID;
                        }
                    }

                    
                    if (roundReport.SkillId == normalAttackId)
                    {
                        isActiveAttack = true;
                    }
                }
                break;
            //被攻击
            case DamageType.ATTACK:
                //播放被击技能
                if (targetUUID == armyUuid)
                {
                    if (roundReport.SkillId == normalAttackId)
                    {
                        if (roundReport.DamageEffectType == (int)APSDamageEffectType.CRIT)
                        {
                            criticalAttack += roundReport.Value;
                        }
                        else
                        {
                            normalHurt += roundReport.Value;
                        }
                        damageEffectType = roundReport.DamageEffectType;
                        //troop.ShowBattleHurt(roundReport.Value, BattleWordType.Normal);
                    }
                    else
                    {
                        var heroId = reportInfo.RoundReport.HeroId;
                        if (heroId > 0)
                        {
                            skillHurt += roundReport.Value;
                        }
                        else if(heroId ==-2)
                        {
                            carSkillHurt += roundReport.Value;
                        }
                        
                        //播放被击技能
                        if (showHurtSkillId <= 0)
                        {
                            var useSkillID = roundReport.SkillId;
                            var effectPath =  GameEntry.ConfigCache.GetTemplateData(GameDefines.TableName.SkillTab, useSkillID,"effect_path");
                            var tempPoint = GameEntry.ConfigCache.GetTemplateData(GameDefines.TableName.SkillTab, useSkillID, "effect_point_type");
                            var skillType = GameEntry.ConfigCache.GetTemplateData(GameDefines.TableName.SkillTab, useSkillID, "type").ToInt();
                            var effectPoint = 0;
                            if (!tempPoint.IsNullOrEmpty())
                            {
                                effectPoint = tempPoint.ToInt();
                            }
                            if ((skillType == (int)HeroSkillType.RAGE_SKILL ||
                                 skillType == (int)HeroSkillType.START_BATTLE_SKILL) && !effectPath.IsNullOrEmpty() && damgeType == (DamageType)effectPoint && sheldPath != effectPath)
                            {
                                showHurtSkillId = useSkillID;
                            }
                        }
                    }
                
                }
                if (triggerUUID == armyUuid)
                {
                    if (roundReport.SkillId == normalAttackId)
                    {
                        isActiveAttack = true;
                    }
                }
                break;
            case DamageType.COUNTER_ATTACK:
                {
                    if (targetUUID == armyUuid)
                    {
                        if (roundReport.DamageEffectType == (int)APSDamageEffectType.CRIT)
                        {
                            criticalAttack += roundReport.Value;
                        }
                        else
                        {
                            normalHurt += roundReport.Value;
                        }
                        damageEffectType = roundReport.DamageEffectType;
                        //troop.ShowBattleHurt(roundReport.Value, BattleWordType.Normal);
                    }
                }
                break;
            case DamageType.ADD_EFFECT:
            {
                if (targetUUID == armyUuid)
                {
                    effectBuffList.Add(roundReport.Value);
                    //troop.ShowBattleHurt(roundReport.Value, BattleWordType.Normal);
                }
            }
                break;
            default:
                break;

        }
    }
    
    
     public void UpdateBattle(float deltaTime)
     {
     }
}
#endif