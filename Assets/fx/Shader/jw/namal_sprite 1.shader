// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "sprite_em"
{
	Properties
	{
		[HDR]_Color0("Color 0", Color) = (1,1,1,0)
		_MainTex("_MainTex", 2D) = "white" {}
		_Float0("Float 0", Float) = 0.5
		_Float1("Float 1", Range( -20 , 1)) = -8
		_Emission("Emission", 2D) = "white" {}
		_x("x", Float) = 0
		_y("y", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float4 _Color0;
		uniform sampler2D _Emission;
		uniform float4 _Emission_ST;
		uniform float _x;
		uniform float _y;
		uniform float _Float1;
		uniform float _Float0;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode13 = tex2D( _MainTex, uv_MainTex );
			o.Albedo = ( tex2DNode13 * i.vertexColor ).rgb;
			float2 uv_Emission = i.uv_texcoord * _Emission_ST.xy + _Emission_ST.zw;
			float2 appendResult45 = (float2(_x , _y));
			o.Emission = ( ( _Color0 * tex2D( _Emission, uv_Emission ) * saturate( ( 1.0 - (( 1.0 - _Float1 ) + (distance( i.uv_texcoord , appendResult45 ) - 1.0) * (0.0 - ( 1.0 - _Float1 )) / (0.0 - 1.0)) ) ) ) + ( tex2DNode13 * _Float0 ) ).rgb;
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
				half4 color : COLOR0;
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
				o.color = v.color;
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
				surfIN.vertexColor = IN.color;
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
88;84;1187;927;1138.884;347.5348;1.66459;True;True
Node;AmplifyShaderEditor.RangedFloatNode;47;-1511.772,1032.197;Float;False;Property;_y;y;6;0;Create;True;0;0;False;0;0;0.26;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-1510.772,848.5817;Float;False;Property;_x;x;5;0;Create;True;0;0;False;0;0;0.29;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-1075.43,1036.685;Float;False;Property;_Float1;Float 1;3;0;Create;True;0;0;False;0;-8;-1.919574;-20;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;22;-1391.458,533.4375;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;45;-1346.523,861.797;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-926.5632,751.9108;Float;False;Constant;_min;min;6;0;Create;True;0;0;False;0;1;0.36;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;42;-634.7477,868.7126;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-931.3593,831.1894;Float;False;Constant;_Max;Max;4;0;Create;True;0;0;False;0;0;0.52;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;38;-1090.724,570.6186;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;24;-534.7134,543.6923;Float;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;40;-201.5666,452.4882;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;39;-690.5613,107.3124;Float;True;Property;_Emission;Emission;4;0;Create;True;0;0;False;0;0b1f5c243354b114dae3f61ad68a93ed;aade19effbcb6394fa06e0c727c7aa00;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;5;-292.9799,-110.7262;Float;False;Property;_Color0;Color 0;0;1;[HDR];Create;True;0;0;False;0;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;20;86.48642,673.9688;Float;False;Property;_Float0;Float 0;2;0;Create;True;0;0;False;0;0.5;0.38;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;32;50.83403,362.9489;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;13;-337.0865,767.3203;Float;True;Property;_MainTex;_MainTex;1;0;Create;False;0;0;False;0;None;b410dc41a489de34791c9ddf88487b7d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;125.6286,28.48923;Float;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;419.4136,501.3551;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;49;911.2349,328.5257;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;1026.149,483.517;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;853.3187,261.4123;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1309.666,346.9662;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;sprite_em;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;45;0;46;0
WireConnection;45;1;47;0
WireConnection;42;0;41;0
WireConnection;38;0;22;0
WireConnection;38;1;45;0
WireConnection;24;0;38;0
WireConnection;24;1;25;0
WireConnection;24;2;26;0
WireConnection;24;3;42;0
WireConnection;24;4;26;0
WireConnection;40;0;24;0
WireConnection;32;0;40;0
WireConnection;3;0;5;0
WireConnection;3;1;39;0
WireConnection;3;2;32;0
WireConnection;44;0;13;0
WireConnection;44;1;20;0
WireConnection;48;0;13;0
WireConnection;48;1;49;0
WireConnection;17;0;3;0
WireConnection;17;1;44;0
WireConnection;0;0;48;0
WireConnection;0;2;17;0
WireConnection;0;9;13;4
ASEEND*/
//CHKSM=901EEB7C1938C487D4593B847ECAADAB117EE450