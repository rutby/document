using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BuildSelect : MonoBehaviour
{
    [SerializeField] private MeshRenderer[] _diMeshRenderer;
    [SerializeField] private MeshRenderer[] _arrowMeshRenderer;

    private bool _isOk;
    private MaterialPropertyBlock _diBlock;
    private static int _ColorSwitch = Shader.PropertyToID("_ColorSwitch");
    void Awake()
    {
        _diBlock = new MaterialPropertyBlock();
        _isOk = true;
        SetColor();
    }

    public void ChangeColor(bool isOk)
    {
        if (_isOk != isOk)
        {
            _isOk = isOk;
            SetColor();
        }
    }

    private void SetColor()
    {
        if (_isOk)
        {
            _diBlock.SetFloat(_ColorSwitch,0);
        }
        else
        {
            _diBlock.SetFloat(_ColorSwitch,1);
        }

        for (int i = 0; i < _diMeshRenderer.Length; ++i)
        {
            _diMeshRenderer[i].SetPropertyBlock(_diBlock);
        }
        for (int i = 0; i < _arrowMeshRenderer.Length; ++i)
        {
            _arrowMeshRenderer[i].SetPropertyBlock(_diBlock);
        }
    }
}
