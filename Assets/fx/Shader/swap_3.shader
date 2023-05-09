// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "swap_2"
{
	Properties
	{
		_Up("Up", 2D) = "white" {}
		_Down("Down", 2D) = "white" {}
		_mask("mask", 2D) = "white" {}
		_Power("Power", Range( 0 , 1)) = 2.4
		_Vector1("Vector 1", Vector) = (0.25,0.25,0,0)
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Vector0("Vector 0", Vector) = (0.5,0.5,0,0)
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_ripplepower("ripple power", Float) = -0.06
		_Vector4("Vector 4", Vector) = (-1,-1,0,0)
		_Vector3("Vector 3", Vector) = (3,3,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard alpha:fade keepalpha addshadow fullforwardshadows noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Up;
		uniform sampler2D _TextureSample1;
		uniform float2 _Vector3;
		uniform float2 _Vector4;
		uniform float _ripplepower;
		uniform sampler2D _Down;
		uniform float4 _Down_ST;
		uniform sampler2D _mask;
		uniform float2 _Vector0;
		uniform float2 _Vector1;
		uniform sampler2D _TextureSample0;
		uniform float _Power;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TexCoord39 = i.uv_texcoord * _Vector3 + _Vector4;
			float2 uv_Down = i.uv_texcoord * _Down_ST.xy + _Down_ST.zw;
			float2 uv_TexCoord17 = i.uv_texcoord * _Vector0 + _Vector1;
			float4 lerpResult1 = lerp( tex2D( _Up, ( ( tex2D( _TextureSample1, uv_TexCoord39 ) * _ripplepower ) + float4( i.uv_texcoord, 0.0 , 0.0 ) ).rg ) , tex2D( _Down, uv_Down ) , ( tex2D( _mask, ( float4( uv_TexCoord17, 0.0 , 0.0 ) + ( tex2D( _TextureSample0, ( uv_TexCoord17 + ( float2( 0.5,0.3 ) * _Time.y ) ) ) * 0.05 ) ).rg ).r * _Power ));
			o.Emission = lerpResult1.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
7;7;1731;1004;2536.244;707.5034;1.66432;True;True
Node;AmplifyShaderEditor.Vector2Node;19;-1835.573,139.7766;Float;False;Property;_Vector1;Vector 1;4;0;Create;True;0;0;False;0;0.25,0.25;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;18;-1807.177,-55.31431;Float;False;Property;_Vector0;Vector 0;6;0;Create;True;0;0;False;0;0.5,0.5;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TimeNode;26;-2299.614,522.7308;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;30;-2170.675,311.7914;Float;False;Constant;_Vector2;Vector 2;7;0;Create;True;0;0;False;0;0.5,0.3;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;17;-1605.744,53.30833;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-2047.988,504.967;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;41;-2201.747,-232.6049;Float;False;Property;_Vector4;Vector 4;9;0;Create;True;0;0;False;0;-1,-1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;40;-2236.329,-423.7104;Float;False;Property;_Vector3;Vector 3;10;0;Create;True;0;0;False;0;3,3;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;28;-1919.842,390.1194;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-1508.167,591.9011;Float;False;Constant;_Float1;Float 1;7;0;Create;True;0;0;False;0;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;39;-1926.632,-404.1618;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;22;-1682.949,427.2789;Float;True;Property;_TextureSample0;Texture Sample 0;5;0;Create;True;0;0;False;0;None;df1a73877e6e817489bcdec99d204d81;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-1402.302,413.9873;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;33;-1525.291,-458.3211;Float;True;Property;_TextureSample1;Texture Sample 1;7;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;37;-1348.84,-266.4395;Float;False;Property;_ripplepower;ripple power;8;0;Create;True;0;0;False;0;-0.06;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-1156.84,-413.4395;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;38;-1296.333,-147.7505;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;21;-1303.258,179.9515;Float;True;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1014.787,341.6369;Float;False;Property;_Power;Power;3;0;Create;False;0;0;False;0;2.4;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;34;-1020.613,-329.8705;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT2;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;5;-1076.906,112.1736;Float;True;Property;_mask;mask;2;0;Create;True;0;0;False;0;26c557c70781099418ab8b10f0aa399a;0000000000000000f000000000000000;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-766.4993,-339.9005;Float;True;Property;_Up;Up;0;0;Create;True;0;0;False;0;a928f6187462adb49b920f329d879931;a928f6187462adb49b920f329d879931;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-698.5328,-33.31312;Float;True;Property;_Down;Down;1;0;Create;True;0;0;False;0;e4f20d2e47818b449ada615520e8c5f2;e4f20d2e47818b449ada615520e8c5f2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-500.8301,180.4601;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1;-183.798,-166.6502;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;114,-160;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;swap_2;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;17;0;18;0
WireConnection;17;1;19;0
WireConnection;31;0;30;0
WireConnection;31;1;26;2
WireConnection;28;0;17;0
WireConnection;28;1;31;0
WireConnection;39;0;40;0
WireConnection;39;1;41;0
WireConnection;22;1;28;0
WireConnection;24;0;22;0
WireConnection;24;1;25;0
WireConnection;33;1;39;0
WireConnection;36;0;33;0
WireConnection;36;1;37;0
WireConnection;21;0;17;0
WireConnection;21;1;24;0
WireConnection;34;0;36;0
WireConnection;34;1;38;0
WireConnection;5;1;21;0
WireConnection;2;1;34;0
WireConnection;7;0;5;1
WireConnection;7;1;8;0
WireConnection;1;0;2;0
WireConnection;1;1;3;0
WireConnection;1;2;7;0
WireConnection;0;2;1;0
ASEEND*/
//CHKSM=9B8DBD5EF5121940B975EECA76C0B8DE751B84E0