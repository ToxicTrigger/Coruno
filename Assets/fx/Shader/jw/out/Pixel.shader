// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "pixel"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Texture0("Texture 0", 2D) = "white" {}
		_Pixel_Scale("Pixel_Scale", Float) = 21.9
		_Dot_Tex("Dot_Tex", 2D) = "white" {}
		_Opacity("Opacity", Float) = 0
		[HDR]_Color0("Color 0", Color) = (0.4103774,1,0.6200885,0)
		_Float0("Float 0", Float) = 0.3
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_Float1("Float 1", Float) = -0.23
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "AlphaTest+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _Color0;
		uniform sampler2D _Texture0;
		uniform float _Pixel_Scale;
		uniform sampler2D _Dot_Tex;
		uniform sampler2D _TextureSample1;
		uniform float _Float0;
		uniform float _Float1;
		uniform float _Opacity;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float pixelWidth12 =  1.0f / _Pixel_Scale;
			float pixelHeight12 = 1.0f / _Pixel_Scale;
			half2 pixelateduv12 = half2((int)(i.uv_texcoord.x / pixelWidth12) * pixelWidth12, (int)(i.uv_texcoord.y / pixelHeight12) * pixelHeight12);
			float4 tex2DNode1 = tex2D( _Texture0, pixelateduv12 );
			float4 appendResult26 = (float4(_Pixel_Scale , _Pixel_Scale , 0.0 , 0.0));
			float2 uv_TexCoord19 = i.uv_texcoord * appendResult26.xy;
			float2 temp_cast_2 = (_Float0).xx;
			float2 panner35 = ( 1.0 * _Time.y * temp_cast_2 + i.uv_texcoord);
			float4 tex2DNode18 = tex2D( _Dot_Tex, ( float4( uv_TexCoord19, 0.0 , 0.0 ) + ( tex2D( _TextureSample1, panner35 ) * _Float1 ) ).rg );
			o.Emission = ( _Color0 * ( tex2DNode1 * tex2DNode18 ) ).rgb;
			float4 temp_output_31_0 = ( ( tex2DNode1.a * tex2DNode18 ) * _Opacity );
			o.Alpha = temp_output_31_0.r;
			clip( temp_output_31_0.r - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

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
1231;1;682;1010;98.82941;728.4164;1.377418;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;13;-1680.619,-282.2983;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;36;-1758.011,555.5468;Float;False;Property;_Float0;Float 0;6;0;Create;True;0;0;False;0;0.3;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-1682.15,-88.4726;Float;False;Property;_Pixel_Scale;Pixel_Scale;2;0;Create;True;0;0;False;0;21.9;21.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;35;-1546.242,527.177;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;37;-1255.594,592.5115;Float;True;Property;_TextureSample1;Texture Sample 1;7;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;40;-1223.487,470.6194;Float;False;Property;_Float1;Float 1;8;0;Create;True;0;0;False;0;-0.23;-0.23;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;26;-1534.64,131.835;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;19;-1270.265,177.9651;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-996.4874,472.6194;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCPixelate;12;-1395.513,-181.2554;Float;True;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;38;-945.3105,212.3681;Float;True;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;2;-1050.871,-418.7353;Float;True;Property;_Texture0;Texture 0;1;0;Create;True;0;0;False;0;None;402c2ea581aaf7d4081c5344913702a3;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;18;-721.6887,152.2812;Float;True;Property;_Dot_Tex;Dot_Tex;3;0;Create;True;0;0;False;0;None;3197984d9d7b8b848903cd32448806c6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-728.4918,-271.4669;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-192.5317,23.9342;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-160.5317,-214.0658;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;34;-106.4707,-372.9179;Float;False;Property;_Color0;Color 0;5;1;[HDR];Create;True;0;0;False;0;0.4103774,1,0.6200885,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;32;61.45829,77.99846;Float;False;Property;_Opacity;Opacity;4;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;209.2905,13.87842;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;214.634,-188.2777;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;383,-232;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;pixel;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;False;Transparent;;AlphaTest;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;35;0;13;0
WireConnection;35;2;36;0
WireConnection;37;1;35;0
WireConnection;26;0;14;0
WireConnection;26;1;14;0
WireConnection;19;0;26;0
WireConnection;39;0;37;0
WireConnection;39;1;40;0
WireConnection;12;0;13;0
WireConnection;12;1;14;0
WireConnection;12;2;14;0
WireConnection;38;0;19;0
WireConnection;38;1;39;0
WireConnection;18;1;38;0
WireConnection;1;0;2;0
WireConnection;1;1;12;0
WireConnection;22;0;1;4
WireConnection;22;1;18;0
WireConnection;21;0;1;0
WireConnection;21;1;18;0
WireConnection;31;0;22;0
WireConnection;31;1;32;0
WireConnection;33;0;34;0
WireConnection;33;1;21;0
WireConnection;0;2;33;0
WireConnection;0;9;31;0
WireConnection;0;10;31;0
ASEEND*/
//CHKSM=E577101CC65785BB1A96F2B9264397669881C3DE