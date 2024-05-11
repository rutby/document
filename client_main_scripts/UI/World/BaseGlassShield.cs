using System;
using System.Collections;
using System.Collections.Generic;
using GameFramework;
using UnityEngine;

public class BaseGlassShield : MonoBehaviour
{
    [SerializeField] private Material _material;
    enum State
    {
        Normal,
        Show,
        Hide,
        Hit,
    }
    
    public static float GlassShieldShowTime = 1.0f;
    public static float GlassShieldHideTime = 1.0f;
    public static float GlassShieldHitShowDuringTime = 3.0f;
    public static float GlassShieldShowMaxValue = 1.2f;
    public static float GlassShieldHideMaxValue = 1.2f;
    public static float GlassShieldHitTime = 1.0f;
    public static float GlassShieldHitMaxValue = 3f;
    public static float GlassShieldHitMinValue = -3f;

    private State _state;
    private float _time;
    void Awake()
    {
        _state = State.Normal;
    }

    public void Hit()
    {
        _time = 0;
        _state = State.Show;
        _material.SetFloat("_Dissolve_Show",0);
        _material.SetFloat("_Dissolve_Delete",GlassShieldHideMaxValue);
        
        GameEntry.Timer.RegisterTimer(GlassShieldHitShowDuringTime, () =>
        {
            _time = 0;
            _state = State.Hide;
        });
        
    }
    
     private void Update()
     {
        if (_state == State.Normal)
            return;

        _time += Time.deltaTime;
        switch (_state)
        {
            case State.Show:
            {
                if (_time < GlassShieldShowTime)
                {
                    _material.SetFloat("_Dissolve_Show",_time / GlassShieldShowTime * GlassShieldShowMaxValue);
                }
                else
                {
                    _material.SetFloat("_Dissolve_Show",GlassShieldShowMaxValue);
                    _state = State.Normal;
                    _time = 0;
                }
            }
                break;
            case State.Hide:
            {
                if (_time < GlassShieldHideTime)
                {
                    _material.SetFloat("_Dissolve_Delete",GlassShieldHideMaxValue - _time / GlassShieldHideTime * GlassShieldHideMaxValue);
                }
                else
                {
                    _material.SetFloat("_Dissolve_Delete",0);
                    _state = State.Normal;
                    _time = 0;
                    gameObject.SetActive(false);
                }
            }
                break;
            case State.Hit:
            {
                if (_time < GlassShieldHitTime)
                {
                    _material.SetFloat("_kuosan_Speed",GlassShieldHitMaxValue - _time / GlassShieldHideTime * (GlassShieldHitMaxValue - GlassShieldHitMinValue));
                }
                else
                {
                    _material.SetFloat("_kuosan_Speed",GlassShieldHitMinValue);
                    _state = State.Normal;
                    _time = 0;
                }
            }
                break;
            
        }
     }

     private void OnTriggerEnter(Collider other)
     {
         //播放动画
         var pos = other.transform.position;
         _material.SetVector("_World_Position",pos);
         _time = 0;
         _state = State.Hit;
     }
}
