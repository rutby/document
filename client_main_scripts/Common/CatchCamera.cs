using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CatchCamera : MonoBehaviour
{
    public RenderTexture texture;
    public Texture2D texture2D;
    public new Camera camera;

    [Sirenix.OdinInspector.Button(Sirenix.OdinInspector.ButtonSizes.Large)]
    void Export()
    {
        texture = camera.targetTexture;
        RenderTexture currentActiveRT = RenderTexture.active;
        RenderTexture.active = texture;
        texture2D = new Texture2D(texture.width, texture.height, TextureFormat.ARGB32, false);
        texture2D.ReadPixels(new Rect(0, 0, texture.width, texture.height), 0, 0);
        var bytes = texture2D.EncodeToPNG();
        System.IO.File.WriteAllBytes("Assets/Main/Scenes/LandGrid.png", bytes);
        RenderTexture.active = currentActiveRT;
    }
}