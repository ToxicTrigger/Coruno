// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "new_trail"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Power_f("Power_f", Range( 0 , 5)) = 0.2334346
		_power("power", Range( 0 , 2)) = 0.2334346
		_y("y", Float) = -0.5
		_Float2("Float 2", Range( 0 , 2)) = 0.2334346
		_Float6("Float 6", Float) = -1
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_Float5("Float 5", Float) = -2
		_x("x", Float) = -2
		[HDR]_Color1("Color 1", Color) = (0,0,0,0)
		[HDR]_Color0("Color 0", Color) = (0,0,0,0)
		[Toggle]_uschanel("us chanel", Float) = 0
		[Toggle]_userorb("use r or b", Float) = 1
		_tile_x("tile_x", Float) = 0
		_taile_y("taile_y", Float) = 0
		[Toggle]_ToggleSwitch0("Toggle Switch0", Float) = 0
		[Toggle]_v("v", Float) = 1
		[Toggle]_v1("v1", Float) = 1
		_Opacity("Opacity", Float) = 1
		[Toggle]_use_vertexalpha("use_vertexalpha", Float) = 1
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
			float4 vertexColor : COLOR;
		};

		uniform float4 _Color0;
		uniform float4 _Color1;
		uniform float _ToggleSwitch0;
		uniform float _Float2;
		uniform float _userorb;
		uniform sampler2D _TextureSample0;
		uniform float _x;
		uniform float _y;
		uniform float _tile_x;
		uniform float _taile_y;
		uniform float _uschanel;
		uniform sampler2D _TextureSample1;
		uniform float _Float5;
		uniform float _Float6;
		uniform float _v;
		uniform float _power;
		uniform float _v1;
		uniform float _Power_f;
		uniform float _use_vertexalpha;
		uniform float _Opacity;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 lerpResult34 = lerp( _Color0 , _Color1 , (_Float2 + (lerp(i.uv_texcoord.x,i.uv_texcoord.y,_ToggleSwitch0) - 0.0) * (1.0 - _Float2) / (1.0 - 0.0)));
			o.Emission = lerpResult34.rgb;
			float2 appendResult20 = (float2(_x , _y));
			float2 appendResult47 = (float2(_tile_x , _taile_y));
			float2 uv_TexCoord2 = i.uv_texcoord * appendResult47;
			float2 panner16 = ( _Time.y * appendResult20 + uv_TexCoord2);
			float4 tex2DNode1 = tex2D( _TextureSample0, panner16 );
			float2 appendResult63 = (float2(_Float5 , _Float6));
			float2 panner64 = ( _Time.y * appendResult63 + uv_TexCoord2);
			float4 temp_cast_1 = (tex2DNode1.g).xxxx;
			float temp_output_4_0 = (( _power * -1.0 ) + (lerp(i.uv_texcoord.x,i.uv_texcoord.y,_v) - 0.0) * (1.0 - ( _power * -1.0 )) / (1.0 - 0.0));
			float4 temp_cast_2 = (temp_output_4_0).xxxx;
			float4 temp_output_13_0 = ( lerp(tex2D( _TextureSample1, panner64 ),temp_cast_1,_uschanel) - temp_cast_2 );
			float4 temp_cast_3 = (tex2DNode1.g).xxxx;
			float4 temp_cast_4 = (temp_output_4_0).xxxx;
			float4 temp_cast_5 = ((( _Power_f * -2.49 ) + (lerp(( 1.0 - i.uv_texcoord.x ),( 1.0 - i.uv_texcoord.y ),_v1) - 0.0) * (1.0 - ( _Power_f * -2.49 )) / (1.0 - 0.0))).xxxx;
			o.Alpha = ( saturate( ( lerp(tex2DNode1.r,tex2DNode1.b,_userorb) * saturate( ( temp_output_13_0 / ( ( temp_output_4_0 + _power ) - temp_output_4_0 ) ) ) * saturate( ( temp_output_13_0 - temp_cast_5 ) ) ) ) * lerp(i.vertexColor.a,_Opacity,_use_vertexalpha) ).r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows 

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
702;236;937;807;2958.751;1097.475;2.874519;True;True
Node;AmplifyShaderEditor.RangedFloatNode;46;-2184.699,160.4162;Float;False;Property;_tile_x;tile_x;13;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-2195.241,270.3602;Float;False;Property;_taile_y;taile_y;14;0;Create;True;0;0;False;0;0;1.53;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;47;-2046.139,195.056;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;60;-1087.22,280.6009;Float;False;Property;_Float6;Float 6;5;0;Create;True;0;0;False;0;-1;-0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1603.36,146.1936;Float;False;Property;_y;y;3;0;Create;True;0;0;False;0;-0.5;-0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;58;-1071.639,179.8595;Float;False;Property;_Float5;Float 5;7;0;Create;True;0;0;False;0;-2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-1599.232,70.64952;Float;False;Property;_x;x;8;0;Create;True;0;0;False;0;-2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-1501.288,767.6763;Float;False;Constant;_Float0;Float 0;3;0;Create;True;0;0;False;0;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1634.809,605.9127;Float;False;Property;_power;power;2;0;Create;True;0;0;False;0;0.2334346;1.84;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-1918.586,176.1422;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;49;-2105.7,631.8643;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;63;-917.5595,214.2634;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;20;-1424.537,110.7802;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TimeNode;17;-1646.866,290.6362;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;62;-946.3268,341.4339;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;52;-1633.591,431.7761;Float;False;Property;_v;v;16;0;Create;True;0;0;False;0;1;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-1366.794,349.3025;Float;False;Constant;_zero;zero;1;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;64;-747.6888,229.8808;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1387.554,517.5685;Float;False;Constant;_one;one;1;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;16;-1274.137,158.4669;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-1179.869,680.9192;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;51;-1822.37,927.5797;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;28;-1785.195,848.0331;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;8;-567.1835,170.2477;Float;True;Property;_TextureSample1;Texture Sample 1;6;0;Create;True;0;0;False;0;0df58e308f423a3469472cc0b69a5254;9df9676d3e7b3d44ca4cc6e7700acf00;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;31;-1835.16,1011.635;Float;False;Property;_Power_f;Power_f;1;0;Create;True;0;0;False;0;0.2334346;0.52;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;4;-992.9792,549.7381;Float;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-421.1739,-308.4047;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;82a8e66f31a9e654792bee0ab05f9fc8;c19d945f0c9ac8e4d80349548e6b818a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;30;-1701.639,1173.399;Float;False;Constant;_Float1;Float 1;3;0;Create;True;0;0;False;0;-2.49;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;45;-159.7462,203.4068;Float;False;Property;_uschanel;us chanel;11;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-1380.22,1086.642;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;50;-1565.133,919.2816;Float;False;Property;_v1;v1;17;0;Create;True;0;0;False;0;1;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-410.8669,581.5186;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;14;-26.85316,463.6892;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;27;-1163.793,946.8414;Float;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;13;-46.61887,291.638;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;32;208.0729,678.0992;Float;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;15;239.3435,287.1246;Float;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;33;500.4155,555.9969;Float;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;24;548.3816,331.3027;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;41;171.9355,-70.43817;Float;False;Property;_userorb;use r or b;12;0;Create;True;0;0;False;0;1;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;811.0188,208.4428;Float;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;53;-1333.729,-51.74599;Float;False;Property;_ToggleSwitch0;Toggle Switch0;15;0;Create;True;0;0;False;0;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;65;878.5597,611.9129;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;66;1058.78,713.2751;Float;False;Property;_Opacity;Opacity;18;0;Create;True;0;0;False;0;1;0.34;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-994.0459,69.46828;Float;False;Property;_Float2;Float 2;4;0;Create;True;0;0;False;0;0.2334346;0.36;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;38;-410.7174,-98.23671;Float;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;23;449.8918,-300.5922;Float;False;Property;_Color0;Color 0;10;1;[HDR];Create;True;0;0;False;0;0,0,0,0;2.343689,0.6301428,1.010931,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;67;1204.251,543.1013;Float;False;Property;_use_vertexalpha;use_vertexalpha;19;0;Create;True;0;0;False;0;1;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;54;1057.493,182.7407;Float;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;36;365.8029,-10.35075;Float;False;Property;_Color1;Color 1;9;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0.1132075,0.1132075,0.1132075,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;34;802.6978,-165.7749;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;1305.984,235.8865;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1518.497,5.891023;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;new_trail;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;47;0;46;0
WireConnection;47;1;48;0
WireConnection;2;0;47;0
WireConnection;63;0;58;0
WireConnection;63;1;60;0
WireConnection;20;0;18;0
WireConnection;20;1;19;0
WireConnection;52;0;49;1
WireConnection;52;1;49;2
WireConnection;64;0;2;0
WireConnection;64;2;63;0
WireConnection;64;1;62;2
WireConnection;16;0;2;0
WireConnection;16;2;20;0
WireConnection;16;1;17;2
WireConnection;10;0;7;0
WireConnection;10;1;11;0
WireConnection;51;0;49;2
WireConnection;28;0;49;1
WireConnection;8;1;64;0
WireConnection;4;0;52;0
WireConnection;4;1;6;0
WireConnection;4;2;5;0
WireConnection;4;3;10;0
WireConnection;4;4;5;0
WireConnection;1;1;16;0
WireConnection;45;0;8;0
WireConnection;45;1;1;2
WireConnection;29;0;31;0
WireConnection;29;1;30;0
WireConnection;50;0;28;0
WireConnection;50;1;51;0
WireConnection;12;0;4;0
WireConnection;12;1;7;0
WireConnection;14;0;12;0
WireConnection;14;1;4;0
WireConnection;27;0;50;0
WireConnection;27;1;6;0
WireConnection;27;2;5;0
WireConnection;27;3;29;0
WireConnection;27;4;5;0
WireConnection;13;0;45;0
WireConnection;13;1;4;0
WireConnection;32;0;13;0
WireConnection;32;1;27;0
WireConnection;15;0;13;0
WireConnection;15;1;14;0
WireConnection;33;0;32;0
WireConnection;24;0;15;0
WireConnection;41;0;1;1
WireConnection;41;1;1;3
WireConnection;21;0;41;0
WireConnection;21;1;24;0
WireConnection;21;2;33;0
WireConnection;53;0;49;1
WireConnection;53;1;49;2
WireConnection;38;0;53;0
WireConnection;38;1;6;0
WireConnection;38;2;5;0
WireConnection;38;3;39;0
WireConnection;38;4;5;0
WireConnection;67;0;65;4
WireConnection;67;1;66;0
WireConnection;54;0;21;0
WireConnection;34;0;23;0
WireConnection;34;1;36;0
WireConnection;34;2;38;0
WireConnection;55;0;54;0
WireConnection;55;1;67;0
WireConnection;0;2;34;0
WireConnection;0;9;55;0
ASEEND*/
//CHKSM=9AF1571B373B741DCFF4AC2720DD0F7F339FA7D7