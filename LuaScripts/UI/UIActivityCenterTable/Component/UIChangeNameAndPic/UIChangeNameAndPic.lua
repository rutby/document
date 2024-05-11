--- Created by shimin
--- DateTime: 2023/10/9 20:31
--- 改头换面活动界面

local UIChangeNameAndPic = BaseClass("UIChangeNameAndPic", UIBaseContainer)
local base = UIBaseContainer
local UICommonItemChange = require "UI.UICommonItem.UICommonItemChange"

local reward_tip_text_path = "offset/content/reward_tip_text"
local scroll_view_path = "offset/content/ScrollView"
local reward_btn_path = "offset/content/reward_btn"
local reward_btn_text_path = "offset/content/reward_btn/reward_btn_text"
local have_get_reward_text_path = "offset/content/have_get_reward_text"
local change_name_text_path = "offset/content/change_name_go/change_name_text"
local change_name_goto_btn_path = "offset/content/change_name_go/change_name_goto_btn"
local change_name_goto_btn_text_path = "offset/content/change_name_go/change_name_goto_btn/change_name_goto_btn_text"
local change_name_finish_text_path = "offset/content/change_name_go/change_name_finish_text"
local change_pic_text_path = "offset/content/change_pic_go/change_pic_text"
local change_pic_goto_btn_path = "offset/content/change_pic_go/change_pic_goto_btn"
local change_pic_goto_btn_text_path = "offset/content/change_pic_go/change_pic_goto_btn/change_pic_goto_btn_text"
local change_pic_finish_text_path = "offset/content/change_pic_go/change_pic_finish_text"
local title_text_path = "offset/title_text"
local des_text_path = "offset/des_text"

function UIChangeNameAndPic:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

function UIChangeNameAndPic:ComponentDefine()
    self.reward_tip_text = self:AddComponent(UIText, reward_tip_text_path)
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCellMoveIn(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnCellMoveOut(itemObj, index)
    end)
    self.reward_btn = self:AddComponent(UIButton, reward_btn_path)
    self.reward_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnRewardBtnClick()
    end)
    self.reward_btn_text = self:AddComponent(UIText, reward_btn_text_path)
    self.have_get_reward_text = self:AddComponent(UIText, have_get_reward_text_path)
    self.change_name_text = self:AddComponent(UIText, change_name_text_path)
    self.change_name_goto_btn = self:AddComponent(UIButton, change_name_goto_btn_path)
    self.change_name_goto_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnChangeNameGotoBtnClick()
    end)
    self.change_name_goto_btn_text = self:AddComponent(UIText, change_name_goto_btn_text_path)
    self.change_name_finish_text = self:AddComponent(UIText, change_name_finish_text_path)
    self.change_pic_text = self:AddComponent(UIText, change_pic_text_path)
    self.change_pic_goto_btn = self:AddComponent(UIButton, change_pic_goto_btn_path)
    self.change_pic_goto_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnChangePicGotoBtnClick()
    end)
    self.change_pic_goto_btn_text = self:AddComponent(UIText, change_pic_goto_btn_text_path)
    self.change_pic_finish_text = self:AddComponent(UIText, change_pic_finish_text_path)
    self.title_text = self:AddComponent(UIText, title_text_path)
    self.des_text = self:AddComponent(UIText, des_text_path)
end

function UIChangeNameAndPic:ComponentDestroy()
end

function UIChangeNameAndPic:DataDefine()
    self.list = {}
    self.isClick = false
end

function UIChangeNameAndPic:DataDestroy()
    self.list = {}
    self.isClick = false
end

function UIChangeNameAndPic:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIChangeNameAndPic:OnEnable()
    base.OnEnable(self)
end

function UIChangeNameAndPic:OnDisable()
    base.OnDisable(self)
end

function UIChangeNameAndPic:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.RefreshChangeNameAndPic, self.RefreshChangeNameAndPicSignal)
end

function UIChangeNameAndPic:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.RefreshChangeNameAndPic, self.RefreshChangeNameAndPicSignal)
end

function UIChangeNameAndPic:ReInit()
    local act = DataCenter.ChangeNameAndPicManager:GetActivity()
    if act ~= nil then
        DataCenter.ChangeNameAndPicManager:SendGetUploadPicActivityInfo(tonumber(act.id))
        self.title_text:SetLocalText(act.name)
        self.des_text:SetLocalText(act.story)
    end
    self.reward_tip_text:SetLocalText(GameDialogDefine.FINISH_RIGHT_CAN_GET_REWARD)
    self.reward_btn_text:SetLocalText(GameDialogDefine.GET_REWARD)
    self.change_name_text:SetLocalText(GameDialogDefine.CHANGE_NAME)
    self.change_name_goto_btn_text:SetLocalText(GameDialogDefine.GOTO)
    self.change_pic_goto_btn_text:SetLocalText(GameDialogDefine.GOTO)
    self.change_name_finish_text:SetLocalText(GameDialogDefine.FINISHED)
    self.change_pic_text:SetLocalText(GameDialogDefine.UP_LOAD_CUSTOM_PIC)
    self.change_pic_finish_text:SetLocalText(GameDialogDefine.FINISHED)
    self:Refresh()
    DataCenter.ChangeNameAndPicManager:SetIsNew()
end


function UIChangeNameAndPic:ShowCells()
    self:ClearScroll()
    self:GetDataList()
    local count = table.count(self.list)
    if count > 0 then
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    end
end

function UIChangeNameAndPic:ClearScroll()
    self.scroll_view:ClearCells()--清循环列表数据
    self.scroll_view:RemoveComponents(UICommonItemChange)--清循环列表gameObject
end

function UIChangeNameAndPic:OnCellMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local item = self.scroll_view:AddComponent(UICommonItemChange, itemObj)
    item:ReInit(self.list[index])
end

function UIChangeNameAndPic:OnCellMoveOut(itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UICommonItemChange)
end

function UIChangeNameAndPic:GetDataList()
    self.list = {}
    local info = DataCenter.ChangeNameAndPicManager:GetActInfo()
    if info ~= nil then
        for k, v in ipairs(info.reward) do
            table.insert(self.list, v)
        end
    end
end

function UIChangeNameAndPic:Refresh()
    self.isClick = false
    local info = DataCenter.ChangeNameAndPicManager:GetActInfo()
    if info ~= nil then
        if info.rewardStatus == ChangeNameAndPicType.Yes then
            self.have_get_reward_text:SetActive(true)
            self.have_get_reward_text:SetLocalText(GameDialogDefine.HAS_GET)
            self.reward_btn:SetActive(false)
            self.change_name_goto_btn:SetActive(false)
            self.change_pic_goto_btn:SetActive(false)
            self.change_name_finish_text:SetActive(true)
            self.change_pic_finish_text:SetActive(true)
        else
            local changeNameState = info.changeName == ChangeNameAndPicType.Yes
            local changePicState = info.uploadPic == ChangeNameAndPicType.Yes
            if changeNameState and changePicState then
                self.have_get_reward_text:SetActive(false)
                self.reward_btn:SetActive(true)
                self.change_name_goto_btn:SetActive(false)
                self.change_pic_goto_btn:SetActive(false)
                self.change_name_finish_text:SetActive(true)
                self.change_pic_finish_text:SetActive(true)
            else
                self.have_get_reward_text:SetActive(true)
                self.have_get_reward_text:SetLocalText(GameDialogDefine.UN_FINISH)
                self.reward_btn:SetActive(false)
                if changeNameState then
                    self.change_name_goto_btn:SetActive(false)
                    self.change_name_finish_text:SetActive(true)
                else
                    self.change_name_goto_btn:SetActive(true)
                    self.change_name_finish_text:SetActive(false)
                end

                if changePicState then
                    self.change_pic_goto_btn:SetActive(false)
                    self.change_pic_finish_text:SetActive(true)
                else
                    self.change_pic_goto_btn:SetActive(true)
                    self.change_pic_finish_text:SetActive(false)
                end
            end
        end
    else
        self.have_get_reward_text:SetActive(true)
        self.have_get_reward_text:SetLocalText(GameDialogDefine.UN_FINISH)
        self.reward_btn:SetActive(false)
        self.change_name_goto_btn:SetActive(true)
        self.change_pic_goto_btn:SetActive(true)
        self.change_name_finish_text:SetActive(false)
        self.change_pic_finish_text:SetActive(false)
    end
    self:ShowCells()
end

function UIChangeNameAndPic:RefreshChangeNameAndPicSignal()
    self:Refresh()
end

function UIChangeNameAndPic:OnRewardBtnClick()
    if not self.isClick then
        local info = DataCenter.ChangeNameAndPicManager:GetActInfo()
        if info ~= nil then
            if info.rewardStatus == ChangeNameAndPicType.No and info.changeName == ChangeNameAndPicType.Yes and info.uploadPic == ChangeNameAndPicType.Yes then
                DataCenter.ChangeNameAndPicManager:SendReceiveUploadPicActivityReward()
                self.isClick = true
            end
        end
    end
end

function UIChangeNameAndPic:OnChangeNameGotoBtnClick()
    GoToUtil.CloseAllWindows()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPlayerInfo, LuaEntry.Player.uid, PLayerInfoArrowType.ChangeName)
end

function UIChangeNameAndPic:OnChangePicGotoBtnClick()
    GoToUtil.CloseAllWindows()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPlayerInfo, LuaEntry.Player.uid, PLayerInfoArrowType.ChangePic)
end

return UIChangeNameAndPic