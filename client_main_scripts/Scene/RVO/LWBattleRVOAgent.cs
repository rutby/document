using UnityEngine;
using Random = System.Random;
using Vector2 = RVO.Vector2;
using RVO;
using System;
using System.Diagnostics.Contracts;

public class LWBattleRVOAgent : MonoBehaviour
{
    public int sid;
    private Random m_random = new Random();
    public LWBattleRVOManager mgr;
    public float speed;
    public bool active = true;
    private RVO.Vector2 _targetPosition;
    private Transform trans;

    private void Awake()
    {
        trans = transform;
    }

    public void Update()
    {
        UnityEngine.Profiling.Profiler.BeginSample("RVO AgentUpdate");
        if (!Simulator.Instance.hasAgent(sid))
        {
            UnityEngine.Profiling.Profiler.EndSample();
            return;
        }
        if (!active)
        {
            Simulator.Instance.setAgentPrefVelocity(sid, new Vector2(0, 0));
            UnityEngine.Profiling.Profiler.EndSample();
            return;
        }
        
        if (sid >= 0)
        {
            Vector2 pos = Simulator.Instance.getAgentPosition(sid);
            Vector2 vel = Simulator.Instance.getAgentPrefVelocity(sid);
            
            if(float.IsNaN((pos.x())) || float.IsNaN((pos.y()) ))
            {
                // error
            }
            else
            {
                trans.position = new Vector3(pos.x(), trans.position.y, pos.y());
                if (Math.Abs(vel.x()) > 0.01f && Math.Abs(vel.y()) > 0.01f)
                    trans.forward = new Vector3(vel.x(), 0, vel.y()).normalized;
            }
        }

        Vector2 goalVector = _targetPosition - Simulator.Instance.getAgentPosition(sid);
        if (RVOMath.absSq(goalVector) > 1.0f)
        {
            goalVector = RVOMath.normalize(goalVector);
        }

        goalVector = speed * goalVector;
        
        Simulator.Instance.setAgentPrefVelocity(sid, goalVector);

        /* Perturb a little to avoid deadlocks due to perfect symmetry. */
        float angle = (float) m_random.NextDouble()*2.0f*(float) Math.PI;
        float dist = (float) m_random.NextDouble()*0.0001f;

        Simulator.Instance.setAgentPrefVelocity(sid, Simulator.Instance.getAgentPrefVelocity(sid) +
                                                     dist*
                                                     new Vector2((float) Math.Cos(angle), (float) Math.Sin(angle)));
        UnityEngine.Profiling.Profiler.EndSample();
    }

    public void SetActive(bool active)
    {
        this.active = active;
    }
    
    private void OnDestroy()
    {
        mgr.DeleteAgent(sid);
        mgr = null;
    }

    public void SetTargetPosition(float x,float z)
    {
        this.active = true;
        _targetPosition.x_ = x;
        _targetPosition.y_ = z;
    }
    
    public void SetCurPosition(float x,float z)
    {
        Simulator.Instance.setAgentPosition(sid,new Vector2(x,z));
    }
    

    
}