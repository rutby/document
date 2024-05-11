---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Still4.
--- DateTime: 2021/7/1 12:06
---
local UIPositionFavoriteItem = BaseClass("UIPositionFavoriteItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local first_name_path = "ImgBg/firstNameTxt"
local second_name_path = "ImgBg/secondNameTxt"
local jump_txt_path = "ImgBg/jumpButton/jumpText"
local jump_btn_path = "ImgBg/jumpButton"
local del_btn_path = "ImgBg/delButton"
local share_btn_path = "ImgBg/shareButton"
local flag_path = "ImgBg/Flag"
local function OnCreate(self)
    base.OnCreate(self)
    self.first_txt = self:AddComponent(UIText, first_name_path)
    self.second_txt = self:AddComponent(UIText, second_name_path)
    self.jump_btn = self:AddComponent(UIButton, jump_btn_path)
    self.jump_btn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnJumpClick()
    end)
    self.jump_txt = self:AddComponent(UIText, jump_txt_path)
    self.jump_txt:SetLocalText(110003) 
    self.del_btn = self:AddComponent(UIButton, del_btn_path)
    self.del_btn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnDelClick()
    end)
    self.share_btn = self:AddComponent(UIButton, share_btn_path)
    self.share_btn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnShareClick()
    end)
    self.flag = self:AddComponent(UIImage, flag_path)
end

local function SetItemShow(self, data)
    self.data = data
    self.first_txt:SetText(self.data.name)
    local pos = SceneUtils.IndexToTilePos(self.data.pos)
    if DataCenter.AccountManager:GetServerTypeByServerId(self.data.server) == ServerType.DRAGON_BATTLE_FIGHT_SERVER then
        self.second_txt:SetLocalText(376134, pos.x,  pos.y)
    else
        self.second_txt:SetLocalText(128005,  self.data.server,  pos.x,  pos.y)
    end
    
    local img = "Common_img_mark"
    if self.data.type == 0 then
        img = "Common_img_mark"
    elseif self.data.type == 1 then
        img = "Common_img_mark_friend"
    elseif self.data.type == 2 then
        img = "Common_img_mark_enemy"
    elseif self.data.type == 3 then
        img = "Common_img_mark_alliance"
    end
    img = string.format(LoadPath.CommonNewPath, img)
    self.flag:LoadSprite(img)

end

local function OnJumpClick(self)
    self.view.ctrl:OnClickPosBtn(self.data)
end

local function OnDelClick(self)
    self.view.ctrl:DelBookMark(self.data)
end

local function OnShareClick(self)
    self.view.ctrl:ShareBookMark(self.data)
end

UIPositionFavoriteItem.OnCreate = OnCreate
UIPositionFavoriteItem.SetItemShow = SetItemShow
UIPositionFavoriteItem.OnJumpClick = OnJumpClick
UIPositionFavoriteItem.OnDelClick = OnDelClick
UIPositionFavoriteItem.OnShareClick = OnShareClick

return UIPositionFavoriteItem