// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "UnityShaderBook/Chapter5/SimpleShader"
{
	Properties
	{
		_Color ("Color Tint", Color) = (1.0, 1.0, 1.0, 1.0)
	}
	SubShader
	{
		
		Pass{

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			fixed4 _Color;

			struct a2v {

				//POSITION告诉Unity 用模型空间的顶点坐标填充vertex
				float4 vertex : POSITION;
				//NORMAL告诉Unity 用模型空间的法线填充normal
				float3 normal : NORMAL;
				//TEXCOORD0告诉Unity 用模型的第一套纹理坐标填充texcoord
				float4 texcoord : TEXCOORD0;
			};

			struct v2f {

				//SV_POSITION语义告诉Unity，pos里包含了顶点在裁剪空间中的位置信息
				float4 pos : SV_POSITION;
				//COLOR0语义用于存储颜色信息
				fixed3 color : COLOR0;

			};

			//POSITION语义表示模型顶点 SV_POSITION语义表示裁剪空间坐标
			float4 vert1(float4 v : POSITION) : SV_POSITION {

				return UnityObjectToClipPos(v);
			}

			v2f vert(a2v v) {

				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				//normal范围是[-1, 1] 取半+0.5 映射到[0, 1]
				o.color = v.normal * 0.5 + fixed3(0.5, 0.5, 0.5);

				return o;
			}

			//SV_TARGET语义是hlsl中的一个系统语义 告诉渲染器将
			//输出颜色存储到一个渲染目标 这里默认输出到帧缓存中
			fixed4 frag1() : SV_TARGET{

				return fixed4(1.0, 1.0, 1.0, 1.0);
			}

			fixed4 frag(v2f i) : SV_TARGET{

				return fixed4(i.color * _Color.rgb, 1.0);
			}
			ENDCG
		}
	}
}
