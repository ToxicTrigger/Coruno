// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "texture"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		[HDR]_texture_color("texture_color", Color) = (1,1,1,1)
		_Float1("Float 1", Float) = 7.07
		[HDR]_emission_c("emission_c", Color) = (0,0,0,0)
		_smooth("smooth", Float) = 0
		[HDR]_Color0("Color 0", Color) = (0,0.8924732,1,0)
		_Float0("Float 0", Float) = 0
		_Lerp_power("Lerp_power", Range( 0 , 1)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+1" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#pragma target 3.0
		#pragma surface surf StandardCustom keepalpha exclude_path:deferred noambient novertexlights nolightmap  noforwardadd 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		struct SurfaceOutputStandardCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			half3 Transmission;
		};

		uniform float4 _texture_color;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform sampler2D _TextureSample2;
		uniform float4 _TextureSample2_ST;
		uniform float _Lerp_power;
		uniform sampler2D _TextureSample1;
		uniform float4 _TextureSample1_ST;
		uniform float4 _emission_c;
		uniform float _Float0;
		uniform float4 _Color0;
		uniform float _smooth;
		uniform float _Float1;

		inline half4 LightingStandardCustom(SurfaceOutputStandardCustom s, half3 viewDir, UnityGI gi )
		{
			half3 transmission = max(0 , -dot(s.Normal, gi.light.dir)) * gi.light.color * s.Transmission;
			half4 d = half4(s.Albedo * transmission , 0);

			SurfaceOutputStandard r;
			r.Albedo = s.Albedo;
			r.Normal = s.Normal;
			r.Emission = s.Emission;
			r.Metallic = s.Metallic;
			r.Smoothness = s.Smoothness;
			r.Occlusion = s.Occlusion;
			r.Alpha = s.Alpha;
			return LightingStandard (r, viewDir, gi) + d;
		}

		inline void LightingStandardCustom_GI(SurfaceOutputStandardCustom s, UnityGIInput data, inout UnityGI gi )
		{
			#if defined(UNITY_PASS_DEFERRED) && UNITY_ENABLE_REFLECTION_BUFFERS
				gi = UnityGlobalIllumination(data, s.Occlusion, s.Normal);
			#else
				UNITY_GLOSSY_ENV_FROM_SURFACE( g, s, data );
				gi = UnityGlobalIllumination( data, s.Occlusion, s.Normal, g );
			#endif
		}

		void surf( Input i , inout SurfaceOutputStandardCustom o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 uv_TextureSample2 = i.uv_texcoord * _TextureSample2_ST.xy + _TextureSample2_ST.zw;
			float4 lerpResult29 = lerp( tex2D( _MainTex, uv_MainTex ) , tex2D( _TextureSample2, uv_TextureSample2 ) , _Lerp_power);
			float4 temp_output_4_0 = ( _texture_color * lerpResult29 );
			o.Albedo = temp_output_4_0.rgb;
			float2 uv_TextureSample1 = i.uv_texcoord * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			float3 appendResult22 = (float3(0.0 , ( ( 1.0 - _Float0 ) * ase_vertexNormal.y ) , ase_vertexNormal.z));
			float fresnelNdotV10 = dot( appendResult22, ase_worldViewDir );
			float fresnelNode10 = ( -0.03 + 0.3 * pow( 1.0 - fresnelNdotV10, 10.0 ) );
			o.Emission = ( temp_output_4_0 + ( tex2D( _TextureSample1, uv_TextureSample1 ) * _emission_c ) + ( saturate( fresnelNode10 ) * _Color0 ) ).rgb;
			float temp_output_8_0 = _smooth;
			o.Metallic = temp_output_8_0;
			o.Smoothness = temp_output_8_0;
			float3 temp_cast_2 = (_Float1).xxx;
			o.Transmission = temp_cast_2;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
578;89;1187;861;824.8864;637.4136;1;True;True
Node;AmplifyShaderEditor.RangedFloatNode;23;-599.1924,168.6898;Float;False;Property;_Float0;Float 0;8;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;26;-499.4893,197.0523;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;20;-596.9716,298.3364;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-348.5664,229.4843;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;22;-203.3239,212.7917;Float;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;31;-575.7014,-113.6559;Float;True;Property;_TextureSample2;Texture Sample 2;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-560.8675,-344.9756;Float;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;False;0;None;db606d425c5d30b448aa46a4d0aaf74e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;10;-49.51244,311.9675;Float;True;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;-0.03;False;2;FLOAT;0.3;False;3;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-358.1287,-194.667;Float;False;Property;_Lerp_power;Lerp_power;9;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;29;-182.8621,-363.962;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;3;-306.9554,-560.8524;Float;False;Property;_texture_color;texture_color;3;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;6;-121.2478,23.59575;Float;False;Property;_emission_c;emission_c;5;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-218.4312,-199.0703;Float;True;Property;_TextureSample1;Texture Sample 1;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;18;452.5453,238.1298;Float;False;Property;_Color0;Color 0;7;1;[HDR];Create;True;0;0;False;0;0,0.8924732,1,0;0,0.8924732,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;27;309.7275,186.5701;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;35.82028,-494.0022;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;136.6108,-122.1054;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;535.5349,77.5423;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;8;374.3196,-251.5493;Float;False;Property;_smooth;smooth;6;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;9;639.152,-127.0961;Float;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;33;939.2924,-30.9584;Float;False;Property;_Float1;Float 1;4;0;Create;True;0;0;False;0;7.07;7.07;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1117.695,-293.9107;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;texture;False;False;False;False;True;True;True;False;False;False;False;True;False;False;True;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;False;1;False;Opaque;;Geometry;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;26;0;23;0
WireConnection;25;0;26;0
WireConnection;25;1;20;2
WireConnection;22;1;25;0
WireConnection;22;2;20;3
WireConnection;10;0;22;0
WireConnection;29;0;1;0
WireConnection;29;1;31;0
WireConnection;29;2;32;0
WireConnection;27;0;10;0
WireConnection;4;0;3;0
WireConnection;4;1;29;0
WireConnection;7;0;2;0
WireConnection;7;1;6;0
WireConnection;16;0;27;0
WireConnection;16;1;18;0
WireConnection;9;0;4;0
WireConnection;9;1;7;0
WireConnection;9;2;16;0
WireConnection;0;0;4;0
WireConnection;0;2;9;0
WireConnection;0;3;8;0
WireConnection;0;4;8;0
WireConnection;0;6;33;0
ASEEND*/
//CHKSM=F01014B579B9FD9A40791632B1CCB19F31969095