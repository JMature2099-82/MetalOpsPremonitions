//Player class mainly for weapons
class SergeantClassToken : MO_ZSToken{}

//Shortcut Player start item giver because too many Player.StartItem for mulitple classes is unreliable.
class PlayerStartItemGiver : CustomInventory
{
	Default
	{
		Inventory.PickupMessage "$GOTPLACEHOLDER";
		-INVENTORY.INVBAR
		+INVENTORY.UNDROPPABLE
		+INVENTORY.AUTOACTIVATE
		-INVENTORY.ALWAYSPICKUP
		-INVENTORY.UNTOSSABLE
		Inventory.MaxAmount 1;
	}
	States
	{
		Spawn:
		AMMO A -1;
		Stop;

		Pickup: Use:
		TNT1 A 1
		{
			//Ammo start for both classes
			A_SetInventory("MO_Fuel", 100);
			A_SetInventory("MO_LowCaliber",50);
			A_SetInventory("MO_HighCaliber",50);
			A_SetInventory("LeverShottyAmmo",7);
			A_SetInventory("PumpShotgunAmmo", 8);
			A_SetInventory("ARAmmo",31);
			A_SetInventory("HCRAmmo",12);
			A_SetInventory("SMGAmmo",35);
			A_SetInventory("SSGAmmo",2);
			A_SetInventory("PlasmaAmmo",60);
			A_GiveInventory("Katana");
			A_SetInventory("MOLOTOVAMMO",4);
			A_SetInventory("GrenadeAmmo", 4);
			A_SetInventory("FragSelected",1);
			A_SetInventory("HeatBlastFullyCharged",1);
			A_SetInventory("HeatBlastLevel",3);
			A_SetInventory("HeatBlastShotCount", 45);

			//Never used tokens
			A_GiveInventory("NeverUsedLAS");
			A_GiveInventory("NeverUsedPSG");
			A_GiveInventory("NeverUsedSMG");
			A_GiveInventory("NeverUsedHCR");
		}
		Fail;
	}
}

class MO_PlayerBase : DoomPlayer
{
	int specialtimer;
	override Void Tick()
	{
		Super.Tick();
		//Destroy the night vision shader if a new level is started or if player dies.
		If(!FindInventory("MO_PowerLightAmp"))
		{
			Shader.SetEnabled(Player,"NiteVis",false);
		}
	}

	override int DamageMobj(Actor inflictor, Actor source, int damage, Name mod, int flags, double angle)
	{
		PlayerInfo plyr = Self.Player;
		if(plyr.mo.CountInv("MO_PowerInvul") == 1)
		{
			A_StartSound("powerup/invul_damage",3);
		}
		return super.DamageMobj(inflictor, source, damage, mod, flags, angle);
	}

	override void PostBeginPlay()
	{
		//Voodoo Doll Check
		Super.PostBeginPlay();
		if(!player || !player.mo || player.mo != self)
		{
			return;
		}
	}

	override void PlayerThink()
	{
		Super.PlayerThink();
		let mo_wep = MO_Weapon(player.readyweapon);
		if(!mo_wep) return;
		State ActionSpecial = mo_wep.FindState("ActionSpecial");

		if(player.cmd.buttons & BT_USER1 && !(player.oldbuttons & BT_USER1))
		{
			
			State TossThrowable = mo_wep.FindState("TossThrowable");
		
			if(TossThrowable != Null && (player.weaponstate & WF_WEAPONREADY) || (mo_wep && mo_wep.CheckIfInReady()))
			{
				player.SetPSprite(PSP_WEAPON, mo_wep.FindState("TossThrowable"));
			}
		}
		
		if(player.cmd.buttons & BT_USER4 && !(player.oldbuttons & BT_USER4) && ActionSpecial != NULL)
		{
			if (player.weaponstate & WF_WEAPONREADY || (mo_wep && mo_wep.CheckIfInReady()))
			A_SetInventory("SpecialAction",1);
		}
	}

	Default
	{
		Player.AttackZOffset 11; //Attacks should actually hit on the same spot as the crosshair now. Thanks Gemini0! -JM
		Player.WeaponSlot 1, "MO_Chainsword", "Katana";
		Player.WeaponSlot 2, "MO_VengeanceStryker", "MO_Submachinegun";
		Player.WeaponSlot 3, "LeverShotgun", "MO_PumpShotgun", "MO_SSG";
		Player.WeaponSlot 4, "AssaultRifle", "MO_MiniGun", "MO_HeavyRifle";
		Player.WeaponSlot 5, "MO_RocketLauncher";
		Player.WeaponSlot 6, "MO_PlasmaRifle";
		Player.WeaponSlot 7, "MO_BFG9000", "MO_Unmaker";
		Player.WeaponSlot 8, "MO_Flamethrower";
	}
}

class MO_OfficerPlayer : MO_PlayerBase
{
    Default
    {
        Player.StartItem "MO_VengeanceStryker";
		Player.DisplayName "Officer (Pistol Start)";
		Player.CrouchSprite "PLYC";
		Player.StartItem "PistolMagAmmo",18;
		Player.StartItem "PlayerStartItemGiver";
		Player.StartItem "NeverUsedPistol";
    }
}

class MO_SergeantPlayer : MO_PlayerBase
{
	Default
    {
        Player.StartItem "MO_Deagle";
		Player.DisplayName "Sergeant (Deagle Start)";
		Player.CrouchSprite "PLYC";
		Player.WeaponSlot 2, "MO_Deagle", "MO_Submachinegun";
		Player.StartItem "MODeagleAmmo",8;
		Player.StartItem "PlayerStartItemGiver";
		Player.StartItem "NeverUsedPocketCannon";
    }
}