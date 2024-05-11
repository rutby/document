using System.Collections.Generic;
using System.IO;
using RVO;
using UnityEngine;

public class LWBattleRVOManager
{
    private int _configCount = 0;
    private int _finishConfigCount = 0;
    
    public void InitLW(float timeStep,float neighborDist,int maxNeighbors,float timeHorizon,float timeHorizonObst,float radius,float maxSpeed)
    {
        Simulator.Instance.Clear();
        Simulator.Instance.setAgentDefaults(neighborDist, maxNeighbors, timeHorizon, timeHorizonObst, radius, maxSpeed, new RVO.Vector2(0.0f, 0.0f));
        _configCount = 0;
        _finishConfigCount = 0;
    }

    public void Append(string configPath,float offset)
    {
        _configCount++;
        var req = GameEntry.Resource.LoadAssetAsync(configPath, typeof(TextAsset));
        req.completed += delegate
        {
            var textAsset = req.asset as TextAsset;
            var data = textAsset.bytes;
            using (var reader = new BinaryReader(new MemoryStream(data)))
            {
                int count = reader.ReadInt32();
                for (int i = 0; i < count; i++)
                {
                    IList<RVO.Vector2> obstacle = new List<RVO.Vector2>();
                    obstacle.Add(new RVO.Vector2(reader.ReadSingle(),reader.ReadSingle() + offset));
                    obstacle.Add(new RVO.Vector2(reader.ReadSingle(),reader.ReadSingle() + offset));
                    obstacle.Add(new RVO.Vector2(reader.ReadSingle(),reader.ReadSingle() + offset));
                    obstacle.Add(new RVO.Vector2(reader.ReadSingle(),reader.ReadSingle() + offset));
                    Simulator.Instance.addObstacle(obstacle);
                }
            }

            _finishConfigCount++;
            if(_finishConfigCount == _configCount)
            {
                Simulator.Instance.processObstacles();
            }
        };
    }

    public void Destory()
    {
        Simulator.Instance.Clear();
    }

    private RVO.Vector2 _targetPosition;
    public RVO.Vector2 targetPosition => _targetPosition;
    public void SyncTargetPosition(float x,float z)
    {
        _targetPosition.x_ = x;
        _targetPosition.y_ = z;
    }
    
    public void Update(float x,float z)
    {
        Simulator.Instance.setTimeStep(Time.deltaTime);
        Simulator.Instance.doStep();
        SyncTargetPosition(x, z);
    }

    public int AddAgent(Vector3 position,GameObject gameObject,float speed,float radius)
    {
        RVO.Vector2 v;
        v.x_ = position.x;
        v.y_ = position.z;
        int sid = Simulator.Instance.addAgent(v);

        var agent = gameObject.GetComponent<LWBattleRVOAgent>();
        if (agent == null)
        {
            agent = gameObject.AddComponent<LWBattleRVOAgent>();
        }

        agent.sid = sid;
        agent.mgr = this;
        agent.speed = speed;
        
        Simulator.Instance.setAgentRadius(sid,radius);
        Simulator.Instance.setAgentMaxSpeed(sid,speed * 2);
        return sid;
    }

    public void DeleteAgent(int sid)
    {
        Simulator.Instance.delAgent(sid);
    }
}