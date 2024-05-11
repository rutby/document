using System.Collections.Generic;
using DG.Tweening;
using GameFramework;
using UnityEngine;

    public class WorldZone
    {
        //public const float ZoneScale = 0.3f;
    
        public int index;
    
        public RectInt rect;
    
        // 城点区域数据
        public WorldZoneData data;
    
        // 区域描边显示对象
        public Transform zoneRoot;
        private SpriteRenderer _zoneState1, _zoneState2; //未占领、已占领
    
        // 区域阴影对象
        public SpriteRenderer shadow;
    

    
        public bool zone_visible;
        public bool zone_loaded;
    
        public bool icon_visible;
        public bool icon_loaded;
    
        public bool edge_visible;
        public bool edge_loaded;
    
        public bool battleNews_visible;
        public bool marchNews_visible;
        public bool cityChangeNews_visible;
    
        public bool finded;
        public int findState = 0;
    
        public Vector3 pos_body;
        public Vector3 pos_cityIcon;
        public Vector3 pos_edge;
    
        
        
        
        private readonly WorldMapZoneManager mapManager;
        // 城点区域边界根对象
        public GameObject edgeRoot;
        private Dictionary<int, GameObject> edgeEntities;
        private static readonly int SolidOutline = Shader.PropertyToID("_SolidOutline");
        private static readonly int BaseAlpha = Shader.PropertyToID("_BaseAlpha");
        private static readonly int SplashTex = Shader.PropertyToID("_SplashTex");
        private static readonly int SplashAlpha = Shader.PropertyToID("_SplashAlpha");
        private static readonly int InnerColor = Shader.PropertyToID("_InnerColor");
        private static readonly int InnerColorIntensity = Shader.PropertyToID("_InnerColorIntensity");
        private static readonly int SplashAngle = Shader.PropertyToID("_Angle");
        private static readonly int SplashTex_ST = Shader.PropertyToID("_SplashTex_ST");
        private static readonly int Outline_Clip = Shader.PropertyToID("_Clip");
        private static readonly int OutLine_Color = Shader.PropertyToID("_OutlineColor");
        private static readonly int Glow_Color = Shader.PropertyToID("_GlowColor");

    public class ZoneColorInfo
    {
        public Color baseColor;
        public Color outLineColor;
        public Color glowColor;


    }
    private List<ZoneColorInfo> zoneColorTestList = new List<ZoneColorInfo>();


        public WorldZone(WorldMapZoneManager manager, WorldZoneData info)
        {

           ZoneColorInfo c = new ZoneColorInfo();
           c.baseColor = new Color(219f / 255f, 146f / 255f, 63f / 255f);
           c.outLineColor = new Color(252f / 255f, 235f / 255f, 88f / 255f);
           c.glowColor = new Color(252f / 255f, 187f / 255f, 74f / 255f);
           zoneColorTestList.Add(c);

            c = new ZoneColorInfo();
            c.baseColor = new Color(217f / 255f,118f / 255f, 77f / 255f);
            c.outLineColor = new Color(255f / 255f, 200f / 255f, 173f / 255f);
            c.glowColor = new Color(248f / 255f, 104f / 255f, 71f / 255f);
            zoneColorTestList.Add(c);


            c = new ZoneColorInfo();
            c.baseColor = new Color(103f / 255f, 172f / 255f, 161f / 255f);
            c.outLineColor = new Color(126f / 255f, 249f / 255f, 253f / 255f);
            c.glowColor = new Color(85f / 255f, 212f / 255f, 201f / 255f);
            zoneColorTestList.Add(c);


            c = new ZoneColorInfo();
            c.baseColor = new Color(163f / 255f, 173f / 255f, 75f / 255f);
            c.outLineColor = new Color(203f / 255f, 250f / 255f, 111f / 255f);
            c.glowColor = new Color(177f / 255f, 227f / 255f, 25f / 255f);
            zoneColorTestList.Add(c);


        mapManager = manager;
            
            index = info.ZoneId;
            rect = new RectInt(info.X, info.Y, info.W, info.H);
            data = info;
            Reset();
        }
    
        public void Reset()
        {
            zone_visible = false;
            zone_loaded = false;
            icon_visible = false;
            icon_loaded = false;
            edge_visible = false;
            edge_loaded = false;
            finded = false;
    
            if (zoneRoot != null)
            {
                Object.Destroy(zoneRoot.gameObject);
                zoneRoot = null;
            }
    
            #if false
            if (cityIcon != null)
            {
                Object.Destroy(cityIcon.gameObject);
                cityIcon = null;
            }
    
            if (edge != null)
            {
                Object.Destroy(edge.gameObject);
                edge = null;
            }
            #endif
        }
    
        public void SetEdgePosition(Vector3 pos)
        {
            pos_edge = pos;
        }

        public void ToggleEdge(bool visible)
        {
            if (edge_visible == visible)
                return;
            
            edge_visible = visible;
            if (visible && !edge_loaded)
            {
                CreateEdge();
            }

            if (edgeRoot != null)
            {
                edgeRoot.gameObject.layer = LayerMask.NameToLayer(visible ? "Hud3D" : "Hide");
            }
        }

        private void CreateEdge()
        {
            var zoneData = data;
            var color = Color.white;
            var matIdx = 0;
            
            //test
            //zoneData.color = Random.Range(1, 13);
            
            var cfg = mapManager.GetWorldCityColor(zoneData.color);
            if (cfg != null)
            {
                matIdx = 1;
                color = cfg.outlineColor;
            }
    
            var useMaterial = mapManager.GetEdgeMaterial(matIdx, color);
                
            edgeRoot = new GameObject($"ZoneEdge{zoneData.ZoneId}");
            edgeRoot.transform.parent = mapManager.EdgeRoot;
            edgeRoot.transform.localScale = Vector3.one;
            edgeRoot.transform.localPosition = Vector3.zero;
            SetEdgePosition(Vector3.zero);
            edge_loaded = true;
    
            // Log.Debug("create Edge id: {0}, edgeCount {1}", zoneData.ZoneId, zoneData.edgeIdList.Count);
            edgeEntities = new Dictionary<int, GameObject>(zoneData.edgeIdList.Count);
            foreach (var side in zoneData.edgeIdList)
            {
                var meshPath = string.Format(WorldMapZoneManager.EdgeMeshPath, zoneData.ZoneId, side);
                if (GameEntry.GlobalData.serverType == (int)ServerType.EDEN_SERVER)
                {
                    meshPath = string.Format(WorldMapZoneManager.EdenEdgeMeshPath, zoneData.ZoneId, side);
                }
                if (! GameEntry.Resource.HasAsset(meshPath))
                {
                    Log.Error($"CreateEdge mesh not found! path:{meshPath}");
                    continue;
                }
    
                var request = GameEntry.Resource.LoadAsset(meshPath, typeof(TextAsset));
                if (request == null)
                {
                    Log.Error($"CreateSubEdge request is null!");
                    continue;
                }
                
                if (request.isError)
                {
                    Log.Error($"CreateSubEdge request.isError! error:{request.error}");
                    continue;
                }
                    
                var asset = request.asset as TextAsset;
                if (asset == null)
                {
                    Log.Error($"CreateEdge mesh asset is null!");
                    continue;
                }
                
                var mesh = MeshSerializer.DeserializeMesh(asset.bytes);

                var name = $"edge_{zoneData.ZoneId}_{side}";
                var subEdgeObj = new GameObject(name, typeof(MeshFilter), typeof(MeshRenderer));
                subEdgeObj.transform.parent = edgeRoot.transform;
                subEdgeObj.transform.localScale = Vector3.one;
                subEdgeObj.transform.localPosition = Vector3.zero;
                var filter = subEdgeObj.transform.GetComponent<MeshFilter>();
                var render = subEdgeObj.transform.GetComponent<MeshRenderer>();
                filter.mesh = mesh;
                render.material = useMaterial;
                
                if (edgeEntities.ContainsKey(side))
                {
                    Log.Error($"CreateEdge duplicate side Error! zoneId:{zoneData.ZoneId}, side:{side}");
                    edgeEntities[side] = subEdgeObj;
                }
                else
                {
                    edgeEntities.Add(side, subEdgeObj);
                }
                
                request.Release();
            }
        }

        public void ToggleZone(bool visible)
        {
            if (zone_visible == visible)
                return;
            
            zone_visible = visible;
            if (visible && !zone_loaded)
            {
                CreateZone();
            }

            if (zoneRoot != null)
            {
                //body.transform.localPosition = visible ? pos_body : FarPos;
                zoneRoot.gameObject.layer = LayerMask.NameToLayer(visible ? "Hud3D" : "Hide");
            }
        }

        private void CreateZone()
        {
            var zoneData = data;

            // var offX = zoneData.W * 0.5f;
            // var offY = zoneData.H * 0.5f;

            var v = mapManager.GetZoneRect(zoneData.ZoneId);
            var x = v[0];
            var y = v[1];
            var w = v[2];
            var h = v[3];
            
            var x1 = x + w * 0.5f;
            var y1 = y - h * 0.5f;
            
            zoneRoot = Object.Instantiate(mapManager.ZoneTemplate, mapManager.ZoneRoot, true);
            zoneRoot.gameObject.name = $"Zone_{zoneData.ZoneId}";
            zoneRoot.transform.localScale = Vector3.one; //Vector3.one * mapManager.GetZoneScale();
            zoneRoot.gameObject.layer = LayerMask.NameToLayer("Hud3D");
            zoneRoot.localRotation = Quaternion.Euler(0, 0, 0);
            zoneRoot.localPosition = new Vector3(x1, y1, 0) * 0.01f;  //new Vector3(zoneData.X + offX, -(zoneData.Y + offY), 0) * 0.01f;;
            zoneRoot.gameObject.SetActive(true);
            var imagePath = $"Assets/Main/Scenes/Zone/Image/zone_{zoneData.ZoneId}.png";
            if (GameEntry.GlobalData.serverType == (int)ServerType.EDEN_SERVER)
            {
                imagePath = $"Assets/Main/Scenes/EdenZone/Image/zone_{zoneData.ZoneId}.png";
            }
            
            
            _zoneState1 = zoneRoot.Find("State1").GetComponent<SpriteRenderer>();
            _zoneState2 = zoneRoot.Find("State2").GetComponent<SpriteRenderer>();
            _zoneState1.LoadSprite(imagePath);
            _zoneState2.LoadSprite(imagePath);

            var cfg = mapManager.GetWorldCityColor(zoneData.color);
            SetZoneRenderParam(cfg);

            zone_loaded = true;
    
            #if false
            var shadowRt = zoneRt.GetChild(0);
            if (shadowRt)
            { 
                var zoneShadow = shadowRt.GetComponent<SpriteRenderer>();
                if (zoneShadow)
                {
                    zoneShadow.LoadSprite(imagePath);
                }
            }
            #endif
        }

        public void SetEdgeMaterial(int matIdx, Color color)
        {
            var useMaterial = mapManager.GetEdgeMaterial(matIdx, color);
            if (edgeEntities == null) //skip, not create yet
            {
                return;
            }
            
            foreach (var edgeEntity in edgeEntities.Values)
            {
                edgeEntity.TryGetComponent<MeshRenderer>(out var renderer);
                if (renderer)
                {
                    renderer.material = useMaterial;
                }
            }
        }
        
        //设置zoneImage显示
        public void SetZoneRenderParam(WorldCityColor cfg)
        {
            _zoneState1.gameObject.SetActive(cfg == null);
            _zoneState2.gameObject.SetActive(cfg != null);
            
            if (cfg == null) //未占领的地块
            {
                return;
            }

            //Debug.Log("SetZoneRenderParam : {0}, {1}, {2}x{3}", cfg.id, cfg.splashIndex, cfg.splashX, cfg.splashY);

            var material = _zoneState2.material;
            material.SetColor(SolidOutline, cfg.baseColor);
            material.SetColor(OutLine_Color, cfg.outlineColor);
            material.SetColor(Glow_Color, cfg.innerColor);
            
            var splashIndex = cfg.splashIndex;
            if (splashIndex == 0) //纯色不加splash
            {
                material.EnableKeyword("PURE_COLOR");
                //material.SetTexture(SplashTex, null);
            }
            else
            {
                material.DisableKeyword("PURE_COLOR");
                var splashTextures = mapManager.GetTextures();
                material.SetTexture(SplashTex, splashTextures[splashIndex-1]);
            }
            
            // var colorInfo = zoneColorTestList[Random.Range(0, zoneColorTestList.Count)];
            // material.SetColor(OutLine_Color, colorInfo.outLineColor);
            // material.SetColor(Glow_Color, colorInfo.glowColor);
            // material.SetColor(SolidOutline, colorInfo.baseColor);
            // material.SetFloat(BaseAlpha, cfg.baseAlpha);
            // material.SetColor(InnerColor, cfg.innerColor);
            // material.SetFloat(InnerColorIntensity, cfg.innerIntensity);        
            // material.SetFloat(SplashAlpha, cfg.splashAlpha);
            // material.SetFloat(SplashAngle, cfg.splashRot);
            //material.SetVector(SplashTex_ST, new Vector4(cfg.splashX, cfg.splashY, 0, 0));
        }

        public void SetZoneChangeColor(int beforeColorIndex, int afterColorIndex)
        {
            var beforeCfg = mapManager.GetWorldCityColor(beforeColorIndex);
            var afterCfg = mapManager.GetWorldCityColor(afterColorIndex);
            if (afterCfg != null)
            {
                _zoneState1.gameObject.SetActive(false);
                _zoneState2.gameObject.SetActive(true);
                var material = _zoneState2.material;
                var beforeBase = new Color(0.89f, 0.6f, 0.36f, 1);
                var beforeOutLine = new Color(0.89f, 0.6f, 0.36f, 1);
                var beforeInner = new Color(0.89f, 0.6f, 0.36f, 1);
                var afterBase = afterCfg.baseColor;
                var afterOutLine = afterCfg.outlineColor;
                var afterInner = afterCfg.innerColor;
                var splashIndex = afterCfg.splashIndex;
                if (beforeCfg != null)
                {
                    beforeBase = beforeCfg.baseColor;
                    beforeOutLine = beforeCfg.outlineColor;
                    beforeInner = beforeCfg.innerColor;
                }
                if (splashIndex != 0) //纯色不加splash
                {
                    material.EnableKeyword("PURE_COLOR");
                    //material.SetTexture(SplashTex, null);
                }
                var progress = 0f;
                DOTween.To(() => progress, x => progress = x, 1f, 2.5f).OnUpdate(() =>
                {
                    material.SetColor(SolidOutline, Color.Lerp(beforeBase,afterBase,progress));
                    material.SetColor(OutLine_Color, Color.Lerp(beforeOutLine,afterOutLine,progress));
                    material.SetColor(Glow_Color, Color.Lerp(beforeInner,afterInner,progress));
                }).OnComplete(() =>
                {
                    SetZoneRenderParam(mapManager.GetWorldCityColor(data.color));
                    GameEntry.Event.Fire(EventId.UINoInput, 3);
                    GameEntry.Event.Fire(EventId.WorldZoneChangeColorFinish, data.ZoneId.ToInt());
                });
            }
            else
            {
                GameEntry.Event.Fire(EventId.UINoInput, 3);
                GameEntry.Event.Fire(EventId.WorldZoneChangeColorFinish, data.ZoneId.ToInt());
            }
            
        }
    }

    // 简单的四叉树存储
    public class WorldZoneTreeNode
    {
        public RectInt rect;
        public List<WorldZoneTreeNode> nodes = new List<WorldZoneTreeNode>();
        public List<WorldZone> zones = new List<WorldZone>();

        public WorldZoneTreeNode(RectInt rc)
        {
            rect = rc;
        }

        public void CrateSubNodes(int depth)
        {
            int w = Mathf.CeilToInt(rect.width * 0.5f);
            int h = Mathf.CeilToInt(rect.height * 0.5f);
            nodes.Clear();
            nodes.Add(new WorldZoneTreeNode(new RectInt(rect.x, rect.y, w, h)));
            nodes.Add(new WorldZoneTreeNode(new RectInt(rect.x + w, rect.y, w, h)));
            nodes.Add(new WorldZoneTreeNode(new RectInt(rect.x, rect.y + h, w, h)));
            nodes.Add(new WorldZoneTreeNode(new RectInt(rect.x + w, rect.y + h, w, h)));
            if (depth > 0)
            {
                foreach (var node in nodes)
                {
                    node.CrateSubNodes(depth - 1);
                }
            }
        }

        bool IsRectIntersect(RectInt rc1, RectInt rc2)
        {
            if (Mathf.Max(rc1.xMin, rc2.xMin) > Mathf.Min(rc1.xMax, rc2.xMax) ||
                Mathf.Max(rc1.yMin, rc2.yMin) > Mathf.Min(rc1.yMax, rc2.yMax))
                return false;
            return true;
        }

        public void AddZone(WorldZone zone)
        {
            if (nodes.Count > 0)
            {
                for (int i = 0; i < nodes.Count; i++)
                {
                    if (IsRectIntersect(nodes[i].rect, zone.rect))
                    {
                        nodes[i].AddZone(zone);
                    }
                }
            }
            else
            {
                zones.Add(zone);
            }
        }

        public void FindZone(RectInt rect, ref List<WorldZone> findZones, ref int count)
        {
            if (nodes.Count > 0)
            {
                for (int i = 0; i < nodes.Count; i++)
                {
                    count++;
                    if (IsRectIntersect(nodes[i].rect, rect))
                    {
                        nodes[i].FindZone(rect, ref findZones, ref count);
                    }
                }
            }
            else if (zones.Count > 0)
            {
                for (int i = 0; i < zones.Count; i++)
                {
                    if (zones[i].finded)
                        continue;

                    count++;
                    if (IsRectIntersect(zones[i].rect, rect))
                    {
                        zones[i].finded = true;
                        zones[i].findState++;
                        findZones.Add(zones[i]);
                    }
                }
            }
        }

    }
