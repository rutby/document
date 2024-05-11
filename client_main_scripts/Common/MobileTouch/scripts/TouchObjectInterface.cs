
using System.Collections.Generic;
using UnityEngine;

public interface ITouchObject
{
    float Priority { get; }
    Vector2Int TilePos { get; }
}

// 单击
public interface ITouchObjectClickHandler : ITouchObject
{
    bool OnClick();
}

// 双击
public interface ITouchObjectDoubleClickHandler : ITouchObject
{
    bool OnDoubleClick();
}

// 拖拽开始
public interface ITouchObjectBeginDragHandler : ITouchObject
{
    bool OnBeginDrag(Vector3 dragStartPos);
}

// 拖拽中
public interface ITouchObjectDragHandler : ITouchObject
{
    bool OnDrag(Vector3 dragStartPos, Vector3 dragCurrPos);
}

// 拖拽结束
public interface ITouchObjectEndDragHandler : ITouchObject
{
    bool OnEndDrag(Vector3 dragStopPos);
}

// 长按开始
public interface ITouchObjectBeginLongTabHandler : ITouchObject
{
    bool OnBeginLongTap();
}

// 长按结束
public interface ITouchObjectEndLongTabHandler : ITouchObject
{
    bool OnEndLongTap();
}

public interface ITouchObjectPointerEnterHandler : ITouchObject
{
    bool OnPointerEnter();
}

public interface ITouchObjectPointerExitHandler : ITouchObject
{
    bool OnPointerExit();
}

public interface ITouchObjectPointerDownHandler : ITouchObject
{
    bool OnPointerDown();
}

public interface ITouchObjectPointerUpHandler : ITouchObject
{
    bool OnPointerUp();
}

static class TouchObjectEvent
{
    public delegate bool EventFunction<T1>(T1 handler);
    
    public static readonly EventFunction<ITouchObjectClickHandler> s_ClickHandler = Execute;
    public static bool Execute(ITouchObjectClickHandler handler)
    {
        return handler.OnClick();
    }
    
    public static readonly EventFunction<ITouchObjectDoubleClickHandler> s_DoubleClickHandler = Execute;
    public static bool Execute(ITouchObjectDoubleClickHandler handler)
    {
        return handler.OnDoubleClick();
    }

    public static readonly EventFunction<ITouchObjectBeginLongTabHandler> s_BeginLongTabHandler = Execute;
    public static bool Execute(ITouchObjectBeginLongTabHandler handler)
    {
        return handler.OnBeginLongTap();
    }
    
    public static readonly EventFunction<ITouchObjectEndLongTabHandler> s_EndLongTabHandler = Execute;
    public static bool Execute(ITouchObjectEndLongTabHandler handler)
    {
        return handler.OnEndLongTap();
    }

    public static readonly EventFunction<ITouchObjectPointerDownHandler> s_PointerDownHandler = Execute;
    public static bool Execute(ITouchObjectPointerDownHandler handler)
    {
        return handler.OnPointerDown();
    }
    
    public static readonly EventFunction<ITouchObjectPointerUpHandler> s_PointerUpHandler = Execute;
    public static bool Execute(ITouchObjectPointerUpHandler handler)
    {
        return handler.OnPointerUp();
    }
    
    public static bool Execute<T>(ITouchObject obj, EventFunction<T> functor) where T : ITouchObject
    {
        if (obj is T handler)
        {
            return functor(handler);
        }

        return false;
    }

    public static ITouchObject GetFirstEventObject<T>(List<ITouchObject> objs)
    {
        foreach (var i in objs)
        {
            if (i is T)
            {
                return i;
            }
        }

        return null;
    }

    public static bool ExecuteClick(ITouchObject obj)
    {
        return Execute(obj, s_ClickHandler);
    }

    public static bool ExecuteDoubleClick(ITouchObject obj)
    {
        return Execute(obj, s_DoubleClickHandler);
    }
    
    public static bool ExecuteBeginDrag(ITouchObject obj, Vector3 dragStartPos)
    {
        if (obj is ITouchObjectBeginDragHandler handler)
        {
            return handler.OnBeginDrag(dragStartPos);
        }

        return false;
    }
    
    public static bool ExecuteDrag(ITouchObject obj, Vector3 dragStartPos, Vector3 dragCurrPos)
    {
        if (obj is ITouchObjectDragHandler handler)
        {
            return handler.OnDrag(dragStartPos, dragCurrPos);
        }

        return false;
    }
    
    public static bool ExecuteEndDrag(ITouchObject obj, Vector3 dragStopPos)
    {
        if (obj is ITouchObjectEndDragHandler handler)
        {
            return handler.OnEndDrag(dragStopPos);
        }

        return false;
    }
    
    public static bool ExecuteBeginLongTab(ITouchObject obj)
    {
        return Execute(obj, s_BeginLongTabHandler);
    }
    
    public static bool ExecuteEndLongTab(ITouchObject obj)
    {
        return Execute(obj, s_EndLongTabHandler);
    }
    
    public static bool ExecutePointerDown(ITouchObject obj)
    {
        return Execute(obj, s_PointerDownHandler);
    }
    
    public static bool ExecutePointerUp(ITouchObject obj)
    {
        return Execute(obj, s_PointerUpHandler);
    }
}





