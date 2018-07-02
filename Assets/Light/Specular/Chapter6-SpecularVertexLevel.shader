// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "UnityShaderBook/Chapter6/SpecularVertexLevel"
{

	//计算高光反射公式
	//（光源颜色*材质高光反射系数）* max(0, 视角方向*光源反射方向的cos值)的gloss次平方（高光区域大小）
	Properties
	{	
		
		_Diffuse ("Diffuse", Color) = (1, 1, 1, 1)
		_Specular ("Specular", Color) = (1, 1, 1, 1)
		_Gloss ("Gloss", Range(8.0, 256)) = 20
	}
	SubShader
	{

		Pass
		{	
			Tags { "LightMode" = "ForwardBase" }

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			fixed4 _Diffuse;
			fixed4 _Spcular;
			float _Gloss;

			struct a2v
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float3 color : COLOR;
			};

		
			v2f vert (a2v v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);

				//环境光
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

				//将模型坐标空间的法线转换到世界空间坐标系
				//mul(v, m) = mul(tranpose(m), v) 下面的计算相当于用逆转置矩阵计算 避免法线计算出问题
				fixed3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));

				fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
				fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLightDir));
				//反射光方向
				fixed3 reflectDir = normalize(reflect(-worldLightDir, worldNormal));
				//视角方向
				fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld, v.vertex).xyz);

				fixed3 specular = _LightColor0.rgb * _Spcular.rgb * pow(saturate(dot(reflectDir, viewDir)), _Gloss);

				o.color = ambient + diffuse + specular;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{	
				fixed3 color = i.color;
				return fixed4(color, 1.0);
			}

			ENDCG
		}
	}

	Fallback "Specular"
}
