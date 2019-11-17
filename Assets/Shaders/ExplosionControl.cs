using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//[ExecuteInEditMode]
public class ExplosionControl : MonoBehaviour {
	public float loopduration = 5;
	public float speed = 0.025f;
	public float length = 1;
	private float time = 0;
	Renderer ren;
	void Awake () => ren = GetComponent<Renderer>();
	void Update () {
		//trying this
		transform.LookAt(Camera.main.transform);
		
		float r = Mathf.Sin((Time.time / loopduration) * (2 * Mathf.PI)) * 0.25f + 0.25f;
		float g = Mathf.Sin((Time.time / loopduration + 0.33333333f) * 2 * Mathf.PI) * 0.25f + 0.25f;
		float b = Mathf.Sin((Time.time / loopduration + 0.66666667f) * 2 * Mathf.PI) * 0.25f + 0.25f;
		float correction = 1 / (r + g + b);
		r *= correction;
		g *= correction;
		b *= correction; 
		ren.sharedMaterial.SetVector("_ChannelFactor", new Vector4(r,g,b,0));
		time+=speed;
		ren.sharedMaterial.SetFloat("_Displacement", time);
		if(time>=length) Destroy(gameObject);
	}
}
