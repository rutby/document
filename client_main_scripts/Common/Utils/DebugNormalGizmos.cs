
using UnityEngine;

[ExecuteInEditMode]
public class DebugNormalGizmos : MonoBehaviour
{
    private Mesh mesh;
    
    void Awake()
    {
        var filter = GetComponent<MeshFilter>();
        if (filter != null)
        {
            mesh = filter.sharedMesh;
        }
    }

    private void OnDrawGizmos()
    {
        if (mesh != null)
        {
            var normals = mesh.normals;
            var vertices = mesh.vertices;
            for (int i = 0; i < vertices.Length; i++)
            {
                var wp0 = transform.TransformPoint(vertices[i]);
                var wp1 = wp0 + normals[i];
                Gizmos.DrawLine(wp0, wp1);
            }
        }
    }
}