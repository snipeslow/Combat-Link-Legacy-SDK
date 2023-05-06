Shader "CombatLink/CombatLink_NightVision"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_NightVisionEnabled ("Enable", Range(0,1)) = 0

    }
    SubShader
    {
        Tags {
			"Queue" = "Transparent+35"
			"RenderType"="Transparent" 
		}
        LOD 100
		ZWrite Off
		ZTest Always
		GrabPass { "_CombatLinkNightVision" }
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
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
				float4 uv2 : TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);

			sampler2D _CombatLinkNightVision;

			float _NightVisionEnabled;

            v2f vert (appdata v)
            {
                v2f o;
                //o.vertex = UnityObjectToClipPos(v.vertex);
				o.vertex = CombatLink_VertexScreenSpacePosition(v.vertex, 1, 0, 6);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.uv2 = ComputeGrabScreenPos(o.vertex);
                COMPUTE_EYEDEPTH(o.uv2.z);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				fixed4 col = tex2Dproj(_CombatLinkNightVision, i.uv2);
				fixed4 colRes = col;
                colRes.w = 0;
				if (_NightVisionEnabled > 0.01)
				{

					fixed pi2 = 3.141 * 2;
					fixed colorGreyscale = max(max(col.r, col.g), col.b);
                    fixed colorOutline = colorGreyscale;

                    fixed deph = 1 - saturate(LinearEyeDepth(tex2Dproj(_CameraDepthTexture, i.uv2)) / lerp(8, 32, _NightVisionEnabled));
                    fixed2 Radius = lerp(deph, 1, _NightVisionEnabled) / _ScreenParams.xy;
                    fixed3 blurColor = colorGreyscale;
                    fixed blurOutline = deph;
					for (int d = 0; d < pi2; d += pi2 / 2)
					{
                        blurColor = tex2Dproj(_CombatLinkNightVision, i.uv2 + fixed4(cos(d)*Radius.x, sin(d)*Radius.y , 0, 0)).rgb;
                        blurOutline += 1 - saturate(LinearEyeDepth(tex2Dproj(_CameraDepthTexture, i.uv2 + fixed4(cos(d) * Radius.x, sin(d) * Radius.y, 0, 0))) / lerp(8, 32, _NightVisionEnabled));
                        colorOutline += max(max(blurColor.r, blurColor.g), blurColor.b);
					}
                    colorOutline /= 4;
                    blurOutline /= 4;
                    blurOutline = distance(deph, blurOutline);
                    blurOutline = saturate(blurOutline * lerp(8, 32, _NightVisionEnabled)) > 0.5;
                    colorOutline = distance(colorGreyscale, colorOutline);
                    colorOutline = saturate(colorOutline *lerp(8,32, _NightVisionEnabled)) > 0.5;
                    colRes = lerp(col * fixed4(0.25, 0.25+deph, 0.25,1), fixed4(0, 1, 0, 1), saturate((colorOutline*0.5)+ blurOutline));
				}
                return colRes;
            }
            ENDCG
        }
    }
}
