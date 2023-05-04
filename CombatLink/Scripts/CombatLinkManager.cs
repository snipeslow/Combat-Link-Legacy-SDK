/**
 * CombatLink is created by Snipeslow as a standardisation for VRChat to allow worlds to send combat/health related data to avatars.
 * This code is meant to be used within the confines of VRChat's UDON system, via UDONSHARP.
 * Use outside of VRChat is discouraged and no support will be provided for non-VRChat use.
 * CombatLink when used in a world project, requires UDONSharp to function.
 * If UDONSharp is not present, this prefab will not function for world use.
 * If used in an Avatar project, this file is not required to function and you may delete the "CombatLink/Scripts/.." folder optionally.
 * CombatLink is not affiliated with AudioLink.
 **/


using UnityEngine;

// Disable if UDONSharp is not available to prevent errors from being thrown up!

#if UDONSHARP
using UdonSharp;
using VRC.SDKBase;
using VRC.Udon;
[UdonBehaviourSyncMode(BehaviourSyncMode.NoVariableSync)]
public class CombatLinkManager : UdonSharpBehaviour
#else
using VRCShader = UnityEngine.Shader;

public class CombatLinkManager : MonoBehaviour
#endif
{

    // This is used to detect if we are using a world project in the editor
#if UDON && UNITY_EDITOR
    [UnityEditor.InitializeOnLoadMethod]
    static void CombatLinkSetupCheck()
    {
        // We do not have UDONSharp, throw an assert and tell them what to do solve the issue.
#if !UDONSHARP
        Debug.LogAssertion("WARNING: CombatLink is detected in your world project, but UDONSharp is not detected.\nWe mainly support UDONSharp World and Avatar projects, however we do provide a wrapper for UDON Graph and CyanTrigger via CombatLinkGraphWrapper! Please install UDONSharp to continue.");
#endif
        // We do not support Quest/Android, warn the user of the issues.
#if UNITY_ANDROID
        Debug.LogWarning("WARNING: CombatLink is not intended to work in Quest/Android platforms. Features will not work as intended!");
#endif
#if !UNITY_2019_4_OR_NEWER
        Debug.LogWarning("WARNING: CombatLink is not intended to work older Unity versions, please upgrade to the correct version! Features will not work as intended!");
#endif
    }
#endif
    public bool ActivateOnLoad = false;
#if UDONSHARP
    public void Start()
    {
        Active = ActivateOnLoad;
    }

    public override void Interact()
    {
        Active = !Active;
    }
#endif

    int activeShaderProperty = -1;
    public bool Active
    {
        set
        {
            _Active = value;
            if (activeShaderProperty < 0)
            {
                activeShaderProperty = VRCShader.PropertyToID("_Udon_CombatLink_Active");
            }
            VRCShader.SetGlobalFloat(activeShaderProperty, _Active ? 1 : 0);
        }
        get
        {
            return _Active;
        }
    }
    bool _Active;

    int aPVPShaderProperty = -1;
    public bool APVP
    {
        set
        {
            _APVP = value;
            if (aPVPShaderProperty < 0)
            {
                aPVPShaderProperty = VRCShader.PropertyToID("_Udon_CombatLink_APVPMode");
            }
            VRCShader.SetGlobalFloat(aPVPShaderProperty, _APVP ? 1 : 0);
        }
        get
        {
            return _APVP;
        }
    }
    bool _APVP;

    // CombatLink_GetMainData()
    int healthShaderProperty = -1;
    public float Health
    {
        set
        {
            _Health = value;
            if (healthShaderProperty < 0)
            {
                healthShaderProperty = VRCShader.PropertyToID("_Udon_CombatLink_Health");
            }
            VRCShader.SetGlobalFloat(healthShaderProperty, _Health);
        }
        get
        {
            return _Health;
        }
    }
    float _Health = 100;

    int maxHealthShaderProperty = -1;
    public float MaxHealth
    {
        set
        {
            _MaxHealth = value;
            if (maxHealthShaderProperty < 0)
            {
                maxHealthShaderProperty = VRCShader.PropertyToID("_Udon_CombatLink_MaxHealth");
            }
            VRCShader.SetGlobalFloat(maxHealthShaderProperty, _MaxHealth);
        }
        get
        {
            return _MaxHealth;
        }
    }
    float _MaxHealth = 100;

    int auxHealthShaderProperty = -1;
    public float AuxHealth
    {
        set
        {
            _AuxHealth = value;
            if (auxHealthShaderProperty < 0)
            {
                auxHealthShaderProperty = VRCShader.PropertyToID("_Udon_CombatLink_AuxHealth");
            }
            VRCShader.SetGlobalFloat(auxHealthShaderProperty, _AuxHealth);
        }
        get
        {
            return _AuxHealth;
        }
    }
    float _AuxHealth = 100;

    int maxAuxHealthShaderProperty = -1;
    public float MaxAuxHealth
    {
        set
        {
            _MaxAuxHealth = value;
            if (maxAuxHealthShaderProperty < 0)
            {
                maxAuxHealthShaderProperty = VRCShader.PropertyToID("_Udon_CombatLink_MaxAuxHealth");
            }
            VRCShader.SetGlobalFloat(maxAuxHealthShaderProperty, _MaxAuxHealth);
        }
        get
        {
            return _MaxAuxHealth;
        }
    }
    float _MaxAuxHealth = 100;

    int oxygenShaderProperty = -1;
    public float Oxygen
    {
        set
        {
            _Oxygen = value;
            if (oxygenShaderProperty < 0)
            {
                oxygenShaderProperty = VRCShader.PropertyToID("_Udon_CombatLink_Oxygen");
            }
            VRCShader.SetGlobalFloat(oxygenShaderProperty, _Oxygen);
        }
        get
        {
            return _Oxygen;
        }
    }
    float _Oxygen = 100;

    int maxOxygenShaderProperty = -1;
    public float MaxOxygen
    {
        set
        {
            _MaxOxygen = value;
            if (maxOxygenShaderProperty < 0)
            {
                maxOxygenShaderProperty = VRCShader.PropertyToID("_Udon_CombatLink_MaxOxygen");
            }
            VRCShader.SetGlobalFloat(maxOxygenShaderProperty, _MaxOxygen);
        }
        get
        {
            return _MaxOxygen;
        }
    }
    float _MaxOxygen = 100;

    public float DefaultTemperature
    {
        get { return 293; }
        set { }
    }

    int temperatureShaderProperty = -1;
    public float Temperature
    {
        set
        {
            _Temperature = Mathf.Max(value, 0);
            if (temperatureShaderProperty < 0)
            {
                temperatureShaderProperty = VRCShader.PropertyToID("_Udon_CombatLink_Temperature");
            }
            VRCShader.SetGlobalFloat(temperatureShaderProperty, _Temperature);
        }
        get
        {
            return _Temperature;
        }
    }

    float _Temperature = 293;

    // CombatLink_GetDamageStatusData()

    int bleedShaderProperty = -1;
    public float Bleed
    {
        set
        {
            _Bleed = Mathf.Max(value, 0);
            if (bleedShaderProperty < 0)
            {
                bleedShaderProperty = VRCShader.PropertyToID("_Udon_CombatLink_Bleed");
            }
            VRCShader.SetGlobalFloat(bleedShaderProperty, _Bleed);
        }
        get
        {
            return _Bleed;
        }
    }

    float _Bleed = 0;

    int burnShaderProperty = -1;
    public float Burn
    {
        set
        {
            _Burn = Mathf.Max(value, 0);
            if (burnShaderProperty < 0)
            {
                burnShaderProperty = VRCShader.PropertyToID("_Udon_CombatLink_Burn");
            }
            VRCShader.SetGlobalFloat(burnShaderProperty, _Burn);
        }
        get
        {
            return _Burn;
        }
    }

    float _Burn = 0;

    int poisonShaderProperty = -1;
    public float Poison
    {
        set
        {
            _Poison = Mathf.Max(value, 0);
            if (poisonShaderProperty < 0)
            {
                poisonShaderProperty = VRCShader.PropertyToID("_Udon_CombatLink_Poison");
            }
            VRCShader.SetGlobalFloat(poisonShaderProperty, _Poison);
        }
        get
        {
            return _Poison;
        }
    }

    float _Poison = 0;

    int frostShaderProperty = -1;
    public float Frost
    {
        set
        {
            _Frost = Mathf.Max(value, 0);
            if (frostShaderProperty < 0)
            {
                frostShaderProperty = VRCShader.PropertyToID("_Udon_CombatLink_Frost");
            }
            VRCShader.SetGlobalFloat(frostShaderProperty, _Frost);
        }
        get
        {
            return _Frost;
        }
    }

    float _Frost = 0;

    // CombatLink_GetStatusData()

    int boostShaderProperty = -1;
    public float Boost
    {
        set
        {
            _Boost = Mathf.Max(value, 0);
            if (boostShaderProperty < 0)
            {
                boostShaderProperty = VRCShader.PropertyToID("_Udon_CombatLink_Boost");
            }
            VRCShader.SetGlobalFloat(boostShaderProperty, _Boost);
        }
        get
        {
            return _Boost;
        }
    }

    float _Boost = 0;

    int slowShaderProperty = -1;
    public float Slow
    {
        set
        {
            _Slow = Mathf.Max(value, 0);
            if (slowShaderProperty < 0)
            {
                slowShaderProperty = VRCShader.PropertyToID("_Udon_CombatLink_Slow");
            }
            VRCShader.SetGlobalFloat(slowShaderProperty, _Slow);
        }
        get
        {
            return _Slow;
        }
    }

    float _Slow = 0;

    int stunShaderProperty = -1;
    public float Stun
    {
        set
        {
            _Stun = Mathf.Max(value, 0);
            if (stunShaderProperty < 0)
            {
                stunShaderProperty = VRCShader.PropertyToID("_Udon_CombatLink_Stun");
            }
            VRCShader.SetGlobalFloat(stunShaderProperty, _Stun);
        }
        get
        {
            return _Stun;
        }
    }

    float _Stun = 0;

    int healingShaderProperty = -1;
    public float Healing
    {
        set
        {
            _Healing = Mathf.Max(value, 0);
            if (healingShaderProperty < 0)
            {
                healingShaderProperty = VRCShader.PropertyToID("_Udon_CombatLink_Healing");
            }
            VRCShader.SetGlobalFloat(healingShaderProperty, _Healing);
        }
        get
        {
            return _Healing;
        }
    }

    float _Healing = 0;

    // Minimap interface
    int hasMinimapShaderProperty = -1;
    public bool HasMinimap
    {
        set
        {
            _HasMinimap = value;
            if (hasMinimapShaderProperty < 0)
            {
                hasMinimapShaderProperty = VRCShader.PropertyToID("_Udon_CombatLink_HasMinimap");
            }
            VRCShader.SetGlobalFloat(hasMinimapShaderProperty, _HasMinimap ? 1 : 0);
        }
        get
        {
            return _HasMinimap;
        }
    }
    bool _HasMinimap;

    int minimapScaleShaderProperty = -1;
    public float MinimapScale
    {
        set
        {
            _MinimapScale = Mathf.Max(value, 0);
            if (minimapScaleShaderProperty < 0)
            {
                minimapScaleShaderProperty = VRCShader.PropertyToID("_Udon_CombatLink_MinimapScale");
            }
            VRCShader.SetGlobalFloat(minimapScaleShaderProperty, _MinimapScale);
        }
        get
        {
            return _MinimapScale;
        }
    }

    float _MinimapScale = 0;

    int minimapShaderProperty = -1;
    public Texture2D Minimap
    {
        set
        {
            _Minimap = value;
            if (minimapShaderProperty < 0)
            {
                minimapShaderProperty = VRCShader.PropertyToID("_Udon_CombatLink_Minimap");
            }
            VRCShader.SetGlobalTexture(minimapShaderProperty, _Minimap);
        }
        get
        {
            return _Minimap;
        }
    }
    Texture2D _Minimap;

    int minimapDotOnlyShaderProperty = -1;
    public Texture2D MinimapDotOnly
    {
        set
        {
            _MinimapDotOnly = value;
            if (minimapDotOnlyShaderProperty < 0)
            {
                minimapDotOnlyShaderProperty = VRCShader.PropertyToID("_Udon_CombatLink_MinimapDotOnly");
            }
            VRCShader.SetGlobalTexture(minimapDotOnlyShaderProperty, _MinimapDotOnly);
        }
        get
        {
            return _MinimapDotOnly;
        }
    }
    Texture2D _MinimapDotOnly;

    // Ammo
    int worldAmmoOverrideShaderProperty = -1;
    public bool WorldAmmoOverride
    {
        set
        {
            _WorldAmmoOverride = value;
            if (worldAmmoOverrideShaderProperty < 0)
            {
                worldAmmoOverrideShaderProperty = VRCShader.PropertyToID("_Udon_CombatLink_WorldAmmoOverride");
            }
            VRCShader.SetGlobalFloat(worldAmmoOverrideShaderProperty, _WorldAmmoOverride ? 1 : 0);
        }
        get
        {
            return _WorldAmmoOverride;
        }
    }
    bool _WorldAmmoOverride;

    int ammoShaderProperty = -1;
    public float Ammo
    {
        set
        {
            _Ammo = value;
            if (ammoShaderProperty < 0)
            {
                ammoShaderProperty = VRCShader.PropertyToID("_Udon_CombatLink_Ammo");
            }
            VRCShader.SetGlobalFloat(ammoShaderProperty, _Ammo);
        }
        get
        {
            return _Ammo;
        }
    }
    float _Ammo = 0;

    int ammo2ShaderProperty = -1;
    public float Ammo2
    {
        set
        {
            _Ammo2 = value;
            if (ammo2ShaderProperty < 0)
            {
                ammo2ShaderProperty = VRCShader.PropertyToID("_Udon_CombatLink_Ammo2");
            }
            VRCShader.SetGlobalFloat(ammo2ShaderProperty, _Ammo2);
        }
        get
        {
            return _Ammo2;
        }
    }
    float _Ammo2 = 0;
}
