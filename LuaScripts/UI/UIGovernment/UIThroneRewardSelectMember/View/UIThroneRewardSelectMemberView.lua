--- Created by shimin
--- DateTime: 2023/3/20 20:53
--- 王座发奖界面

local UIThroneRewardSelectMemberView = BaseClass("UIThroneRewardSelectMemberView", UIBaseView)
local base = UIBaseView
local UIThroneRewardSelectMemberCell = require "UI.UIGovernment.UIThroneRewardSelectMember.Component.UIThroneRewardSelectMemberCell"
local Localization = CS.GameEntry.Localization

local title_txt_path ="UICommonPopUpTitle/bg_mid/titleText"
local close_btn_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local return_btn_path = "UICommonPopUpTitle/panel"
local input_path = "ImgBg/InputField"
local search_btn_path = "ImgBg/BtnSearch"
local content_path = "ImgBg/ScrollView/Viewport/Content"
local des_text_path = "ImgBg/TxtEmpty"
local btn_path = "ImgBg/BtnYellow03"
local btn_text_path = "ImgBg/BtnYellow03/GoBtnName"

function UIThroneRewardSelectMemberView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

function UIThroneRewardSelectMemberView:ComponentDefine()
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.return_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.title_txt = self:AddComponent(UITextMeshProUGUIEx, title_txt_path)
    self.input = self:AddComponent(UIInput, input_path)
    self.search_btn = self:AddComponent(UIButton, search_btn_path)
    self.search_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnSearchBtnClick()
    end)
    self.content = self:AddComponent(UIBaseContainer, content_path)
    self.des_text = self:AddComponent(UIText, des_text_path)
    self.btn_text = self:AddComponent(UIText, btn_text_path)
    self.btn = self:AddComponent(UIButton, btn_path)
    self.btn:SetOnClick(function()
        self:OnClickBtn()
    end)
end

function UIThroneRewardSelectMemberView:ComponentDestroy()
end

function UIThroneRewardSelectMemberView:DataDefine()
    self.tabType = 0
    self.leftNum = 0
    self.allNum = 0
    self.uid = {}
    self.present = nil
    self.list = {}
    self.cell = {}
end

function UIThroneRewardSelectMemberView:DataDestroy()
    self.tabType = 0
    self.leftNum = 0
    self.allNum = 0
    self.uid = {}
    self.present = nil
    self.list = {}
    self.cell = {}
end

function UIThroneRewardSelectMemberView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIThroneRewardSelectMemberView:OnEnable()
    base.OnEnable(self)
end

function UIThroneRewardSelectMemberView:OnDisable()
    base.OnDisable(self)
end

function UIThroneRewardSelectMemberView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.GovernmentPresentRefresh, self.GovernmentPresentRefreshSignal)
    self:AddUIListener(EventId.SendContactGiftSearchBack, self.SendContactGiftSearchBackSignal)
    self:AddUIListener(EventId.AllianceMember, self.AllianceMemberSignal)
end

function UIThroneRewardSelectMemberView:OnRemoveListener()
    self:RemoveUIListener(EventId.GovernmentPresentRefresh, self.GovernmentPresentRefreshSignal)
    self:RemoveUIListener(EventId.SendContactGiftSearchBack, self.SendContactGiftSearchBackSignal)
    self:RemoveUIListener(EventId.AllianceMember, self.AllianceMemberSignal)
    base.OnRemoveListener(self)
 
end

function UIThroneRewardSelectMemberView:ReInit()
    if LuaEntry.Player:IsInAlliance() then
        SFSNetwork.SendMessage(MsgDefines.AlRank, LuaEntry.Player.allianceId)
    end
    self.tabType = self:GetUserData()
    self.uid = {}
    self.present = DataCenter.GovernmentManager:GetPresentByRewardType(self.tabType)
    if self.present ~= nil then
        local template = DataCenter.WonderGiftTemplateManager:GetTemplate(self.present.presentId)
        if template ~= nil then
            self.allNum = template.num
            local tileName = Localization:GetString(template.name)
            self.title_txt:SetText(tileName)
        end
    end
    self:RefreshLeftNum()
    self.btn_text:SetLocalText(GameDialogDefine.SEND)
    --第一次显示联盟中的人
    self:AllianceMemberSignal()
end

--点击发奖（只有国王可以点击）
function UIThroneRewardSelectMemberView:OnClickBtn()
    local result = {}
    for k,v in pairs(self.uid) do
        if not DataCenter.GovernmentManager:IsGetReward(k) then
            table.insert(result, k)
        end
    end
    if result[1] ~= nil then
        UIUtil.ShowTipsId(GameDialogDefine.SEND_SUCCESS)
        DataCenter.GovernmentManager:KingSendPresent(result, self.present.presentId)
    end
    self.ctrl:CloseSelf()
end

function UIThroneRewardSelectMemberView:GovernmentPresentRefreshSignal()
    self:RefreshLeftNum()
    self:ShowCells()
end

function UIThroneRewardSelectMemberView:OnSearchBtnClick()
    local str = self.input:GetText()
    if str ~= "" and #str >= 3 then
        SFSNetwork.SendMessage(MsgDefines.SendContactGiftSearch, LuaEntry.Player.serverId, str)
    else
        UIUtil.ShowTipsId(GameDialogDefine.INPUT_MORE_THEN_THREE_CHAR)
    end
end

function UIThroneRewardSelectMemberView:RefreshLeftNum()
    self.des_text:SetText(Localization:GetString(GameDialogDefine.SELECT_PLAYER_SEND_GIFT) .. 
            "(" .. Localization:GetString(GameDialogDefine.LEFT) .. self:GetLeftNum() .. "/" .. self.allNum .. ")")
    if table.count(self.uid) > 0 then
        self.btn:SetInteractable(true)
    else
        self.btn:SetInteractable(false)
    end
end

function UIThroneRewardSelectMemberView:GetLeftNum()
    return self.allNum - self.present.useCount - table.count(self.uid)
end


function UIThroneRewardSelectMemberView:SendContactGiftSearchBackSignal(message)
    self.list = {}
    if message["searchRet"] then
        for k, v in ipairs(message["searchRet"]) do
            if v.uid ~= LuaEntry.Player.uid then
                table.insert(self.list, v)
            end
        end
    end
    self:Sort()
    self:ShowCells()
end

function UIThroneRewardSelectMemberView:ShowCells()
    local count = #self.list
    for k,v in ipairs(self.list) do
        if self.cell[k] == nil then
            local param = {}
            self.cell[k] = param
            param.visible = true
            param.info = v
            param.select = self:IsSelect(v.uid)
            param.req = self:GameObjectInstantiateAsync(UIAssets.UIThroneRewardSelectMemberCell, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject
                go:SetActive(true)
                go.transform:SetParent(self.content.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                go.transform:SetAsLastSibling()
                local nameStr = tostring(NameCount)
                go.name = nameStr
                NameCount = NameCount + 1
                local model = self.content:AddComponent(UIThroneRewardSelectMemberCell, nameStr)
                model:ReInit(param)
                param.model = model
            end)
        else
            self.cell[k].visible = true
            self.cell[k].info = v
            self.cell[k].select = self:IsSelect(v.uid)
            if self.cell[k].model ~= nil then
                self.cell[k].model:Refresh()
            end
        end
    end
    local cellCount = #self.cell
    if cellCount > count then
        for i = count + 1, cellCount, 1 do
            local cell = self.cell[i]
            if cell ~= nil then
                cell.visible = false
                if cell.model ~= nil then
                    cell.model:Refresh()
                end
            end
        end
    end
end

function UIThroneRewardSelectMemberView:IsSelect(uid)
    return self.uid[uid] ~= nil
end

function UIThroneRewardSelectMemberView:Select(uid)
    if self.uid[uid] == nil then
        self.uid[uid] = true
    else
        self.uid[uid] = nil
    end
    self:RefreshLeftNum()
end

function UIThroneRewardSelectMemberView:CanSelect()
    return self:GetLeftNum() > 0
end

function UIThroneRewardSelectMemberView:AllianceMemberSignal()
    self.list = {}
    local all = DataCenter.AllianceMemberDataManager:GetAllMember()
    if all ~= nil then
        for _, v in pairs(all) do
            if v.uid ~= LuaEntry.Player.uid then
                table.insert(self.list, v)
            end
        end
        self:Sort()
        self:ShowCells()
    end
end

function UIThroneRewardSelectMemberView:Sort()
    if self.list[2] ~= nil then
        table.sort(self.list, function (a, b)
            local sendA = DataCenter.GovernmentManager:IsGetReward(a.uid)
            local sendB = DataCenter.GovernmentManager:IsGetReward(b.uid)
            if sendA == sendB then
                return a.uid < b.uid
            else
                if sendA then
                    return false
                end
                return true
            end
            return false
        end)
    end
end


return UIThroneRewardSelectMemberView