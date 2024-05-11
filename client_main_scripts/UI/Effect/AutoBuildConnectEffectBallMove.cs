using System.Collections.Generic;
using UnityEngine;

public class AutoBuildConnectEffectBallMove : MonoBehaviour
{
    private List<Vector3> _list;
    private float _time = 0;
    public static Vector3 HeightDelta = new Vector3(0, 0.25f, 0);
    private int _useIndex;
    private Vector3 _startPos;
    private Vector3 _endPos;
    private bool _isMove = false;
    private float _movePerTime;

    public void Init(List<Vector2Int> list,float movePerTime,int startIndex = 0)
    {
        _time = 0;
        _useIndex = startIndex;
        _list = new List<Vector3>();
        _movePerTime = movePerTime;
        if (list != null && list.Count > 0)
        {
            for (int i = 0; i < list.Count; ++i)
            {
                _list.Add(SceneManager.World.TileToWorld(list[i]) + HeightDelta);
                _isMove = true;
            }
        }
    }

    private void Update()
    {
        if (_isMove)
        {
            _time += Time.deltaTime;
            if (_time > _movePerTime)
            {
                _time = 0;
                if (_useIndex + 1 >= _list.Count - 1)
                {
                    _isMove = false;
                }
                else
                {
                    ++_useIndex;
                }
            }

            transform.position = Vector3.Lerp(_list[_useIndex], _list[_useIndex + 1], _time / _movePerTime);
        }
    }
}
