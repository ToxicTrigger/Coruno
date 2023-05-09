// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "simple_scroll"
{
	Properties
	{
		_Tex1("Tex1", 2D) = "white" {}
		_Tex2("Tex2", 2D) = "white" {}
		_Tex2_Tilie("Tex2_Tilie", Vector) = (0.35,0,0,0)
		_Tex1_Tilie("Tex1_Tilie", Vector) = (0.35,0,0,0)
		_offset("offset", Vector) = (0.35,0,0,0)
		_Tex2_offset("Tex2_offset", Vector) = (0.35,0,0,0)
		_Tex2_Speed("Tex2_Speed", Vector) = (0.18,0,0,0)
		_speedxy("speed(x,y)", Vector) = (0.18,0,0,0)
		[HDR]_Color("Color", Color) = (2,2,2,0)
		_Bias("Bias", Float) = -0.15
		_Tex2_Power("Tex2_Power", Float) = 1
		_Tex1_Power("Tex1_Power", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Overlay+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend One One
		
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float4 _Color;
		uniform sampler2D _Tex1;
		uniform float2 _speedxy;
		uniform float2 _Tex1_Tilie;
		uniform float2 _offset;
		uniform float _Tex1_Power;
		uniform float _Tex2_Power;
		uniform sampler2D _Tex2;
		uniform float2 _Tex2_Speed;
		uniform float2 _Tex2_Tilie;
		uniform float2 _Tex2_offset;
		uniform float _Bias;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_TexCoord4 = i.uv_texcoord * _Tex1_Tilie + _offset;
			float2 panner3 = ( 1.0 * _Time.y * _speedxy + uv_TexCoord4);
			float2 uv_TexCoord16 = i.uv_texcoord * _Tex2_Tilie + _Tex2_offset;
			float2 panner18 = ( 1.0 * _Time.y * _Tex2_Speed + uv_TexCoord16);
			float4 temp_output_13_0 = ( ( tex2D( _Tex1, panner3 ) * _Tex1_Power ) + ( _Tex2_Power * tex2D( _Tex2, panner18 ) ) );
			o.Emission = ( _Color * temp_output_13_0 * i.vertexColor ).rgb;
			o.Alpha = ( ( ( temp_output_13_0 * i.vertexColor.a ) + _Bias ) * 1.58 ).r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit keepalpha fullforwardshadows 

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
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
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
1133;49;780;962;471.5651;671.5106;1.953428;True;False
Node;AmplifyShaderEditor.Vector2Node;5;-1271.704,-87.96101;Float;False;Property;_offset;offset;5;0;Create;True;0;0;False;0;0.35,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;25;-1291.346,-206.6354;Float;False;Property;_Tex1_Tilie;Tex1_Tilie;4;0;Create;True;0;0;False;0;0.35,0;5,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;15;-1253.822,303.0168;Float;False;Property;_Tex2_offset;Tex2_offset;6;0;Create;True;0;0;False;0;0.35,0;0.8,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;21;-1237.49,118.7705;Float;False;Property;_Tex2_Tilie;Tex2_Tilie;3;0;Create;True;0;0;False;0;0.35,0;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;17;-1027.587,483.3308;Float;False;Property;_Tex2_Speed;Tex2_Speed;7;0;Create;True;0;0;False;0;0.18,0;0,0.3;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;16;-1032.737,300.2715;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;7;-926.9702,66.5055;Float;False;Property;_speedxy;speed(x,y);8;0;Create;True;0;0;False;0;0.18,0;0,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-955.1812,-118.0912;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;18;-771.2865,361.0885;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;3;-743.8498,-49.48323;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;14;-590.0432,291.4144;Float;True;Property;_Tex2;Tex2;1;0;Create;True;0;0;False;0;e24b2c680edaa90458d31f11544d79ca;e28dc97a9541e3642a48c0e3886688c5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-625.8128,-97.01994;Float;True;Property;_Tex1;Tex1;0;0;Create;True;0;0;False;0;e24b2c680edaa90458d31f11544d79ca;54a73c4a3cc9d9c42ac6802e3d6b43e1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;28;-535.3524,195.1365;Float;False;Property;_Tex2_Power;Tex2_Power;11;0;Create;True;0;0;False;0;1;0.28;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-546.3524,123.1365;Float;False;Property;_Tex1_Power;Tex1_Power;12;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-349.3524,1.136536;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-329.3524,261.1365;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;19;-274.876,496.6614;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-204.1649,12.06067;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;24;72.25102,420.5612;Float;False;Property;_Bias;Bias;10;0;Create;True;0;0;False;0;-0.15;-0.04;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;83.21313,556.8383;Float;False;Constant;_Float0;Float 0;9;0;Create;True;0;0;False;0;1.58;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-50.02517,199.6592;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;11;-295.8995,-356.2536;Float;False;Property;_Color;Color;9;1;[HDR];Create;True;0;0;False;0;2,2,2,0;0.3230242,0.4114967,0.5754717,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;21.9178,-72.70507;Float;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;22;248.8371,241.8237;Float;True;ConstantBiasScale;-1;;1;63208df05c83e8e49a48ffbdce2e43a0;0;3;3;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;523.1152,33.59367;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;simple_scroll;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Overlay;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;4;1;False;-1;1;False;-1;0;1;False;-1;1;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;2;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;16;0;21;0
WireConnection;16;1;15;0
WireConnection;4;0;25;0
WireConnection;4;1;5;0
WireConnection;18;0;16;0
WireConnection;18;2;17;0
WireConnection;3;0;4;0
WireConnection;3;2;7;0
WireConnection;14;1;18;0
WireConnection;2;1;3;0
WireConnection;27;0;2;0
WireConnection;27;1;29;0
WireConnection;26;0;28;0
WireConnection;26;1;14;0
WireConnection;13;0;27;0
WireConnection;13;1;26;0
WireConnection;20;0;13;0
WireConnection;20;1;19;4
WireConnection;8;0;11;0
WireConnection;8;1;13;0
WireConnection;8;2;19;0
WireConnection;22;3;20;0
WireConnection;22;1;24;0
WireConnection;22;2;23;0
WireConnection;0;2;8;0
WireConnection;0;9;22;0
ASEEND*/
//CHKSM=A88B659FD91BE9AC4F0C189130DB092A6E8202FA