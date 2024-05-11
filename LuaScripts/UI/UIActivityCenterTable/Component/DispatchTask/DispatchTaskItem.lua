---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by jinpeng.
--- DateTime: 2023/6/14 20:49
---
---@class DispatchTaskItem:UIBaseContainer
local DispatchTaskItem = BaseClass("DispatchTaskItem", UIBaseContainer)
local base = UIBaseContainer
local RewardItem = require "UI.UIWorldPoint.Component.WorldPointRewardItem"

local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization

local go_bg_path = "GoBg"
local got_bg_path = "GotBg"
local icon_bg_path = "IconBg"
local icon_path = "IconBg/Icon"
local task_level_path = "IconBg/taskLevel"
local star_path = "star"
local desc_path = "Desc"
local reward_content_path = "ScrollView/Viewport/Content"
local go_btn_path = "Btns/GoBtn"
local go_btn_text_path = "Btns/GoBtn/GoBtnText"
local receive_btn_path = "Btns/ReceiveBtn"
local receive_btn_txt_path = "Btns/ReceiveBtn/ReceiveBtnText"
local cd_text_path = "Btns/time/cdText"
local duigou_img_path = "duigouImg"
local perpect_text_path = "perpectText"
local time_path = "Btns/time"
local player_head_obj_path = "UIPlayerHead"
local ui_player_head_path = "UIPlayerHead/HeadIcon"
local star_list_path = "Btns/Title/starList"
local star1_path = "Btns/Title/starList/star1"
local star2_path = "Btns/Title/starList/star2"
local star3_path = "Btns/Title/starList/star3"
local star4_path = "Btns/Title/starList/star4"
local star5_path = "Btns/Title/starList/star5"
local color_bg_path = "Btns/Title/starList/ColorBg"
local title_path = "Btns/Title"

function DispatchTaskItem:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

function DispatchTaskItem:OnDestroy()
    self:DeleteTimer()
    self:ClearContent()
    self:DataDestroy()
    self:ComponentDestroy()
    base.OnDestroy(self)
end

function DispatchTaskItem:ComponentDefine()
    self.go_bg = self:AddComponent(UIButton, go_bg_path)
    self.go_bg:SetOnClick(function()
        self:OnBgClick()
    end)
    self.got_bg = self:AddComponent(UIImage, got_bg_path)
    self.icon_bg = self:AddComponent(UIImage, icon_bg_path) -- 道具品质
    self.icon = self:AddComponent(UIImage, icon_path)
    self.star = self:AddComponent(UIImage, star_path)
    self.descText = self:AddComponent(UITextMeshProUGUIEx, desc_path)
    self.task_level = self:AddComponent(UITextMeshProUGUIEx, task_level_path)
    self.scroll = self:AddComponent(UIScrollRect,"ScrollView")
    self.reward_content = self:AddComponent(UIBaseContainer, reward_content_path)
    self.goTextMat = self.transform:Find("Btns/GoBtn/goTextMat"):GetComponent(typeof(CS.UnityEngine.MeshRenderer))
    self.go_btn = self:AddComponent(UIButton, go_btn_path)
    self.go_btn:SetOnClick(function()
        self:OnGoClick()
    end)
    self.go_btn_text = self:AddComponent(UITextMeshProUGUIEx, go_btn_text_path)
    self.receive_btn = self:AddComponent(UIButton, receive_btn_path)
    self.receive_btn:SetOnClick(function()
        self:OnReceiveClick()
    end)
    self.receive_btn_txt = self:AddComponent(UITextMeshProUGUIEx,receive_btn_txt_path)
    self.receive_btn_txt:SetLocalText(371058)
    self.cd_text_root = self:AddComponent(UIBaseContainer, time_path)
    self.cd_text = self:AddComponent(UITextMeshProUGUIEx, cd_text_path)
    self.duigou_img = self:AddComponent(UIImage, duigou_img_path)
    self.perpect_text = self:AddComponent(UITextMeshProUGUIEx, perpect_text_path)

    self.player_head = self:AddComponent(UIPlayerHead, ui_player_head_path)
    self.player_obj =self:AddComponent(UIBaseContainer,player_head_obj_path)
    self.playerHeadFg = self:AddComponent(UIImage, "UIPlayerHead/Foreground")
    self.star_list = self:AddComponent(UIBaseContainer, star_list_path)
    self.star1 = self:AddComponent(UIImage, star1_path)
    self.star2 = self:AddComponent(UIImage, star2_path)
    self.star3 = self:AddComponent(UIImage, star3_path)
    self.star4 = self:AddComponent(UIImage, star4_path)
    self.star5 = self:AddComponent(UIImage, star5_path)
    --self.player_head:SetEnableClickShowInfo(true, true)
    self.starRoot = self:AddComponent(UIBaseContainer, title_path)
    self.color_bg = self:AddComponent(UIImage, color_bg_path)
end

function DispatchTaskItem:ComponentDestroy()
    self.go_bg = nil
    self.got_bg = nil
    self.icon_bg = nil
    self.icon = nil
    self.star = nil
    self.descText = nil
    self.reward_content = nil
    self.go_btn = nil
    self.receive_btn = nil
    self.cd_text = nil
    self.duigou_img = nil
    self.perpect_text = nil
    self.go_btn_text = nil
end

function DispatchTaskItem:DataDefine()
    self.infos = {}
    self.itemReqs = {}
    self.itemList = {}
end

function DispatchTaskItem:DataDestroy()
    self.infos = nil
    self.itemReqs = nil
    self.itemList = nil
end

function DispatchTaskItem:OnEnable()
    base.OnEnable(self)
end

function DispatchTaskItem:OnDisable()
    base.OnDisable(self)
end

function DispatchTaskItem:OnAddListener()
    base.OnAddListener(self)
end

function DispatchTaskItem:OnRemoveListener()
    base.OnRemoveListener(self)
end

-- 刷新状态: go/receive
function DispatchTaskItem:RefreshState(is_finish)
    --self.receiveBg:SetActive(is_finish)
    self.goBtn:SetActive(not is_finish)
    self.receiveBtn:SetActive(is_finish)
end

function DispatchTaskItem:ClearContent()
    self.reward_content:RemoveComponents(RewardItem)
    if self.itemReqs~=nil then
        for k,v in pairs(self.itemReqs) do
            if v ~= nil then
                self:GameObjectDestroy(v)
            end
        end
    end
    self.itemReqs ={}
end

-- 刷新奖励
function DispatchTaskItem:RefreshReward(rewardList)
    self:ClearContent()
    if rewardList~=nil then
        local num =0
        if #rewardList>4 then
            self.scroll:SetEnable(true)
        else
            self.scroll:SetEnable(false)
        end 
        for i = 1, table.length(rewardList) do
            --复制基础prefab，每次循环创建一次
            num = num+1
            self.itemReqs[i] = self:GameObjectInstantiateAsync(UIAssets.WorldPointRewardItem, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject;
                go.gameObject:SetActive(true)
                go.transform:SetParent(self.reward_content.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                local nameStr = tostring(NameCount)
                go.name = nameStr
                NameCount = NameCount + 1
                local cell = self.reward_content:AddComponent(RewardItem,nameStr)
                cell:RefreshData(rewardList[i],true)
            end)
        end
    end
end

function DispatchTaskItem:SetData(params, tab)
    self.infos = params
    self.tab = tab
    self.go_btn_text:SetLocalText(tab==1 and 110003 or 100389)
    self.go_btn_text:SetMaterial(tab==1 and self.goTextMat.sharedMaterials[1] or self.goTextMat.sharedMaterials[2])
    self.go_btn:LoadSprite(tab==1 and string.format(LoadPath.CommonNewPath, "Common_btn_blue_samll") or string.format(LoadPath.CommonNewPath, "Common_btn_green71"))
    self:RefreshShow()
    self.hasReceive = false
    if tab == 1 or params.cfg == nil then
        --self.descText:SetColorRGBA(0x2a/255, 0x28/255, 0x30/255, 1) -- 2A2830
        self.player_obj:SetActive(false)
        self.starRoot:SetActive(false)
        self.icon_bg:SetActive(true)
    else
        --local taskColor = params.cfg.color      -- 任务品质：1-5，白绿蓝紫橙
        local starLevel = params.cfg.task_star  -- 任务对应的星级：1-5
        self.star1:SetActive(starLevel >= 1)
        self.star2:SetActive(starLevel >= 2)
        self.star3:SetActive(starLevel >= 3)
        self.star4:SetActive(starLevel >= 4)
        self.star5:SetActive(starLevel >= 5)
        self.player_obj:SetActive(true)
        self.starRoot:SetActive(true)
        self.icon_bg:SetActive(false)
        self.player_head:SetData(params.uid, params.pic, params.picVer)
        local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(params.headSkinId, params.headSkinET)
        if headBgImg ~= nil  then
            self.playerHeadFg:SetActive(true)
            self.playerHeadFg:LoadSprite(headBgImg)
        else
            self.playerHeadFg:SetActive(false)
        end
        --self.descText:SetText(Localization:GetString(self.infos.cfg.name))
        --
        --if taskColor == 1 then
        --    -- 白
        --    self.descText:SetColorRGBA(132/255, 128/255, 133/255, 1)
        --elseif taskColor == 2 then
        --    -- 绿
        --    self.descText:SetColorRGBA(15/255, 164/255, 100/255, 1)
        --elseif taskColor == 3 then
        --    -- 蓝
        --    self.descText:SetColorRGBA(18/255, 135/255, 186/255, 1)
        --elseif taskColor == 4 then
        --    -- 紫
        --    self.descText:SetColorRGBA(156/255, 71/255, 223/255, 1)
        --elseif taskColor == 5 then
        --    -- 橙
        --    self.descText:SetColorRGBA(238/255, 136/255, 53/255, 1)
        --elseif taskColor == 6 then
        --    -- 金
        --    self.descText:SetColorRGBA(233/255, 72/255, 69/255, 1)
        --else
        --    self.descText:SetColorRGBA(0x2a/255, 0x28/255, 0x30/255, 1) -- 2A2830
        --end
    end
end

function DispatchTaskItem:RefreshShow()
    if self.infos and self.infos.cfg then
        if not string.IsNullOrEmpty(self.infos.cfg.icon) then
            self.icon:LoadSprite("Assets/Main/Sprites/UI/UIActivityDispatchTask/"..self.infos.cfg.icon)
        end
        self.color_bg:LoadSprite(DataCenter.ItemTemplateManager:GetToolBgByColor(self.infos.cfg.color))
        self.icon_bg:LoadSprite(DataCenter.ItemTemplateManager:GetToolBgByColor(self.infos.cfg.color))
        self.star:SetActive(self.infos.cfg.is_special == 1)
        -- 2010379=Lv.{0}
        self.task_level:SetLocalText(300665, self.infos.cfg.level or 1)
        if self.tab == 1 then
            self.descText:SetLocalText(self.infos.cfg.name)
            local rewList = self:GetRewardList(self.infos.cfg.base_reward_show)
            self:RefreshReward(rewList)
        else    -- 援助奖励
            self.descText:SetText(self.infos.name)
            local rewList = self:GetRewardList(self.infos.cfg.aid_extra_reward_show)
            self:RefreshReward(rewList)
        end

        self.go_btn:SetActive(true)
        self.receive_btn:SetActive(false)
        self.go_bg:SetActive(true)
        self.got_bg:SetActive(false)
        self.duigou_img:SetActive(false)
        self.perpect_text:SetActive(false)
        self.cd_text_root:SetActive(false)
        
        -- 各种状态...
        local completionTime = self.infos.completionTime
        local now = UITimeManager:GetInstance():GetServerTime()
        if self.tab == 1 then
            --个人任务 go+领奖
            if completionTime == 0 then
                -- 未开始
            else
                if completionTime <= now then
                    --已完成
                    if self.infos.rewarded == 1 then
                        --已领奖
                        self.go_btn:SetActive(false)
                        self.go_bg:SetActive(false)
                        self.got_bg:SetActive(true)
                        self.duigou_img:SetActive(true)
                        --if #self.infos.stealInfoList == 0 then
                        --    --完美
                        --    self.perpect_text:SetActive(true)
                        --end
                    else
                        --未领取
                        self.go_btn:SetActive(false)
                        self.receive_btn:SetActive(true)
                    end
                else
                    --ing 隐藏go按钮，时间上下居中 [jinpeng:目前不会同时出现倒计时和按钮，prefab直接都居中]
                    self.cd_text_root:SetActive(true)
                    self.go_btn:SetActive(false)
                    self:AddTimer()
                    self:RefreshTime()
                end
            end
        else
            --联盟任务 只有援助按钮 (进行中的+未领取且世界可见的)
            if completionTime == 0 then
                -- 未开始
            else
                if completionTime <= now then
                    --已完成
                    if self.infos.rewarded == 1 then
                        --不应该有
                    else
                        --未领取 (援助)
                        self.go_btn:SetActive(true)
                    end
                else
                    --ing
                    self.cd_text_root:SetActive(true)
                    self.go_btn:SetActive(false)
                    self:AddTimer()
                    self:RefreshTime()
                end
            end
        end
    end
end

function DispatchTaskItem:DeleteTimer()
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

function DispatchTaskItem:AddTimer()
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(1, self.RefreshTime, self, false,false,false)
    end
    self.timer:Start()
end

function DispatchTaskItem:RefreshTime()
    if self.infos == nil then
        return
    end
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.infos.completionTime - curTime
    if remainTime > 0 then
        self.cd_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
        self.cd_text_root:SetActive(false)
        self:DeleteTimer()
        self:RefreshShow()
    end
end

function DispatchTaskItem:OnBgClick()
    --self:TaskGotoWorld()
    if self.tab == 1 then
        if self.infos.completionTime == 0 then
            local uuid = self.infos.uuid
            local pointId = self.infos.pointId
            GoToUtil.CloseAllWindows()
            GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(pointId,ForceChangeScene.World), nil,nil,function()
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationDispatchTask,uuid)
            end)
            return
        end
    end
    local pointId = self.infos.pointId
    local position = SceneUtils.TileIndexToWorld(pointId,ForceChangeScene.World)
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoWorldPos(position, nil,nil,function()
        WorldArrowManager:GetInstance():ShowArrowEffect(0,position,ArrowType.Building)
    end)
end

-- OnClick()
function DispatchTaskItem:OnGoClick()
    if self.tab == 1 then
        if self.infos.completionTime == 0 then
            local uuid = self.infos.uuid
            local pointId = self.infos.pointId
            GoToUtil.CloseAllWindows()
            GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(pointId,ForceChangeScene.World), nil,nil,function()
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationDispatchTask,uuid)
            end)
        else
            local uuid = self.infos.uuid
            local pointId = self.infos.pointId
            local position = SceneUtils.TileIndexToWorld(pointId,ForceChangeScene.World)
            GoToUtil.CloseAllWindows()
            GoToUtil.GotoWorldPos(position, nil,nil,function()
                WorldArrowManager:GetInstance():ShowArrowEffect(0,position,ArrowType.Building)
            end)
        end
    else
        if self.hasReceive == true then
            return
        end
        --援助 玩家每天协助收取的次数也是有限制的，满了再点提示
        local mgr = DataCenter.ActDispatchTaskDataManager
        local todayAssistNum = mgr:GetTodayAssistNum()
        local assistMax = toInt(mgr:GetDispatchSetting("aid_count"))
        if todayAssistNum < assistMax then
            SFSNetwork.SendMessage(MsgDefines.DispatchAssist, self.infos.uuid)
            self.hasReceive = true
        else
            UIUtil.ShowTipsId(461054)
        end
    end
end


function DispatchTaskItem:OnReceiveClick()
    if self.hasReceive == true then
        return
    end
    -- 领取任务奖励 收菜
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.infos.completionTime - curTime
    if remainTime > 0 then
        return
    end
    --local rewardPos = self.icon.transform.position
    --DataCenter.ChapterTaskManager:QuestGetReward(self.infos, rewardPos)
    CS.GameEntry.Sound:PlayEffect(SoundAssets.Music_Effect_Task_Done_Btn)
    SFSNetwork.SendMessage(MsgDefines.DispatchReward, self.infos.uuid)
    self.hasReceive = true
end

function DispatchTaskItem:GetRewardList(reward_str)
    local rewardShowList = {}
    if reward_str~=nil and reward_str~="" then
        local rewardList = string.split(reward_str,"|")
        table.walk(rewardList,function (k,v)
            local str = v
            if str~=nil and str~="" then
                local strVec = string.split(str,";")
                if #strVec>2 then
                    local id = tonumber(strVec[1])
                    local rewardType = tonumber(strVec[2])
                    local num = tonumber(strVec[3])
                    local item = {}
                    item.firstKill = false
                    if rewardType ==  RewardType.GOODS then
                        local goods = DataCenter.ItemTemplateManager:GetItemTemplate(id)
                        if goods~=nil then
                            item.itemId = id
                            item.iconName = string.format(LoadPath.ItemPath,goods.icon)
                            item.count = num
                            item.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(goods.color)
                            item.rewardType = rewardType
                            item.itemName = DataCenter.ItemTemplateManager:GetName(id)
                            item.itemDesc = DataCenter.ItemTemplateManager:GetDes(id)
                            item.isLocal = true
                            --item.itemName = goods.name
                            --item.itemDesc = goods.description
                            local itemType = goods.type
                            if itemType == 2 then -- SPD
                                if goods.para1 ~= nil and goods.para1 ~= "" then
                                    local para1 = goods.para1
                                    local temp = string.split(para1,';')
                                    if temp ~= nil and #temp > 1 then
                                        item.itemFlag = temp[1]..temp[2]
                                    end
                                end
                            elseif itemType == 3 then -- USE
                                local type2 = goods.type2
                                if type2 ~= 999 and goods.para ~= nil then
                                    local res_num = tonumber(goods.para)
                                    item.itemFlag = string.GetFormattedStr(res_num)
                                end
                            end
                            if item.firstKill == true then
                                table.insert(rewardShowList,item)
                            else
                                table.insert(rewardShowList,item)
                            end

                        end
                    else
                        local resourceType = RewardToResType[rewardType]
                        if resourceType~=nil then
                            item.itemId = id
                            item.iconName = DataCenter.ResourceManager:GetResourceIconByType(resourceType)
                            item.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.GREEN)
                            item.rewardType = rewardType
                            item.itemDesc = CommonUtil.GetResourceDescriptionByType(resourceType)
                            item.count = num
                            item.itemName = DataCenter.ResourceManager:GetResourceNameByType(resourceType)
                            item.isLocal = true
                            if item.firstKill == true then
                                table.insert(rewardShowList,item)
                            else
                                table.insert(rewardShowList,item)
                            end
                        end
                    end
                end
            end
        end)
    end
    return rewardShowList
end
return DispatchTaskItem