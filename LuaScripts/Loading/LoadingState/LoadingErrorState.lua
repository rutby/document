---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 4/3/2024 下午2:23
---
local LoadingStateBase = require("Loading.LoadingState.LoadingStateBase")
local LoadingErrorState = BaseClass("LoadingErrorState", LoadingStateBase)
local Const = require("Loading.Const")
local GameEntry = CS.GameEntry
local Localization = CS.GameEntry.Localization
function LoadingErrorState:__init(startupLoading)
    LoadingStateBase:__init(startupLoading)
end

function LoadingStateBase:__delete()

end

function LoadingErrorState:OnEnter(args)
    EventManager:GetInstance():Broadcast(EventId.CloseDisconnectView)

    local errorCode = args[1]
    LoadingPrint("Loading error: %s", tostring(errorCode))
    

    if errorCode == Const.LoginErrorCode.ERROR_NETWORK
            or errorCode == Const.LoginErrorCode.ERROR_HTTP
            or errorCode == Const.LoginErrorCode.ERROR_TIMEOUT
            or errorCode == Const.LoginErrorCode.ERROR_CONNECT
            or errorCode == Const.LoginErrorCode.ERROR_UNREACHABLE
            or errorCode == Const.LoginErrorCode.ERROR_CONN_LOST
            or errorCode == Const.LoginErrorCode.ERROR_LOGIN_ERROR then
        UIUtil.ShowMessage(Localization:GetString("129063"), 2, 110043, 129091,function()
            LoadingPrint("LoadingErrorState 1!")
            CS.ApplicationLaunch.Instance:Quit()
        end, function()
            CS.ApplicationLaunch.Instance:ReStartGame()
        end,function()
            CS.ApplicationLaunch.Instance:ReStartGame()
        end)
    elseif errorCode == Const.LoginErrorCode.ERROR_UPDATE_MANIFEST
            or errorCode == Const.LoginErrorCode.ERROR_CHECK_VERSION_FAILED
            or errorCode == Const.LoginErrorCode.ERROR_CHECK_VERSION_TIMEOUT then
        UIUtil.ShowMessage(Localization:GetString("129063"), 2, 110043, 129091,function()
            LoadingPrint("LoadingErrorState 2!")
            CS.ApplicationLaunch.Instance:Quit()
        end, function()
            CS.ApplicationLaunch.Instance:ReStartGame()
        end,function()
            CS.ApplicationLaunch.Instance:ReStartGame()
        end)
    elseif errorCode == Const.LoginErrorCode.ERROR_LOAD_DATATABLE
            or errorCode == Const.LoginErrorCode.ERROR_LOAD_DATATABLE_TIMEOUT
            or errorCode == Const.LoginErrorCode.ERROR_LOGIN_TIMEOUT
            or errorCode == Const.LoginErrorCode.ERROR_JSON
            or errorCode == Const.LoginErrorCode.ERROR_DATA
            or errorCode == Const.LoginErrorCode.ERROR_INIT
            or errorCode == Const.LoginErrorCode.ERROR_INIT_TIMEOUT then
        UIUtil.ShowMessage(Localization:GetString("129063"), 2, 110043, 129091,function()
            LoadingPrint("LoadingErrorState 3!")
            CS.ApplicationLaunch.Instance:Quit()
        end, function()
            CS.ApplicationLaunch.Instance:ReStartGame()
        end, function()
            CS.ApplicationLaunch.Instance:ReStartGame()
        end)
    elseif errorCode == Const.LoginErrorCode.ERROR_MAINTENANCE then
        UIUtil.ShowMessage(Localization:GetString("129012"), 2, "", "", function()
            CS.ApplicationLaunch.Instance:ReStartGame()
        end, function()
            LoadingPrint("LoadingErrorState 4!")
            CS.ApplicationLaunch.Instance:Quit()
        end,function()
            CS.ApplicationLaunch.Instance:ReStartGame()
        end)
    elseif errorCode == Const.LoginErrorCode.ERROR_SERVER_LIST
            or errorCode == Const.LoginErrorCode.ERROR_SERVER_LIST_EMPTY then
        local str = Localization:GetString("129063") .. "\n" .. GameEntry.Device:GetDeviceUid()
        UIUtil.ShowMessage(str, 2, 110043, 129091, function()
            LoadingPrint("LoadingErrorState 5!")
            CS.ApplicationLaunch.Instance:Quit()
        end, function()
            CS.ApplicationLaunch.Instance:ReStartGame()
        end,nil,nil,nil,nil,nil,nil,true)
    elseif errorCode == Const.LoginErrorCode.ERROR_DOWNLOAD_UPDATE then
        UIUtil.ShowMessage(Localization:GetString("129063"), 2, 110043, 129091, function()
            LoadingPrint("LoadingErrorState 6!")
            CS.ApplicationLaunch.Instance:Quit()
        end, function()
            CS.ApplicationLaunch.Instance:ReStartGame()
        end,function()
            CS.ApplicationLaunch.Instance:ReStartGame()
        end)
    elseif errorCode == Const.LoginErrorCode.ERROR_MAIL_ERROR then
        UIUtil.ShowMessage(Localization:GetString("208269"), 2, 110043, 129091, function()
            CS.ApplicationLaunch.Instance:Quit()
        end, function()
            CS.ApplicationLaunch.Instance:ReStartGame()
        end,function()
            CS.ApplicationLaunch.Instance:ReStartGame()
        end)
    elseif errorCode == Const.LoginErrorCode.ERROR_SEASON_SEVER_START then
        UIUtil.ShowMessage(Localization:GetString("110319"), 1, 110043, 129091, function()
            CS.ApplicationLaunch.Instance:Quit()
        end,function()
            CS.ApplicationLaunch.Instance:Quit()
        end,function()
            CS.ApplicationLaunch.Instance:Quit()
        end)
    elseif errorCode == Const.LoginErrorCode.ERROR_ACCOUNT_ERR then
        UIUtil.ShowMessage(Localization:GetString("280061"), 1, 129091,"", function()
            CS.ApplicationLaunch.Instance:ReStartGame()
        end,function()
            CS.ApplicationLaunch.Instance:ReStartGame()
        end,function()
            CS.ApplicationLaunch.Instance:ReStartGame()
        end)
    end
end

function LoadingErrorState:OnExit()

end

function LoadingErrorState:OnUpdate()

end

return LoadingErrorState