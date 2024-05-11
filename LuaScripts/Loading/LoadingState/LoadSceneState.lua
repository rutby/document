---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 4/3/2024 下午2:05
---
local LoadingStateBase = require("Loading.LoadingState.LoadingStateBase")
local LoadSceneState = BaseClass("LoadSceneState", LoadingStateBase)
local Const = require("Loading.Const")

function LoadSceneState:__init(startupLoading)
    LoadingStateBase:__init(startupLoading)
end

function LoadingStateBase:__delete()

end

function LoadSceneState:OnEnter(args)
end

function LoadSceneState:OnExit()

end

function LoadSceneState:OnUpdate()
    if self._startupLoading:GetLoadingProgress()>= 0.999 and (CS.SceneManager.World == nil or CS.SceneManager.World:IsBuildFinish()) then
        self._startupLoading:SetState(Const.LoadingState.EnterGame)
    end
end


return LoadSceneState