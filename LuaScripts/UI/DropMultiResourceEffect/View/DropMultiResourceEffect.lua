---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guq.
--- DateTime: 2021/5/18 16:15
---
local DropMultiResourceEffect = BaseClass("DropMultiResourceEffect")

local icon1_path = "mask/item1/icon1"
local icon2_path = "mask/item1/icon2"
local icon3_path = "mask/item2/icon3"
local icon4_path = "mask/item2/icon4"
local icon5_path = "mask/item3/icon5"
local icon6_path = "mask/item3/icon6"
local self_path = "mask"
--创建
local function OnCreate(self,go)
    if go ~= nil then
        self.request = go
        self.gameObject = go.gameObject
        self.transform = go.gameObject.transform
    end
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
end

local function ComponentDefine(self)
    self.animator = self.transform:Find(self_path):GetComponent(typeof(CS.UnityEngine.Animator))
    self.icon1 = self.transform:Find(icon1_path):GetComponent(typeof(CS.UnityEngine.UI.Image))
    self.icon2 = self.transform:Find(icon2_path):GetComponent(typeof(CS.UnityEngine.UI.Image))
    self.icon3 = self.transform:Find(icon3_path):GetComponent(typeof(CS.UnityEngine.UI.Image))
    self.icon4 = self.transform:Find(icon4_path):GetComponent(typeof(CS.UnityEngine.UI.Image))
    self.icon5 = self.transform:Find(icon5_path):GetComponent(typeof(CS.UnityEngine.UI.Image))
    self.icon6 = self.transform:Find(icon6_path):GetComponent(typeof(CS.UnityEngine.UI.Image))
end


local function ComponentDestroy(self)
    self.animator = nil
    self.icon1 = nil
    self.icon2 = nil
    self.icon3 = nil
    self.icon4 = nil
    self.icon5 = nil
    self.icon6 = nil
end


local function DataDefine(self)
    self.param = nil
    self.__update_handle = function() self:Update() end
    UpdateManager:GetInstance():AddUpdate(self.__update_handle)
    self.isDoAnim = false
    self.curTime = 0
end

local function DataDestroy(self)
    self.param = nil
    UpdateManager:GetInstance():RemoveUpdate(self.__update_handle)
    self.__update_handle = nil
    self.isDoAnim = nil
    self.curTime = nil
end



local function ReInit(self,param)
    self.param = param
    self:ShowPanel()
end

local function ShowPanel(self)
    Logger.Log("drop positon".."x:"..self.param.pos.x.."y:"..self.param.pos.y.."z:"..self.param.pos.z)
    self.gameObject.transform.position = self.param.pos
    if #self.param.iconList>=3 then
        self.icon1:LoadSprite(self.param.iconList[1])
        self.icon2:LoadSprite(self.param.iconList[1])
        self.icon3:LoadSprite(self.param.iconList[2])
        self.icon4:LoadSprite(self.param.iconList[2])
        self.icon5:LoadSprite(self.param.iconList[3])
        self.icon6:LoadSprite(self.param.iconList[3])
        self.icon1.gameObject:SetActive(true)
        self.icon2.gameObject:SetActive(true)
        self.icon3.gameObject:SetActive(true)
        self.icon4.gameObject:SetActive(true)
        self.icon5.gameObject:SetActive(true)
        self.icon6.gameObject:SetActive(true)
    elseif  #self.param.iconList>=2 then
        self.icon1:LoadSprite(self.param.iconList[1])
        self.icon2:LoadSprite(self.param.iconList[1])
        self.icon3:LoadSprite(self.param.iconList[2])
        self.icon4:LoadSprite(self.param.iconList[2])
        self.icon1.gameObject:SetActive(true)
        self.icon2.gameObject:SetActive(true)
        self.icon3.gameObject:SetActive(true)
        self.icon4.gameObject:SetActive(true)
        self.icon5.gameObject:SetActive(false)
        self.icon6.gameObject:SetActive(false)
    elseif #self.param.iconList>=1 then
        self.icon1:LoadSprite(self.param.iconList[1])
        self.icon2:LoadSprite(self.param.iconList[1])
        self.icon1.gameObject:SetActive(true)
        self.icon2.gameObject:SetActive(true)
        self.icon3.gameObject:SetActive(false)
        self.icon4.gameObject:SetActive(false)
        self.icon5.gameObject:SetActive(false)
        self.icon6.gameObject:SetActive(false)
    end
    self.curTime = 0
    local clips = self.animator.runtimeAnimatorController.animationClips
    for i = 0, clips.Length - 1 do
        if clips[i].name == "factory_drop_item" then
            self.endTime = clips[i].length
        end
    end
    self.animator:Play("factory_drop_item",0,0)
    self.isDoAnim = true

end

local function Update(self)
    if self.isDoAnim then
        self.curTime = self.curTime + Time.deltaTime
        if self.curTime > self.endTime then
            self.isDoAnim = false
            DataCenter.DropResourceEffectManager:RemoveOneEffect(self.param)
        end
    end
end


DropMultiResourceEffect.OnCreate = OnCreate
DropMultiResourceEffect.OnDestroy = OnDestroy
DropMultiResourceEffect.ComponentDefine = ComponentDefine
DropMultiResourceEffect.ComponentDestroy = ComponentDestroy
DropMultiResourceEffect.DataDefine = DataDefine
DropMultiResourceEffect.DataDestroy = DataDestroy
DropMultiResourceEffect.ReInit = ReInit
DropMultiResourceEffect.ShowPanel = ShowPanel
DropMultiResourceEffect.Update = Update
return DropMultiResourceEffect