//////////////////////////////////////
//      THE FLAMETHROWER      //
//   Sprites by VriskaSerket  	//
///////////////////////////////////

class MO_Flamethrower : MO_Weapon
{
	bool altFlameMode;

	const FreezeMode = 1;

	action void MO_SetFlamerMode(bool b = false)
	{
		invoker.altFlameMode = b;
	}

	action bool MO_GetFlamerMode()
	{
		return invoker.altFlameMode;
	}

	action void MO_AttachFlamerLightDef(string flight, string ilight)
	{
		if(MO_GetFlamerMode() == FreezeMode)
			A_AttachLightDef('GunLighting', ilight);
		else
			A_AttachLightDef('GunLighting', flight);
	}	

	action void MO_DepleteFuel()
	{
		if (!invoker.DepleteAmmo(invoker.bAltFire, true))
		{
			return;
		}
	}

	action void MO_PlayFlamerRaiseSound()
	{
		if(MO_GetFlamerMode() == FreezeMode)
			{A_StartSound("Weapons/flamer/icedraw",0);}
			else{	A_StartSound("weapons/flamer/draw", 0);}
	}

    Default
    {
       Weapon.AmmoUse1 2;
       Weapon.AmmoGive1 50;
		Weapon.SelectionOrder 3000;
        Weapon.AmmoType1 "MO_Fuel";
        Inventory.PickupSound "weapons/flamer/pickup";
        Inventory.PickupMessage "$GOTFLAMER";
		Tag "$TAG_FLAMER";
        +FLOORCLIP;
		+WEAPON.NOALERT
		+WEAPON.NOAUTOFIRE
		+WEAPON.AMMO_OPTIONAL
		-WEAPON.MELEEWEAPON
		Scale 0.42;
		Obituary "%o was burnt to a crisp by %k's Flamethrower.";
    }
    States
    {

    ReadyToFire:
		FLMG A 0 A_JumpIf(PressingFire(), "Fire");
        F1MG A 1 JM_WeaponReady();
        Loop;

    Deselect:
		TNT1 A 0 A_SetCrosshair(invoker.GetXHair(16));
        FLMS DCBA 1;
		TNT1 A 0 A_Lower(12);
        Wait;
    Select:
        TNT1 A 0;
		TNT1 A 0 A_SetCrosshair(invoker.GetXHair(16));
    ContinueSelect:
		TNT1 A 0 MO_Raise();
	Ready:
	SelectAnimation:
        TNT1 A 0 MO_PlayFlamerRaiseSound();
        FLMS ABCD 1;
		Goto ReadyToFire;

    Fire:
        F1MG A 1 A_WeaponOffset(0,34);
        F1MG A 1 
		{
			A_OverlayPivot(PSP_WEAPON, 0.08, flags: WOF_KEEPY);
			A_OverlayPivotAlign(PSP_WEAPON, PSPA_CENTER, PSPA_BOTTOM);
			A_WeaponOffset(-1,37);
			A_OverlayScale(PSP_WEAPON, 1.03, 0);
		}
		FLMG A 0
		{
			if(waterlevel > 1 || invoker.Ammo1.amount < 2) {return ResolveState("DontFire");}
			return ResolveState(null);
		}
        TNT1 A 0 {
			if(MO_GetFlamerMode() == FreezeMode)
				{A_StartSound("Weapons/flamer/startice", 2);}
			else
			{A_StartSound("Weapons/flamer/startfire", 2);}
		}
        F1MG A 1 {
			A_AlertMonsters();
            A_WeaponOffset(-2,38);
			A_OverlayScale(PSP_WEAPON, 1.06, 0);
        }
        F1MG A 1 
		{
			A_OverlayScale(PSP_WEAPON, 1.09, 0);
			A_WeaponOffset(-3,40);
		}
        F1MG A 1 
		{
			A_OverlayScale(PSP_WEAPON, 1.14, 0);
			A_WeaponOffset(-5,44);
		}
        F1MG A 1 A_WeaponOffset(-6,45);
		FLMG A 0 JM_CheckForQuadDamage();
		FLMG A 0 A_JumpIf(MO_GetFlamerMode() == FreezeMode, "FireIceThrower");
		TNT1 A 0 A_StartSound("weapons/flamer/flameon",7, CHANF_DEFAULT, 0.6);
        TNT1 A 0 A_StartSound("weapons/flamer/fireloop", 1, CHANF_LOOPING);
	HoldingFire:
		FLMG A 0 A_JumpIf(waterlevel > 1 || invoker.Ammo1.amount < 2, "StopFire");
		FLMG A 0 A_GunFlash();
        FTF1 ABCD 1 {
            A_WeaponOffset(random(-6,0), random(45, 49));
            A_FireProjectile("FlamethrowerAttack",0,false,0,4);
			JM_GunRecoil(-.1,0);
			invoker.CheckAmmo(PrimaryFire, true);
			if(waterlevel > 1 || invoker.Ammo1.amount < 2) {return ResolveState("StopFire");}
			return ResolveState(null);
		}
	
		TNT1 A 0 MO_DepleteFuel();
        SAWG B 0 A_JumpIf(PressingFire(), "HoldingFire");
	StopFire:
		FLMG A 0 A_StopSound(1);
		FLMG A 0 A_StopSound(7);
		FLMG A 0 A_StartSound("weapons/flamer/end",1);
	StopAnimation:
        F1MG A 1 {A_WeaponOffset(-5,42); A_OverlayScale(PSP_WEAPON, 1.11, 0);}
        F1MG A 1  {A_WeaponOffset(-4,38); A_OverlayScale(PSP_WEAPON, 1.09, 0);}
        F1MG A 1 {A_WeaponOffset(-3,36); A_OverlayScale(PSP_WEAPON, 1.06, 0);}
        F1MG A 1 {A_WeaponOffset(-2,33); A_OverlayScale(PSP_WEAPON, 1.03, 0);}
		F1MG A 1 {A_WeaponOffset(0,32); A_OverlayScale(PSP_WEAPON, 1.00, 0);}
        Goto ReadyToFire;
	DontFire:
		 TNT1 A 0 A_StartSound("Weapons/flamer/inwater", 2);
		 F1MG A 1 A_WeaponOffset(0,42);
		 F1MG A 1 A_WeaponOffset(0,46);
         F1MG A 1  A_WeaponOffset(0,41);
         F1MG A 1 A_WeaponOffset(0,38);
		Goto StopAnimation;
	
	FireIcethrower:
		TNT1 A 0 A_StartSound("Weapons/flamer/fireicebegin", 7);
        TNT1 A 0 A_StartSound("weapons/flamer/iceloop", 1, CHANF_LOOPING);
		TNT1 A 0 A_StartSound("weapons/flamer/icelooplayer", 6, CHANF_LOOPING,0.2);
	HoldingFireIce:
		FLMG A 0 A_JumpIf(waterlevel > 1 || invoker.Ammo1.amount < 2, "StopFireIce");
		FLMG A 0 A_GunFlash();
        FTF2 ABCD 1 {
            A_WeaponOffset(random(-6,0), random(45, 49));
            A_FireProjectile("IcethrowerAttack",0,false,0,4);
			JM_GunRecoil(-.1,0);
			if(waterlevel > 1 || invoker.Ammo1.amount < 2) {return ResolveState("StopFireIce");}
			return ResolveState(null);
			}
		TNT1 A 0 MO_DepleteFuel();
        SAWG B 0 A_JumpIf(PressingFire(), "HoldingFireIce");
	StopFireIce:
		SAWG A 0 A_StopSound(1);
		SAWG A 0 A_StopSound(6);
		SAWG A 0 A_StartSound("weapons/flamer/end",1,chanf_default, 0.7);
		SAWG A 0 A_StartSound("weapons/flamer/iceend",3);
		Goto StopAnimation;
		
	ActionSpecial:
		FLMG A 0 A_StartSound("weapons/flamer/special1",CHAN_AUTO);
		FLMK ABCD 1;
		FLMG A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
		FLMK EF 1;
		FLMG A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
		FLMK F 1 A_WeaponOffset(-2, 34);
		FLMK F 1 A_WeaponOffset(-5, 37);
		FLMK F 25 {
			A_WeaponOffset(-8, 40);
			IF(CountInv("MO_PowerSpeed") == 1) {A_SetTics(12);}
		}
		FLMK F 1 A_WeaponOffset(-11, 43);
		FLMG A 0 A_StartSound("weapons/flamer/special2",CHAN_AUTO);
		FLMK F 1 A_WeaponOffset(-15, 47);
		FLMK F 1 A_WeaponOffset(-18, 50);
		FLMG A 0 
		{
			if(MO_GetFlamerMode() != FreezeMode)
			{
				A_StartSound("weapons/flamer/icemodeactive",CHAN_AUTO);
				MO_SetFlamerMode(FreezeMode);
				A_Print("Freeze mode activated");
			}
			else
			{
				A_StartSound("weapons/flamer/firemodeactive",CHAN_AUTO);
				MO_SetFlamerMode();
				A_Print("Flame mode activated");
			}
		}
		FLMK F 1 A_WeaponOffset(-22, 54);
		FLMK F 1 A_WeaponOffset(-25, 57);
		FLMK F 1 A_WeaponOffset(-22, 54);
		FLMK F 8 	
		{
			A_WeaponOffset(-8, 40);
			IF(CountInv("MO_PowerSpeed") == 1) {A_SetTics(4);}
		}
		FLMK F 1 A_WeaponOffset(-15, 45);
		FLMG A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
		FLMK E 1 A_WeaponOffset(-7, 40);
		FLMK D 1 A_WeaponOffset(-4, 36);
		FLMG A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
		FLMK CBA 1 A_WeaponOffset(0,32);
		FLMG A 0 A_SetInventory("SpecialAction",0);
		Goto ReadyToFire;

	Flash:
		TNT1 A 4 BRIGHT MO_AttachFlamerLightDef('GunFireLight', 'FreezethrowerLight'); 
		TNT1 A 0 A_RemoveLight('GunLighting');
		Stop;
		
    Spawn:
        F1MC A -1;
        Stop;
	FlashKick:
		"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,"FlashKickFast");
		FLMK ABCDEFFFFFEDCBA 1;
		Goto ReadyToFire;
	FlashKickFast:
		FLMK ABCDEFFFEDCBA 1;
		Goto ReadyToFire;
	FlashAirKick:
		"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,"FlashAirKickFast");
		FLMK ABCDEFFFFFFFEDCBA 1;
		Goto ReadyToFire;
	FlashAirKickFast:
		FLMK ABCDEFFFFFFEDCBA 1;
		Goto ReadyToFire;
    } 
}
		 
//Based on PB's Flamethrower missile
Class FlamethrowerAttack : Actor
{
    default {
		Radius 12;
		Height 8;
		Speed 20;
		DamageFunction (random(24, 28));
		+NOBLOCKMAP;
		+NOTELEPORT;
		+DONTSPLASH;
		+MISSILE;
		+FORCEXYBILLBOARD;
		+Randomize;
		-RIPPER;
		+NOBLOOD;
		+NOBLOODDECALS;
		+BLOODLESSIMPACT;
		-BLOODSPLATTER;
		Obituary "$OB_FLAMER";
//		+HitMaster;
		RenderStyle "Add";
		DamageType "Fire";
		Scale 0.1;
		Gravity 0;
	}
	States {
		Spawn:
			TNT1 A 0;
			DB55 ABCDE 1 BRIGHT A_SetScale(frandom(0.02, 0.08),frandom(0.02, 0.08));
			DB55 FGH 1 BRIGHT A_SetScale(Scale.X+0.1, Scale.Y+0.1);
			DB55 IJKLMNOPQRSTUVWXYZ 1 BRIGHT {
				A_SetScale(Scale.X+0.04, Scale.Y+0.04);
				A_Explode(1, 85, 0);
			}
			TNT1 A 0 A_SpawnItemEx("FlamerAttackExplosion",0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			Stop;
		Death:
			TNT1 A 0 A_Explode(8, 150, 0);
			TNT1 A 0 A_CheckFloor(1);
			TNT1 A 0 A_SpawnItemEx("GroundFlameSpawner",random (-25, 25), random (-15, 15),0,5);
			TNT1 A 0 A_SpawnItemEx("FlamerAttackExplosion",0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			Stop;
    }
}

Class IceThrowerAttack : FlamethrowerAttack
{
	Default
	{
		DamageType "Ice";
		Translation "CryoBlue"; //New Translation to fix an issue with Legion of Bones' custom PLAYPAL palette, see TRNSLATE
		Decal "FreezeScorch";
		RenderStyle "Add";
		Alpha 0.8;
		Scale 0.1;
		Gravity 0;
		Obituary "$OB_ICEFLAMER";
	}
	States
	{
		Spawn:
			TNT1 A 0;
			DB55 ABCDE 1 BRIGHT A_SetScale(frandom(0.02, 0.08),frandom(0.02, 0.08));
			DB55 FGH 1 BRIGHT 
			{
				A_SetScale(Scale.X+0.1, Scale.Y+0.1);
				A_SpawnProjectile ("IceThrowerSnowFlakes", 1, 0, random (0, 360), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 360));
			}
			DB55 IJKLMN 1  BRIGHT {
				A_SetScale(Scale.X+0.04, Scale.Y+0.04);
				A_Explode(1, 85, 0);
			}
			DB55 OPQ 1 BRIGHT {
				A_SetScale(Scale.X+0.04, Scale.Y+0.04);
				A_Explode(1, 85, 0);
				A_SpawnProjectile ("IceThrowerSnowFlakes", 1, 0, random (0, 360), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 360));
			}
			DB55 STUVWXYZ 1 BRIGHT {
				A_SetScale(Scale.X+0.04, Scale.Y+0.04);
				A_Explode(1, 85, 0);
			}
			TNT1 A 0 A_SpawnItemEx("IcethrowerAttackExplosion",0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);

		Death:
			TNT1 A 0 A_Explode(8, 150, 0);
			TNT1 A 0 A_SpawnItemEx("IcicleSpawner",0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			TNT1 A 1 A_SpawnItemEx("IcethrowerAttackExplosion",0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			Stop;
	}
}