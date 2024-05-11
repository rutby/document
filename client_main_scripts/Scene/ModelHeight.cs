using UnityEngine;

public class ModelHeight : MonoBehaviour
{
    // 建筑模型
    [SerializeField]
    private GameObject _modelObj;
    // 总高度和当前进度
    [SerializeField]
    private float height;
    // 高度增加值，默认为0
    [SerializeField]
    private float heightDelta = 0.0f;

    public float GetHeight()
    {
        return height + heightDelta;
    }
    

#if UNITY_EDITOR
    [Sirenix.OdinInspector.Button(Sirenix.OdinInspector.ButtonSizes.Large)]
    public void SetModelHeight()
    {
        //
        // 获取模型最大高度
        //
        height = 0;
        var filters = _modelObj.GetComponentsInChildren<MeshFilter>();
        foreach (var f in filters)
        {
            var verts = f.sharedMesh.vertices;
            foreach (var v in verts)
            {
                var worldV = f.transform.TransformPoint(v);
                if (worldV.y > height)
                {
                    height = worldV.y;
                }
            }
        }
        
        var skinned = _modelObj.GetComponentsInChildren<SkinnedMeshRenderer>();
        foreach (var f in skinned)
        {
            var verts = f.sharedMesh.vertices;
            var bindposes = f.sharedMesh.bindposes;
            var boneWeights = f.sharedMesh.boneWeights;
            var bones = f.bones;
            for (var i = 0; i < verts.Length; i++)
            {
                var v = verts[i];
                var w = boneWeights[i];
                Vector4 worldV = bones[w.boneIndex0].localToWorldMatrix * bindposes[w.boneIndex0] * v * w.weight0
                                 + bones[w.boneIndex1].localToWorldMatrix * bindposes[w.boneIndex1] * v * w.weight1
                                 + bones[w.boneIndex2].localToWorldMatrix * bindposes[w.boneIndex2] * v * w.weight2
                                 + bones[w.boneIndex3].localToWorldMatrix * bindposes[w.boneIndex3] * v * w.weight3;
                
                if (worldV.y > height)
                {
                    height = worldV.y;
                }
            }
        }
    }

#endif
}