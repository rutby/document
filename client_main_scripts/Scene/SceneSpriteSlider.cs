using System;
using UnityEngine;
public class SceneSpriteSlider : MonoBehaviour
{
    // 图片
    [SerializeField]
    private SpriteRenderer _renderer;
    [SerializeField]
    private Vector4 _bounds = new Vector4(0.5f, 0.5f, 27, 78);
    [SerializeField]
    private float _angle = 0.0f;
    [SerializeField]
    private Sprite sprite;
    
    private MaterialPropertyBlock _propertyBlock;

    private void Awake()
    {
        _propertyBlock = new MaterialPropertyBlock();
        _propertyBlock.SetFloat("_Angle", _angle);
        _propertyBlock.SetVector("_Bounds", _bounds);
        _propertyBlock.SetFloat("_Progress", 0);
        _propertyBlock.SetTexture("_MainTex", _renderer.sprite.texture);
        _renderer.SetPropertyBlock(_propertyBlock);
    }

    public void Init(long maxValue,long curValue)
    {
        var value = (curValue).ToFloat() / maxValue;
        if (value < 0)
        {
            value = 0;
        }

        if (value > 1)
        {
            value = 1;
        }

        if (_propertyBlock == null)
        {
            return;
        }
        _propertyBlock.SetFloat("_Progress", value);
        _propertyBlock.SetTexture("_MainTex", _renderer.sprite.texture);
        _renderer.SetPropertyBlock(_propertyBlock);
    }
    
    
}