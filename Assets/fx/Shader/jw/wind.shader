Shader "Custom/NewSurfaceShader"
{
    Properties
    {
       [HDR] _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Cutoff ("Cutoff", float) = 0.5
        _Move("바람세기", Range(0,1)) = 0.1
	    _Timeing("속도", Range(0,5)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="TransparentCutout" "Queue" = "AlphaTest" }
		

        CGPROGRAM
        #pragma surface surf Lambert alphatest:_Cutoff vertex:vert 
       

        sampler2D _MainTex;
		float _Move;
		float _Timeing;

		void vert(inout appdata_full v) {
			v.vertex.x += sin(_Time.y * _Timeing)* _Move * v.color.r;

		}

        struct Input
        {
            float2 uv_MainTex;
        };

		fixed4 _Color;

		void surf(Input IN, inout SurfaceOutput o) {
	        
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex)* _Color ;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
			
		}
      
        ENDCG
    }
    FallBack "Legacy Shaders/Transparent/Cutout/VertexLit"
}
