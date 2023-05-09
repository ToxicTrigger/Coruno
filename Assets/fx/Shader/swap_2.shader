// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "swap_2"
{
	Properties
	{
		_Up("Up", 2D) = "white" {}
		_Down("Down", 2D) = "white" {}
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_ripplepower("ripple power", Float) = -0.06
		_TextureSample3("Texture Sample 3", 2D) = "white" {}
		_Power("Power", Range( -3 , 1)) = 0
		_TextureSample4("Texture Sample 4", 2D) = "white" {}
		_TextureSample5("Texture Sample 5", 2D) = "white" {}
		[Toggle]_F_blur("F_blur?", Float) = 1
		[Toggle]_F_blur2("F_blur2", Float) = 1
		[Toggle]_particle1("particle?1", Float) = 0
		[Toggle]_Particle("Particle", Float) = 0
		[Toggle]_toggletex("toggle tex", Float) = 1
		[Toggle]_toggle_tex("toggle_tex", Float) = 0
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
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
			float2 uv2_texcoord2;
			float4 vertexColor : COLOR;
		};

		uniform float _toggle_tex;
		uniform float _F_blur;
		uniform sampler2D _TextureSample4;
		uniform float4 _TextureSample4_ST;
		uniform sampler2D _Up;
		uniform sampler2D _TextureSample1;
		uniform sampler2D _Sampler6086;
		uniform float _particle1;
		uniform float _ripplepower;
		uniform sampler2D _Down;
		uniform sampler2D _TextureSample2;
		uniform sampler2D _Sampler6083;
		uniform float _F_blur2;
		uniform sampler2D _TextureSample5;
		uniform float4 _TextureSample5_ST;
		uniform float _toggletex;
		uniform sampler2D _TextureSample3;
		uniform sampler2D _TextureSample0;
		uniform float _Particle;
		uniform float _Power;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TextureSample4 = i.uv_texcoord * _TextureSample4_ST.xy + _TextureSample4_ST.zw;
			float2 temp_output_1_0_g4 = float2( 1,1 );
			float2 appendResult10_g4 = (float2(( (temp_output_1_0_g4).x * i.uv_texcoord.x ) , ( i.uv_texcoord.y * (temp_output_1_0_g4).y )));
			float2 temp_output_11_0_g4 = float2( 0,0 );
			float2 panner18_g4 = ( ( (temp_output_11_0_g4).x * _Time.y ) * float2( 1,0 ) + i.uv_texcoord);
			float2 panner19_g4 = ( ( _Time.y * (temp_output_11_0_g4).y ) * float2( 0,1 ) + i.uv_texcoord);
			float2 appendResult24_g4 = (float2((panner18_g4).x , (panner19_g4).y));
			float2 temp_output_47_0_g4 = float2( 0,-1 );
			float2 uv_TexCoord78_g4 = i.uv_texcoord * float2( 2,2 );
			float2 temp_output_31_0_g4 = ( uv_TexCoord78_g4 - float2( 1,1 ) );
			float2 appendResult39_g4 = (float2(frac( ( atan2( (temp_output_31_0_g4).x , (temp_output_31_0_g4).y ) / 6.28318548202515 ) ) , length( temp_output_31_0_g4 )));
			float2 panner54_g4 = ( ( (temp_output_47_0_g4).x * _Time.y ) * float2( 1,0 ) + appendResult39_g4);
			float2 panner55_g4 = ( ( _Time.y * (temp_output_47_0_g4).y ) * float2( 0,1 ) + appendResult39_g4);
			float2 appendResult58_g4 = (float2((panner54_g4).x , (panner55_g4).y));
			float4 temp_output_81_0 = ( lerp(float4( 1,1,1,0 ),tex2D( _TextureSample4, uv_TextureSample4 ),_F_blur) * tex2D( _Up, ( ( tex2D( _TextureSample1, ( ( (tex2D( _Sampler6086, ( appendResult10_g4 + appendResult24_g4 ) )).rg * 1.0 ) + ( float2( 1,2 ) * appendResult58_g4 ) ) ) * lerp(_ripplepower,i.uv2_texcoord2.x,_particle1) ) + float4( i.uv_texcoord, 0.0 , 0.0 ) ).rg ) );
			float2 temp_output_1_0_g2 = float2( 1,1 );
			float2 appendResult10_g2 = (float2(( (temp_output_1_0_g2).x * i.uv_texcoord.x ) , ( i.uv_texcoord.y * (temp_output_1_0_g2).y )));
			float2 temp_output_11_0_g2 = float2( 0,0 );
			float2 panner18_g2 = ( ( (temp_output_11_0_g2).x * _Time.y ) * float2( 1,0 ) + i.uv_texcoord);
			float2 panner19_g2 = ( ( _Time.y * (temp_output_11_0_g2).y ) * float2( 0,1 ) + i.uv_texcoord);
			float2 appendResult24_g2 = (float2((panner18_g2).x , (panner19_g2).y));
			float2 appendResult84 = (float2(0.0 , -1.0));
			float2 temp_output_47_0_g2 = appendResult84;
			float2 temp_output_31_0_g2 = ( ( i.uv_texcoord / float2( 0.5,0.5 ) ) - float2( 1,1 ) );
			float2 appendResult39_g2 = (float2(frac( ( atan2( (temp_output_31_0_g2).x , (temp_output_31_0_g2).y ) / 6.28318548202515 ) ) , length( temp_output_31_0_g2 )));
			float2 panner54_g2 = ( ( (temp_output_47_0_g2).x * _Time.y ) * float2( 1,0 ) + appendResult39_g2);
			float2 panner55_g2 = ( ( _Time.y * (temp_output_47_0_g2).y ) * float2( 0,1 ) + appendResult39_g2);
			float2 appendResult58_g2 = (float2((panner54_g2).x , (panner55_g2).y));
			float2 temp_output_83_0 = ( ( (tex2D( _Sampler6083, ( appendResult10_g2 + appendResult24_g2 ) )).rg * 1.0 ) + ( float2( 1,1 ) * appendResult58_g2 ) );
			float2 uv_TextureSample5 = i.uv_texcoord * _TextureSample5_ST.xy + _TextureSample5_ST.zw;
			float4 temp_output_88_0 = ( tex2D( _Down, ( float4( i.uv_texcoord, 0.0 , 0.0 ) + ( tex2D( _TextureSample2, temp_output_83_0 ) * 0.01 ) ).rg ) * lerp(float4( 1,1,1,0 ),tex2D( _TextureSample5, uv_TextureSample5 ),_F_blur2) );
			float4 temp_cast_10 = (( lerp(( 1.0 - _Power ),( 1.0 - i.uv2_texcoord2.y ),_Particle) / 5.0 )).xxxx;
			float4 temp_cast_11 = (lerp(( 1.0 - _Power ),( 1.0 - i.uv2_texcoord2.y ),_Particle)).xxxx;
			float4 temp_cast_12 = (0.0).xxxx;
			float4 temp_cast_13 = (1.0).xxxx;
			float4 lerpResult1 = lerp( lerp(temp_output_81_0,temp_output_88_0,_toggle_tex) , lerp(temp_output_88_0,temp_output_81_0,_toggletex) , saturate( ( ( (temp_cast_12 + (tex2D( _TextureSample3, ( float4( i.uv_texcoord, 0.0 , 0.0 ) + ( tex2D( _TextureSample0, temp_output_83_0 ) * 0.1 ) ).rg ) - temp_cast_10) * (temp_cast_13 - temp_cast_12) / (temp_cast_11 - temp_cast_10)) + -0.29 ) * 1.0 ) ));
			o.Emission = lerpResult1.rgb;
			o.Alpha = i.vertexColor.a;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 

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
				float4 customPack1 : TEXCOORD1;
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
				o.customPack1.zw = customInputData.uv2_texcoord2;
				o.customPack1.zw = v.texcoord1;
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
				surfIN.uv2_texcoord2 = IN.customPack1.zw;
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
578;113;1187;837;1370.421;746.1249;1.398841;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;74;-3078.771,379.6634;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;84;-3132.663,1125.392;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;85;-3337.048,1084.986;Float;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;83;-3027.975,831.0902;Float;False;RadialUVDistortion;-1;;2;051d65e7699b41a4c800363fd0e822b2;0;7;60;SAMPLER2D;_Sampler6083;False;1;FLOAT2;1,1;False;11;FLOAT2;0,0;False;65;FLOAT;1;False;68;FLOAT2;1,1;False;47;FLOAT2;1,1;False;29;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;60;-1945.573,1108.952;Float;False;Property;_Power;Power;10;0;Create;True;0;0;False;0;0;-3;-3;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;86;-2590.869,-701.2177;Float;False;RadialUVDistortion;-1;;4;051d65e7699b41a4c800363fd0e822b2;0;7;60;SAMPLER2D;_Sampler6086;False;1;FLOAT2;1,1;False;11;FLOAT2;0,0;False;65;FLOAT;1;False;68;FLOAT2;1,2;False;47;FLOAT2;0,-1;False;29;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-2129.396,-718.9724;Float;False;Property;_ripplepower;ripple power;6;0;Create;True;0;0;False;0;-0.06;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;90;-1956.525,1407.078;Float;False;1;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;77;-2609.359,1045.552;Float;False;Constant;_Float0;Float 0;7;0;Create;True;0;0;False;0;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;76;-2597.64,769.2048;Float;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;False;0;None;9df9676d3e7b3d44ca4cc6e7700acf00;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;49;-2463.87,214.8765;Float;True;Property;_TextureSample2;Texture Sample 2;4;0;Create;True;0;0;False;0;None;5baef9617239b944e95c18ee0f2d8e77;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;50;-2476.499,472.3698;Float;False;Constant;_Float2;Float 2;7;0;Create;True;0;0;False;0;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;33;-2176.847,-958.854;Float;True;Property;_TextureSample1;Texture Sample 1;5;0;Create;True;0;0;False;0;None;96ef7f2e1f32c96418e3d5d06cf43d66;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;94;-1871.848,-764.4962;Float;False;Property;_particle1;particle?1;15;0;Create;True;0;0;False;0;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;63;-1588.938,1095.052;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;91;-1594.019,1289.388;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;-2259.107,852.9167;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;38;-1947.889,-648.2833;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-2126.247,279.7339;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-1808.396,-913.9724;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;92;-1412.765,1086.383;Float;False;Property;_Particle;Particle;16;0;Create;True;0;0;False;0;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;79;-2035.175,779.2684;Float;True;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;34;-1672.169,-830.4034;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT2;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;52;-1902.315,206.0856;Float;True;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;97;-1165.213,105.8829;Float;True;Property;_TextureSample5;Texture Sample 5;12;0;Create;True;0;0;False;0;None;f9523bf0960af914ea57fda2acad452d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;80;-1096.391,-597.0267;Float;True;Property;_TextureSample4;Texture Sample 4;11;0;Create;True;0;0;False;0;None;bb4d3839b12ac9d4abf79f140ee84070;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;62;-1159.003,1044.689;Float;False;Constant;_Float6;Float 6;14;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-1182.463,946.9579;Float;False;Constant;_Float5;Float 5;14;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;64;-1373.562,811.6469;Float;True;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;54;-1698.45,830.8228;Float;True;Property;_TextureSample3;Texture Sample 3;9;0;Create;True;0;0;False;0;None;26c557c70781099418ab8b10f0aa399a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;82;-680.0811,-525.4409;Float;False;Property;_F_blur;F_blur?;13;0;Create;True;0;0;False;0;1;2;0;COLOR;1,1,1,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;98;-748.9028,177.4687;Float;False;Property;_F_blur2;F_blur2;14;0;Create;True;0;0;False;0;1;2;0;COLOR;1,1,1,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;3;-797.4308,-60.25529;Float;True;Property;_Down;Down;2;0;Create;True;0;0;False;0;e4f20d2e47818b449ada615520e8c5f2;e4f20d2e47818b449ada615520e8c5f2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;58;-1030.961,744.0207;Float;True;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2;-766.4993,-339.9005;Float;True;Property;_Up;Up;1;0;Create;True;0;0;False;0;a928f6187462adb49b920f329d879931;a928f6187462adb49b920f329d879931;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;-414.4082,14.26694;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;-426.5806,-323.9409;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;70;-694.0146,737.1766;Float;True;ConstantBiasScale;-1;;5;63208df05c83e8e49a48ffbdce2e43a0;0;3;3;COLOR;0,0,0,0;False;1;FLOAT;-0.29;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;96;-257.6156,-26.89652;Float;False;Property;_toggletex;toggle tex;17;0;Create;True;0;0;False;0;1;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;95;-211.4771,-254.28;Float;False;Property;_toggle_tex;toggle_tex;18;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;68;-199.5468,979.568;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TimeNode;71;-3533.307,799.7173;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;72;-3380.812,641.7775;Float;False;Constant;_Vector0;Vector 0;7;0;Create;True;0;0;False;0;0.3,0.2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.VertexColorNode;93;-85.18387,133.9412;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;-3160.959,737.7874;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;41;-2853.303,-733.1378;Float;False;Property;_Vector4;Vector 4;7;0;Create;True;0;0;False;0;-1,-1;-1,-1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;75;-2759.28,709.4174;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;39;-2578.188,-904.6947;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;1;-45.798,-145.6502;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;40;-2887.885,-924.2433;Float;False;Property;_Vector3;Vector 3;8;0;Create;True;0;0;False;0;3,3;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;331.5035,-146.5264;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;swap_2;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;AlphaTest;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;85;0;74;0
WireConnection;83;47;84;0
WireConnection;83;29;85;0
WireConnection;76;1;83;0
WireConnection;49;1;83;0
WireConnection;33;1;86;0
WireConnection;94;0;37;0
WireConnection;94;1;90;1
WireConnection;63;0;60;0
WireConnection;91;0;90;2
WireConnection;78;0;76;0
WireConnection;78;1;77;0
WireConnection;51;0;49;0
WireConnection;51;1;50;0
WireConnection;36;0;33;0
WireConnection;36;1;94;0
WireConnection;92;0;63;0
WireConnection;92;1;91;0
WireConnection;79;0;74;0
WireConnection;79;1;78;0
WireConnection;34;0;36;0
WireConnection;34;1;38;0
WireConnection;52;0;74;0
WireConnection;52;1;51;0
WireConnection;64;0;92;0
WireConnection;54;1;79;0
WireConnection;82;1;80;0
WireConnection;98;1;97;0
WireConnection;3;1;52;0
WireConnection;58;0;54;0
WireConnection;58;1;64;0
WireConnection;58;2;92;0
WireConnection;58;3;61;0
WireConnection;58;4;62;0
WireConnection;2;1;34;0
WireConnection;88;0;3;0
WireConnection;88;1;98;0
WireConnection;81;0;82;0
WireConnection;81;1;2;0
WireConnection;70;3;58;0
WireConnection;96;0;88;0
WireConnection;96;1;81;0
WireConnection;95;0;81;0
WireConnection;95;1;88;0
WireConnection;68;0;70;0
WireConnection;73;0;72;0
WireConnection;73;1;71;2
WireConnection;75;0;74;0
WireConnection;75;1;73;0
WireConnection;39;0;40;0
WireConnection;39;1;41;0
WireConnection;1;0;95;0
WireConnection;1;1;96;0
WireConnection;1;2;68;0
WireConnection;0;2;1;0
WireConnection;0;9;93;4
ASEEND*/
//CHKSM=024B71CCB724365DCA7B177797F366DDCFDA8F65