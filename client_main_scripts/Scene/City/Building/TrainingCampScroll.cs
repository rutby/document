using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using GameFramework;


public class TrainingCampScroll : MonoBehaviour, IEndDragHandler, IDragHandler, IBeginDragHandler
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
	private bool _onDray = false;
	private bool _playMove = false;

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
	private float _startTime;
	/// <summary>
	/// 当前中心child索引
	/// </summary>
	private int _curCenterChildIndex = 0;
	private Vector3 _startPos;//训练专有
	private Bounds m_ContentBounds;


	/// <summary>
	/// 当前中心ChildItem
	/// </summary>
	public GameObject CurCenterChildItem
	{
		get
		{
			GameObject centerChild = null;
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
			return centerChild;
		}
	}

	public int CurCenterChildIndex
	{
		get { return _curCenterChildIndex; }
	}

	Vector2 center;
	public void Start()
	{
		//center = _scrollView.viewport.rect.center;
		//Debug.Log("_scrollView.viewport.rect " + center);
		//Debug.Log("_scrollView.viewport width " + _scrollView.viewport.rect.width);
		//RectTransform rectTF = _scrollView.GetComponent<RectTransform>();
		//Debug.Log("_scrollView.RectTransform anchoredPosition: " + rectTF.anchoredPosition);
		 
		//RectTransform rectTFviewport = _scrollView.viewport.GetComponent<RectTransform>();
		//Debug.Log("rectTFviewport : " + rectTFviewport.anchoredPosition);
	}

	public void Init()
	{

		_scrollView = GetComponent<ScrollRect>();
		if (_scrollView == null)
		{
            Log.Error("ScrollRect is null");
			return;
		}
	
		_content = _scrollView.content;
		_childrenPos.Clear();
		_childImages.Clear();


		LayoutGroup layoutGroup = null;
		layoutGroup = _content.GetComponent<LayoutGroup>();
		if (layoutGroup == null)
		{
            Log.Error("LayoutGroup component is null");
		}
		_scrollView.movementType = ScrollRect.MovementType.Unrestricted;

        Log.Debug("width : " + GetChildItemWidth(0)* _content.childCount);

		float spacing = 0f;
		//根据dir计算坐标，Horizontal：存x，Vertical：存y
		switch (Dir)
		{
			case ScrollDir.Horizontal:
				if (layoutGroup is HorizontalLayoutGroup)
				{
			
					float width = GetChildItemWidth(0);
					//_childrenPos.Add(childPosX);
					for (int i = 0; i < _content.childCount ; i++)
					{
						_childrenPos.Add( -width * (i + 0.5f));
					}

					for (int i = 0; i < _childrenPos.Count; i++)
					{
						Log.Debug("child x:" + _childrenPos[i]);
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
                    Log.Error("Horizontal ScrollView is using VerticalLayoutGroup");
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


		//GoToItem(_curCenterChildIndex);
	}

	private float GetChildItemWidth(int index)
	{
		return (_content.GetChild(index) as RectTransform).sizeDelta.x;
	}

	private float GetChildItemHeight(int index)
	{
		return (_content.GetChild(index) as RectTransform).sizeDelta.y;
	}

	bool m_isMoveStop = true;

	void OnScrollMoveStop()
	{
		if (!m_isMoveStop)
			m_isMoveStop = true;
		//Debug.Log("OnScrollMoveStop");

		SetPageIndex(FindClosestChildIndex());
		_startTime = 0;
		_startPos = _scrollView.content.anchoredPosition;
		_targetPos = FindClosestChildPos(_curCenterChildIndex);
		_playMove = true;
	}

	void Update()
	{
		//Debug.Log(_scrollView.velocity);

		ClampBounds();
		if (_scrollView)
		{
			if (!m_isMoveStop)
			{
				if (_scrollView.velocity == Vector2.zero)
				{
					OnScrollMoveStop();
				}
				else
				{
					int _CurItmeIndex = FindClosestChildIndex();
					if (_CurItmeIndex == _curCenterChildIndex)
					{
						return;
					}
					SetPageIndex(_CurItmeIndex);
					UpdateSelected();
				}
			}
		}
	}


	private void LateUpdate()
	{
		//ClampBounds();
		if (m_isMoveStop)
		{
			if (_playMove && !_onDray)
			{
				_startTime += Time.deltaTime * 5f;
				if (Vector2.Distance(_scrollView.content.anchoredPosition, _targetPos) < 0.02f)
				{
					SetAnchoredPosition(_targetPos);
					_playMove = false;
					OnMoveDone();
					return;
				}
				Vector2 cur = Vector2.Lerp(_startPos, _targetPos, _startTime);
				SetAnchoredPosition(cur);

			}
		}
	}

	private void UpdateSelected()
	{
		
	}

	public void OnBeginDrag(PointerEventData eventData)
	{
		_onDray = true;

	}

	public void OnDrag(PointerEventData eventData)
	{
		int _CurItmeIndex = FindClosestChildIndex();
		if (_CurItmeIndex == _curCenterChildIndex)
		{
			return;
		}
		SetPageIndex(_CurItmeIndex);
		UpdateSelected();
	}

	public void OnEndDrag(PointerEventData eventData)
	{
		m_isMoveStop = false;
		_playMove = false;
		_onDray = false;
		int oldIndex = _curCenterChildIndex;
		switch (Dir)
		{
			case ScrollDir.Horizontal:

				break;
			case ScrollDir.Vertical:

				break;
		}

	}


	public void CenterOn(int index)
	{

		if (m_isMoveStop)
		{
			_playMove = false;
		}
		else
		{
			_scrollView.StopMovement();
		}

		//if (index == _curCenterChildIndex)
		//{
		//	return;
		//}

		GoToItem(index);
	}

	private void OnMoveDone()
	{
		//Debug.Log("OnMoveDone");
		//UpdateSelected();
	}

	private int FindClosestChildIndex()
	{
		float posX = _scrollView.content.anchoredPosition.x; //当前的位置
														   //Debug.Log("posX " + posX);
		//posX += ((posX - startDragHorizontal) * sensitivity); //当前的位置加上增量
		//posX = posX < 1 ? posX : 1;
		//posX = posX > 0 ? posX : 0;
		int index = 0;
		float offset = Mathf.Abs(_childrenPos[index] - posX); //第一页的偏移
														 // Debug.Log("offset " + offset);

		for (int i = 1; i < _childrenPos.Count; i++)
		{
			float temp = Mathf.Abs(_childrenPos[i] - posX);
			//Debug.Log("temp " + temp);
			//Debug.Log("i " + i);
			if (temp < offset)
			{

				index = i;
				offset = temp;
				//Debug.Log("index " + index);
			}

		}
		//Debug.Log(index);
		return index;
	}


	private Vector2 _targetPos;


	private Vector2 FindClosestChildPos(int curCenterChildIndex)
	{
		return new Vector2(_childrenPos[curCenterChildIndex],0); 
	}

	public void ClampBounds()
	{
        if (_scrollView != null)
        {
            Vector2 pos = _scrollView.content.anchoredPosition;

            if (pos.x > _childrenPos[0])
            {
                _scrollView.StopMovement();
                _scrollView.content.anchoredPosition = new Vector2(_childrenPos[0], 0);
            }


            if (pos.x < _childrenPos[_childrenPos.Count - 1])
            {
                _scrollView.StopMovement();
                _scrollView.content.anchoredPosition = new Vector2(_childrenPos[_childrenPos.Count - 1], 0);
            }
        }
	}


	public void AotuGotoItem(int index) 
	{
		if (_playMove)
		{
			return;
		}
		_startTime = 0;
		_startPos = _scrollView.content.anchoredPosition;
		SetPageIndex(index);
		_targetPos = FindClosestChildPos(index);
		_playMove = true;
	}

	public void GoToItem(int index) 
	{
		float x = _childrenPos[index];
		Vector2 pos = new Vector2(x, 0);
		SetAnchoredPosition(pos);
		SetPageIndex(index);
 	}

	private void SetPageIndex(int index)
	{
		_curCenterChildIndex = index;
	}

	private void SetAnchoredPosition(Vector2 pos) 
	{
		_scrollView.content.anchoredPosition = pos;
	}
}