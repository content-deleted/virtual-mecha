Shader "Jacob/Explosion"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_RampTex ("Color Ramp", 2D) = "white" {}
		_DispTex ("Displacement Texture", 2D) = "gray" {}
		_Displacement ("Displacement", Range(0, 1.0)) = 0.1
		_ChannelFactor ("ChannelFactor (r,g,b)", Vector) = (1,0,0)
        _ClipRange ("ClipRange [0,1]", float) = 0.8
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			#pragma multi_compile_builtin //nolightmap nodirlightmap nodynlightmap novertexlight
			#include "AutoLight.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
				SHADOW_COORDS(1) // put shadows data into TEXCOORD1
                fixed3 diff : COLOR0;
                fixed3 ambient : COLOR1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _DispTex;
			float4 _DispTex_ST;
			float _Displacement;
			float3 _ChannelFactor; 
			
			v2f vert (appdata v)
			{
				v2f o;

				float4 f = tex2Dlod(_DispTex, float4(v.vertex.xyz,v.uv.x));

				float offset = 2;

				//v.vertex.xyz += v.vertex.xyz*_ChannelFactor.xyz*f.rgb*offset;

				float3 dcolor = tex2Dlod (_DispTex, float4(v.uv.xy,0,0));
            	float d = (dcolor.r*_ChannelFactor.r + dcolor.g*_ChannelFactor.g + dcolor.b*_ChannelFactor.b);
           	 	v.vertex.xyz += v.normal * d * _Displacement * _Displacement;

				float scale = (1 + _Displacement)/2;
				float4x4 scaleM = {scale , 0, 0, 0,
				                   0, scale, 0 , 0,
								   0, 0, scale, 0,
				 				   0, 0, 0     , 1 };
				
				v.vertex = mul(scaleM, v.vertex);

				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);

				half3 worldNormal = UnityObjectToWorldNormal(v.normal);
                half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
                o.diff = nl * _LightColor0.rgb;
                o.ambient = ShadeSH9(half4(worldNormal,1));
                // compute shadows data
                TRANSFER_SHADOW(o)

				return o;
			}
			
			sampler2D _RampTex;
        	float _ClipRange;

			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);

				/*fixed shadow = SHADOW_ATTENUATION(i);
                // darken light's illumination with shadow, keep ambient intact
                fixed3 lighting = i.diff * shadow + i.ambient;
                col.rgb *= lighting;*/

				float d = (col.r*_ChannelFactor.r + col.g*_ChannelFactor.g + col.b*_ChannelFactor.b)* (_Displacement);//* (_Range.y-_Range.x) + _Range.x;
            	clip (_ClipRange-d);
				d = (col.r*_ChannelFactor.r + col.g*_ChannelFactor.g + col.b*_ChannelFactor.b);
				half4 c = tex2D (_RampTex, float2(d*(1-_Displacement),0.5));

				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, c);
				return c;
			}
			ENDCG
		}
	}
}
