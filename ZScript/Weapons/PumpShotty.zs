Class AltPumping : MO_ZSToken{}
Class SGPumping: MO_ZSToken{}

class MO_PumpShotgun : JMWeapon
{
    Default
    {
        Weapon.AmmoGive 6;
		Weapon.AmmoUse 0;
		Weapon.SelectionOrder 1400;
        Weapon.AmmoType1 "MO_ShotShell";
        Weapon.AmmoType2 "PumpShotgunAmmo";
        Inventory.PickupMessage "You got the Pump Action Shotgun! (Slot 3)";
        Obituary "%o got blasted away by %k's Pump Shotgun.";
        Tag "Pump Shotgun";
		Inventory.PickupSound "weapons/pumpshot/pump";
		JMWeapon.inspectToken "NeverUsedPSG";
		+Weapon.NoAlert
    }
    States
    {
		Inspect:
			PSGS E 7 JM_WeaponReady();
			PSGM ABCDEF 1 JM_WeaponReady();
			PGR2 A 0 A_StartSound("weapons/pumpshot/pumpBACK", 0);
			PGR2 A 1 JM_WeaponReady();
			PGR2 B 6 JM_WeaponReady();
            PGR2 CCD 1 JM_WeaponReady();
			PGR2 A 0 A_StartSound("weapons/pumpshot/load", 1);
            PGR2 EF 1 JM_WeaponReady();
//			PGR2 A 0 JM_LoadShell("PumpShotgunAmmo","Shell",1);
            PGR2 GHIJKKKKKK 1 JM_WeaponReady();
            PGR2 A 0 A_StartSound("weapons/pumpshot/pumpforward", 0);
            PGR2 KLM 1 JM_WeaponReady();
            PGR2 M 9 JM_WeaponReady();
			PGR2 A 0 A_StartSound("weapons/pumpshot/pumpback", 1);
			PGR2 LKKKKKKK 1 JM_WeaponReady();
			PGR2 L 1 A_StartSound("weapons/pumpshot/pumpforward", 0);
			PGR2 M 6 JM_WeaponReady();
            Goto DoneReload;
        Ready:
		SelectAnimation:
            PSGS A 0 A_StartSound("weapons/pumpshot/draw", CHAN_AUTO);
            PSGS ABCDE 1;
			TNT1 A 0 JM_CheckInspectIfDone;
        ReadyToFire:
            PSGG A 1 
			{
				if(CountInv("SGPumping") >= 1) {SetWeaponState("Pump");}
				if(CountInv("AltPumping") >= 1) {SetWeaponState("AltPump");}
				if(CountInv("PumpShotgunAmmo") == 0 && CountInv("MO_ShotShell") > 1)
				{SetWeaponState("REload");}
				return JM_WeaponReady(WRF_ALLOWRELOAD);
			}
            Loop;
        Deselect:
			PSTG A 0 A_SetCrosshair(invoker.GetXHair(5));
			PSGS EDCBA 1;
            SHTG A 0 A_Lower(12);
            WAIT;
        Select:
            TNT1 A 0;
			TNT1 A 0 A_SetCrosshair(invoker.GetXHair(5));
            Goto ClearAudioAndResetOverlays;
		ContinueSelect:
			TNT1 AAAAAAAAAAAAAAAAAA 0 A_Raise();
			Goto Ready;
        Fire:
            PSTG A 0 MO_CheckMag;
            PSGF A 1 
            {
                A_FireBullets (random(3, 6), frandom(3,7), 20, 6, "ShotgunPuff20GA", FBF_NORANDOM,0,"MO_BulletTracer",0);
                A_StartSound ("weapons/pumpshot/fire", CHAN_WEAPON);
                A_TakeInventory("PumpShotgunAmmo",1, TIF_NOTAKEINFINITE);
				A_GunFlash();
				A_SetInventory("SGPumping",1);
				JM_CheckForQuadDamage();
				A_AlertMonsters();
		    }
            PSGF BC 1 JM_GunRecoil(-1.2,.09);
            PSGF D 1 JM_GunRecoil(0.3,.09);
			PSGF E 1 JM_GunRecoil(0.1,.09);
            PSGG A 4
			{
				if(CountInv("MO_PowerSpeed") == 1) {A_SetTics(2);}
			}
			TNT1 A 0 A_WeaponReady(WRF_NOFIRE);
			TNT1 A 0 MO_CheckMag;
            Goto Pump;
        Pump:
            W87A A 0 SetInventory("SGPumping",1);
            PSGM ABC 1;		
			PSTF A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			PSGM DEFG 1;
            W87A A 0 A_StartSound("weapons/pumpshot/pumpback", 0);
            PSGM H 1
			{
				SetInventory("SGPumping",0);
				MO_EjectCasing("ShotgunCasing20ga", ejectpitch: frandom(-55, -45), speed: frandom(5, 7), accuracy: 5, offset:(28, -8, -14));
			}
			TNT1 A 0 JM_WeaponReady(WRF_NOFIRE); //Quick switch	
			PSTF A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
            PSGM IJKL 1 JM_WeaponReady(WRF_NOFIRE);
			W87A A 0 A_StartSound("weapons/pumpshot/pumpforward", 0);
			PSTF A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			PSGM LKJ 1 JM_WeaponReady(WRF_NOFIRE);
			PSTF A 0 A_JumpIfInventory("MO_PowerSpeed",1,3);
            PSGM IHGFEDCBA 1 JM_WeaponReady(WRF_NOFIRE);
            PSGG A 1 A_JumpIf(PressingFire(), "Fire");
            Goto ReadyToFire;
			
		AltFire:
			PSTG A 0 MO_CheckMag(2);
			TNT1 A 0 A_StartSound ("weapons/pumpshot/fire", CHAN_WEAPON, CHANF_DEFAULT, 0.85);
			TNT1 A 0 A_StartSound("weapons/pumpshot/altfire",CHAN_7);
			PSGF A 1 
            {
                 A_FireBullets (random(4, 8), frandom(3,15), 40, 6, "ShotgunPuff20GA", FBF_NORANDOM,0,"MO_BulletTracer",0);
                A_TakeInventory("PumpShotgunAmmo",2, TIF_NOTAKEINFINITE);
				A_GunFlash();
				JM_CheckForQuadDamage();
				A_SetInventory("AltPumping",1);
				A_AlertMonsters();
		    }
            PSGF B 1 JM_GunRecoil(-2.25,.09);
			PSGF C 1 JM_GunRecoil(-1.6,.09);
			PSGF C 1 JM_GunRecoil(.6,.09);
            PSGF D 3 JM_GunRecoil(.4,.09);
            PSGF E 4;
			PSGG A 1;
			TNT1 A 0 A_WeaponReady(WRF_NOFIRE);
			TNT1 A 0 MO_CheckMag;
            PSGG A 9
			{
				if(CountInv("MO_PowerSpeed") == 1) {A_SetTics(5);}
			}
			TNT1 A 0 A_WeaponReady(WRF_NOFIRE);
            Goto AltPump;
		
		AltPump:
 //           W87A A 0 A_JumpIf(CountInv("LeverShottyAmmo") < 1, "TerminatorLever");
            PSGM ABC 1;		
			PSTF A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			PSGM DEFG 1;
            W87A A 0 A_StartSound("weapons/pumpshot/pumpback", 0);
            PSGM H 1
			{
				SetInventory("AltPumping",0);
				MO_EjectCasing("ShotgunCasing20ga", ejectpitch: frandom(-55, -45), speed: frandom(5, 7), accuracy: 5, offset:(28, -8, -14));
				MO_EjectCasing("ShotgunCasing20ga", ejectpitch: frandom(-55, -45), speed: frandom(5, 7), accuracy: 5, offset:(28, -8, -14));
			}
			TNT1 A 0 JM_WeaponReady(WRF_NOFIRE); //Quick switch	
			PSTF A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
            PSGM IJKL 1 JM_WeaponReady(WRF_NOFIRE);
			W87A A 0 A_StartSound("weapons/pumpshot/pumpforward", 0);
			PSTF A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			PSGM LKJ 1 JM_WeaponReady(WRF_NOFIRE);
			PSTF A 0 A_JumpIfInventory("MO_PowerSpeed",1,3);
            PSGM IHGFEDCBA 1 JM_WeaponReady(WRF_NOFIRE);
            PSGG A 1 A_JumpIf(PressingAltFire(), "AltFire");
            Goto ReadyToFire;
			
        Flash:
			TNT1 A 2 A_AttachLightDef('GunLighting', 'GunFireLight');
			TNT1 A 0 A_RemoveLight('GunLighting');
			Stop;

        Reload:
			PSTG A 0 A_JumpIfInventory("PumpShotgunAmmo",8,"ReadyToFire");
			PSTG A 0 A_JumpIfInventory("MO_ShotShell",1,1);
			goto ReadyToFire;
            PSGM ABCDEF 1;// JM_WeaponReady();
            PSGA A 0 A_JumpIf(CountInv("PumpShotgunAmmo") < 1, "ChamberShell");
			PSTG A 0 A_SetInventory("SGPumping",0);
			PSTG A 0 A_SetInventory("AltPumping",0);
			PSGR AB 1;// JM_WeaponReady();
			PGR1 I 5;
        ShellLoop:
            PSTG A 0 A_JumpIfInventory("PumpShotgunAmmo",8,"DoneReload");           
			TNT1 A 0 A_JumpIfInventory("MO_ShotShell",1,1);
			Goto DoneReload;
            PGR1 AB 1 JM_WeaponReady(WRF_NOFIRE);
            PGR1 C 1 A_StartSound("weapons/pumpshot/load", 1);
            PISG A 0 JM_LoadShell("PumpShotgunAmmo","MO_ShotShell",1);
			PSTF A 0 A_JumpIf(invoker.OwnerHasSpeed(), 3);
            PGR1 DE 1 JM_WeaponReady(WRF_NOFIRE);
			PGR1 FGHII 1 
			{
				if(JustPressed(BT_ATTACK)) {return ResolveState("Fire");}
				if(JustPressed(BT_ALTATTACK)) {return ResolveState("AltFire");}
				return JM_WeaponReady(WRF_NOFIRE);
			}
			PSTG A 0 A_JumpIf(invoker.OwnerHasSpeed(), 2);
            PGR1 IIII 1 {
				if(JustPressed(BT_ATTACK)) {return ResolveState("Fire");}
				if(JustPressed(BT_ALTATTACK)) {return ResolveState("AltFire");}
				return JM_WeaponReady(WRF_NOFIRE);
			}
            PISG A 0
			{
				if(PressingFire()) {return ResolveState("Fire");}
				if(PressingAltFire()) {return ResolveState("AltFire");}
				return JM_WeaponReady(WRF_NOFIRE);
			}
            Loop;
        DoneReload:
            PSGR BA 1;
            PSGM EDCBA 1;
            Goto ReadyToFire;
        ChamberShell:
            TNT1 A 0 A_StartSound("weapons/pumpshot/pumpback", 0);
            PGR2 A 1;
			TNT1 A 0
			{
				if(CountInv("SGPumping") >= 1)
				{
					SetInventory("SGPumping",0);
					MO_EjectCasing("ShotgunCasing20ga", false, frandom(-55, -45), frandom(5, 7), 5, offset:(28, -8, -14));
				}
				else if(CountInv("AltPumping") >= 1)
				{
					SetInventory("AltPumping",0);
					MO_EjectCasing("ShotgunCasing20ga", false, frandom(-55, -45), frandom(5, 7), 5, offset:(28, -8, -14));
					MO_EjectCasing("ShotgunCasing20ga", false, frandom(-55, -45), frandom(5, 7), 5, offset:(28, -8, -14));
				}
			}
			PGR2 B 6 {
				if(CountInv("MO_PowerSpeed") == 1) {A_SetTics(3);}
			}
			PSTF A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
            PGR2 CCD 1;
			PGR2 A 0 A_StartSound("weapons/pumpshot/load", 1);
            PGR2 EF 1;
			PGR2 A 0 JM_LoadShell("PumpShotgunAmmo","MO_ShotShell",1);
			PSTF A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
            PGR2 GHIJ 1;
			PSTF A 0 A_JumpIfInventory("MO_PowerSpeed",1,4);
			PGR2 KKKKKK 1;
            PGR2 A 0 A_StartSound("weapons/pumpshot/pumpforward", 0);
            PGR2 KLM 1;
			PSGG A 0 A_JumpIf(PressingFire(), "DoneReload");
            PGR2 M 9 
			{
				if(CountInv("MO_PowerSpeed") == 1) {A_SetTics(5);}
			}
			PSGG A 0 A_JumpIf(PressingFire(), "DoneReload");
            Goto ShellLoop;
		FlashKick:
		PSGM ABCDEF 1 JM_WeaponReady();
		PSGM F 4;
		PSGM EEDCBA 1;
		Goto ReadyToFire;
	FlashAirKick:
		PSGM ABCDEF 1;
		PSGM F 6;
		PSGM EEDCBA 1;
		Goto ReadyToFire;
        Spawn:
            PSGC A -1;
            Stop;
    }
	
	//This is so that the shell loading of the inventory give and take is in one function for the Shotgun
	action void JM_LoadShell(name type, name reserve, int c)
	{
		A_TakeInventory(reserve, c);
		GiveInventory(type, c);
	}
}

class PumpShotgunAmmo : Ammo
{
	Default
	{
		Inventory.Amount 0;
		Inventory.MaxAmount 8;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount 8;
		Inventory.Icon "PSGCA0";
		+INVENTORY.IGNORESKILL;
	}
}