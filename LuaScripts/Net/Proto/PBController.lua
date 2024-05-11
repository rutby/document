---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mac.
--- DateTime: 7/15/21 9:02 PM
---
local PBController = BaseClass("PBController")
local rapidjson = require "rapidjson"
local pb = require "pb"
local protoc = require "Common.protoc"
local base64 = require "Framework.Common.base64"

local ProtoConfig = {
    "Assets/Main/Proto/Wrappers.proto.bytes",
    "Assets/Main/Proto/BattleReport.proto.bytes",
    "Assets/Main/Proto/Mail.proto.bytes",
    "Assets/Main/Proto/AllianceCityRecordProto.proto.bytes",
    "Assets/Main/Proto/WorldPointInfo.proto.bytes",
    "Assets/Main/Proto/ArmyUnitInfo.proto.bytes",
    "Assets/Main/Proto/DeliteReport.proto.bytes",
    "Assets/Main/Proto/WorldCityRankMail.proto.bytes",
    "Assets/Main/Proto/CrossPlunderData.proto.bytes",
    "Assets/Main/Proto/BattleRoundPush.proto.bytes",
    "Assets/Main/Proto/Resident.proto.bytes",
}

--[[
    不同的pb配置文件--这部分回头需要优化,目前一直没有装好环境,暂时先使用scheme的形式,效率会低一些
]]
--local PB_Wrapper = require "Net.Proto.Wrappers"
--local Pb_ArmyUnitInfo = require "Net.Proto.ArmyUnitInfo"
--local Pb_BattleReport = require "Net.Proto.BattleReport"
--local Pb_ScoutReport = require "Net.Proto.Mail"
--local Pb_WorldPointInfo = require "Net.Proto.WorldPointInfo"
--local Pb_AllianceCityRecordProto = require "Net.Proto.AllianceCityRecordProto"
-- 在刚进入游戏的时候就加载吧

function PBController.InitBytes(bytes)
    protoc:loadBytes(bytes)
end

function PBController.InitPBConfig()
    --protoc:loadfile("Assets/ProtoFile/Wrappers.proto")
    --protoc:loadfile("Assets/ProtoFile/AllianceCityRecordProto.proto")
    --protoc:loadfile("Assets/ProtoFile/ArmyUnitInfo.proto")
    --protoc:loadfile("Assets/ProtoFile/BattleReport.proto")
    --protoc:loadfile("Assets/ProtoFile/Mail.proto")
    --protoc:loadfile("Assets/ProtoFile/WorldPointInfo.proto")
    
    
    
    
    
    
     --protoc:load(PB_Wrapper, "Wrappers.proto")
     --protoc:load(Pb_ArmyUnitInfo, "ArmyUnitInfo.proto")
     --protoc:load(Pb_BattleReport, "BattleReport.proto")
     --protoc:load(Pb_ScoutReport, "Mail.proto")
     --protoc:load(Pb_WorldPointInfo, "WorldPointInfo.proto")
     --protoc:load(Pb_AllianceCityRecordProto, "AllianceCityRecordProto.proto")

    --protoc:load(PB_Wrapper, "Wrappers.proto")
    --protoc:load(Pb_ArmyUnitInfo, "ArmyUnitInfo.proto")
    --protoc:load(Pb_BattleReport, "BattleReport.proto")
    --protoc:load(Pb_ScoutReport, "Mail.proto")
    --protoc:load(Pb_WorldPointInfo, "WorldPointInfo.proto")

    --PBController.LoadBytes("Wrappers.proto.bytes")
    --PBController.LoadBytes("ArmyUnitInfo.proto.bytes")
    --PBController.LoadBytes("BattleReport.proto.bytes")
    --PBController.LoadBytes("Mail.proto.bytes")

    --if (add == false) then
    --    local loadAsset = CS.UnityEngine.AssetBundle.LoadFromFile("Assets/Proto/game_proto_bundle.bundle")
    --    if (loadAsset == nil) then
    --        return
    --    end
    --    local func_asset = xlua.get_generic_method(CS.UnityEngine.AssetBundle, 'LoadAsset')
    --    local func_asset1 = func_asset(CS.UnityEngine.TextAsset)
    --    for i = 1, table.count(ProtoConfig) do
    --        local result = func_asset1(loadAsset, ProtoConfig[i])
    --        local binary = result.bytes
    --        protoc:loadBytes(binary)
    --    end
    --    add = true
    --end
end


function PBController.LoadBytes(filename)
    local luafile = CS.UnityEngine.Application.dataPath .. "/Proto/" .. filename;
    local file = io.open(luafile, 'r')
    local data = file:read("*a")
    file:close()
    protoc:loadBytes(data)
end

--function PBController.ParsePb( dataTable, pbType )
--    local result = {}
--    for _, v in pairs(dataTable) do
--        result[#result+1] = string.pack("B", v)
--    end
--    local strBinary = table.concat(result)
--    return pb.decode(".protobuf.ArmyUnitInfo", strBinary)
--end
--

function PBController.ParsePb1( strBinary, pbType )
    local armyObj_binary = base64.decode(strBinary)
    return pb.decode(pbType, armyObj_binary)
end

function PBController.ParsePbFromBytes(bytes,pbType)
    return pb.decode(pbType, bytes)
end

PBController.ProtoConfig = ProtoConfig;
return PBController