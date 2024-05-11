using System;
using System.Collections.Generic;
using GameFramework;
using UnityEngine;

public class SceneLowFpsMonitor : MonoBehaviour
{
    private float _unscaledDeltaTime;
    private float _avgFps;
    private float _currentFps;
    private List<float> _fpsSamples = new List<float>();
    private List<float> _avgFpsSamples = new List<float>();

    [SerializeField]
    private int AvgFpsThreshold = 20;
    [SerializeField]
    private int FpsSamplesMaxCount = 200;
    [SerializeField]
    private float AverageSampleInterval = 10;
    [SerializeField]
    private int AverageSampleCount = 3;
    
    private float _avgSampleTime;
    private bool _startStats;

    public void StartStats()
    {
        _startStats = true;
    }

    private void Update()
    {
        if (!_startStats)
            return;
        
        _unscaledDeltaTime = Time.unscaledDeltaTime;
        
        // 计算平均帧率
        _avgFps = 0;
        _currentFps = 1.0f / _unscaledDeltaTime;
        
        if (_fpsSamples.Count >= FpsSamplesMaxCount)
        {
            _fpsSamples.RemoveAt(0);
        }
        _fpsSamples.Add(_currentFps);
        
        for (int i = 0; i < _fpsSamples.Count; i++)
        {
            _avgFps += _fpsSamples[i];
        }

        _avgFps /= _fpsSamples.Count;

        // 记录一段时间内的平均帧率
        _avgSampleTime += _unscaledDeltaTime;
        if (_avgSampleTime > AverageSampleInterval)
        {
            _avgSampleTime = 0;

            if (_avgFpsSamples.Count >= AverageSampleCount)
            {
                _avgFpsSamples.RemoveAt(0);
            }
            _avgFpsSamples.Add(_avgFps);
        }
        
        // 3次平均帧率都低于阈值时降效果
        if (_avgFpsSamples.Count >= AverageSampleCount)
        {
            bool lowFps = true;
            foreach (var i in _avgFpsSamples)
            {
                if (i > AvgFpsThreshold)
                {
                    lowFps = false;
                }
            }

            if (lowFps)
            {
                Log.Debug("SceneLowFpsMonitor low fps " + string.Join(",", _avgFpsSamples));
                GameEntry.Event?.Fire(EventId.LowFps);
                _startStats = false;
            }
        }
    }
}