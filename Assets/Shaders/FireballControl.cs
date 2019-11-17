using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FireballControl : MonoBehaviour {
	public float loopduration = 5;
	public float pulseAmount = 0.1F;
	public float pulseOffset = 0.15F;
	public float pulseTiming = 2;
	Renderer ren;
	void Awake () => ren = GetComponent<Renderer>();
	void Update () {
		
		float r = Mathf.Sin((Time.time / loopduration) * (2 * Mathf.PI)) * 0.25f + 0.25f;
		float g = Mathf.Sin((Time.time / loopduration + 0.33333333f) * 2 * Mathf.PI) * 0.25f + 0.25f;
		float b = Mathf.Sin((Time.time / loopduration + 0.66666667f) * 2 * Mathf.PI) * 0.25f + 0.25f;
		float correction = 1 / (r + g + b);
		r *= correction;
		g *= correction;
		b *= correction; 
		ren.sharedMaterial.SetVector("_ChannelFactor", new Vector4(r,g,b,0));
		ren.sharedMaterial.SetFloat("_Displacement", pulseOffset+Mathf.Sin(Time.fixedTime*pulseTiming)*pulseAmount);
	}
}
