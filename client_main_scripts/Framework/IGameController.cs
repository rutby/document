﻿
public interface IGameController
{
    /// <summary>
    /// 游戏框架模块轮询。
    /// </summary>
    /// <param name="elapseSeconds">逻辑流逝时间，以秒为单位。</param>
    /// <param name="realElapseSeconds">真实流逝时间，以秒为单位。</param>
    void OnUpdate(float elapseSeconds);

    /// <summary>
    /// 关闭并清理游戏框架模块。
    /// </summary>
    void Shutdown();
}
