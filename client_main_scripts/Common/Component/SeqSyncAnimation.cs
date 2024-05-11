using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using System;
using System.Threading.Tasks;
using System.Threading;

public class SeqSyncAnimation : MonoBehaviour
{
    public Sprite[] sprites = new Sprite[34];
    private Image image;
    private int index = 0;
    public int SleepTime = 30;
    private void Awake()
    {
        image = GetComponent<Image>();
        ComputeAsync();
    }

    async void ComputeAsync()
    {
  
        await System.Threading.Tasks.Task.Run(() =>
        {
            for (int i = 0; i < 10000; i++)
            {
                //image.sprite = sprites[index];
                index++;
                if (index == sprites.Length)
                {
                    index = 0;
                }

                Thread.Sleep(SleepTime);
            }
    
        });
    }

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        image.sprite = sprites[index];
    }
}
