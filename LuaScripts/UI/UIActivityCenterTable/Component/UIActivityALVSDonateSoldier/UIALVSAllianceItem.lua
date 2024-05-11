local UIALVSAllianceItem = BaseClass("UIALVSAllianceItem", UIBaseContainer)
local base = UIBaseContainer;

local left_time_text_path = "layout/LeftTimeText"
local next_wave_text_path = "layout/NextWaveText"
local gray_node_path = "grayNode"
local index_bg_path = "grayNode/IndexBg"
local icon_path = "grayNode/icon"
local bg_path = "grayNode/bg"
local level_path = "grayNode/level"
local text_path = "grayNode/Text"
local click_node_path = "ClickNode"
local extra_score_node_path = "ExtraScoreNode"
local extra_score_path = "ExtraScoreNode/ExtraScore"
local extra_score_num_path = "ExtraScoreNode/ExtraScoreNum"
local yes_path = "yes"
local no_path = "no"
local not_put_down_path = "NotPutDown"
local not_put_down_text_path = "NotPutDown/NotPutDownText"
local attack_icon_path = "attackIcon"
local yes_label_path = "yes/yesLabel"
local no_label_path = "no/noLabel"
local un_open_label_path = "UnOpenLabel"


local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ComponentDefine(self)

    self.left_time_text = self:AddComponent(UIText, left_time_text_path)
    self.next_wave_text = self:AddComponent(UIText, next_wave_text_path)

    self.gray_node = self:AddComponent(UIBaseContainer, gray_node_path)
    self.index_bg = self:AddComponent(UIImage, index_bg_path)
    self.icon = self:AddComponent(UIImage, icon_path)
    self.bg = self:AddComponent(UIImage, bg_path)
    self.level = self:AddComponent(UIText, level_path)
    self.click_node = self:AddComponent(UIButton, click_node_path)
    self.click_node:SetOnClick(function()
        self:OnClick()
    end)

    self.text = self:AddComponent(UIText, text_path)
    self.extra_score_node = self:AddComponent(UIBaseContainer, extra_score_node_path)
    self.extra_score = self:AddComponent(UIText, extra_score_path)
    self.extra_score:SetLocalText(130294)
    self.extra_score_num = self:AddComponent(UIText, extra_score_num_path)
    self.yes = self:AddComponent(UIImage, yes_path)
    self.no = self:AddComponent(UIImage, no_path)
    self.not_put_down = self:AddComponent(UIBaseContainer, not_put_down_path)
    self.not_put_down_text = self:AddComponent(UIText, not_put_down_text_path)
    self.not_put_down_text:SetLocalText(110599)
    self.attack_icon = self:AddComponent(UIImage, attack_icon_path)

    self.yes_label = self:AddComponent(UIText, yes_label_path)
    self.yes_label:SetLocalText(302229)
    self.no_label = self:AddComponent(UIText, no_label_path)
    self.no_label:SetLocalText(311110)
    self.un_open_label = self:AddComponent(UIText, un_open_label_path)
    self.un_open_label:SetLocalText(308046)

    self.is_finished = false
end

local function ComponentDestroy(self)
    self.left_time_text = nil
    self.next_wave_text = nil
    self.gray_node = nil
    self.icon = nil
    self.bg = nil
    self.level = nil
    self.click_node = nil
    self.text = nil
    self.extra_score_node = nil
    self.extra_score = nil
    self.extra_score_num = nil
    self.yes = nil
    self.no = nil
    self.index_bg = nil
    self.not_put_down = nil
    self.not_put_down_text = nil
    self.attack_icon = nil

    self.yes_label = nil
    self.no_label = nil
    self.un_open_label = nil

end

local function SetAllianceBuildingInfo(self, info, index)
    --[[
        buildingId    //int 联盟中心建筑id
        serverId      //int 建筑所在服务器id
        pointId       //int 建筑坐标，=0 表示没放
        state         //int 0未开始  1 正在进攻当前联盟中心  2 防守成功  3 防守失败
        round					  //int 当前攻击波次
        nextRoundTime			  //long 下波海盗攻击时间,没有该字段表示没有下一波了
    ]]
    self.left_time_text:SetActive(false)
    self.next_wave_text:SetActive(false)
    self.no:SetActive(false)
    self.yes:SetActive(false)
    self.un_open_label:SetActive(false)

    self.buildingInfo = info
    self.index = index
    self.level:SetText(tostring(self.index))
    self.attack_icon:SetActive(false)

    local allianceBuildTemp = DataCenter.AllianceMineManager:GetAllianceMineTemplate(self.buildingInfo.buildingId)
    local buildName = ""
    if allianceBuildTemp then
        buildName = allianceBuildTemp.name
    end

    if self.buildingInfo ~= nil and self.buildingInfo.pointId == 0 then
        --未放置的联盟中心
        self.not_put_down:SetActive(true)
    else
        self.not_put_down:SetActive(false)
    end

    if self.buildingInfo.state == 0 then
        -- 未开始
        self.next_wave_text:SetActive(false)
        if self.isSelf == nil then
            self.un_open_label:SetActive(true)
        end
    elseif self.buildingInfo.state == 1 then
        -- 正在进攻
        self.next_wave_text:SetActive(true)
        -- 当前波次：(x/x)
        -- self.next_wave_text:SetLocalText(308022, tostring(self.buildingInfo.round), tostring(self.buildingInfo.maxRound))
        self.attack_icon:SetActive(true)
        self:OnUpdate1000ms() -- 调用下定时器 里面有对战斗不同波次的处理
    elseif self.buildingInfo.state == 2 then
        --防守成功
        self.next_wave_text:SetActive(false)
        self.yes:SetActive(true)
        self:ShowExtraScore()
    elseif self.buildingInfo.state == 3 then
        --放手失败 显示叉子 并且置灰
        self.next_wave_text:SetActive(false)
        self.no:SetActive(true)
        self:SetPicGray(true)
    end

    self.text:SetLocalText(buildName)
end

-- 手动设置联盟建筑防守失败状态 用于可宣战时间内没宣战的时候调用
-- 此时服务器状态不会置为失守 需要前端自己设置一下。
local function SetAllianceBuildingFail(self)
    self.next_wave_text:SetActive(false)
    self.no:SetActive(true)
    self.un_open_label:SetActive(false)
    self:SetPicGray(true)
end

local function ShowExtraScore(self)
    if self.buildingInfo == nil then
        return
    end

    local allianceBuildTemp = DataCenter.AllianceMineManager:GetAllianceMineTemplate(self.buildingInfo.buildingId)
    if allianceBuildTemp then
        -- 根据联盟建筑id对应取第几个dataconfig的key值
        local key = ""
        if self.buildingInfo.buildingId == BuildingTypes.ALLIANCE_CENTER_1 then
            key = "k3"
        elseif self.buildingInfo.buildingId == BuildingTypes.ALLIANCE_CENTER_2 then
            key = "k4"
        elseif self.buildingInfo.buildingId == BuildingTypes.ALLIANCE_CENTER_3 then
            key = "k5"
        else
            key = "k6"
        end
        
        local value = LuaEntry.DataConfig:TryGetStr("activity_donate_v2", key)
        local addScoreStr = ""
        if value ~= nil then
            addScoreStr = tostring(value)

            self.extra_score_node:SetActive(true)
            self.extra_score_num:SetText("+" .. addScoreStr)
        end
    end
end

-- 每秒定时在UIActivityALVSBattle中调用
local function OnUpdate1000ms(self)
    if self.buildingInfo == nil then
        return
    end

    if self.is_finished == true then
        --如果处于战斗已结束的状态
        self.next_wave_text:SetActive(false)
        self.left_time_text:SetActive(false)
        return
    end

    local now = UITimeManager:GetInstance():GetServerTime()
    if self.buildingInfo.state == 1 then
        self.un_open_label:SetActive(false)
        -- 正在进攻
        local nextRoundTime = 0
        if self.buildingInfo.nextRoundTime ~= nil then
            nextRoundTime = self.buildingInfo.nextRoundTime
        end

        local deltaTime = 0
        if nextRoundTime > 0 then
            self.next_wave_text:SetActive(true)
            self.left_time_text:SetActive(true)
            deltaTime = nextRoundTime - now 
            if deltaTime >= 0 then
                if self.buildingInfo.round == 0 then
                    self.next_wave_text:SetLocalText(308022) --进攻倒计时
                else
                    self.next_wave_text:SetLocalText(308044, tostring(self.buildingInfo.maxRound - self.buildingInfo.round)) --剩余波次
                end
                self.left_time_text:SetText(UITimeManager:GetInstance():SecondToFmtString(deltaTime / 1000)) --时间
            else
                self.next_wave_text:SetLocalText(308044, tostring(self.buildingInfo.maxRound - self.buildingInfo.round)) --剩余波次
                self.left_time_text:SetActive(false)
            end
            -- -- 假如没有下一波时间
        else
            self.next_wave_text:SetActive(false)
            self.left_time_text:SetActive(false)
        end
    end
end

local function OnClick(self)
    if self.buildingInfo == nil or self.buildingInfo.pointId == 0 then
        --未放置的联盟中心
        UIUtil.ShowTipsId(308032)
        return
    end
    GoToUtil.CloseAllWindows()
    local worldPos = SceneUtils.TileIndexToWorld(self.buildingInfo.pointId, ForceChangeScene.World)
    GoToUtil.GotoWorldPos(worldPos, CS.SceneManager.World.InitZoom, nil, nil ,self.buildingInfo.serverId)
end

local function SetPicGray(self, gray)
    if gray == true then
        self.index_bg:SetColor(Color32.New(0.7, 0.7, 0.7, 0.7))
        self.icon:SetColor(Color32.New(0.7, 0.7, 0.7, 0.7))
        self.bg:SetColor(Color32.New(0.7, 0.7, 0.7, 0.7))
        self.level:SetColor(Color32.New(0.7, 0.7, 0.7, 0.7))
        -- self.text:SetColor(Color32.New(0.7, 0.7, 0.7, 0.7))
    else
        self.index_bg:SetColor(Color32.New(1, 1, 1, 1))
        self.gray_node:SetColor(Color32.New(1, 1, 1, 1))
        self.icon:SetColor(Color32.New(1, 1, 1, 1))
        self.bg:SetColor(Color32.New(1, 1, 1, 1))
        self.level:SetColor(Color32.New(1, 1, 1, 1))
        -- self.text:SetColor(Color32.New(1, 1, 1, 1))
    end
end

local function SetIsNextAttackBuilding(self)
    self.left_time_text:SetActive(false)
    self.next_wave_text:SetActive(true)
    self.next_wave_text:SetLocalText(308039)
end

local function SetBattleIsFinished(self)
    self.is_finished = true
    self:OnUpdate1000ms()
end

local function SetIsSelf(self, v)
    self.isSelf = v
end

UIALVSAllianceItem.OnCreate = OnCreate
UIALVSAllianceItem.OnDestroy = OnDestroy
UIALVSAllianceItem.OnEnable = OnEnable
UIALVSAllianceItem.OnDisable = OnDisable
UIALVSAllianceItem.ComponentDefine = ComponentDefine
UIALVSAllianceItem.ComponentDestroy = ComponentDestroy
UIALVSAllianceItem.SetAllianceBuildingInfo = SetAllianceBuildingInfo
UIALVSAllianceItem.SetAllianceBuildingFail = SetAllianceBuildingFail
UIALVSAllianceItem.OnUpdate1000ms = OnUpdate1000ms
UIALVSAllianceItem.OnClick = OnClick
UIALVSAllianceItem.SetPicGray = SetPicGray
UIALVSAllianceItem.ShowExtraScore = ShowExtraScore
UIALVSAllianceItem.SetIsNextAttackBuilding = SetIsNextAttackBuilding
UIALVSAllianceItem.SetBattleIsFinished = SetBattleIsFinished
UIALVSAllianceItem.SetIsSelf = SetIsSelf

return UIALVSAllianceItem