Shader "jw/winganime" {
	Properties {
		_Cutout("알파", Range(0,1)) = 0.5
		_Power("파워", Range(0,5)) = 0.5
		_speed("스피드", Range(0,100)) = 10
	[HDR]_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		
		
	}
		SubShader{
			Tags { "RenderType" = "TransparentCutout" "Queue" = "AlphaTest" }
			LOD 200
			Cull Off
		CGPROGRAM
		#pragma surface surf Standard noshadow alphatest:_Cutout vertex:winganime noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		

		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		float _Power;
		float _speed;
		struct appdata {
			float4 vertex : POSITION;
			float3 normal : NORMAL;
			float4 color : COLOR;
			float4 texcoord : TEXCOORD;
		};

		void winganime(inout appdata v) {
			float2 a = v.vertex.xy;
			float b = distance( a.x , 0); //몸통과 날개 끝 사이거리

		//	v.vertex.xyz += v.normal * sin(b+ (_Time.y *_speed))*b*_Power;// 완전 곡선으로 펄럭
		//	v.vertex.xyz += v.normal *   b.x * sin(_Time.y*_speed)*_Power;// 곡선없이 위아래 펄럭
			v.vertex.xyz += v.normal *   b.x * sin(_Time.y*_speed)*b*_Power; //적당히 곡선 펄럭
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {
			
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Emission = c.rgb;

		
	
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
