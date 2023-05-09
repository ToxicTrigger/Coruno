// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Trail2"
{
	Properties
	{
		_Opacity("Opacity", Float) = 1
		[HDR]_Texture1("Texture 1", 2D) = "white" {}
		[HDR]_Color2("Color 2", Color) = (0.3915094,0.6520674,1,1)
		[HDR]_Color1("Color 1", Color) = (0.3915094,0.6520674,1,1)
		_Texture0("Texture 0", 2D) = "white" {}
		_ahlpaspeed("ahlpa speed", Vector) = (1,0.2,0,0)
		_trailspeed("trail speed", Vector) = (-0.89,0,0,0)
		_TextureSample4("Texture Sample 4", 2D) = "white" {}
		_Color_balance("Color_balance", Range( 0 , 1)) = 0.5
		_dis_Power("dis_Power", Float) = 0
		_max("max", Float) = 0.6
		_Min("Min", Float) = 0
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
		#pragma surface surf Unlit alpha:fade keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _Color1;
		uniform float4 _Color2;
		uniform float _Color_balance;
		uniform sampler2D _TextureSample4;
		uniform float4 _TextureSample4_ST;
		uniform float _Min;
		uniform float _max;
		uniform sampler2D _Texture1;
		uniform float2 _trailspeed;
		uniform sampler2D _Texture0;
		uniform float2 _ahlpaspeed;
		uniform float _dis_Power;
		uniform float _Opacity;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 lerpResult104 = lerp( _Color1 , _Color2 , ( _Color_balance * i.uv_texcoord.x ));
			float2 uv_TextureSample4 = i.uv_texcoord * _TextureSample4_ST.xy + _TextureSample4_ST.zw;
			float4 tex2DNode103 = tex2D( _TextureSample4, uv_TextureSample4 );
			float4 temp_cast_0 = (_Min).xxxx;
			float4 temp_cast_1 = (_max).xxxx;
			float4 temp_output_128_0 = (float4( 0,0,0,0 ) + (( 1.0 - ( i.uv_texcoord.x * tex2DNode103 ) ) - temp_cast_0) * (float4( 1,1,1,0 ) - float4( 0,0,0,0 )) / (temp_cast_1 - temp_cast_0));
			float2 panner59 = ( 1.0 * _Time.y * _trailspeed + i.uv_texcoord);
			float2 uv_TexCoord4 = i.uv_texcoord * float2( 1,2 );
			float2 panner5 = ( 1.0 * _Time.y * _ahlpaspeed + uv_TexCoord4);
			float4 tex2DNode6 = tex2D( _Texture0, panner5 );
			float4 color90 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
			float4 temp_cast_4 = (_Min).xxxx;
			float4 temp_cast_5 = (_max).xxxx;
			float4 temp_output_71_0 = ( temp_output_128_0 * ( tex2D( _Texture1, ( float4( panner59, 0.0 , 0.0 ) + ( tex2DNode6 * _dis_Power * ( color90 * i.uv_texcoord.x ) ) ).rg ) * saturate( ( 1.0 - ( tex2DNode6 * (0.0 + (i.uv_texcoord.x - 0.1) * (1.0 - 0.0) / (0.33 - 0.1)) ) ) ) ) * saturate( temp_output_128_0 ) );
			o.Emission = ( lerpResult104 * temp_output_71_0 ).rgb;
			float4 temp_cast_7 = (_Min).xxxx;
			float4 temp_cast_8 = (_max).xxxx;
			o.Alpha = ( temp_output_71_0 * _Opacity ).r;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
1103;420;895;565;-529.2429;-54.84436;1;True;False
Node;AmplifyShaderEditor.Vector2Node;61;-2581.775,238.96;Float;True;Constant;_Vector0;Vector 0;3;0;Create;True;0;0;False;0;1,2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-2315.684,218.9791;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;63;-2251.046,362.2393;Float;False;Property;_ahlpaspeed;ahlpa speed;5;0;Create;True;0;0;False;0;1,0.2;-1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;5;-1981.246,287.0959;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;36;-1868.821,19.60994;Float;True;Property;_Texture0;Texture 0;4;0;Create;True;0;0;False;0;None;5baef9617239b944e95c18ee0f2d8e77;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;58;-1703.073,-537.5209;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;90;-1562.93,487.2372;Float;False;Constant;_Color3;Color 3;11;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;118;-1137.277,669.2076;Float;False;Constant;_Mask_scale;Mask_scale;11;0;Create;True;0;0;False;0;0.33;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;114;-1147.692,579.3691;Float;False;Constant;_Mask_bais;Mask_bais;11;0;Create;True;0;0;False;0;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;126;-1464.394,32.60239;Float;False;Property;_dis_Power;dis_Power;9;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;-1334.789,453.7813;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;62;-1604.772,-263.2234;Float;False;Property;_trailspeed;trail speed;6;0;Create;True;0;0;False;0;-0.89,0;-0.8,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;103;-347.9947,742.0752;Float;True;Property;_TextureSample4;Texture Sample 4;7;0;Create;True;0;0;False;0;None;0777ecfa8cc97cc4ab643f6491b61798;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;6;-1581.514,255.5835;Float;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;None;e28dc97a9541e3642a48c0e3886688c5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;117;-899.6957,554.1163;Float;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;134;153.2264,682.0781;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;38;-968.6829,122.1207;Float;False;302;280;c;1;37;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;110;-462.1704,453.0904;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;59;-1289.037,-432.541;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;93;-1266.404,-27.57416;Float;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;37;-918.683,172.1208;Float;True;Property;_Texture1;Texture 1;1;1;[HDR];Create;True;0;0;False;0;None;ee5c309d6a245ef40bb5cbd486e7bd3e;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;129;574.3098,733.6816;Float;False;Property;_max;max;10;0;Create;True;0;0;False;0;0.6;0.97;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;130;534.2847,574.2769;Float;False;Property;_Min;Min;11;0;Create;True;0;0;False;0;0;1.16;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;84;-883.6862,-273.1603;Float;True;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;125;373.7381,442.8999;Float;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;121;-125.6612,241.7434;Float;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2;-632.7354,-111.8879;Float;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;False;0;None;5491bac98960f9842a6af8cfe61ef794;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;132;-92.14266,28.60053;Float;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;105;-153.3041,479.7428;Float;False;Property;_Color_balance;Color_balance;8;0;Create;True;0;0;False;0;0.5;0.28;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;128;835.359,626.0333;Float;True;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;79;6.94629,-432.0861;Float;False;Property;_Color1;Color 1;3;1;[HDR];Create;True;0;0;False;0;0.3915094,0.6520674,1,1;1,0.1854861,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;112;115.4211,-18.06433;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;81;29.95783,-227.2747;Float;False;Property;_Color2;Color 2;2;1;[HDR];Create;True;0;0;False;0;0.3915094,0.6520674,1,1;0,0.8901011,2.881782,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;106;105.6678,354.8852;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;131;472.476,307.7428;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;136;1022.219,205.868;Float;False;Property;_Opacity;Opacity;0;0;Create;True;0;0;False;0;1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;104;429.7891,-298.8257;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;490.418,30.96797;Float;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;135;1202.666,52.48877;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;102;85.537,1112.337;Float;False;Constant;_Float2;Float 2;13;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;256.8668,869.6195;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;100;-4.887223,826.787;Float;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;716.9593,-43.71472;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;55;1386.427,-149.4646;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;Trail2;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;5;False;-1;1;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;61;0
WireConnection;5;0;4;0
WireConnection;5;2;63;0
WireConnection;89;0;90;0
WireConnection;89;1;58;1
WireConnection;6;0;36;0
WireConnection;6;1;5;0
WireConnection;117;0;58;1
WireConnection;117;1;114;0
WireConnection;117;2;118;0
WireConnection;134;0;58;1
WireConnection;134;1;103;0
WireConnection;110;0;6;0
WireConnection;110;1;117;0
WireConnection;59;0;58;0
WireConnection;59;2;62;0
WireConnection;93;0;6;0
WireConnection;93;1;126;0
WireConnection;93;2;89;0
WireConnection;84;0;59;0
WireConnection;84;1;93;0
WireConnection;125;0;134;0
WireConnection;121;0;110;0
WireConnection;2;0;37;0
WireConnection;2;1;84;0
WireConnection;132;0;121;0
WireConnection;128;0;125;0
WireConnection;128;1;130;0
WireConnection;128;2;129;0
WireConnection;112;0;2;0
WireConnection;112;1;132;0
WireConnection;106;0;105;0
WireConnection;106;1;58;1
WireConnection;131;0;128;0
WireConnection;104;0;79;0
WireConnection;104;1;81;0
WireConnection;104;2;106;0
WireConnection;71;0;128;0
WireConnection;71;1;112;0
WireConnection;71;2;131;0
WireConnection;135;0;71;0
WireConnection;135;1;136;0
WireConnection;101;0;100;0
WireConnection;101;1;102;0
WireConnection;100;0;103;0
WireConnection;65;0;104;0
WireConnection;65;1;71;0
WireConnection;55;2;65;0
WireConnection;55;9;135;0
ASEEND*/
//CHKSM=4A6C3BE50A106F1E88C6D82CF252A73FC083CBAE