// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "sprite/wave_cut"
{
	Properties
	{
		_power("power", Range( 0 , 5)) = 1
		_Cutoff( "Mask Clip Value", Float ) = 0.22
		_Main_Tex("Main_Tex", 2D) = "white" {}
		[HDR]_Tex_Color("Tex_Color", Color) = (1.605559,1.605559,1.605559,1)
		[HDR]_Emmision_Color("Emmision_Color", Color) = (1.605559,1.605559,1.605559,1)
		_speed("speed", Range( 0 , 10)) = 10
		_emmision("emmision", 2D) = "white" {}
		[Toggle]_Emmision("Emmision?", Float) = 1
		_dis_tex("dis_tex", 2D) = "white" {}
		[Toggle]_texture("texture?", Float) = 1
		_dis_speed("dis_speed", Vector) = (1,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+555" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _speed;
		uniform float _power;
		uniform float _texture;
		uniform sampler2D _dis_tex;
		uniform float2 _dis_speed;
		uniform sampler2D _Main_Tex;
		uniform float4 _Main_Tex_ST;
		uniform float _Emmision;
		uniform float4 _Tex_Color;
		uniform float4 _Emmision_Color;
		uniform sampler2D _emmision;
		uniform float4 _emmision_ST;
		uniform float _Cutoff = 0.22;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float4 temp_cast_1 = (1.0).xxxx;
			float2 panner88 = ( _Time.y * _dis_speed + v.texcoord.xy);
			v.vertex.xyz += ( float4( ( ( ( ase_vertex3Pos + float3( 0,0,0 ) ) * sin( ( ase_vertex3Pos + ( _speed * _Time.y ) ) ) ) * _power ) , 0.0 ) * v.color.r * lerp(temp_cast_1,tex2Dlod( _dis_tex, float4( panner88, 0, 0.0) ),_texture) ).rgb;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Main_Tex = i.uv_texcoord * _Main_Tex_ST.xy + _Main_Tex_ST.zw;
			float4 tex2DNode71 = tex2D( _Main_Tex, uv_Main_Tex );
			o.Albedo = tex2DNode71.rgb;
			float2 uv_emmision = i.uv_texcoord * _emmision_ST.xy + _emmision_ST.zw;
			o.Emission = lerp(float4( 0,0,0,0 ),( ( tex2DNode71 * _Tex_Color ) + ( _Emmision_Color * tex2D( _emmision, uv_emmision ).r ) ),_Emmision).rgb;
			o.Alpha = 1;
			clip( tex2DNode71.a - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
425;7;1022;1004;2138.609;1106.428;1.856734;True;False
Node;AmplifyShaderEditor.RangedFloatNode;68;-906.1766,-167.1295;Float;False;Property;_speed;speed;5;0;Create;True;0;0;False;0;10;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;75;-908.4196,-38.51981;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;93;-987.4343,-480.709;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;-556.1736,-26.44562;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;16;-410.9917,-502.1674;Float;True;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;90;-411.7006,357.8873;Float;False;Property;_dis_speed;dis_speed;10;0;Create;True;0;0;False;0;1,0;1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;57;-350.1224,-290.8512;Float;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TimeNode;92;-408.587,519.7872;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;87;-509.7749,236.4619;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;71;401.2194,-634.6679;Float;True;Property;_Main_Tex;Main_Tex;2;0;Create;True;0;0;False;0;None;9527bd04b2b678145a0a51db0104f23c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;65;-123.4204,-477.2234;Float;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;49;627.6956,-309.4953;Float;False;Property;_Tex_Color;Tex_Color;3;1;[HDR];Create;True;0;0;False;0;1.605559,1.605559,1.605559,1;1.059274,1.059274,1.059274,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;88;-114.3645,322.0823;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SinOpNode;66;-112.1478,-240.8813;Float;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;79;604.7634,301.6469;Float;True;Property;_emmision;emmision;6;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;82;860.7736,179.3709;Float;False;Property;_Emmision_Color;Emmision_Color;4;1;[HDR];Create;True;0;0;False;0;1.605559,1.605559,1.605559,1;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;86;439.6481,133.4371;Float;False;Constant;_Float0;Float 0;10;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;1080.783,204.1703;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;885.9175,-291.8762;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;84;246.1942,263.6036;Float;True;Property;_dis_tex;dis_tex;8;0;Create;True;0;0;False;0;None;9e2de8f315a45444984d69c9b0ea6e5a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;113.6767,-304.1907;Float;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;19;72.9166,-40.31995;Float;False;Property;_power;power;0;0;Create;True;0;0;False;0;1;0.3;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;31;439.8067,-80.71404;Float;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;80;1361.214,-178.9072;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;349.3829,-261.8395;Float;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ToggleSwitchNode;85;573.6481,124.4371;Float;False;Property;_texture;texture?;9;0;Create;True;0;0;False;0;1;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldPosInputsNode;5;-799.4799,-398.0316;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;804.0821,-82.6794;Float;True;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;83;1566.754,-210.9132;Float;False;Property;_Emmision;Emmision?;7;0;Create;True;0;0;False;0;1;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;1;1810.99,-270.2977;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;sprite/wave_cut;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.22;True;False;555;False;TransparentCutout;;AlphaTest;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;5;False;-1;10;False;-1;2;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;77;0;68;0
WireConnection;77;1;75;2
WireConnection;57;0;93;0
WireConnection;57;1;77;0
WireConnection;65;0;16;0
WireConnection;88;0;87;0
WireConnection;88;2;90;0
WireConnection;88;1;92;2
WireConnection;66;0;57;0
WireConnection;81;0;82;0
WireConnection;81;1;79;1
WireConnection;78;0;71;0
WireConnection;78;1;49;0
WireConnection;84;1;88;0
WireConnection;17;0;65;0
WireConnection;17;1;66;0
WireConnection;80;0;78;0
WireConnection;80;1;81;0
WireConnection;18;0;17;0
WireConnection;18;1;19;0
WireConnection;85;0;86;0
WireConnection;85;1;84;0
WireConnection;21;0;18;0
WireConnection;21;1;31;1
WireConnection;21;2;85;0
WireConnection;83;1;80;0
WireConnection;1;0;71;0
WireConnection;1;2;83;0
WireConnection;1;10;71;4
WireConnection;1;11;21;0
ASEEND*/
//CHKSM=D5A8DE2F92CBB86358546D6BF384443880C2F57A