using UnityEngine;
using XLua;

[LuaCallCSharp]
public static class PointUtils
{
    public static Vector2 ScreenPointToLocalPointInRectangle(RectTransform _rectTransform, Vector2 _screenPoint, Camera _camera)
    {
        if (RectTransformUtility.ScreenPointToLocalPointInRectangle(_rectTransform, _screenPoint, _camera, out Vector2 localPoint))
        {
            return localPoint;
        }
        return Vector2.zero;
    }
}