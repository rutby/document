#if UNITY_EDITOR

using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using Sirenix.OdinInspector;
using UnityEditor;
using UnityEditor.SceneManagement;
using WayPoint = CityResidentPathUtil.WayPoint;

public class WayPointEdit : MonoBehaviour
{
    public int id;
    public List<WayPointEdit> linkPoints = new List<WayPointEdit>();
    public WayPointFlag flag;
    public List<string> args = new List<string>();

    public void Refresh()
    {
        name = id.ToString();
        List<WayPointEdit> newLinkPoints = new List<WayPointEdit>();
        foreach (WayPointEdit point in linkPoints)
        {
            if (point == null)
                continue;
            if (newLinkPoints.Contains(point))
                continue;
            if (transform.parent != point.transform.parent)
                continue;
            // if (!point.linkPoints.Contains(this))
            //     continue;
            newLinkPoints.Add(point);
        }
        linkPoints = newLinkPoints;
    }
    
    private void OnValidate()
    {
        Refresh();
    }

    private Color GetColor()
    {
        Color color;
        if ((flag & WayPointFlag.Center) != 0)
        {
            color = new Color(0.5f, 1, 0.5f);
        }
        else if ((flag & WayPointFlag.SafeHide) != 0)
        {
            color = new Color(0, 0.75f, 0);
        }
        else if ((flag & WayPointFlag.Invade) != 0)
        {
            color = new Color(1, 0, 0);
        }
        else if ((flag & WayPointFlag.Zombie) != 0)
        {
            color = new Color(1, 0, 1);
        }
        else if ((flag & WayPointFlag.ZombieSpawn) != 0)
        {
            color = new Color(0.75f, 0, 0.75f);
        }
        else if ((flag & WayPointFlag.Entrance) != 0 || (flag & WayPointFlag.Exit) != 0)
        {
            color = new Color(0, 1, 1);
        }
        else if ((flag & WayPointFlag.Special) != 0)
        {
            color = new Color(1, 0.5f, 0);
        }
        else if ((flag & WayPointFlag.Hunting) != 0)
        {
            color = new Color(0.75f, 0.75f, 0);
        }
        else if ((flag & WayPointFlag.Chopping) != 0)
        {
            color = new Color(0f, 0.75f, 0.75f);
        }
        else if ((flag & WayPointFlag.Digging) != 0)
        {
            color = new Color(0.25f, 0.5f, 1f);
        }
        else
        {
            color = Color.white;
        }
        return color;
    }

    private void OnDrawGizmos()
    {
        const float sphereRadius = 0.04f;
        const float arrowAngle = 15f;
        const float arrowSize = 0.1f;
        const int fontSize = 16;
        
        Color color = GetColor();
        foreach (WayPointEdit point in linkPoints)
        {
            if (point != null)
            {
                if (color == point.GetColor())
                {
                    Gizmos.color = color;
                }
                else
                {
                    Gizmos.color = new Color(0.75f, 0.75f, 0.75f);
                }
                
                Vector3 fPos = transform.position;
                Vector3 tPos = point.transform.position;
                Vector3 dir = (tPos - fPos).normalized;
                Vector3 aDir = Quaternion.AngleAxis(arrowAngle, Vector3.up) * dir;
                Vector3 bDir = Quaternion.AngleAxis(-arrowAngle, Vector3.up) * dir;
                Vector3 aPos = tPos - aDir * arrowSize;
                Vector3 bPos = tPos - bDir * arrowSize;
                Gizmos.DrawLine(fPos, tPos);
                Gizmos.DrawLine(aPos, tPos);
                Gizmos.DrawLine(bPos, tPos);
            }
        }

        Gizmos.color = color;
        Gizmos.DrawSphere(transform.position, sphereRadius);

        string str = name;
        GUIStyle style = new GUIStyle {fontSize = fontSize, normal = new GUIStyleState {textColor = color}};
        if ((flag & WayPointFlag.ZombieSpawn) != 0)
        {
            if (args.Count > 0)
            {
                str = str + "\nSpawn " + args[0];
            }
        }
        Handles.Label(transform.position, str, style);
    }
}

#endif
