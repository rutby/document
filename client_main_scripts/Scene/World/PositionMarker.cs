
using UnityEngine;

//
// 位置标记，当选中该对象时，在场景视图中显示该对象的世界格子坐标
//
[ExecuteInEditMode]
public class PositionMarker : MonoBehaviour
{
    [SerializeField]
    private Vector2Int tilePos;

    private void Awake()
    {
        tilePos = TileCoord.WorldToTile(transform.position);
    }

    private void Update()
    {
        
    }

    public void SetToTileCenter()
    {
        var pos = transform.position;
        var newPos = TileCoord.SnapToTileCenter(pos);
        transform.position = new Vector3(newPos.x, pos.y, newPos.z);
        tilePos = TileCoord.WorldToTile(transform.position);
    }

    public Vector2Int GetTilePos()
    {
        return TileCoord.WorldToTile(transform.position);
    }
}
