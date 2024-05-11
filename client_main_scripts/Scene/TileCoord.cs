using UnityEngine;

public static class TileCoord
{
    // 格子的边长度、格子对角线长度
    public const float TileSize = 2f;
    public const float TileDiagonalSize = 2.8284f;
    
    // 格子坐标 -> 世界坐标
    public static Vector3 TileToWorld(Vector2Int tilePos)
    {
        return new Vector3((tilePos.x + 0.5f) * TileSize, 0, (tilePos.y + 0.5f) * TileSize);
    }

    // 格子坐标 -> 世界坐标
    public static Vector3 TileToWorld(int tilePosX, int tilePosY)
    {
        return new Vector3((tilePosX + 0.5f) * TileSize, 0, (tilePosY + 0.5f) * TileSize);
    }

    // 世界坐标 -> 格子坐标
    public static Vector2Int WorldToTile(Vector3 worldPos)
    {
        return new Vector2Int((int) (worldPos.x / TileSize), (int) (worldPos.z / TileSize));
    }

    // 将 worldPos 对齐到格子中心的世界坐标
    public static Vector3 SnapToTileCenter(Vector3 worldPos)
    {
        return TileToWorld(WorldToTile(worldPos));
    }

    // 浮点格子坐标 -> 世界坐标
    public static Vector3 TileFloatToWorld(Vector2 tilePos)
    {
        return new Vector3(tilePos.x * TileSize, 0, tilePos.y * TileSize);
    }

    public static Vector3 TileFloatToWorld(float x, float y)
    {
        return new Vector3(x * TileSize, 0, y * TileSize);
    }

    // 世界坐标 -> 浮点格子坐标 
    public static Vector2 WorldToTileFloat(Vector3 worldPos)
    {
        return new Vector2(worldPos.x / TileSize, worldPos.z / TileSize);
    }
    
    public static Vector2Int IndexToTilePos(int index, Vector2Int tileCount)
    {
        if (index < 1 || index > tileCount.x * tileCount.y)
        {
            return Vector2Int.zero;
        }

        index -= 1;
        return new Vector2Int(index % tileCount.x, index / tileCount.y);
    }

    public static int TilePosToIndex(Vector2Int tilePos, Vector2Int tileCount)
    {
        if (tilePos.x < 0 || tilePos.y < 0 || tilePos.x > tileCount.x - 1 || tilePos.y > tileCount.y - 1)
        {
            return 0;
        }

        return tilePos.x + tilePos.y * tileCount.x + 1;
    }

    public static Vector3 TileIndexToWorld(int index, Vector2Int tileCount)
    {
        return TileToWorld(IndexToTilePos(index, tileCount));
    }

    public static int WorldToTileIndex(Vector3 pos, Vector2Int tileCount)
    {
        return TilePosToIndex(WorldToTile(pos), tileCount);
    }

    // 格子距离
    public static float TileDistance(Vector2Int a, Vector2Int b)
    {
        return Vector2Int.Distance(a, b);
    }
}