using System;
using UnityEngine;
 

public enum ResType 
{
	Prefab,
	Atlas,
	Sprite,
}

public enum ReferenceType 
{
    Prefab,
	Atlas,
	Sprite,
}
 
[AttributeUsage(AttributeTargets.Enum | AttributeTargets.Field)]
public sealed class Reference : PropertyAttribute
{
    public ReferenceType RefType { get; private set; }
	[SerializeField]public string Path;
    public Reference(ReferenceType refType)
    {
        RefType = refType;
    }
}