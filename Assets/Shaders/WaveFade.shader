Shader "Jacob/WaveFade"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		//_TimeCount ("Current Time", Float) = 0.0
		_Displacement ("Displacement", Range(0, 1.0)) = 0.0
	}
	SubShader
	{
		Tags {"LightMode"="ForwardBase" "Queue" = "AlphaTest" "RenderType" = "TransparentCutout" "IgnoreProjector" = "True"}
		LOD 100
		Blend SrcAlpha OneMinusSrcAlpha

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			#pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight
			#include "AutoLight.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float2 uv_MainTex : TEXCOORD0;
				float4 pos : SV_POSITION;
				SHADOW_COORDS(1) // put shadows data into TEXCOORD1
                fixed3 diff : COLOR0;
                fixed3 ambient : COLOR1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Displacement;

			v2f vert (appdata v)
			{
				v2f o;

				v.vertex.y += .005 * cos(200*v.vertex.x * _Displacement) * _Displacement;

				float4 vertexPosition = mul(UNITY_MATRIX_MV, v.vertex);

				o.pos = mul(UNITY_MATRIX_P, vertexPosition);
				o.uv_MainTex = TRANSFORM_TEX(v.uv, _MainTex);

				half3 worldNormal = UnityObjectToWorldNormal(v.normal);
                half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
                o.diff = nl * _LightColor0.rgb;
                o.ambient = ShadeSH9(half4(worldNormal,1));
                // compute shadows data
                TRANSFER_SHADOW(o)

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv_MainTex);
                // compute shadow attenuation (1.0 = fully lit, 0.0 = fully shadowed)
                fixed shadow = SHADOW_ATTENUATION(i);
                // darken light's illumination with shadow, keep ambient intact
                fixed3 lighting = i.diff * shadow + i.ambient;
                col.rgb *= lighting;
				col.rgb += float4(0.11,0.12,0.12,0); //lighting correction
				col.a -= 0.15 *  _Displacement;
                return col;
			}
			ENDCG
		}
	}
}
