using System.Linq;
using UnityEngine;

public class WorldTroopLine : MonoBehaviour
{
    [SerializeField]
    private LineRenderer lineRenderer;

    [SerializeField]
    private SpriteRenderer lineStart;

    [SerializeField]
    private SpriteRenderer lineEnd;

    private int pathIndex = -1;
    private Vector3[] dragPath = new Vector3[2];

    private string cachePathStr = "";

    private WorldTroopPathSegment[] curPath;
    //public const float FadeTime = 0.5f;
    //private Color color = Color.white;
    //private float fadeTimer;
    //private STATE state;
    //目标点选中特效
    [SerializeField]
    private GameObject destEffectObject;
    
    private WorldTroopPathSegment[] pathList;
    private int curPathIndex;
    private float curPathLen;
    private float moveSpeed;
    private Vector3 moveDir;
    private int targetPos;
    private Vector3 position;
    private int realTPos;//用于划线真实落点
    private long endTime;
    private long marchUuid;
    private long blackStartTime;
    private long blackEndTime;
    private long startTime;
    private bool useUpdate = false;
    public void Clear()
    {
        pathIndex = -1;
        dragPath[0] = Vector3.zero;
        dragPath[0] = Vector3.zero;
        lineRenderer.positionCount = 0;
        if (lineEnd != null)
        {
            lineEnd.gameObject.SetActive(false);
        }
    }

    public void FadeIn()
    {
        //state = STATE.FADE_IN;
    }

    public void FadeOut()
    {
        //state = STATE.FADE_OUT;
    }

    public bool IsFadeOutFinish()
    {
        return true;
    }

    public void SetDragPath(Vector3 start, Vector3 end)
    {
        if (lineStart != null)
        {
            lineStart.transform.position = start;
        }

        if (lineEnd != null)
        {
            lineEnd.gameObject.SetActive(true);
            lineEnd.transform.position = end;
        }

        dragPath[0] = end;
        dragPath[1] = start;
        lineRenderer.positionCount = 2;
        lineRenderer.SetPositions(dragPath);
        //if(destEffectObject.activeSelf)
        //{
        //    destEffectObject.SetActive(false);
        //}
    }

    public void SetMovePath(WorldTroopPathSegment[] path, int currPath, Vector3 currPos,int realTargetPos = 0,bool needRefresh =false)
    {
        if (path == null || path.Length == 0)
            return;

        currPos.y = 0.05f;
        if (pathIndex == currPath && needRefresh ==false)
        {
            lineRenderer.SetPosition(0, currPos);
        }
        else
        {
            pathIndex = currPath;
            
            if (lineStart != null)
            {
                lineStart.transform.position = currPos;
            }

            if (realTargetPos > 0)
            {
                var endPos = SceneManager.World.TileIndexToWorld(realTargetPos);
                endPos.y = 0.05f;
                if (lineEnd != null)
                {
                    lineEnd.gameObject.SetActive(true);
                    lineEnd.transform.position = endPos;
                }

                int count = path.Length - currPath + 1 ;
                lineRenderer.positionCount = count;
                if (count > 1)
                {
                    lineRenderer.SetPosition(0, currPos);
                    for (int i = currPath + 1; i < path.Length; i++)
                    {
                        path[i].pos.y = 0.05f;
                        lineRenderer.SetPosition(i - currPath, path[i].pos);
                    }

                    endPos.y = 0.05f;
                    lineRenderer.SetPosition(count-1, endPos);
                }
            }
            else
            {
                if (lineEnd != null)
                {
                    lineEnd.gameObject.SetActive(true);
                    path[path.Length - 1].pos.y = 0.05f;
                    lineEnd.transform.position = path[path.Length - 1].pos;
                }

                int count = path.Length - currPath;
                lineRenderer.positionCount = count;
                if (count > 0)
                {
                    lineRenderer.SetPosition(0, currPos);
                    for (int i = currPath + 1; i < path.Length; i++)
                    {
                        path[i].pos.y = 0.05f;
                        lineRenderer.SetPosition(i - currPath, path[i].pos);
                    }
                }
            }
            
        }
    }

    public void StartMove(int tarPos,string strPath,float speed,long blackST,long blackET,long sTime,long eTime,int realTargetPos)
    {
        useUpdate = true;
        long serverNow = GameEntry.Timer.GetServerTime();
        pathList = CreatePathSegment(strPath);
        moveSpeed = speed*SceneManager.World.TileSize;
        targetPos = tarPos;
        blackStartTime = blackST;
        blackEndTime = blackET;
        startTime = sTime;
        realTPos = realTargetPos;
        //到现在走了多少距离
        if (blackEndTime > 0 && blackStartTime > 0)
        {
            // 如果没进入黑土地
            if (serverNow <= blackStartTime)
            {
                curPathLen  = moveSpeed * (serverNow - startTime) * 0.001f;
            }
            // 如果没出黑土地
            else if (serverNow <= blackEndTime)
            {
                curPathLen  = moveSpeed * (blackStartTime - startTime) * 0.001f;
                curPathLen += moveSpeed * (serverNow - blackStartTime) * 0.001f*SceneManager.World.BlackLandSpeed;
            }
            //已经出黑土地
            else
            {
                curPathLen  = moveSpeed* (blackStartTime - startTime) * 0.001f;
                curPathLen += moveSpeed * (blackEndTime - blackStartTime) * 0.001f*SceneManager.World.BlackLandSpeed;
                curPathLen += moveSpeed* (serverNow - blackEndTime) * 0.001f;
            }
        }
        else
        {
            curPathLen = moveSpeed * (serverNow - startTime) * 0.001f;
        }
        if (pathList != null && pathList.Length > 1)
        {
            CalcMoveOnPath(pathList, 0, curPathLen, out curPathIndex, out _, out position);
            if (curPathIndex >= pathList.Length - 1)
            {
                FinishMove();
                return;
            }
            else
            {
                var moveVec = pathList[curPathIndex + 1].pos - position;
                moveDir = moveVec.normalized;
                curPathLen = moveVec.magnitude;
            }
        }
        SetMovePath(pathList, curPathIndex, position, realTPos, true);
        
    }
    private void CalcMoveOnPath(WorldTroopPathSegment[] path, int startIndex, float startPathLen, out int pathIdx, out float pathLen, out Vector3 pos)
    {
        pathIdx = startIndex;
        pathLen = startPathLen;
        
        while (pathIdx < path.Length && pathLen > path[pathIdx].dist)
        {
            pathLen -= path[pathIdx].dist;
            pathIdx++;
        }

        if (pathIdx < path.Length - 1)
        {
            pos = path[pathIdx].pos + path[pathIdx].dir * pathLen;
        }
        else
        {
            pos = path[path.Length - 1].pos;
        }
    }
    
    public void SetStraightMovePath(Vector3 startPos, Vector3 endPos)
    {
        if (lineStart != null)
        {
            lineStart.transform.position = startPos;
        }

        if (lineEnd != null)
        {
            lineEnd.gameObject.SetActive(true);
            lineEnd.transform.position = endPos;
        }

        if (lineRenderer != null)
        {
            lineRenderer.SetPosition(0, startPos);
            lineRenderer.SetPosition(1, endPos);
        }
    }

    public void SetColor(Color color)
    {
        //this.color = color;
        
        lineRenderer.startColor = color;
        lineRenderer.endColor = color;
        // var mat = lineRenderer.material;
        // mat.color = color;
        if (lineStart != null)
        {
            lineStart.color = color;
        }

        if (lineEnd != null)
        {
            lineEnd.color = color;
        }
        //if(color== Color.green)
        //{
        //    destEffectObject.SetActive(true);

        //}
    }

    private WorldTroopPathSegment[] CreatePathSegment(string strPath)
    {
        var path = strPath.Split(';').Select(a => a.ToInt()).ToArray();
        if (path.Length < 2)
        {
            return null;
        }
        
        var pathList = new WorldTroopPathSegment[path.Length];
        for (int i = 0; i < pathList.Length; i++)
        {
            pathList[i] = new WorldTroopPathSegment();
            if (i < pathList.Length - 1)
            {
                var curPos = SceneManager.World.TileIndexToWorld(path[i]);
                var nextPos = SceneManager.World.TileIndexToWorld(path[i + 1]);
                    
                var pathVec = nextPos - curPos;
                pathList[i].pos = curPos;
                pathList[i].dir = pathVec.normalized;
                pathList[i].dist = pathVec.magnitude; 
            }
            else
            {
                pathList[i].pos = SceneManager.World.TileIndexToWorld(path[i]);
                pathList[i].dir = pathList[i - 1].dir;
                pathList[i].dist = float.MaxValue;
            }
        }

        return pathList;
    }

    private void Update()
    {
        if (!useUpdate)
        {
            return;
        }
        var deltaTime = Time.deltaTime;
        if (pathList == null || curPathIndex >= pathList.Length - 1)
            return;
        if (blackEndTime > 0 && blackStartTime > 0)
        {
            long serverNow = GameEntry.Timer.GetServerTime();
            if ( blackStartTime<=serverNow &&serverNow <= blackEndTime)
            {
                moveSpeed = moveSpeed *SceneManager.World.BlackLandSpeed;
            }
        }
        position += moveDir * moveSpeed * deltaTime;
        curPathLen -= moveSpeed * deltaTime;
        if (curPathLen <= 0)
        {
            if (pathList != null)
            {
                if (curPathIndex >= pathList.Length - 2)
                {
                    curPathLen = 0;
                    FinishMove();
                    return;
                }
                else
                {
                    curPathIndex++;
                    var moveVec = pathList[curPathIndex+1].pos - position;
                    moveDir = moveVec.normalized;
                    curPathLen = moveVec.magnitude;
                }
            }
            else
            {
                FinishMove();
                return;
            }
        }
        SetMovePath(pathList, curPathIndex, position, realTPos, false);
    }
    private void FinishMove()
    {
        Clear();
        pathList = null;
        useUpdate = false;
    }
    /*
    private void Update()
    {
        // 渐隐
        if (state == STATE.FADE_OUT)
        {
            color.a = 1f - fadeTimer / FadeTime;
            if (color.a <= 0f)
            {
                color.a = 0f;
                state = STATE.NORMAL;
            }

            SetColor(color);
            fadeTimer += Time.deltaTime;
        }
        // 渐显
        else if (state == STATE.FADE_IN)
        {
            color.a = fadeTimer / FadeTime;
            if (color.a >= 1f)
            {
                color.a = 1f;
                state = STATE.NORMAL;
            }

            SetColor(color);
            fadeTimer += Time.deltaTime;
        }
    }

    private enum STATE
    {
        NORMAL,
        FADE_OUT,
        FADE_IN
    }
    */
}