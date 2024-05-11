---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mac.
--- DateTime: 8/11/21 3:25 PM
---
local BuffMgr = require "Scene.BattlePveModule.MailDetailParseModule.PveMailDetailBuffMgr"
local ActionItem = require "Scene.BattlePveModule.MailDetailParseModule.PveMailDetailActionItem"
---------------------------------------------------------------- ReportDetail ---------------------------------------------------------
--[[ 
// 详细战报
message BattleDetailInfo {
	repeated BaseRoundReport roundReports = 1;
	repeated EffectRoundReport effectReports = 2;
	repeated DetailReportPlayerInfo playerInfos = 3;// 详细战报玩家信息
}

    功能:
        在拿到服务器的数据后需要做文字战报解析的服务
        
    大体流程:
        在服务器返回的数据中,计算出startRoundIndex, endRoundIndex,然后遍历 roundReports / effectReports
        如果roundReport存在[有可能会有多个] 这个表示释放技能,普攻这种动作描述
        如果effectReports存在,则需要进入自己维护的列表中,在接下来的round中要获取当前轮次身上的buff状态
    
    local AllReports = { [roundIdx] = {[Action] = { xxxx-list }, [Buff] = { xxx-list }} }
    之后可以直接获取指定一轮的数据,进行显示
]]
local MailDetailReportParseHelper = BaseClass("MailDetailReportParseHelper")
local Const = require "Scene.BattlePveModule.Const"

function MailDetailReportParseHelper:InitData()
    self._minIndex = 0
    self._maxIndex = 0
    self._allDetails = {}
    self._healthList = {}
end

function MailDetailReportParseHelper:AddEffectData( effectlist, roundIdx )
    if (self._allDetails[roundIdx] == nil) then
        self._allDetails[roundIdx] = {}
    end
    self._allDetails[roundIdx][Const.Define.BUFF] = effectlist
end

function MailDetailReportParseHelper:AddActionData( skill, normal, roundIdx )
    if (self._allDetails[roundIdx] == nil) then
        self._allDetails[roundIdx] = {}
    end
    self._allDetails[roundIdx][Const.Define.SKILL] = skill
    self._allDetails[roundIdx][Const.Define.NORMAL] = normal
    -- 这块对普通攻击进行统计,注意,这个地方普攻都是掉血,这个是后端明确告诉的！！！
    local normalAtk = {}
    for _, v in pairs(normal) do
        local t_index = tostring(v:GetTargetIndex())
        if (normalAtk[t_index] == nil) then
            local item = v:GetValue()
            if item["value"]~=nil then
                normalAtk[t_index] = item["value"]
            end
        else
            local item = v:GetValue()
            if item["value"]~=nil then
                normalAtk[t_index] = normalAtk[t_index] +item["value"]
            end
        end
    end
    
    self._allDetails[roundIdx][Const.Define.NORMAL_ATK] = normalAtk
end

-- 计算回合中最大/小回合数
function MailDetailReportParseHelper:SetIndexRange( detailData )
    -- 获取最大
    local roundReports = self._roundReports
    local effectReports = self._effectReports
    if (not table.IsNullOrEmpty(roundReports)) then
        self._minIndex = roundReports[1]["round"]
        self._maxIndex = roundReports[#roundReports]["round"]
    end
    if (not table.IsNullOrEmpty(effectReports)) then
        local e_minIndex = effectReports[1]["baseReport"]["round"]
        local e_maxIndex = effectReports[#effectReports]["baseReport"]["round"]
        self._minIndex = self._minIndex > e_minIndex and e_minIndex or self._minIndex
        self._maxIndex = self._maxIndex > e_maxIndex and self._maxIndex or e_maxIndex
    end
end

--[[
 返回Round
 在这个里面需要处理 如果在遍历中遇到了type=7的类型的表示使用技能,需要将 attid+defid+skillid相同的type=1的都给他.这才表示完整的一个技能打击
 好无奈啊！！！
]]
function MailDetailReportParseHelper:GetActionList( findIndex )
    local _skillroundList = {}
    local _normalAtkList = {}
    
    local function InsertActionItem( actionItem )
        local tbCnt = table.count(_skillroundList)
        if (tbCnt == 0) then
            return false
        end
        for i = tbCnt, 1, -1 do
            local _action = _skillroundList[i]
            if (_action:IsBelongThisSkill(actionItem)) then
                _action:AddSkillTarget(actionItem)
                return true
            end
        end
        return false
    end
    
    -- 筛选进入辅助列表
    for key, reportItem in pairs(self._roundReports) do
        if (reportItem ~= nil and reportItem["round"] == findIndex) then
            local actionItem = ActionItem.New()
            actionItem:InitData(reportItem, self._playerInfos)
            -- 检测是否是type=1的技能攻击,如果是的话,需要向前找到该技能的发起方
            if (actionItem:IsSubActionItem() and InsertActionItem(actionItem)) then
            elseif actionItem:GetActionItemType() == eMailDetailActionType.USE_SKILL then
                _skillroundList[#_skillroundList+1] = actionItem
            else
                _normalAtkList[#_normalAtkList+1] = actionItem
            end
            self._roundReports[key] = nil
        elseif (reportItem ~= nil and reportItem["round"] > findIndex) then
            break
        end
    end
    return _skillroundList, _normalAtkList
end

-- 返回Effect
function MailDetailReportParseHelper:GetEffectList( findIndex )
    local effectList = {}
    -- 筛选进入辅助列表
    for key, effectItem in pairs(self._effectReports) do
        if (effectItem ~= nil and effectItem["baseReport"] ~= nil and effectItem["baseReport"]["round"] == findIndex) then
            effectList[#effectList+1] = effectItem
            self._effectReports[key] = nil
        elseif (effectItem ~= nil and effectItem["baseReport"] ~= nil and effectItem["baseReport"]["round"] > findIndex) then
            break
        end
    end
    return effectList
end

--[[ 构建玩家信息 这个地方使用玩家的index作为key,方便后续查找 ]]
function MailDetailReportParseHelper:InitPlayerInfo( playerInfos )
    playerInfos = playerInfos or {}
    if (self._playerInfos == nil) then
        self._playerInfos = {}
    end
    for _, userinfo in pairs(playerInfos) do
        self._playerInfos[userinfo["index"]] = userinfo
    end
end

function MailDetailReportParseHelper:GetPlayerInfo()
    return self._playerInfos
end

function MailDetailReportParseHelper:GetCampTypeByTriggerIndex( value, needExchange)
    local userinfo = self._playerInfos[value] or {}
    if (userinfo["isSelf"] == true) then
        return needExchange and Const.CampType.Target or Const.CampType.Player
    else
        return needExchange and Const.CampType.Player or Const.CampType.Target
    end
end

function MailDetailReportParseHelper:ClearData()
    self:InitData()
    BuffMgr:ClearData()
end

--effectReports只存储针对己方生效的buff。 我方对敌方以及敌方对我方的buff数据只在roundReport里面存在，所以在这里客户端重组一下数据
function MailDetailReportParseHelper:AnalyseRoundAndEffect()
    local realEffectList = {}
    for key, effectItem in pairs(self._effectReports) do
        realEffectList[#realEffectList+1] = effectItem
        self._effectReports[key] = nil
    end
    for key, reportItem in pairs(self._roundReports) do
        if reportItem~=nil and reportItem["type"] == eMailDetailActionType.ADD_EFFECT then
            local oneData = {}
            local time = reportItem["param"]
            oneData.baseReport = reportItem
            oneData.time = time
            realEffectList[#realEffectList+1] = oneData
            self._roundReports[key] = nil
        end
    end
    table.sort(realEffectList,function(a,b)
        if a["baseReport"]["round"] < b["baseReport"]["round"] then
            return true
        end
        return false
    end)
    self._effectReports = realEffectList
end
function MailDetailReportParseHelper:ParseData( detailData, selfHealth, otherHealth )
    BuffMgr:ClearData()
    self:InitData()
    self._roundReports = detailData["roundReports"] or {}
    self._effectReports = detailData["effectReports"] or {}
    self:InitPlayerInfo(detailData["playerInfos"])
    --重新组合
    self:AnalyseRoundAndEffect()
    -- 计算区间   
    self:SetIndexRange(detailData)
    
    for index = self._minIndex, self._maxIndex do
        -- Buff效果处理 需要加入本地EffectMgr中,在后续round中通过isBuffActive来处理,查看是否生效
        local effectList = self:GetEffectList(index)
        for k, effectitem in pairs(effectList) do
            BuffMgr:AddBuffItem(effectitem, self._playerInfos)
        end
        
        local skill, normal = self:GetActionList(index)
        --[[
        {"type":7,"heroId":1003,"skillId":100106,},
        {"type":1,"heroId":1003,"skillId":100106,},
        {"type":7,"heroId":1003,"skillId":200005,},
        这个是一个技能的服务器数据,我们可以看到对于1003英雄来讲,100106是主技能, 200005 是对应的子技能,但是服务器全都发过来了(按照正常技能)
        但是因为子技能在我们代码中因为没有targetlist,所以不会播放动画,直接跳过了.但是他是用来产生buff,所以我们需要在下面buff的时候,将buff
        的处理放入其主技能中
        ]]
        --[[
        在对上面的effectlist做一次处理,因为要做给buff的起手动作,在目前actionlist中不存在这个东西
        所以我们的处理是如果只是use_skill但是不同直接命中的那种的则直接continue,不做任何效果处理
        后端在buff处理上也是在回合最后才进行处理的,所以我们直接把当前回合施加的buff按照技能添加到技能后面
        这样就可以有技能表现了。但是需要注意的是在buff回合生效的时候需要做一个处理,第一次就不能再继续生效了
        ]]
        for _, effectItem in pairs(effectList) do
            -- 先找到之前 use_skill 类型的action做一次拷贝,然后将buff塞入到 skilltarget
            local skillUser = nil
            for _, skill_item in pairs(skill) do
                -- 下面这两个判定skillid的取了个巧,必然是先有主技能才有子技能,所以如果遇到主技能的情况,直接break了
                if ( (skill_item:IsSubSkill(effectItem.baseReport.skillId) or skill_item:GetSkillId() == effectItem.baseReport.skillId) and
                        skill_item:GetTriggerIndex() == effectItem.baseReport.triggerIndex and
                        skill_item:GetHeroId() == effectItem.baseReport.heroId ) then
                    --skillUser = DeepCopy(skill_item)
                    skillUser = skill_item
                    break
                end
            end
            if (skillUser ~= nil) then
                local actionItem = ActionItem.New()
                actionItem:InitData(effectItem["baseReport"], self._playerInfos)
                skillUser:AddSkillTarget(actionItem)
                --skill[#skill+1] = skillUser
            else
                local actionItem = ActionItem.New()
                actionItem:InitData(effectItem["baseReport"], self._playerInfos)
                skill[#skill+1] = actionItem
            end
        end
        self:AddActionData(skill, normal, index)
    end
end

function MailDetailReportParseHelper:GetBuffListByRoundIndex(index)
    return BuffMgr:GetBuffListByRoundIndex(index)
end


function MailDetailReportParseHelper:GetMinIndex()
    return self._minIndex or 0
end

function MailDetailReportParseHelper:GetMaxIndex()
    return self._maxIndex or 0
end

function MailDetailReportParseHelper:GetAtkInfoByIndex( index )
    return self._allDetails[index] or {}
end

return MailDetailReportParseHelper