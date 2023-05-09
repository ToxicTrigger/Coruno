// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "sprite/wave"
{
	Properties
	{
		_power("power", Range( 0 , 1)) = 1
		_MainTex("MainTex", 2D) = "white" {}
		_TextureSample3("Texture Sample 3", 2D) = "white" {}
		[HDR]_Power("Power", Color) = (1,1,1,1)
		[HDR]_E_color("E_color", Color) = (1.605559,1.605559,1.605559,1)
		[HDR]_Tex_Color("Tex_Color", Color) = (1.605559,1.605559,1.605559,1)
		_speed("speed", Range( 0 , 10)) = 10
		_Emmision("Emmision", 2D) = "white" {}
		_Opacity("Opacity", Float) = 1
		[Toggle]_emmission("emmission?", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard alpha:fade keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd vertex:vertexDataFunc 
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
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float _emmission;
		uniform float4 _Tex_Color;
		uniform float4 _E_color;
		uniform sampler2D _Emmision;
		uniform float4 _Emmision_ST;
		uniform float _Opacity;

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
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode71 = tex2D( _MainTex, uv_MainTex );
			o.Albedo = tex2DNode71.rgb;
			float2 uv_Emmision = i.uv_texcoord * _Emmision_ST.xy + _Emmision_ST.zw;
			o.Emission = lerp(float4( 0,0,0,0 ),( ( _Tex_Color * tex2DNode71 ) + ( _E_color * tex2D( _Emmision, uv_Emmision ) ) ),_emmission).rgb;
			o.Alpha = ( tex2DNode71.a * _Opacity );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
1204;73;480;927;-950.3056;882.694;1.521657;True;False
Node;AmplifyShaderEditor.RangedFloatNode;68;-928.1766,-155.1295;Float;False;Property;_speed;speed;6;0;Create;True;0;0;False;0;10;3.27;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;75;-908.4196,-38.51981;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;5;-799.4799,-398.0316;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;-556.1736,-26.44562;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;51;-397.0475,44.64915;Float;True;Property;_TextureSample3;Texture Sample 3;2;0;Create;True;0;0;False;0;5491bac98960f9842a6af8cfe61ef794;e28dc97a9541e3642a48c0e3886688c5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;62;-382.1709,278.7664;Float;False;Property;_Power;Power;3;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;16;-410.9917,-502.1674;Float;True;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;57;-350.1224,-290.8512;Float;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;65;-123.4204,-477.2234;Float;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SinOpNode;66;-112.1478,-240.8813;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-84.80547,134.8089;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;49;649.7115,-335.9918;Float;False;Property;_Tex_Color;Tex_Color;5;1;[HDR];Create;True;0;0;False;0;1.605559,1.605559,1.605559,1;1.605559,1.605559,1.605559,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;71;340.3497,-528.1458;Float;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;False;0;None;328d827e41a57dd4b819d633f5f6c5d8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;81;826.9669,284.0774;Float;False;Property;_E_color;E_color;4;1;[HDR];Create;True;0;0;False;0;1.605559,1.605559,1.605559,1;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;78;475.1804,228.3654;Float;True;Property;_Emmision;Emmision;7;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;19;107.9166,-25.31995;Float;False;Property;_power;power;0;0;Create;True;0;0;False;0;1;0.45;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;113.6767,-304.1907;Float;True;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;1135.674,243.1294;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;999.1482,-285.075;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;31;373.5418,42.33199;Float;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;83;924.5201,-29.72776;Float;False;Property;_Opacity;Opacity;8;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;365.3829,-251.8395;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;79;1236.074,-164.7217;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;677.7351,-75.64006;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;1120.222,-21.98126;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;84;1491.843,-196.4265;Float;False;Property;_emmission;emmission?;9;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;1;1701.458,-261.5789;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;sprite/wave;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0;True;False;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;77;0;68;0
WireConnection;77;1;75;2
WireConnection;57;0;5;0
WireConnection;57;1;77;0
WireConnection;65;0;16;0
WireConnection;66;0;57;0
WireConnection;63;0;51;0
WireConnection;63;1;62;0
WireConnection;17;0;65;0
WireConnection;17;1;66;0
WireConnection;17;2;63;0
WireConnection;80;0;81;0
WireConnection;80;1;78;0
WireConnection;74;0;49;0
WireConnection;74;1;71;0
WireConnection;18;0;17;0
WireConnection;18;1;19;0
WireConnection;79;0;74;0
WireConnection;79;1;80;0
WireConnection;21;0;18;0
WireConnection;21;1;31;1
WireConnection;82;0;71;4
WireConnection;82;1;83;0
WireConnection;84;1;79;0
WireConnection;1;0;71;0
WireConnection;1;2;84;0
WireConnection;1;9;82;0
WireConnection;1;11;21;0
ASEEND*/
//CHKSM=AB17D4FED0526A19C51501BAD2171DFA2F5CD81C