using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestCombatLink : MonoBehaviour
{
    public Texture2D MiniMapTexture;
    public Texture2D MiniMapTextureDot;

    [ContextMenu("SetRandomValues")]
    public void SetRandomValues()
    {
        
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_SendHelp"), Random.value);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Health"), Random.value*100);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_MaxHealth"), 100);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_AuxHealth"), Random.value * 100);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_MaxAuxHealth"), 100);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Oxygen"), Random.value * 100);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_MaxOxygen"), 100);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Temperature"), Random.value * 566);


        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Bleed"), Random.value - 0.5f);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Burn"), Random.value - 0.5f);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Poison"), Random.value - 0.5f);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Frost"), Random.value - 0.5f);

        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Boost"), Random.value - 0.5f);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Slow"), Random.value - 0.5f);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Stun"), Random.value - 0.5f);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Healing"), Random.value - 0.5f);

        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_HasMinimap"), 1);
        Shader.SetGlobalTexture(Shader.PropertyToID("_Udon_CombatLink_Minimap"), MiniMapTexture);
        Shader.SetGlobalTexture(Shader.PropertyToID("_Udon_CombatLink_MinimapDotOnly"), MiniMapTextureDot);
    }
    [ContextMenu("SetDefaultValues")]
    public void SetDefaultValues()
    {

        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_SendHelp"), Random.value);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Health"), 100);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_MaxHealth"), 100);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_AuxHealth"), 0);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_MaxAuxHealth"), 100);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Oxygen"), 100);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_MaxOxygen"), 100);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Temperature"), 293);

        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Bleed"), 0);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Burn"), 0);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Poison"), 0);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Frost"), 0);

        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Boost"), 0);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Slow"), 0);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Stun"), 0);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Healing"), 0);

        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_HasMinimap"), 0);
        Shader.SetGlobalTexture(Shader.PropertyToID("_Udon_CombatLink_Minimap"), Texture2D.blackTexture);
        Shader.SetGlobalTexture(Shader.PropertyToID("_Udon_CombatLink_MinimapDotOnly"), Texture2D.blackTexture);

    }
    [ContextMenu("SetFlatlineValues")]
    public void SetFlatlineValues()
    {

        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_SendHelp"), Random.value);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Health"), 0);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_MaxHealth"), 100);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_AuxHealth"), 0);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_MaxAuxHealth"), 100);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Oxygen"), 0);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_MaxOxygen"), 100);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Temperature"), 0);

        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Bleed"), 0);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Burn"), 0);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Poison"), 0);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Frost"), 0);

        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Boost"), 0);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Slow"), 0);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Stun"), 0);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Healing"), 0);

        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_HasMinimap"), 0);
        Shader.SetGlobalTexture(Shader.PropertyToID("_Udon_CombatLink_Minimap"), Texture2D.blackTexture);
        Shader.SetGlobalTexture(Shader.PropertyToID("_Udon_CombatLink_MinimapDotOnly"), Texture2D.blackTexture);

    }
    [ContextMenu("SetDEBUGValues")]
    public void SetDEBUGValues()
    {

        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_SendHelp"), Random.value);

        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Health"), 75);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_AuxHealth"), 25);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Oxygen"), 50);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Temperature"), 293/2);

        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Bleed"), 1);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Burn"), 1);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Poison"), 1);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Frost"), 1);


        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Boost"), 1);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Slow"), 1);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Stun"), 1);
        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Healing"), 1);

        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_HasMinimap"), 1);
        Shader.SetGlobalTexture(Shader.PropertyToID("_Udon_CombatLink_Minimap"), MiniMapTexture);
        Shader.SetGlobalTexture(Shader.PropertyToID("_Udon_CombatLink_MinimapDotOnly"), MiniMapTextureDot);

    }

    [ContextMenu("EnableCombatLink")]
    public void EnableCombatLink()
    {

        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Active"), 1);
    }
    [ContextMenu("DisableCombatLink")]
    public void DisableCombatLink()
    {

        Shader.SetGlobalFloat(Shader.PropertyToID("_Udon_CombatLink_Active"), 0);
    }
}
