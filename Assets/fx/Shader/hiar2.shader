Shader "Custom/hiar"
{
    Properties
    {
		[HDR]_Color ("컬러", Color) = (1,1,1,1)
		[HDR]_Color2("에미션 컬러", Color) = (1,1,1,1)
		[HDR]_Color3("외각선 컬러", Color) = (0,0,0,0)
        _MainTex ("텍스쳐", 2D) = "white" {}
	    _Emission("에미션 텍스쳐", 2D) = "black" {}
	    _Outline("외각선굵기",  Range(0,0.1)) = 0.01
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
	
		cull front
        CGPROGRAM
        #pragma surface surf Lambert vertex:verf noshadow // novertexlights nolightmap  noforwardadd  noambient
        #pragma target 3.0

       sampler2D _MainTex;
		

        struct Input
        {
            float2 uv_MainTex;
        };
		
       
		fixed4 _Color3;
		float _Outline;

		void verf(inout appdata_full v) {

			v.vertex.xyz += v.normal*_Outline;
		}
        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color3;

			o.Emission = c.rgb;
            o.Albedo = c.rgb;
           // o.Alpha = c.a;
        }
        ENDCG

		cull off
		CGPROGRAM
        #pragma surface surf Lambert LightingOff novertexlights nolightmap  noforwardadd noambient //요거 추가햇슴
        #pragma target 3.0

        sampler2D _MainTex;
		sampler2D _Emission;

        struct Input
        {
            float2 uv_MainTex;
			float2 uv_Emission;
        };

		fixed4 _Color2;
        fixed4 _Color;

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			fixed4 d = tex2D(_Emission, IN.uv_Emission) * _Color2;

            o.Albedo = c.rgb;
			o.Emission = c.rgb + (c.a*_Color2); //d.rgb; // 빛안받으면 ㅈㄴ 어두워져서 추가함
		
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
