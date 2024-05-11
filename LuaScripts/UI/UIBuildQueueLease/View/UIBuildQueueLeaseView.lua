--- Created by shimin.
--- DateTime: 2023/12/20 20:44
--- 租赁建筑队列界面

local UIBuildQueueLeaseView = BaseClass("UIBuildQueueLeaseView", UIBaseView)
local base = UIBaseView

local return_btn_path = "panel"
local close_btn_path = "bg/CloseBtn"
local title_text_path = "bg/title_text"
local name_text_path = "bg/name_text"
local des_text_path = "bg/des_text"
local blue_btn_path = "bg/btn_go/blue_btn"
local blue_cost_go_path = "bg/btn_go/blue_btn/blue_cost_go"
local blue_cost_name_text_path = "bg/btn_go/blue_btn/blue_cost_go/blue_cost_name_text"
local blue_cost_time_text_path = "bg/btn_go/blue_btn/blue_cost_go/blue_cost_time_text"
local blue_btn_text_path = "bg/btn_go/blue_btn/blue_btn_text"
local yellow_btn_path = "bg/btn_go/yellow_btn"
local yellow_name_text_path = "bg/btn_go/yellow_btn/yellow_name_text"
local yellow_btn_text_path = "bg/btn_go/yellow_btn/yellow_btn_text"
local gold_btn_path = "fullTop/gold_btn"
local gold_num_text_path = "fullTop/gold_btn/gold_num_text"

local BuyId = 1002

--创建
function UIBuildQueueLeaseView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
function UIBuildQueueLeaseView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIBuildQueueLeaseView:ComponentDefine()
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.return_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
    self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
    self.des_text = self:AddComponent(UITextMeshProUGUIEx, des_text_path)
    self.blue_btn = self:AddComponent(UIButton, blue_btn_path)
    self.blue_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnBlueBtnClick()
    end)
    self.blue_cost_go = self:AddComponent(UIBaseContainer, blue_cost_go_path)
    self.blue_cost_name_text = self:AddComponent(UITextMeshProUGUIEx, blue_cost_name_text_path)
    self.blue_cost_time_text = self:AddComponent(UITextMeshProUGUIEx, blue_cost_time_text_path)
    self.blue_btn_text = self:AddComponent(UITextMeshProUGUIEx, blue_btn_text_path)
    self.yellow_btn = self:AddComponent(UIButton, yellow_btn_path)
    self.yellow_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnYellowBtnClick()
    end)
    self.yellow_name_text = self:AddComponent(UITextMeshProUGUIEx, yellow_name_text_path)
    self.yellow_name_text:SetLocalText(GameDialogDefine.UNLOCK_FOREVER)
    self.yellow_btn_text = self:AddComponent(UITextMeshProUGUIEx, yellow_btn_text_path)
    self.gold_btn = self:AddComponent(UIButton, gold_btn_path)
    self.gold_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnGoldBtnClick()
    end)
    self.gold_num_text = self:AddComponent(UITextMeshProUGUIEx, gold_num_text_path)
end

function UIBuildQueueLeaseView:ComponentDestroy()
end

function UIBuildQueueLeaseView:DataDefine()
    self.spendGold = 0
    self.robotId = BuyId
end

function UIBuildQueueLeaseView:DataDestroy()
end

function UIBuildQueueLeaseView:OnEnable()
    base.OnEnable(self)
end

function UIBuildQueueLeaseView:OnDisable()
    base.OnDisable(self)
end

function UIBuildQueueLeaseView:ReInit()
    self.title_text:SetLocalText(GameDialogDefine.UNLOCK_MORE_BUILD_QUEUE)
    self.name_text:SetLocalText(GameDialogDefine.BUY_BUILD_QUEUE_DES)
    self.robotId = self:GetRobotId()
    self:Refresh()
    self:RefreshGold()
end

function UIBuildQueueLeaseView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
end

function UIBuildQueueLeaseView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
end

function UIBuildQueueLeaseView:Refresh()
    if DataCenter.GuideManager:IsFreeLeaseBuildQueue() then
        self.des_text:SetLocalText(GameDialogDefine.MORE_BUILD_QUEUE_DES)
        self.yellow_btn:SetActive(false)
        self.blue_btn:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_btn_green101"))
        self.blue_cost_go:SetActive(false)
        self.blue_btn_text:SetActive(true)
        self.blue_btn_text:SetLocalText(GameDialogDefine.USE_FIFTEEN_MIN)
    else
        self.des_text:SetLocalText(GameDialogDefine.BUY_BUILD_QUEUE_GIFT_DES)
        self.yellow_btn:SetActive(true)
        local dataList = GiftPackageData.getRobotPacks() or {}
        if #dataList > 0 then
            self.giftPack = dataList[1]
            self.yellow_btn_text:SetText(DataCenter.PayManager:GetDollarText(self.giftPack:getPrice(), self.giftPack:getProductID()))
        end
        
        self.blue_btn:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_btn_blue_big"))
        self.blue_cost_go:SetActive(true)
        self.blue_cost_name_text:SetLocalText(GameDialogDefine.LEASE_BUILD_QUEUE_TWO_DAY)
        self.blue_btn_text:SetActive(false)

        local template = DataCenter.BuildQueueTemplateManager:GetBuildQueueTemplate(self.robotId)
        if template ~= nil then
            if template.unlockType == BuildQueueUnlockType.Gold then
                self.spendGold = tonumber(template.unlockParam)
                self.blue_cost_time_text:SetText(string.GetFormattedSeperatorNum(template.unlockParam))
                self:RefreshGoldColor()
            end
        end
    end
end

function UIBuildQueueLeaseView:RefreshGold()
    self.gold_num_text:SetText(string.GetFormattedSeperatorNum(LuaEntry.Player.gold))
end


function UIBuildQueueLeaseView:UpdateGoldSignal()
    self:RefreshGoldColor()
    self:RefreshGold()
end

function UIBuildQueueLeaseView:RefreshGoldColor()
    if self.spendGold ~= 0 then
        local gold = LuaEntry.Player.gold
        if gold < self.spendGold then
            self.blue_cost_time_text:SetColor(ButtonRedTextColor)
        else
            self.blue_cost_time_text:SetColor(WhiteColor)
        end
    end
end

function UIBuildQueueLeaseView:OnBlueBtnClick()
    if DataCenter.GuideManager:IsFreeLeaseBuildQueue() then
        SFSNetwork.SendMessage(MsgDefines.UserNewbieRobotUnlock)
        self.ctrl:CloseSelf()
    else
        local gold = LuaEntry.Player.gold
        if gold < self.spendGold then
            GoToUtil.GotoPayTips()
        else
            SFSNetwork.SendMessage(MsgDefines.UnlockBuildingQueue, self.robotId)
            self.ctrl:CloseSelf()
        end
    end
end

function UIBuildQueueLeaseView:OnYellowBtnClick()
    if self.giftPack ~= nil then
        DataCenter.PayManager:CallPayment(self.giftPack, "GoldExchangeView")
        self.ctrl:CloseSelf()
    end
    --[[local template = DataCenter.BuildQueueTemplateManager:GetBuildQueueTemplate(self.robotId)
    if template ~= nil then
        if template.gift ~= nil and template.gift ~= "" then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackage, {anim = true},
                    {
                        targetPackageId = template.gift
                    })
        else
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackage)
        end
        self.ctrl:CloseSelf()
    end]]
end

function UIBuildQueueLeaseView:OnGoldBtnClick()
    GoToUtil.GotoPay()
end

function UIBuildQueueLeaseView:GetRobotId()
    return BuyId
end

return UIBuildQueueLeaseView