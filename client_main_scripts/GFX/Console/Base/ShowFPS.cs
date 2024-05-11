using UnityEngine;

public class ShowFPS : MonoBehaviour 
{
    private float updateInterval = 1F;
    private double lastInterval;
    private int frames = 0;
    private int fps;
    private GUIStyle textStyle;
    void Start() 
    {
        lastInterval = Time.realtimeSinceStartup;
        frames = 0;
    }
    void OnGUI() 
    {
        if (textStyle == null)
        {
            textStyle = new GUIStyle();
            textStyle.normal.textColor = Color.green;
            textStyle.fontSize = 35;
        }
        GUILayout.Label("FPS:"+fps, textStyle);
    }
    void Update() 
    {
        ++frames;
        float timeNow = Time.realtimeSinceStartup;
        if (timeNow > lastInterval + updateInterval) {
            fps = (int) (frames / (timeNow - lastInterval));
            frames = 0;
            lastInterval = timeNow;
        }
    }
}