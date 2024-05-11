using System.Collections.Generic;
using UnityEngine;

// 已废弃，使用 WayPointEdit
public class WayPointSimple : MonoBehaviour
{
    public List<WayPointSimple> Neighbors = new List<WayPointSimple>();
    public bool IsDoor = false;
    public bool IsEnter = false;
    public bool IsExit = false;
    public bool IsHuntPoint = false;
    public bool IsSpecial = false;
}
