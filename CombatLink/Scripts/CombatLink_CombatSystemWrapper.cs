
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

public class CombatLink_CombatSystemWrapper : UdonSharpBehaviour
{
    public CombatLinkManager CombatLinkManager;
    [Header("CombatLink variables below!")]
    public bool Active;
    float MaxHealth = 0;
    private void LateUpdate()
    {
        if (CombatLinkManager)
        {
            CombatLinkManager.Active = Active;
            CombatLinkManager.Health = Networking.LocalPlayer.CombatGetCurrentHitpoints();
            if(MaxHealth > CombatLinkManager.Health)
            {
                MaxHealth = CombatLinkManager.Health;
            }
            CombatLinkManager.MaxHealth = MaxHealth;
        }
    }
    private void OnDisable()
    {
        MaxHealth = 0;
    }
}
