
// Call this in your vertex shader for screen space. Optional
float4 CombatLink_VertexScreenSpacePosition(float4 vertex, float scale, float verticalAdjust, float maxDistance)
{
    float4 resultVertex;
    // Borrowed from error.mdl's hud code
    float3 worldScale = float3(
        length(float3(unity_ObjectToWorld[0].x, unity_ObjectToWorld[1].x, unity_ObjectToWorld[2].x)), // scale x axis
        length(float3(unity_ObjectToWorld[0].y, unity_ObjectToWorld[1].y, unity_ObjectToWorld[2].y)), // scale y axis
        length(float3(unity_ObjectToWorld[0].z, unity_ObjectToWorld[1].z, unity_ObjectToWorld[2].z))  // scale z axis
    );
    float worldScaleLength = length(worldScale);
    #if UNITY_SINGLE_PASS_STEREO
        float vrOffset = 0.070*(0.5 - unity_StereoEyeIndex);
    #else
        float vrOffset = 0;

    #endif

    // modified from: https://en.wikibooks.org/wiki/Cg_Programming/Unity/Billboards
    // 2 years of smashing my head into a brick wall and finally accidently stumbling upon the solution
    // This is why you should learn Matrices, or you'll end up like me.
    resultVertex = mul(UNITY_MATRIX_P,
    // Uses UNITY_MATRIX_T_MV instead of UNITY_MATRIX_MV in order to have it follow the camera. I have no idea why this works. Can someone explain to me later?
        mul(UNITY_MATRIX_T_MV, float4(0.0, 0.0, 0.0, 1.0))
        // For some reason we need the z component to be -1 for some reason, but I used _ProjectionParams.x instead for no reason. Probally a bad idea. Can someone explain to me why this works.
        + float4(vertex.x+vrOffset, vertex.y+verticalAdjust, _ProjectionParams.x, 0.0)
        * float4(scale, scale, 1.0, 1.0));
    // Borrowed from error.mdl's hud code
    // Incase someone impliments the hud incorrectly, prevents it being shown on everyone's screen at once
    if (distance(resultVertex, UnityObjectToClipPos(vertex))>maxDistance)
    {
        resultVertex = float4(0, 0, 0, 0);
    }
    return resultVertex;
}

uniform float _Udon_CombatLink_Active = 0;

bool CombatLink_IsActive()
{
    return _Udon_CombatLink_Active > 0.5;
}

// Innate support for GoFluffYaself's Avatar PVP to change behaviour to better suit that contex
uniform float _Udon_CombatLink_APVPMode = 0;

bool CombatLink_APVPMode()
{
    return min(_Udon_CombatLink_APVPMode, _Udon_CombatLink_Active) > 0.5;
}


uniform float _Udon_CombatLink_Health = 100;
uniform float _Udon_CombatLink_MaxHealth = 100;
uniform float _Udon_CombatLink_AuxHealth = 0;
uniform float _Udon_CombatLink_MaxAuxHealth = 100;
uniform float _Udon_CombatLink_Oxygen = 100;
uniform float _Udon_CombatLink_MaxOxygen = 100;
uniform float _Udon_CombatLink_Temperature = 293;
#define COMBATLINK_SAFETEMPERATURE 293.0

/*
X = Health
Y = Aux Health/Shield
Z = Oxygen
W = Temperature
*/
float4 CombatLink_GetMainDataRaw()
{
    return float4(_Udon_CombatLink_Health, _Udon_CombatLink_AuxHealth, _Udon_CombatLink_Oxygen, _Udon_CombatLink_Temperature);

}

/*
X = Health Percent
Y = Aux Health/Shield Percent
Z = Oxygen Percent
W = Temperature
*/
float4 CombatLink_GetMainData()
{
    return float4(_Udon_CombatLink_Health / _Udon_CombatLink_MaxHealth,_Udon_CombatLink_AuxHealth / _Udon_CombatLink_MaxAuxHealth,_Udon_CombatLink_Oxygen / _Udon_CombatLink_MaxOxygen, _Udon_CombatLink_Temperature);
}

/*
X = Bleed
Y = Burn
Z = Poison
W = Ice
All of these represents seconds left before the effect is gone.
*/
uniform float _Udon_CombatLink_Bleed;
uniform float _Udon_CombatLink_Burn;
uniform float _Udon_CombatLink_Poison;
uniform float _Udon_CombatLink_Frost;

float4 CombatLink_GetDamageStatusData()
{
    return float4(_Udon_CombatLink_Bleed, _Udon_CombatLink_Burn, _Udon_CombatLink_Poison, _Udon_CombatLink_Frost);
}

/*
X = Boost
Y = Slow
Z = Stun
W = Healing
All of these represents seconds left before the effect is gone.
*/
uniform float _Udon_CombatLink_Boost;
uniform float _Udon_CombatLink_Slow;
uniform float _Udon_CombatLink_Stun;
uniform float _Udon_CombatLink_Healing;

float4 CombatLink_GetStatusData()
{
    return float4(_Udon_CombatLink_Boost, _Udon_CombatLink_Slow, _Udon_CombatLink_Stun, _Udon_CombatLink_Healing);
}

// Tell Shader if we have a minimap or not
uniform float _Udon_CombatLink_HasMinimap;

bool CombatLink_HasMinimap()
{
    return _Udon_CombatLink_HasMinimap > 0.5;
}
// Minimap interface
uniform sampler2D _Udon_CombatLink_Minimap;
uniform sampler2D _Udon_CombatLink_MinimapDotOnly;

fixed4 CombatLink_GetMinimap(float2 uv, float dotOnly)
{
    if(_Udon_CombatLink_HasMinimap)
    {
        if(dotOnly)
        {
           return tex2D(_Udon_CombatLink_MinimapDotOnly, uv);
        }
        else
        {
           return tex2D(_Udon_CombatLink_Minimap, uv);
        }
    }
    return fixed4(0,0,0,1);
}

// Expressed in meters. If not available, return -1 so that the shader knows it doesn't exist.
uniform float _Udon_CombatLink_MinimapScale;

float CombatLink_GetMinimapScale()
{
    if(_Udon_CombatLink_HasMinimap)
    {
        return _Udon_CombatLink_MinimapScale;
    }
    else
    {
        return -1;
    }
}

// For worlds that use their own guns
uniform float _Udon_CombatLink_WorldAmmoOverride = 0;

bool CombatLink_WorldAmmoOverride()
{
    return _Udon_CombatLink_WorldAmmoOverride > 0.5;
}

uniform float _Udon_CombatLink_Ammo;

float CombatLink_GetAmmo()
{
    return _Udon_CombatLink_Ammo;
}

uniform float _Udon_CombatLink_Ammo2;

float CombatLink_GetAmmo2()
{
    return _Udon_CombatLink_Ammo2;
}
