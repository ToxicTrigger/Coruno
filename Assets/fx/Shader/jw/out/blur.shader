// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "blur"
{
	Properties
	{
		_power("power", Range( 0 , 0.01)) = 0
		_light("light", Float) = 10
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" }
		Cull Back
		GrabPass{ }
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#pragma target 3.0
		#pragma surface surf StandardCustomLighting keepalpha addshadow fullforwardshadows noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float4 screenPos;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform sampler2D _GrabTexture;
		uniform float _power;
		uniform float _light;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float ScreenPositionX104 = ase_screenPosNorm.x;
			float power118 = _power;
			float temp_output_46_0 = ( ScreenPositionX104 + power118 );
			float ScreenPositionY103 = ase_screenPosNorm.y;
			float temp_output_51_0 = ( ScreenPositionY103 + power118 );
			float2 appendResult53 = (float2(temp_output_46_0 , temp_output_51_0));
			float4 screenColor47 = tex2D( _GrabTexture, appendResult53 );
			float2 appendResult54 = (float2(temp_output_46_0 , temp_output_51_0));
			float4 screenColor52 = tex2D( _GrabTexture, appendResult54 );
			float4 screenColor3 = tex2D( _GrabTexture, ( ase_screenPosNorm + power118 ).xy );
			float2 appendResult63 = (float2(( ScreenPositionX104 - power118 ) , ScreenPositionY103));
			float4 screenColor65 = tex2D( _GrabTexture, appendResult63 );
			float2 appendResult64 = (float2(ScreenPositionX104 , ( ScreenPositionY103 - power118 )));
			float4 screenColor66 = tex2D( _GrabTexture, appendResult64 );
			float temp_output_97_0 = ( ScreenPositionX104 - power118 );
			float temp_output_82_0 = ( ScreenPositionY103 + power118 );
			float2 appendResult73 = (float2(temp_output_97_0 , temp_output_82_0));
			float4 screenColor75 = tex2D( _GrabTexture, appendResult73 );
			float temp_output_81_0 = ( ScreenPositionX104 + power118 );
			float temp_output_98_0 = ( ScreenPositionY103 - power118 );
			float2 appendResult74 = (float2(temp_output_81_0 , temp_output_98_0));
			float4 screenColor76 = tex2D( _GrabTexture, appendResult74 );
			float2 appendResult83 = (float2(temp_output_81_0 , temp_output_98_0));
			float4 screenColor85 = tex2D( _GrabTexture, appendResult83 );
			float2 appendResult84 = (float2(temp_output_97_0 , temp_output_82_0));
			float4 screenColor86 = tex2D( _GrabTexture, appendResult84 );
			float4 screenColor93 = tex2D( _GrabTexture, ( ase_screenPosNorm + power118 ).xy );
			float4 temp_cast_2 = (power118).xxxx;
			float4 screenColor90 = tex2D( _GrabTexture, ( ase_screenPosNorm - temp_cast_2 ).xy );
			c.rgb = ( ( ( screenColor47 + screenColor52 + screenColor3 + screenColor65 + screenColor66 ) + ( screenColor75 + screenColor76 + screenColor85 + screenColor86 + screenColor93 + screenColor90 ) ) / _light ).rgb;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
572;222;937;789;-1777.325;-2793.19;1.650613;True;True
Node;AmplifyShaderEditor.RangedFloatNode;45;-2509.676,3537.734;Float;False;Property;_power;power;0;0;Create;True;0;0;False;0;0;0.01;0;0.01;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;102;-2460.206,3232.492;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;118;-2169.061,3540.814;Float;False;power;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;104;-2201.565,3234.548;Float;False;ScreenPositionX;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;103;-2194.235,3321.231;Float;False;ScreenPositionY;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;111;-1246.497,2676.121;Float;False;103;ScreenPositionY;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;106;-1174.584,1642.917;Float;False;103;ScreenPositionY;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;125;-1418.957,3771.262;Float;False;118;power;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;121;-1158.941,1751.646;Float;False;118;power;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;120;-1134.139,1390.718;Float;False;118;power;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;122;-1325.31,2179.489;Float;False;118;power;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;123;-1279.835,2839.913;Float;False;118;power;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;108;-1306,2049.195;Float;False;104;ScreenPositionX;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;105;-1209.485,1269.219;Float;False;104;ScreenPositionX;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;114;-1207.364,3332.084;Float;False;104;ScreenPositionX;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;115;-1234.933,4161.344;Float;False;104;ScreenPositionX;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;113;-1281.906,3639.271;Float;False;103;ScreenPositionY;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;116;-1309.475,4468.531;Float;False;103;ScreenPositionY;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;126;-1418.957,4258.194;Float;False;118;power;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;124;-1341.667,3481.423;Float;False;118;power;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;127;-1279.835,4606;Float;False;118;power;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;82;-960.9561,3690.022;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;97;-930.4537,3371.21;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;38;-929.8823,614.8104;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;99;-917.6347,2124.056;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;119;-760.7965,875.3922;Float;False;118;power;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;81;-933.8234,4253.128;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;100;-916.1708,2605.962;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;46;-923.9641,1148.109;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;109;-1005,1977.947;Float;False;103;ScreenPositionY;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;94;-1351.203,5303.028;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;110;-907.4976,2443.369;Float;False;104;ScreenPositionX;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;51;-924.1536,1637.722;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;129;-1125.255,5433.007;Float;False;118;power;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;128;-1190.952,5119.979;Float;False;118;power;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;98;-950.7225,4512.566;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;91;-1371.011,4910.908;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;74;-633.152,4520.421;Float;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;84;-595.2975,3752.372;Float;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;53;-562.233,1165.914;Float;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;54;-1234.676,2319.554;Float;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;64;-594.3325,2561.049;Float;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;101;-939.0941,5028.621;Float;True;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;83;-651.1769,4240.886;Float;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;92;-840.9987,5344.604;Float;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;73;-588.0484,3342.01;Float;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;41;-514.3815,664.2791;Float;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;63;-615.4097,2107.503;Float;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenColorNode;86;-289.3422,3538.217;Float;False;Global;_GrabScreen12;Grab Screen 12;0;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;93;-311.4804,5436.375;Float;False;Global;_GrabScreen2;Grab Screen 2;0;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;47;-306.7108,1116.316;Float;False;Global;_GrabScreen5;Grab Screen 5;0;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;52;-196.0049,1652.895;Float;False;Global;_GrabScreen6;Grab Screen 6;0;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;75;-335.6695,3254.699;Float;False;Global;_GrabScreen9;Grab Screen 9;0;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;76;-152.5068,4320.169;Float;False;Global;_GrabScreen10;Grab Screen 10;0;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;65;-351.0196,2077.859;Float;False;Global;_GrabScreen7;Grab Screen 7;0;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;90;-259.4505,5070.245;Float;False;Global;_GrabScreen1;Grab Screen 1;0;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;85;-260.8596,4102.325;Float;False;Global;_GrabScreen11;Grab Screen 11;0;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;66;-293.5213,2574.531;Float;False;Global;_GrabScreen8;Grab Screen 8;0;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;3;-130.8654,799.4565;Float;False;Global;_GrabScreen0;Grab Screen 0;0;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;87;834.189,3278.721;Float;True;6;6;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;48;755.2154,2507.206;Float;True;5;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;56;1645.626,3183.016;Float;False;Property;_light;light;1;0;Create;True;0;0;False;0;10;15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;88;1458.129,2830.935;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;55;1966.274,2971.025;Float;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2716.996,3193.596;Float;False;True;2;Float;ASEMaterialInspector;0;0;CustomLighting;blur;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;118;0;45;0
WireConnection;104;0;102;1
WireConnection;103;0;102;2
WireConnection;82;0;113;0
WireConnection;82;1;125;0
WireConnection;97;0;114;0
WireConnection;97;1;124;0
WireConnection;99;0;108;0
WireConnection;99;1;122;0
WireConnection;81;0;115;0
WireConnection;81;1;126;0
WireConnection;100;0;111;0
WireConnection;100;1;123;0
WireConnection;46;0;105;0
WireConnection;46;1;120;0
WireConnection;51;0;106;0
WireConnection;51;1;121;0
WireConnection;98;0;116;0
WireConnection;98;1;127;0
WireConnection;74;0;81;0
WireConnection;74;1;98;0
WireConnection;84;0;97;0
WireConnection;84;1;82;0
WireConnection;53;0;46;0
WireConnection;53;1;51;0
WireConnection;54;0;46;0
WireConnection;54;1;51;0
WireConnection;64;0;110;0
WireConnection;64;1;100;0
WireConnection;101;0;91;0
WireConnection;101;1;128;0
WireConnection;83;0;81;0
WireConnection;83;1;98;0
WireConnection;92;0;94;0
WireConnection;92;1;129;0
WireConnection;73;0;97;0
WireConnection;73;1;82;0
WireConnection;41;0;38;0
WireConnection;41;1;119;0
WireConnection;63;0;99;0
WireConnection;63;1;109;0
WireConnection;86;0;84;0
WireConnection;93;0;92;0
WireConnection;47;0;53;0
WireConnection;52;0;54;0
WireConnection;75;0;73;0
WireConnection;76;0;74;0
WireConnection;65;0;63;0
WireConnection;90;0;101;0
WireConnection;85;0;83;0
WireConnection;66;0;64;0
WireConnection;3;0;41;0
WireConnection;87;0;75;0
WireConnection;87;1;76;0
WireConnection;87;2;85;0
WireConnection;87;3;86;0
WireConnection;87;4;93;0
WireConnection;87;5;90;0
WireConnection;48;0;47;0
WireConnection;48;1;52;0
WireConnection;48;2;3;0
WireConnection;48;3;65;0
WireConnection;48;4;66;0
WireConnection;88;0;48;0
WireConnection;88;1;87;0
WireConnection;55;0;88;0
WireConnection;55;1;56;0
WireConnection;0;13;55;0
ASEEND*/
//CHKSM=860964B16B7F7D8D5B6CB473505DB4FC6C24C417