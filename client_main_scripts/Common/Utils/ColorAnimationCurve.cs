using UnityEngine;

public class ColorAnimationCurve
{
    private AnimationCurve[] curves;

    public ColorAnimationCurve()
    {
        curves = new AnimationCurve[4];
        for (int i = 0; i < curves.Length; i++)
        {
            curves[i] = new AnimationCurve();
        }
    }

    public void AddKey(float time, Color color)
    {
        curves[0].AddKey(time, color.r);
        curves[1].AddKey(time, color.g);
        curves[2].AddKey(time, color.b);
        curves[3].AddKey(time, color.a);
    }

    public Color Evaluate(float time)
    {
        var color = new Color();
        color.r = curves[0].Evaluate(time);
        color.g = curves[1].Evaluate(time);
        color.b = curves[2].Evaluate(time);
        color.a = curves[3].Evaluate(time);

        return color;
    }
}