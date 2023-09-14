
using UnityEngine;

#if UDONSHARP
using UdonSharp;
using VRC.SDKBase;
using VRC.Udon;
public class CombatLinkGraphWrapper : UdonSharpBehaviour
#else
public class CombatLinkGraphWrapper : MonoBehaviour
#endif
{
    public CombatLinkManager CombatLinkManager;
    [Header("CombatLink variables below!")]
    public bool Active;
    public bool APVP;
    public float Health;
    public float MaxHealth;
    public float AuxHealth;
    public float MaxAuxHealth;
    public float Oxygen;
    public float MaxOxygen;
    public float Temperature;
    public float Bleed;
    public float Burn;
    public float Poison;
    public float Frost;
    public float Boost;
    public float Slow;
    public float Stun;
    public float Healing;
    public bool HasMinimap;
    public float MinimapScale;
    public Texture2D Minimap;
    public Texture2D MinimapDotOnly;
    public bool WorldAmmoOverride;
    public float Ammo;
    public float Ammo2;
    private void LateUpdate()
    {
        if(CombatLinkManager)
        {
            CombatLinkManager.Active = Active;
            CombatLinkManager.APVP = APVP;
            CombatLinkManager.Health = Health;
            CombatLinkManager.MaxHealth = MaxHealth;
            CombatLinkManager.AuxHealth = AuxHealth;
            CombatLinkManager.MaxAuxHealth = MaxAuxHealth;
            CombatLinkManager.Oxygen = Oxygen;
            CombatLinkManager.MaxOxygen = MaxOxygen;
            CombatLinkManager.Temperature = Temperature;
            CombatLinkManager.Bleed = Bleed;
            CombatLinkManager.Burn = Burn;
            CombatLinkManager.Poison = Poison;
            CombatLinkManager.Frost = Frost;
            CombatLinkManager.Boost = Boost;
            CombatLinkManager.Slow = Slow;
            CombatLinkManager.Stun = Stun;
            CombatLinkManager.Healing = Healing;
            CombatLinkManager.HasMinimap = HasMinimap;
            CombatLinkManager.MinimapScale = MinimapScale;
            CombatLinkManager.Minimap = Minimap;
            CombatLinkManager.MinimapDotOnly = MinimapDotOnly;
            CombatLinkManager.WorldAmmoOverride = WorldAmmoOverride;
            CombatLinkManager.Ammo = Ammo;
            CombatLinkManager.Ammo2 = Ammo2;
        }
    }
}
