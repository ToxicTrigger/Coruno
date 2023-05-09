// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "radial_uv"
{
	Properties
	{
		[Toggle]_use_twoTex("use_twoTex", Float) = 1
		[HDR]_out_color("out_color", Color) = (1,0.4386792,0.4386792,0)
		[HDR]_In_color("In_color", Color) = (1,0.4386792,0.4386792,0)
		_Lerp_power("Lerp_power", Float) = 3.5
		_Bias("Bias", Float) = -0.35
		_Scale("Scale", Float) = 2
		_Main_Tex("Main_Tex", 2D) = "white" {}
		[Toggle]_useTexcolor("use Tex color", Float) = 1
		[HDR]_Tex1_color("Tex1_color", Color) = (1,0.7988446,0,0)
		_Tex_U("Tex_U", Float) = 1
		_Tex_V("Tex_V", Float) = 1
		_Tex_Speed_X("Tex_Speed_X", Float) = 1
		_Tex_Speed_Y("Tex_Speed_Y", Float) = 1
		_Tex1_power("Tex1_power", Float) = 1
		_Main_Tex2("Main_Tex2", 2D) = "white" {}
		[Toggle]_useTex2color("use Tex2 color", Float) = 1
		[HDR]_Tex2_color("Tex2_color", Color) = (1,0,0,0)
		_Tex2X("Tex2X", Float) = 1
		_Tex2y("Tex2y", Float) = 1
		_Tex2speedx("Tex2speedx", Float) = 1
		_Tex2speedy("Tex2 speedy", Float) = 1
		_Tex2_power("Tex2_power", Float) = 1
		_Noise_Tex("Noise_Tex", 2D) = "white" {}
		_Noise_Power("Noise_Power", Float) = 0
		_Noise2_power("Noise2_power", Float) = 0
		_Noise_U("Noise_U", Float) = 1
		_Noise_V("Noise_V", Float) = 1
		_NoiseSpeed_X("Noise Speed_X", Float) = 1
		_Noise_Speed_Y("Noise_Speed_Y", Float) = 1
		_Noise_Tex2("Noise_Tex2", 2D) = "white" {}
		_Noise2x("Noise2 x", Float) = 1
		_Noise2_Y("Noise2_Y", Float) = 1
		_Noise2_Speedx("Noise2_Speedx", Float) = 1
		_Noise2_Speedy("Noise2_Speedy", Float) = 1
		_Mask_Tex("Mask_Tex", 2D) = "white" {}
		[Toggle]_Noise2mask("Noise2mask", Float) = 0
		[Toggle]_NoiseMask("NoiseMask", Float) = 0
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
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
			float2 uv2_texcoord2;
		};

		uniform float _use_twoTex;
		uniform float _Tex2_power;
		uniform sampler2D _Main_Tex2;
		uniform sampler2D _Noise_Tex2;
		uniform sampler2D _Sampler6085;
		uniform float _Noise2x;
		uniform float _Noise2_Y;
		uniform float _Noise2_Speedx;
		uniform float _Noise2_Speedy;
		uniform float _Noise2mask;
		uniform float _Noise2_power;
		uniform sampler2D _Mask_Tex;
		uniform float4 _Mask_Tex_ST;
		uniform sampler2D _Sampler6094;
		uniform float _Tex2X;
		uniform float _Tex2y;
		uniform float _Tex2speedx;
		uniform float _Tex2speedy;
		uniform float _useTex2color;
		uniform float4 _Tex2_color;
		uniform float _Tex1_power;
		uniform sampler2D _Main_Tex;
		uniform sampler2D _Noise_Tex;
		uniform sampler2D _Sampler6063;
		uniform float _Noise_U;
		uniform float _Noise_V;
		uniform float _NoiseSpeed_X;
		uniform float _Noise_Speed_Y;
		uniform float _NoiseMask;
		uniform float _Noise_Power;
		uniform sampler2D _Sampler602;
		uniform float _Tex_U;
		uniform float _Tex_V;
		uniform float _Tex_Speed_X;
		uniform float _Tex_Speed_Y;
		uniform float _useTexcolor;
		uniform float4 _Tex1_color;
		uniform float _Bias;
		uniform float _Scale;
		uniform float4 _out_color;
		uniform float4 _In_color;
		uniform float _Lerp_power;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 temp_output_1_0_g21 = float2( 0.5,0.5 );
			float2 appendResult10_g21 = (float2(( (temp_output_1_0_g21).x * i.uv_texcoord.x ) , ( i.uv_texcoord.y * (temp_output_1_0_g21).y )));
			float2 temp_output_11_0_g21 = float2( 0.1,0.1 );
			float2 panner18_g21 = ( ( (temp_output_11_0_g21).x * _Time.y ) * float2( 1,0 ) + i.uv_texcoord);
			float2 panner19_g21 = ( ( _Time.y * (temp_output_11_0_g21).y ) * float2( 0,1 ) + i.uv_texcoord);
			float2 appendResult24_g21 = (float2((panner18_g21).x , (panner19_g21).y));
			float2 appendResult82 = (float2(_Noise2x , _Noise2_Y));
			float2 appendResult81 = (float2(_Noise2_Speedx , _Noise2_Speedy));
			float2 temp_output_47_0_g21 = appendResult81;
			float2 temp_output_80_0 = ( i.uv2_texcoord2 / float2( 0.5,0.5 ) );
			float2 temp_output_31_0_g21 = ( temp_output_80_0 - float2( 1,1 ) );
			float2 appendResult39_g21 = (float2(frac( ( atan2( (temp_output_31_0_g21).x , (temp_output_31_0_g21).y ) / 6.28318548202515 ) ) , length( temp_output_31_0_g21 )));
			float2 panner54_g21 = ( ( (temp_output_47_0_g21).x * _Time.y ) * float2( 1,0 ) + appendResult39_g21);
			float2 panner55_g21 = ( ( _Time.y * (temp_output_47_0_g21).y ) * float2( 0,1 ) + appendResult39_g21);
			float2 appendResult58_g21 = (float2((panner54_g21).x , (panner55_g21).y));
			float temp_output_124_0 = ddx( i.uv2_texcoord2.x );
			float2 temp_cast_0 = (temp_output_124_0).xx;
			float temp_output_125_0 = ddy( i.uv2_texcoord2.y );
			float2 temp_cast_1 = (temp_output_125_0).xx;
			float4 temp_cast_2 = (_Noise2_power).xxxx;
			float2 uv_Mask_Tex = i.uv_texcoord * _Mask_Tex_ST.xy + _Mask_Tex_ST.zw;
			float4 tex2DNode30 = tex2D( _Mask_Tex, uv_Mask_Tex );
			float4 MaskTex116 = tex2DNode30;
			float2 temp_output_1_0_g25 = float2( 0.5,0.5 );
			float2 appendResult10_g25 = (float2(( (temp_output_1_0_g25).x * i.uv_texcoord.x ) , ( i.uv_texcoord.y * (temp_output_1_0_g25).y )));
			float2 temp_output_11_0_g25 = float2( 0.1,0.1 );
			float2 panner18_g25 = ( ( (temp_output_11_0_g25).x * _Time.y ) * float2( 1,0 ) + i.uv_texcoord);
			float2 panner19_g25 = ( ( _Time.y * (temp_output_11_0_g25).y ) * float2( 0,1 ) + i.uv_texcoord);
			float2 appendResult24_g25 = (float2((panner18_g25).x , (panner19_g25).y));
			float2 appendResult89 = (float2(_Tex2X , _Tex2y));
			float2 appendResult83 = (float2(_Tex2speedx , _Tex2speedy));
			float2 temp_output_47_0_g25 = appendResult83;
			float2 temp_output_31_0_g25 = ( temp_output_80_0 - float2( 1,1 ) );
			float2 appendResult39_g25 = (float2(frac( ( atan2( (temp_output_31_0_g25).x , (temp_output_31_0_g25).y ) / 6.28318548202515 ) ) , length( temp_output_31_0_g25 )));
			float2 panner54_g25 = ( ( (temp_output_47_0_g25).x * _Time.y ) * float2( 1,0 ) + appendResult39_g25);
			float2 panner55_g25 = ( ( _Time.y * (temp_output_47_0_g25).y ) * float2( 0,1 ) + appendResult39_g25);
			float2 appendResult58_g25 = (float2((panner54_g25).x , (panner55_g25).y));
			float2 temp_cast_5 = (temp_output_124_0).xx;
			float2 temp_cast_6 = (temp_output_125_0).xx;
			float4 temp_cast_7 = (1.0).xxxx;
			float2 temp_output_1_0_g24 = float2( 0.5,0.5 );
			float2 appendResult10_g24 = (float2(( (temp_output_1_0_g24).x * i.uv_texcoord.x ) , ( i.uv_texcoord.y * (temp_output_1_0_g24).y )));
			float2 temp_output_11_0_g24 = float2( 0.1,0.1 );
			float2 panner18_g24 = ( ( (temp_output_11_0_g24).x * _Time.y ) * float2( 1,0 ) + i.uv_texcoord);
			float2 panner19_g24 = ( ( _Time.y * (temp_output_11_0_g24).y ) * float2( 0,1 ) + i.uv_texcoord);
			float2 appendResult24_g24 = (float2((panner18_g24).x , (panner19_g24).y));
			float2 appendResult33 = (float2(_Noise_U , _Noise_V));
			float2 appendResult36 = (float2(_NoiseSpeed_X , _Noise_Speed_Y));
			float2 temp_output_47_0_g24 = appendResult36;
			float2 temp_output_21_0 = ( i.uv2_texcoord2 / float2( 0.5,0.5 ) );
			float2 temp_output_31_0_g24 = ( temp_output_21_0 - float2( 1,1 ) );
			float2 appendResult39_g24 = (float2(frac( ( atan2( (temp_output_31_0_g24).x , (temp_output_31_0_g24).y ) / 6.28318548202515 ) ) , length( temp_output_31_0_g24 )));
			float2 panner54_g24 = ( ( (temp_output_47_0_g24).x * _Time.y ) * float2( 1,0 ) + appendResult39_g24);
			float2 panner55_g24 = ( ( _Time.y * (temp_output_47_0_g24).y ) * float2( 0,1 ) + appendResult39_g24);
			float2 appendResult58_g24 = (float2((panner54_g24).x , (panner55_g24).y));
			float2 temp_cast_8 = (temp_output_124_0).xx;
			float2 temp_cast_9 = (temp_output_125_0).xx;
			float4 temp_cast_10 = (_Noise_Power).xxxx;
			float2 temp_output_1_0_g26 = float2( 0.5,0.5 );
			float2 appendResult10_g26 = (float2(( (temp_output_1_0_g26).x * i.uv_texcoord.x ) , ( i.uv_texcoord.y * (temp_output_1_0_g26).y )));
			float2 temp_output_11_0_g26 = float2( 0.1,0.1 );
			float2 panner18_g26 = ( ( (temp_output_11_0_g26).x * _Time.y ) * float2( 1,0 ) + i.uv_texcoord);
			float2 panner19_g26 = ( ( _Time.y * (temp_output_11_0_g26).y ) * float2( 0,1 ) + i.uv_texcoord);
			float2 appendResult24_g26 = (float2((panner18_g26).x , (panner19_g26).y));
			float2 appendResult39 = (float2(_Tex_U , _Tex_V));
			float2 appendResult42 = (float2(_Tex_Speed_X , _Tex_Speed_Y));
			float2 temp_output_47_0_g26 = appendResult42;
			float2 temp_output_31_0_g26 = ( temp_output_21_0 - float2( 1,1 ) );
			float2 appendResult39_g26 = (float2(frac( ( atan2( (temp_output_31_0_g26).x , (temp_output_31_0_g26).y ) / 6.28318548202515 ) ) , length( temp_output_31_0_g26 )));
			float2 panner54_g26 = ( ( (temp_output_47_0_g26).x * _Time.y ) * float2( 1,0 ) + appendResult39_g26);
			float2 panner55_g26 = ( ( _Time.y * (temp_output_47_0_g26).y ) * float2( 0,1 ) + appendResult39_g26);
			float2 appendResult58_g26 = (float2((panner54_g26).x , (panner55_g26).y));
			float2 temp_cast_13 = (temp_output_124_0).xx;
			float2 temp_cast_14 = (temp_output_125_0).xx;
			float4 temp_cast_15 = (1.0).xxxx;
			float4 temp_output_20_0 = saturate( ( ( max( lerp(float4( 0,0,0,0 ),( _Tex2_power * tex2D( _Main_Tex2, ( ( tex2D( _Noise_Tex2, ( ( (tex2D( _Sampler6085, ( appendResult10_g21 + appendResult24_g21 ) )).rg * 0.05 ) + ( appendResult82 * appendResult58_g21 ) ), temp_cast_0, temp_cast_1 ) * lerp(temp_cast_2,( _Noise2_power * ( 1.0 - MaskTex116 ) ),_Noise2mask) ) + float4( ( ( (tex2D( _Sampler6094, ( appendResult10_g25 + appendResult24_g25 ) )).rg * 0.05 ) + ( appendResult89 * appendResult58_g25 ) ), 0.0 , 0.0 ) ).rg, temp_cast_5, temp_cast_6 ) * lerp(temp_cast_7,_Tex2_color,_useTex2color) ),_use_twoTex) , ( _Tex1_power * tex2D( _Main_Tex, ( ( tex2D( _Noise_Tex, ( ( (tex2D( _Sampler6063, ( appendResult10_g24 + appendResult24_g24 ) )).rg * 0.05 ) + ( appendResult33 * appendResult58_g24 ) ), temp_cast_8, temp_cast_9 ) * lerp(temp_cast_10,( _Noise_Power * ( 1.0 - MaskTex116 ) ),_NoiseMask) ) + float4( ( ( (tex2D( _Sampler602, ( appendResult10_g26 + appendResult24_g26 ) )).rg * 0.05 ) + ( appendResult39 * appendResult58_g26 ) ), 0.0 , 0.0 ) ).rg, temp_cast_13, temp_cast_14 ) * lerp(temp_cast_15,_Tex1_color,_useTexcolor) ) ) + _Bias ) * _Scale ) );
			float4 lerpResult67 = lerp( _out_color , _In_color , saturate( ( _Lerp_power * tex2DNode30 ) ));
			o.Emission = ( temp_output_20_0 * lerpResult67 ).rgb;
			o.Alpha = ( temp_output_20_0 * tex2DNode30 ).r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 

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
88;78;1187;933;2520.433;830.0165;3.034337;True;True
Node;AmplifyShaderEditor.SamplerNode;30;251.0853,584.1243;Float;True;Property;_Mask_Tex;Mask_Tex;34;0;Create;True;0;0;False;0;None;3197984d9d7b8b848903cd32448806c6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;116;712.8625,861.4236;Float;False;MaskTex;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-2383.007,-674.522;Float;False;Property;_Noise2_Speedx;Noise2_Speedx;32;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;121;-1877.773,-610.15;Float;False;116;MaskTex;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;75;-2391.089,-591.4003;Float;False;Property;_Noise2_Speedy;Noise2_Speedy;33;0;Create;True;0;0;False;0;1;-0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;73;-2329.365,-763.6248;Float;False;Property;_Noise2_Y;Noise2_Y;31;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;76;-2630.985,-369.693;Float;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;74;-2336.505,-841.2489;Float;False;Property;_Noise2x;Noise2 x;30;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-2155.375,369.528;Float;False;Property;_Noise_U;Noise_U;25;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;91;-1616.856,-731.5585;Float;False;Property;_Noise2_power;Noise2_power;24;0;Create;True;0;0;False;0;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;122;-1662.261,-584.141;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-2228.081,614.846;Float;False;Property;_Noise_Speed_Y;Noise_Speed_Y;28;0;Create;True;0;0;False;0;1;-0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-2166.357,442.6215;Float;False;Property;_Noise_V;Noise_V;26;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;81;-2109.186,-674.1013;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;80;-2033.433,-500.9434;Float;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;82;-2101.815,-826.9045;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-2227.57,531.4379;Float;False;Property;_NoiseSpeed_X;Noise Speed_X;27;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;117;-1744.82,596.4556;Float;False;116;MaskTex;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-2400.755,815.8695;Float;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;88;-2171.34,-256.1672;Float;False;Property;_Tex2y;Tex2y;18;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;33;-1938.808,379.3418;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;123;-1529.544,-643.0994;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;85;-1951.332,-892.1552;Float;True;RadialUVDistortion;-1;;21;051d65e7699b41a4c800363fd0e822b2;0;7;60;SAMPLER2D;_Sampler6085;False;1;FLOAT2;0.5,0.5;False;11;FLOAT2;0.1,0.1;False;65;FLOAT;0.05;False;68;FLOAT2;1,1;False;47;FLOAT2;0.2,0.1;False;29;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DdyOpNode;125;-1350.501,-177.2331;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DdxOpNode;124;-1400.949,-316.7067;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;21;-1858.987,708.1625;Float;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-1438.929,487.7431;Float;False;Property;_Noise_Power;Noise_Power;23;0;Create;True;0;0;False;0;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;36;-1954.321,510.4299;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;86;-2172.059,-339.3888;Float;False;Property;_Tex2X;Tex2X;17;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;119;-1534.479,632.8065;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;78;-2185.204,-175.4053;Float;False;Property;_Tex2speedx;Tex2speedx;19;0;Create;True;0;0;False;0;1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;79;-2180.357,-93.38435;Float;False;Property;_Tex2speedy;Tex2 speedy;20;0;Create;True;0;0;False;0;1;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;87;-1792.694,-1131.653;Float;True;Property;_Noise_Tex2;Noise_Tex2;29;0;Create;True;0;0;False;0;None;e28dc97a9541e3642a48c0e3886688c5;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.DynamicAppendNode;83;-1924.309,-147.4613;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-2008.332,950.0791;Float;False;Property;_Tex_V;Tex_V;10;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;90;-1489.435,-942.6305;Float;True;Property;_TextureSample3;Texture Sample 3;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Derivative;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;63;-1788.324,314.0912;Float;True;RadialUVDistortion;-1;;24;051d65e7699b41a4c800363fd0e822b2;0;7;60;SAMPLER2D;_Sampler6063;False;1;FLOAT2;0.5,0.5;False;11;FLOAT2;0.1,0.1;False;65;FLOAT;0.05;False;68;FLOAT2;1,1;False;47;FLOAT2;0.2,0.1;False;29;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-2009.051,866.8575;Float;False;Property;_Tex_U;Tex_U;9;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;89;-1936.065,-250.5443;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;118;-1357.493,605.4337;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-2017.349,1112.862;Float;False;Property;_Tex_Speed_Y;Tex_Speed_Y;12;0;Create;True;0;0;False;0;1;-0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;120;-1328.555,-703.5419;Float;False;Property;_Noise2mask;Noise2mask;35;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-2022.196,1030.841;Float;False;Property;_Tex_Speed_X;Tex_Speed_X;11;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;15;-1629.686,74.59332;Float;True;Property;_Noise_Tex;Noise_Tex;22;0;Create;True;0;0;False;0;None;e28dc97a9541e3642a48c0e3886688c5;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;64;-1324.352,265.6906;Float;True;Property;_TextureSample2;Texture Sample 2;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Derivative;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;42;-1761.301,1058.785;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ToggleSwitchNode;115;-1215.955,479.1458;Float;False;Property;_NoiseMask;NoiseMask;36;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;93;-1094.053,-738.5606;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;39;-1773.057,955.702;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;94;-1437.948,-571.5109;Float;True;RadialUVDistortion;-1;;25;051d65e7699b41a4c800363fd0e822b2;0;7;60;SAMPLER2D;_Sampler6094;False;1;FLOAT2;0.5,0.5;False;11;FLOAT2;0.1,0.1;False;65;FLOAT;0.05;False;68;FLOAT2;1,1;False;47;FLOAT2;0.2,0.1;False;29;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;96;-710.6511,-888.8964;Float;True;Property;_Main_Tex2;Main_Tex2;14;0;Create;True;0;0;False;0;9789d23040cb1fb45ad60392430c3c15;3d70f8d53a519e041abb8b7594c1c31f;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleAddOpNode;95;-945.5164,-591.6924;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT2;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;109;-764.4975,-192.9777;Float;False;Property;_Tex2_color;Tex2_color;16;1;[HDR];Create;True;0;0;False;0;1,0,0,0;0.513653,0.7620299,1.414214,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;112;-518.4628,-24.95404;Float;False;Constant;_Float0;Float 0;33;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;2;-1161.94,747.7355;Float;True;RadialUVDistortion;-1;;26;051d65e7699b41a4c800363fd0e822b2;0;7;60;SAMPLER2D;_Sampler602;False;1;FLOAT2;0.5,0.5;False;11;FLOAT2;0.1,0.1;False;65;FLOAT;0.05;False;68;FLOAT2;1,1;False;47;FLOAT2;0.2,0.1;False;29;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;-987.0456,436.6857;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;97;-737.8795,-586.2177;Float;True;Property;_TextureSample4;Texture Sample 4;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Derivative;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;17;-793.0768,390.1041;Float;True;Property;_Main_Tex;Main_Tex;6;0;Create;True;0;0;False;0;9789d23040cb1fb45ad60392430c3c15;d9526d8ad23bef44fb6e8fc0a9de98ad;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.ToggleSwitchNode;113;-420.949,-186.977;Float;False;Property;_useTex2color;use Tex2 color;15;0;Create;True;0;0;False;0;1;2;0;COLOR;0,0,0,0;False;1;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;107;-442.0341,-298.2272;Float;False;Property;_Tex2_power;Tex2_power;21;0;Create;True;0;0;False;0;1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;108;-767.4076,87.35515;Float;False;Property;_Tex1_color;Tex1_color;8;1;[HDR];Create;True;0;0;False;0;1,0.7988446,0,0;0.7764706,1.145098,1.498039,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;65;-639.5215,728.0894;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT2;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;111;-345.9384,158.072;Float;False;Property;_useTexcolor;use Tex color;7;0;Create;True;0;0;False;0;1;2;0;COLOR;0,0,0,0;False;1;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;105;-200.0814,308.459;Float;False;Property;_Tex1_power;Tex1_power;13;0;Create;True;0;0;False;0;1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;106;-281.3342,-308.2272;Float;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;6;-398.172,548.7286;Float;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Derivative;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;69;705.3124,-114.4076;Float;False;Property;_Lerp_power;Lerp_power;3;0;Create;True;0;0;False;0;3.5;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;98;-123.2809,-295.1301;Float;False;Property;_use_twoTex;use_twoTex;0;0;Create;True;0;0;False;0;1;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;104;-66.72116,-67.15904;Float;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;24;187.1855,319.209;Float;False;Property;_Scale;Scale;5;0;Create;True;0;0;False;0;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;103;266.7385,-247.3157;Float;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;937.1789,-85.24406;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;23;262.8224,160.3908;Float;False;Property;_Bias;Bias;4;0;Create;True;0;0;False;0;-0.35;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;72;1117.624,-171.3016;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;27;841.6479,-402.0611;Float;False;Property;_out_color;out_color;1;1;[HDR];Create;True;0;0;False;0;1,0.4386792,0.4386792,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;18;606.5387,-48.39751;Float;True;ConstantBiasScale;-1;;27;63208df05c83e8e49a48ffbdce2e43a0;0;3;3;COLOR;0,0,0,0;False;1;FLOAT;-0.3;False;2;FLOAT;2;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;71;848.5807,-247.6013;Float;False;Property;_In_color;In_color;2;1;[HDR];Create;True;0;0;False;0;1,0.4386792,0.4386792,0;0.8726415,0.9234184,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;20;862.3629,139.8199;Float;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;67;1234.211,-291.0942;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;1083.421,317.3499;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;1516.396,-138.6161;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1873.549,-107.8486;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;radial_uv;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;116;0;30;0
WireConnection;122;0;121;0
WireConnection;81;0;77;0
WireConnection;81;1;75;0
WireConnection;80;0;76;0
WireConnection;82;0;74;0
WireConnection;82;1;73;0
WireConnection;33;0;35;0
WireConnection;33;1;34;0
WireConnection;123;0;91;0
WireConnection;123;1;122;0
WireConnection;85;68;82;0
WireConnection;85;47;81;0
WireConnection;85;29;80;0
WireConnection;125;0;76;2
WireConnection;124;0;76;1
WireConnection;21;0;3;0
WireConnection;36;0;38;0
WireConnection;36;1;37;0
WireConnection;119;0;117;0
WireConnection;83;0;78;0
WireConnection;83;1;79;0
WireConnection;90;0;87;0
WireConnection;90;1;85;0
WireConnection;90;3;124;0
WireConnection;90;4;125;0
WireConnection;63;68;33;0
WireConnection;63;47;36;0
WireConnection;63;29;21;0
WireConnection;89;0;86;0
WireConnection;89;1;88;0
WireConnection;118;0;28;0
WireConnection;118;1;119;0
WireConnection;120;0;91;0
WireConnection;120;1;123;0
WireConnection;64;0;15;0
WireConnection;64;1;63;0
WireConnection;64;3;124;0
WireConnection;64;4;125;0
WireConnection;42;0;44;0
WireConnection;42;1;43;0
WireConnection;115;0;28;0
WireConnection;115;1;118;0
WireConnection;93;0;90;0
WireConnection;93;1;120;0
WireConnection;39;0;41;0
WireConnection;39;1;40;0
WireConnection;94;68;89;0
WireConnection;94;47;83;0
WireConnection;94;29;80;0
WireConnection;95;0;93;0
WireConnection;95;1;94;0
WireConnection;2;68;39;0
WireConnection;2;47;42;0
WireConnection;2;29;21;0
WireConnection;66;0;64;0
WireConnection;66;1;115;0
WireConnection;97;0;96;0
WireConnection;97;1;95;0
WireConnection;97;3;124;0
WireConnection;97;4;125;0
WireConnection;113;0;112;0
WireConnection;113;1;109;0
WireConnection;65;0;66;0
WireConnection;65;1;2;0
WireConnection;111;0;112;0
WireConnection;111;1;108;0
WireConnection;106;0;107;0
WireConnection;106;1;97;0
WireConnection;106;2;113;0
WireConnection;6;0;17;0
WireConnection;6;1;65;0
WireConnection;6;3;124;0
WireConnection;6;4;125;0
WireConnection;98;1;106;0
WireConnection;104;0;105;0
WireConnection;104;1;6;0
WireConnection;104;2;111;0
WireConnection;103;0;98;0
WireConnection;103;1;104;0
WireConnection;68;0;69;0
WireConnection;68;1;30;0
WireConnection;72;0;68;0
WireConnection;18;3;103;0
WireConnection;18;1;23;0
WireConnection;18;2;24;0
WireConnection;20;0;18;0
WireConnection;67;0;27;0
WireConnection;67;1;71;0
WireConnection;67;2;72;0
WireConnection;29;0;20;0
WireConnection;29;1;30;0
WireConnection;25;0;20;0
WireConnection;25;1;67;0
WireConnection;0;2;25;0
WireConnection;0;9;29;0
ASEEND*/
//CHKSM=6C2BC0522A6D824C3B30BD56F071AE9C3A8BC0F8