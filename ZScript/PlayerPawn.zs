//Player class mainly for weapons
class SergeantClassToken : MO_ZSToken{}

class MO_PlayerBase : DoomPlayer
{
	override Void Tick()
	{
		Super.Tick();
		//Destroy the night vision shader if a new level is started or if player dies.
		If(!FindInventory("MO_NightVision"))
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

	int grenadecooktimer;

	Default
	{
		Player.AttackZOffset 11; //Attacks should actually hit on the same spot as the crosshair now. Thanks Gemini0! -JM
		Player.WeaponSlot 1, "Katana";
		Player.WeaponSlot 2, "MO_VengeanceStriker", "MO_Submachinegun";
		Player.WeaponSlot 3, "LeverShotgun", "MO_PumpShotgun", "MO_SSG";
		Player.WeaponSlot 4, "AssaultRifle", "MO_MiniGun", "MO_HeavyRifle";
		Player.WeaponSlot 5, "MO_RocketLauncher";
		Player.WeaponSlot 6, "JM_PlasmaRifle";
		Player.WeaponSlot 7, "MO_BFG9000", "MO_Unmaker";
		Player.WeaponSlot 8, "MO_Flamethrower";
	}
}

class MO_OfficerPlayer : MO_PlayerBase
{
    Default
    {
        Player.StartItem "MO_VengeanceStriker";
		Player.DisplayName "Officer (Pistol Start)";
		Player.CrouchSprite "PLYC";
		Player.StartItem "PistolMagAmmo",18;
		Player.StartItem "MO_Gasoline", 200;
		Player.StartItem "MO_LowCaliber",50;
		Player.StartItem "MO_HighCaliber",50;
		Player.StartItem "LeverShottyAmmo",7;
		Player.StartItem "PumpShotgunAmmo", 8;
		Player.StartItem "ARAmmo",30;
		Player.StartItem "HCRAmmo",12;
		Player.StartItem "SMGAmmo",40;
		Player.StartItem "SSGAmmo",2;
		Player.StartItem "PlasmaAmmo",60;
		Player.StartItem "Katana";
		Player.StartItem "MOLOTOVAMMO",4;
		Player.StartItem "GrenadeAmmo", 4;
		Player.StartItem "FragSelected",1;
		Player.StartItem "HeatBlastFullyCharged";
		Player.StartItem "HeatBlastLevel",3;
		Player.StartItem "HeatBlastShotCount", 45;

		//Never used tokens
		Player.StartItem "NeverUsedPistol";
		Player.StartItem "NeverUsedLAS";
		Player.StartItem "NeverUsedPSG";
		Player.StartItem "NeverUsedSMG";
		Player.StartItem "NeverUsedHCR";
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
		Player.StartItem "SergeantClass", 1;
		Player.StartItem "MODeagleAmmo",7;
		Player.StartItem "MO_Gasoline", 200;
		Player.StartItem "MO_LowCaliber",50;
		Player.StartItem "MO_HighCaliber",50;
		Player.StartItem "LeverShottyAmmo",7;
		Player.StartItem "PumpShotgunAmmo", 8;
		Player.StartItem "ARAmmo",30;
		Player.StartItem "SMGAmmo",40;
		Player.StartItem "SSGAmmo",2;
		Player.StartItem "HCRAmmo",12;
		Player.StartItem "PlasmaAmmo",60;
		Player.StartItem "Katana";
		Player.StartItem "MOLOTOVAMMO",4;
		Player.StartItem "GrenadeAmmo", 4;
		Player.StartItem "FragSelected",1;
		Player.StartItem "HeatBlastFullyCharged";
		Player.StartItem "HeatBlastLevel",3;
		Player.StartItem "HeatBlastShotCount", 45;

		//Never used tokens
		Player.StartItem "NeverUsedLAS";
		Player.StartItem "NeverUsedPSG";
		Player.StartItem "NeverUsedSMG";
		Player.StartItem "NeverUsedHCR";
    }
}