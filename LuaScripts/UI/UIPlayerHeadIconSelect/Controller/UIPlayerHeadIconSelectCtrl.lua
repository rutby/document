
local UIPlayerHeadIconSelectCtrl = BaseClass("UIPlayerHeadIconSelectCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization



local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPlayerHeadIconSelect)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function OnPhotoClick(self)
  --  Logger.LogError(" 点击相册按钮")
   -- CS.GameEntry.UI:OpenUIForm(CS.GameDefines.UIAssets.UIChangehead, CS.GameDefines.UILayer.Normal);
	local state = PermissionType.Accept
	if CS.GameEntry.Sdk.GetPermissionByType~=nil then -- 1授权  2拒绝(未授权)   3永久拒绝
		local stateStr = CS.GameEntry.Sdk:GetPermissionByType(1)
		state = tonumber(stateStr)
		if state==nil then
			state = PermissionType.Request
		end
	end
	if state == PermissionType.Accept then
		CS.UploadImageManager.Instance:OnUploadImage(1, LuaEntry.Player.uid, LuaEntry.Player.picVer,
				function(ret, reason)
					if ret ~= "true" then
						--print(reason)
						local str = Localization:GetString("120239").."\n"..reason
						UIUtil.ShowTipsId(str) --120239=头像上传失败，请重试！
						LuaEntry.Player:UploadPicEnd()
						return
					end
					SFSNetwork.SendMessage(MsgDefines.UpdatePic)
				end)
	elseif state == PermissionType.Refuse then
		UIUtil.ShowMessage(Localization:GetString("208261"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL)
	else
		UIUtil.ShowMessage(Localization:GetString("208262"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
			CS.UploadImageManager.Instance:OnUploadImage(1, LuaEntry.Player.uid, LuaEntry.Player.picVer,
					function(ret, reason)
						if ret ~= "true" then
							--print(reason)
							local str = Localization:GetString("120239").."\n"..reason
							UIUtil.ShowTipsId(str) --120239=头像上传失败，请重试！
							LuaEntry.Player:UploadPicEnd()
							return
						end
						SFSNetwork.SendMessage(MsgDefines.UpdatePic)
					end)
		end)
	end
		
	self:CloseSelf()
end


local function OnCameraClick(self)
  --  Logger.LogError(" 点击照相机按钮")

	local state = PermissionType.Accept
	if CS.GameEntry.Sdk.GetPermissionByType~=nil then -- 1授权  2拒绝(未授权)   3永久拒绝
		local stateStr = CS.GameEntry.Sdk:GetPermissionByType(0)
		state = tonumber(stateStr)
		if state==nil then
			state = PermissionType.Request
		end
	end
	if state == PermissionType.Accept then
		CS.UploadImageManager.Instance:OnUploadImage(0, LuaEntry.Player.uid, LuaEntry.Player.picVer,
				function(ret, reason)
					if ret ~= "true" then
						--print(reason)
						local str = Localization:GetString("120239").."\n"..reason
						UIUtil.ShowTipsId(str) --120239=头像上传失败，请重试！
						return
					end

					SFSNetwork.SendMessage(MsgDefines.UpdatePic)
				end)
	elseif state == PermissionType.Refuse then
		UIUtil.ShowMessage(Localization:GetString("208259"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL)
	else
		UIUtil.ShowMessage(Localization:GetString("208260"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
			CS.UploadImageManager.Instance:OnUploadImage(0, LuaEntry.Player.uid, LuaEntry.Player.picVer,
					function(ret, reason)
						if ret ~= "true" then
							--print(reason)
							local str = Localization:GetString("120239").."\n"..reason
							UIUtil.ShowTipsId(str) --120239=头像上传失败，请重试！
							return
						end

						SFSNetwork.SendMessage(MsgDefines.UpdatePic)
					end)
		end)
	end
	
	
	
	self:CloseSelf()
end


UIPlayerHeadIconSelectCtrl.CloseSelf = CloseSelf
UIPlayerHeadIconSelectCtrl.Close = Close
UIPlayerHeadIconSelectCtrl.OnPhotoClick = OnPhotoClick
UIPlayerHeadIconSelectCtrl.OnCameraClick = OnCameraClick
return UIPlayerHeadIconSelectCtrl