// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "light_tree"
{
	Properties
	{
		[HDR]_Color1("Color 1", Color) = (0.7924528,0.7924528,0.7924528,0)
		[HDR]_Color2("Color 2", Color) = (0.7924528,0.7924528,0.7924528,0)
		[HDR]_Color0("Color 0", Color) = (0.8396226,0.8396226,0.8396226,0)
		_mix_power("mix_power", Float) = 1.65
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Tex_Power("Tex_Power", Float) = 0.18
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform float4 _Color0;
		uniform float4 _Color1;
		uniform float _mix_power;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float4 _Color2;
		uniform float _Tex_Power;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 lerpResult5 = lerp( _Color0 , _Color1 , ( ase_vertex3Pos.z * _mix_power ));
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			o.Emission = ( lerpResult5 * ( tex2D( _TextureSample0, uv_TextureSample0 ) * _Color2 ) * _Tex_Power ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
1146;1;767;1010;984.4335;344.7373;1.434559;True;False
Node;AmplifyShaderEditor.PosVertexDataNode;11;-886.5442,87.14105;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;8;-747.4661,261.7126;Float;False;Property;_mix_power;mix_power;3;0;Create;True;0;0;False;0;1.65;0.75;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;16;-586.8748,402.3458;Float;False;Property;_Color2;Color 2;1;1;[HDR];Create;True;0;0;False;0;0.7924528,0.7924528,0.7924528,0;0.3111872,0.5854911,0.5943396,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;12;-623.2789,217.072;Float;True;Property;_TextureSample0;Texture Sample 0;4;0;Create;True;0;0;False;0;None;5baef9617239b944e95c18ee0f2d8e77;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;4;-765.2131,-70.36813;Float;False;Property;_Color1;Color 1;0;1;[HDR];Create;True;0;0;False;0;0.7924528,0.7924528,0.7924528,0;0.3111872,0.5854911,0.5943396,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;3;-752.5,-262.5;Float;False;Property;_Color0;Color 0;2;1;[HDR];Create;True;0;0;False;0;0.8396226,0.8396226,0.8396226,0;0.1085795,0.1886792,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-631.4661,72.71259;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-271.1619,175.1929;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-359.0963,438.6107;Float;False;Property;_Tex_Power;Tex_Power;5;0;Create;True;0;0;False;0;0.18;1.98;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;5;-332.486,-51.45505;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-62.39169,102.7965;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;10;137.8034,5.713481;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;light_tree;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;7;0;11;3
WireConnection;7;1;8;0
WireConnection;15;0;12;0
WireConnection;15;1;16;0
WireConnection;5;0;3;0
WireConnection;5;1;4;0
WireConnection;5;2;7;0
WireConnection;13;0;5;0
WireConnection;13;1;15;0
WireConnection;13;2;14;0
WireConnection;10;2;13;0
ASEEND*/
//CHKSM=6C4650FC2969E99CD17F80EB2DD0A630428C095B