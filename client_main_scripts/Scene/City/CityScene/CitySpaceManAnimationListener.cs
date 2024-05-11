using System;
using UnityEngine;
using System.Collections.Generic;

public class CitySpaceManAnimationListener : MonoBehaviour
{


    public Action animation_playBegin { get; set; }
    public Action animation_attackBegin { get; set; }
    public Action animation_attackDone { get; set; }
    public Action animation_playEnd { get; set; }
    //插旗动画
    public Action animation_placeFlag { get; set; }

    public Action animation_walkLeft { get; set; }
    public Action animation_walkRight { get; set; }
    public Action animation_showTrail { get; set; }
    private class StepInfo
    {
        public Vector3 pos;
        public bool isLeft;

    }
    private float startTick = 0;
    private List<StepInfo> stepList = new List<StepInfo>();

    public void OnAnimationEvent_PlayBegin()
    {
        //Debug.Log($"[animation] OnAnimationEvent_PlayBegin");
        animation_playBegin?.Invoke();
    }

    public void OnAnimationEvent_AttackBegin()
    {
        //Debug.Log($"[animation] OnAnimationEvent_AttackBegin");
        animation_attackBegin?.Invoke();
    }

    public void OnAnimationEvent_AttackDone()
    {
        //Debug.Log($"[animation] OnAnimationEvent_AttackEnd");
        animation_attackDone?.Invoke();
    }
    
    public void OnAnimationEvent_PlayEnd()
    {
        //Debug.Log(">>TestFunc");
        animation_playEnd?.Invoke();
    }

    public void OnAnimationEvent_PlaceFlag()
    {
        //Debug.Log("OnAnimationEvent_PlaceFlag");
        animation_placeFlag?.Invoke();
    }

    public void OnWalkLeft()
    {
        animation_walkLeft?.Invoke();
    }
    public void OnWalkRight()
    {
        animation_walkRight?.Invoke();


    }
    public void OnAnimationEvent_ShowTrail()
    {
        animation_showTrail?.Invoke();
    }
      
    
    
}