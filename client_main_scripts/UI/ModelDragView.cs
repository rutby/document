using BitBenderGames;
using UnityEngine;

public class ModelDragView : MonoBehaviour
{
    public bool allowUserInput = true; // set this to false to prevent the user from dragging the view
    public float sensitivity = 30.0f;
    public float dragAcceleration = 40.0f;
    public float dragDeceleration = 15.0f;
    public bool reverseControls = false;

    private TouchInputController touchInput;
    private Transform cachedTransform;
    private Vector2 angularVelocity = Vector2.zero;
    private Quaternion rotation;
    private bool isDragging = false;
    private Vector3 lastDragPos;
    private Vector3 deltaMove;

    private void Awake()
    {
        cachedTransform = transform;
        touchInput = GetComponent<TouchInputController>();
        touchInput.OnDragStart += OnDragStart;
        touchInput.OnDragUpdate += OnDrag;
        touchInput.OnDragStop += OnDragStop;
        rotation = cachedTransform.rotation;
    }

    private void OnDisable()
    {
        ResetRotation();
    }

    private void OnDragStart(Vector3 pos, bool isLongTap)
    {
        lastDragPos = pos;
    }

    private void OnDragStop(Vector3 dragStopPos, Vector3 dragFinalMomentum)
    {
        isDragging = false;
    }
    
    private void OnDrag(Vector3 dragPosStart, Vector3 dragPosCurrent, Vector3 correctionOffset)
    {
        if (allowUserInput)
        {
            isDragging = true;
            deltaMove = dragPosCurrent - lastDragPos;
            lastDragPos = dragPosCurrent;
        }
        else
        {
            isDragging = false;
        }
    }

    private void Update()
    {
        UpdateDrag();
    }

    private void UpdateDrag()
    {
        Vector3 localAngles = transform.localEulerAngles;
        Vector2 idealAngularVelocity = Vector2.zero;

        float accel = dragDeceleration;

        if (isDragging)
        {
            idealAngularVelocity = sensitivity * new Vector2(deltaMove.x, deltaMove.y);
            accel = dragAcceleration;
        }

        angularVelocity = Vector2.Lerp(angularVelocity, idealAngularVelocity, Time.deltaTime * accel);
        Vector2 angularMove = Time.deltaTime * angularVelocity;

        if (reverseControls)
        {
            angularMove = -angularMove;
        }

        // yaw angle
        localAngles.y -= angularMove.x;

        // apply
        transform.localEulerAngles = localAngles;
    }

    public void ResetRotation()
    {
        cachedTransform.rotation = rotation;
    }
}