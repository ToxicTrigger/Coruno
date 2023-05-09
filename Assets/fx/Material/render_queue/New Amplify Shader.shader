// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "sprite_switch"
{
	Properties
	{
		_power("power", Range( 0 , 0.01)) = 0
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Off
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard alpha:fade keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
		};

		uniform sampler2D _TextureSample0;
		uniform float _power;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float power16 = _power;
			float ScreenPositionX17 = i.uv_texcoord.x;
			float temp_output_47_0 = ( ScreenPositionX17 + power16 );
			float ScreenPositionY18 = i.uv_texcoord.y;
			float temp_output_38_0 = ( ScreenPositionY18 + power16 );
			float4 appendResult59 = (float4(temp_output_47_0 , temp_output_38_0 , 0.0 , 0.0));
			float4 appendResult58 = (float4(temp_output_47_0 , temp_output_38_0 , 0.0 , 0.0));
			float4 appendResult57 = (float4(( ScreenPositionX17 - power16 ) , ScreenPositionY18 , 0.0 , 0.0));
			float4 appendResult53 = (float4(ScreenPositionX17 , ( ScreenPositionY18 - power16 ) , 0.0 , 0.0));
			float temp_output_40_0 = ( ScreenPositionX17 - power16 );
			float temp_output_42_0 = ( ScreenPositionY18 + power16 );
			float4 appendResult60 = (float4(temp_output_40_0 , temp_output_42_0 , 0.0 , 0.0));
			float4 appendResult55 = (float4(temp_output_40_0 , temp_output_42_0 , 0.0 , 0.0));
			float temp_output_50_0 = ( ScreenPositionX17 + power16 );
			float temp_output_49_0 = ( ScreenPositionY18 - power16 );
			float4 appendResult56 = (float4(temp_output_50_0 , temp_output_49_0 , 0.0 , 0.0));
			float4 appendResult61 = (float4(temp_output_50_0 , temp_output_49_0 , 0.0 , 0.0));
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float4 temp_cast_1 = (power16).xxxx;
			o.Albedo = tex2D( _TextureSample0, ( ( ( float4( ( i.uv_texcoord + power16 ), 0.0 , 0.0 ) + appendResult59 + appendResult58 + appendResult57 + appendResult53 ) + ( appendResult60 + appendResult55 + appendResult56 + appendResult61 + ( ase_screenPosNorm - temp_cast_1 ) + ( ase_screenPosNorm + power16 ) ) ) / 10.0 ).xy ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
1204;73;480;927;-834.027;-2322.049;1.803687;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;78;-3680.446,2961.393;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;14;-3715.892,3398.414;Float;False;Property;_power;power;0;0;Create;True;0;0;False;0;0;0.00198;0;0.01;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;18;-3400.451,3181.911;Float;False;ScreenPositionY;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;17;-3407.781,3095.228;Float;False;ScreenPositionX;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;16;-3375.277,3401.494;Float;False;power;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;24;-2547.883,3342.103;Float;False;16;power;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;23;-2486.051,4466.68;Float;False;16;power;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;26;-2308.283,1251.398;Float;False;16;power;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;25;-2625.173,3631.942;Float;False;16;power;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;32;-2515.691,4329.211;Float;False;18;ScreenPositionY;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;31;-2413.58,3192.764;Float;False;17;ScreenPositionX;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;34;-2488.122,3499.951;Float;False;18;ScreenPositionY;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;33;-2441.149,4022.024;Float;False;17;ScreenPositionX;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;28;-2452.713,2536.801;Float;False;18;ScreenPositionY;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;27;-2415.701,1129.899;Float;False;17;ScreenPositionX;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;30;-2512.216,1909.875;Float;False;17;ScreenPositionX;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;29;-2380.8,1503.597;Float;False;18;ScreenPositionY;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;20;-2404.896,2117.051;Float;False;16;power;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;19;-2486.051,2700.593;Float;False;16;power;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;22;-2625.173,4118.874;Float;False;16;power;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;21;-2358.521,1691.953;Float;False;16;power;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;42;-2167.172,3550.702;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;79;-2064.735,495.2862;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;50;-2140.04,4113.808;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;39;-2122.387,2466.642;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;40;-2136.67,3231.89;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;41;-2577.227,4771.588;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;46;-2123.851,1984.736;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;45;-2211.216,1838.627;Float;False;18;ScreenPositionY;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;43;-2113.714,2304.049;Float;False;17;ScreenPositionX;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;49;-2156.939,4373.246;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;48;-2557.419,5163.708;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;47;-2110.228,1126.29;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;36;-1967.013,736.0717;Float;False;16;power;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;35;-2331.471,5293.687;Float;False;16;power;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;38;-2068.294,1507.269;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;37;-2397.168,4980.66;Float;False;16;power;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;55;-1798.991,3610.529;Float;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;56;-1857.393,4101.566;Float;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;53;-1800.549,2421.729;Float;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;54;-2047.215,5205.284;Float;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;57;-1821.626,1968.183;Float;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;60;-1794.265,3202.69;Float;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;61;-1839.368,4381.101;Float;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;58;-1772.298,1504.071;Float;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;59;-1768.449,1026.594;Float;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;51;-2145.31,4889.301;Float;True;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;52;-1720.598,524.9587;Float;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;74;-372.0273,3139.401;Float;True;6;6;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;5;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;73;-451.001,2367.886;Float;True;5;5;0;FLOAT2;0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;76;439.4098,3043.696;Float;False;Constant;_light;light;1;0;Create;True;0;0;False;0;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;75;161.8766,2588.715;Float;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;77;760.0582,2831.705;Float;True;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;80;1164.219,2792.06;Float;True;Property;_TextureSample0;Texture Sample 0;5;0;Create;True;0;0;False;0;None;350ad78503abe694f961726b88ab6e87;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-915.7926,-128.3332;Float;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-661.4791,-403.5626;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-397.9214,-351.7602;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;6;-400.7265,-602.1876;Float;False;Property;_Color0;Color 0;3;1;[HDR];Create;True;0;0;False;0;0.4481132,0.7569961,1,0;0,1.158541,1.5933,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;-625.6091,-268.6684;Float;False;Constant;_Float0;Float 0;2;0;Create;True;0;0;False;0;0.333;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-230.1384,-387.0269;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;2;326.7852,-123.7772;Float;False;Property;_no_Emission;no_Emission;4;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;71.06194,-163.8242;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;8;97.38953,-376.7605;Float;False;Property;_ToggleSwitch0;Toggle Switch0;2;0;Create;True;0;0;False;0;1;2;0;COLOR;0,0,0,0;False;1;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1574.116,2731.124;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;sprite_switch;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Off;1;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;True;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;18;0;78;2
WireConnection;17;0;78;1
WireConnection;16;0;14;0
WireConnection;42;0;34;0
WireConnection;42;1;25;0
WireConnection;50;0;33;0
WireConnection;50;1;22;0
WireConnection;39;0;28;0
WireConnection;39;1;19;0
WireConnection;40;0;31;0
WireConnection;40;1;24;0
WireConnection;46;0;30;0
WireConnection;46;1;20;0
WireConnection;49;0;32;0
WireConnection;49;1;23;0
WireConnection;47;0;27;0
WireConnection;47;1;26;0
WireConnection;38;0;29;0
WireConnection;38;1;21;0
WireConnection;55;0;40;0
WireConnection;55;1;42;0
WireConnection;56;0;50;0
WireConnection;56;1;49;0
WireConnection;53;0;43;0
WireConnection;53;1;39;0
WireConnection;54;0;48;0
WireConnection;54;1;35;0
WireConnection;57;0;46;0
WireConnection;57;1;45;0
WireConnection;60;0;40;0
WireConnection;60;1;42;0
WireConnection;61;0;50;0
WireConnection;61;1;49;0
WireConnection;58;0;47;0
WireConnection;58;1;38;0
WireConnection;59;0;47;0
WireConnection;59;1;38;0
WireConnection;51;0;41;0
WireConnection;51;1;37;0
WireConnection;52;0;79;0
WireConnection;52;1;36;0
WireConnection;74;0;60;0
WireConnection;74;1;55;0
WireConnection;74;2;56;0
WireConnection;74;3;61;0
WireConnection;74;4;51;0
WireConnection;74;5;54;0
WireConnection;73;0;52;0
WireConnection;73;1;59;0
WireConnection;73;2;58;0
WireConnection;73;3;57;0
WireConnection;73;4;53;0
WireConnection;75;0;73;0
WireConnection;75;1;74;0
WireConnection;77;0;75;0
WireConnection;77;1;76;0
WireConnection;80;1;77;0
WireConnection;12;0;1;1
WireConnection;12;1;1;2
WireConnection;12;2;1;3
WireConnection;11;0;12;0
WireConnection;11;1;4;0
WireConnection;7;0;6;0
WireConnection;7;1;11;0
WireConnection;2;0;13;0
WireConnection;13;0;7;0
WireConnection;13;1;8;0
WireConnection;8;0;7;0
WireConnection;8;1;1;0
WireConnection;0;0;80;0
ASEEND*/
//CHKSM=8B1D3DC1E0F2A1BF3A33C096784E1C88547C8A97