// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "swap"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_DisolveGuide("Disolve Guide", 2D) = "white" {}
		_DissolveAmount("Dissolve Amount", Range( 0 , 1)) = 0
		_scrollpower_1("scrollpower_1", Vector) = (0.3,0,0,0)
		_Vector4("Vector 4", Vector) = (1,1,0,0)
		_scrollpower_2("scrollpower_2", Vector) = (0.3,0,0,0)
		_Vector3("Vector 3", Vector) = (-0.3,0,0,0)
		_tex_d_power("tex_d_power", Vector) = (0.1,0,0,0)
		_line_tex1("line_tex1", 2D) = "white" {}
		_line_tex2("line_tex2", 2D) = "white" {}
		_Float3("Float 3", Float) = 0.05
		_noise_power_1("noise_power_1", Float) = 0.01
		_noise_power_2("noise_power_2", Float) = 0.01
		_Float0("Float 0", Float) = 0.05
		_TextureSample8("Texture Sample 8", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_tex_color("tex_color", Color) = (1,1,1,1)
		[HDR]_Color0("Color 0", Color) = (1,1,1,1)
		_TextureSample9("Texture Sample 9", 2D) = "white" {}
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
		uniform sampler2D _TextureSample1;
		uniform float2 _Vector3;
		uniform float _Float3;
		uniform sampler2D _TextureSample8;
		uniform float2 _tex_d_power;
		uniform float _Float0;
		uniform float4 _tex_color;
		uniform sampler2D _TextureSample9;
		uniform sampler2D _line_tex1;
		uniform float2 _Vector4;
		uniform float2 _scrollpower_2;
		uniform float _noise_power_1;
		uniform sampler2D _line_tex2;
		uniform float2 _scrollpower_1;
		uniform float _noise_power_2;
		uniform float _DissolveAmount;
		uniform sampler2D _DisolveGuide;
		uniform float4 _Color0;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 temp_output_92_0 = ( tex2D( _TextureSample0, ( float4( i.uv_texcoord, 0.0 , 0.0 ) + ( ( tex2D( _TextureSample1, ( i.uv_texcoord + ( _Vector3 * _Time.y ) ) ) * _Float3 ) + ( tex2D( _TextureSample8, ( i.uv_texcoord + ( _tex_d_power * _Time.y ) ) ) * _Float0 ) ) ).rg ) * _tex_color );
			float2 uv_TexCoord167 = i.uv_texcoord * _Vector4;
			o.Albedo = ( temp_output_92_0 * tex2D( _TextureSample9, ( float4( i.uv_texcoord, 0.0 , 0.0 ) + ( tex2D( _line_tex1, ( uv_TexCoord167 + ( _scrollpower_2 * _Time.y ) ) ) * _noise_power_1 ) + ( tex2D( _line_tex2, ( uv_TexCoord167 + ( _scrollpower_1 * _Time.y ) ) ) * _noise_power_2 ) ).rg ) ).rgb;
			float2 uv_TexCoord195 = i.uv_texcoord * float2( 2,2 ) + float2( -0.5,-0.5 );
			float4 tex2DNode154 = tex2D( _DisolveGuide, uv_TexCoord195 );
			float clampResult157 = clamp( (-4.0 + (( (-0.6 + (( 1.0 - _DissolveAmount ) - 0.0) * (0.6 - -0.6) / (1.0 - 0.0)) + tex2DNode154.r ) - 0.0) * (4.0 - -4.0) / (1.0 - 0.0)) , 0.0 , 1.0 );
			float temp_output_158_0 = ( 1.0 - clampResult157 );
			o.Emission = ( temp_output_92_0 + ( temp_output_158_0 * ( _Color0 + float4( 0,0,0,0 ) ) ) ).rgb;
			o.Alpha = ( tex2DNode154 * ( 1.0 - _DissolveAmount ) ).r;
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
539;280;1191;570;4967.761;1667.874;7.261994;True;False
Node;AmplifyShaderEditor.TimeNode;141;-1352.717,-762.1794;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;190;-1285.816,-1421.424;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;140;-1379.318,-969.1688;Float;False;Property;_tex_d_power;tex_d_power;11;0;Create;True;0;0;False;0;0.1,0;0,0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;189;-1312.417,-1628.414;Float;False;Property;_Vector3;Vector 3;10;0;Create;True;0;0;False;0;-0.3,0;0.1,-0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;151;-1497.886,126.034;Float;False;Property;_DissolveAmount;Dissolve Amount;3;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;266;-954.8884,860.6428;Float;True;Constant;_Vector6;Vector 6;28;0;Create;True;0;0;False;0;-0.5,-0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;264;-954.8868,715.5667;Float;False;Constant;_Vector0;Vector 0;28;0;Create;True;0;0;False;0;2,2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;188;-1023.257,-1554.288;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;142;-1090.158,-895.043;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;143;-961.4028,-979.3941;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;163;-2468.463,1530.05;Float;False;Property;_scrollpower_2;scrollpower_2;8;0;Create;True;0;0;False;0;0.3,0;0,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;178;-2652.198,1140.616;Float;False;Property;_scrollpower_1;scrollpower_1;5;0;Create;True;0;0;False;0;0.3,0;0,2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TimeNode;164;-2530.418,924.4485;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;177;-2649.597,1348.961;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;152;-1140.067,615.6774;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;194;-2196.667,515.8845;Float;False;Property;_Vector4;Vector 4;7;0;Create;True;0;0;False;0;1,1;2,2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;195;-716.9079,758.4325;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;144;-929.1665,-780.1481;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;187;-862.2656,-1439.393;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;147;-694.3636,-426.4866;Float;False;Property;_Float0;Float 0;21;0;Create;True;0;0;False;0;0.05;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;192;-607.6951,-1112.06;Float;False;Property;_Float3;Float 3;16;0;Create;True;0;0;False;0;0.05;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;179;-2387.035,1216.097;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;186;-740.12,-1342.922;Float;True;Property;_TextureSample1;Texture Sample 1;23;0;Create;True;0;0;False;0;df1a73877e6e817489bcdec99d204d81;a8c8f3879983aa643b7e058f8fc14498;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;153;-1148.951,414.9883;Float;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.6;False;4;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;154;-494.9419,706.6096;Float;True;Property;_DisolveGuide;Disolve Guide;1;0;Create;True;0;0;False;0;ba93efbdacad0824c86a148fd77e554e;8c4a7fca2884fab419769ccc0355c0c1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;145;-837.5704,-688.0421;Float;True;Property;_TextureSample8;Texture Sample 8;22;0;Create;True;0;0;False;0;df1a73877e6e817489bcdec99d204d81;a8c8f3879983aa643b7e058f8fc14498;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;167;-1986.287,595.0267;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;165;-2267.856,791.5843;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;146;-538.6505,-590.7292;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;191;-451.9821,-1276.302;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;180;-2226.045,1330.992;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;156;-759.3184,542.1804;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;166;-2106.866,906.4797;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;193;-217.795,-1051.571;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;162;-1257.878,-7.150861;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-4;False;4;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;172;-1836.682,1257.391;Float;False;Property;_noise_power_1;noise_power_1;17;0;Create;True;0;0;False;0;0.01;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;183;-1787.388,1602.728;Float;False;Property;_noise_power_2;noise_power_2;20;0;Create;True;0;0;False;0;0.01;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;181;-2103.899,1427.462;Float;True;Property;_line_tex2;line_tex2;15;0;Create;True;0;0;False;0;df1a73877e6e817489bcdec99d204d81;12d6b7d262476274084aad78f279cd0c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;169;-1984.72,1002.95;Float;True;Property;_line_tex1;line_tex1;13;0;Create;True;0;0;False;0;df1a73877e6e817489bcdec99d204d81;5baef9617239b944e95c18ee0f2d8e77;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;265;-1501.622,922.7269;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;182;-1674.044,1381.756;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;173;-1658.017,1051.512;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;157;-960.5057,-8.197901;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;175;-766.7073,224.0969;Float;False;Property;_Color0;Color 0;25;1;[HDR];Create;True;0;0;False;0;1,1,1,1;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;148;24.96563,-839.4753;Float;True;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;185;-499.573,233.1398;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;131;-222.6365,-167.4822;Float;False;Property;_tex_color;tex_color;24;0;Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;59;227.7271,-521.3223;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;ba93efbdacad0824c86a148fd77e554e;e4f20d2e47818b449ada615520e8c5f2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;158;-772.9039,69.57629;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;168;-1370.662,1148.702;Float;True;3;3;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;259;-1160.849,348.2361;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;256;-719.1346,1042.566;Float;True;Property;_TextureSample9;Texture Sample 9;27;0;Create;True;0;0;False;0;None;6e6cba53deb4f4e41a81667b73a1ca42;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;265.1763,-266.1434;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;161;-156.1948,53.33792;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;246;-1776.515,2244.346;Float;True;3;3;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;257;-2901.385,2673.915;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;241;-2242.534,2353.035;Float;False;Property;_Float1;Float 1;18;0;Create;True;0;0;False;0;0.2;0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;236;-2673.708,1887.228;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TimeNode;231;-2977.513,2011.255;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;232;-3058.05,2236.26;Float;False;Property;_Vector2;Vector 2;4;0;Create;True;0;0;False;0;0.3,0;0.1,0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;160;-1411.147,2264.13;Float;True;Property;_dis;dis;2;0;Create;True;0;0;False;0;None;59cd4e5b90f6739408f5fbf92f61feaa;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;237;-2512.719,2002.124;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;248;-218.5623,440.6939;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;244;-2063.87,2147.156;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;233;-2955.526,1770.073;Float;False;Property;_Vector5;Vector 5;9;0;Create;True;0;0;False;0;0.3,0;0,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;242;-2193.24,2698.372;Float;False;Property;_Float2;Float 2;19;0;Create;True;0;0;False;0;0.1;0.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;240;-2390.572,2098.594;Float;True;Property;_TextureSample4;Texture Sample 4;12;0;Create;True;0;0;False;0;None;9fbef4b79ca3b784ba023cb1331520d5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;171;186.9402,192.9636;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;261;-2247.467,-939.2946;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;255;453.0606,25.29722;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;230;-2602.52,1611.528;Float;False;Property;_Vector1;Vector 1;6;0;Create;True;0;0;False;0;0.3,0;5,5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;227;389.1166,838.9515;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;200;-852.5151,1825.265;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;243;-2120.101,1861.098;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;228;23.33672,685.7434;Float;False;Property;_out_light_power;out_light_power;26;1;[HDR];Create;True;0;0;False;0;1.247059,1.027451,2,0;0.547372,1.247773,0.9404541,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;159;-585.6405,77.90461;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;239;-2509.751,2523.107;Float;True;Property;_TextureSample2;Texture Sample 2;14;0;Create;True;0;0;False;0;None;e28dc97a9541e3642a48c0e3886688c5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;234;-2392.139,1690.671;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;235;-2792.887,2311.741;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TimeNode;229;-3055.449,2444.606;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;262;-2090.724,-893.8185;Float;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;263;-2136.087,-883.3971;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;245;-2079.896,2477.401;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;238;-2631.897,2426.636;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;787.4865,302.758;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;swap;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;2;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;188;0;189;0
WireConnection;188;1;190;2
WireConnection;142;0;140;0
WireConnection;142;1;141;2
WireConnection;152;0;151;0
WireConnection;195;0;264;0
WireConnection;195;1;266;0
WireConnection;144;0;143;0
WireConnection;144;1;142;0
WireConnection;187;0;143;0
WireConnection;187;1;188;0
WireConnection;179;0;178;0
WireConnection;179;1;177;2
WireConnection;186;1;187;0
WireConnection;153;0;152;0
WireConnection;154;1;195;0
WireConnection;145;1;144;0
WireConnection;167;0;194;0
WireConnection;165;0;163;0
WireConnection;165;1;164;2
WireConnection;146;0;145;0
WireConnection;146;1;147;0
WireConnection;191;0;186;0
WireConnection;191;1;192;0
WireConnection;180;0;167;0
WireConnection;180;1;179;0
WireConnection;156;0;153;0
WireConnection;156;1;154;1
WireConnection;166;0;167;0
WireConnection;166;1;165;0
WireConnection;193;0;191;0
WireConnection;193;1;146;0
WireConnection;162;0;156;0
WireConnection;181;1;180;0
WireConnection;169;1;166;0
WireConnection;182;0;181;0
WireConnection;182;1;183;0
WireConnection;173;0;169;0
WireConnection;173;1;172;0
WireConnection;157;0;162;0
WireConnection;148;0;143;0
WireConnection;148;1;193;0
WireConnection;185;0;175;0
WireConnection;59;1;148;0
WireConnection;158;0;157;0
WireConnection;168;0;265;0
WireConnection;168;1;173;0
WireConnection;168;2;182;0
WireConnection;259;0;151;0
WireConnection;256;1;168;0
WireConnection;92;0;59;0
WireConnection;92;1;131;0
WireConnection;161;0;158;0
WireConnection;161;1;185;0
WireConnection;246;0;243;0
WireConnection;246;1;244;0
WireConnection;246;2;245;0
WireConnection;236;0;233;0
WireConnection;236;1;231;2
WireConnection;160;1;246;0
WireConnection;237;0;234;0
WireConnection;237;1;236;0
WireConnection;248;0;154;0
WireConnection;248;1;259;0
WireConnection;244;0;240;0
WireConnection;244;1;241;0
WireConnection;240;1;237;0
WireConnection;171;0;92;0
WireConnection;171;1;161;0
WireConnection;255;0;92;0
WireConnection;255;1;256;0
WireConnection;227;0;200;0
WireConnection;227;1;228;0
WireConnection;200;0;151;0
WireConnection;200;1;160;0
WireConnection;159;0;158;0
WireConnection;239;1;238;0
WireConnection;234;0;230;0
WireConnection;235;0;232;0
WireConnection;235;1;229;2
WireConnection;262;0;261;0
WireConnection;245;0;239;0
WireConnection;245;1;242;0
WireConnection;238;0;257;0
WireConnection;238;1;235;0
WireConnection;0;0;255;0
WireConnection;0;2;171;0
WireConnection;0;9;248;0
ASEEND*/
//CHKSM=5B0CE2EC820F37285469B7BA3EB4BFD2ADE147FB