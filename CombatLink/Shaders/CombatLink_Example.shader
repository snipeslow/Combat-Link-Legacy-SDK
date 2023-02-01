Shader "CombatLink/CombatLink_Example"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {}
		_RampTex("Ramp Texture", 2D) = "black" {}
		_ThermalTex("Thermal Texture", 2D) = "black" {}
		_StatusTex("Status Texture", 2D) = "black" {}
		_MiniMapDefault("Texture", 2D) = "black" {}
		_Scale("Scale", Float) = 1.0
		_VerticalAdjust("Vertical Adjust", Float) = 0.0
		_ScaleVR("ScaleVR VR", Float) = 0.5
		_VerticalAdjustVR("Vertical Adjust VR", Float) = 0.0
		_CombatLink_Ammo("Ammo", Float) = 0
		_NightVisionEnabled("Enable", Range(0,1)) = 0
    }
    SubShader
    {
        Tags { 
			 "Queue"="Transparent+40"
			 "RenderType"="Transparent"
		}
        LOD 100
		ZWrite Off
		ZTest Always
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
			#include "../../CombatLink/Shaders/Includes/CombatLink_Shared.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
				float4 color : COLOR;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
                float4 vertex : SV_POSITION;
				float4 color : COLOR;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

			sampler2D _RampTex;
			float4 _RampTex_ST;

			sampler2D _ThermalTex;
			float4 _ThermalTex_ST;

			sampler2D _MiniMapDefault;
			float4 _MiniMapDefault_ST;

			sampler2D _StatusTex;
			float4 _StatusTex_ST;
			
			float _Scale;	
			float _ScaleVR;	
			float _VerticalAdjust;	
			float _VerticalAdjustVR;	
			float _CombatLink_Ammo;
			float _DEBUGMODE_VR;

			sampler2D _CombatLinkNightVision;
				
            v2f vert (appdata v)
            {
                v2f o;
				o.color = v.color;
				#if UNITY_SINGLE_PASS_STEREO
					o.vertex = CombatLink_VertexScreenSpacePosition(v.vertex, _ScaleVR, _VerticalAdjustVR, 3);
				#else
					o.vertex = CombatLink_VertexScreenSpacePosition(v.vertex, _Scale, _VerticalAdjust, 3);
				#endif
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv2 = TRANSFORM_TEX(v.uv2, _MainTex);
                return o;
            }

			fixed4 BlendByAlpha(v2f i, fixed4 iCol, fixed4 damageColor, float value, bool symmetrical)
			{
				float3 colorResult = lerp(iCol.xyz, damageColor.xyz, damageColor.w < (1-value));
				if(symmetrical)
				{
					value = (value*0.5)+0.5;
					colorResult = lerp(iCol.xyz, damageColor.xyz, damageColor.w > (value));
					colorResult = lerp(colorResult, damageColor.xyz, damageColor.w < (1-value));
					//colorResult = lerp(colorResult, damageColor.xyz, damageColor.w < (1-value));
				}
				colorResult = colorResult * iCol;
				return float4(colorResult,iCol.w);
			}
			
			fixed4 BlendByAlphaSlider(v2f i, fixed4 iCol, fixed4 damageColor, float value)
			{
				value = clamp(value,0.02,1);
				float3 colorResult = lerp(iCol.xyz, damageColor.xyz, damageColor.w < 0.99-value);
				colorResult = lerp(colorResult, damageColor.xyz, damageColor.w > 1.01-value);
				colorResult = colorResult * iCol;
				return float4(colorResult,iCol.w);
			}

			bool IsVetexColorID(v2f i, int id)
			{
				return distance(i.color, fixed4(id*0.1%1,floor(id*0.1)*0.1,0,1)) < 0.05;
			}
			fixed4 StatusIcon(v2f i, fixed4 col, int id){
				fixed2 uvCoord = i.uv*0.25;
				uvCoord.x = uvCoord.x + ((id % 4)*0.25);
				uvCoord.y = uvCoord.y + 0.75 - (floor(id / 4.0) * 0.25);
				return fixed4(col.xyz * tex2D(_StatusTex, uvCoord).xyz, col.w);
			}

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
				float4 damageColor = tex2D(_RampTex, i.uv);
				float4 thermalColor = tex2D(_ThermalTex, i.uv);
				float4 minimap = tex2D(_MiniMapDefault, i.uv);
				if(CombatLink_IsActive())
				{
					float4 HAOT = CombatLink_GetMainData();
					if(IsVetexColorID(i, 1))
					{
						col = BlendByAlpha(i, col, damageColor, HAOT.x, false);
					}

					if(IsVetexColorID(i, 2))
					{
						col = BlendByAlpha(i, col, damageColor, HAOT.y, true);
					}
					
					if(IsVetexColorID(i, 3))
					{
						col = BlendByAlpha(i, col, damageColor, HAOT.z, false);
					}
					// Temperature is defined as a raw value in Kelvin rather than a percentage, so make sure to calculate that properly!
					if(IsVetexColorID(i, 4))
					{
						col = BlendByAlphaSlider(i, col, thermalColor, (HAOT.w/(COMBATLINK_SAFETEMPERATURE*2)));

					}
					
					if(IsVetexColorID(i, 5))
					{
						col = minimap;
						if(CombatLink_HasMinimap())
						{
							col.xyz = minimap.xyz * CombatLink_GetMinimap(i.uv, false).xyz;
						}
						else
						{
							col.w = 0;
						}
					}
					
					float4 BBPF = CombatLink_GetDamageStatusData();

					if(IsVetexColorID(i, 6))
					{
						if(BBPF.x > 0)
						{
							col =  StatusIcon(i, col, 0);
						}else if(BBPF.y > 0)
						{
							col =  StatusIcon(i, col, 1);
						}else if(BBPF.z > 0)
						{
							col =  StatusIcon(i, col, 2);
						}else if(BBPF.w > 0)
						{
							col =  StatusIcon(i, col, 3);
						}else{
							col.w = 0;
						}
					}

					if(IsVetexColorID(i, 7))
					{
						if(BBPF.x > 0)
						{
							if(BBPF.y > 0)
							{
								col =  StatusIcon(i, col, 1);
							}else if(BBPF.z > 0)
							{
								col =  StatusIcon(i, col, 2);
							}else if(BBPF.w > 0)
							{
								col =  StatusIcon(i, col, 3);
							}else
							{
								col.w = 0;
							}
						}else{
							col.w = 0;
						}
					}

					if(IsVetexColorID(i, 8))
					{
						if(BBPF.x > 0)
						{
							if(BBPF.y > 0)
							{ 
								if(BBPF.z > 0)
								{
									col =  StatusIcon(i, col, 2);
								}else if(BBPF.w > 0)
								{
									col =  StatusIcon(i, col, 3);
								}else
								{
									col.w = 0;
								}
							}else
							{
								col.w = 0;
							}
						}else{
							col.w = 0;
						}
					}
					
					if(IsVetexColorID(i, 9))
					{
						if(BBPF.x > 0)
						{
							if(BBPF.y > 0)
							{ 
								if(BBPF.z > 0)
								{ 
									if(BBPF.w > 0)
									{
										col =  StatusIcon(i, col, 3);
									}else
									{
										col.w = 0;
									}
								}else
								{
									col.w = 0;
								}
							}else
							{
								col.w = 0;
							}
						}else{
							col.w = 0;
						}
					}

					float4 BSSH = CombatLink_GetStatusData();

					if(IsVetexColorID(i, 10))
					{
						if(BSSH.x > 0)
						{
							col =  StatusIcon(i, col, 4);
						}else if(BSSH.y > 0)
						{
							col =  StatusIcon(i, col, 5);
						}else if(BSSH.z > 0)
						{
							col =  StatusIcon(i, col, 6);
						}else if(BSSH.w > 0)
						{
							col =  StatusIcon(i, col, 7);
						}else{
							col.w = 0;
						}
					}

					if(IsVetexColorID(i, 11))
					{
						if(BSSH.x > 0)
						{
							if(BSSH.y > 0)
							{
								col =  StatusIcon(i, col, 5);
							}else if(BSSH.z > 0)
							{
								col =  StatusIcon(i, col, 6);
							}else if(BSSH.w > 0)
							{
								col =  StatusIcon(i, col, 7);
							}else{
								col.w = 0;
							}
						}else{
							col.w = 0;
						}
					}

					if(IsVetexColorID(i, 12))
					{
						if(BSSH.x > 0)
						{
							if(BSSH.y > 0)
							{
								if(BSSH.z > 0)
								{
									col =  StatusIcon(i, col, 6);
								}else if(BSSH.w > 0)
								{
									col =  StatusIcon(i, col, 7);
								}else{
									col.w = 0;
								}
							}else{
								col.w = 0;
							}
						}else{
							col.w = 0;
						}
					}
					
					if(IsVetexColorID(i, 13))
					{
						if(BSSH.x > 0)
						{
							if(BSSH.y > 0)
							{
								if(BSSH.z > 0)
								{
									if(BSSH.w > 0)
									{
										col =  StatusIcon(i, col, 7);
									}else{
										col.w = 0;
									}
								}else{
									col.w = 0;
								}
							}else{
								col.w = 0;
							}
						}else{
							col.w = 0;
						}
					}
				}
				else{
					if(IsVetexColorID(i, 2))
					{
						col = BlendByAlpha(i, col, damageColor, 0, false);
					}
					
					if(IsVetexColorID(i, 4))
					{
						col = BlendByAlphaSlider(i, col, thermalColor, 0.5);
					}

					if(IsVetexColorID(i, 5))
					{
						col = minimap;
						col.w = 0;
					}
					for(int iCount = 6; iCount <= 14; iCount++)
					{
						if(IsVetexColorID(i, iCount))
						{
								col.w = 0;
						}
					}
				}

                return col;
            }
            ENDCG
        }
    }
}
