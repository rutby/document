using System;
using System.Collections.Generic;
using GameFramework;
using Google.Protobuf;
using Protobuf;
public class WorldDesertInfo
{
    public int pointIndex;
    public int desertId;
    public long uuid;
    public int serverId;
    public int srcServerId;
    public string ownerUid;
    public string allianceId;
    public int protectEndTime;
    public bool hasAssistance;
    public int mineId;
    public int oriDesertId;
    public WorldDesertInfo()
    {
    }
    public WorldDesertInfo(DesertInfo di)
    {
        pointIndex = di.Id;
        uuid = di.Uuid;
        desertId = di.DesertId;
        serverId = di.ServerId;
        srcServerId = di.OwnerServer;
        allianceId = di.AllianceId;
        protectEndTime = di.ProtectEndTime;
        ownerUid = di.Uid;
        hasAssistance = di.HasAssistance;
        mineId = di.MineId;
        oriDesertId = di.OriDesertId;
    }
    
    public PlayerType GetPlayerType()
    {
        if (ownerUid.IsNullOrEmpty())
        {
            return PlayerType.PlayerNone;
        }
        string uid = GameEntry.Data.Player.GetUid();
        if (uid == ownerUid)
        {
            return PlayerType.PlayerSelf;
        }

        string myAllianceId = GameEntry.Data.Player.GetAllianceId();
        if (string.IsNullOrEmpty(myAllianceId))
        {
            return PlayerType.PlayerOther;
        }

        if (myAllianceId == allianceId)
        {
            return PlayerType.PlayerAlliance;
        }

        return PlayerType.PlayerOther;
    }

    public bool IsRed()
    {
        if (srcServerId != GameEntry.Data.Player.GetSelfServerId())
        {
            return true;
        }

        if (GameEntry.Data.Player.GetIsInAttackDic(ownerUid) == true)
        {
            return true;
        }
        if (GameEntry.Data.Player.GetIsInFightServerList(srcServerId) == true)
        {
            return true;
        }
        string fightAllianceId = GameEntry.Data.Player.GetFightAllianceId();
        if (fightAllianceId.IsNullOrEmpty() == false && fightAllianceId == allianceId)
        {
            return true;
        }

        if (GameEntry.GlobalData.serverType == (int)ServerType.EDEN_SERVER)
        {
            if (GameEntry.Data.Player.IsAllianceSelfCamp(allianceId))
            {
                return false;
            }
            return true;
        }
        return false;
    }

    public bool IsYellow()
    {
        if (GameEntry.Data.Player.GetIsInAttackDic(ownerUid) == true)
        {
            return false;
        }
        if (GameEntry.GlobalData.serverType == (int)ServerType.EDEN_SERVER)
        {
            if (GameEntry.Data.Player.IsAllianceSelfCamp(allianceId))
            {
                return true;
            }
        }

        return false;
    }
}