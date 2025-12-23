//Assault Rifle

Class ARSemiAuto : MO_ZSToken{} 

Class AssaultRifle : MO_Weapon
{
    Default
    {
		Weapon.AmmoUse1 1;
        Weapon.AmmoType1 "ARAmmo";
        Weapon.AmmoType2 "MO_HighCaliber";
		Weapon.AmmoGive2 10;
		Weapon.SelectionOrder 800;
        Inventory.PickupMessage "$GOTRIFLE";
        Obituary "$OBMO_RIFLE";
        Tag "$TAG_RIFLE";
		Inventory.PickupSound "weapons/ar/pickup";
		+INVENTORY.TOSSED
		+WEAPON.NOALERT
		+WEAPON.NOAUTOFIRE;
		+WEAPON.AMMO_OPTIONAL;
    }

	override void PostBeginPlay()
	{	
			isZoomed = false;
			isHoldingAim = false;
	}

	action void MO_FireRifle()
	{
		if (!invoker.DepleteAmmo(false, true)){return;}
		A_FireBullets(5.6, 0, 1, 18, "UpdatedBulletPuff",FBF_NORANDOM,0,"MO_BulletTracer",0);
        A_StartSound("weapons/ar/fire", 0);
		A_GunFlash();
		JM_CheckForQuadDamage();
		A_AlertMonsters();
	}


    States
    {

        Spawn:
            AR1W A -1;
            STOP;

		SelectAnimation:
			TNT1 A 0 A_StartSound("weapons/ar/select",0);
            AR1S ABCD 1;
			HCRG A 0 A_JumpIf(invoker.isZoomed, "Zoom");
		Ready:
        ReadyToFire:
            AR1G A 1 
			{
				A_SetCrossHair(invoker.GetXHair(7));
				if(invoker.isZoomed) {return ResolveState("Ready2");}
				if(PressingAltFire() && invoker.ADSMode >= 1) {
				return ResolveState("AltFire");
				}
				if(JustPressed(BT_ALTATTACK) && invoker.ADSMode < 1) {
				return ResolveState("AltFire");
				}
				if(PressingFire() && invoker.Ammo1.amount > 0) {
				return ResolveState("Fire");
				}
				return JM_WeaponReady(WRF_ALLOWRELOAD|WRF_NOSECONDARY);
			}
            Loop;

        Select:
			TNT1 A 0;
			TNT1 A 0 
			{
				invoker.isZoomed = false;
				invoker.isHoldingAim = False;
				A_ZoomFactor(1);
			}
			TNT1 A 0 A_SetCrossHair(invoker.GetXHair(7));
		ContinueSelect:
			TNT1 A 0 MO_Raise();
			Goto SelectAnimation;
		
        Fire:
			AR1G A 0 MO_JumpIfLessAmmo(where: "Empty");
			TNT1 A 0 A_JumpIf(invoker.isZoomed, "Fire2");
            AR1F A 1 BRIGHT MO_FireRifle;
            AR1F B 1 BRIGHT 
			{
				JM_WeaponReady(WRF_NOFIRE);
				MO_EjectCasing("EmptyRifleBrass", false, ejectpitch: frandom(-35, -25), speed: frandom(5, 8), offset: (38, 3, -14));
				JM_GunRecoil(-0.45, .04);
			}
            AR1F C 1 
			{
				JM_WeaponReady(WRF_NOFIRE);
				JM_GunRecoil(-0.45, .04);
			}
			AR1F D 1 JM_WeaponReady(WRF_NOPRIMARY);
			AR1G A 0 MO_JumpIfLessAmmo();
			AR1G A 0 A_JumpIfInventory("ARSemiAuto",1, "SemiFireFinished");
            AR1F A 0 A_ReFire();
            Goto ReadyToFire;
		
		SemiFireFinished:
			AR1Z E 0 A_JumpIf(invoker.isZoomed, "SemiFireFinishedADS");
			AR1G A 1 A_JumpIf(JustPressed(BT_ATTACK), "Fire");
			AR1G A 0 A_JumpIf(!PressingFire(), "ReadyToFire");
			Loop;
		
		SemiFireFinishedADS:
			AR1Z E 1;
			AR1Z E 1 
			{
				if(invoker.ADSMode >= 1)
				{
					if(PressingAltFire() && PressingFire())
					{
						invoker.isHoldingAim = true;
						return ResolveState("SemiFireFinishedADS");
					}
					if(!PressingAltFire() && invoker.isHoldingAim == true) {
						return ResolveState("UnZoom");
					}
					else
					{if(PressingFire()) {return ResolveState("SemiFireFinishedADS");}}
				}
				else
				{A_ReFire("SemiFireFinishedADS");}
				return JM_WeaponReady(WRF_NOFIRE|WRF_ALLOWRELOAD);
			}
			Goto Ready2;
		Flash:
			TNT1 A 2 A_AttachLightDef('GunLighting', 'GunFireLight');
			TNT1 A 2 A_AttachLightDef('GunLighting', 'GunFireLight');
			TNT1 A 0 A_RemoveLight('GunLighting');
			Stop;

		AltFire:
			TNT1 A 0 A_JumpIf(invoker.isZoomed, "UnZoom");
		Zoom:
			SMGR A 0 
			{
				invoker.isZoomed = True;
				A_ZoomFactor(1.85);
				A_StartSound("weapon/adsup",0);
				A_SetCrosshair(99);
			}
			AR1Z ABCD 1 JM_WeaponReady(WRF_NOFIRE);
			AR1Z E 1 JM_WeaponReady(WRF_NOFIRE);
		Ready2:
			TNT1 A 0 A_JumpIf(invoker.ADSMode <= 0, "ADSToggle");
			TNT1 A 0 A_JumpIf(invoker.ADSMode == 1, "ADSHold");
			AR1Z EEEEE 1 
			{
				if(JustPressed(BT_ATTACK)) {return ResolveState("Fire");}
				if(PressingFire() && invoker.Ammo1.amount > 0) {
				return ResolveState("Fire");
				}
				return JM_WeaponReady(WRF_ALLOWRELOAD|WRF_NOFIRE);
			}
			TNT1 A 0 A_JumpIf(invoker.ADSMode == 2 && PressingAltFire() , "ADSHold");
			Goto ADSToggle;

		Empty:
		AR1Z E 0 A_JumpIf(invoker.isZoomed, 2);
		AR1G A 0;
		#### ## 0;
		#### # 0 A_JumpIf(invoker.ammo2.amount >= 1, "Reload");
		#### # 0 A_StartSound("weapon/rifleempty",0);
		#### # 1;
		Goto ReadyToFire;

		ADSToggle:
			AR1Z E 1 
			{
				if(JustPressed(BT_ALTATTACK)) {return ResolveState("UnZoom");}
				if(PressingFire() && invoker.Ammo1.amount > 0) {
				return ResolveState("Fire");
				}
				return JM_WeaponReady(WRF_ALLOWRELOAD|WRF_NOSECONDARY);
			}
			Loop;

		ADSHold:
			TNT1 A 0 {invoker.isHoldingAim = true;}
			AR1Z E 1 
			{
				if(!PressingAltFire()) {return ResolveState("UnZoom");}
				if(PressingFire() && invoker.Ammo1.amount > 0) {
				return ResolveState("Fire");
				}
				return JM_WeaponReady(WRF_ALLOWRELOAD|WRF_NOSECONDARY);
			}
			Loop;

		Unzoom:
			SMGR A 0 
			{
				invoker.isZoomed = false;
				invoker.isHoldingAim = False;
				A_ZoomFactor(1);
				A_StartSound("weapon/adsdown",0);
				A_SetCrossHair(invoker.GetXHair(7));
			}
			AR1Z EDCBA 1 JM_WeaponReady(WRF_NOFIRE);
			Goto ReadyToFire;

		Fire2:
			AR1G A 0 MO_JumpIfLessAmmo(where: "Empty");
			AR1Z F 1 BRIGHT MO_FireRifle;
            AR1Z G 1 BRIGHT 
			{
				JM_GunRecoil(-0.38, .04);
				JM_WeaponReady(WRF_NOFIRE);
				MO_EjectCasing("EmptyRifleBrass", false, ejectpitch: frandom(-35, -25), speed: frandom(5, 8), offset: (40, 2, -9));
			}
			AR1Z H 1 
			{
				JM_WeaponReady(WRF_NOFIRE);
				JM_GunRecoil(-0.42, .04);
			}
            AR1Z I 1 JM_WeaponReady(WRF_NOFIRE);
			TNT1 A 0 MO_JumpIfLessAmmo;
			TNT1 A 0 A_Jumpif(CountInv("ARSemiAuto") >= 1, "SemiFireFinishedADS");
			AR1F A 0
			{
				if(invoker.ADSMode >= 1)
				{
					if(PressingAltFire() && PressingFire())
					{
						invoker.isHoldingAim = true;
						return ResolveState("Fire2");
					}
					if(!PressingAltFire() && invoker.isHoldingAim == true) {
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

        Deselect:
			TNT1 A 0 
			{
				invoker.isZoomed = false;
				invoker.isHoldingAim = False;
				A_ZoomFactor(1);
				A_SetCrossHair(invoker.GetXHair(7));
			}
            AR1S EFGH 1;
            TNT1 A 0 A_Lower(12);
            Wait;
		
		FireFinished:
			AR1Z E 0 A_JumpIf(invoker.isZoomed, 2);
			AR1G A 0;
			"####" "#" 1 JM_WeaponReady(WRF_NoFire);
			AR1F A 0 A_JumpIf(PressingFire(), "FireFinished");
			Goto ReadyToFire;

		NoAmmoZoomed:
			AR1Z E 1;
			Goto Ready2;
        
        Reload:
			AR1G A 0 MO_CheckReload(30,1, "DoAnEmptyReload", null, "ReadyToFire");
		Reload.Default:
			AR10 A 0 A_JumpIf(Invoker.isZoomed, "ReloadZoomed");
			AR10 A 0 
			{
				invoker.isZoomed = false;
				invoker.isHoldingAim = False;
				A_ZoomFactor(1.0);
				if(CountInv("ARIsEmpty") >= 1) {return A_Jump(128, "MagFlipReload");}
				return ResolveState(Null);
			}
			AR10 ABC 1 JM_WeaponReady(WRF_NOFIRE);
			AR1F A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			AR10 DEF 1 JM_WeaponReady(WRF_NOFIRE);
			AR1F A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			AR10 GHI 1 JM_WeaponReady(WRF_NOFIRE);
			AR10 I 7 {
				JM_WeaponReady(WRF_NOFIRE);
				if(CountInv("MO_PowerSpeed") == 1) {A_SetTics(4);}
				}
			A612 A 0 A_JumpIf(CountInv("ARAmmo") < 1, 2);
			AR10 A 0;
			"####" J 1 A_StartSound("weapons/ar/magout", CHAN_AUTO);
			"####" KLM 1 JM_WeaponReady(WRF_NOFIRE);
			AR12 A 0 A_JumpIf(CountInv("ARAmmo") >= 1, 2);
		
			AR10 A 0 {MO_EjectCasing("ARMagazine",true,-30, offset:(24,2,-10));}//A_SpawnItemEx('ARMagazine', 25, 7, 29, random(-1,2), random(-6,-4), random(2,5));
			AR10 N 8 {
				JM_WeaponReady(WRF_NOFIRE);
				if(CountInv("MO_PowerSpeed") == 1) {A_SetTics(4);}
				}
			AR1F A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			AR10 OPQ 1 JM_WeaponReady(WRF_NOFIRE);
			AR10 A 0 A_StartSound("weapons/ar/magin", CHAN_AUTO);
			AR1F A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			AR10 RST 1 JM_WeaponReady(WRF_NOFIRE);
		DoneReload:		
			AR10 UV 1;
			AR1F A 0 A_JumpIfInventory("MO_PowerSpeed",1,4);
			AR10 WWWWXYZ 1; //JM_WeaponReady(WRF_NOFIRE);
			AR1F A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			AR11 AB 1 JM_WeaponReady(WRF_NOFIRE);
			AR11 J 0 A_StartSound("weapons/ar/ReloadEnd",1);
			AR11 A 0 A_JumpIf(CountInv("ARIsEmpty") >= 1, "Chamber");
			AR10 A 0 JM_ReloadGun("ARAmmo", "MO_HighCaliber",31,1);
			AR11 C 1 JM_WeaponReady(WRF_NOFIRE);
			 AR1G A 1;
			 Goto ReadyToFire;
       MagFlipReload:
			AR1G A 0 A_StartSound("weapons/ar/arflipstart", 0);
			AR12 ABC 1 JM_WeaponReady(WRF_NOFIRE);
			AR1F A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			AR12 DEF 1 JM_WeaponReady(WRF_NOFIRE);
			AR1F A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			AR12 GH 1 JM_WeaponReady(WRF_NOFIRE);
			AR11 J 0 A_StartSound("weapons/ar/magflipsound",0);
			AR12 I 11 {
				JM_WeaponReady(WRF_NOFIRE);
				if(CountInv("MO_PowerSpeed") == 1) {A_SetTics(6);}
				}
			AR12 J 1 JM_WeaponReady(WRF_NOFIRE);	
			AR12 K 1 A_StartSound("weapons/ar/arflipend", 0);
			AR1F A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			AR12 L 1 JM_WeaponReady(WRF_NOFIRE);
			AR10 A 0 {MO_EjectCasing("ARMagazine",true,-20, frandom(6,10), offset:(28,5,-12));}//A_SpawnItemEx('ARMagazine', 28, 7, 29, random(-1,2), random(-8,-4), random(2,3));
			AR12 MNO 1 JM_WeaponReady(WRF_NOFIRE);
			AR12 P 5 {
				JM_WeaponReady(WRF_NOFIRE);
				if(CountInv("MO_PowerSpeed") == 1) {A_SetTics(3);}
				}
			AR1F A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			AR12 QRS 1 JM_WeaponReady(WRF_NOFIRE);
			AR10 A 0 A_StartSound("weapons/ar/magin", CHAN_AUTO);
			AR1F A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			AR12 TUV 1 JM_WeaponReady(WRF_NOFIRE);
			AR10 A 0 JM_ReloadGun("ARAmmo", "MO_HighCaliber",30,1);
			AR12 W 5 {
				JM_WeaponReady(WRF_NOFIRE);
				if(CountInv("MO_PowerSpeed") == 1) {A_SetTics(3);}
				}
			AR12 A 0 A_SetInventory("ARIsEmpty",0);
			AR12 XYZ 1;
			AR13 AB 1 JM_WeaponReady(WRF_NOFIRE);
			AR11 J 0 A_StartSound("weapons/ar/chamberbck",1);
			AR1F A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			AR13 CCDE 1  JM_WeaponReady(WRF_NOFIRE);
			AR13 F 1;
			AR11 J 0 A_StartSound("weapons/ar/chamberfwd",1);
			AR13 G 1;
			AR13 H 7
			{
				JM_WeaponReady(WRF_NOFIRE);
				if(CountInv("MO_PowerSpeed") == 1) {A_SetTics(4);}
			}
			AR11 J 0 A_StartSound("weapons/ar/ReloadEnd",1);
			AR13 IJKL 1;
			Goto ReadyToFire;

		DoAnEmptyReload:
			TNT1 A 0 A_SetInventory("ARIsEmpty",1);
			Goto Reload.Default;

		ReloadZoomed:
			TNT1 A 0 A_ZoomFactor(1.575);
			AR1Z E 1 JM_WeaponReady(WRF_NOFIRE);
			ARZR AB 1 JM_WeaponReady(WRF_NOFIRE);
			AR1F A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			ARZR BCC 1 JM_WeaponReady(WRF_NOFIRE);
			AR1F A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			ARZR DEF 1 JM_WeaponReady(WRF_NOFIRE);
			ARZR G 7 {
				JM_WeaponReady(WRF_NOFIRE);
				if(CountInv("MO_PowerSpeed") == 1) {A_SetTics(4);}
				}
			ARZR H 1 A_StartSound("weapons/ar/magout", CHAN_AUTO);
			ARZR IJI 1 JM_WeaponReady(WRF_NOFIRE);
			AR12 A 0 A_JumpIf(CountInv("ARAmmo") >= 1, 2);
			AR10 A 0 {MO_EjectCasing("ARMagazine",true,-20, frandom(6,10), offset:(28,5,-12));}
			ARZR K 8 {
				JM_WeaponReady(WRF_NOFIRE);
				if(CountInv("MO_PowerSpeed") == 1) {A_SetTics(4);}
				}
			ARZR A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			ARZR KKL 1 JM_WeaponReady(WRF_NOFIRE);
			AR10 A 0 A_StartSound("weapons/ar/magin", CHAN_AUTO);
			AR1F A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			ARZR MN 1 JM_WeaponReady(WRF_NOFIRE);
			ARZR O 1;
			ARZR O 5 {
				JM_WeaponReady(WRF_NOFIRE);
				if(CountInv("MO_PowerSpeed") == 1) {A_SetTics(3);}
				}
			AR1F A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			ARZR PQR 1 JM_WeaponReady(WRF_NOFIRE);
			AR11 A 0 A_JumpIf(CountInv("ARIsEmpty") >= 1, "Chamber");
			AR10 A 0 JM_ReloadGun("ARAmmo", "MO_HighCaliber",31,1);
			TNT1 A 0 A_ZoomFactor(1.85);
			AR1F A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			ARZR STU 1 JM_WeaponReady(WRF_NOFIRE);
			AR11 J 0 A_StartSound("weapons/ar/ReloadEnd",1);
			ARZR B 1 JM_WeaponReady(WRF_NOFIRE);
			 Goto ReadyToFire;
		ActionSpecial:
			"####" A 0 
			{
				if(CountInv("ARSemiAuto") == 1)
				{
					A_SetInventory("ARSemiAuto",0);
					A_Print("Full Auto");
				}
				else			
				{
					A_SetInventory("ARSemiAuto",1);
					A_Print("Semi Auto");
				}
			}
			AR1K ABCDEFGGG 1;// JM_WeaponReady();
			TNT1 A 0 A_StartSound("weapons/smg/modeswitch",0);
			AR1K GGG 1;
			AR1K FEDCBA 1;
			AR10 A 0 A_SetInventory("SpecialAction",0);
			Goto ReadyToFire;

		Chamber:
			TNT1 A 0 A_SetInventory("ARIsEmpty",0);
			AR10 A 0 JM_ReloadGun("ARAmmo", "MO_HighCaliber",30,1);
			TNT1 A 0 A_JumpIf(invoker.isZoomed, "Chamber2");
			AR1G A 0 A_StartSound("weapons/ar/ReloadEnd",0);
			AR11 D 1;
			AR11 EF 2;
			AR11 J 0 A_StartSound("weapons/ar/chamberbck",1);
			AR11 GH 2;
			AR11 N 0 A_StartSound("weapons/ar/chamberfwd",2);
			AR11 IJKLMNO 1;
			GOTO ReadyToFire;

		Chamber2: //Zoomed
			AR1G A 0 A_StartSound("weapons/ar/ReloadEnd",0);
			ARZR S 2;
			ARZS ABCD 1;
			AR11 J 0 A_StartSound("weapons/ar/chamberbck",1);
			ARZS EEFG 1;
			AR11 N 0 A_StartSound("weapons/ar/chamberfwd",2);
			ARZS HIJ 1;
			TNT1 A 0 A_ZoomFactor(1.85);
			ARZR STUBA 1;
			GOTO ReadyToFire;
		
		FlashKick:
			AR1K ABCDEFG 1;// JM_WeaponReady();
			AR1K GGFFEDCBA 1;// JM_WeaponReady();
			Goto ReadyToFire;
		
		FlashAirKick:
			AR1K ABCDEFG 1;// JM_WeaponReady();
			AR1K G 5;
			AR1K GGFEDCBA 1;// JM_WeaponReady();
			Goto ReadyToFire;
    }
} 

Class ARAmmo : Ammo
{
	Default
	{
    Inventory.Amount 0;
	Inventory.MaxAmount 31;
	Ammo.BackpackAmount 0;
	Ammo.BackpackMaxAmount 31;
	Inventory.Icon "AR1WA0";
	+INVENTORY.IGNORESKILL;
	}
}