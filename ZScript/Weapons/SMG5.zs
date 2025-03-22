//SMG

Class SMGBurstMode : MO_ZSToken{}

Class MO_SubMachineGun : JMWeapon
{
    Default
    {
        Weapon.AmmoGive 40;
		Weapon.SelectionOrder 1800;
        Weapon.AmmoType1 "MO_LowCaliber";
        Weapon.AmmoType2 "SMGAmmo";
        Inventory.PickupMessage "You got the Submachine Gun (Slot 2)!";
        Obituary "%o got turned into swiss cheese by %k's Submachine Gun.";
        Tag "Submachine Gun";
		Inventory.PickupSound "weapons/smg/pickup";
		JMWeapon.InspectToken "NeverUsedSMG";
		+WEAPON.NOALERT;	
		+WEAPON.NOAUTOFIRE;
		+INVENTORY.TOSSED;
    }

	override void PostBeginPlay()
	{	
			isZoomed = false;
			isHoldingAim = false;
	}

    States
    {
		ContinueSelect:
		TNT1 AAAAAAAAAAAAAAAAAA 0 A_Raise();
		Goto Ready;
		
		Inspect:
			TNT1 A 0 A_StartSound("weapons/smg/inspect1",0);
			SM5I ABCDEFGHI 1 JM_WeaponReady();
			SM5I KMNPRSTVW 1 JM_WeaponReady();
			SM5I WWWXYZZZ 1 JM_WeaponReady();
			TNT1 A 0 A_StartSound("weapons/smg/inspect4",0);
			SM51 ABCDEFG 1;
			TNT1 A 0 A_StartSound("weapons/smg/inspect2",6);
			SM51 HHHHHHHH 1 JM_WeaponReady();
			SM5G A 0 A_StartSound("Weapons/smg/inspect3",7);
			SM51 HHIJKLMMMMLKJI 1 JM_WeaponReady();
			SM51 IIIII 1 JM_WeaponReady();
			TNT1 A 0 A_StartSound("weapons/smg/select",0);
			SM51 NOP 1 JM_WeaponReady();
			Goto ReadyToFire;
        Spawn:
            SUBM A -1;
            STOP;
        Ready:
			TNT1 A 0 JM_CheckInspectIfDone;
		SelectAnimation:
			TNT1 A 0 A_StartSound("weapons/smg/select",0);
            SM5S ABCD 1;
			SMGG A 0 A_JumpIf(invoker.isZoomed, "Zoom");
        ReadyToFire:
            SM5G A 1 
			{
				if(invoker.isZoomed) {
				return ResolveState("Ready2");
				}
				if(PressingAltFire() && invoker.ADSMode >= 1) {
				return ResolveState("AltFire");
				}
				if(JustPressed(BT_ALTATTACK) && invoker.ADSMode < 1) {
				return ResolveState("AltFire");
				}
				if(PressingFire() && invoker.Ammo2.amount > 0) {
				return ResolveState("Fire");
				}
				return JM_WeaponReady(WRF_NOSECONDARY|WRF_ALLOWRELOAD);
			}
            Loop;
        Select:
			TNT1 A 0;
			TNT1 A 0
			{
				invoker.isZoomed = False;
				invoker.isHoldingAim = False;
				A_ZoomFactor(1.0);
				A_SetCrosshair(invoker.GetXHair(3));
			}
			Goto ClearAudioAndResetOverlays;
        Fire:
			TNT1 A 0 MO_CheckMag;
			TNT1 A 0 A_JumpIf(invoker.isZoomed, "Fire2");
            SM5F A 1 BRIGHT {
                A_FireBullets(5.6, 0, 1, 10, "UpdatedBulletPuff",FBF_NORANDOM, 0,"MO_BulletTracer",0);
                A_TakeInventory("SMGAmmo", 1);
                A_StartSound("weapons/smg/fire", 0);
				A_AlertMonsters();
				JM_CheckForQuadDamage();
				A_GunFlash();
            }
            SM5F B 1 BRIGHT 
			{
				JM_GunRecoil(-0.6, .09);
				JM_WeaponReady(WRF_NOFIRE);
				MO_EjectCasing("PistolCasing", false, speed: frandom(4,7), offset: (24, 0, -6));
			}
            SM5F C 1 JM_WeaponReady(WRF_NOPRIMARY);
            AR1F A 0 A_JumpIf(PressingFire(), "Fire");
			TNT1 A 0 MO_CheckMag;
            Goto ReadyToFire;

		Fire2:
			  TNT1 A 0 MO_CheckMag;
			  SM5Z E 1 BRIGHT {
                A_FireBullets(5.6, 0, 1, 10, "UpdatedBulletPuff",FBF_NORANDOM, 0,"MO_BulletTracer",0);
                A_TakeInventory("SMGAmmo", 1);
                A_StartSound("weapons/smg/fire", 0);
				A_AlertMonsters();
				JM_CheckForQuadDamage();
				A_GunFlash();
            }
            SM5Z F 1 BRIGHT 
			{
				JM_GunRecoil(-0.5, .06);
				JM_WeaponReady(WRF_NOFIRE);
				MO_EjectCasing("PistolCasing", false, speed: frandom(4,7), offset: (28, 4, -4));
			}
            SM5Z G 1;
			TNT1 A 0 MO_CheckMag;
            AR1F A 0
			{
				if(invoker.ADSMode >= 1)
				{
					if(PressingAltFire() && PressingFire())
					{
						invoker.isHoldingAim = true;
						return ResolveState("Fire2");
					}
					if(!PressingAltFire() && invoker.isHoldingAim) {
						return ResolveState("UnZoom");
					}
					else
					{if(PressingFire()) {return ResolveState("Fire2");}}
				}
				else
				{A_ReFire("Fire2");}
				return JM_WeaponReady(WRF_NOFIRE|WRF_ALLOWRELOAD);
			}
            Goto Ready2;

		Flash:
			TNT1 A 2 A_AttachLightDef('GunLighting', 'GunFireLight');
			TNT1 A 0 A_RemoveLight('GunLighting');
			Stop;
	
		AltFire:
			TNT1 A 0 A_JumpIf(invoker.isZoomed, "UnZoom");
		Zoom:
			TNT1 A 0 {invoker.isZoomed = true;}
			SMGR A 0 A_StartSound("weapon/adsup",0);
			SMGR A 0 A_ZoomFactor(1.3);
			SMGR A 0 A_SetCrosshair(99);
			SM5Z ABC 1;
		Ready2:
			TNT1 A 0 A_JumpIf(invoker.ADSMode <= 0, "ADSToggle");
			TNT1 A 0 A_JumpIf(invoker.ADSMode == 1, "ADSHold");
			TNT1 A 0 A_JumpIf(PressingFire(), "Fire");
			SM5Z DDDDD 1 
			{
				if(JustPressed(BT_ATTACK)) {return ResolveState("Fire");}
				if(PressingFire() && invoker.Ammo2.amount > 0) {
				return ResolveState("Fire");
				}
				return JM_WeaponReady(WRF_ALLOWRELOAD|WRF_NOFIRE);
			}
			TNT1 A 0 A_JumpIf(invoker.ADSMode == 2 && PressingAltFire() , "ADSHold");

		ADSToggle:
			SM5Z D 1 
			{
				if(JustPressed(BT_ALTATTACK)) {return ResolveState("UnZoom");}
				if(PressingFire() && invoker.Ammo2.amount > 0) {
				return ResolveState("Fire");
				}
				return JM_WeaponReady(WRF_ALLOWRELOAD|WRF_NOSECONDARY);
			}
			Loop;
		//Hold and Hybrid
		ADSHold:
			TNT1 A 0 {invoker.isHoldingAim = true;}
			SM5Z D 1 
			{
				if(!PressingAltFire()) {return ResolveState("UnZoom");}
				if(PressingFire() && invoker.Ammo2.amount > 0) {
				return ResolveState("Fire");
				}
				return JM_WeaponReady(WRF_ALLOWRELOAD|WRF_NOSECONDARY);
			}
			Loop;

	NoAmmoZoomed:
			SM5Z D 1;
			Goto Ready2;

		UnZoom:
			TNT1 A 0 
			{
				invoker.isZoomed = False;
				invoker.isHoldingAim = False;
			}
			SMGR A 0 A_StartSound("weapon/adsdown",0);
			SMGR A 0 A_ZoomFactor(1.0);
			SMGR A 0 A_SetCrosshair(invoker.GetXHair(3));
			SM5Z CBA 1;
			SM5G AAA 3
			{
				if(PressingFire()) {return ResolveState("Fire");}
				return JM_WeaponReady(WRF_ALLOWRELOAD|WRF_NOFIRE);
			}
			TNT1 A 0 A_WeaponReady(WRF_NOSECONDARY);
			Goto ReadyToFire;
			
        Deselect:
			TNT1 A 0
			{
				invoker.isZoomed = False;
				invoker.isHoldingAim = False;
				A_SetCrosshair(invoker.GetXHair(3));
			}
			SMGR A 0 A_ZoomFactor(1.0);
            SM5S DCBA 1;
            TNT1 A 0 A_Lower(12);
            Wait;
        
        Reload:
			TNT1 A 0 A_JumpIfInventory("SMGAmmo",40,"ReadyToFire");
			TNT1 A 0 A_JumpIfInventory("MO_LowCaliber",1,3);
			TNT1 A 0 A_StartSound("weapon/empty",0);
			TNT1 A 0 A_JumpIf(invoker.isZoomed, "NoAmmoZoomed");
			Goto ReadyToFire;
			TNT1 AAA 0;
			TNT1 A 0 A_JumpIf(Invoker.isZoomed, "ReloadZoomed");
			TNT1 A 0 
			{
				invoker.isZoomed = False;
				invoker.isHoldingAim = False;
				A_ZoomFactor(1.0);
			}
			SMR1 AB 1 JM_WeaponReady(WRF_NOFIRE);
			SM5G A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			SMR1 CDE 1 JM_WeaponReady(WRF_NOFIRE);
			SM5G A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			SMR1 FGH 1 JM_WeaponReady(WRF_NOFIRE);
			SMR1 I 7 
			{
				JM_WeaponReady(WRF_NOFIRE);
				if(CountInv("MO_PowerSpeed") == 1) {A_SetTics(3);}
			}
			SMR2 A 0 A_JumpIf(CountInv("SMGAmmo") < 1, 2);
			SMR1 A 0;
			"####" J 1 A_StartSound("weapons/smg/magout", CHAN_AUTO);
			"####" JKLM 1 JM_WeaponReady(WRF_NOFIRE);
			SMR1 N 1 JM_WeaponReady(WRF_NOFIRE);
			SMR1 A 0 A_JumpIf(CountInv("SMGAmmo") >= 1, 2);
			SMR1 A 0; //A_SpawnItemEx('SMGMagazine', 25, 7, 29, random(-1,2), random(-6,-4), random(2,5));
			SMR1 N 5 
			 {
				JM_WeaponReady(WRF_NOFIRE);
				if(CountInv("MO_PowerSpeed") == 1) {A_SetTics(2);}
			}
			SMR1 OP 1 JM_WeaponReady(WRF_NOFIRE);
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			SMR1 QR 1 JM_WeaponReady(WRF_NOFIRE);
			SMR1 A 0 A_StartSound("weapons/SMG/magin", CHAN_AUTO, CHANF_DEFAULT);
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			SMR1 S 1 JM_WeaponReady(WRF_NOFIRE);
			SMR1 TU 1 JM_WeaponReady(WRF_NOFIRE);
			TNT1 A 0 JM_ReloadGun("SMGAmmo","MO_LowCaliber",40,1);
	DoneReload:
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			SMR1 VWXYZ 1;
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,5);
			SMR2 ABBBBBC 1 JM_WeaponReady(WRF_NOFIRE);
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
            SMR2 DE 1 JM_WeaponReady(WRF_NOFIRE);
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,3);
            SMR1 DCBA 1 JM_WeaponReady(WRF_NOFIRE);
			SM5G A 1;
            Goto ReadyToFire;

	ReloadZoomed:
			TNT1 AAA 0;
			TNT1 A 0 
			{
				A_ZoomFactor(1.2);
			}
			SMRZ AB 1 JM_WeaponReady(WRF_NOFIRE);
			SM5G A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			SMRZ CDE 1 JM_WeaponReady(WRF_NOFIRE);
			SM5G A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			SMRZ FGG 1 JM_WeaponReady(WRF_NOFIRE);
			SMRZ G 7 
			{
				JM_WeaponReady(WRF_NOFIRE);
				if(CountInv("MO_PowerSpeed") == 1) {A_SetTics(3);}
			}
			SMRZ H 1 A_StartSound("weapons/smg/magout", CHAN_AUTO);
			SMRZ IIJJ 1 JM_WeaponReady(WRF_NOFIRE);
			SMRZ J 1 JM_WeaponReady(WRF_NOFIRE);
			SMR1 A 0 A_JumpIf(CountInv("SMGAmmo") >= 1, 2);
			SMR1 A 0; //A_SpawnItemEx('SMGMagazine', 25, 7, 29, random(-1,2), random(-6,-4), random(2,5));
			SMRZ J 4 
			 {
				JM_WeaponReady(WRF_NOFIRE);
				if(CountInv("MO_PowerSpeed") == 1) {A_SetTics(2);}
			}
			SMRZ IHG 1 JM_WeaponReady(WRF_NOFIRE);
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			SMRZ K 1 JM_WeaponReady(WRF_NOFIRE);
			SMR1 A 0 A_StartSound("weapons/SMG/magin", CHAN_AUTO, CHANF_DEFAULT);
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			SMRZ LL 1 JM_WeaponReady(WRF_NOFIRE);
			SMRZ MN 1 JM_WeaponReady(WRF_NOFIRE);
			TNT1 A 0 JM_ReloadGun("SMGAmmo","MO_LowCaliber",40,1);
	DoneReloadZoomed:
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			SMRZ OONML 1;
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,5);
			SMRZ KKKKKKP 1 JM_WeaponReady(WRF_NOFIRE);
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
            SMRZ QR 1 JM_WeaponReady(WRF_NOFIRE);
			SMRZ A 0 A_ZoomFactor(1.3);
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
            SMRZ S 1 JM_WeaponReady(WRF_NOFIRE);
			SMRZ A 1 A_OverlayOffset(PSP_WEAPON , 0,39); 
			SMRZ A 1 A_OverlayOffset(PSP_WEAPON ,0,35);
			SMRZ A 1 A_OverlayOffset(PSP_WEAPON ,0,32);
			SM5G A 0 A_JumpIf(invoker.isHoldingAim == true, "ADSHold");
            Goto ReadyToFire;

	/*	ActionSpecial:
			"####" A 0 
			{
				if(CountInv("SMGBurstMode") == 1)
					{
						A_SetInventory("SMGBurstMode",0);
						A_Print("Full Auto");
					}
				else			
					{
					A_SetInventory("SMGBurstMode",1);
					A_Print("Burst Fire");
					}
			}
			SK34 ABCDEFGGG 1;// JM_WeaponReady();
			TNT1 A 0 A_StartSound("weapons/smg/modeswitch",0);
			SK34 GGG 1;
			SK34 FEDCBA 1 JM_WeaponReady();
			Goto ReadyToFire;*/

	//This will be added in a future update.
/*		Chamber:
			AR1G A 1 A_StartSound("weapons/ar/select",0);
			AR11 DEFGHIJ 1;
			AR11 J 0 A_StartSound("weapons/ar/chamberbck",1);
			AR11 JK 1;// A_StartSound("weapons/ar/chamberbck",1);
			AR11 LMM 1;
			AR11 N 0 A_StartSound("weapons/ar/chamberfwd",2);
			AR11 NOPQQQQQ 1;
			AR11 GFED 1;
			GOTO ReloadLoop;*/
		
		FlashKick:
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,"FlashKickFast");
			SK34 ABCDEFG 1;// JM_WeaponReady();
			SK34 GGFFEDCBA 1;// JM_WeaponReady();
			Goto ReadyToFire;
		
		FlashKickFast:
			SK34 ABCDEF 1;// JM_WeaponReady();
			SK34 GFEDCBA 1;// JM_WeaponReady();
			Goto ReadyToFire;
		
		FlashAirKick:
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,"FlashAirKickFast");
			SK34 ABCDEFG 1;// JM_WeaponReady();
			SK34 G 5;
			SK34 GGFEDCBA 1;// JM_WeaponReady();
			Goto ReadyToFire;
		
		FlashAirKickFast:
			SK34 ABCDEFG 1;// JM_WeaponReady();
			SK34 G 2;
			SK34 FEDCBA 1;// JM_WeaponReady();
			Goto ReadyToFire;
    }
} 

Class SMGAmmo : Ammo
{
	Default
	{
    Inventory.Amount 0;
	Inventory.MaxAmount 40;
	Ammo.BackpackAmount 0;
	Ammo.BackpackMaxAmount 40;
	Inventory.Icon "SUBMA0";
	}
}