---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 4/3/2024 下午12:13
---
local LoadingStateBase = require("Loading.LoadingState.LoadingStateBase")
local LoginState = BaseClass("LoginState", LoadingStateBase)
local Const = require("Loading.Const")

function LoginState:__init(startupLoading)
    LoadingStateBase:__init(startupLoading)
end

function LoginState:__delete()

end

function LoginState:OnEnter(args)
    self._elapseTime = 0
    self._timeout = 5

    ---- 登录前首先要初始化游戏
    --LuaEntry:StartGame()

    PostEventLog.Record(PostEventLog.Defines.LOGIN_START)

    -- 发送登录消息，考虑到
    local so = CS.Sfs2X.Entities.Data.SFSObject()
    CS.LoginMessage.Instance.onLoginResponse = function(msg) self:OnLoginResponse(msg) end
    CS.LoginMessage.Instance:Send(CS.GameEntry.Network.Uid, "", CS.GameEntry.Network.ZoneName);
end

function LoginState:OnExit()
end

function LoginState:OnUpdate()
    -- 如果有对话框存在的话，不做处理

    self._elapseTime = self._elapseTime + Time.deltaTime
    if self._elapseTime > self._timeout then
        if self._startupLoading.LoginTryCount < self._startupLoading.LoginMaxTryCount then
            self._startupLoading:StartConnect()
        else
            self._startupLoading:SetState(Const.LoadingState.LoadingError, Const.LoginErrorCode.ERROR_LOGIN_TIMEOUT)
        end
    end
end

function LoginState:OnLoginResponse(loginMessage)
    Logger.Log("OnLoginResponse ok")

    if loginMessage:ContainsKey("errorMessage") ==true then
        local errorCode = loginMessage:GetUtfString("errorMessage")
        if not CS.CommonUtils.IsDebug() and (errorCode == "E002" or errorCode == "E001") then
            CS.UnityEngine.PlayerPrefs.DeleteAll()
            CS.ApplicationLaunch.Instance:ReStartGame()
        else
            if errorCode == Const.LoginErrorCode.ERROR_SEASON_SEVER_START then
                self._startupLoading:SetState(Const.LoadingState.LoadingError, Const.LoginErrorCode.ERROR_SEASON_SEVER_START)
            elseif errorCode == Const.LoginErrorCode.ERROR_MAIL_ERROR then
                self._startupLoading:SetState(Const.LoadingState.LoadingError, Const.LoginErrorCode.ERROR_MAIL_ERROR)
            else
                if App.IsDebug() then
                    UIUtil.ShowMessage(errorCode, 2, "", "110043", function()
                        CS.ApplicationLaunch.Instance:ReStartGame()
                    end, function()
                        CS.ApplicationLaunch.Instance:Quit()
                    end,function()
                        CS.ApplicationLaunch.Instance:Quit()
                    end,nil,nil,nil,nil,nil,true)
                    self._startupLoading:SetState(Const.LoadingState.LoadingError,"")
                else
                    self._startupLoading:SetState(Const.LoadingState.LoadingError, Const.LoginErrorCode.ERROR_LOGIN_ERROR)
                end
                
            end
        end
    else
        if CS.GameEntry.GlobalData.updateType == 2 then
            self._startupLoading:SetState(Const.LoadingState.AppUpdate)
        else
            self._startupLoading:SetState(Const.LoadingState.PushInit,loginMessage)
        end
    end
end

return LoginState