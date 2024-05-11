using BitBenderGames;
using UnityEngine;

public class AutoAdjustScale : MonoBehaviourWrapped
{
    [SerializeField] private float minScale = 0;
    [SerializeField] private float maxScale = 10000;
    [SerializeField] private float DefaultScale = 3.2f / 23.4f; // Scale / Z_Disttance

    private void OnEnable()
    {
        SceneManager.World?.AddAutoScale(this);
    }

    private void OnDisable()
    {
        SceneManager.World?.RemoveAutoScale(this);
    }

    private void RefreshScale(Camera mainCamera)
    {
        Vector3 pos = mainCamera.transform.worldToLocalMatrix.MultiplyPoint3x4(transform.position);
        float scale = Mathf.Clamp(DefaultScale * pos.z, minScale, maxScale);
        var world = SceneManager.World;
        if (minScale<=0 && world != null && world.Zoom <= (world.GetMinLodDistance() * 2))
        {
            scale = 0;
        }
        transform.localScale = new Vector3(scale, scale, scale);
    }

    public void OnUpdate(Camera mainCamera)
    {
        RefreshScale(mainCamera);
    }
}
