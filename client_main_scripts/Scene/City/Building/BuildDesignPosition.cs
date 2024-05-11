using System;
using UnityEngine;
using System.IO;
using System.Text;


public class BuildDesignPosition : MonoBehaviour
{
    [SerializeField] private Transform _go;
    
    [Sirenix.OdinInspector.Button(Sirenix.OdinInspector.ButtonSizes.Large)]
    public void PositionExport()
    {
        StringBuilder sb = new StringBuilder();
        string filePath = "Temp/build_position.txt";
        Transform use = _go ? _go : transform;
        for (int i = 0; i < use.childCount; ++i)
        {
            Transform tf = use.GetChild(i);
            Vector3 pos = tf.localPosition;
            var x = (float)Math.Round(pos.x, 2);
            var y = (float)Math.Round(pos.y, 2);
            var z = (float)Math.Round(pos.z, 2);
            tf.localPosition = new Vector3(x, y, z);
            sb.Append(tf.name + "," + x + ";" + y + ";" + z + "," + Math.Round(tf.localEulerAngles.y, 2));
            sb.AppendLine();
        }
        File.WriteAllText(filePath, sb.ToString());
    }

}

