using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using GameFramework;

public enum ScrollDir
{
    Horizontal,
    Vertical
}

public class ScrollRectCenter : MonoBehaviour, IEndDragHandler, IDragHandler, IBeginDragHandler
{
    public enum ScrollType
    {
        Normal, //滑动超出最后一个，变成最后一个
        ForGiftPack, //滑动超出最后一个，变成第一个
        ForHeroInfo,
        ForEditTroop,
        ForEditTrain,
    }


    public ScrollDir Dir = ScrollDir.Horizontal;

    /// <summary>
    /// 是否正在居中
    /// </summary>
    private bool _isCentering = false;

    /// <summary>
    /// 居中过程移动速度
    /// </summary>
    public float MoveToCenterSpeed = 10f;
    public delegate void OnCenterComplete(int index);
    public OnCenterComplete OnCenterCallBack;

    private ScrollRect _scrollView;

    private Transform _content;

    private List<float> _childrenPos = new List<float>();
    private List<Image> _childImages = new List<Image>();
    private float _targetPos;
    private float _tempTime;
    private bool _inited = false;
    /// <summary>
    /// 当前中心child索引
    /// </summary>
    private int _curCenterChildIndex = 0;
    private Vector3 _startPrefix = Vector3.zero;

    private ScrollType _type;//滚动类型

    private Vector3 _startPos;//训练专有

    /// <summary>
    /// 当前中心ChildItem
    /// </summary>
    public GameObject CurCenterChildItem
    {
        get
        {
            GameObject centerChild = null;
            if(_type == ScrollType.ForEditTrain)
            {
                if (_content != null && _curCenterChildIndex >= 0)
                {
                    if (_curCenterChildIndex < _content.childCount)
                    {
                        centerChild = _content.GetChild(_curCenterChildIndex == 0 ? 0 : _curCenterChildIndex - 1).gameObject;
                    }
                    else
                    {
                        centerChild = _content.GetChild(_content.childCount - 1).gameObject;
                    }
                }
            }
            else
            {
                if (_content != null && _curCenterChildIndex >= 0 && _curCenterChildIndex < _content.childCount)
                {
                    centerChild = _content.GetChild(_curCenterChildIndex).gameObject;
                }
            }
            return centerChild;
        }
    }

    public int CurCenterChildIndex
    {
        get { return _curCenterChildIndex; }
    }

    public void Init(ScrollType type)
	{
        _scrollView = GetComponent<ScrollRect>();
        if (_scrollView == null)
        {
            Log.Error("ScrollRect is null");
            return;
        }
        _type = type;
        _content = _scrollView.content;
	    _childrenPos.Clear();
        _childImages.Clear();
        if (_type == ScrollType.ForHeroInfo)
        {
            for (int i = 0; i < _content.childCount; ++i)
            {
                // ItemHeroImg itemHeroImg = _content.GetChild(i).GetComponent<ItemHeroImg>();
                // _childImages.Add(itemHeroImg.heroImg);
            }
        }else if (_type == ScrollType.ForEditTroop || _type == ScrollType.ForEditTrain)
        {
            for (int i = 0; i < _content.childCount; ++i)
            {
                _childImages.Add(_content.GetChild(i).GetComponentInChildren<Image>());
            }
        }

        LayoutGroup layoutGroup = null;
        layoutGroup = _content.GetComponent<LayoutGroup>();
        if (layoutGroup == null)
        {
            Log.Debug("LayoutGroup component is null");
        }
        //_scrollView.movementType = ScrollRect.MovementType.Unrestricted;
        float spacing = 0f;
        //根据dir计算坐标，Horizontal：存x，Vertical：存y
        switch (Dir)
        {
            case ScrollDir.Horizontal:
                if (layoutGroup is HorizontalLayoutGroup)
                {
                    spacing = (layoutGroup as HorizontalLayoutGroup).spacing;
                    float childPosX = 0;
                    if(_type == ScrollType.Normal || _type == ScrollType.ForHeroInfo || _type == ScrollType.ForGiftPack)
                    {
                        _childrenPos.Add(childPosX);
                        for (int i = 1; i < _content.childCount; i++)
                        {
                            childPosX -= GetChildItemWidth(i) * 0.5f + GetChildItemWidth(i - 1) * 0.5f + spacing;
                            _childrenPos.Add(childPosX);
                        }
                    }else if (_type == ScrollType.ForEditTroop)
                    {
                        childPosX = _scrollView.GetComponent<RectTransform>().rect.width * 0.5f - GetChildItemWidth(0) * 0.5f;
                        spacing = (layoutGroup as HorizontalLayoutGroup).spacing;
                        _childrenPos.Add(childPosX);
                        for (int i = 1; i < _content.childCount; i++)
                        {
                            childPosX -= GetChildItemWidth(i) * 0.5f + GetChildItemWidth(i - 1) * 0.5f + spacing;
                            _childrenPos.Add(childPosX);
                        }

                    }
                    else if (_type == ScrollType.ForEditTrain)
                    {
                        childPosX = _scrollView.GetComponent<RectTransform>().rect.width * 0.5f - GetChildItemWidth(0) * 0.5f;
                        spacing = (layoutGroup as HorizontalLayoutGroup).spacing;
                        _childrenPos.Add(childPosX);
                        for (int i = 0; i < _content.childCount + 1; i++)
                        {
                            if (i == _content.childCount)
                            {
                                // 最后一个
                                childPosX = _childrenPos[i];//- 150;
                            }
                            else if (i == 0)
                            {

                            }
                            else
                            {
                                childPosX -= (GetChildItemWidth(i) * 0.5f + GetChildItemWidth(i - 1) * 0.5f + spacing);
                            }

                            _childrenPos.Add(childPosX);
                        }
                    }
                }
                else if (layoutGroup is GridLayoutGroup)
                {
                    GridLayoutGroup grid = layoutGroup as GridLayoutGroup;
                    float childPosX = _scrollView.GetComponent<RectTransform>().rect.width * 0.5f - grid.cellSize.x * 0.5f;
                    _childrenPos.Add(childPosX);
                    for (int i = 0; i < _content.childCount - 1; i++)
                    {
                        childPosX -= grid.cellSize.x + grid.spacing.x;
                        _childrenPos.Add(childPosX);
                    }
                }
                else
                {
                    Log.Debug("Horizontal ScrollView is using VerticalLayoutGroup");
                }
                break;
            case ScrollDir.Vertical:
                if (layoutGroup is VerticalLayoutGroup)
                {
                    float childPosY = -_scrollView.GetComponent<RectTransform>().rect.height * 0.5f + GetChildItemHeight(0) * 0.5f;
                    spacing = (layoutGroup as VerticalLayoutGroup).spacing;
                    _childrenPos.Add(childPosY);
                    for (int i = 1; i < _content.childCount; i++)
                    {
                        childPosY += GetChildItemHeight(i) * 0.5f + GetChildItemHeight(i - 1) * 0.5f + spacing;
                        _childrenPos.Add(childPosY);
                    }
                }
                else if (layoutGroup is GridLayoutGroup)
                {
                    GridLayoutGroup grid = layoutGroup as GridLayoutGroup;
                    float childPosY = -_scrollView.GetComponent<RectTransform>().rect.height * 0.5f + grid.cellSize.y * 0.5f;
                    _childrenPos.Add(childPosY);
                    for (int i = 1; i < _content.childCount; i++)
                    {
                        childPosY += grid.cellSize.y + grid.spacing.y;
                        _childrenPos.Add(childPosY);
                    }
                }
                else
                {
                    Log.Debug("Vertical ScrollView is using HorizontalLayoutGroup");
                }
                break;
        }
	    _tempTime = 0;
	    _inited = true;
	}
    
    private float GetChildItemWidth(int index)
    {
        return (_content.GetChild(index) as RectTransform).sizeDelta.x;
    }

    private float GetChildItemHeight(int index)
    {
        return (_content.GetChild(index) as RectTransform).sizeDelta.y;
    }
	
	void Update () 
	{
        if (_isCentering && _inited)
        {
            Vector3 v = _startPrefix;
            _tempTime += MoveToCenterSpeed * Time.deltaTime;
            switch (Dir)
            {
                case ScrollDir.Horizontal:
                    v.x = Mathf.Lerp(_startPrefix.x, _targetPos, _tempTime);
                    _content.localPosition = v;
                    
                    break;
                case ScrollDir.Vertical:
                    v.y = Mathf.Lerp(_startPrefix.y, _targetPos, _tempTime);
                    _content.localPosition = v;
                    break;
            }
            if(_type == ScrollType.Normal || _type == ScrollType.ForHeroInfo || _type == ScrollType.ForGiftPack)
            {
                for (int i = _curCenterChildIndex - 1; i <= _curCenterChildIndex + 1; i++)
                {
                    if (i < 0 || i >= _childImages.Count)
                    {
                        continue;
                    }
                    //fixme列表两边模糊效果之后再看需求是否实现
                    //var c = _childImages[i].color;
                    //var dis = (_childrenPos[i] - _content.localPosition.x) / 100;
                    //if (dis == 0)
                    //{
                    //    dis = 1;
                    //}
                    //c.a = Mathf.Abs(1 / dis);
                    //_childImages[i].color = c;
                }
            }

            if (_tempTime >= 1)
            {
                _isCentering = false;
                if(OnCenterCallBack != null)
                {
                    OnCenterCallBack(_curCenterChildIndex);
                }
            }
        }
	}

    public void AsyncPos()
    {
        _content.localPosition = Vector3.zero;
    }

    public void OnDrag(PointerEventData eventData)
    {
        for (int i = _curCenterChildIndex - 1; i <= _curCenterChildIndex + 1; i++)
        {
            if (i < 0 || i >= _childImages.Count)
            {
                continue;
            }
            //fixme列表两边模糊效果之后再看需求是否实现
            //var c = _childImages[i].color;
            //var dis = (_childrenPos[i] - _content.localPosition.x) / 100;
            //if (dis == 0)
            //{
            //    dis = 1;
            //}
            //c.a = Mathf.Abs(1 / dis);
            //_childImages[i].color = c;
        }
    }

    public void OnEndDrag(PointerEventData eventData)
    {
        int oldIndex = _curCenterChildIndex;
        switch (Dir)
        {
            case ScrollDir.Horizontal:
                _targetPos = FindClosestChildPos(_content.localPosition.x, out _curCenterChildIndex);
                //感觉这里应该写在callbackl里面，如果有时间就改一下
                if(_type == ScrollType.ForEditTrain)
                {
                    if (oldIndex == _curCenterChildIndex)
                    {
                        //选中项并未变化。
                        var dir = _startPos.x - eventData.position.x;
                        if (Mathf.Abs(dir) > 30)
                        {
                            if (dir < 0)
                            {
                                _curCenterChildIndex -= 1;
                            }
                            else if (dir > 0)
                            {
                                _curCenterChildIndex += 1;
                            }

                            _targetPos = FindClosestChildPos(_curCenterChildIndex);

                        }
                    }
                }
                break;
            case ScrollDir.Vertical:
                _targetPos = FindClosestChildPos(_content.localPosition.y, out _curCenterChildIndex);
                break;
        }
        _isCentering = true;
        _startPrefix = _content.localPosition;

        if (_type == ScrollType.ForEditTrain)
        {
            
        }
    }

    public void OnBeginDrag(PointerEventData eventData)
    {
        _isCentering = false;
        //_curCenterChildIndex = -1;
        _tempTime = 0;
        _startPrefix = Vector3.zero;
        _startPos = eventData.position;
    }

    public void CenterOn(int index)
    {

        //_type != ScrollType.ForEditTrain &&
        if (index >= _childrenPos.Count)
        {
            index = _childrenPos.Count - 1;
        }

        if (index < 0)
        {
            index = 0;
        }

        Vector3 v;
        switch (Dir)
        {
            case ScrollDir.Horizontal:
                v = _content.localPosition;
                v.x = _childrenPos[index];
                _content.localPosition = v;
                break;
            case ScrollDir.Vertical:
                v = _content.localPosition;
                v.y = _childrenPos[index];
                _content.localPosition = v;
                break;
        }

        _curCenterChildIndex = index;
    }

    private float FindClosestChildPos(float currentPos, out int curCenterChildIndex)
    {
        if (currentPos - _childrenPos[_curCenterChildIndex] > 50)
        {
            if(_type == ScrollType.ForGiftPack)
            {
                curCenterChildIndex = _curCenterChildIndex <= 0 ? _childrenPos.Count - 1 : _curCenterChildIndex - 1;
            }
            else
            {
                curCenterChildIndex = _curCenterChildIndex <= 0 ? 0 : _curCenterChildIndex - 1;
            }
            return _childrenPos[curCenterChildIndex];
        }
        else if (currentPos - _childrenPos[_curCenterChildIndex] < -50)
        {
            if (_type == ScrollType.ForGiftPack)
            {
                curCenterChildIndex = _curCenterChildIndex + 1 >= _childrenPos.Count ? 0 : _curCenterChildIndex + 1;
            }
            else
            {
                curCenterChildIndex = _curCenterChildIndex + 1 >= _childrenPos.Count ? _childrenPos.Count - 1 : _curCenterChildIndex + 1;
            }
            return _childrenPos[curCenterChildIndex];
        }
        else
        {
            curCenterChildIndex = _curCenterChildIndex;
            return _childrenPos[curCenterChildIndex];
        }
    }

    private float FindClosestChildPos(int curCenterChildIndex)
    {
        return _childrenPos[curCenterChildIndex];
    }
}