// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "nabi_wing_particle"
{
	Properties
	{
		[Toggle]_is_particlespeed("is_particle(speed)", Float) = 0
		[Toggle]_is_particlepower("is_particle(power)", Float) = 0
		_Cutoff( "Mask Clip Value", Float ) = 1
		_Nabi("Nabi", 2D) = "white" {}
		[HDR]_Color0("Color 0", Color) = (1,0.5801887,0.5801887,0)
		_Speed("Speed", Range( 0 , 15)) = 10
		_Power("Power", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _is_particlepower;
		uniform float _Power;
		uniform float _is_particlespeed;
		uniform float _Speed;
		uniform float4 _Color0;
		uniform sampler2D _Nabi;
		uniform float4 _Nabi_ST;
		uniform float _Cutoff = 1;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			float temp_output_28_0 = distance( v.texcoord.xy.x , 0.5 );
			v.vertex.xyz += ( ase_vertexNormal * temp_output_28_0 * lerp(_Power,v.texcoord1.xy.x,_is_particlepower) * sin( ( temp_output_28_0 + ( _Time.y * lerp(_Speed,v.texcoord1.xy.y,_is_particlespeed) ) ) ) );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Emission = _Color0.rgb;
			float2 uv_Nabi = i.uv_texcoord * _Nabi_ST.xy + _Nabi_ST.zw;
			float4 tex2DNode1 = tex2D( _Nabi, uv_Nabi );
			o.Alpha = tex2DNode1.a;
			clip( tex2DNode1.a - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.0
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
				vertexDataFunc( v, customInputData );
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
319;35;1437;958;1420.86;-254.0601;1.3;True;False
Node;AmplifyShaderEditor.RangedFloatNode;38;-946.3361,931.4077;Float;False;Property;_Speed;Speed;5;0;Create;True;0;0;False;0;10;15;0;15;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;37;-844.991,1054.652;Float;False;1;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;39;-624.0276,932.9592;Float;False;Property;_is_particlespeed;is_particle(speed);0;0;Create;True;0;0;False;0;0;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;29;-825.749,570.9198;Float;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;10;-803.0237,750.5564;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DistanceOpNode;28;-516.4075,595.1936;Float;True;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-390.3165,815.7618;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;32;-111.5274,782.2036;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-599.1623,1277.674;Float;False;Property;_Power;Power;6;0;Create;True;0;0;False;0;0;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;50;-285.929,1321.941;Float;False;Property;_is_particlepower;is_particle(power);1;0;Create;True;0;0;False;0;0;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;54;139.0222,795.2534;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;30;173.6214,378.1241;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-471.6895,75.56538;Float;True;Property;_Nabi;Nabi;3;0;Create;True;0;0;False;0;ec3e34fcc6110194da32aa1210c8cf1f;ec3e34fcc6110194da32aa1210c8cf1f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;467.4558,573.0821;Float;True;4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;3;-74.70471,-47.71468;Float;False;Property;_Color0;Color 0;4;1;[HDR];Create;True;0;0;False;0;1,0.5801887,0.5801887,0;0.4636842,0.9403878,2.184467,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;788.9565,235.7977;Float;False;True;4;Float;ASEMaterialInspector;0;0;Standard;nabi_wing_particle;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;1;True;True;0;True;Transparent;;AlphaTest;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;1;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;2;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;39;0;38;0
WireConnection;39;1;37;2
WireConnection;28;0;29;1
WireConnection;31;0;10;2
WireConnection;31;1;39;0
WireConnection;32;0;28;0
WireConnection;32;1;31;0
WireConnection;50;0;51;0
WireConnection;50;1;37;1
WireConnection;54;0;32;0
WireConnection;34;0;30;0
WireConnection;34;1;28;0
WireConnection;34;2;50;0
WireConnection;34;3;54;0
WireConnection;0;2;3;0
WireConnection;0;9;1;4
WireConnection;0;10;1;4
WireConnection;0;11;34;0
ASEEND*/
//CHKSM=F785D50EEFBC731560648A016FAB77EB75A3869E