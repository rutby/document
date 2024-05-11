using UnityEngine;

public class AutoFaceToCamera : MonoBehaviour
{
    private Quaternion _quaternion;

    private void Awake()
    {
        _quaternion = Quaternion.identity;
    }

    private void OnEnable()
    {
        SceneManager.World?.AddAutoFace(this);
    }

    private void OnDisable()
    {
        SceneManager.World?.RemoveAutoFace(this);
    }

    private void RefreshRotate(Camera mainCamera)
    {
        Quaternion rotation = mainCamera.transform.rotation;
        if (rotation != _quaternion)
        {
            _quaternion = rotation;
            transform.rotation = _quaternion;
        }
    }

    public void OnUpdate(Camera mainCamera)
    {
        RefreshRotate(mainCamera);
    }
}
