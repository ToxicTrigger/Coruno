// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "sprite_outline"
{
	Properties
	{
		_MainTex("Main Tex", 2D) = "white" {}
		_scale("scale", Range( 0 , 3)) = 0
		[HDR]_Color0("Color 0", Color) = (0,0,0,0)
		_Float0("Float 0", Float) = -0.2
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float4 _Color0;
		uniform float _scale;
		uniform float4 _MainTex_TexelSize;
		uniform float _Float0;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode29 = tex2D( _MainTex, uv_MainTex );
			float temp_output_7_0 = saturate( _scale );
			float4 lerpResult30 = lerp( tex2DNode29 , _Color0 , temp_output_7_0);
			float4 lerpResult37 = lerp( lerpResult30 , tex2DNode29 , tex2DNode29.a);
			o.Albedo = lerpResult37.rgb;
			o.Emission = lerpResult37.rgb;
			float temp_output_2_0 = ( _scale * _MainTex_TexelSize.x );
			float temp_output_5_0 = ( _MainTex_TexelSize.y * _scale );
			float2 appendResult15 = (float2(temp_output_2_0 , temp_output_5_0));
			float2 appendResult12 = (float2(-temp_output_2_0 , temp_output_5_0));
			float2 appendResult16 = (float2(temp_output_2_0 , -temp_output_5_0));
			float2 appendResult17 = (float2(-temp_output_2_0 , -temp_output_5_0));
			float lerpResult38 = lerp( tex2DNode29.a , ( ( ( ( tex2D( _MainTex, ( i.uv_texcoord + appendResult15 ) ).a + tex2D( _MainTex, ( i.uv_texcoord + appendResult12 ) ).a ) + tex2D( _MainTex, ( i.uv_texcoord + appendResult16 ) ).a ) + tex2D( _MainTex, ( i.uv_texcoord + appendResult17 ) ).a ) + tex2DNode29.a ) , temp_output_7_0);
			o.Alpha = saturate( max( tex2DNode29.a , ( ( lerpResult38 * ( 1.0 - tex2DNode29.a ) ) * _Float0 ) ) );
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
188;431;1309;821;-137.2201;-575.5649;1.7863;True;False
Node;AmplifyShaderEditor.TexturePropertyNode;24;-2452.371,-49.33116;Float;True;Property;_MainTex;Main Tex;0;0;Create;True;0;0;False;0;None;0510c62f893cdec4aa70f461c785890b;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TexelSizeNode;3;-1795.219,-190.0289;Float;False;-1;1;0;SAMPLER2D;_Sampler03;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;-1695.89,314.0304;Float;False;Property;_scale;scale;1;0;Create;True;0;0;False;0;0;0.87;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-1229.395,-117.9568;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-1221.849,344.0773;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;8;-799.0641,-140.1376;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;9;-774.8237,344.8131;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;18;-576.6986,-594.7324;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;12;-458.3365,-163.114;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;15;-463.2517,-293.3669;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;16;-475.5398,-32.86115;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;20;-223.4161,-127.9836;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;19;-227.8706,-405.9778;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;21;-225.7201,46.94486;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;26;-58.36255,-171.693;Float;True;Property;_TextureSample1;Texture Sample 1;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;25;-27.39593,-424.3153;Float;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;17;-470.6246,134.2557;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;27;-40.43451,69.52063;Float;True;Property;_TextureSample2;Texture Sample 2;3;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;33;475.2883,-256.2357;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-236.121,178.7777;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;28;-95.52664,312.6069;Float;True;Property;_TextureSample3;Texture Sample 3;4;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;34;713.9392,-21.25635;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;35;864.4728,191.6937;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;29;-52.99041,566.8698;Float;True;Property;_TextureSample4;Texture Sample 4;5;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;36;1011.335,426.6732;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;7;-1237.162,925.3001;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;45;983.8219,1211.859;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;38;938.4846,998.3251;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;1346.219,1404.314;Float;False;Property;_Float0;Float 0;3;0;Create;True;0;0;False;0;-0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;1366.867,1117.621;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;32;4.131718,813.9769;Float;False;Property;_Color0;Color 0;2;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0,1.57704,1.90566,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;1610.11,1095.931;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;30;335.3059,796.0637;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;49;1641.329,785.1177;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;37;1033.187,699.4774;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;42;1837.001,733.6104;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2064.044,428.1685;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;sprite_outline;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;3;0;24;0
WireConnection;2;0;4;0
WireConnection;2;1;3;1
WireConnection;5;0;3;2
WireConnection;5;1;4;0
WireConnection;8;0;2;0
WireConnection;9;0;5;0
WireConnection;12;0;8;0
WireConnection;12;1;5;0
WireConnection;15;0;2;0
WireConnection;15;1;5;0
WireConnection;16;0;2;0
WireConnection;16;1;9;0
WireConnection;20;0;18;0
WireConnection;20;1;12;0
WireConnection;19;0;18;0
WireConnection;19;1;15;0
WireConnection;21;0;18;0
WireConnection;21;1;16;0
WireConnection;26;0;24;0
WireConnection;26;1;20;0
WireConnection;25;0;24;0
WireConnection;25;1;19;0
WireConnection;17;0;8;0
WireConnection;17;1;9;0
WireConnection;27;0;24;0
WireConnection;27;1;21;0
WireConnection;33;0;25;4
WireConnection;33;1;26;4
WireConnection;22;0;18;0
WireConnection;22;1;17;0
WireConnection;28;0;24;0
WireConnection;28;1;22;0
WireConnection;34;0;33;0
WireConnection;34;1;27;4
WireConnection;35;0;34;0
WireConnection;35;1;28;4
WireConnection;29;0;24;0
WireConnection;36;0;35;0
WireConnection;36;1;29;4
WireConnection;7;0;4;0
WireConnection;45;0;29;4
WireConnection;38;0;29;4
WireConnection;38;1;36;0
WireConnection;38;2;7;0
WireConnection;46;0;38;0
WireConnection;46;1;45;0
WireConnection;43;0;46;0
WireConnection;43;1;44;0
WireConnection;30;0;29;0
WireConnection;30;1;32;0
WireConnection;30;2;7;0
WireConnection;49;0;29;4
WireConnection;49;1;43;0
WireConnection;37;0;30;0
WireConnection;37;1;29;0
WireConnection;37;2;29;4
WireConnection;42;0;49;0
WireConnection;0;0;37;0
WireConnection;0;2;37;0
WireConnection;0;9;42;0
ASEEND*/
//CHKSM=4588888D0562A1408F123806C21C58122C87B1E1