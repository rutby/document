--[[
	web相关的功能
]]

local WebUtil = {}
--[[
-- 头像上传URL
local PHOTO_UPLOAD_URL = "http://10.7.88.22:85/upload_img.php"
-- 头像下载URL
local PHOTO_DOWNLOAD_URL = "http://10.7.88.22:89/img/"

-- 上传图片
function WebUtil.UploadImage(uid, seq_id, filePath, callback)
	print(string.format('#WebUtil# UploadImage uid:{%s}, seq_id:{%d}, filePath:{%s}', uid, seq_id, filePath))
	
	local ret = CS.ChatService.Instance:UploadHeadImage(PHOTO_UPLOAD_URL, 
		uid, seq_id, filePath, callback)
	if ret == false then
		if callback then
			callback("false", "return")
		end
	end
					
end

-- 下载图片
function WebUtil.DownloadImage(uid, seq_id, filePath, callback)

	local ret = CS.ChatService.DownloadHeadImage(PHOTO_DOWNLOAD_URL,
		uid, seq_id, filePath, callback)
	if ret == false then
		if callback then
			callback("false", "return")
		end
	end

end

--call by c# UploadImageManager
function WebUtil:UploadHead(filePath)
	local picVer = LuaEntry.Player.picVer
	picVer = picVer % 1000000
	local photo_seq = tostring(picVer + 1)
	
	WebUtil.UploadImage(LuaEntry.Player.uid, photo_seq, filePath, function (ret, str)
		print('#WebUtil#  Res:' .. tostring(ret))
		
		if ret == "false" then
			UIUtil.ShowTips('120239')
			return
		end
		
		SFSNetwork.SendMessage(MsgDefines.UpdatePic)
	end)
end
]]

return WebUtil