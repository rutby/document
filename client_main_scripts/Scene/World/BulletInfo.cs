using System;
using System.Collections.Generic;
using System.Linq;
using GameFramework;
using Unity.Mathematics;
using UnityEngine;

public class BulletInfo
{
    public Transform Transform;
    public float3 StartPosition;
    private float3 _targetPosition;
    public double StartTime;
    private InstanceRequest _reqInst;
    private bool _isCreateFinish;
    private long _targetUuid;
    private int _targetType;
    private bool _isSetPosition;
    private string _hitEffectName = "";
    private Transform _targetTrans;
    private int _tileSize;
    public void CreateObject(string prefabName, string hitPrefabName, float3 startPos,Quaternion rotation, int tType, long tUuid,float3 targetPos)
    {
        _hitEffectName = hitPrefabName;
        StartPosition = startPos+ new float3(0, 1.2f, 0);
        _isCreateFinish = false;
        _isSetPosition = false;
        _targetUuid = tUuid;
        _targetType = tType;
        SetTargetPosition();
        _reqInst = GameEntry.Resource.InstantiateAsync(prefabName);
        _reqInst.completed += (result) =>
        {
            if (_reqInst.gameObject == null)
            {
                Log.Error("gameObject null");
                return;
            }
            _reqInst.gameObject.transform.position = StartPosition;
            _reqInst.gameObject.transform.rotation = rotation;
            Transform = _reqInst.gameObject.transform;
            var trailRenders = Transform.GetComponentsInChildren<TrailRenderer>();
            for(int i=0;i<trailRenders.Length;i++)
            {
                trailRenders[i].Clear();
            }
            StartTime = DateTime.Now.TimeOfDay.TotalMilliseconds;
            _isCreateFinish = true;
        };
        

    }

    public void CreateObjectV2(string prefabName, string hitPrefabName, float3 startPos, Quaternion rotation, int tType,
        int tileSize, Transform trans)
    {
        _hitEffectName = hitPrefabName;
        StartPosition = startPos+ new float3(0, 1.2f, 0);
        _isCreateFinish = false;
        _isSetPosition = false;
        _tileSize = tileSize;
        _targetType = tType;
        _targetTrans = trans;
        SetTargetPositionV2();
        _reqInst = GameEntry.Resource.InstantiateAsync(prefabName);
        _reqInst.completed += (result) =>
        {
            if (_reqInst.gameObject == null)
            {
                Log.Error("gameObject null");
                return;
            }
            _reqInst.gameObject.transform.position = StartPosition;
            _reqInst.gameObject.transform.rotation = rotation;
            Transform = _reqInst.gameObject.transform;
            var trailRenders = Transform.GetComponentsInChildren<TrailRenderer>();
            for(int i=0;i<trailRenders.Length;i++)
            {
                trailRenders[i].Clear();
            }
            StartTime = DateTime.Now.TimeOfDay.TotalMilliseconds;
            _isCreateFinish = true;
        };
    }

    public Quaternion GetRotation()
    {
        return Transform.rotation;
    }
    public float3 GetPosition()
    {
        return Transform.position;
    }
    public bool IsCreateFinish()
    {
        return _isCreateFinish;
    }

    public void Destroy()
    {
        if (_reqInst != null)
        {
            _reqInst.Destroy();
        }
    }

    public float3 GetTargetPosition()
    {
        SetTargetPosition();
        return _targetPosition;
    }
    public float3 GetTargetPositionV2()
    {
        SetTargetPositionV2();
        return _targetPosition;
    }
    public void SetTargetPosition()
    {
        var marchTargetType = (MarchTargetType)_targetType;
        if (marchTargetType == MarchTargetType.RALLY_FOR_BUILDING|| marchTargetType == MarchTargetType.ATTACK_BUILDING)
        {
            if (_isSetPosition == false)
            {
                if (SceneManager.World.GetObjectByUuid(_targetUuid) is WorldBuildObjectNew buildObject)
                {
                    _targetPosition = buildObject.GetPosition();
                    var pointInfo = SceneManager.World.GetPointInfoByUuid(_targetUuid);
                    if (pointInfo != null)
                    {
                        if (pointInfo.tileSize > 1)
                        {
                            _targetPosition+=new float3(-pointInfo.tileSize,0,-pointInfo.tileSize);
                        }
                    }
                }
                else
                {
                    var pointInfo = SceneManager.World.GetPointInfoByUuid(_targetUuid);
                    if (pointInfo != null)
                    {
                        _targetPosition = SceneManager.World.TileIndexToWorld(pointInfo.mainIndex);
                        if (pointInfo.tileSize > 1)
                        {
                            _targetPosition+=new float3(-pointInfo.tileSize,0,-pointInfo.tileSize);
                        }
                    }
                }
                _targetPosition += new float3(0, 1f, 0);
            }
        }
        else if (marchTargetType == MarchTargetType.RALLY_FOR_CITY|| marchTargetType == MarchTargetType.ATTACK_CITY|| marchTargetType == MarchTargetType.DIRECT_ATTACK_CITY)
        {
            if (_isSetPosition == false)
            {
                if (SceneManager.World.GetObjectByUuid(_targetUuid) is WorldBuildObjectNew buildObject)
                {
                    _targetPosition = buildObject.GetPosition();
                    var pointInfo = SceneManager.World.GetPointInfoByUuid(_targetUuid);
                    if (pointInfo != null)
                    {
                        if (pointInfo.tileSize > 1)
                        {
                            _targetPosition+=new float3(-pointInfo.tileSize,0,-pointInfo.tileSize);
                        }
                    }
                }
                else
                {
                    var pointInfo = SceneManager.World.GetPointInfoByUuid(_targetUuid);
                    if (pointInfo != null)
                    {
                        _targetPosition = SceneManager.World.TileIndexToWorld(pointInfo.mainIndex);
                        if (pointInfo.tileSize > 1)
                        {
                            _targetPosition+=new float3(-pointInfo.tileSize,0,-pointInfo.tileSize);
                        }
                        
                    }
                }
                _targetPosition += new float3(0, 1.5f, 0);
            }
        }
        else if (marchTargetType ==MarchTargetType.ATTACK_ALLIANCE_CITY ||
                 marchTargetType ==MarchTargetType.RALLY_FOR_ALLIANCE_CITY || marchTargetType == MarchTargetType.RALLY_THRONE)
        {
            if (_isSetPosition == false)
            {
                var pointInfo = SceneManager.World.GetPointInfoByUuid(_targetUuid);
                if (pointInfo != null)
                {
                    _targetPosition = SceneManager.World.TileIndexToWorld(pointInfo.mainIndex);
                    _targetPosition+=new float3(-6,0,-6);
                }
                _targetPosition += new float3(0, 2f, 0);
            }
            
        }
        else if (marchTargetType ==MarchTargetType.ATTACK_ALLIANCE_BUILDING || marchTargetType == MarchTargetType.ATTACK_ACT_ALLIANCE_MINE)
        {
            if (_isSetPosition == false)
            {
                var pointInfo = SceneManager.World.GetPointInfoByUuid(_targetUuid);
                if (pointInfo != null)
                {
                    _targetPosition = SceneManager.World.TileIndexToWorld(pointInfo.mainIndex);
                    _targetPosition+=new float3(-3,0,-3);
                }
                _targetPosition += new float3(0, 1f, 0);
            }
            
        }
        else if (marchTargetType ==MarchTargetType.TRIGGER_CROSS_THRONE_BUILDING)
        {
            if (_isSetPosition == false)
            {
                var pointInfo = SceneManager.World.GetPointInfoByUuid(_targetUuid);
                if (pointInfo != null)
                {
                    _targetPosition = SceneManager.World.TileIndexToWorld(pointInfo.mainIndex);
                    _targetPosition+=new float3(-3,0,-3);
                }
                _targetPosition += new float3(0, 1f, 0);
            }
            
        }
        else if (marchTargetType ==MarchTargetType.ATTACK_DRAGON_BUILDING || marchTargetType == MarchTargetType.TRIGGER_DRAGON_BUILDING)
        {
            if (_isSetPosition == false)
            {
                var pointInfo = SceneManager.World.GetPointInfoByUuid(_targetUuid);
                if (pointInfo != null)
                {
                    _targetPosition = SceneManager.World.TileIndexToWorld(pointInfo.mainIndex);
                    _targetPosition+=new float3(-2,0,-2);
                }
                _targetPosition += new float3(0, 1f, 0);
            }
            
        }
        else if (marchTargetType ==MarchTargetType.ATTACK_NPC_CITY ||marchTargetType ==MarchTargetType.DIRECT_ATTACK_NPC_CITY || marchTargetType == MarchTargetType.RALLY_NPC_CITY)
        {
            if (_isSetPosition == false)
            {
                var pointInfo = SceneManager.World.GetPointInfoByUuid(_targetUuid);
                if (pointInfo != null)
                {
                    _targetPosition = SceneManager.World.TileIndexToWorld(pointInfo.mainIndex);
                    _targetPosition+=new float3(-3,0,-3);
                }
                _targetPosition += new float3(0, 1f, 0);
            }
            
        }
        else if (marchTargetType == MarchTargetType.ATTACK_DESERT || marchTargetType == MarchTargetType.TRAIN_DESERT)
        {
            if (_isSetPosition == false)
            {
                _targetPosition =SceneManager.World.TileIndexToWorld(_targetUuid.ToInt());
            }
            
        }
        else if (marchTargetType == MarchTargetType.DIRECT_ATTACK_ACT_BOSS
                 || marchTargetType == MarchTargetType.ATTACK_ARMY_COLLECT
                 || marchTargetType == MarchTargetType.RALLY_FOR_BOSS || marchTargetType == MarchTargetType.ATTACK_ALLIANCE_BOSS)
        {
            if (_isSetPosition == false)
            {
                var troop = SceneManager.World.GetTroop(_targetUuid);
                if (troop != null)
                {
                    _targetPosition = troop.GetPosition();
                }
                else
                {
                    var march =  SceneManager.World.GetMarch(_targetUuid);
                    if (march != null)
                    {
                        _targetPosition =march.position;
                    }
                }
                _targetPosition += new float3(0, 5f, 0);
            }
            
        }
        else if (marchTargetType == MarchTargetType.ATTACK_MONSTER)
        {
            if (_isSetPosition == false)
            {
                var troop = SceneManager.World.GetTroop(_targetUuid);
                if (troop != null)
                {
                    _targetPosition = troop.GetPosition();
                }
                else
                {
                    var march =  SceneManager.World.GetMarch(_targetUuid);
                    if (march != null)
                    {
                        _targetPosition =march.position;
                    }
                }
                _targetPosition += new float3(0, 0, 0);
            }
        }
        else if (marchTargetType == MarchTargetType.ATTACK_ARMY)
        {
            var troop = SceneManager.World.GetTroop(_targetUuid);
            if (troop != null)
            {
                _targetPosition = troop.GetPosition();
            }
            else
            {
                var march =  SceneManager.World.GetMarch(_targetUuid);
                if (march != null)
                {
                    _targetPosition =march.position;
                }
            }
            _targetPosition += new float3(0, 0.5f, 0);
        }

        _isSetPosition = true;
    }
    
    public void SetTargetPositionV2()
    {
        var marchTargetType = (MarchTargetType)_targetType;
        if (marchTargetType == MarchTargetType.RALLY_FOR_BUILDING|| marchTargetType == MarchTargetType.ATTACK_BUILDING)
        {
            if (_isSetPosition == false)
            {
                if (_targetTrans != null)
                {
                    _targetPosition = _targetTrans.position;
                    if (_tileSize > 0)
                    {
                        _targetPosition+=new float3(-_tileSize,0,-_tileSize);
                    }
                }
                _targetPosition += new float3(0, 1f, 0);
            }
        }
        else if (marchTargetType == MarchTargetType.RALLY_FOR_CITY|| marchTargetType == MarchTargetType.ATTACK_CITY|| marchTargetType == MarchTargetType.DIRECT_ATTACK_CITY)
        {
            if (_isSetPosition == false)
            {
                if (_targetTrans != null)
                {
                    _targetPosition = _targetTrans.position;
                    if (_tileSize > 0)
                    {
                        _targetPosition+=new float3(-_tileSize,0,-_tileSize);
                    }
                }
                _targetPosition += new float3(0, 1.5f, 0);
            }
        }
        else if (marchTargetType ==MarchTargetType.ATTACK_ALLIANCE_CITY ||
                 marchTargetType ==MarchTargetType.RALLY_FOR_ALLIANCE_CITY || marchTargetType == MarchTargetType.RALLY_THRONE)
        {
            if (_isSetPosition == false)
            {
                if (_targetTrans != null)
                {
                    _targetPosition = _targetTrans.position;
                    _targetPosition+=new float3(-6,0,-6);
                }
                _targetPosition += new float3(0, 2f, 0);
            }
            
        }
        else if (marchTargetType ==MarchTargetType.ATTACK_ALLIANCE_BUILDING || marchTargetType == MarchTargetType.ATTACK_ACT_ALLIANCE_MINE)
        {
            if (_isSetPosition == false)
            {
                if (_targetTrans != null)
                {
                    _targetPosition = _targetTrans.position;
                    _targetPosition+=new float3(-3,0,-3);
                }
                _targetPosition += new float3(0, 1f, 0);
            }
            
        }
        else if (marchTargetType ==MarchTargetType.TRIGGER_CROSS_THRONE_BUILDING)
        {
            if (_isSetPosition == false)
            {
                if (_targetTrans != null)
                {
                    _targetPosition = _targetTrans.position;
                    _targetPosition+=new float3(-3,0,-3);
                }
                _targetPosition += new float3(0, 1f, 0);
            }
            
        }
        else if (marchTargetType ==MarchTargetType.ATTACK_DRAGON_BUILDING || marchTargetType == MarchTargetType.TRIGGER_DRAGON_BUILDING)
        {
            if (_isSetPosition == false)
            {
                if (_targetTrans != null)
                {
                    _targetPosition = _targetTrans.position;
                    _targetPosition+=new float3(-2,0,-2);
                }
                _targetPosition += new float3(0, 1f, 0);
            }
            
        }
        else if (marchTargetType ==MarchTargetType.ATTACK_NPC_CITY ||marchTargetType ==MarchTargetType.DIRECT_ATTACK_NPC_CITY || marchTargetType == MarchTargetType.RALLY_NPC_CITY)
        {
            if (_isSetPosition == false)
            {
                if (_targetTrans != null)
                {
                    _targetPosition = _targetTrans.position;
                    _targetPosition+=new float3(-3,0,-3);
                }
                _targetPosition += new float3(0, 1f, 0);
            }
            
        }
        else if (marchTargetType == MarchTargetType.ATTACK_DESERT || marchTargetType == MarchTargetType.TRAIN_DESERT)
        {
            if (_isSetPosition == false)
            {
                if (_targetTrans != null)
                {
                    _targetPosition = _targetTrans.position;
                }
            }
            
        }
        else if (marchTargetType == MarchTargetType.DIRECT_ATTACK_ACT_BOSS
                 || marchTargetType == MarchTargetType.ATTACK_ARMY_COLLECT
                 || marchTargetType == MarchTargetType.RALLY_FOR_BOSS || marchTargetType == MarchTargetType.ATTACK_ALLIANCE_BOSS)
        {
            if (_isSetPosition == false)
            {
                if (_targetTrans != null)
                {
                    _targetPosition = _targetTrans.position;
                }
                _targetPosition += new float3(0, 5f, 0);
            }
            
        }
        else if (marchTargetType == MarchTargetType.ATTACK_MONSTER)
        {
            if (_isSetPosition == false)
            {
                if (_targetTrans != null)
                {
                    _targetPosition = _targetTrans.position;
                }
                _targetPosition += new float3(0, 0, 0);
            }
        }
        else if (marchTargetType == MarchTargetType.ATTACK_ARMY)
        {
            if (_targetTrans != null)
            {
                _targetPosition = _targetTrans.position;
            }
            _targetPosition += new float3(0, 0.5f, 0);
        }

        _isSetPosition = true;
    }

    public float ArriveDistance()
    {
        var dis = 0.3f;
        var marchTargetType = (MarchTargetType)_targetType;
        if (marchTargetType ==MarchTargetType.ATTACK_ALLIANCE_CITY ||
                 marchTargetType ==MarchTargetType.RALLY_FOR_ALLIANCE_CITY||marchTargetType == MarchTargetType.RALLY_THRONE)
        {
            dis = 4f;
        }
        else if (marchTargetType == MarchTargetType.RALLY_FOR_CITY || marchTargetType == MarchTargetType.ATTACK_CITY ||
                  marchTargetType == MarchTargetType.DIRECT_ATTACK_CITY)
        {
            dis = 1f;
        }
        

        return dis;
    }
    
    public string GetHitPrefabName()
    {
        return _hitEffectName;
    }
}