// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "UnityShaderBook/Chapter6/DiffuseVertexLevel"
{
	Properties
	{	
		//计算漫反射公式（光源颜色*材质漫反射系数）* max(0, 法线和光源方向的cos值)
		_Diffuse("Diffuse", Color) = (1, 1, 1, 1)
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

			float4 _Diffuse;

			struct a2v
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				fixed3 color : COLOR;
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

				fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);

				fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLight));

				o.color = ambient + diffuse;

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				return fixed4(i.color, 1.0);
			}

			ENDCG
		}
	}

	Fallback "Diffuse"
}
