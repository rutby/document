using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;
using Random = System.Random;


public class MonsterSandworm : MonoBehaviour
{
    public static class AnimName
    {
        public const string Show = "shachong_zuanchu";
        public const string Breathe = "shachong_huxi";
        public const string Idle = "shachong_daiji";
        public const string Exit = "shachong_zuanjin";
    }

    [SerializeField] private GPUSkinningAnimator _monsterAnim;
    [SerializeField] private SimpleAnimation _effectAnim;

    public static string[] TestAnimList =
    {
        AnimName.Show, AnimName.Idle, AnimName.Breathe, AnimName.Breathe, AnimName.Breathe,
        AnimName.Breathe, AnimName.Breathe, AnimName.Idle, AnimName.Breathe,
        AnimName.Breathe, AnimName.Breathe, AnimName.Exit
    };

    public static float UnderWaitTime = 4.0f;

    private int _curIndex = 0;
    private bool _isTimerDuring;
    private bool _isActive;
    void Awake()
    {
        _curIndex = 0;
        float rand = UnityEngine.Random.Range(10, 50) / 10.0f;
        _isTimerDuring = true;
        _isActive = true;
        GameEntry.Timer.RegisterTimer(rand, () =>
        {
            _isTimerDuring = false;
            CheckPlayAnim();
        });
    }

    private float Play(string animName)
    {
        var effAniName = animName + "_effect";
        if (_effectAnim.GetState(effAniName) != null)
        {
            UIUtils.PlayAnimationReturnTime(_effectAnim, effAniName);
        }
        _monsterAnim.Play(animName);
        return _monsterAnim.GetClipLength(animName);
    }
    
    private void CheckPlayAnim()
    {
        if (_isActive)
        {
            if (_curIndex >= TestAnimList.Length)
            {
                _isTimerDuring = true;
                GameEntry.Timer.RegisterTimer(UnderWaitTime, () =>
                {
                    _isTimerDuring = false;
                    _curIndex = 0;
                    CheckPlayAnim();
                });
            
            }
            else
            {
                var time = Play(TestAnimList[_curIndex]);
                if (time > 0)
                {
                    _isTimerDuring = true;
                    GameEntry.Timer.RegisterTimer(time, () =>
                    {
                        _isTimerDuring = false;
                        ++_curIndex;
                        CheckPlayAnim();
                    });
                }
            }
        }
    }

    private void OnDisable()
    {
        _isActive = false;
    }

    private void OnEnable()
    {
        _isActive = true;
        if (!_isTimerDuring)
        {
            CheckPlayAnim();
        }
    }
}
