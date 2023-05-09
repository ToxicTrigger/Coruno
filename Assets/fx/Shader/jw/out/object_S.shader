// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "object_s"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_Opacity("Opacity", Range( 0 , 1)) = 0
		[Toggle]_Silhouette("Silhouette", Float) = 1
		[Toggle]_silhouette2(" silhouette2", Float) = 1
		_dis_Tex("dis_Tex", 2D) = "white" {}
		_dis_Speed("dis_Speed", Vector) = (0,0,0,0)
		_dis_Poewr("dis_Poewr", Range( 0 , 0.5)) = 0
		_dis_Color("dis_Color", 2D) = "white" {}
		_dis_Color_Power("dis_Color_Power", Range( 0 , 0.5)) = 0
		[HDR]_Color0("Color 0", Color) = (0.6650944,0.9440371,1,0)
		[Toggle]_filp_y("filp_y", Float) = 0
		[Toggle]_flip_x("flip_x", Float) = 0
		_Float4("Float 4", Float) = 0.5
		[HDR]_Color1("Color 1", Color) = (1,1,1,0)
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

		uniform float4 _Color1;
		uniform sampler2D _MainTex;
		uniform float _flip_x;
		uniform float _filp_y;
		uniform float _dis_Poewr;
		uniform sampler2D _dis_Tex;
		uniform float2 _dis_Speed;
		uniform float _Silhouette;
		uniform float _Float4;
		uniform float4 _Color0;
		uniform sampler2D _dis_Color;
		uniform float _dis_Color_Power;
		uniform float _silhouette2;
		uniform float _Opacity;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 appendResult27 = (float2(lerp(1.0,-1.0,_flip_x) , lerp(1.0,-1.0,_filp_y)));
			float2 uv_TexCoord5 = i.uv_texcoord * appendResult27;
			float2 uv_TexCoord14 = i.uv_texcoord * float2( 0.5,0.5 );
			float2 panner4 = ( _Time.y * _dis_Speed + uv_TexCoord14);
			float4 tex2DNode6 = tex2D( _dis_Tex, panner4 );
			float4 tex2DNode1 = tex2D( _MainTex, ( float4( uv_TexCoord5, 0.0 , 0.0 ) + ( _dis_Poewr * tex2DNode6 ) ).rg );
			o.Albedo = ( _Color1 * tex2DNode1 ).rgb;
			o.Emission = lerp(( _Float4 * tex2DNode1 ),( _Color0 * tex2DNode1.r * tex2D( _dis_Color, ( float4( uv_TexCoord5, 0.0 , 0.0 ) + ( _dis_Color_Power * tex2DNode6 ) ).rg ) ),_Silhouette).rgb;
			o.Alpha = lerp(tex2DNode1.a,( tex2DNode1.a * _Opacity ),_silhouette2);
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
7;1;1906;1010;2004.246;1331.795;2.311423;True;False
Node;AmplifyShaderEditor.RangedFloatNode;28;-1319.27,-31.44513;Float;False;Constant;_Float0;Float 0;10;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-1333.27,45.18581;Float;False;Constant;_Float1;Float 1;10;0;Create;True;0;0;False;0;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-1319.844,124.7044;Float;False;Constant;_Float3;Float 3;10;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-1326.644,201.8353;Float;False;Constant;_Float2;Float 2;10;0;Create;True;0;0;False;0;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;10;-1533.787,238.8745;Float;False;Property;_dis_Speed;dis_Speed;5;0;Create;True;0;0;False;0;0,0;0.1,0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TimeNode;7;-1527.512,427.7932;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;14;-1760.829,331.3568;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.5,0.5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;30;-1158.545,18.52218;Float;False;Property;_flip_x;flip_x;11;0;Create;True;0;0;False;0;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;4;-1225.854,332.4184;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ToggleSwitchNode;32;-1154.705,133.9941;Float;False;Property;_filp_y;filp_y;10;0;Create;True;0;0;False;0;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;6;-999.4132,335.838;Float;True;Property;_dis_Tex;dis_Tex;4;0;Create;True;0;0;False;0;None;e28dc97a9541e3642a48c0e3886688c5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;21;-950.7698,58.37615;Float;False;Property;_dis_Color_Power;dis_Color_Power;8;0;Create;True;0;0;False;0;0;0.3;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;27;-893.5829,159.3116;Float;False;FLOAT2;4;0;FLOAT;-1;False;1;FLOAT;-1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1031.184,257.7498;Float;False;Property;_dis_Poewr;dis_Poewr;6;0;Create;True;0;0;False;0;0;0.03;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-628.8656,350.0047;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-657.8158,180.1326;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-625.1956,61.96987;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-460.7953,302.5359;Float;True;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;19;-428.144,65.8558;Float;False;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;18;-278.6222,-21.9319;Float;True;Property;_dis_Color;dis_Color;7;0;Create;True;0;0;False;0;None;5baef9617239b944e95c18ee0f2d8e77;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;3;-125.0449,575.4362;Float;False;Property;_Opacity;Opacity;1;0;Create;True;0;0;False;0;0;0.186;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-221.0349,310.9902;Float;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;False;0;None;9ed816e5345744d4988285ea773c4649;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;17;-260.8508,-215.68;Float;False;Property;_Color0;Color 0;9;1;[HDR];Create;True;0;0;False;0;0.6650944,0.9440371,1,0;0,8.59259,21.91111,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;36;-21.78621,187.3629;Float;False;Property;_Float4;Float 4;12;0;Create;True;0;0;False;0;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;173.8697,357.2114;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;126.1072,-94.40158;Float;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;180.908,138.521;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;37;396.4264,-204.6746;Float;False;Property;_Color1;Color 1;13;1;[HDR];Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;24;447.8887,256.158;Float;False;Property;_silhouette2; silhouette2;3;0;Create;True;0;0;False;0;1;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;729.2072,-80.85388;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;23;428.1045,41.44004;Float;True;Property;_Silhouette;Silhouette;2;0;Create;True;0;0;False;0;1;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;947.9529,-14.7467;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;object_s;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;30;0;28;0
WireConnection;30;1;29;0
WireConnection;4;0;14;0
WireConnection;4;2;10;0
WireConnection;4;1;7;2
WireConnection;32;0;34;0
WireConnection;32;1;33;0
WireConnection;6;1;4;0
WireConnection;27;0;30;0
WireConnection;27;1;32;0
WireConnection;12;0;13;0
WireConnection;12;1;6;0
WireConnection;5;0;27;0
WireConnection;20;0;21;0
WireConnection;20;1;6;0
WireConnection;8;0;5;0
WireConnection;8;1;12;0
WireConnection;19;0;5;0
WireConnection;19;1;20;0
WireConnection;18;1;19;0
WireConnection;1;1;8;0
WireConnection;2;0;1;4
WireConnection;2;1;3;0
WireConnection;16;0;17;0
WireConnection;16;1;1;1
WireConnection;16;2;18;0
WireConnection;35;0;36;0
WireConnection;35;1;1;0
WireConnection;24;0;1;4
WireConnection;24;1;2;0
WireConnection;38;0;37;0
WireConnection;38;1;1;0
WireConnection;23;0;35;0
WireConnection;23;1;16;0
WireConnection;0;0;38;0
WireConnection;0;2;23;0
WireConnection;0;9;24;0
ASEEND*/
//CHKSM=2C7D82BDEB250506A563C3A1C75EBFE741CE77B6