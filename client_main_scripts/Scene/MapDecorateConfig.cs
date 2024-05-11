
using UnityEngine;

public class MapDecorateConfig : MonoBehaviour
{
    public enum DecorateType
    {
        Unit,
        Decorate,
        BirthPoint,
    }

    public DecorateType decorateType;
    public bool isStatic;
    public int genCount;
    public int space;
    public string prefabPath;
    public int priority;
    public Bounds bounds;
}
