// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "sprite/wave1"
{
	Properties
	{
		_Opacity("Opacity", Range( 0 , 1)) = 1
		_power("power", Range( 0 , 1)) = 1
		_Cutoff( "Mask Clip Value", Float ) = 0.1
		_Main_Tex("Main_Tex", 2D) = "white" {}
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_TextureSample3("Texture Sample 3", 2D) = "white" {}
		[HDR]_Power("Power", Color) = (1,1,1,1)
		[HDR]_Tex_Color("Tex_Color", Color) = (1.605559,1.605559,1.605559,1)
		_speed("speed", Range( 0 , 10)) = 10
		_Dis_Power("Dis_Power", Float) = 0.025
		_Speed("Speed", Float) = 0.5
		_Dis_Speed("Dis_Speed", Float) = 0.5
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		[Toggle]_dis("dis", Float) = 0
		[Toggle]_noise_animation("noise_animation?", Float) = 1
		_Y("Y", Float) = 0
		_X("X", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Overlay+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform float _speed;
		uniform sampler2D _TextureSample3;
		uniform float4 _TextureSample3_ST;
		uniform float4 _Power;
		uniform float _power;
		uniform float4 _Tex_Color;
		uniform sampler2D _Main_Tex;
		uniform float _dis;
		uniform float _Dis_Power;
		uniform sampler2D _TextureSample0;
		uniform float _Dis_Speed;
		uniform float _Opacity;
		uniform sampler2D _TextureSample1;
		uniform float _noise_animation;
		uniform float _X;
		uniform float _Y;
		uniform float _Speed;
		uniform float _Cutoff = 0.1;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 uv_TextureSample3 = v.texcoord * _TextureSample3_ST.xy + _TextureSample3_ST.zw;
			v.vertex.xyz += ( ( ( float4( ( ase_vertex3Pos + float3( 0,0,0 ) ) , 0.0 ) * float4( sin( ( ase_worldPos + ( _speed * _Time.y ) ) ) , 0.0 ) * ( tex2Dlod( _TextureSample3, float4( uv_TextureSample3, 0, 0.0) ) * _Power ) ) * _power ) * v.color.r ).rgb;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 temp_cast_1 = (_Dis_Speed).xx;
			float2 panner87 = ( 1.0 * _Time.y * temp_cast_1 + i.uv_texcoord);
			float4 tex2DNode71 = tex2D( _Main_Tex, lerp(( float4( i.uv_texcoord, 0.0 , 0.0 ) + ( _Dis_Power * tex2D( _TextureSample0, panner87 ) ) ),float4( i.uv_texcoord, 0.0 , 0.0 ),_dis).rg );
			o.Emission = ( _Tex_Color * tex2DNode71 ).rgb;
			float2 appendResult101 = (float2(_X , _Y));
			float2 uv_TexCoord99 = i.uv_texcoord * appendResult101;
			float2 temp_cast_5 = (_Speed).xx;
			float2 panner98 = ( 1.0 * _Time.y * temp_cast_5 + uv_TexCoord99);
			float4 temp_output_96_0 = ( tex2DNode71.a * tex2D( _TextureSample1, lerp(uv_TexCoord99,panner98,_noise_animation) ) );
			o.Alpha = ( _Opacity * temp_output_96_0 ).r;
			clip( temp_output_96_0.r - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
7;7;1906;1004;518.108;930.475;1.658183;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;84;-1282.554,-1112.014;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;88;-968.8732,-935.8531;Float;False;Property;_Dis_Speed;Dis_Speed;11;0;Create;True;0;0;False;0;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;103;-146.7578,596.152;Float;False;Property;_Y;Y;15;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;102;-153.7578,491.152;Float;False;Property;_X;X;16;0;Create;True;0;0;False;0;0;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;87;-860.5586,-904.8836;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;68;-928.1766,-155.1295;Float;False;Property;_speed;speed;8;0;Create;True;0;0;False;0;10;7;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;75;-908.4196,-38.51981;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;90;-645.1489,-864.2417;Float;True;Property;_TextureSample0;Texture Sample 0;4;0;Create;True;0;0;False;0;5491bac98960f9842a6af8cfe61ef794;5491bac98960f9842a6af8cfe61ef794;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;101;50.24219,455.152;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;91;-662.0021,-984.2293;Float;False;Property;_Dis_Power;Dis_Power;9;0;Create;True;0;0;False;0;0.025;0.025;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;5;-799.4799,-398.0316;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;-556.1736,-26.44562;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;99;191.2718,493.405;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;-407.002,-919.2293;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;97;445.2425,687.0577;Float;False;Property;_Speed;Speed;10;0;Create;True;0;0;False;0;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;51;-397.0475,44.64915;Float;True;Property;_TextureSample3;Texture Sample 3;5;0;Create;True;0;0;False;0;5491bac98960f9842a6af8cfe61ef794;bdbe94d7623ec3940947b62544306f1c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;16;-410.9917,-502.1674;Float;True;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;57;-350.1224,-290.8512;Float;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;62;-382.1709,278.7664;Float;False;Property;_Power;Power;6;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;89;-359.4433,-990.7214;Float;False;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;98;586.2673,468.5354;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-84.80547,134.8089;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;65;-123.4204,-477.2234;Float;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SinOpNode;66;-112.1478,-240.8813;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ToggleSwitchNode;93;14.91901,-661.3755;Float;False;Property;_dis;dis;13;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;100;614.4749,294.6782;Float;False;Property;_noise_animation;noise_animation?;14;0;Create;True;0;0;False;0;1;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;19;107.9166,-25.31995;Float;False;Property;_power;power;1;0;Create;True;0;0;False;0;1;0.12;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;113.6767,-304.1907;Float;True;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;71;340.3497,-528.1458;Float;True;Property;_Main_Tex;Main_Tex;3;0;Create;True;0;0;False;0;None;402c2ea581aaf7d4081c5344913702a3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;95;913.0573,214.6605;Float;True;Property;_TextureSample1;Texture Sample 1;12;0;Create;True;0;0;False;0;None;e8fc4ddb6dd7ccb448479e40c68322a2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;365.3829,-251.8395;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;83;1101.638,-181.3232;Float;False;Property;_Opacity;Opacity;0;0;Create;True;0;0;False;0;1;0.65;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;31;373.5418,42.33199;Float;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;96;1272.013,-60.0409;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;49;624.6207,-413.7731;Float;False;Property;_Tex_Color;Tex_Color;7;1;[HDR];Create;True;0;0;False;0;1.605559,1.605559,1.605559,1;0.8638885,1.594727,1.888086,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;104;1268.467,-219.323;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;677.7351,-75.64006;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;973.6935,-292.4932;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;1;1479.267,-401.8127;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;sprite/wave1;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.1;True;False;0;True;Opaque;;Overlay;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;2;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;87;0;84;0
WireConnection;87;2;88;0
WireConnection;90;1;87;0
WireConnection;101;0;102;0
WireConnection;101;1;103;0
WireConnection;77;0;68;0
WireConnection;77;1;75;2
WireConnection;99;0;101;0
WireConnection;92;0;91;0
WireConnection;92;1;90;0
WireConnection;57;0;5;0
WireConnection;57;1;77;0
WireConnection;89;0;84;0
WireConnection;89;1;92;0
WireConnection;98;0;99;0
WireConnection;98;2;97;0
WireConnection;63;0;51;0
WireConnection;63;1;62;0
WireConnection;65;0;16;0
WireConnection;66;0;57;0
WireConnection;93;0;89;0
WireConnection;93;1;84;0
WireConnection;100;0;99;0
WireConnection;100;1;98;0
WireConnection;17;0;65;0
WireConnection;17;1;66;0
WireConnection;17;2;63;0
WireConnection;71;1;93;0
WireConnection;95;1;100;0
WireConnection;18;0;17;0
WireConnection;18;1;19;0
WireConnection;96;0;71;4
WireConnection;96;1;95;0
WireConnection;104;0;83;0
WireConnection;104;1;96;0
WireConnection;21;0;18;0
WireConnection;21;1;31;1
WireConnection;74;0;49;0
WireConnection;74;1;71;0
WireConnection;1;2;74;0
WireConnection;1;9;104;0
WireConnection;1;10;96;0
WireConnection;1;11;21;0
ASEEND*/
//CHKSM=51E7AA617427EA6BE8D9A0E1C4A75BE762E736C0