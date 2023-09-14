Shader "CombatLink/GuardianSpace_Hud"
{
    Properties
    {
        _MainTex ("Background", 2D) = "white" {}
        _StatusTex("Status Icons", 2D) = "white" {}
        _MaskTex("Mask", 2D) = "white" {}
        _Alpha("Alpha", Range(0,1)) = 0.5
        _AlphaAdd("Alpha Add", Float) = 0
        _Scale("Scale", Float) = 0.75
        _VerticalAdjust("Vertical Adjust", Float) = 0.0
        _ScaleVR("ScaleVR VR", Float) = 0.375
        _VerticalAdjustVR("Vertical Adjust VR", Float) = 0.0
        _DEBUGBAR("DEBUG: TEMP", Range(-1,1)) = 1.0
    }
    SubShader
    {
        Tags {
             "Queue" = "Transparent+40"
             "RenderType" = "Transparent"
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
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "Assets/CombatLink/Shaders/Includes/CombatLink_Shared.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
                float2 uv3 : TEXCOORD2;
                float2 uv4 : TEXCOORD3;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float2 gradient : TEXCOORD1;
                float2 mask : TEXCOORD2;
                float2 icons : TEXCOORD3;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _MaskTex;
            float4 _MaskTex_ST;

            sampler2D _StatusTex;
            float4 _StatusTex_ST;

            float _Alpha;
            float _AlphaAdd;

            float _Scale;
            float _ScaleVR;
            float _VerticalAdjust;
            float _VerticalAdjustVR;
            float _DEBUGBAR;

            v2f vert (appdata v)
            {
                v2f o;
#if UNITY_SINGLE_PASS_STEREO
                o.vertex = CombatLink_VertexScreenSpacePosition(v.vertex, _ScaleVR, _VerticalAdjustVR, 3);
#else
                o.vertex = CombatLink_VertexScreenSpacePosition(v.vertex, _Scale, _VerticalAdjust, 3);
#endif
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.gradient = TRANSFORM_TEX(v.uv2, _MainTex);
                o.mask = TRANSFORM_TEX(v.uv3, _MainTex);
                o.icons = TRANSFORM_TEX(v.uv4, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv) * _Alpha;
                fixed mask = tex2D(_MaskTex, i.uv).r;
                if (CombatLink_IsActive())
                {
                    float4 combatLinkDataMain = CombatLink_GetMainData();
                    float4 combatLinkDataDamageStatus = CombatLink_GetDamageStatusData();
                    float4 combatLinkDataStatus = CombatLink_GetStatusData();
                    if (distance(i.mask, float2(0, 1)) < 0.005f)
                    {
                        col = lerp(col, col * half4(1, 0, 0, 1 + _AlphaAdd), (i.gradient.x < combatLinkDataMain.r) * mask);
                    }

                    if (distance(i.mask, float2(0.01f, 1)) < 0.005f)
                    {
                        if (combatLinkDataMain.g > 0.01)
                        {
                            col = lerp(col, col * half4(0, 1, 0, 1 + _AlphaAdd), (i.gradient.x < combatLinkDataMain.g) * mask);
                        }
                        else {
                            col.a = 0;
                        }
                    }

                    if (distance(i.mask, float2(0.02f, 1)) < 0.005f)
                    {
                        col = lerp(col, col * half4(0.75f, 0.75f, 1, 1 + _AlphaAdd), (i.gradient.x < combatLinkDataMain.b) * mask);
                    }

                    if (distance(i.mask, float2(0.03f, 1)) < 0.005f)
                    {
                        float temperature = (combatLinkDataMain.a / COMBATLINK_SAFETEMPERATURE)-1;
                        if (temperature > 0)
                        {
                            col = lerp(col, col * half4(lerp(half3(0.5,1,0.5), half3(0.5, 0, 0), clamp((temperature*2) - 0.1,0,1)), 1 + _AlphaAdd), (i.gradient.x < temperature) * mask);

                        }
                        else {
                            col = lerp(col, col * half4(lerp(half3(0.5, 1, 0.5), half3(0.5, 0.5, 1), clamp((-2 * temperature)-0.05, 0,1)), 1 + _AlphaAdd), (i.gradient.x < -1 * temperature) * mask);
                        }
                    }

                    if (distance(i.mask, float2(0.0f, 0.99f)) < 0.005f)
                    {
                        col = tex2D(_StatusTex, (i.icons * 0.25) + half2(0,0.75)) * _Alpha * clamp(combatLinkDataDamageStatus.r*5, 0,1);
                        col.a *= clamp(1.5 + (_SinTime.w), 0, 1);
                    }

                    if (distance(i.mask, float2(0.01f, 0.99f)) < 0.005f)
                    {
                        col = tex2D(_StatusTex, (i.icons * 0.25) + half2(0.25, 0.75)) * _Alpha * clamp(combatLinkDataDamageStatus.g * 5, 0, 1);
                        col.a *= clamp(1.5 + (_SinTime.w), 0, 1);
                    }

                    if (distance(i.mask, float2(0.02f, 0.99f)) < 0.005f)
                    {
                        col = tex2D(_StatusTex, (i.icons * 0.25) + half2(0.5, 0.75)) * _Alpha * clamp(combatLinkDataDamageStatus.b * 5, 0, 1);
                        col.a *= clamp(1.5 + (_SinTime.w), 0, 1);
                    }

                    if (distance(i.mask, float2(0.03f, 0.99f)) < 0.005f)
                    {
                        col = tex2D(_StatusTex, (i.icons * 0.25) + half2(0.75, 0.75)) * _Alpha * clamp(combatLinkDataDamageStatus.a * 5, 0, 1);
                        col.a *= clamp(1.5 + (_SinTime.w), 0, 1);
                    }

                    if (distance(i.mask, float2(0.04f, 0.99f)) < 0.005f)
                    {
                        col = tex2D(_StatusTex, (i.icons * 0.25) + half2(0, 0.5)) * _Alpha * clamp(combatLinkDataStatus.r * 5, 0, 1);
                        col.a *= clamp(1.5 + (_SinTime.w), 0, 1);
                    }

                    if (distance(i.mask, float2(0.05f, 0.99f)) < 0.005f)
                    {
                        col = tex2D(_StatusTex, (i.icons * 0.25) + half2(0.25f, 0.5)) * _Alpha * clamp(combatLinkDataStatus.g * 5, 0, 1);
                        col.a *= clamp(1.5 + (_SinTime.w), 0, 1);
                    }

                    if (distance(i.mask, float2(0.06f, 0.99f)) < 0.005f)
                    {
                        col = tex2D(_StatusTex, (i.icons * 0.25) + half2(0.5f, 0.5)) * _Alpha * clamp(combatLinkDataStatus.b * 5, 0, 1);
                        col.a *= clamp(1.5 + (_SinTime.w), 0, 1);
                    }

                    if (distance(i.mask, float2(0.07f, 0.99f)) < 0.005f)
                    {
                        col = tex2D(_StatusTex, (i.icons * 0.25) + half2(0.75f, 0.5)) * _Alpha * clamp(combatLinkDataStatus.a * 5, 0, 1);
                        col.a *= clamp(1.5 +(_SinTime.w), 0, 1);
                    }
                }
                else {
                    if (distance(i.mask, float2(0, 1)) < 0.01f)
                    {
                        col = lerp(col, col * half4(1, 0, 0, 1 + _AlphaAdd), mask);
                    }

                    if (distance(i.mask, float2(0.01f, 1)) < 0.005f)
                    {
                        col.a = 0;
                    }

                    if (distance(i.mask, float2(0.02f, 1)) < 0.005f)
                    {
                        col = lerp(col, col * half4(0.75f, 0.75f, 1, 1 + _AlphaAdd), (i.gradient.x < (_CosTime.y * 0.025f) + 0.9f) * mask);
                    }

                    if (distance(i.mask, float2(0.03f, 1)) < 0.005f)
                    {
                        col = lerp(col, col * half4(0.5, 1, 0.5, 1 + _AlphaAdd), (i.gradient.x < (_SinTime.w * 0.025f) + 0.1f) * mask);
                    }

                    if (distance(i.mask, float2(0.0f, 0.99f)) < 0.005f)
                    {
                        col.a = 0;
                    }

                    if (distance(i.mask, float2(0.01f, 0.99f)) < 0.005f)
                    {
                        col.a = 0;
                    }

                    if (distance(i.mask, float2(0.02f, 0.99f)) < 0.005f)
                    {
                        col.a = 0;
                    }

                    if (distance(i.mask, float2(0.03f, 0.99f)) < 0.005f)
                    {
                        col.a = 0;
                    }

                    if (distance(i.mask, float2(0.04f, 0.99f)) < 0.005f)
                    {
                        col.a = 0;
                    }

                    if (distance(i.mask, float2(0.05f, 0.99f)) < 0.005f)
                    {
                        col.a = 0;
                    }

                    if (distance(i.mask, float2(0.06f, 0.99f)) < 0.005f)
                    {
                        col.a = 0;
                    }

                    if (distance(i.mask, float2(0.07f, 0.99f)) < 0.005f)
                    {
                        col.a = 0;
                    }
                }
                return col;
            }
            ENDCG
        }
    }
}
