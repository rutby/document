using System.Collections.Generic;
using System.IO;
using System.Xml;
using Unity.Mathematics;
using UnityEngine;

public class WorldSceneDesc
{
    public class ObjectDesc
    {
        public int id;
        public int type;
        public Vector3 localPos;
        public Vector3 rotation;
        public Vector3 scale;
        public string assetPath;
        public int assetGuid;
        public bool isStatic;
        public float distance;

        public Vector2Int worldDecorationTilePos;

        public int4 worldDecorationTileRect; //(xMin, yMin, xMax. yMax)

        public void Load(BinaryReader reader)
        {
            id = reader.ReadInt16();
            type = reader.ReadInt16();
            //isStatic = reader.ReadByte() == 1;
            localPos = new Vector3(reader.ReadSingle(), reader.ReadSingle(), reader.ReadSingle());
            rotation = new Vector3(reader.ReadSingle(), reader.ReadSingle(), reader.ReadSingle());
            scale = new Vector3(reader.ReadSingle(), reader.ReadSingle(), reader.ReadSingle());
            //assetPath = reader.ReadString();
            assetPath = reader.ReadString().Replace("_Art_LastWar", "_Art"); // TODO: Beef
        }
        
        public void LoadWorldOptimize(BinaryReader reader, int extends)
        {
            id = reader.ReadInt16();
            type = 0;
            localPos = new Vector3(reader.ReadSingle(), 0, reader.ReadSingle());
            rotation = new Vector3(0, reader.ReadSingle(), 0);
            scale = Vector3.one * reader.ReadSingle();
            assetGuid = reader.ReadInt16();
            int tileX = reader.ReadInt16();
            int tileY = reader.ReadInt16();
            worldDecorationTilePos = new Vector2Int(tileX, tileY);
            worldDecorationTileRect = new int4(tileX - extends, tileY - extends,
                tileX + extends,
                tileY + extends);
        }

        public void Save(BinaryWriter writer)
        {
            writer.Write((short)id);
            writer.Write((short)type);
            //writer.Write((byte)(isStatic ? 1 : 0));
            writer.Write(localPos.x);
            writer.Write(localPos.y);
            writer.Write(localPos.z);
            writer.Write(rotation.x);
            writer.Write(rotation.y);
            writer.Write(rotation.z);
            writer.Write(scale.x);
            writer.Write(scale.y);
            writer.Write(scale.z);
            writer.Write(assetPath);
        }
        
        public void SaveWorldOptimize(BinaryWriter writer)
        {
            writer.Write((short)id);
            //都是StaticObjectType.Decorate装饰物类型，不需要存储
            // writer.Write((short)type);
            //writer.Write((byte)(isStatic ? 1 : 0));
            writer.Write(localPos.x);
            //y都是0，不存储
            // writer.Write(localPos.y);
            writer.Write(localPos.z);
            //rotation x、z都是0， 不存储
            // writer.Write(rotation.x);
            writer.Write(rotation.y);
            // writer.Write(rotation.z);
            writer.Write(scale.x);
            //scale要求等比缩放
            // writer.Write(scale.y);
            // writer.Write(scale.z);
            writer.Write((short)assetGuid);
            //存储guid，不存path
            // writer.Write(assetPath);
            writer.Write((short)worldDecorationTilePos.x);
            writer.Write((short)worldDecorationTilePos.y);
        }

        public void SaveXml(XmlDocument doc, XmlNode parent)
        {
            var objDesc = doc.CreateElement("Object");
            parent.AppendChild(objDesc);

            objDesc.SetAttribute("id", id.ToString());
            objDesc.SetAttribute("type", type.ToString());
            objDesc.SetAttribute("T", string.Format("{0} {1} {2}", localPos.x, localPos.y, localPos.z));
            objDesc.SetAttribute("R", string.Format("{0} {1} {2}", rotation.x, rotation.y, rotation.z));
            objDesc.SetAttribute("S", string.Format("{0} {1} {2}", scale.x, scale.y, scale.z));
            objDesc.SetAttribute("path", assetPath);
        }
    }

    public class GridDesc
    {
        public int width;
        public int height;
        public byte[] grids;

        public void Load(BinaryReader reader)
        {
            width = reader.ReadInt32();
            height = reader.ReadInt32();
            
            int len = reader.ReadInt32();
            if (len > 0)
            {
                var gs = reader.ReadBytes(len);
                grids = new byte[width * height];
                for (int i = 0; i < grids.Length; i++)
                {
                    int x = i / 8;
                    int y = i % 8;
                    grids[i] = (byte)((gs[x] & (1 << y)) == 0 ? 0 : 1);
                }
            }
        }

        public void Save(BinaryWriter writer)
        {
            writer.Write(width);
            writer.Write(height);
            if (grids != null && grids.Length > 0)
            {
                int len = (grids.Length + 7) / 8;
                writer.Write(len);

                var gs = new byte[len];
                for (int i = 0; i < grids.Length; i++)
                {
                    if (grids[i] != 0)
                    {
                        int x = i / 8;
                        int y = i % 8;
                        byte b = (byte)(1 << y);
                        gs[x] = (byte)(gs[x] | b);
                    }
                }
                
                writer.Write(gs);
            }
            else
            {
                writer.Write(0);
            }
        }

        public void SaveXml(XmlDocument doc, XmlNode parent)
        {
            var mapGrids = doc.CreateElement("MapGridList");
            mapGrids.SetAttribute("width", width.ToString());
            mapGrids.SetAttribute("height", height.ToString());
            parent.AppendChild(mapGrids);

            if (grids != null)
            {
                for (int i = 0; i < grids.Length; i++)
                {
                    if (grids[i] != 0)
                    {
                        var g = doc.CreateElement("G");
                        g.SetAttribute("x", (i % width).ToString());
                        g.SetAttribute("y", (i / width).ToString());
                        g.SetAttribute("walkable", grids[i] == 0 ? "1" : "0");
                        mapGrids.AppendChild(g);
                    }
                }
            }
        }
    }

    public const string WorldDescPath = "Assets/Main/Scenes/WorldSceneDesc.bytes";
    public const string WorldDescXmlPath = "Assets/Main/Scenes/WorldSceneDesc.xml";
    public const string WorldEdenDescPath = "Assets/Main/Scenes/WorldEdenSceneDesc.bytes";
    public const string WorldEdenDescXmlPath = "Assets/Main/Scenes/WorldEdenSceneDesc.xml";
    public const string WorldAllianceCityDescPath = "Assets/Main/Scenes/WorldSceneAllianceCityDesc.bytes";
    public const string WorldAllianceCityDescXmlPath = "Assets/Main/Scenes/WorldSceneAllianceCityDesc.xml";
    
    public const string CityDescPath = "Assets/Main/Scenes/CitySceneDesc.bytes";
    public const string CityDescXmlPath = "Assets/Main/Scenes/CitySceneDesc.xml";
    
    private List<ObjectDesc> _objectDescs = new List<ObjectDesc>();
    private GridDesc _gridDesc = new GridDesc();
    
    public List<ObjectDesc> objectDescs
    {
        get { return _objectDescs; }
    }

    public GridDesc gridDesc
    {
        get { return _gridDesc; }
    }

    public void Load(byte[] data)
    {
        if (data == null || data.Length == 0)
            return;
        
        using (var reader = new BinaryReader(new MemoryStream(data)))
        {
            int count = reader.ReadInt32();
            for (int i = 0; i < count; i++)
            {
                var objDesc = new ObjectDesc();
                objDesc.Load(reader);
                _objectDescs.Add(objDesc);
            }
            
            _gridDesc.Load(reader);
        }
    }

    public List<ObjectDesc> LoadWithReturn(byte[] data)
    {
        List<ObjectDesc> list = new List<ObjectDesc>();
        if (data == null || data.Length == 0)
            return list;
        using (var reader = new BinaryReader(new MemoryStream(data)))
        {
            int count = reader.ReadInt32();
            for (int i = 0; i < count; i++)
            {
                var objDesc = new ObjectDesc();
                objDesc.Load(reader);
                _objectDescs.Add(objDesc);
                list.Add(objDesc);
            }
            
            _gridDesc.Load(reader);
        }

        return list;
    }
    
    public void Save(string savePath)
    {
        using (var writer = new BinaryWriter(File.Create(savePath)))
        {
            int count = _objectDescs.Count;
            writer.Write(count);
            for (int i = 0; i < count; i++)
            {
                _objectDescs[i].Save(writer);
            }
            _gridDesc.Save(writer);
        }
    }

    public void SaveXml(string savePath)
    {
        XmlDocument doc = new XmlDocument();
        var decl = doc.CreateXmlDeclaration("1.0", "UTF-8", "yes");
        doc.AppendChild(decl);

        var root = doc.CreateElement("WorldSceneDesc");
        doc.AppendChild(root);
        
        var objDescList = doc.CreateElement("ObjectList");
        root.AppendChild(objDescList);
        for (int i = 0; i < _objectDescs.Count; i++)
        {
            _objectDescs[i].SaveXml(doc, objDescList);
        }
        
        _gridDesc.SaveXml(doc, root);
        
        doc.Save(savePath);
    }

}