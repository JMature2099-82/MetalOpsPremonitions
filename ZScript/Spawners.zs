class ShotgunDropper : Inventory// replaces Shotgun
{
	Default{+DROPPED}
	States
	{
	 Spawn:
        TNT1 A 0 NoDelay
        {
            If(invoker.bTOSSED) //If a monster drops this, only drop the Lever Shotgun
                { return A_Jump(256, "SpawnLAS", "SpawnPSG"); }
            Else
                { A_SpawnItemEx("ShotgunSpawner", flags:SXF_NOCHECKPOSITION); }
			return resolvestate(null);
        }
		Stop;
		SpawnLAS:
			TNT1 A 0 A_SpawnItemEx("LeverShotgun", flags:SXF_NOCHECKPOSITION);
			Stop;
		SpawnPSG:
			TNT1 A 0 A_SpawnItemEx("MO_Pumpshotgun", flags:SXF_NOCHECKPOSITION); 
			Stop;
   }
}

class ShotgunSpawner : RandomSpawner
{
	Default
    {
		DropItem "LeverShotgun", 255, 4;
		DropItem "MO_Pumpshotgun", 255, 2;
		DropItem "SSGRandomizer", 255,1;
	}
}

//This is not a spawner! This is a randomizer actor for the SSG spawn option.
//If the ssg random spawn on shotgun is off, it would spawn either the 
//lever action or pump shotgun. -JM
class SSGRandomizer : inventory
{
	Default{+Inventory.TOSSED}
	States
	{
		Spawn:
			TNT1 A 0;
			TNT1 A 1
			{
				if(CVar.FindCVar("mo_ssgrandomizer").GetBool() == True)
				{return resolvestate("SpawnSSG");}
				return A_Jump(256, "SpawnPump", "SpawnLever");
			}
		SpawnSSG:
			TNT1 A 0;
			TNT1 A 1 A_Jump(80, "SpawnPump", "SpawnLever");
			TNT1 A 0 A_SpawnItemEx("MO_SSG");
			Stop;
		SpawnPump:
			TNT1 A 0 A_SpawnItemEx("MO_Pumpshotgun");
			Stop;
		SpawnLever:
			TNT1 A 0 A_SpawnItemEx("LeverShotgun");
			Stop;
	}
}

//Based on code from Jarwill and Ac1d
class ChaingunDropper : Inventory// replaces Chaingun
{
	Default{+DROPPED}
	States
	{
	 Spawn:
        TNT1 A 0 NoDelay
        {
            If(invoker.bTOSSED) //If a monster drops this, only drop the Minigun
                { A_SpawnItem("MO_MiniGun"); }
            Else
                { A_SpawnItem("ChaingunSpawner"); }
        }
        Stop;
   }
}

class ChaingunSpawner : RandomSpawner
{
	Default
    {
		DropItem "MO_MiniGun", 255, 4;
		DropItem "AssaultRifle", 255, 2;
		DropItem "MO_HeavyRifle", 255,1;
		DropItem "MO_SubMachinegun",255, 1;
	}
}

class BFGSpawner : RandomSpawner replaces BFG9000
{
	Default
	{
		DropItem "MO_BFG9000", 255, 3;
		DropItem "MO_Unmaker", 255, 1;
	}
}

//Items and Powerups
Class BerserkPackSpawner: RandomSpawner replaces Berserk
{
	Default
	{
		DropItem "MO_Berserk",255,3;
		DropItem "MO_HasteSphere",255,1;
	}
}

Class InvulSphereSpawner : RandomSpawner replaces InvulnerabilitySphere
{
	Default 
	{
		DropItem "MO_Invulnerability",255,3;
		DropItem "MO_QuadDMGSphere",255,1;
	}
}

Class ArmorBonusSpawner : RandomSpawner replaces ArmorBonus
{
	Default
	{
		DropItem "MO_ArmorBonus",255,5;
		DropItem "MO_GeminusArmorBonus",255, 3;
		DropItem "MO_TrebleArmorBonus",255,1;
	}
}


Class HealthBonusSpawner : RandomSpawner replaces HealthBonus
{
	Default
	{
		DropItem "MO_HealthBonus",255,5;
		DropItem "MO_CorruptedHealthBonus",255, 3;
		DropItem "MO_SpiritualHealthBonus",255,1;
	}
}