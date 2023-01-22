Shader "CombatLink/CombatLink_Example"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {}
		_MainTex2("Secondary Texture", 2D) = "black" {}
		_MiniMapDefault("Texture", 2D) = "black" {}
		_Scale("Scale", Float) = 1.0
		_VerticalAdjust("Vertical Adjust", Float) = 0.0
		_ScaleVR("ScaleVR VR", Float) = 0.5
		_VerticalAdjustVR("Vertical Adjust VR", Float) = 0.0
		_CombatLink_Ammo("Ammo", Float) = 0
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

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD0;
				float4 color : COLOR;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD0;
                float4 vertex : SV_POSITION;
				float4 color : COLOR;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			sampler2D _MainTex2;
			float4 _MainTex2_ST;
			sampler2D _MiniMapDefault;
			float4 _MiniMapDefault_ST;
			float _Scale;	
			float _ScaleVR;	
			float _VerticalAdjust;	
			float _VerticalAdjustVR;	
			float _CombatLink_Ammo;
			float _DEBUGMODE;
            #include "../../CombatLink/Shaders/Includes/CombatLink_Shared.cginc"
				
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

			fixed4 BlendByAlpha(v2f i, fixed4 iCol, fixed4 damageColor, float value)
			{
				float3 colorResult = lerp(iCol.xyz, damageColor.xyz, damageColor.w < (1-value));
				return float4(colorResult,iCol.w);
			}

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
				float4 damageColor = tex2D(_MainTex2, i.uv);
				float4 minimap = tex2D(_MiniMapDefault, i.uv);
				float4 HAOT = CombatLink_GetMainData();
				if(CombatLink_IsActive())
				{
					if(distance(i.color, fixed4(1,0,0,1)) < 0.05)
					{
						col = BlendByAlpha(i, col, damageColor, HAOT.x);
					}

					if(distance(i.color, fixed4(0.9,0,0,1)) < 0.05)
					{
						col = BlendByAlpha(i, col, damageColor, 0.5);
					}
					
					if(distance(i.color, fixed4(0.8,0,0,1)) < 0.05)
					{
						col = BlendByAlpha(i, col, damageColor, HAOT.z);
					}
					// Temperature is defined as a raw value in Kelvin rather than a percentage, so make sure to calculate that properly!
					if(distance(i.color, fixed4(0.7,0,0,1)) < 0.05)
					{
						col = BlendByAlpha(i, col, damageColor, HAOT.w/(COMBATLINK_SAFETEMPERATURE*2));
					}
					
					if(distance(i.color, fixed4(0.6,0,0,1)) < 0.05)
					{
						col = minimap;
						if(CombatLink_HasMinimap())
						{
							col.xyz = CombatLink_GetMinimap(i.uv, false).xyz;
						}
						else
						{
							col.w = 0;
						}
					}
					int currentStatusSlot = 0;


					if(distance(i.color, fixed4(0.5,0,0,1)) < 0.05)
					{
						currentStatusSlot = currentStatusSlot + 1;
					}
					switch(currentStatusSlot)
					{
						case 0:
							if(distance(i.color, fixed4(0.5,0,0,1)) < 0.05)
							{
								currentStatusSlot = currentStatusSlot + 1;
							}
						break;
						case 1:
							if(distance(i.color, fixed4(0.4,0,0,1)) < 0.05)
							{
								currentStatusSlot = currentStatusSlot + 1;
							}
						break;
						default:
						break;
					}
					switch(currentStatusSlot)
					{
						case 0:
							if(distance(i.color, fixed4(0.5,0,0,1)) < 0.05)
							{
								currentStatusSlot = currentStatusSlot + 1;
							}
						break;
						case 1:
							if(distance(i.color, fixed4(0.4,0,0,1)) < 0.05)
							{
								currentStatusSlot = currentStatusSlot + 1;
							}
						break;
						case 2:
							if(distance(i.color, fixed4(0.3,0,0,1)) < 0.05)
							{
								currentStatusSlot = currentStatusSlot + 1;
							}
						break;
						default:
						break;
					}
					switch(currentStatusSlot)
					{
						case 0:
							if(distance(i.color, fixed4(0.5,0,0,1)) < 0.05)
							{
								currentStatusSlot = currentStatusSlot + 1;
							}
						break;
						case 1:
							if(distance(i.color, fixed4(0.4,0,0,1)) < 0.05)
							{
								currentStatusSlot = currentStatusSlot + 1;
							}
						break;
						case 2:
							if(distance(i.color, fixed4(0.3,0,0,1)) < 0.05)
							{
								currentStatusSlot = currentStatusSlot + 1;
							}
						break;
						case 3:
							if(distance(i.color, fixed4(0.2,0,0,1)) < 0.05)
							{
								currentStatusSlot = currentStatusSlot + 1;
							}
						break;
						default:
						break;
					}
					switch(currentStatusSlot)
					{
						case 0:
							if(distance(i.color, fixed4(0.5,0,0,1)) < 0.05)
							{
								currentStatusSlot = currentStatusSlot + 1;
							}
						break;
						case 1:
							if(distance(i.color, fixed4(0.4,0,0,1)) < 0.05)
							{
								currentStatusSlot = currentStatusSlot + 1;
							}
						break;
						case 2:
							if(distance(i.color, fixed4(0.3,0,0,1)) < 0.05)
							{
								currentStatusSlot = currentStatusSlot + 1;
							}
						break;
						case 3:
							if(distance(i.color, fixed4(0.2,0,0,1)) < 0.05)
							{
								currentStatusSlot = currentStatusSlot + 1;
							}
						break;
						case 4:
							if(distance(i.color, fixed4(0.1,0,0,1)) < 0.05)
							{
								currentStatusSlot = currentStatusSlot + 1;
							}
						break;
						default:
						break;
					}
					switch(currentStatusSlot)
					{
						case 0:
							if(distance(i.color, fixed4(0.5,0,0,1)) < 0.05)
							{
								currentStatusSlot = currentStatusSlot + 1;
							}
						break;
						case 1:
							if(distance(i.color, fixed4(0.4,0,0,1)) < 0.05)
							{
								currentStatusSlot = currentStatusSlot + 1;
							}
						break;
						case 2:
							if(distance(i.color, fixed4(0.3,0,0,1)) < 0.05)
							{
								currentStatusSlot = currentStatusSlot + 1;
							}
						break;
						case 3:
							if(distance(i.color, fixed4(0.2,0,0,1)) < 0.05)
							{
								currentStatusSlot = currentStatusSlot + 1;
							}
						break;
						case 4:
							if(distance(i.color, fixed4(0.1,0,0,1)) < 0.05)
							{
								currentStatusSlot = currentStatusSlot + 1;
							}
						break;
						case 5:
							if(distance(i.color, fixed4(0,0,0,1)) < 0.05)
							{
								currentStatusSlot = currentStatusSlot + 1;
							}
						break;
						default:
						break;
					}
					switch(currentStatusSlot)
					{
						case 0:
							if(distance(i.color, fixed4(0.5,0,0,1)) < 0.05)
							{
								currentStatusSlot = currentStatusSlot + 1;
							}
						break;
						case 1:
							if(distance(i.color, fixed4(0.4,0,0,1)) < 0.05)
							{
								currentStatusSlot = currentStatusSlot + 1;
							}
						break;
						case 2:
							if(distance(i.color, fixed4(0.3,0,0,1)) < 0.05)
							{
								currentStatusSlot = currentStatusSlot + 1;
							}
						break;
						case 3:
							if(distance(i.color, fixed4(0.2,0,0,1)) < 0.05)
							{
								currentStatusSlot = currentStatusSlot + 1;
							}
						break;
						case 4:
							if(distance(i.color, fixed4(0.1,0,0,1)) < 0.05)
							{
								currentStatusSlot = currentStatusSlot + 1;
							}
						break;
						case 5:
							if(distance(i.color, fixed4(0,0,0,1)) < 0.05)
							{
								currentStatusSlot = currentStatusSlot + 1;
							}
						break;
						case 6:
							if(distance(i.color, fixed4(0,0.1,0,1)) < 0.05)
							{
								currentStatusSlot = currentStatusSlot + 1;
							}
						break;
						default:
						break;
					}
					
					switch(currentStatusSlot)
					{
						case 0:
							if(distance(i.color, fixed4(0.5,0,0,1)) < 0.05)
							{
								currentStatusSlot = currentStatusSlot + 1;
							}
						break;
						case 1:
							if(distance(i.color, fixed4(0.4,0,0,1)) < 0.05)
							{
								currentStatusSlot = currentStatusSlot + 1;
							}
						break;
						case 2:
							if(distance(i.color, fixed4(0.3,0,0,1)) < 0.05)
							{
								currentStatusSlot = currentStatusSlot + 1;
							}
						break;
						case 3:
							if(distance(i.color, fixed4(0.2,0,0,1)) < 0.05)
							{
								currentStatusSlot = currentStatusSlot + 1;
							}
						break;
						case 4:
							if(distance(i.color, fixed4(0.1,0,0,1)) < 0.05)
							{
								currentStatusSlot = currentStatusSlot + 1;
							}
						break;
						case 5:
							if(distance(i.color, fixed4(0,0,0,1)) < 0.05)
							{
								currentStatusSlot = currentStatusSlot + 1;
							}
						break;
						case 6:
							if(distance(i.color, fixed4(1,0.1,0,1)) < 0.05)
							{
								currentStatusSlot = currentStatusSlot + 1;
							}
						break;
						case 7:
							if(distance(i.color, fixed4(0.9,0.1,0,1)) < 0.05)
							{
								currentStatusSlot = currentStatusSlot + 1;
							}
						break;
						default:
						break;
					}
				}
				else{
					if(distance(i.color, fixed4(0.9,0,0,1)) < 0.05)
					{
						col = BlendByAlpha(i, col, damageColor, 0);
					}
					
					if(distance(i.color, fixed4(0.7,0,0,1)) < 0.05)
					{
						col = BlendByAlpha(i, col, damageColor, 0.5);
					}

					if(distance(i.color, fixed4(0.6,0,0,1)) < 0.05)
					{
						col = minimap;
						col.w = 0;
					}
				}

                return col;
            }
            ENDCG
        }
    }
}
