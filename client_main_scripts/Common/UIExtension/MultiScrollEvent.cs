using System;
using System.Collections;
using System.Collections.Generic;
using GameFramework;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public enum MultiType
{
	/// <summary>
	/// 水平
	/// </summary>
	Horizontal,
	/// <summary>
	/// 垂直
	/// </summary>
	Vertial,
}

public class MultiScrollEvent : MonoBehaviour,IPointerDownHandler, IInitializePotentialDragHandler, IBeginDragHandler, IEndDragHandler, IDragHandler, IScrollHandler, IPointerClickHandler
{

	public PageView PageView;

	private ScrollRect scrollRect;

	[SerializeField]
	private GameObject rootScroller;
	public GameObject RootScroller
	{
		get
		{
			return rootScroller;
		}

		set
		{
			rootScroller = value;
			if (rootScroller != null)
			{
				rootScrollRect = rootScroller.GetComponent<ScrollRect>();

			}
		}
	}
	[SerializeField]
	private ScrollRect rootScrollRect;

	public MultiType RootScrollType;
	public List<GameObject> ChildScrolls;

	public bool isHorizontal = false;
	public bool isVertical = false;
	public readonly List<KeyValuePair<GameObject, IPointerClickHandler>> pointerClickHandlers = new List<KeyValuePair<GameObject, IPointerClickHandler>>();
	[SerializeField] private GameObject ScrollBaffle;

	private ScrollRect currentChildScroll;
	private GameObject currentChildScrollGo;
	private Vector2 navigation;
	private Vector2 initializePos;
	[SerializeField]
	private float AnglewithUpAxis = 50;//Vector2.Angle(Vector2.up, dir);
	private bool dragging;

	private readonly List<GameObject> ClickGameObjectList = new List<GameObject>();

	private void ClearClickList()
	{
		ClickGameObjectList.Clear();
	}

	public void AddClickList(GameObject go)
	{
		if (go != null)
		{
			if (!ClickGameObjectList.Contains(go))
			{
				ClickGameObjectList.Add(go);
			}
		}
	}


	public void Awake()
	{

		gameObject.name = "MultiScrollEvent";
		//if (RootScroller != null)
		//{
	
		//	rootScrollRect = RootScroller.GetComponent<ScrollRect>();
		//	rootScrollRect.viewport = null;
		//}

		//PageView.SetScrollRect(rootScrollRect)
		//	.SetAllPagePosition();

		//PageView.OnPageMoveDone = SetCurrentChildScroll;

	}

	public MultiScrollEvent SetRootScroller(GameObject gameObject)
	{
		//Log.Debug("SetRootScroller-1");
		this.RootScroller = gameObject;
		if (gameObject != null)
		{
			ScrollRect scrollRect = gameObject.GetComponent<ScrollRect>();
			if (scrollRect != null)
			{
				this.rootScrollRect = scrollRect;
				rootScrollRect.enabled = false;
				rootScrollRect.movementType = ScrollRect.MovementType.Clamped;
			}
		}
        //Log.Debug("SetRootScroller-PageView");
        if (PageView != null)
        {
            PageView.SetScrollRect(rootScrollRect)
        .SetContentWidth()
        .SetAllPagePosition();

            //Log.Debug("SetRootScroller-PageView-1");
            PageView.PageTo(0);
            PageView.OnPageMoveDone += SetCurrentChildScroll;
        }

		//Log.Debug("SetRootScroller-PageView-2");

		//rootScrollRect.enabled = true;
		//Log.Debug("SetRootScroller-2");

		rootScrollRect.enabled = true;
		rootScrollRect.movementType = ScrollRect.MovementType.Elastic;

		return this;
	}

	public MultiScrollEvent InitChildScrill()
	{
		//Log.Debug("InitChildScrill-1");
		ChildScrolls.Clear();

		if (rootScrollRect != null)
		{
			Transform content = rootScrollRect.content;

			if (content != null)
			{
				for (int i = 0; i < content.childCount; i++)
				{
					GameObject go = content.GetChild(i).gameObject;

					if (go != null)
					{
						ScrollRect scrollRect = go.GetComponentInChildren<ScrollRect>();

						if (scrollRect != null && scrollRect.gameObject.activeInHierarchy)
						{
							ChildScrolls.Add(scrollRect.gameObject);
						}
					}
				}
			}


		}
		currentChildScrollGo = ChildScrolls[0];
		//Log.Debug("InitChildScrill-2");
		return this;

	}

	public void Hide() 
	{
		if (PageView != null)
		{
			if (PageView.OnPageMoveDone != null)
			{
				PageView.OnPageMoveDone -= SetCurrentChildScroll;
			}

			PageView.ClearChild();
		}

		if (ChildScrolls != null)
		{
			ChildScrolls.Clear();
		}
	}

	private void OnDestroy()
	{

		if (ChildScrolls != null)
		{
			ChildScrolls.Clear();
		}
	}

	//public void InitClickGamObject() {

	//	if (RootScroller == null)
	//	{
	//		return;
	//	}

	//	Graphic[] graphics = RootScroller.GetComponentsInChildren<Graphic>();
	//	for (int i = 0; i < graphics.Length; i++)
	//	{
	//		if (graphics[i].raycastTarget)
	//		{
	//			IPointerClickHandler clickHandler = graphics[i].gameObject.GetComponent<IPointerClickHandler>();

	//			if (graphics[i].gameObject == this.gameObject)
	//			{
	//				continue;
	//			}

	//			if (clickHandler == null)
	//			{
	//				graphics[i].raycastTarget = false;
	//				continue;
	//			}
	//			pointerClickHandlers.Add(new KeyValuePair<GameObject, IPointerClickHandler>(graphics[i].gameObject, clickHandler));
	//			//graphics[i].raycastTarget = false;
	//		}
	//	}
	//}

	private void ClearCurrentChildScroll()
	{
		//Debug.Log("ClearCurrentChildScroll");
		currentChildScroll = null;
		currentChildScrollGo = null;
	}

	public void SetCurrentChildScroll(GameObject go) 
	{
		//Debug.Log("SetCurrentChildScroll--1");
		if (go != null)
		{
			//Debug.Log("SetCurrentChildScroll--2");
			CheckScrollerInCollection(go);
		}
		else
		{
			currentChildScroll = null;
		}
	}


	private bool CheckScrollerInCollection(GameObject go)
	{

		if (go == null)
		{
			return false;
		}

		for (int i = 0; i < ChildScrolls.Count; i++)
		{

			if (ChildScrolls[i] == go)
			{
				currentChildScrollGo = go;
				return true;
			}
		}
		return false;

	}

	public void SetCurrentChildScroll(ScrollRect scroll)
	{
		CheckScrollerInCollection(scroll);
	}

	private bool CheckScrollerInCollection(ScrollRect scroll)
	{

		if (scroll == null)
		{
			return false;
		}

		for (int i = 0; i < ChildScrolls.Count; i++)
		{

			if (ChildScrolls[i] == scroll.gameObject)
			{
				currentChildScroll = scroll;
				return true;
			}
		}
		return false;

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
		dragging = true;
		navigation = OnBeginDrag(eventData.position);

		//Debug.Log("navigation ==" + navigation);
		//Debug.Log("isHorizontal ==" + isHorizontal);
		//Debug.Log("isVertical ==" + isVertical);

		if (RootScrollType == MultiType.Horizontal)
		{
			if (isHorizontal)
			{
				ExecuteEvents.Execute(rootScroller, eventData, ExecuteEvents.beginDragHandler);
				//ClearCurrentChildScroll();
				//if (currentChildScrollGo != null)
				//{
				//	ExecuteEvents.Execute(currentChildScrollGo, eventData, ExecuteEvents.beginDragHandler);
				//}

			}

			if (isVertical)
			{
				if (currentChildScrollGo != null)
				{
					ExecuteEvents.Execute(currentChildScrollGo, eventData, ExecuteEvents.beginDragHandler);
				}
			}

		}
		else
		{
			if (isVertical)
			{
				ExecuteEvents.Execute(rootScroller, eventData, ExecuteEvents.beginDragHandler);
			}
			else
			{
				if (currentChildScrollGo != null)
				{
					ExecuteEvents.Execute(currentChildScrollGo, eventData, ExecuteEvents.beginDragHandler);
				}
			}
		}
	}

	public void OnDrag(PointerEventData eventData)
	{
		//Debug.Log("OnDrag " + eventData.position);

		if (RootScrollType == MultiType.Horizontal)
		{
			if (isHorizontal)
			{
				ExecuteEvents.Execute(rootScroller, eventData, ExecuteEvents.dragHandler);
			}
			if (isVertical)
			{
				if (currentChildScrollGo != null)
				{
					//Debug.Log("22");
					ExecuteEvents.Execute(currentChildScrollGo, eventData, ExecuteEvents.dragHandler);
				}
			}

		}
		else
		{
			if (isVertical)
			{
				ExecuteEvents.Execute(rootScroller, eventData, ExecuteEvents.dragHandler);
			}
			else
			{
				if (currentChildScrollGo != null)
				{
					ExecuteEvents.Execute(currentChildScrollGo, eventData, ExecuteEvents.dragHandler);
				}
			}
		}

	}

	public void OnEndDrag(PointerEventData eventData)
	{
        //Log.Debug("OnEndDrag" + eventData.position);
		if (RootScrollType == MultiType.Horizontal)
		{
			if (isHorizontal)
			{
				ExecuteEvents.Execute(rootScroller, eventData, ExecuteEvents.endDragHandler);
			}
			if (isVertical)
			{
				if (currentChildScrollGo != null)
				{
					//Debug.Log("33");
					ExecuteEvents.Execute(currentChildScrollGo, eventData, ExecuteEvents.endDragHandler);
				}
			}

		}
		else
		{
			if (isVertical)
			{
				ExecuteEvents.Execute(rootScroller, eventData, ExecuteEvents.endDragHandler);
			}
			else
			{
				if (currentChildScrollGo != null)
				{
					ExecuteEvents.Execute(currentChildScrollGo, eventData, ExecuteEvents.endDragHandler);
				}
			}
		}

		dragging = false;
	}

	public void OnInitializePotentialDrag(PointerEventData eventData)
	{
		//Log.Debug("OnInitializePotentialDrag " + eventData.position);

		initializePos = eventData.position;
		isVertical = false;
		isHorizontal = false;

		//if (rootScroller != null)
		//{
		//	ExecuteEvents.Execute(rootScroller, eventData, ExecuteEvents.initializePotentialDrag);
		//}

		//for (int i = 0; i < ChildScrolls.Count; i++)
		//{
		//	if (ChildScrolls[i] == null)
		//	{
		//		continue;
		//	}
		//	ExecuteEvents.Execute(ChildScrolls[i], eventData, ExecuteEvents.initializePotentialDrag);

		//}
	}

	public void OnScroll(PointerEventData eventData)
	{
		//Log.Debug("OnScroll " + eventData.position);
		if (rootScroller != null)
		{
			ExecuteEvents.Execute(rootScroller, eventData, ExecuteEvents.scrollHandler);
		}
		for (int i = 0; i < ChildScrolls.Count; i++)
		{
			if (ChildScrolls[i] == null)
			{
				continue;
			}
			ExecuteEvents.Execute(ChildScrolls[i], eventData, ExecuteEvents.scrollHandler);
		}
	}

	public void OnPointerClick(PointerEventData eventData)
	{
		if (dragging)
		{
            //Log.Debug("OnPointerClick dragging:"+ dragging.ToString());
			return;
		}

		var results = new List<RaycastResult>();
		EventSystem.current.RaycastAll(eventData, results);
		var current = eventData.pointerCurrentRaycast.gameObject;
		for (int i = 0; i < results.Count; i++)
		{
			//Log.Debug("OnPointerClick:=" + results[i].gameObject.name);
			if (CanClick(results[i].gameObject))
			{
				//判断穿透对象是否是需要要点击的对象
				if (current != results[i].gameObject)
				{
					//Debug.Log("name" + results[i].gameObject.name);
					ExecuteEvents.Execute(results[i].gameObject, eventData, ExecuteEvents.pointerClickHandler);
				}
			}
		}
	}

	private bool CanClick(GameObject go)
 	{
		//for (int i = 0; i < ClickGameObjectList.Count; i++)
		//{
		 
		//}
		return ClickGameObjectList.Contains(go);
		//return false;
 	}

	public void OnClick(GameObject Go)
 	{
		//Debug.Log("name" + Go.name);
	}


	//如果是横向移动就y就永远是0
	public void OnRootvalueChange(Vector2 vector)
	{
		//Log.Debug("OnRootvalueChange=" + vector);
	}

	private void OnEnable()
	{
		ClearClickList();
	}

	private void OnDisable()
	{
		ClearClickList();
	}

	public Action OnCloseBaffle;

	public void BaffleMultiScroll(bool _enable)
	{
		if (ScrollBaffle != null)
		{
			ScrollBaffle.SetActive(_enable);
		}
	}

	public void OnClickBaffleUI()
	{
		if (ScrollBaffle != null && ScrollBaffle.activeSelf)
		{
			ScrollBaffle.SetActive(false);
			OnCloseBaffle?.Invoke();
			OnCloseBaffle = null;
		}

	}

    public bool CanAutoClickDown = false;


    public void OnPointerDown(PointerEventData eventData)
    {
        if (!CanAutoClickDown)
        {
            return;
        }

        var results = new List<RaycastResult>();
        EventSystem.current.RaycastAll(eventData, results);
        var current = eventData.pointerCurrentRaycast.gameObject;
        for (int i = 0; i < results.Count; i++)
        {
            if (ChildScrolls.Contains(results[i].gameObject))
            {
                currentChildScrollGo = results[i].gameObject;
                return;
            }
        }

    }
}
