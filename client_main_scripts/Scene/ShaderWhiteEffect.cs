﻿using UnityEngine;
//闪白特效
public class ShaderWhiteEffect : MonoBehaviour
{
    public static float ShakeWhiteEffectChangeTime = 0.1f;//闪白过度时间
    public static float ShakeWhiteEffectStayTime = 0.05f;//闪白停留时间
    public static float ShakeWhiteEffectMinValue = 0f;//闪白最小值
    public static float ShakeWhiteEffectMaxValue = 1f;//闪白最大值
    
    private int _toggleFlashId = 0;
    private MaterialPropertyBlock _propertyBlock;
    private Renderer[] _renderers;
    private int _length = 0;
    private float _time;
    private bool _play;
    private float _addTime;
    private float _desTime;
    private float _allTime;
    private float _changeValue = ShakeWhiteEffectMaxValue - ShakeWhiteEffectMinValue;

    private void Start()
    {
        
        _renderers = gameObject.GetComponentsInChildren<Renderer>(true);
        if (_renderers != null)
        {
            _length = _renderers.Length;
        }
    }

    //闪白特效
    public void PlayEffect()
    {
        if (_toggleFlashId == 0)
        {
            _toggleFlashId = Shader.PropertyToID( "_ToggleFlash");
        }

        if (_propertyBlock == null)
        {
            _propertyBlock = new MaterialPropertyBlock();
        }
        _propertyBlock.SetFloat(_toggleFlashId, ShakeWhiteEffectMinValue);
        _time = 0;
        _play = true;
        _addTime = ShakeWhiteEffectChangeTime;
        _desTime = _addTime + ShakeWhiteEffectStayTime;
        _allTime = _desTime + ShakeWhiteEffectChangeTime;
    }

    private void Update()
    {
        if (_play)
        {
            _time += Time.deltaTime;
            if (_time <= _addTime)
            {
                _propertyBlock.SetFloat(_toggleFlashId, ShakeWhiteEffectMinValue + (_time / ShakeWhiteEffectChangeTime) *  _changeValue);
                ChangeEffect();
            } 
            else if (_time >= _allTime)
            {
                _play = false;
                _propertyBlock.SetFloat(_toggleFlashId, ShakeWhiteEffectMinValue);
                ChangeEffect();
            }
            else if(_time >= _desTime)
            {
                _propertyBlock.SetFloat(_toggleFlashId, ShakeWhiteEffectMinValue + (1 - (_time - _desTime) / ShakeWhiteEffectChangeTime) * _changeValue);
                ChangeEffect();
            }
        }
    }

    private void ChangeEffect()
    {
        if (_length > 0)
        {
            for (int i = 0; i < _length; ++i)
            {
                _renderers[i].SetPropertyBlock(_propertyBlock);
            }
        }
    }
}