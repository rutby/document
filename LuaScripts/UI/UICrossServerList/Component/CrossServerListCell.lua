---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2022/8/8 11:19
---
local CrossServerListCell = BaseClass("CrossServerListCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Color_Select_MainTitle = Color.New(208/255, 104/255, 50/255, 1)
-- 创建
function CrossServerListCell:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
function CrossServerListCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

-- 显示
function CrossServerListCell:OnEnable()
    base.OnEnable(self)
end

-- 隐藏
function CrossServerListCell:OnDisable()
    base.OnDisable(self)
end


--控件的定义
function CrossServerListCell:ComponentDefine()
    self.btn = self:AddComponent(UIButton, "")
    self.btn:SetOnClick(function()
        self:OnBtnClick()
    end)
    self.un_select_img = self:AddComponent(UIImage, "unselect")
    self.select_img = self:AddComponent(UIImage, "select")
    self._server_txt = self:AddComponent(UIText, "Txt_ServerName")
end

--控件的销毁
function CrossServerListCell:ComponentDestroy()
    self.btn = nil
    self._server_txt = nil
end

--变量的定义
function CrossServerListCell:DataDefine()
    self.param = {}
end

--变量的销毁
function CrossServerListCell:DataDestroy()
    self.param = nil
end

-- 全部刷新
function CrossServerListCell:ReInit(param)
    --self.param = param
    self.serverId = param
    local selfServerId = LuaEntry.Player:GetSelfServerId()
    self._server_txt:SetText(Localization:GetString("208236",self.serverId))
    if self.serverId == selfServerId then
        self.select_img:SetActive(true)
        self.un_select_img:SetActive(false)
    else
        self.select_img:SetActive(false)
        self.un_select_img:SetActive(true)
    end
end


function CrossServerListCell:OnBtnClick()
    local selfServerId = LuaEntry.Player:GetSelfServerId()
    if self.serverId ~= selfServerId then
        local data = DataCenter.MigrateDataManager:OnGetServerDetailDataByServerId(self.serverId)
        if data~=nil then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UICheckServer,self.serverId,true)
        else
            UIManager:GetInstance():OpenWindow(UIWindowNames.UICheckServer,self.serverId)
        end
       
    end
    
end

return  CrossServerListCell