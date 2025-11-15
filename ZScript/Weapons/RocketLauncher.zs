//Rawket Lawnchair
class MiniNukeMode :  Inventory {Default{Inventory.MaxAmount 1;}}

class MO_RocketLauncher : MO_Weapon replaces RocketLauncher
{
	
	int burstCount;
	const maxBurst = 3;

	action void MO_CountRLBurst()
	{
		invoker.burstCount++;
	}

	action void MO_ResetRLBurstCount()
	{
		invoker.burstCount = 0;
	}

	 action int MO_GetBurstCount()
	{
		return invoker.burstCount;
	}

	action void MO_FireRocket()
	{		
		A_StartSound("weapons/rocket/fire", 1);
        A_Overlay(-5, "MuzzleFlash");
		JM_CheckForQuadDamage();
		A_FireProjectile("MO_Rocket",0,true,0,0,0);
	}

    Default
	{
		Weapon.AmmoUse 1;
		Weapon.SelectionOrder 2500;
		Weapon.AmmoGive 5;
		Weapon.AmmoType "MO_RocketAmmo";
		+WEAPON.NOAUTOFIRE
		Inventory.PickupMessage "You got the Rocket Launcher (Slot 5)!";
		Tag "$TAG_RLAUNCHER";
        Inventory.PickupSound "weapons/rocket/draw";
		Obituary "$OB_MOROCKETSPLASH";
	}

    States
    {
        Spawn:
            LAUN A -1;
            Stop;
       
        SelectAnimation:
            TNT1 A 0 A_StartSound("weapons/rocket/draw", 0);
            RLAS A 1;
			RNAS A 0 A_JumpIfInventory("MiniNukeMode",1,2);
			RLAS A 0;
			"####" BCDEF 1;
		Ready:
        ReadyToFire:
			RNAS A 0 A_JumpIfInventory("MiniNukeMode",1,2);
			RLAS A 0;
            "####" F 1 JM_WeaponReady;
            Loop;

		Select:
			TNT1 A 0;
			TNT1 A 0 A_SETCROSSHAIR(Invoker.GetXHair(10));
		 ContinueSelect:
			MGNG A 0 MO_Raise();
			Goto SelectAnimation;

		Deselect:
			TNT1 A 0 A_SETCROSSHAIR(Invoker.GetXHair(10));
			RNAS A 0 A_JumpIfInventory("MiniNukeMode",1,2);
			RLAS A 0;
			"####" FEDCB 1;
			RLAS A 1;
			TNT1 A 0 A_lower(12);
			Wait;

        Fire:
			RLAS A 0 A_CheckReload();
            RLAF A 1 BRIGHT MO_FireRocket();
            RLAF BCD 1 BRIGHT JM_GunRecoil(-0.95, .05);
			TNT1 A 0 A_JumpIf(CountInv("MO_RocketAmmo") < 1,2);
			RLAF A 0 A_StartSound("weapons/rocket/loading",6);
			TNT1 AAA 0;
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
		RecoilFrames:
            RLAF E 1;
			RLAF FFG 1 JM_GunRecoil(-0.2, .04);
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			RLAF G 1;
			RLAF H 2 
			{
				A_WeaponOffset(2,36);
				A_OverlayPivot(PSP_WEAPON, 0.15, flags: WOF_KEEPY);
				A_OverlayScale(PSP_WEAPON, 1.06, 0);
				A_OverlayPivotAlign(PSP_WEAPON, PSPA_CENTER, PSPA_BOTTOM);
			}
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			RLAF HHHH 1{
				A_WeaponOffset(1,35);
				JM_GunRecoil(-0.075, +.04);
				A_OverlayScale(PSP_WEAPON, 1.03, 0);
			}
			RLAF H 0
			{
				A_WeaponOffset(0,34);
				A_OverlayScale(PSP_WEAPON, 1, 0);
			}
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			RLAF HHH 1 A_WeaponOffset(0,32);
			RLAF II 1 JM_GunRecoil(+0.45, -.04);
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			RLAF EJ 1 
			{
				JM_GunRecoil(+0.6, -.04);
				A_WeaponOffset(0,32);
			}
			RLAF K 1 JM_GunRecoil(+0.6, -.04);
            RLAS F 6 {
			if(CountInv("MO_powerspeed") == 1)
			{A_SetTics(3);}
			}
			TNT1 A 0 A_Refire();
            Goto REadyToFire;

        AltFire:
			TNT1 A 0 A_JumpIfInventory("MiniNukeMode",1,"NoAltForNuke");
			TNT1 A 0 A_JumpIf(CountInv("MO_RocketAmmo") < 1,"ReadyToFire");
            RLAF A 1 BRIGHT
            {
                A_FireProjectile("MO_Rocket",0,0,0,7,0);
                A_StartSound("weapons/rocket/fire", 1);
				A_Overlay(-5, "MuzzleFlash");
				JM_CheckForQuadDamage();
				MO_CountRLBurst();
				A_TakeInventory("MO_RocketAmmo",1,TIF_NOTAKEINFINITE);
            }
            RLAF B 1 BRIGHT JM_GunRecoil(-0.95, .05);
			TNT1 A 0 A_JumpIf(MO_GetBurstCount() == maxBurst, "BurstDone");
			TNT1 A 0 A_JumpIf(CountInv("MO_RocketAmmo") < 1,"BurstDone");
            RLAF CC 1 JM_GunRecoil(-0.65, .05);
			Loop;
            RLAF A 1 BRIGHT
            {
                A_FireProjectile("MO_Rocket",0,0,0,0,0);
				A_TakeInventory("MO_RocketAmmo",1,TIF_NOTAKEINFINITE);
                A_StartSound("weapons/rocket/fire", 1);
            }
            RLAF B 1 BRIGHT JM_GunRecoil(-0.95, .05);
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
            RLAF CC 1 JM_GunRecoil(-0.65, .05);
			TNT1 A 0 A_JumpIf(CountInv("MO_RocketAmmo") < 1,"BurstDone");
            RLAF A 1 BRIGHT
            {
                A_FireProjectile("MO_Rocket",0,0,0,0,0);
				A_TakeInventory("MO_RocketAmmo",1,TIF_NOTAKEINFINITE);
                A_StartSound("weapons/rocket/fire", 1, starttime: 0.1);
            }
            RLAF B 1 BRIGHT JM_GunRecoil(-0.95, .05);
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
		BurstDone:
			TNT1 A 0 MO_ResetRLBurstCount;
            RLAF CD 1 JM_GunRecoil(-0.95, .05);
			TNT1 A 0 A_JumpIf(CountInv("MO_RocketAmmo") < 1,2);
			RLAF A 0 A_StartSound("weapons/rocket/loading",6);
			TNT1 AAA 0;
			Goto RecoilFrames;
            RLAF E 1;
			RLAF FFG 1 JM_GunRecoil(-0.2, .04);
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			RLAF G 1;
			RLAF H 2 
			{
				A_WeaponOffset(2,36);
				A_OverlayPivot(PSP_WEAPON, 0.15, flags: WOF_KEEPY);
				A_OverlayScale(PSP_WEAPON, 1.06, 0);
				A_OverlayPivotAlign(PSP_WEAPON, PSPA_CENTER, PSPA_BOTTOM);
			}
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			RLAF HHHH 1{
				A_WeaponOffset(1,35);
				JM_GunRecoil(-0.075, +.04);
				A_OverlayScale(PSP_WEAPON, 1.03, 0);
			}
			RLAF H 0
			{
				A_WeaponOffset(0,33);
				A_OverlayScale(PSP_WEAPON, 1, 0);
			}
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			RLAF HHH 1 A_WeaponOffset(0,32);
			RLAF II 1 JM_GunRecoil(+0.6, -.04);
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			RLAF EJ 1 
			{
				JM_GunRecoil(+0.6, -.04);
				A_WeaponOffset(0,32);
			}
			RLAF K 1 JM_GunRecoil(+0.6, -.04);
            RLAS F 6 {
			if(CountInv("MO_powerspeed") == 1)
			{A_SetTics(3);}
			}
			TNT1 A 0 A_JumpIf(PressingAltFire(), "AltFire");
            Goto ReadyToFire;
		NoAltForNuke:
			"####" A 0;// A_Print("You can't do alt fire on nuke mode");
			Goto ReadyTofire;
        MuzzleFlash:
            MUZR ABC 1 BRIGHT A_AttachLightDef('GunLighting', 'GunFireLight');
			MUZR D 1 BRIGHT A_RemoveLight('GunLighting'); 
            Stop;
		MuzzleFlashRapid:
			MUZR ABC 1 BRIGHT A_AttachLightDef('GunLighting', 'GunFireLight');
			TNT1 A 1 A_RemoveLight('GunLighting');
			MUZR ABC 1 BRIGHT A_AttachLightDef('GunLighting', 'GunFireLight');
			TNT1 A 1 A_RemoveLight('GunLighting');
			MUZR ABC 1 BRIGHT A_AttachLightDef('GunLighting', 'GunFireLight');
			MUZR D 1 BRIGHT A_RemoveLight('GunLighting'); 
			Stop;
/*
		ActionSpecial:
			TNT1 A 0 A_JumpIfInventory("MiniNukeMode",1,"ActionBackToNormal");
			RLAS F 1;// A_StartSound("weapons/rocket/special1",0);
			RLAK ABCDEFG 1;
			RLAK G 5;
//			RLAS F 0 A_StartSound("weapons/rocket/special2",0);
			RLAK G 1 A_WeaponOffset(-2,34);
			RLAK G 1 A_WeaponOffset(-4,36);
			RLAK G 1 A_WeaponOffset(-2,34);
			RLAK G 18 A_WeaponOffset(1,32);
			RNAK G 1 A_WeaponOffset(-9,44);
			RNAK G 1 A_WeaponOffset(-5,40);
			RNAK G 8 A_WeaponOffset(0,32);
			TNT1 A 0 A_StartSound("weapons/rocket/draw", 0);
			RNAK FEDCBA 1;
			TNT1 A 0
			{
					A_SetInventory("MiniNukeMode",1);
//					A_Print("Laser Guided/Homing rockets selected");
//					A_StartSound("weapons/rocket/nukemodeact",0);
			}
			Goto ReadyToFire;
			
		ActionBackToNormal:
			RNAS F 1 A_StartSound("weapons/rocket/special1",0);
			RNAK ABCDEFG 1;
			RNAK G 5;
			RNAS F 0 A_StartSound("weapons/rocket/special2",0);
			RNAK G 1 A_WeaponOffset(-2,34);
			RNAK G 1 A_WeaponOffset(-4,36);
			RNAK G 1 A_WeaponOffset(-2,34);
			RNAK G 18 A_WeaponOffset(1,32);
			RNAS F 0 A_StartSound("weapons/rocket/special3",0);
			RNAK G 1 A_WeaponOffset(-3,36);
			RNAK G 1 A_WeaponOffset(-6,40);
			RNAK G 1 A_WeaponOffset(-9,44);
			RNAK G 1 A_WeaponOffset(-12,48);
			RNAK G 3 A_WeaponOffset(-15,52);
			RLAK G 1 A_WeaponOffset(-12,48);
			RLAK G 1 A_WeaponOffset(-9,44);
			RLAK G 1 A_WeaponOffset(-5,40);
			RLAK G 8 A_WeaponOffset(0,32);
			TNT1 A 0 A_StartSound("weapons/rocket/draw", 0);
			RLAK FEDCBA 1;
			TNT1 A 0
			{
					A_SetInventory("MiniNukeMode",0);
					A_Print("Rockets selected");
			}
			Goto ReadyTofire;
		NukeOverlayIdle:
			RNUK A 1;
			Stop;*/
		FlashKick:
			RNAK A 0 A_JumpIfInventory("MiniNukeMode",1,2);
			RLAK A 0;
			"####" ABCDEFG 1;// JM_WeaponReady();
			"####" GGFFEDCBA 1;// JM_WeaponReady();
			Goto ReadyToFire;
		
		FlashAirKick:
			RNAK A 0 A_JumpIfInventory("MiniNukeMode",1,2);
			RLAK A 0;
			"####" ABCDEFG 1;// JM_WeaponReady();
			"####" G 5;
			"####" GGFEDCBA 1;// JM_WeaponReady();
			Goto ReadyToFire;
    }
}

Class MO_Rocket : Rocket// replaces rocket
{
	override string GetObituary (Actor victim, Actor inflictor, Name mod, bool playerattack)
    {
        if(mod == "ExplosiveImpact")
		{
			return "$OB_MOROCKETSPLASH";
		}
        return "$OB_MOROCKET";
    }

    Default
    {
        Speed 40;
        SeeSound "NULLSND";
	    DeathSound "rocket/explosion";
		Scale 0.5;
		DamageFunction (random(50, 70));
		DamageType "Explosive";
		Decal "Scorch";
		Obituary "$OB_MOROCKET";
    }
	States
	{
		Spawn:
			MI5L A 1;
			MI5L A 1 BRIGHT A_StartSound("rocket/flyloop", CHAN_BODY, CHANF_LOOPING, 0.5);
		FlyLoop:
			MI5L ABCD 1 BRIGHT
			{
				if(waterlevel < 1) {
					A_SpawnItemEx("MO_RocketSmokeTrail",-3,0,0,-1,0,0);
				}
			}
            Loop;
		Death:
            TNT1 A 0 A_StopSound(CHAN_7);
			TNT1 A 0 A_StartSound("rocket/explosion");
			TNT1 A 0 A_StartSound("FarExplosion",8);
			TNT1 A 1 A_SpawnItemEx("RocketExplosionFX",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			TNT1 A 0 A_Explode(200, 180, damagetype: "ExplosiveImpact");
			TNT1 A 1;
			Stop;
    }
}