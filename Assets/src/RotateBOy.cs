using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotateBOy : MonoBehaviour {

	// Use this for initialization
    public float speed = 0.04f;
    public List<GameObject> child = new List<GameObject>();
	void Start () {
		foreach(GameObject c in child) c.transform.parent = this.gameObject.transform;
	}
	
	// Update is called once per frame
	void Update () {
		transform.RotateAround(Vector3.up, speed);
	}
}
