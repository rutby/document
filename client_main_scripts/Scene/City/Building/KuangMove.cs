using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class KuangMove : MonoBehaviour {

    // Use this for initialization
    public float speed = 0.5f;
    public float addvalue;
    private Vector3 currentscale;

	void Start () {
        currentscale = transform.localScale;
	}
	
	// Update is called once per frame
	void Update () 
    {
        float f = Mathf.PingPong(Time.time * speed, addvalue);
        Vector3 scale = new Vector3(f,f,0);
        transform.localScale = currentscale+scale;
	}
}
