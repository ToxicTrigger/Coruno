// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "vertex_wa"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.87
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_xpower("x power", Float) = 0
		_ypower("y power", Float) = 0
		_Speed("Speed", Float) = 0.5
		_Color1("Color 1", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _xpower;
		uniform float _ypower;
		uniform float _Speed;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float4 _Color1;
		uniform float _Cutoff = 0.87;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 temp_cast_0 = (( ( ( ( ase_vertex3Pos.x * _xpower ) + ( ase_vertex3Pos.y * _ypower ) ) * sin( ( _Time.y * _Speed ) ) ) * v.color.r )).xxx;
			v.vertex.xyz += temp_cast_0;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 color20 = IsGammaSpace() ? float4(1,1,1,1) : float4(1,1,1,1);
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 tex2DNode1 = tex2D( _TextureSample0, uv_TextureSample0 );
			o.Emission = ( ( color20 * tex2DNode1 ) * _Color1 ).rgb;
			o.Alpha = 1;
			clip( tex2DNode1.a - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
1127;191;1148;961;1223.055;710.0165;1.562498;True;False
Node;AmplifyShaderEditor.TimeNode;34;-1190.94,24.73179;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;43;-948.0386,-76.15691;Float;False;Property;_ypower;y power;3;0;Create;True;0;0;False;0;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-1092.707,236.6852;Float;False;Property;_Speed;Speed;4;0;Create;True;0;0;False;0;0.5;1.69;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;58;-911.1215,-331.3049;Float;False;Property;_xpower;x power;2;0;Create;True;0;0;False;0;0;0.29;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;49;-1158.13,-318.6707;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-751.6604,-111.2858;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;-733.1575,-307.8197;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-894.8645,41.73713;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;53;-549.8475,-189.4178;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-389.6776,-310.9464;Float;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;None;328d827e41a57dd4b819d633f5f6c5d8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinOpNode;10;-576.4992,2.738392;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;20;-242.0472,-482.8212;Float;False;Constant;_Color0;Color 0;3;0;Create;True;0;0;False;0;1,1,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;11;-646.7786,185.246;Float;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;11.88064,-323.9718;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-305.3087,-76.73936;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;60;216.0056,-56.89238;Float;False;Property;_Color1;Color 1;5;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;4.641724,104.6176;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;576.9427,-88.14236;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;739.8657,-11.81239;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;vertex_wa;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.87;True;True;0;False;TransparentCutout;;AlphaTest;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;55;0;49;2
WireConnection;55;1;43;0
WireConnection;54;0;49;1
WireConnection;54;1;58;0
WireConnection;40;0;34;2
WireConnection;40;1;33;0
WireConnection;53;0;54;0
WireConnection;53;1;55;0
WireConnection;10;0;40;0
WireConnection;18;0;20;0
WireConnection;18;1;1;0
WireConnection;42;0;53;0
WireConnection;42;1;10;0
WireConnection;44;0;42;0
WireConnection;44;1;11;1
WireConnection;59;0;18;0
WireConnection;59;1;60;0
WireConnection;0;2;59;0
WireConnection;0;10;1;4
WireConnection;0;11;44;0
ASEEND*/
//CHKSM=CE4FAF1D5C77A6E5BB99ACE53CED1581BD5643E3