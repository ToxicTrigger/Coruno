Shader "Custom/sprite_depth"
{
    Properties
    {
		_Cutalpha("알파자르기",Range(0,1)) = 0.5
		_Depth("깊이값",Range(0,1)) = 0.5
        _Color ("색깔", Color) = (1,1,1,1)
        _MainTex ("텍스쳐", 2D) = "white" {}
		_HightTex("높이 텍스쳐", 2D) = "white" {}
		_Nomal("노말 텍스쳐", 2D) = "white" {}

    }
    SubShader
    {
        Tags { "RenderType"="Transparentcout" "Queue" = "Alphatest" }
       

        CGPROGRAM
        
        #pragma surface surf Standard  alphatest:_Cutalpha

       
        #pragma target 3.0

        sampler2D _MainTex;
	sampler2D _HightTex;
	sampler2D _Nomal;
	
	float _Depth;

        struct Input
        {
            float2 uv_MainTex;
			float3 ViewDir;
			float2 uv_Nomal;
        };
        fixed4 _Color;

        
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
			o.Normal = UnpackNormal(tex2D(_Nomal, IN.uv_Nomal)); //노말 풀기
			
			float4 offsettex = tex2D(_HightTex, IN.uv_MainTex);
			float2 offset = (IN.ViewDir.xy / IN.ViewDir.z)*(1 - offsettex.r)* _Depth;

			fixed4 c = tex2D(_MainTex, IN.uv_MainTex - offset) * _Color;



           
            o.Albedo = c.rgb;
           
          
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
