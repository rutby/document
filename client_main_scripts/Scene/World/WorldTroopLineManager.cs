using System.Collections.Generic;
using UnityEngine;
#if false
public class WorldTroopLineManager : WorldManagerBase
{
    private static readonly Color MyTroopLineColor = new Color(0.68f, 0.98f, 0.1f, 1f);
    private static readonly Color AllianceTroopLineColor = new Color(0.06f, 0.54f, 0.98f,1f);
    private static readonly Color OtherTroopLineColor = new Color(1f, 1f, 1f,1f);// new Color(0.79f, 0.79f, 0.79f, 0.8f);
    private static readonly Color EnemyTroopLineColor =  new Color(0.95f,0.24f,0.24f,1f);
    private static readonly Color YellowTroopLineColor =  new Color(0.996f,0.913f,0.007f,1f);
    private class TroopLine
    {
        public long uuid;
        public InstanceRequest lineInst;
        public WorldTroopLine line;
        public InstanceRequest destInst;
        //public WorldTroopDestinationSignal dest;
        public void OnCreateMarchLine(WorldMarch march)
        {
            lineInst = GameEntry.Resource.InstantiateAsync(GameDefines.EntityAssets.TroopLine);
            lineInst.completed += delegate
            {
                lineInst.gameObject.transform.SetParent(SceneManager.World.DynamicObjNode);
                line = lineInst.gameObject.GetComponent<WorldTroopLine>();
                line.Clear();
                SetColor(march);
            };
        }

        public void SetColor(WorldMarch march)
        {
            if (line!=null)
            {
                line.SetColor(GetTroopLineColor(march));
            }
        }
        private Color GetTroopLineColor(WorldMarch march)
        {
            if (march.ownerUid == GameEntry.Data.Player.Uid)
            {
                return MyTroopLineColor;
            }
        
            string allianceId = GameEntry.Data.Player.GetAllianceId();
            if (!allianceId.IsNullOrEmpty() && march.allianceUid == allianceId)
            {
                return AllianceTroopLineColor;
            }

            if (SceneManager.World.IsTargetForMine(march))
            {
                return EnemyTroopLineColor;
            }

            if (march.srcServer != GameEntry.Data.Player.GetSelfServerId())
            {
                return EnemyTroopLineColor;
            }
            string fightAllianceId = GameEntry.Data.Player.GetFightAllianceId();
            if (fightAllianceId.IsNullOrEmpty()==false && fightAllianceId == march.allianceUid)
            {
                return EnemyTroopLineColor;;
            }

            if (GameEntry.Data.Player.GetIsInAttackDic(march.ownerUid) == true || GameEntry.Data.Player.GetIsInFightServerList(march.srcServer) == true )
            {
                return EnemyTroopLineColor;
            }
            if (GameEntry.GlobalData.serverType == (int)ServerType.EDEN_SERVER)
            {
                if (GameEntry.Data.Player.IsAllianceSelfCamp(march.allianceUid))
                {
                    return YellowTroopLineColor;
                }
                return EnemyTroopLineColor;
            }
            if (GameEntry.GlobalData.serverType == (int)ServerType.DRAGON_BATTLE_FIGHT_SERVER || GameEntry.GlobalData.serverType == (int)ServerType.CROSS_THRONE)
            {
                return EnemyTroopLineColor; 
            }
            return OtherTroopLineColor;
        }
    }

    private Dictionary<long, TroopLine> _troopLines = new Dictionary<long,TroopLine>();
    
    public WorldTroopLineManager(WorldScene scene) : base(scene)
    {
    }

    public override void Init()
    {
        base.Init();
    }

    public override void UnInit()
    {
        base.UnInit();

        foreach (var i in _troopLines)
        {
            i.Value.lineInst.Destroy();
        }
        _troopLines.Clear();
    }

    public void CreateTroopLine(WorldMarch march)
    {
        if (march.type == NewMarchType.MONSTER || march.type == NewMarchType.BOSS)
        {
            return;
        }

        if (_troopLines.TryGetValue(march.uuid, out var troopLine))
        {
            if (troopLine.line != null)
            {
                troopLine.line.Clear();
                troopLine.SetColor(march);
            }
        }
        else
        {
            troopLine = new TroopLine();
            troopLine.OnCreateMarchLine(march);
            // troopLine.lineInst = GameEntry.Resource.InstantiateAsync(GameDefines.EntityAssets.TroopLine);
            // troopLine.lineInst.completed += delegate
            // {
            //     troopLine.lineInst.gameObject.transform.SetParent(world.DynamicObjNode);
            //     troopLine.line = troopLine.lineInst.gameObject.GetComponent<WorldTroopLine>();
            //     troopLine.line.Clear();
            //     troopLine.SetColor(march);
            // };
            // if (march.ownerUid == GameEntry.Data.Player.Uid)
            // {
            //     troopLine.destInst = GameEntry.Resource.InstantiateAsync(GameDefines.EntityAssets.TroopDestinationSignal);
            //     troopLine.destInst.completed += delegate
            //     {
            //         troopLine.destInst.gameObject.transform.SetParent(world.DynamicObjNode);
            //         troopLine.dest = troopLine.destInst.gameObject.GetComponent<WorldTroopDestinationSignal>();
            //     };
            // }
            
            _troopLines.Add(march.uuid, troopLine);
        }
    }

    public void DestroyTroopLine(long marchUuid)
    {
        if (!_troopLines.TryGetValue(marchUuid, out var troopLine))
            return;

        if (troopLine.lineInst != null)
        {
            troopLine.lineInst.Destroy();
            troopLine.lineInst = null;
        }
        
        if (troopLine.destInst != null)
        {
            troopLine.destInst.Destroy();
            troopLine.destInst = null;
        }
        _troopLines.Remove(marchUuid);
    }

    public bool IsTroopLineCreate(long marchUuid)
    {
        return _troopLines.ContainsKey(marchUuid);
    }
    
    public void UpdateTroopLine(WorldMarch march, WorldTroopPathSegment[] path, int currPath, Vector3 currPos,int realTargetPos = 0,bool needRefresh=false, bool clear = false)
    {
        if (path == null || path.Length == 0)
            return;
        
        if (!_troopLines.TryGetValue(march.uuid, out var troopLine))
            return;

        if (clear)
        {
            if (troopLine.line != null)
            {
                troopLine.line.Clear();
            }
        }

        if (troopLine.line != null)
        {
            troopLine.line.SetMovePath(path, currPath, currPos, realTargetPos, needRefresh);
        }
        
        // if (troopLine.dest != null)
        // {
        //     Vector3 targetRealPos;
        //     if (realTargetPos > 0)
        //     {
        //         targetRealPos = world.TileIndexToWorld(realTargetPos);
        //     }
        //     else
        //     {
        //         targetRealPos = path[path.Length - 1].pos;
        //     }
        //     int tileSize = 1;
        //     var destinationType = world.GetDestinationType(march.uuid, march.targetUuid, 
        //         realTargetPos, march.target,false, ref targetRealPos, ref tileSize);
        //     troopLine.dest.SetDestinationForMarch(targetRealPos, destinationType, tileSize);
        // }
    }

    public void HideDestination(long uuid)
    {
        // if (!_troopLines.TryGetValue(uuid, out var troopLine))
        //     return;
        // if (troopLine.dest != null)
        // {
        //     troopLine.dest.HideDestination();
        // }
    }
    
    
}
#endif