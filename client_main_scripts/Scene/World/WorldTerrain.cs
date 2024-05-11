using System.Collections.Generic;
using System.Linq;
using UnityEngine;

// 世界地形
public class WorldTerrain : MonoBehaviour
{
    private const float MeshGridSize = 1.8101934f;
    private Mesh mesh;
    private MeshFilter filter;
    private MeshRenderer meshRenderer;

    [SerializeField]
    private int sortingOrder;

    public void Create(int tileRange)
    {
        filter.mesh = CreateMesh(tileRange);
    }

    private void Awake()
    {
        filter = GetComponent<MeshFilter>();

        meshRenderer = GetComponent<MeshRenderer>();
        meshRenderer.sortingLayerName = "FreeBuildGround";
        meshRenderer.sortingOrder = sortingOrder;
    }

    private int[] triangles =
    {
        0, 2, 3,
        0, 3, 1,
        1, 7, 5,
        1, 3, 7,
        5, 6, 4,
        5, 7, 6,
        2, 11, 3,
        2, 9, 11,
        3, 15, 7,
        3, 11, 15,
        7, 13, 6,
        7, 15, 13,
        8, 10, 9,
        9, 10, 11,
        11, 14, 15,
        11, 10, 14,
        12, 15, 14,
        12, 13, 15
    };

    private Mesh CreateMesh(int tileRange)
    {
        var mesh = new Mesh();

        var range = (tileRange + 1) * MeshGridSize;

        //
        // 创建模型顶点，顶点索引号如下
        // 8 10   14 12
        // 9 11   15 13
        //        
        // 2 3    7  6
        // 0 1    5  4
        //
        List<Vector3> vertices = new List<Vector3>(16);
        List<Color> colors = new List<Color>(16);

        vertices.Add(new Vector3(0, 0, 0));
        vertices.Add(new Vector3(MeshGridSize, 0, 0));
        vertices.Add(new Vector3(0, MeshGridSize, 0));
        vertices.Add(new Vector3(MeshGridSize, MeshGridSize, 0));

        vertices.Add(new Vector3(range, 0, 0));
        vertices.Add(new Vector3(range - MeshGridSize, 0, 0));
        vertices.Add(new Vector3(range, MeshGridSize, 0));
        vertices.Add(new Vector3(range - MeshGridSize, MeshGridSize, 0));

        vertices.Add(new Vector3(0, range, 0));
        vertices.Add(new Vector3(0, range - MeshGridSize, 0));
        vertices.Add(new Vector3(MeshGridSize, range, 0));
        vertices.Add(new Vector3(MeshGridSize, range - MeshGridSize, 0));

        vertices.Add(new Vector3(range, range, 0));
        vertices.Add(new Vector3(range, range - MeshGridSize, 0));
        vertices.Add(new Vector3(range - MeshGridSize, range, 0));
        vertices.Add(new Vector3(range - MeshGridSize, range - MeshGridSize, 0));

        //Matrix4x4 m = Matrix4x4.identity;
        
        // Mesh中心移到源点，旋转
        //m = Matrix4x4.Translate(new Vector3(-range / 2, -range / 2, 0)) * m;
        //m = Matrix4x4.Rotate(Quaternion.Euler(90, 0, 45)) * m;

        //vertices = vertices.Select(v =>
        //{
        //    var v4 = m * new Vector4(v.x, v.y, v.z, 1);
        //    return new Vector3(v4.x, v4.y, v4.z);
        //}).ToList();
        //transform.localPosition = Vector3.zero;
        //transform.localRotation = Quaternion.identity;
        //transform.localScale = Vector3.one;
        //transform.localPosition = new Vector3(-range / 2, -range / 2, 0);
        //transform.localRotation = Quaternion.Euler(90, 0, 45);
        
        mesh.SetVertices(vertices);
        mesh.SetTriangles(triangles, 0);

        // 计算纹理坐标，其中10.24为地形贴图的单位大小
        mesh.SetUVs(0, vertices.Select(v => new Vector2(v.x / 10.24f, v.y / 10.24f)).ToList());

        // 设置顶点颜色，实现地形边缘到内部的过渡。除了顶点3 7 11 15，其他顶点颜色设为全透明
        colors.Add(new Color(1, 1, 1, 0));
        colors.Add(new Color(1, 1, 1, 0));
        colors.Add(new Color(1, 1, 1, 0));
        colors.Add(new Color(1, 1, 1, 1));

        colors.Add(new Color(1, 1, 1, 0));
        colors.Add(new Color(1, 1, 1, 0));
        colors.Add(new Color(1, 1, 1, 0));
        colors.Add(new Color(1, 1, 1, 1));

        colors.Add(new Color(1, 1, 1, 0));
        colors.Add(new Color(1, 1, 1, 0));
        colors.Add(new Color(1, 1, 1, 0));
        colors.Add(new Color(1, 1, 1, 1));

        colors.Add(new Color(1, 1, 1, 0));
        colors.Add(new Color(1, 1, 1, 0));
        colors.Add(new Color(1, 1, 1, 0));
        colors.Add(new Color(1, 1, 1, 1));

        mesh.SetColors(colors);
        
        return mesh;
    }
}