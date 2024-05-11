---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2022/9/28 11:05
---
local CampDetailItem = BaseClass("CampDetailItem",UIBaseContainer)
local base = UIBaseContainer
local img1_path = "Image1"
local img2_path = "Image2"
local img3_path = "Image3"

local effect1_path = "Image1/VFX_ui_restraintbtn_pian_glow_blue02"
local effect2_path = "Image2/VFX_ui_restraintbtn_pian_glow_blue01"
local effect3_path = "Image3/VFX_ui_restraintbtn_pian_glow_blue"

local function OnCreate(self)
    base.OnCreate(self)
    self.img1 = self:AddComponent(UIImage,img1_path)
    self.img2 = self:AddComponent(UIImage,img2_path)
    self.img3 = self:AddComponent(UIImage,img3_path)
    self.effect1 = self:AddComponent(UIBaseContainer, effect1_path)
    self.effect2 = self:AddComponent(UIBaseContainer, effect2_path)
    self.effect3 = self:AddComponent(UIBaseContainer, effect3_path)
    self.effect1:SetActive(true)
    self.effect2:SetActive(true)
    self.effect3:SetActive(true)

    self.firstImgCamp = -1 --策划杨波给的规则，记录1号位上一次更新的阵营
end

local function OnDestroy(self)
    self.img1 = nil
    self.img2 = nil
    self.img3 = nil
    base.OnDestroy(self)
end

local function InitData(self,campList,needShowEffect)
    local str = "Assets/Main/Sprites/UI/UITroopsNew/UITroopsNew_img_fetters_"
    local preVisible1 = self.img1:GetActive()
    local preVisible2 = self.img2:GetActive()
    local preVisible3 = self.img3:GetActive()
    self.img1:SetActive(false)
    self.img2:SetActive(false)
    self.img3:SetActive(false)
    
    if campList~=nil then
        if #campList >=2 then
            table.sort(campList,function(a,b)
                return a.camp<b.camp
            end)
            local campA = campList[1]
            local campB = campList[2]
            if campA.num ==3 and campB.num ==2 then
                self.img2:SetActive(true)
                self.img3:SetActive(true)
                self.img2:LoadSprite(str.."2_"..campA.camp)
                self.img3:LoadSprite(str.."3_"..campA.camp)
                self.img1:SetActive(true)
                self.img1:LoadSprite(str.."1_"..campB.camp)
                self.firstImgCamp = campB.camp
            elseif campB.num == 3 and campA.num ==2 then
                self.img2:SetActive(true)
                self.img3:SetActive(true)
                self.img2:LoadSprite(str.."2_"..campB.camp)
                self.img3:LoadSprite(str.."3_"..campB.camp)
                self.img1:SetActive(true)
                self.img1:LoadSprite(str.."1_"..campA.camp)
                self.firstImgCamp = campA.camp
            elseif campA.num ==2 and campB.num ==2 then
                self.img1:SetActive(true)
                self.img2:SetActive(true)
                if self.firstImgCamp<0 then
                    self.firstImgCamp = campB.camp
                end
                if self.firstImgCamp == campA.camp then
                    self.img1:LoadSprite(str.."1_"..campA.camp)
                    self.img2:LoadSprite(str.."2_"..campB.camp)
                elseif self.firstImgCamp == campB.camp then
                    self.img1:LoadSprite(str.."1_"..campB.camp)
                    self.img2:LoadSprite(str.."2_"..campA.camp)
                else
                    self.img1:LoadSprite(str.."1_"..campB.camp)
                    self.img2:LoadSprite(str.."2_"..campA.camp)
                end
                
            end
            
        elseif #campList == 1 then
            local campA = campList[1]
            if campA.num ==5 then
                self.img1:SetActive(true)
                self.img2:SetActive(true)
                self.img3:SetActive(true)
                self.img1:LoadSprite(str.."1_"..campA.camp)
                self.img2:LoadSprite(str.."2_"..campA.camp)
                self.img3:LoadSprite(str.."3_"..campA.camp)
            elseif campA.num ==4 then
                self.img1:SetActive(true)
                self.img2:SetActive(true)
                self.img1:LoadSprite(str.."1_"..campA.camp)
                self.img2:LoadSprite(str.."2_"..campA.camp)
            elseif campA.num ==3 then
                self.img2:SetActive(true)
                self.img3:SetActive(true)
                self.img2:LoadSprite(str.."2_"..campA.camp)
                self.img3:LoadSprite(str.."3_"..campA.camp)
            elseif campA.num ==2 then
                self.img1:SetActive(true)
                self.img1:LoadSprite(str.."1_"..campA.camp)
            end
            self.firstImgCamp = campA.camp
        else
            self.firstImgCamp = -1
        end
    else
        self.firstImgCamp = -1
    end
    if needShowEffect then
        local nowVisible1 = self.img1:GetActive()
        local nowVisible2 = self.img2:GetActive()
        local nowVisible3 = self.img3:GetActive()
        self.effect1:SetActive(not preVisible1 and nowVisible1)
        self.effect2:SetActive(not preVisible2 and nowVisible2)
        self.effect3:SetActive(not preVisible3 and nowVisible3)
    else
        self.effect1:SetActive(false)
        self.effect2:SetActive(false)
        self.effect3:SetActive(false)
    end
end
CampDetailItem.OnCreate = OnCreate
CampDetailItem.OnDestroy = OnDestroy
CampDetailItem.InitData =InitData
return CampDetailItem