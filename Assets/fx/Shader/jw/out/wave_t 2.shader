// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "sprite/wave_nabi"
{
	Properties
	{
		_power("power", Range( 0 , 0.02)) = 1
		[Toggle]_is_particlespeed("is_particle(speed)", Float) = 0
		_Cutoff( "Mask Clip Value", Float ) = 0.22
		_Main_Tex("Main_Tex", 2D) = "white" {}
		[HDR]_Tex_Color("Tex_Color", Color) = (1.605559,1.605559,1.605559,1)
		[HDR]_Emmision_Color("Emmision_Color", Color) = (1.605559,1.605559,1.605559,1)
		_Speed("Speed", Range( 0 , 15)) = 10
		_emmision("emmision", 2D) = "white" {}
		[Toggle]_Emmision("Emmision?", Float) = 1
		_dis_tex("dis_tex", 2D) = "white" {}
		[Toggle]_texture("texture?", Float) = 1
		_dis_speed("dis_speed", Vector) = (1,0,0,0)
		_uv_distance("uv_distance", Float) = 0.76
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

		uniform float _uv_distance;
		uniform float _is_particlespeed;
		uniform float _Speed;
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
			float temp_output_108_0 = saturate( ( ( pow( distance( v.texcoord.xy.x , _uv_distance ) , 0.43 ) + -0.21 ) * 5.0 ) );
			float4 temp_cast_0 = (1.0).xxxx;
			float2 panner88 = ( _Time.y * _dis_speed + v.texcoord.xy);
			v.vertex.xyz += ( ( sin( ( temp_output_108_0 + ( _Time.y * lerp(_Speed,v.texcoord1.xy.y,_is_particlespeed) ) ) ) * _power * temp_output_108_0 ) * v.color.r * lerp(temp_cast_0,tex2Dlod( _dis_tex, float4( panner88, 0, 0.0) ),_texture) ).rgb;
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
7;1;1022;1010;799.8502;790.5745;1.343275;True;False
Node;AmplifyShaderEditor.TexCoordVertexDataNode;98;-1173.196,-511.7631;Float;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;104;-987.5865,249.6856;Float;False;Property;_uv_distance;uv_distance;12;0;Create;True;0;0;False;0;0.76;0.91;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;100;-935.8629,-596.4743;Float;True;2;0;FLOAT;0;False;1;FLOAT;0.74;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;96;-1192.438,-28.03099;Float;False;1;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;95;-1293.783,-151.2753;Float;False;Property;_Speed;Speed;6;0;Create;True;0;0;False;0;10;11.48189;0;15;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;105;-657.0013,-518.4984;Float;True;2;0;FLOAT;0;False;1;FLOAT;0.43;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;106;-388.6138,-615.9204;Float;True;ConstantBiasScale;-1;;1;63208df05c83e8e49a48ffbdce2e43a0;0;3;3;FLOAT;0;False;1;FLOAT;-0.21;False;2;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;97;-971.475,-149.7237;Float;False;Property;_is_particlespeed;is_particle(speed);1;0;Create;True;0;0;False;0;0;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;99;-1150.471,-332.1265;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;92;-408.587,519.7872;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;108;-151.2055,-598.4356;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;87;-509.7749,236.4619;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;90;-411.7006,357.8873;Float;False;Property;_dis_speed;dis_speed;11;0;Create;True;0;0;False;0;1,0;1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;-691.1952,-240.7972;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;49;627.6956,-309.4953;Float;False;Property;_Tex_Color;Tex_Color;4;1;[HDR];Create;True;0;0;False;0;1.605559,1.605559,1.605559,1;1.059274,1.059274,1.059274,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;88;-114.3645,322.0823;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;79;604.7634,301.6469;Float;True;Property;_emmision;emmision;7;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;102;-404.4823,-292.6947;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;71;401.2194,-634.6679;Float;True;Property;_Main_Tex;Main_Tex;3;0;Create;True;0;0;False;0;None;9527bd04b2b678145a0a51db0104f23c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;82;844.1674,162.7646;Float;False;Property;_Emmision_Color;Emmision_Color;5;1;[HDR];Create;True;0;0;False;0;1.605559,1.605559,1.605559,1;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;1130.602,181.177;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SinOpNode;103;-119.6308,-257.1096;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;9.015232,-47.39789;Float;False;Property;_power;power;0;0;Create;True;0;0;False;0;1;0.004741983;0;0.02;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;84;246.1942,263.6036;Float;True;Property;_dis_tex;dis_tex;9;0;Create;True;0;0;False;0;None;9e2de8f315a45444984d69c9b0ea6e5a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;86;388.5519,132.1597;Float;False;Constant;_Float0;Float 0;10;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;885.9175,-291.8762;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;31;439.8067,-80.71404;Float;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;85;573.6481,124.4371;Float;False;Property;_texture;texture?;10;0;Create;True;0;0;False;0;1;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;80;1361.214,-178.9072;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;349.3829,-261.8395;Float;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;804.0821,-82.6794;Float;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;83;1566.754,-210.9132;Float;False;Property;_Emmision;Emmision?;8;0;Create;True;0;0;False;0;1;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;1;1810.99,-270.2977;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;sprite/wave_nabi;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.22;True;False;555;False;TransparentCutout;;AlphaTest;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;5;False;-1;10;False;-1;2;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;2;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;100;0;98;1
WireConnection;100;1;104;0
WireConnection;105;0;100;0
WireConnection;106;3;105;0
WireConnection;97;0;95;0
WireConnection;97;1;96;2
WireConnection;108;0;106;0
WireConnection;101;0;99;2
WireConnection;101;1;97;0
WireConnection;88;0;87;0
WireConnection;88;2;90;0
WireConnection;88;1;92;2
WireConnection;102;0;108;0
WireConnection;102;1;101;0
WireConnection;81;0;82;0
WireConnection;81;1;79;1
WireConnection;103;0;102;0
WireConnection;84;1;88;0
WireConnection;78;0;71;0
WireConnection;78;1;49;0
WireConnection;85;0;86;0
WireConnection;85;1;84;0
WireConnection;80;0;78;0
WireConnection;80;1;81;0
WireConnection;18;0;103;0
WireConnection;18;1;19;0
WireConnection;18;2;108;0
WireConnection;21;0;18;0
WireConnection;21;1;31;1
WireConnection;21;2;85;0
WireConnection;83;1;80;0
WireConnection;1;0;71;0
WireConnection;1;2;83;0
WireConnection;1;10;71;4
WireConnection;1;11;21;0
ASEEND*/
//CHKSM=07087746526B6D2B2CAD41C9D400829EC531384C