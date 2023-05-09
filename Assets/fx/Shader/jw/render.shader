Shader "Custom/render" {
	Properties {
		_Cutoff("알파", float) = 0.5
		[HDR]_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("오염", 2D) = "white" {}
	    _MainTex2("정화", 2D) = "white" {}
		
	}
	SubShader {
		Tags { "RenderType"="TransparentCouout" "Queue"= "Alphatest" }
		Cull Off
		
		CGPROGRAM
	
		#pragma surface surf Standard fullforwardshadows noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa alphatest:_Cutoff
		#pragma target 3.0

		sampler2D _MainTex;
	    sampler2D _MainTex2;

		struct Input {
			float2 uv_MainTex;
			float2 uv_MainTex2;
		};

		
		fixed4 _Color;

	
		UNITY_INSTANCING_BUFFER_START(Props)
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutputStandard o) {
			
			fixed4 c1 = tex2D(_MainTex, IN.uv_MainTex)*_Color;//오염된 지형텍스쳐
			fixed4 c2 = tex2D(_MainTex2, IN.uv_MainTex2); // 정화 영역 텍스쳐
			o.Albedo = c1.rgb;
			o.Emission = c1.rgb;
		//	o.Alpha = c.r*c.g*c.b*0.333;//텍스쳐의 흑백
			o.Alpha = c1*c2;//멀티플라이
		}
		ENDCG
	}
	FallBack "Diffuse"
}
