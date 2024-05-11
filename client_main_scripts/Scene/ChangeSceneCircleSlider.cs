using System;
using UnityEngine;

public class ChangeSceneCircleSlider : MonoBehaviour
{
    // 图片
    [SerializeField]
    private SpriteRenderer _renderer;
    [SerializeField]
    private Vector4 _bounds = new Vector4(-1, -1, 1, 1);
    [SerializeField]
    private float _angle = 90.0f;
    [SerializeField]
    private Sprite sprite;

    private long _startTime;
    private long _endTime;
    private MaterialPropertyBlock _propertyBlock;
    public int _waitRefresh = 20;//根据时间长短改变刷新频率
    private int _waitCount = 0;
    private float _maxTime = 0;

    private void Awake()
    {
        _propertyBlock = new MaterialPropertyBlock();
        _propertyBlock.SetFloat("_Angle", _angle);
        _propertyBlock.SetFloat("_Progress", 0);
        _renderer.SetPropertyBlock(_propertyBlock);
    }

    public void Init(long startTime,long endTime)
    {
        _startTime = startTime;
        _endTime = endTime;
        _waitCount = 0;
        _maxTime = (_endTime - _startTime).ToFloat();
        _waitRefresh = GetRefreshDuring();
        RefreshValue();
    }

    private void Update()
    {
        _waitCount += 1;
        if (_waitCount > _waitRefresh)
        {
            _waitCount = 0;
            RefreshValue();
        }
    }

    private void RefreshValue()
    {
        var curTime = GameEntry.Timer.GetServerTime();
        if (_endTime > 0 && _endTime > curTime)
        {
            var value = 1 - (_endTime - curTime).ToFloat() / _maxTime;
            if (value < 0)
            {
                value = 0;
            }
            _propertyBlock.SetFloat("_Progress", value);
            _renderer.SetPropertyBlock(_propertyBlock);
        }
    }

    private int GetRefreshDuring()
    {
        if (_maxTime < 60000)
        {
            return 0;
        }
        else if (_maxTime < 300000)
        {
            return 10;
        }
        else if (_maxTime < 600000)
        {
            return 30;
        }
        else
        {
            return 60;
        }
        
        return 20;
    }
}