using System.Collections.Generic;
using Sfs2X.Entities.Data;
using XLua;

public class DCPlayer : BaseDataContainer
{
    // uid和serverId可以缓存一份
    // 一方面是用的实在太多，另一方面是只有这两个值是不变的；其中serverId表示玩家账号所在的服务器
    // 其他值就不要缓存了，需要的话从LUA端去获取
    public string Uid;
    private int serverId;
    private int scrWorldId;
    private int curWorldId = 0;
    private int crossServerId = -1;
    private string fightAllianceId = "";
    private HashSet<int> serverDic = new HashSet<int>();
    private Dictionary<string,long> attackerDic = new Dictionary<string,long>();
    private Dictionary<string, int> allianceServerCamp = new Dictionary<string, int>();
    public string GetUid()
    {
        return Uid;
    }

    // 获取我账号服的服务器id
    public int GetSelfServerId()
    {
        return serverId;
    }

    public int GetCrossServerId()
    {
        return crossServerId;
    }

    public int GetCurServerId()
    {
        if (crossServerId >= 0)
        {
            return crossServerId;
        }

        return serverId;
    }
    public void SetWorldId(int worldId)
    {
        curWorldId = worldId;
    }
    public int GetWorldId()
    {
        return curWorldId;
    }

    public int GetSrcWorldId()
    {
        return scrWorldId;
    }
    public void OnCrossServerId(int targetServerId)
    {
        crossServerId = targetServerId;
    }
    public string GetName()
    {
        // string name = GameEntry.Lua.CallWithReturn<string>("LuaEntry.Player:GetName");
        string name = GameEntry.Lua.GetValue_String("LuaEntry.Player", "name");
        return name;
    }

    public bool IsInSelfServer()
    {
        if (crossServerId >= 0 && crossServerId != serverId)
        {
            return false;
        }
        return true;
    }
    
    // // 获取当前所在服的id
    // public int GetCurServerId()
    // {
    //     int curServerId = GameEntry.Lua.CallWithReturn<int>("LuaEntry.Player:GetCurServerId");
    //     return curServerId;
    // }

    public string GetAllianceId()
    {
        string allianceId = GameEntry.Lua.CallWithReturn<string>("LuaEntry.Player:GetAllianceUid");
        return allianceId;
    }

    public T GetValue<T>(string strKey)
    {
        // return GameEntry.Lua.CallWithReturn<T, string>("LuaEntry.Player:GetValue", strKey);
        return GameEntry.Lua.GetValue<T>("LuaEntry.Player", strKey);
    }
    
    public void SetValue<T>(string strKey, T value)
    {
        GameEntry.Lua.SetValue("LuaEntry.Player", strKey, value);
        // GameEntry.Lua.Call("LuaEntry.Player:SetValue", strKey, value);
    }

    public override void CSInit(ISFSObject obj)
    {
        if (obj.ContainsKey("user"))
        {
            UpdateUser(obj.GetSFSObject("user"));
        }
        
        
        if (obj.ContainsKey("crossWormObj"))
        {
            var dragon = obj.GetSFSObject("crossWormObj");
            if (dragon.ContainsKey("worldId"))
            {
                var worldId = dragon.TryGetInt("worldId");
                SetWorldId(worldId);
                GameEntry.GlobalData.serverType = dragon.TryGetInt("serverType");
            }
        }
        else if (obj.ContainsKey("dragonObj"))
        {
            var dragon = obj.GetSFSObject("dragonObj");
            if (dragon.ContainsKey("worldId"))
            {
                var worldId = dragon.TryGetInt("worldId");
                SetWorldId(worldId);
                if (worldId > 0)
                {
                    GameEntry.GlobalData.serverType = (int)ServerType.DRAGON_BATTLE_FIGHT_SERVER;
                }
            }
        }
    }
    
    public void UpdateUser(ISFSObject user)
    {
        Uid = user.GetUtfString("uid");
        serverId = user.GetInt("serverId");
        scrWorldId = user.TryGetInt("worldId");
        SetWorldId(scrWorldId);
        // 服务器类型
        GameEntry.GlobalData.serverType = user.GetInt("serverType");
        GameEntry.GlobalData.serverMax = user.GetInt("serverMax");
        
        if (user.ContainsKey("deviceBindTimes"))
        {
            GameEntry.GlobalData.nowGameCnt = user.TryGetInt("deviceBindTimes");
        }
    }

    public void SetFightAllianceId(string allianceId)
    {
        fightAllianceId = allianceId;
    }
    
    public string GetFightAllianceId()
    {
        return fightAllianceId;
    }

    public void SetFightServerList(LuaTable serverList)
    {
        serverDic.Clear();
        if (serverList.Length > 0)
        {
            serverList.ForEach<int,int>((_, data) =>
            {
                var sId = data;
                if (sId>0)
                {
                    serverDic.Add(sId);
                }
            });
        }
    }

    public bool GetIsInFightServerList(int sId)
    {
        return serverDic.Contains(sId);
    }

    public void SetAttackInfoList(LuaTable attackerList)
    {
        attackerDic.Clear();
        if (attackerList.Length > 0)
        {
            attackerList.ForEach<int,LuaTable>((_, data) =>
            {
                var uid = data.Get<string>("uid");
                var endTime = data.Get<long>("endTime");
                if (uid.IsNullOrEmpty() == false && endTime > 0)
                {
                    attackerDic.Add(uid,endTime);
                }
            });
        }
    }

    public bool GetIsInAttackDic(string uid)
    {
        if (attackerDic.ContainsKey(uid))
        {
            var serverTime = GameEntry.Timer.GetServerTime();
            var endTime = attackerDic[uid];
            if (endTime > serverTime)
            {
                return true;
            }
        }

        return false;
    }

    public void SetAllianceServerCamp(LuaTable campList)
    {
        allianceServerCamp.Clear();
        if (campList.Length > 0)
        {
            campList.ForEach<int,LuaTable>((_, data) =>
            {
                var uid = data.Get<string>("allianceId");
                var camp = data.Get<int>("camp");
                if (uid.IsNullOrEmpty() == false && camp > 0)
                {
                    allianceServerCamp.Add(uid,camp);
                }
            });
        }
    }

    public bool IsAllianceSelfCamp(string allianceId)
    {
        var selfAllianceId = GetAllianceId();
        if (selfAllianceId.IsNullOrEmpty() == false && allianceId.IsNullOrEmpty() == false)
        {
            if (allianceServerCamp.ContainsKey(selfAllianceId) && allianceServerCamp.ContainsKey(allianceId))
            {
                if (allianceServerCamp[selfAllianceId] == allianceServerCamp[allianceId])
                {
                    return true;
                }
            }
        }

        return false;
    }

    public int GetAllianceCampByAllianceId(string allianceId)
    {
        if (allianceId.IsNullOrEmpty())
        {
            return -1;
        }

        if (allianceServerCamp.ContainsKey(allianceId))
        {
            return allianceServerCamp[allianceId];
        }

        return -1;
    }
}
