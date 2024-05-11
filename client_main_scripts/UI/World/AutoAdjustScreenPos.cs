using UnityEngine;

public class AutoAdjustScreenPos : MonoBehaviour
{
    private Vector3 _worldPos;
    private Vector3 _screenPos;
    private Transform _obj;
    private Vector3 _deltaPos;
    private Transform tran;
    
    void Awake()
    {
        _screenPos = Vector3.zero;
        _obj = null;
        tran = transform;
    }

    public void Init(Vector3 pos)
    {
        _worldPos = pos;
    }
    
    public void Init(Transform obj,Vector3 deltaPos)
    {
        _obj = obj;
        _deltaPos = deltaPos;
    }

    private void RefreshPos()
    {
        if (_obj != null)
        {
            _worldPos = _obj.position + _deltaPos;
        }
        var screen = SceneManager.World.WorldToScreenPoint(_worldPos);
        if (screen != _screenPos)
        {
            _screenPos = screen;
            tran.position = _screenPos;
        }

    }

    private void OnEnable()
    {
        SceneManager.World.AfterUpdate += RefreshPos;
    }

    private void OnDisable()
    {
        if (SceneManager.World != null)
        {
            SceneManager.World.AfterUpdate -= RefreshPos;
        }
    }
}
