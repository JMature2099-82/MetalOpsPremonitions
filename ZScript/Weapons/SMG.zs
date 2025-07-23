//SMG

Class SMGBurstMode : MO_ZSToken{}

Class SMGIsEmpty : MO_ZSToken{}

Class MO_SubMachineGun : MO_Weapon
{
    Default
    {
		Weapon.AmmoUse1 1;
        Weapon.AmmoGive2 10;
		Weapon.SelectionOrder 1800;
        Weapon.AmmoType1 "SMGAmmo";
        Weapon.AmmoType2 "MO_LowCaliber";
        Inventory.PickupMessage "$GOTSMG";
        Obituary "$OBMO_SMG";
        Tag "$TAG_SMG";
		Inventory.PickupSound "weapons/smg/pickup";
		MO_Weapon.InspectToken "NeverUsedSMG";
		+WEAPON.NOALERT
		+WEAPON.NOAUTOFIRE
		+INVENTORY.TOSSED
		+WEAPON.AMMO_OPTIONAL
    }

	override void PostBeginPlay()
	{	
			isZoomed = false;
			isHoldingAim = false;
	}

	action void MO_FireSMG()
	{		
			if (!invoker.DepleteAmmo(false, true)) {return;}
			A_FireBullets(5.6, 0, 1, 10, "UpdatedBulletPuff",FBF_NORANDOM, 0,"MO_BulletTracer",0);
			A_StartSound("weapons/smg/fire", 0);
			A_AlertMonsters();
			JM_CheckForQuadDamage();
			A_GunFlash();
	}

    States
    {
		
		Inspect:
			TNT1 A 3;
			SM5G A 0 A_StartSound("weapon/inspectfoley4",0);
			SM11 ABCDEFFGG 1 JM_WeaponReady();
			SMR1 L 16 JM_WeaponReady();
			SMR1 MMNNOO 1 JM_WeaponReady();
			SMR1 PPQR 1 JM_WeaponReady();
			SMR1 A 0 A_StartSound("weapons/SMG/magin", CHAN_AUTO, CHANF_DEFAULT);
			SMR1 S 1 JM_WeaponReady();
			SMR1 TU 1 JM_WeaponReady();
			SMR1 VV 1 JM_WeaponReady();
			SMR1 WWW 1 JM_WeaponReady();
			SMR1 XXX 1 JM_WeaponReady();
			SMR1 YY 1 JM_WeaponReady();
			SM5G A 0 A_StartSound("weapons/smg/inspect2",0); 
			SMR1 ZZ 1 JM_WeaponReady();
			SM12 AA 1 JM_WeaponReady();
			SM12 B 1 JM_WeaponReady();
			SM12 C 1 JM_WeaponReady();
			SM12 D 5 JM_WeaponReady();
			SM5G A 0 A_StartSound("smg/pump1",0); //pump 
            SM12 E 2 JM_WeaponReady();
			SM12 F 20 JM_WeaponReady();
			SM5G A 0 A_StartSound("smg/pump2",0); //pump Forward 
			SM12 GH 2 JM_WeaponReady();
			SM12 H 4 JM_WeaponReady();
			SM12 IJKLM 1 JM_WeaponReady();
			Goto ReadyToFire;

        Spawn:
            SUBM A -1;
            STOP;

		SelectAnimation:
			TNT1 A 0 JM_CheckInspectIfDone;
			SM5G A 0 A_StartSound("weapons/smg/select",0);
            SM5S ABCD 1;
			SM5G A 0 A_JumpIf(invoker.isZoomed, "Zoom");
        ReadyToFire:
		Ready:
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
				if(PressingFire() && invoker.Ammo1.amount > 0) {
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
		ContinueSelect:
			TNT1 A 0 MO_Raise();
			Goto SelectAnimation;

        Fire:
			SM5G A 0 MO_JumpIfLessAmmo(1,"Empty");
			SM5G A 0 A_JumpIf(invoker.isZoomed, "Fire2");
            SM5F A 1 BRIGHT MO_FireSMG;
            SM5F B 1 BRIGHT 
			{
				JM_GunRecoil(-0.4, .03);
				JM_WeaponReady(WRF_NOFIRE);
				MO_EjectCase('PistolCasing', 26, 2, 7, random(-1, 2), frandom(3, 5), random(3, 4));
			}
            SM5F C 1 JM_WeaponReady(WRF_NOPRIMARY);
            AR1F A 0 A_JumpIf(PressingFire(), "Fire");
			SM5G A 0 MO_JumpIfLessAmmo;
            Goto ReadyToFire;

		Fire2:
			SM5G A 0 MO_JumpIfLessAmmo(1,"Empty");
		    SM5Z E 1 BRIGHT MO_FireSMG;
            SM5Z F 1 BRIGHT 
			{
				JM_GunRecoil(-0.2, .03);
				JM_WeaponReady(WRF_NOFIRE);
				MO_EjectCase('PistolCasing',31, -2, 7, frandom(-1,2), frandom(3,5), frandom(3,4));
			}
            SM5Z G 1;
			SM5G A 0 MO_JumpIfLessAmmo;
            SM5G A 0
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

	DryFire:
		TNT1 A 0 A_StartSound("weapon/pistolempty",0);
		Goto ReadyTofire;

		Flash:
			TNT1 A 2 A_AttachLightDef('GunLighting', 'GunFireLight');
			TNT1 A 1 A_AttachLightDef('GunLighting', 'GunFireLight');
			TNT1 A 0 A_RemoveLight('GunLighting');
			Stop;
	
		AltFire:
			TNT1 A 0 A_JumpIf(invoker.isZoomed, "UnZoom");
		Zoom:
			TNT1 A 0 {invoker.isZoomed = true;}
			SMGR A 0 A_StartSound("weapon/adsup",0);
			SMGR A 0 A_ZoomFactor(1.3);
			SMGR A 0 A_SetCrosshair(99);
			SMGR A 0 MO_ZoomBob;
			SM5Z ABC 1;
		Ready2:
			TNT1 A 0 A_JumpIf(invoker.ADSMode <= 0, "ADSToggle");
			TNT1 A 0 A_JumpIf(invoker.ADSMode == 1, "ADSHold");
			SM5Z DDDDD 1 
			{
				if(JustPressed(BT_ATTACK)) {return ResolveState("Fire");}
				if(PressingFire() && invoker.Ammo1.amount > 0) {
				return ResolveState("Fire");
				}
				return JM_WeaponReady(WRF_ALLOWRELOAD|WRF_NOFIRE);
			}
			TNT1 A 0 A_JumpIf(invoker.ADSMode == 2 && PressingAltFire() , "ADSHold");
		ADSToggle:
			SM5Z D 1 
			{
				if(JustPressed(BT_ALTATTACK)) {return ResolveState("UnZoom");}
				if(PressingFire() && invoker.Ammo1.amount > 0) {
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
				if(PressingFire() && invoker.Ammo1.amount > 0) {
				return ResolveState("Fire2");
				}
				return JM_WeaponReady(WRF_ALLOWRELOAD|WRF_NOSECONDARY);
			}
			Loop;

	Empty:
		SM5Z D 0 A_JumpIf(invoker.isZoomed, 2);
		SM5G A 0;
		#### # 0 A_JumpIf(invoker.ammo2.amount >= 1, "Reload");
		#### # 0 A_StartSound("weapon/pistolempty",0);
		#### # 1;
		Goto ReadyToFire;

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
			SM5G AAAAA 1
			{
				MO_ResetBob();
				if(PressingFire()) {return ResolveState("Fire");}
				if(JustPressed(BT_ALTATTACK)) {Return ResolveState("AltFire");}
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
			TNT1 AAA 0;
			TNT1 A 0 MO_CheckReload(34,1,"DoAnEmptyReload", null, "ReadyToFire");
		NormalReloadAnimation:
			TNT1 A 0 A_JumpIf(Invoker.isZoomed, "ReloadZoomed");
			TNT1 A 0 
			{
				invoker.isZoomed = False;
				invoker.isHoldingAim = False;
				A_ZoomFactor(1.0);
			}
			SMR2 A 0;
			SMR1 AB 1 JM_WeaponReady(WRF_NOFIRE);
			SM5G A 0 A_JumpIf(invoker.OwnerHasSpeed(), 1);
			SMR1 CDE 1 JM_WeaponReady(WRF_NOFIRE);
			SM5G A 0 A_JumpIf(invoker.OwnerHasSpeed(), 2);
			SMR1 F 1 JM_WeaponReady(WRF_NOFIRE);
			SMR1 G 5 
			{
				JM_WeaponReady(WRF_NOFIRE);
				MO_SetHasteTics(3);
			}
			SMR1 A 0 {
				if(invoker.Ammo1.amount < 1) 
				{JM_SetWeaponSprite("SMR2");}
			}
			#### A 0 A_StartSound("weapons/SMG/magout", CHAN_AUTO, CHANF_DEFAULT);
			"####" HIJK 1 JM_WeaponReady(WRF_NOFIRE);
			SMR1 A 0 A_JumpIf(CountInv("SMGAmmo") >= 1, 2);
			SMR1 A 0 MO_EjectCase('EmptySMGMagazine',25, 7, 8, random(-1,2), random(-5,-2), random(0,1)); //A_SpawnItemEx('SMGMagazine', 25, 7, 29, random(-1,2), random(-6,-4), random(2,5));
			SMR1 L 4 
			 {
				JM_WeaponReady(WRF_NOFIRE);
				MO_SetHasteTics(2);
			}
			SM5G A 0 A_JumpIf(invoker.OwnerHasSpeed(),2);
			SMR1 MNO 1 JM_WeaponReady(WRF_NOFIRE);
			SM5G A 0 A_JumpIf(invoker.OwnerHasSpeed(),2);
			SMR1 PQR 1 JM_WeaponReady(WRF_NOFIRE);
			SMR1 A 0 A_StartSound("weapons/SMG/magin", CHAN_AUTO, CHANF_DEFAULT);
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			SMR1 S 1 JM_WeaponReady(WRF_NOFIRE);
			SMR1 TU 1 JM_WeaponReady(WRF_NOFIRE);
			TNT1 A 0
			{
				if(invoker.Ammo1.amount < 1)
				{
					JM_ReloadGun("SMGAmmo","MO_LowCaliber",34,1);
				}
				else
				{
					JM_ReloadGun("SMGAmmo","MO_LowCaliber",35,1);
				}
			}
	DoneReload:
			SMR1 VV 1;
			SMR1 WW 1;
			SM5G A 0 A_JumpIf(invoker.OwnerHasSpeed(),2);
			SMR1 XX 1;
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			SMR1 YYY 1;
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			SMR1 ZZ 1;
			SMR1 [ 1;
			SMR1 \ 1;
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			SMR1 ] 1;
            SMR2 AB 1;
			SM5G A 0 A_JumpIfInventory("SMGIsEmpty",1,"Chamber");
            Goto ReadyToFire;

	DoAnEmptyReload:
		SM5G A 0 A_SetInventory("SMGIsEmpty",1);
		SM5G A 0 A_Jump(128, "AKReload");
		Goto NormalReloadAnimation;

	AKReload: //Random reload animation based on the AK-47 style reload
			TNT1 A 0 A_JumpIf(Invoker.isZoomed, "ZoomedAKReload");
			TNT1 A 0 
			{
				invoker.isZoomed = False;
				invoker.isHoldingAim = False;
				A_ZoomFactor(1.0);
			}
			SMGA A 0 A_StartSound("Weapon/inspectfoley2",0);
			SMR3 AB 1 JM_WeaponReady(WRF_NOFIRE);
			SM5G A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			SMR3 CDE 1 JM_WeaponReady(WRF_NOFIRE);
			SM5G A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			SMR3 FG 1 JM_WeaponReady(WRF_NOFIRE);
			SMR3 H 4 
			{
				JM_WeaponReady(WRF_NOFIRE);
				MO_SetHasteTics(2);
			}
			SM5G A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			SMR3 IJ 1 JM_WeaponReady(WRF_NOFIRE);
			SMR3 K 2 A_StartSound("smg/akreloadhit", CHAN_AUTO); 
			SMR3 L 3 MO_SetHasteTics(2);
			SMR3 M 2 MO_SetHasteTics(1);
			SM5G A 0 MO_EjectCase("EmptySMGMagazine",10, 5, 6, 11, 0, 2);
			SM5G A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			SMR3 NOP 1 JM_WeaponReady(WRF_NOFIRE);
			SM5G A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			SMR3 QQ 1 JM_WeaponReady(WRF_NOFIRE);
			SMR3 R 4
			{
					JM_WeaponReady(WRF_NOFIRE);
					MO_SetHasteTics(2);
			}
			SM5G A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			SMR3 STUV 1 JM_WeaponReady(WRF_NOFIRE);
			SM5G A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			SMR3 WXYY 1;
			TNT1 A 0 JM_ReloadGun("SMGAmmo","MO_LowCaliber",34,1);
			SMR3 Z 1 A_StartSound("weapons/SMG/magin", CHAN_AUTO, CHANF_DEFAULT);
			SMR3 Z 1;
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,3);
			//Chamber the round.
			SMR4 A 2;
			SM5G AAA 0;
			SMR4 B 7 MO_SetHasteTics(4);
			SMR4 C 2 A_StartSound("weapons/smg/inspect2",0);
			SM5G A 0 A_JumpIf(invoker.OwnerHasSpeed(), 2);
			SMR4 D 1;
			SMR4 E 1;
			SM5G A 0 A_JumpIf(invoker.OwnerHasSpeed(), 2);
			SMR4 F 1;
			SMR4 GH 1;
			SM5G A 0 A_JumpIf(invoker.OwnerHasSpeed(), 2);
			SMR4 IJK 1;
			SMR4 L 2;
			Goto Chamber;

		ZoomedAKReload: //Random reload animation based on the AK-47 style reload
			TNT1 A 0 A_ZoomFactor(1.2);
			SMGA A 0 A_StartSound("Weapon/inspectfoley2",0);
			SMZ1 AB 1 JM_WeaponReady(WRF_NOFIRE);
			SM5G A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			SMZ1 CDE 1 JM_WeaponReady(WRF_NOFIRE);
			SM5G A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			SMZ1 EF 1 JM_WeaponReady(WRF_NOFIRE);
			SMZ1 F 4 
			{
				JM_WeaponReady(WRF_NOFIRE);
				MO_SetHasteTics(2);
			}
			SM5G A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			SMZ1 FFF 1;
			SMZ1 G 2 A_StartSound("smg/akreloadhit", CHAN_AUTO); 
			SMZ1 H 3 MO_SetHasteTics(2);
			SMZ1 I 2 MO_SetHasteTics(1);
			SM5G A 0 MO_EjectCase("EmptySMGMagazine", 4, 0, 9, random(7,10), 0, random(0,1));
			SM5G A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			SMZ1 JKL 1;
			SM5G A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			SMZ1 MM 1 JM_WeaponReady(WRF_NOFIRE);
			SMZ1 NO 2;
			SM5G A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			SMZ1 PQQ 1 JM_WeaponReady(WRF_NOFIRE);
			SM5G A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			SMZ1 RSTU 1;
			TNT1 A 0 JM_ReloadGun("SMGAmmo","MO_LowCaliber",34,1);
			TNT1 A 0 A_StartSound("weapons/SMG/magin", CHAN_AUTO, CHANF_DEFAULT);
			SMZ1 TUV 2 MO_SetHasteTics(1);
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,3);
			SMZ1 WWXXYZ 1;
			SM5G AAA 0 A_ZoomFactor(1.3);
			SMZ1 "[\]" 1;
			SMZ1 A 4;
			Goto ChamberZoomed;

	ReloadZoomed:
			TNT1 AAA 0;
			TNT1 A 0 A_ZoomFactor(1.2);
			SZ01 AB 1 JM_WeaponReady(WRF_NOFIRE);
			SM5G A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			SZ01 CDE 1 JM_WeaponReady(WRF_NOFIRE);
			SM5G A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			SZ01 F 1 JM_WeaponReady(WRF_NOFIRE);
			SZ01 G 5 
			{
				JM_WeaponReady(WRF_NOFIRE);
				MO_SetHasteTics(3);
			}
			SZ01 H 1 A_StartSound("weapons/smg/magout", CHAN_AUTO);
			SZ01 IIJK 1 JM_WeaponReady(WRF_NOFIRE);
			SZ01 L 1 JM_WeaponReady(WRF_NOFIRE);
			SZ01 L 4 
			 {
				JM_WeaponReady(WRF_NOFIRE);
				MO_SetHasteTics(2);
			}
			SZ01 MNO 1 JM_WeaponReady(WRF_NOFIRE);
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			SZ01 P 1 JM_WeaponReady(WRF_NOFIRE);
			SMR1 A 0 A_StartSound("weapons/SMG/magin", CHAN_AUTO, CHANF_DEFAULT);
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			SZ01 QQ 1 JM_WeaponReady(WRF_NOFIRE);
			SZ01 R 1 JM_WeaponReady(WRF_NOFIRE);
			TNT1 A 0
			{
				if(invoker.Ammo1.amount < 1)
				{
					JM_ReloadGun("SMGAmmo","MO_LowCaliber",34,1);
				}
				else
				{
					JM_ReloadGun("SMGAmmo","MO_LowCaliber",35,1);
				}
			}
	DoneReloadZoomed:
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			SZ01 RQQPO 1;
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,3);
			SZ01 OOP 1;
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
            SZ01 Q 1;
			SM5G A 0 A_ZoomFactor(1.3);
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
            SZ01 R 1;
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			SZ01 STUV 1;
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			SZ01 WXY 1;
			SM5G A 0 A_JumpIfInventory("SMGIsEmpty",1,"ChamberZoomed");
			SM5G A 0 A_JumpIf(invoker.isHoldingAim == true, "ADSHold");
            Goto ReadyToFire;

			Chamber:
				TNT1 A 0 A_SetInventory("SMGIsEmpty",0);
				SMR2 B 2;
				SMR5 A 0 A_StartSound("smg/pump1",0); //pump 
				SM5R A 1 Offset(0,31);
				SM5R B 1;
				SM5R C 1 Offset(0,30);
				SM5R D 3 Offset(0,30);
				SM5R C 1 A_StartSound("smg/pump2",0); //pump Forward 
				SM5R B 1 Offset(0,30);
				SM5R A 1 Offset(0,31);
				SMR2 B 1 A_WeaponOffset(0,32);
				Goto ReadyToFire;

		ChamberZoomed:
				TNT1 A 0 A_SetInventory("SMGIsEmpty",0);
				SM5Z D 2;
				SMR5 A 0 A_StartSound("smg/pump1",0); //pump 
				SMRZ T 1;
				SMRZ UV 1;
				SMRZ W 3;
				SMRZ V 1 A_StartSound("smg/pump2",0); //pump Forward 
				SMRZ UT 1;
				SM5Z D 1 A_WeaponOffset(0,32);
				SM5G A 0 A_JumpIf(invoker.isZoomed && invoker.isHoldingAim && PressingAltFire() == true, "ADSHold");
				Goto ReadyToFire;
			
		FlashKick:
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,"FlashKickFast");
			SK34 ABCDE 1;
			SK34 F 5;
			SK34 EEDCBA 1;
			Goto ReadyToFire;
		
		FlashKickFast:
			SK34 ABCDEF 1;
			SK34 FEEDCBA 1;
			Goto ReadyToFire;
		
		FlashAirKick:
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,"FlashAirKickFast");
			SK34 ABCDEF 1;
			SK34 F 5;
			SK34 FEEDCBA 1;
			Goto ReadyToFire;
		
		FlashAirKickFast:
			SK34 ABCDEF 1;
			SK34 F 2;
			SK34 FEEDCBA 1;
			Goto ReadyToFire;

		FlashEquipmentToss:
			SM5S DCBA 1;
			Goto ThrowThatShitForReal;
    }
} 

Class SMGAmmo : Ammo
{
	Default
	{
    Inventory.Amount 0;
	Inventory.MaxAmount 35;
	Ammo.BackpackAmount 0;
	Ammo.BackpackMaxAmount 35;
	Inventory.Icon "SUBMA0";
	}
}