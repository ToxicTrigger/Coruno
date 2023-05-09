// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "line_laser"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		[HDR]_Color("Color", Color) = (4,4,4,0)
		_main_speed("main_speed", Vector) = (2,0,0,0)
		_noise_speed("noise_speed", Vector) = (3,0,0,0)
		_mask("mask", 2D) = "white" {}
		_noise("noise", 2D) = "white" {}
		_niose_power("niose_power", Float) = 0.1
		_sub_power("sub_power", Float) = 0.18
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
		#pragma surface surf Unlit alpha:fade keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float4 _Color;
		uniform sampler2D _mask;
		uniform float4 _mask_ST;
		uniform sampler2D _TextureSample0;
		uniform sampler2D _noise;
		uniform float2 _noise_speed;
		uniform float _niose_power;
		uniform float2 _main_speed;
		uniform float _sub_power;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_mask = i.uv_texcoord * _mask_ST.xy + _mask_ST.zw;
			float4 tex2DNode16 = tex2D( _mask, uv_mask );
			float4 tex2DNode24 = tex2D( _noise, ( i.uv_texcoord + ( _noise_speed * _Time.y ) ) );
			float4 lerpResult25 = lerp( float4( i.uv_texcoord, 0.0 , 0.0 ) , tex2DNode24 , _niose_power);
			float4 tex2DNode1 = tex2D( _TextureSample0, ( lerpResult25 + float4( ( _main_speed * _Time.y ), 0.0 , 0.0 ) ).rg );
			float4 lerpResult31 = lerp( tex2DNode1 , ( tex2DNode1.a * tex2DNode24 ) , _sub_power);
			o.Emission = ( ( _Color * ( tex2DNode16 * lerpResult31 ) ) * i.vertexColor ).rgb;
			o.Alpha = ( ( tex2DNode16.r * tex2DNode1.a ) * i.vertexColor.a );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
1339;264;952;788;511.3098;168.3437;1.888565;True;False
Node;AmplifyShaderEditor.Vector2Node;29;-2129.98,778.815;Float;False;Property;_noise_speed;noise_speed;3;0;Create;True;0;0;False;0;3,0;0,-0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TimeNode;4;-2364.713,216.7237;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-1917.321,115.7298;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-1896.035,587.0847;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;-1731.615,555.3126;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;24;-1537.983,512.02;Float;True;Property;_noise;noise;5;0;Create;True;0;0;False;0;a8c8f3879983aa643b7e058f8fc14498;fbd6baf45322aff48b88be139928718c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;28;-1259.974,680.4253;Float;False;Property;_niose_power;niose_power;6;0;Create;True;0;0;False;0;0.1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;9;-1831.77,-56.98874;Float;False;Property;_main_speed;main_speed;2;0;Create;True;0;0;False;0;2,0;0,-0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.LerpOp;25;-1100.003,441.0828;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-1185.006,213.0405;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-754.2661,161.416;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT2;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-613.9074,94.00726;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;e6b1ac900b6adc14894e7f4ff57b67b9;5491bac98960f9842a6af8cfe61ef794;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;32;-276.973,797.1118;Float;False;Property;_sub_power;sub_power;7;0;Create;True;0;0;False;0;0.18;0.42;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-347.4189,509.4577;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;31;-107.5763,568.8287;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;16;-771.5428,-180.8023;Float;True;Property;_mask;mask;4;0;Create;True;0;0;False;0;5228a04ef529d2641937cab585cc1a02;5228a04ef529d2641937cab585cc1a02;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-281.3652,-73.93395;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;14;-303.647,-272.9415;Float;False;Property;_Color;Color;1;1;[HDR];Create;True;0;0;False;0;4,4,4,0;0.6188427,1.799145,3.47644,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;12.55538,-76.20027;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;10;123.7375,187.329;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-180.8078,222.9983;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;317.1394,463.8244;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;318.3349,-25.31492;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;23;979.5513,201.6082;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;line_laser;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;True;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;2;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;27;0;29;0
WireConnection;27;1;4;2
WireConnection;26;0;2;0
WireConnection;26;1;27;0
WireConnection;24;1;26;0
WireConnection;25;0;2;0
WireConnection;25;1;24;0
WireConnection;25;2;28;0
WireConnection;5;0;9;0
WireConnection;5;1;4;2
WireConnection;8;0;25;0
WireConnection;8;1;5;0
WireConnection;1;1;8;0
WireConnection;30;0;1;4
WireConnection;30;1;24;0
WireConnection;31;0;1;0
WireConnection;31;1;30;0
WireConnection;31;2;32;0
WireConnection;18;0;16;0
WireConnection;18;1;31;0
WireConnection;15;0;14;0
WireConnection;15;1;18;0
WireConnection;19;0;16;1
WireConnection;19;1;1;4
WireConnection;11;0;19;0
WireConnection;11;1;10;4
WireConnection;12;0;15;0
WireConnection;12;1;10;0
WireConnection;23;2;12;0
WireConnection;23;9;11;0
ASEEND*/
//CHKSM=C89497A05C6E8ED88D0B068860CC8D6126F5713F