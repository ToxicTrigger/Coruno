// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "nomal_sprite"
{
	Properties
	{
		[Toggle]_use_2em("use_2em?", Float) = 0
		_emosion("emosion", 2D) = "white" {}
		[HDR]_Lerp_color("Lerp_color", Color) = (1,0.495283,0.495283,0)
		[HDR]_emsion("emsion", Color) = (1,1,1,0)
		[HDR]_tex_color("tex_color", Color) = (1,1,1,0)
		_nomal_power("nomal_power", Float) = 1
		_Normal("_Normal", 2D) = "bump" {}
		_MainTex("_MainTex", 2D) = "white" {}
		_Float0("Float 0", Float) = 0.5
		_Max("Max", Float) = 0.52
		_min("min", Float) = 0.36
		[Toggle]_use_Lerp("use_Lerp?", Float) = 0
		[Toggle]_use_uorv("use _u or v", Float) = 0
		[Toggle]_oneMius("one Mius", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Normal;
		uniform float _nomal_power;
		uniform float4 _Normal_ST;
		uniform float4 _tex_color;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float _use_2em;
		uniform float _use_Lerp;
		uniform float4 _emsion;
		uniform float4 _Lerp_color;
		uniform float _oneMius;
		uniform float _use_uorv;
		uniform float _min;
		uniform float _Max;
		uniform sampler2D _emosion;
		uniform float4 _emosion_ST;
		uniform float _Float0;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			o.Normal = UnpackScaleNormal( tex2D( _Normal, uv_Normal ), _nomal_power );
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode13 = tex2D( _MainTex, uv_MainTex );
			float4 lerpResult21 = lerp( _Lerp_color , _emsion , saturate( (0.0 + (lerp(lerp(i.uv_texcoord.x,i.uv_texcoord.y,_use_uorv),( 1.0 - lerp(i.uv_texcoord.x,i.uv_texcoord.y,_use_uorv) ),_oneMius) - _min) * (1.0 - 0.0) / (_Max - _min)) ));
			float2 uv_emosion = i.uv_texcoord * _emosion_ST.xy + _emosion_ST.zw;
			float4 tex2DNode6 = tex2D( _emosion, uv_emosion );
			o.Albedo = ( ( _tex_color * tex2DNode13 ) + lerp(( lerp(_emsion,lerpResult21,_use_Lerp) * tex2DNode6 ),( ( tex2DNode6 * _emsion ) + ( tex2DNode6.a * _Lerp_color ) ),_use_2em) ).rgb;
			o.Emission = ( lerp(( lerp(_emsion,lerpResult21,_use_Lerp) * tex2DNode6 ),( ( tex2DNode6 * _emsion ) + ( tex2DNode6.a * _Lerp_color ) ),_use_2em) + ( tex2DNode13 * _Float0 ) ).rgb;
			o.Alpha = tex2DNode13.a;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
7;7;1906;1004;977.5112;13.95694;1;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;22;-1462.624,625.3609;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;29;-1200.107,604.3648;Float;False;Property;_use_uorv;use _u or v;12;0;Create;True;0;0;False;0;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;31;-969.9874,629.528;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;30;-899.8027,520.1802;Float;False;Property;_oneMius;one Mius;13;0;Create;True;0;0;False;0;0;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-1038.971,1006.766;Float;False;Property;_Max;Max;9;0;Create;True;0;0;False;0;0.52;0.52;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-1020.236,826.5013;Float;False;Property;_min;min;10;0;Create;True;0;0;False;0;0.36;0.36;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;24;-625.4388,539.7477;Float;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;27;-915.0754,-137.5352;Float;False;Property;_Lerp_color;Lerp_color;2;1;[HDR];Create;True;0;0;False;0;1,0.495283,0.495283,0;0.6957496,1.067331,0.09565699,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;32;-322.0197,494.3713;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;8;-1322.117,4.930523;Float;False;Property;_emsion;emsion;3;1;[HDR];Create;True;0;0;False;0;1,1,1,0;0.6957496,1.067331,0.09565699,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;6;-1434.915,288.6461;Float;True;Property;_emosion;emosion;1;0;Create;True;0;0;False;0;None;d00bd81c5dd4d3d4abe7174f4a120c95;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;21;-237.4386,49.30446;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;28;-5.391098,267.0799;Float;False;Property;_use_Lerp;use_Lerp?;11;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-739.0172,317.9653;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-981.005,159.9305;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;13;-338.8867,915.481;Float;True;Property;_MainTex;_MainTex;7;0;Create;False;0;0;False;0;None;31fab15a3cd6fbc4eb96a07d44e135a2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;35;-137.7867,431.8627;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;218.2095,265.4086;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;5;-307.9997,-150.7791;Float;False;Property;_tex_color;tex_color;4;1;[HDR];Create;True;0;0;False;0;1,1,1,0;2.670157,2.670157,2.670157,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;20;-11.8261,863.4694;Float;False;Property;_Float0;Float 0;8;0;Create;True;0;0;False;0;0.5;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;37;428.508,349.3455;Float;False;Property;_use_2em;use_2em?;0;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;88.94847,670.1181;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-530.153,1042.165;Float;False;Property;_nomal_power;nomal_power;5;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;125.6286,28.48923;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;12;-483.9969,768.5278;Float;True;Property;_Normal;_Normal;6;0;Create;True;0;0;False;0;None;None;False;bump;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleAddOpNode;18;515.4762,604.9893;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;619.2957,266.2729;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2;-326.0456,611.6142;Float;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;797.9354,527.7581;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;nomal_sprite;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;29;0;22;1
WireConnection;29;1;22;2
WireConnection;31;0;29;0
WireConnection;30;0;29;0
WireConnection;30;1;31;0
WireConnection;24;0;30;0
WireConnection;24;1;25;0
WireConnection;24;2;26;0
WireConnection;32;0;24;0
WireConnection;21;0;27;0
WireConnection;21;1;8;0
WireConnection;21;2;32;0
WireConnection;28;0;8;0
WireConnection;28;1;21;0
WireConnection;33;0;6;4
WireConnection;33;1;27;0
WireConnection;34;0;6;0
WireConnection;34;1;8;0
WireConnection;35;0;34;0
WireConnection;35;1;33;0
WireConnection;14;0;28;0
WireConnection;14;1;6;0
WireConnection;37;0;14;0
WireConnection;37;1;35;0
WireConnection;19;0;13;0
WireConnection;19;1;20;0
WireConnection;3;0;5;0
WireConnection;3;1;13;0
WireConnection;18;0;37;0
WireConnection;18;1;19;0
WireConnection;17;0;3;0
WireConnection;17;1;37;0
WireConnection;2;0;12;0
WireConnection;2;5;9;0
WireConnection;0;0;17;0
WireConnection;0;1;2;0
WireConnection;0;2;18;0
WireConnection;0;9;13;4
ASEEND*/
//CHKSM=E2CC55F44F6B44039651C97A86222CE629164263