// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "uv_flow"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_speed("speed", Vector) = (0,-1,0,0)
		_tex_2speed("tex_2 speed", Vector) = (0,-1,0,0)
		_tiling("tiling", Vector) = (1,1,0,0)
		_tiling2("tiling2", Vector) = (1,1,0,0)
		_offset("offset", Vector) = (0,0,0,0)
		_offset2("offset2", Vector) = (0,0,0,0)
		[HDR]_Color0("Color 0", Color) = (1,1,1,1)
		[HDR]_Color1("Color 1", Color) = (1,1,1,1)
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_opacity("opacity", Float) = 0.5
		_mask("mask", 2D) = "white" {}
		[HDR]_power("power", Color) = (0.3584906,0.3584906,0.3584906,0)
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
		_TextureSample3("Texture Sample 3", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _TextureSample0;
		uniform float2 _speed;
		uniform float2 _tiling;
		uniform float2 _offset;
		uniform sampler2D _TextureSample1;
		uniform float2 _tex_2speed;
		uniform float2 _tiling2;
		uniform float2 _offset2;
		uniform float4 _power;
		uniform float4 _Color0;
		uniform float4 _Color1;
		uniform sampler2D _TextureSample3;
		uniform float _opacity;
		uniform sampler2D _mask;
		uniform float4 _mask_ST;
		uniform sampler2D _TextureSample2;
		uniform float4 _TextureSample2_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TexCoord3 = i.uv_texcoord * _tiling + _offset;
			float2 panner2 = ( 1.0 * _Time.y * _speed + uv_TexCoord3);
			float2 uv_TexCoord20 = i.uv_texcoord * _tiling2 + _offset2;
			float2 panner22 = ( 1.0 * _Time.y * _tex_2speed + uv_TexCoord20);
			float4 temp_output_29_0 = ( float4( panner2, 0.0 , 0.0 ) + ( tex2D( _TextureSample1, panner22 ) * _power ) );
			float4 temp_output_17_0 = ( tex2D( _TextureSample0, temp_output_29_0.rg ) * _Color0 );
			float4 lerpResult32 = lerp( temp_output_17_0 , ( _Color1 * tex2D( _TextureSample3, temp_output_29_0.rg ) ) , 0.6);
			o.Emission = lerpResult32.rgb;
			float2 uv_mask = i.uv_texcoord * _mask_ST.xy + _mask_ST.zw;
			float2 uv_TextureSample2 = i.uv_texcoord * _TextureSample2_ST.xy + _TextureSample2_ST.zw;
			o.Alpha = ( temp_output_17_0 * _opacity * tex2D( _mask, uv_mask ) * tex2D( _TextureSample2, uv_TextureSample2 ) ).r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 

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
388;19;1248;992;1711.773;558.9889;1;True;False
Node;AmplifyShaderEditor.Vector2Node;18;-1247.75,139.4857;Float;False;Property;_tiling2;tiling2;4;0;Create;True;0;0;False;0;1,1;0.5,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;19;-1255.932,289.8736;Float;False;Property;_offset2;offset2;6;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;20;-1018.324,168.0822;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;21;-880.7239,448.0684;Float;False;Property;_tex_2speed;tex_2 speed;2;0;Create;True;0;0;False;0;0,-1;1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;6;-1141.548,-258.6358;Float;False;Property;_tiling;tiling;3;0;Create;True;0;0;False;0;1,1;1,5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;7;-1149.73,-108.2478;Float;False;Property;_offset;offset;5;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;22;-711.9909,167.1184;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;16;-511.4649,148.9893;Float;True;Property;_TextureSample1;Texture Sample 1;9;0;Create;True;0;0;False;0;None;df1a73877e6e817489bcdec99d204d81;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-910.1213,-250.0393;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;13;-779.5886,12.52874;Float;False;Property;_speed;speed;1;0;Create;True;0;0;False;0;0,-1;1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ColorNode;27;-392.1902,387.0449;Float;False;Property;_power;power;12;1;[HDR];Create;True;0;0;False;0;0.3584906,0.3584906,0.3584906,0;0.3584906,0.3584906,0.3584906,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-179.6141,195.2602;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;2;-635.1434,-175.8653;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;29;-431.2423,-137.7601;Float;True;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;14;-179.3964,-363.4742;Float;False;Property;_Color0;Color 0;7;1;[HDR];Create;True;0;0;False;0;1,1,1,1;0.3006468,0.3207547,0.09834461,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-205.5368,-199.8346;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;5a433b6c7433e1940836a645d07dc052;a8c8f3879983aa643b7e058f8fc14498;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;33;255.3394,550.5316;Float;True;Property;_TextureSample3;Texture Sample 3;14;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;36;182.6412,318.2289;Float;False;Property;_Color1;Color 1;8;1;[HDR];Create;True;0;0;False;0;1,1,1,1;0.1650053,0.2727189,0.3396226,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;30;41.22198,-3.689128;Float;True;Property;_mask;mask;11;0;Create;True;0;0;False;0;None;5a52c9ffd983d2e4b9a2c9bd37439b7b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;31;51.91134,186.9061;Float;True;Property;_TextureSample2;Texture Sample 2;13;0;Create;True;0;0;False;0;None;8540c281d4bbfbd4391515a0296557c6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;23;201.8651,-113.2214;Float;False;Property;_opacity;opacity;10;0;Create;True;0;0;False;0;0.5;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;505.8806,22.43553;Float;False;Constant;_Float0;Float 0;14;0;Create;True;0;0;False;0;0.6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;517.9017,285.2917;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;116.9624,-382.054;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;32;707.2307,-235.8791;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;422.7206,-208.025;Float;True;4;4;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;978.8832,-316.7386;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;uv_flow;False;False;False;False;False;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;20;0;18;0
WireConnection;20;1;19;0
WireConnection;22;0;20;0
WireConnection;22;2;21;0
WireConnection;16;1;22;0
WireConnection;3;0;6;0
WireConnection;3;1;7;0
WireConnection;26;0;16;0
WireConnection;26;1;27;0
WireConnection;2;0;3;0
WireConnection;2;2;13;0
WireConnection;29;0;2;0
WireConnection;29;1;26;0
WireConnection;1;1;29;0
WireConnection;33;1;29;0
WireConnection;37;0;36;0
WireConnection;37;1;33;0
WireConnection;17;0;1;0
WireConnection;17;1;14;0
WireConnection;32;0;17;0
WireConnection;32;1;37;0
WireConnection;32;2;35;0
WireConnection;24;0;17;0
WireConnection;24;1;23;0
WireConnection;24;2;30;0
WireConnection;24;3;31;0
WireConnection;0;2;32;0
WireConnection;0;9;24;0
ASEEND*/
//CHKSM=8C90A3122365F107399D1E1DB5C5A1E201AA4DA2