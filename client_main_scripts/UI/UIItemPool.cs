using System;
using UnityEngine;
using UnityEngine.UI;
using UnityGameFramework.Runtime;

[Serializable]
public class UIItemPool : MonoBehaviour
{

    [SerializeField]
    private string uiName;
    public string UIName
    {
        get
        {
            return uiName;
        }
    }

    [SerializeField]
    private string atlasName;
    public string AtlasName
    {
        get
        {
            return atlasName;
        }
    }

    [SerializeField]
    private string atlasPath;

    [SerializeField]
    private string spriteName;
    public string SpriteName
    {
        get
        {
            return spriteName;
        }
    }

    [SerializeField]
    private string spritePath;

    [SerializeField]
    private ResType resType;
    private GameObject templateGO;
    private bool loading = false;
    private bool fail = false;
    private Action<GameObject> successHandle;
    private VEngine.Asset assetRequest;

    private void Awake()
    {
        if (resType == ResType.Prefab)
        {
            TryGetGameObject();
        }
    }

    public void TryGetSprite(Image image, string spriteName)
    {
        fail = true;
        image.LoadSprite(spriteName);
    }

    public void TryGetSprite(Action<Sprite> callback)
    {
        TryGetSprite(callback, this.spriteName);
    }

    public void TryGetSprite(Action<Sprite> callback, string spriteName)
    {
        if (string.IsNullOrEmpty(spriteName))
        {
            return;
        }

        if (string.IsNullOrEmpty(AtlasName))
        {
            return;
        }

        fail = true;

        //ResourceUtils.LoadSpriteFromSpriteAtlas(AtlasName, spriteName, null, (atlas, sprite) =>
        //{
        //    callback?.Invoke(sprite);
        //    fail = false;
        //});
    }

    /// <summary>
    /// 异步，尝试获得Gamobject ，如果有此对象就直接返回 ，没有就回调
    /// </summary>
    /// <param name="action">Action 获得Gameobject的回调</param>
    public void TryGetGameObject(Action<GameObject> action = null)
    {

        if (fail)
        {
            return;
        }

        if (templateGO != null)
        {
            action?.Invoke(templateGO);
        }
        else
        {
            successHandle += action;
            GetTemplate(uiName);
        }
    }

    public void RemoveSccessHandle(Action<GameObject> action)
    {
        if (action == null)
        {
            return;
        }

        if (successHandle != null)
        {
            successHandle -= action;
        }
    }

    private void GetTemplate(string AssetName)
    {
        if (!loading)
        {
            loading = true;
            assetRequest = GameEntry.Resource.LoadAssetAsync(AssetName, typeof(GameObject));
            assetRequest.completed += delegate
            {
                if (!assetRequest.isError)
                {
                    LoadUIFormSuccessCallback(AssetName, assetRequest.asset, 0, null);
                }
                else
                {
                    LoadUIFormFailureCallback(AssetName, assetRequest.error, null);
                }
            };
        }
    }

    private void LoadUIFormSuccessCallback(string uiFormAssetName, object uiFormAsset, float duration, object userData)
    {
        templateGO = (GameObject)uiFormAsset;
        loading = false;
        successHandle?.Invoke(templateGO);
    }

    private void LoadUIFormFailureCallback(string uiFormAssetName, string errorMessage, object userData)
    {
        loading = false;
        fail = true;
    }

    private void OnDestroy()
    {
		DoDestroy();
	}

	protected virtual void DoDestroy()
	{
		if (resType == ResType.Prefab && assetRequest != null)
		{
            assetRequest.Release();
		}

		if ((resType == ResType.Atlas || resType == ResType.Sprite) && !string.IsNullOrEmpty(atlasName))
		{
			//ResourceUtils.UnloadSpriteAtlas(atlasName);
		}
	}
}
