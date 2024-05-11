using System.Collections.Generic;
using System.Linq;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Tilemaps;

#if UNITY_EDITOR
using UnityEditor;

#endif

[DisallowMultipleComponent]
[ExecuteInEditMode]
public class CityEnergyConfig : MonoBehaviour
{
    private static int FOG_TILE_COUNT = 100;
    private static float FOG_TILE_SIZE = 2;
    
    [ReadOnly]
    [HideInInspector]
    public int objId;
    
    [LabelText("id: ID")]
    public string triggerId;
    
    [ReadOnly]
    [LabelText("Pos: 位置")]
    public string pos;
    
    [LabelText("UnclockType: 类型")]
    public string triggerType;
    
    [LabelText("UnclockPara: 参数1")]
    public string unlockPara1;
    
    [LabelText("UnclockPara2: 参数2")]
    public string unlockPara2;
    
    [LabelText("UnclockPara3: 参数3")]
    public string unlockPara3;
    
    [LabelText("UnclockPara4: 参数4")]
    public string unlockPara4;
    
    [LabelText("UnclockPara5: 参数5")]
    public string unlockPara5;

    [LabelText("trigger_type: 触发类型")]
    public string triggerType2;

    [LabelText("name: 物品名称")]
    public string itemName;

    [LabelText("description: 说明文字")]
    public string description;

    [HorizontalGroup("modelName")]
    [LabelText("ModelName: 模型名称")]
    public GameObject modelNameGameObject;

    [HorizontalGroup("modelName")]
    [LabelText("")]
    public string modelName;

    [LabelText("Timeline: timeline名称")]
    public string timeline;

    [LabelText("Animation: 小人交互动画")]
    public string anim;
    
    [LabelText("energy_cost: 体力消耗")]
    public string energyCost;
    
    [LabelText("rewardId: 奖励")]
    public string rewardId;
    
    [LabelText("exp_reward: 英雄经验值")]
    public string expReward;

    [LabelText("FollowNpc")]
    public string followNpc;
    
    [ReadOnly]
    [LabelText("Transform")]
    public string trans;
    
    [LabelText("JsRotation: 建筑、怪物的角度")]
    public string jsRotation;
    
    [LabelText("need_army: 需求士兵数量")]
    public string needArmy;
    
    [LabelText("dis: 挑战按钮上面的推荐文本")]
    public string dis;
    
    [LabelText("SideQuest: 支线任务")]
    public bool sideQuest;
    
    [LabelText("Order: 主线顺序")]
    public string order;
    
    [LabelText("ShowPos: 提示牌显示位置")]
    public string showPos;
    
    [HorizontalGroup("conditionId")]
    [LabelText("ConditionID: 前置条件")]
    public CityEnergyConfig conditionIdConfig;
    
    [HorizontalGroup("conditionId")]
    [LabelText("")]
    public string conditionId;
    
    [LabelText("UnclockFog: 解锁迷雾")]
    public GameObject fogGameObject;
    
    [ReadOnly]
    [LabelText(" - UnclockFog: 解锁迷雾的坐标")]
    [ShowIf("@fogGameObject != null")] 
    public string unlockFog;
    
    private HashSet<int> unlockFogIdSet = new HashSet<int>();
    
    [HorizontalGroup("showFogInEditor")]
    [LabelText(" - 在编辑器中显示实际迷雾")]
    public bool showFogInEditor;

    [LabelText("SpecialTag: 特殊显示部分")]
    public string specialTag;

    [LabelText("Noviceboot")]
    public string noviceboot;

    [LabelText("BubbleDisplay")]
    public string bubbleDisplay;

    [LabelText("EffectArea: 生效区域")]
    public GameObject effectAreaGameObject;

    [ReadOnly]
    [LabelText(" - EffectArea: 生效区域的坐标")]
    [ShowIf("@effectAreaGameObject != null")] 
    public string effectArea;

    private HashSet<Vector2Int> effectAreaSet = new HashSet<Vector2Int>();

    [LabelText(" - 在编辑器中显示生效区域")]
    public bool showEffectAreaInEditor;

    [LabelText("ForceFinish")]
    public string forceFinish;
    
    [HorizontalGroup("editorField", width: 10)]
    [LabelText("在编辑器场景中显示的字段")]
    public int editorFieldFontSize = 12;
    
    [HorizontalGroup("editorField")]
    [LabelText("")]
    [ValueDropdown("editorFieldList")]
    public string editorField = "rewardId";
    private static readonly ValueDropdownList<string> editorFieldList = new ValueDropdownList<string> { {"无", ""}, {"id", "triggerId"}, {"name", "itemName"}, {"description", "description"}, {"Timeline", "timeline"}, {"energy_cost", "energyCost"}, {"rewardId", "rewardId"}, {"Noviceboot", "noviceboot"}, {"ForceFinish", "forceFinish"}, };

#if UNITY_EDITOR
    private void Start()
    {
        objId = gameObject.GetInstanceID();
    }
    
    private void OnValidate()
    {
        Refresh();
    }

    private void OnEnable()
    {
        Tilemap.tilemapTileChanged += OnTilemapTileChanged;
    }

    private void OnDisable()
    {
        Tilemap.tilemapTileChanged -= OnTilemapTileChanged;
    }

    [Button("刷新")] [VerticalGroup(PaddingTop = 25)]
    public void Refresh()
    {
        // pos
        Vector2Int tilePos = TileCoord.WorldToTile(transform.position);
        pos = $"{tilePos.x},{tilePos.y}";
        
        // modelNameGameObject
        if (modelNameGameObject != null)
        {
            modelName = modelNameGameObject.name;
            modelNameGameObject = null;
        }
        
        // conditionIdConfig
        if (conditionIdConfig != null)
        {
            conditionId = conditionIdConfig.triggerId;
            conditionIdConfig = null;
        }
        
        // fogGameObjects
        List<int> fogIds = new List<int>();
        if (fogGameObject != null)
        {
            Tilemap map = fogGameObject.GetComponent<Tilemap>();
            if (map != null)
            {
                fogIds.AddRange(ParseFogIds(map));
            }
            else
            {
                BoxCollider[] colliders = fogGameObject.GetComponentsInChildren<BoxCollider>(true);
                foreach (BoxCollider c in colliders)
                {
                    fogIds.AddRange(ParseFogIds(c));
                }
            }
        }
        fogIds = fogIds.Distinct().ToList();
        fogIds.Sort();
        unlockFog = string.Join(";", fogIds);
        unlockFogIdSet = new HashSet<int>(fogIds);
        
        // effectAreaGameObjects
        List<Vector2Int> areaPoses = new List<Vector2Int>();
        if (effectAreaGameObject != null)
        {
            Tilemap map = effectAreaGameObject.GetComponent<Tilemap>();
            if (map != null)
            {
                areaPoses.AddRange(ParseAreaPoses(map));
            }
            else
            {
                BoxCollider[] colliders = effectAreaGameObject.GetComponentsInChildren<BoxCollider>(true);
                foreach (BoxCollider c in colliders)
                {
                    areaPoses.AddRange(ParseAreaPoses(c));
                }
            }
        }
        areaPoses = areaPoses.Distinct().ToList();
        areaPoses.Sort((a, b) => (a.x + a.y * FOG_TILE_COUNT) - (b.x + b.y * FOG_TILE_COUNT));
        string[] areaPoseStrs = areaPoses.Select(p => $"{p.x},{p.y}").ToArray();
        effectArea = string.Join(";", areaPoseStrs);
        effectAreaSet = new HashSet<Vector2Int>(areaPoses);
        
        // trans
        Vector3 t = transform.position;
        Vector3 r = transform.rotation.eulerAngles;
        Vector3 s = transform.localScale;
        if (Mathf.Abs(t.x) < 0.001f) t.x = 0;
        if (Mathf.Abs(t.y) < 0.001f) t.y = 0;
        if (Mathf.Abs(t.z) < 0.001f) t.z = 0;
        trans = $"{t.x},{t.y},{t.z};{r.x},{r.y},{r.z};{s.x},{s.y},{s.z};";
    }

    private List<int> ParseFogIds(Tilemap map)
    {
        List<int> ids = new List<int>();
        for (int x = 0; x < FOG_TILE_COUNT; x++)
        {
            for (int y = 0; y < FOG_TILE_COUNT; y++)
            {
                TileBase tile = map.GetTile(new Vector3Int(x, y, 0));
                if (tile != null)
                {
                    int id = x + y * FOG_TILE_COUNT + 1;
                    ids.Add(id);
                }
            }
        }
        return ids;
    }

    private List<int> ParseFogIds(BoxCollider c)
    {
        List<int> ids = new List<int>();
        Vector3 center = c.transform.position + c.center;
        Vector3 size = c.size;
        float left = center.x - size.x / 2;
        float right = center.x + size.x / 2;
        float bottom = center.z - size.z / 2;
        float top = center.z + size.z / 2;
        for (float x = left; x <= right; x += FOG_TILE_SIZE / 2)
        {
            for (float z = bottom; z <= top; z += FOG_TILE_SIZE / 2)
            {
                Vector3 worldPos = new Vector3(x, 0, z);
                ids.Add(WorldPosToFogId(worldPos));
            }
        }
        return ids;
    }

    private List<Vector2Int> ParseAreaPoses(Tilemap map)
    {
        List<Vector2Int> poses = new List<Vector2Int>();
        for (int x = 0; x < FOG_TILE_COUNT; x++)
        {
            for (int y = 0; y < FOG_TILE_COUNT; y++)
            {
                TileBase tile = map.GetTile(new Vector3Int(x, y, 0));
                if (tile != null)
                {
                    poses.Add(new Vector2Int(x, y));
                }
            }
        }
        
        return poses;
    }

    private List<Vector2Int> ParseAreaPoses(BoxCollider c)
    {
        List<Vector2Int> poses = new List<Vector2Int>();
        Vector3 center = c.transform.position + c.center;
        Vector3 size = c.size;
        float left = center.x - size.x / 2;
        float right = center.x + size.x / 2;
        float bottom = center.z - size.z / 2;
        float top = center.z + size.z / 2;
        for (float x = left; x <= right; x += TileCoord.TileSize / 2)
        {
            for (float z = bottom; z <= top; z += TileCoord.TileSize / 2)
            {
                Vector3 worldPos = new Vector3(x, 0, z);
                Vector2Int tilePos = TileCoord.WorldToTile(worldPos);
                poses.Add(tilePos);
            }
        }
        
        return poses;
    }

    public void OnDrawGizmos()
    {
        if (!string.IsNullOrEmpty(editorField))
        {
            object o = GetType().GetField(editorField)?.GetValue(this);
            if (o != null)
            {
                GUIStyle style = new GUIStyle();
                style.normal.textColor = Color.white;
                style.fontSize = editorFieldFontSize;
                style.fontStyle = FontStyle.Bold;
                Handles.zTest = CompareFunction.Never;
                Handles.Label(transform.position, o.ToString(), style);
            }
        }

        if (showFogInEditor)
        {
            Gizmos.color = new Color(0, 0, 0, 0.3f);
            foreach (int id in unlockFogIdSet)
            {
                Vector3 worldPos = FogIdToWorldPos(id);
                Gizmos.DrawCube(worldPos, new Vector3(FOG_TILE_SIZE, 0f, FOG_TILE_SIZE));
            }

            if (unlockFogIdSet.Count > 0 && fogGameObject != null)
            {
                GUIStyle style = new GUIStyle();
                style.normal.textColor = Color.red;
                style.fontSize = 18;
                style.fontStyle = FontStyle.Bold;
                Vector3 labelPos = FogIdToWorldPos(unlockFogIdSet.First());
                Handles.zTest = CompareFunction.Never;
                Handles.Label(labelPos, fogGameObject.name, style);
            }
        }

        if (showEffectAreaInEditor)
        {
            foreach (Vector2Int p in effectAreaSet)
            {
                Vector3 worldPos = TileCoord.TileToWorld(p.x, p.y);
                Gizmos.color = new Color(1, 0, 0, 0.5f);
                Gizmos.DrawCube(worldPos, new Vector3(FOG_TILE_SIZE, 0f, FOG_TILE_SIZE));
            }
        }

        if (fogGameObject != null && Selection.Contains(fogGameObject))
        {
            DrawFogOutline();
        }
    }

    private void OnDrawGizmosSelected()
    {
        DrawFogOutline();
    }

    private void DrawFogOutline()
    {
        Gizmos.color = Color.magenta;
        foreach (int id in unlockFogIdSet)
        {
            Vector3 worldPos = FogIdToWorldPos(id);
            // left
            if (!unlockFogIdSet.Contains(id - 1))
            {
                Vector3 from = worldPos + new Vector3(-1, 0, -1) * FOG_TILE_SIZE / 2;
                Vector3 to = worldPos + new Vector3(-1, 0, 1) * FOG_TILE_SIZE / 2;
                Gizmos.DrawLine(from, to);
            }
            // right
            if (!unlockFogIdSet.Contains(id + 1))
            {
                Vector3 from = worldPos + new Vector3(1, 0, -1) * FOG_TILE_SIZE / 2;
                Vector3 to = worldPos + new Vector3(1, 0, 1) * FOG_TILE_SIZE / 2;
                Gizmos.DrawLine(from, to);
            }
            // bottom
            if (!unlockFogIdSet.Contains(id - FOG_TILE_COUNT))
            {
                Vector3 from = worldPos + new Vector3(-1, 0, -1) * FOG_TILE_SIZE / 2;
                Vector3 to = worldPos + new Vector3(1, 0, -1) * FOG_TILE_SIZE / 2;
                Gizmos.DrawLine(from, to);
            }
            // top
            if (!unlockFogIdSet.Contains(id + FOG_TILE_COUNT))
            {
                Vector3 from = worldPos + new Vector3(-1, 0, 1) * FOG_TILE_SIZE / 2;
                Vector3 to = worldPos + new Vector3(1, 0, 1) * FOG_TILE_SIZE / 2;
                Gizmos.DrawLine(from, to);
            }
        }
    }

    private void OnTilemapTileChanged(Tilemap tilemap, Tilemap.SyncTile[] syncTiles)
    {
        if (fogGameObject != null && fogGameObject.GetComponent<Tilemap>() == tilemap)
        {
            Refresh();
        }
    }

    [HorizontalGroup("showFogInEditor")]
    [Button("创建迷雾")]
    private void CreateFogTilemap()
    {
        UnityEditor.SceneManagement.PrefabStage prefabStage = UnityEditor.SceneManagement.PrefabStageUtility.GetCurrentPrefabStage();
        if (prefabStage == null)
        {
            return;
        }
        Transform root = prefabStage.prefabContentsRoot.transform;
        Grid grid = root.GetComponentInChildren<Grid>(true);
        if (grid == null)
        {
            GameObject gridPrefab = AssetDatabase.LoadAssetAtPath<GameObject>("Assets/_Art/Map/APS_PVE/PveFog/PveFogGrid.prefab");
            GameObject gridGo = Instantiate(gridPrefab, root);
            grid = gridGo.GetComponent<Grid>();
            gridGo.name = "PveFogGrid";
            gridGo.transform.localPosition.Set(0, 0, 0);
        }
        
        GameObject fogPrefab = AssetDatabase.LoadAssetAtPath<GameObject>("Assets/_Art/Map/APS_PVE/PveFog/PveFogTilemap.prefab");
        GameObject fogGo = Instantiate(fogPrefab, grid.transform);
        fogGo.name = triggerId != "" ? $"Fog ({triggerId})" : "Fog";
        fogGo.transform.localPosition.Set(0, 0, 0);
        fogGameObject = fogGo;
        
        EditFogTilemap();
    }

    [HorizontalGroup("showFogInEditor")]
    [Button("编辑迷雾")]
    private void EditFogTilemap()
    {
        if (fogGameObject == null)
        {
            CreateFogTilemap();
            return;
        }
        
        UnityEditor.SceneManagement.PrefabStage prefabStage = UnityEditor.SceneManagement.PrefabStageUtility.GetCurrentPrefabStage();
        if (prefabStage == null)
        {
            return;
        }
        Transform root = prefabStage.prefabContentsRoot.transform;
        Grid grid = root.GetComponentInChildren<Grid>(true);
        if (grid != null)
        {
            Tilemap[] tilemaps = grid.GetComponentsInChildren<Tilemap>(true);
            foreach (Tilemap tilemap in tilemaps)
            {
                tilemap.gameObject.SetActive(tilemap.gameObject == fogGameObject);
            }
        }
        
        showFogInEditor = true;
        Selection.activeGameObject = fogGameObject;
        Tools.current = Tool.Custom;
    }

    /**
     * Utils
     */
    
    private Vector3 FogIdToWorldPos(int fogId)
    {
        int fogX = (fogId - 1) % FOG_TILE_COUNT;
        int fogY = (fogId - 1) / FOG_TILE_COUNT;
        float x = (fogX + 0.5f) * FOG_TILE_SIZE;
        float z = (fogY + 0.5f) * FOG_TILE_SIZE;
        return new Vector3(x, 0, z);
    }

    private int WorldPosToFogId(Vector3 worldPos)
    {
        float x = worldPos.x;
        float z = worldPos.z;
        int fogX = Mathf.RoundToInt(x / FOG_TILE_SIZE - 0.5f);
        int fogY = Mathf.RoundToInt(z / FOG_TILE_SIZE - 0.5f);
        return fogX + fogY * FOG_TILE_COUNT + 1;
    }
#endif
}