---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/1/13 11:51
---

local BarterShopMoreBtn = BaseClass("BarterShopMoreBtn", UIBaseContainer)
local base = UIBaseContainer

local use_count_btn_path = "UseCountBtn"
local use_count_btn_name_path = "UseCountBtn/UseCountBtnName"
local use_max_btn_path = "UseMaxBtn"
local use_max_btn_name_path = "UseMaxBtn/UseMaxBtnName"

-- 创建
local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

--控件的定义
local function ComponentDefine(self)
    self.more_btn_go = self:AddComponent(UIAnimator, "")
    self.use_count_btn = self:AddComponent(UIButton, use_count_btn_path)
    self.use_count_btn_name = self:AddComponent(UITextMeshProUGUIEx, use_count_btn_name_path)
    self.use_max_btn = self:AddComponent(UIButton, use_max_btn_path)
    self.use_max_btn_name = self:AddComponent(UITextMeshProUGUIEx, use_max_btn_name_path)
    self.use_count_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:UseBtnClick()
    end)
    self.use_max_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:UseMaxBtnClick()
    end)
end

--控件的销毁
local function ComponentDestroy(self)

end

--变量的定义
local function DataDefine(self)
   
end

--变量的销毁
local function DataDestroy(self)

end

local function InitData(self)
    self.exchangeIndex = nil
    self.exchangeNum = nil
    self.BarterList = nil
end

local function SetUseBtnState(self,state)
    self.use_count_btn:SetActive(state)
end

local function SetUseBtnTxt(self,str)
    self.use_count_btn_name:SetText(str)
end

local function SetMaxBtnState(self,state)
    self.use_max_btn:SetActive(state)
end

local function SetMaxBtnTxt(self,str)
    self.use_max_btn_name:SetText(str)
end

local function SetBtnParam(self,exchangeIndex,count,BarterList)
    self.exchangeIndex = exchangeIndex
    self.exchangeNum = count
    self.BarterList = BarterList
end

local function ShowMoreBtn(self,pos)
    local moreBtnParent = pos
    if self.moreBtnParent ~= moreBtnParent then
        self.moreBtnParent = moreBtnParent
        self.more_btn_go.transform:SetParent(moreBtnParent)
        self.more_btn_go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
        local ret,time = self.more_btn_go:PlayAnimationReturnTime("ShowMoreBtn")
        if ret then
            self.showTimer = TimerManager:GetInstance():GetTimer(time + 0.5, function()
                if self.showTimer ~= nil then
                    self.showTimer:Stop()
                    self.showTimer = nil
                end
            end , self, true,false,false)
            self.showTimer:Start()
        end
    end
end

local function HideMoreBtn(self,pos)
    if self.moreBtnParent then
        self.more_btn_go.transform:SetParent(pos)
        self.more_btn_go.transform:SetAsFirstSibling()
        self.moreBtnParent = nil
        self.more_btn_go:Play("CloseMoreBtn",0,0)
    end
end

local function ClearParent(self)
    self.moreBtnParent = nil
end

local function UseBtnClick(self)
    if self.isRefreshSuccess then
        return
    end
    if self.exchangeNum and self.exchangeIndex and self.BarterList and self.BarterList[self.exchangeIndex] then
        self.isRefreshSuccess = true
        self.exchangeNum = self.exchangeNum - 5
        --提前计算兑换后是否还能再次兑换
        if self.exchangeNum < 5 then
            self.use_count_btn:SetActive(false)
        end
        if self.exchangeNum <= 0 then
            self:HideMoreBtn()
        end
        self.use_max_btn_name:SetText("x"..self.exchangeNum)
        SFSNetwork.SendMessage(MsgDefines.BarterShopExchange,self.BarterList[self.exchangeIndex].activity_id, self.BarterList[self.exchangeIndex].id,5)
    end
end

local function UseMaxBtnClick(self)
    self:HideMoreBtn()
    if self.isRefreshSuccess then
        return
    end
    if self.exchangeNum and self.exchangeIndex and self.BarterList and self.BarterList[self.exchangeIndex] then
        self.isRefreshSuccess = true
        SFSNetwork.SendMessage(MsgDefines.BarterShopExchange,self.BarterList[self.exchangeIndex].activity_id, self.BarterList[self.exchangeIndex].id,self.exchangeNum)
        self.exchangeNum = nil
    end
end

local function RefreshEnterState(self,state)
    self.isRefreshSuccess = state
end


BarterShopMoreBtn.OnCreate = OnCreate
BarterShopMoreBtn.OnDestroy = OnDestroy
BarterShopMoreBtn.ComponentDefine = ComponentDefine
BarterShopMoreBtn.ComponentDestroy = ComponentDestroy
BarterShopMoreBtn.DataDefine = DataDefine
BarterShopMoreBtn.DataDestroy = DataDestroy
BarterShopMoreBtn.InitData = InitData
BarterShopMoreBtn.SetUseBtnState = SetUseBtnState
BarterShopMoreBtn.SetUseBtnTxt = SetUseBtnTxt
BarterShopMoreBtn.SetMaxBtnState = SetMaxBtnState
BarterShopMoreBtn.SetMaxBtnTxt = SetMaxBtnTxt
BarterShopMoreBtn.SetBtnParam = SetBtnParam
BarterShopMoreBtn.ShowMoreBtn = ShowMoreBtn
BarterShopMoreBtn.HideMoreBtn = HideMoreBtn
BarterShopMoreBtn.ClearParent = ClearParent
BarterShopMoreBtn.UseBtnClick = UseBtnClick
BarterShopMoreBtn.UseMaxBtnClick = UseMaxBtnClick
BarterShopMoreBtn.RefreshEnterState = RefreshEnterState

return BarterShopMoreBtn