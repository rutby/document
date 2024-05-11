using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GorgeEffect : MonoBehaviour
{
    private SimpleAnimation _animator;

    private void Awake()
    {
        _animator = transform.GetComponent<SimpleAnimation>();
        float rand = UnityEngine.Random.Range(0, 30) / 10.0f;
        _animator.enabled = false;
        GameEntry.Timer.RegisterTimer(rand, () =>
        {
            _animator.enabled = true;
        });
    }
}
