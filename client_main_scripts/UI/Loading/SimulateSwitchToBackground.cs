using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SimulateSwitchToBackground : MonoBehaviour
{
    void sendApplicationPauseMessage(bool isPause)
    {
        Transform[] transList = GameObject.FindObjectsOfType<Transform>();
        for (int i = 0; i < transList.Length; i++)
        {
            Transform trans = transList[i];
            //Note that messages will not be sent to inactive objects
            trans.SendMessage("OnApplicationPause", isPause, SendMessageOptions.DontRequireReceiver);
        }
    }
    void sendApplicationFocusMessage(bool isFocus)
    {
        Transform[] transList = GameObject.FindObjectsOfType<Transform>();
        for (int i = 0; i < transList.Length; i++)
        {
            Transform trans = transList[i];
            //Note that messages will not be sent to inactive objects
            trans.SendMessage("OnApplicationFocus", isFocus, SendMessageOptions.DontRequireReceiver);
        }
    }

    public void sendEnterBackgroundMessage()
    {
        sendApplicationPauseMessage(true);
        sendApplicationFocusMessage(false);
        Time.timeScale = 0.0f;

    }
    public void sendEnterFoegroundMessage()
    {
        sendApplicationFocusMessage(true);
        sendApplicationPauseMessage(false);
        ApplicationLaunch.Instance.DisconnectRetry();
        Time.timeScale = 1.0f;

    }
}
