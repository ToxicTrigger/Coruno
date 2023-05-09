// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "podo"
{
	Properties
	{
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_TextureSample3("Texture Sample 3", 2D) = "white" {}
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Float3("Float 3", Float) = 0.05
		_x("x", Float) = 0.05
		_Float4("Float 4", Float) = 0.05
		_y("y", Float) = 0.05
		_MainTex("Main Tex", 2D) = "white" {}
		[HDR]_Emission_color("Emission_color", Color) = (0,0,0,0)
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
		_Float0("Float 0", Float) = 0
		_Float1("Float 1", Float) = 2.1
		_Float2("Float 2", Float) = 0.5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _MainTex;
		uniform sampler2D _TextureSample3;
		uniform float _Float3;
		uniform float _Float4;
		uniform float _Float2;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform sampler2D _TextureSample1;
		uniform float _x;
		uniform float _y;
		uniform sampler2D _TextureSample2;
		uniform float _Float0;
		uniform float4 _Emission_color;
		uniform float _Float1;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 appendResult42 = (float2(_Float3 , _Float4));
			float2 panner40 = ( 1.0 * _Time.y * appendResult42 + i.uv_texcoord);
			float4 tex2DNode12 = tex2D( _MainTex, ( float4( i.uv_texcoord, 0.0 , 0.0 ) + ( pow( ( 1.0 - i.uv_texcoord.x ) , 3.81 ) * tex2D( _TextureSample3, panner40 ) * _Float2 ) ).rg );
			o.Albedo = tex2DNode12.rgb;
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 tex2DNode1 = tex2D( _TextureSample0, uv_TextureSample0 );
			float2 appendResult8 = (float2(_x , _y));
			float2 uv_TexCoord5 = i.uv_texcoord * float2( 2,2 );
			float2 panner6 = ( 1.0 * _Time.y * appendResult8 + uv_TexCoord5);
			float4 tex2DNode19 = tex2D( _TextureSample2, ( ( tex2DNode1 * _Float0 ) + float4( panner6, 0.0 , 0.0 ) ).rg );
			float4 temp_cast_5 = (_Float1).xxxx;
			o.Emission = ( max( tex2DNode12 , ( ( ( tex2DNode1 * tex2D( _TextureSample1, panner6 ) ) + tex2DNode19 ) * _Emission_color ) ) + pow( tex2DNode19 , temp_cast_5 ) ).rgb;
			o.Alpha = tex2DNode12.a;
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
147;296;1309;875;3842.037;585.8944;2.604034;True;False
Node;AmplifyShaderEditor.RangedFloatNode;43;-2430.515,310.5197;Float;False;Property;_Float3;Float 3;3;0;Create;True;0;0;False;0;0.05;-0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1312,432;Float;False;Property;_x;x;4;0;Create;True;0;0;False;0;0.05;-0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1328,528;Float;False;Property;_y;y;6;0;Create;True;0;0;False;0;0.05;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-2446.515,406.5197;Float;False;Property;_Float4;Float 4;5;0;Create;True;0;0;False;0;0.05;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-1168,288;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;2,2;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;42;-2238.515,358.5197;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;32;-1147.243,-148.41;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;22;-1099.618,634.7169;Float;False;Property;_Float0;Float 0;10;0;Create;True;0;0;False;0;0;0.22;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-717.1055,62.02019;Float;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;False;0;0df58e308f423a3469472cc0b69a5254;0df58e308f423a3469472cc0b69a5254;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;8;-1120,480;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;39;-2286.515,166.5196;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;6;-912,368;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;40;-2030.515,246.5196;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;36;-1313.332,35.18956;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-910.1713,566.3801;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.2075472;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;37;-1215.865,-51.99474;Float;True;2;0;FLOAT;0;False;1;FLOAT;3.81;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-736,336;Float;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;False;0;0df58e308f423a3469472cc0b69a5254;0df58e308f423a3469472cc0b69a5254;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;38;-1220.617,186.6598;Float;False;Property;_Float2;Float 2;12;0;Create;True;0;0;False;0;0.5;0.06;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;20;-866.3029,664.9348;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT2;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;41;-1854.515,214.5196;Float;True;Property;_TextureSample3;Texture Sample 3;1;0;Create;True;0;0;False;0;0df58e308f423a3469472cc0b69a5254;cd460ee4ac5c1e746b7a734cc7cc64dd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;19;-671.7631,671.0413;Float;True;Property;_TextureSample2;Texture Sample 2;9;0;Create;True;0;0;False;0;None;7b6be8be7c5eb6346a45f2720c5cbb48;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-374.6605,116.0996;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-868.9819,79.86073;Float;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-284.8099,513.9485;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;17;-481.7606,445.5197;Float;False;Property;_Emission_color;Emission_color;8;1;[HDR];Create;True;0;0;False;0;0,0,0,0;5.656854,0.3162217,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;33;-759.8875,-85.12915;Float;False;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;26;33.98705,648.5314;Float;False;Property;_Float1;Float 1;11;0;Create;True;0;0;False;0;2.1;2.23;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;12;-572.7048,-142.0886;Float;True;Property;_MainTex;Main Tex;7;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-103.2614,221.8035;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;14;71.9882,46.50892;Float;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;28;225.7742,619.2157;Float;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;30;440.262,370.9218;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;657.8872,-24.33977;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;podo;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;42;0;43;0
WireConnection;42;1;44;0
WireConnection;8;0;9;0
WireConnection;8;1;10;0
WireConnection;6;0;5;0
WireConnection;6;2;8;0
WireConnection;40;0;39;0
WireConnection;40;2;42;0
WireConnection;36;0;32;1
WireConnection;21;0;1;0
WireConnection;21;1;22;0
WireConnection;37;0;36;0
WireConnection;4;1;6;0
WireConnection;20;0;21;0
WireConnection;20;1;6;0
WireConnection;41;1;40;0
WireConnection;19;1;20;0
WireConnection;2;0;1;0
WireConnection;2;1;4;0
WireConnection;34;0;37;0
WireConnection;34;1;41;0
WireConnection;34;2;38;0
WireConnection;18;0;2;0
WireConnection;18;1;19;0
WireConnection;33;0;32;0
WireConnection;33;1;34;0
WireConnection;12;1;33;0
WireConnection;15;0;18;0
WireConnection;15;1;17;0
WireConnection;14;0;12;0
WireConnection;14;1;15;0
WireConnection;28;0;19;0
WireConnection;28;1;26;0
WireConnection;30;0;14;0
WireConnection;30;1;28;0
WireConnection;0;0;12;0
WireConnection;0;2;30;0
WireConnection;0;9;12;4
ASEEND*/
//CHKSM=584175A19E990623AFDC76C2AA329F84D6960243