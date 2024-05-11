using UnityEngine;

[CreateAssetMenu(fileName = "BuildingRobotCurve", menuName = "ScriptableObjects/BuildingRobotCurve", order = 0)]
public class BuildingRobotCurve : ScriptableObject
{
    // 起飞动画 Y 坐标改变
    public AnimationCurve takeOffPosYCurve;

    // 降落动画 Y 坐标改变
    public AnimationCurve landingPosYCurve;
    
    // 建造移动速度改变
    public AnimationCurve buildingMoveSpeedCurve;

    // 前往目标Y坐标改变
    public AnimationCurve goTargetPosYCurve;
    
    // 前往目标Y坐标改变
    public AnimationCurve goBackPosYCurve;

    // 到达目标回弹
    public AnimationCurve approachTargetDisCurve;
    
    // 到达无人机中心回弹
    public AnimationCurve approachHomeDisCurve;
}