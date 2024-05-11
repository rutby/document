using UnityEngine;
using System.Collections;
using UnityEngine.UI;
using System.Collections.Generic;
using UnityEngine.EventSystems;
using System;
using GameFramework;

public class PageView : MonoBehaviour, IBeginDragHandler, IEndDragHandler ,IDragHandler ,IInitializePotentialDragHandler
{

	public Action OnPageMoveBegin;
	public Action<GameObject> OnPageMoveDone;
	public Action<int> OnPageChanged;

	private ScrollRect rect;                        //滑动组件  
    private float targethorizontal = 0;             //滑动的起始坐标  
    private bool isDrag = false;                    //是否拖拽结束  
    private List<float> posList = new List<float>();            //求出每页的临界角，页索引从0开始  
	private List<Vector2> itemPoslist = new List<Vector2>();
	private CircularArry<Vector2> inputList = new CircularArry<Vector2>();
	private bool stopMove = true;
      //滑动速度 
    public float smooting = 4;      //滑动速度  
	private float dragSmooting = 0;
	public float dragSmootingMax = 4;
	public float sensitivity = 0;
    private float startTime;

    private float startDragHorizontal;
	private float dragTime = 0;
	private float screenValue = Screen.width * 0.02f;
	public readonly List<GameObject> PageChilds = new List<GameObject>();

	private int currentPageIndex = -1;
	public int CurrentPageIndex
	{
		get
		{
			return currentPageIndex;
		}
	}

	[SerializeField]
	private RectTransform content;
	public RectTransform Content
	{
		private get
		{
			return content;
		}

		set
		{
			content = value;
		}
	}

	void Start()
    {
		//PageChilds.Clear();
		//rect = transform.GetComponent<ScrollRect>();
		//     var _rectWidth = GetComponent<RectTransform>();
		//     var tempWidth = ((float)Content.transform.childCount * _rectWidth.rect.width);

		//     Content.sizeDelta = new Vector2(tempWidth, _rectWidth.rect.height);
		//     //未显示的长度
		//     float horizontalLength = Content.rect.width - _rectWidth.rect.width;
		//     //Debug.Log(horizontalLength);
		//     for (int i = 0; i < rect.content.transform.childCount; i++)
		//     {
		//         posList.Add(_rectWidth.rect.width * i / horizontalLength);
		//PageChilds.Add(rect.content.transform.GetChild(i).gameObject);

		//Debug.Log(posList[i]);
		//}
		//screenValue = Screen.width * 0.02f;

	}

	public PageView SetScrollRect(ScrollRect rect)
	{

		this.rect = rect;
		Content = rect.content;
		return this;
	}

	//目前只支持同宽度
	public PageView SetContentWidth()
	{
	//	Log.Debug("PageView-SetContentWidth-1");
		ContentSizeFitter fitter = Content.GetComponent<ContentSizeFitter>();

		if (fitter != null)
		{
			//Log.Debug("SetContentWidth-2");
			Canvas.ForceUpdateCanvases();
		}
		else
		{
			//Log.Debug("PageView-SetContentWidth-3");
			if (rect != null && rect.content != null)
			{
				Content = rect.content;
				float width = 0;
				for (int i = 0; i < Content.childCount; i++)
				{
					var contentRect = Content.GetChild(i).GetComponent<RectTransform>();
					if (contentRect.gameObject.activeInHierarchy)
					{
						width += LayoutUtility.GetMinWidth(contentRect);
					}
				}
				//float heigth = Content.GetComponent<RectTransform>().rect.height;

				Content.sizeDelta = new Vector2(width, 0);
			
			}
		}
		//Log.Debug("SetContentWidth-4");

		return this;
	}
	private Canvas canvas = null;
	private float unitWidth = 0;
	public void SetAllPagePosition()
	{

		//Log.Debug("PageView-SetAllPagePosition-1");
		isDrag = false;
		posList.Clear();
		PageChilds.Clear();
		itemPoslist.Clear();
		if (rect != null && Content != null)
		{
	
			if (Content.childCount == 0)
			{
				return;
			}

			GameObject go = Content.GetChild(0).gameObject;
			RectTransform rectTF = go.GetComponent<RectTransform>();
			
			unitWidth = LayoutUtility.GetMinWidth(rectTF);

			float horizontalLength = Content.rect.width - unitWidth;

			for (int i = 0; i < Content.transform.childCount; i++)
			{
				posList.Add(unitWidth * i / horizontalLength);

				Vector2 itemPos = new Vector2(-unitWidth * i, 0);
				itemPoslist.Add(itemPos);
				//Log.Debug("itemPos=="+ itemPos);

				SetPageList(Content.transform.GetChild(i).gameObject);
			}

		}
		//Log.Debug("PageView-SetAllPagePosition-2");
		//SetViewCentre();
	}

	private void SetPageList(GameObject ChildGo) 
	{
		if (ChildGo != null)
		{
			ScrollRect scroll = ChildGo.GetComponentInChildren<ScrollRect>();
			if (scroll != null)
			{
				PageChilds.Add(scroll.gameObject);
			}
		}
	}

	Vector2 centre;
	public void SetViewCentre()
	{
		if (rect != null)
		{
			RectTransform rectTransform = rect.GetComponent<RectTransform>();
			if (rectTransform != null)
			{
				centre = rectTransform.anchoredPosition;
			}
		}
	}

	void Update()
    {
		//Debug.Log(Content.rect.width);
        if (!isDrag && !stopMove)
        {
            startTime += Time.deltaTime;
            float t = startTime * Mathf.Max(smooting, dragSmooting);
			if ( Mathf.Abs(rect.horizontalNormalizedPosition - targethorizontal) < 0.02 ) {

				rect.horizontalNormalizedPosition = targethorizontal;
				stopMove = true;
				if (OnPageMoveDone != null)
				{
					OnPageMoveDone(PageChilds[currentPageIndex]);
				}
				return;
			}
			rect.horizontalNormalizedPosition = Mathf.Lerp(rect.horizontalNormalizedPosition, targethorizontal, t);

		}
        //Debug.Log(rect.horizontalNormalizedPosition);
    }

	public void ClearChild()
	{
	
		PageChilds.Clear();
	}

	private void OnDestroy()
	{
	
		ClearChild();
	}

	public void PageTo(int index)
    {
		//Log.Debug("PageTo--1");
        if (index >= 0 && index < posList.Count)
        {
			//Log.Debug("PageTo--2");
			if (rect != null)
			{
				Vector2 pos = itemPoslist[index];
				if (Vector2.Distance(pos,Content.anchoredPosition ) > 0.02f)
				{
					Content.anchoredPosition = pos;
					//OnPageMoveDone?.Invoke(PageChilds[index]);
				}
				else
				{
					//OnPageMoveDone?.Invoke(PageChilds[index]);
					//Log.Debug("不用换页");
				}

			}

			SetPageIndex(index);
        }
        else
        {
            //Log.Debug("页码不存在");
        }
    }

	public void AutoPageTo(int index)
	{
		if (isDrag)
		{
			return;
		}

		index = Mathf.Clamp(index, 0 ,posList.Count);
		targethorizontal = posList[index];
		startTime = 0;
		SetPageIndex(index);
		stopMove = false;
		if (OnPageMoveBegin != null)
		{
			OnPageMoveBegin.Invoke();
		}
	}

	private void SetPageIndex(int index)
    {
		//Log.Debug("SetPageIndex--1");
		if (CurrentPageIndex != index)
        {
			currentPageIndex = index;
            if (OnPageChanged != null)
                OnPageChanged(index);
        }
    }

	private float AnglewithUpAxis = 50;
	private Vector2 initializePos;
	public bool isHorizontal = false;
	public bool isVertical = false;
	public void OnInitializePotentialDrag(PointerEventData eventData)
	{
		//Log.Debug("OnInitializePotentialDrag" + eventData.position);
		initializePos = eventData.position;
	}


	private Vector2 OnBeginDrag(Vector2 vectors)
	{
		Vector2 _navigation = (vectors - initializePos).normalized;
		_navigation.x = Mathf.Abs(_navigation.x);
		_navigation.y = Mathf.Abs(_navigation.y);

		float Angle = Vector2.Angle(Vector2.up, _navigation);

		if (Angle > AnglewithUpAxis)
		{
			isHorizontal = true;
			isVertical = false;
		}
		else
		{
			isHorizontal = false;
			isVertical = true;
		}

		return _navigation;
	}

	public void OnBeginDrag(PointerEventData eventData)
    {
		OnBeginDrag(eventData.position);
		if (isVertical)
		{
			return;
		}

		//Log.Debug("OnBeginDrag" + eventData.position);
		dragSmooting = 0;
		inputList.Clear();
		isDrag = true;
        //开始拖动
        startDragHorizontal = rect.horizontalNormalizedPosition;

		dragTime = Time.time;

	}

	public void OnEndDrag(PointerEventData eventData)
	{
		if (isDrag)
		{
			//Log.Debug("OnEndDrag" + eventData.position);
			dragTime = Time.time - dragTime;

			//Debug.Log("eventData.position: " + eventData.position);
			//Debug.Log("eventData.pressPosition: " + eventData.pressPosition);
			if (dragTime < 0.2f)
			{
				//Log.Debug("dragTime=" + dragTime);
				Vector2 distance = inputList.Last.Value - inputList.First.Value;
				float distance_x = Mathf.Abs(distance.x);

				if (distance_x > screenValue)
				{
					dragSmooting = distance_x / 10f;
					dragSmooting = Mathf.Clamp(dragSmooting, 0, dragSmootingMax);

					//Log.Debug("dragSmooting" + dragSmooting);
					int toPageNum = 0;
					if (distance.x > 0)
					{
						if (currentPageIndex == 0)
						{
							return;
						}

						toPageNum = currentPageIndex - 1;
					}
					else
					{
						if (currentPageIndex == posList.Count - 1)
						{
							return;
						}
						toPageNum = currentPageIndex + 1;
					}

					isDrag = false;
					AutoPageTo(toPageNum);
					return;
				}

			}

			//Debug.Log("	delta: " + delta);


			float posX = rect.horizontalNormalizedPosition; //当前的位置
															//Debug.Log("posX " + posX);
			posX += ((posX - startDragHorizontal) * sensitivity); //当前的位置加上增量
			posX = posX < 1 ? posX : 1;
			posX = posX > 0 ? posX : 0;
			int index = 0;
			float offset = Mathf.Abs(posList[index] - posX); //第一页的偏移
															 //Debug.Log("offset " + offset);

			for (int i = 1; i < posList.Count; i++)
			{
				float temp = Mathf.Abs(posList[i] - posX);
				//Debug.Log("temp " + temp);
				//Debug.Log("i " + i);
				if (temp < offset)
				{

					index = i;
					offset = temp;
					//Debug.LogWarning("index " + index);
				}

			}
			//Debug.Log(index);
			SetPageIndex(index);

			targethorizontal = posList[index]; //设置当前坐标，更新函数进行插值  
			isDrag = false;
			startTime = 0;
			stopMove = false;

			if (OnPageMoveBegin != null)
			{
				OnPageMoveBegin.Invoke();
			}

		}

	}

	public void OnDrag(PointerEventData eventData)
	{
		//itemPoslist.Add(eventData.position);
		if (isDrag)
		{
			inputList.Add(eventData.position);
		}

	}

}
