//Heavy Combat Rifle

Class HCRIsEmpty : MO_ZSToken{}
Class HCR_GLMode : MO_ZSToken{}
Class HCR_3XZoom : MO_ZSToken{}
Class HCR_6XZoom : MO_ZSToken{}

Class MO_HeavyRifle : MO_Weapon
{
	bool hcrFiredGrenade;
	const PSP_MUZZLESMOKE = -2;
    Default
    {
		Weapon.AmmoUse1 1;
        Weapon.AmmoGive2 10;
        Weapon.AmmoType1 "HCRAmmo";
        Weapon.AmmoType2 "MO_HighCaliber";
        Inventory.PickupMessage "You got the Heavy Combat Rifle! (Slot 4)";
		Weapon.SelectionOrder 650;
        Obituary "$OB_HEAVYRIFLE";
        Tag "$TAG_HEAVYRIFLE";
		Weapon.SlotNumber 4;
		Inventory.PickupSound "weapons/ar/pickup";
		Scale 0.55;
		MO_Weapon.inspectToken "NeverUsedHCR";
		+INVENTORY.TOSSED
		+WEAPON.NOALERT
		+WEAPON.NOAUTOFIRE
		+WEAPON.AMMO_OPTIONAL
    }

    States
    {
		Inspect:
			HCRI A 1 A_StartSound("hcr/inspectRaise", 0); //Inspect Raise
			HCRI BCDEFGHI 1;
			HCRI JKLLLLLLL 1;
			HCRI MNOPQ 1;
			HCRA A 0 A_StartSound("hcr/boltback", 0);
			HCRI RRSSSTTUU 1;
			HCRI U 8;
			HCRA A 0 A_StartSound("hcr/boltfwd", 0);
			HCRI VVWXYZZ 1;
			HCRI Z 1 A_StartSound("hcr/inspectEnd", 6);
			HCRI "[\]" 1;
			1CRI AB 1;
			Goto Ready;
        Spawn:
            HCRC A -1;
            STOP;

		SelectAnimation:
			TNT1 A 0 JM_CheckInspectIfDone;
            HCRI A 1 A_StartSound("hcr/draw", 0);
			HCRI BCD 1;
			HCRG A 0 A_JumpIf(invoker.isZoomed, "Zoom");
		Ready:
			TNT1 A 0 A_SetInventory("SpecialAction",0);
        ReadyToFire:
            HCRG A 1
			{
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
			HCRG A 0;
			HCRG A 0
			{
				invoker.isHoldingAim = false;
				invoker.isZoomed = false;
				A_SetInventory("HCR_3XZoom",0);
				A_SetInventory("HCR_6XZoom",0);
				A_ZoomFactor(1.0);
				MO_SetHMRCrosshair();
			}
		ContinueSelect:
			TNT1 A 0 MO_Raise();
			//Initialize empty sprite frames into memory
			HCGG A 0;
			HCRG A 0;
			HR4R A 0; 
			Goto SelectAnimation;

        Fire:
			TNT1 A 0 A_JumpIf(invoker.isZoomed == true, "Fire2");
			TNT1 A 0 MO_JumpIfLessAmmo(1, "NoAmmo");
			TNT1 A 0 A_GunFlash("Flash");
            TNT1 A 1 BRIGHT {
				invoker.DepleteAmmo(false, true);
				MO_FireHMR();
				A_Overlay(PSP_MUZZLESMOKE, "MuzzleSmoke");
            }
            TNT1 B 1 BRIGHT 
			{
				JM_WeaponReady(WRF_NOFIRE);
				MO_EjectCase("HeavyRifleBrass",26,2,13, random(-1,1), random(4,7), random(3,6));
				JM_GunRecoil(-1.1, .04);
			}
		ResumeFire:
            HCRF C 1 
			{
				JM_WeaponReady(WRF_NOFIRE);
				JM_GunRecoil(-1.1, .04);
			}
			HCRF D 1 
			{
				JM_WeaponReady(WRF_NOFIRE);
				JM_GunRecoil(-1.1, .04);
			}
			HCRF D 1 JM_WeaponReady(WRF_NOFIRE);
			HCRF EF 1
			{
				JM_WeaponReady(WRF_NOFIRE);
				JM_GunRecoil(1.0, .10);
			}
			HCRF G 1 JM_WeaponReady(WRF_NOFIRE);
			HCRG AAAAAAAA 1 
			{
				If(JustPressed(BT_ATTACK)) {Return ResolveState("fIRE");}
				return JM_WeaponReady(WRF_NOFIRE);
			}
			TNT1 A 0 MO_JumpIfLessAmmo(1);
			TNT1 A 0 A_ReFire;
            Goto Ready;

		Flash:
			TNT1 A 0 A_AttachLightDef('GunLighting', 'GunFireLight');
			TNT1 A 0 A_Jump(256, "FlashAB", "FlashHI", "FlashJK", "FlashLM");
		FlashAB:
			HCRF AB 1 BRIGHT;
			TNT1 A 0 A_RemoveLight('GunLighting');
			Goto FlashDone;

		FlashHI: //Frames H and I
			HCRF HI 1 BRIGHT;
			Goto FlashDone;

		FlashJK: //Frames J and K
			HCRF JK 1 BRIGHT;
			Goto FlashDone;

		FlashLM: //Frames L and M
			HCRF JK 1 BRIGHT;
			Goto FlashDone;

		FlashDone:
			TNT1 A 0 A_RemoveLight('GunLighting');
			Stop;

		Fire2:
			TNT1 A 0 MO_JumpIfLessAmmo(1, "NoAmmo");
			TNT1 A 0 A_JumpIf(CountInv("HCR_3XZoom") || CountInv("HCR_6XZoom") >= 1, "SniperFire");
            HC2G B 1 BRIGHT {
				invoker.DepleteAmmo(false, true);
				MO_FireHMR();
				A_Overlay(-5, "ZOOMEDFLASH");
				A_AlertMonsters();
            }
            HC2G C 1 BRIGHT 
			{
				JM_WeaponReady(WRF_NOFIRE);
				MO_EjectCase("HeavyRifleBrass",26,-1,11, random(0,1), random(4,6), random(4,6));
				JM_GunRecoil(-1.1, .04);
			}
            HC2G D 1 
			{
				JM_WeaponReady(WRF_NOFIRE);
				JM_GunRecoil(-1.1, .04);
			}
			HC2G D 1 
			{
				JM_WeaponReady(WRF_NOFIRE);
				JM_GunRecoil(-1.1, .04);
			}
			HC2G E 1 JM_WeaponReady(WRF_NOFIRE);
			HC2G EF 1
			{
				JM_WeaponReady(WRF_NOFIRE);
				JM_GunRecoil(+1.0, .10);
			}
			HC2G G 1 JM_WeaponReady(WRF_NOFIRE);
			HC2G AAAAAAA 1 
			{
				If(JustPressed(BT_ATTACK)) {Return ResolveState("fIRE");}
				return JM_WeaponReady(WRF_NOFIRE);
			}
			TNT1 A 0 MO_JumpIfLessAmmo(1);
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

		SniperFire:
			TNT1 A 0 MO_JumpIfLessAmmo(1, "NoAmmo");
            HC2Z D 1 BRIGHT 
			{
				invoker.DepleteAmmo(false, true);
				MO_FireHMR();
			}
            HC2Z D 1 BRIGHT 
			{
				JM_WeaponReady(WRF_NOFIRE);
				MO_EjectCase("HeavyRifleBrass",26,-1,17, random(0,1), random(3,6), random(3,6));
				JM_GunRecoil(-1.1, .04);
			}
			HC2Z DD 1 
			{
				JM_WeaponReady(WRF_NOFIRE);
				JM_GunRecoil(-1.1, .04);
			}
			HC2Z DD 1 JM_WeaponReady(WRF_NOFIRE);
			HC2Z DD 1
			{
				JM_WeaponReady(WRF_NOFIRE);
				JM_GunRecoil(+1.0, .10);
			}
			HC2Z DDDDDDDDDD 1
			{
				If(JustPressed(BT_ATTACK)) {Return ResolveState("SniperFire");}
				return JM_WeaponReady(WRF_NOFIRE);
			}
			TNT1 A 0 MO_JumpIfLessAmmo(1);
			AR1F A 0
			{
				if(invoker.ADSMode >= 1)
				{
					if(PressingAltFire() && PressingFire())
					{
						invoker.isHoldingAim = true;
						return ResolveState("SniperFire");
					}
					if(!PressingAltFire() && invoker.isHoldingAim) {
						return ResolveState("UnZoom");
					}
					else
					{if(PressingFire()) {return ResolveState("SniperFire");}}
				}
				else
				{A_ReFire("SniperFire");}
				return JM_WeaponReady(WRF_NOFIRE|WRF_ALLOWRELOAD);
			}
            Goto Ready2;

        Deselect:
			HCRG A 0
			{
				A_SetInventory("HCR_3XZoom",0);
				A_SetInventory("HCR_6XZoom",0);
				invoker.isHoldingAim = false;
				invoker.isZoomed = false;
				A_ZoomFactor(1.0);
				MO_SetHMRCrosshair();
			}
            HCRI D 1;
			HCRI CBA 1;
            TNT1 A 0 A_Lower(12);
            Wait;
        

		ActionSpecial:
			#### # 1;
			TNT1 A 0 A_JumpIf(invoker.isZoomed == true, "ZoomSniper");
			TNT1 A 0 A_StartSound("weapons/smg/modeswitch",0);
			TNT1 A 0 A_JumpIfInventory("HCR_GLMode",1,"DeselectUBGL");
			TNT1 A 0 
			{
				A_Print("Underbarrel Grenade Launcher Alt Fire");
				A_SetCrossHair(invoker.GetXHair(17));
				A_SetInventory("HCR_GLMode",1);
				A_SetInventory("SpecialAction",0);
			}
			Goto ReadyToFire;

		ZoomSniper:
			TNT1 A 0 A_JumpIfInventory("HCR_6XZoom",1, "ReturnToNormalAim");
			TNT1 A 0 A_StartSound("hcr/sniperzoom");
			TNT1 A 0 A_JumpIfInventory("HCR_3XZoom",1, "Zoom6X");
			TNT1 A 0
			{
				A_SetInventory("HCR_3XZoom",1);
				A_SetInventory("HCR_6XZoom",0);
				A_Print("3x Sniper Zoom");
				A_ZoomFactor(3.8);
			}
			HC2G A 1;
			HC2Z ABC 1;
			FLMG A 0 A_SetInventory("SpecialAction",0);
			Goto SniperReady;

		Zoom6X:
			TNT1 A 0
			{
					A_SetInventory("HCR_3XZoom",0);
					A_SetInventory("HCR_6XZoom",1);
					A_Print("6x Sniper Zoom");
					A_ZoomFactor(6.8);
					A_SetInventory("SpecialAction",0);
			}
			Goto SniperReady;

		ReturnToNormalAim:
			TNT1 A 0
			{
					A_StartSound("hcr/sniperunzoom");
					A_SetInventory("HCR_3XZoom",0);
					A_SetInventory("HCR_6XZoom",0);
					A_Print("Normal Aim, sniper bullets disabled");
					A_ZoomFactor(1.85);
			}
		SniperUnzoomAnimation:
			HC2Z CBA 1;
			HC2G A 1;
			TNT1 A 0 A_SetInventory("SpecialAction",0);
			Goto Ready2;

		SniperUnZoom:
			TNT1 A 0
			{
					A_SetInventory("HCR_3XZoom",0);
					A_SetInventory("HCR_6XZoom",0);
					A_ZoomFactor(1.85);
					A_SetCrossHair(invoker.GetXHair(8));
			}
			HC2Z CBA 1;
			HC2G A 1;
			Goto UnZoom;
			
		DeselectUBGL:
			HCRG A 0 
			{
				A_SetCrossHair(invoker.GetXHair(8));
				A_SetInventory("SpecialAction",0);
				A_Print("Sniper/Zoom Aim Alt Fire");
				A_SetInventory("HCR_GLMode",0);
			}
			Goto ReadyToFire;

		AltFire:
			HCRA A 0 A_JumpIfInventory("HCR_GLMode",1,"GrenadeFire");
			HCRA A 0 A_JumpIf(invoker.isZoomed, "UnZoom");
		Zoom:
			HCRA A 0 {
				invoker.isZoomed = true;
				A_StartSound("weapon/adsup",0);
				A_ZoomFactor(1.85);
				A_SetCrosshair(99);
			}
			HCRZ AB 1;
			HCRZ CD 1 A_WeaponOffset(0,36);
			HCRZ E 1 A_WeaponOffset(0,34);
			HCRZ F 1 A_WeaponOffset(0,32);
		Ready2:
			TNT1 A 0 A_JumpIf(CountInv("HCR_3XZoom") || CountInv("HCR_6XZoom") >= 1, "SniperReady");
			TNT1 A 0 A_JumpIf(invoker.ADSMode <= 0, "ADSToggle");
			TNT1 A 0 A_JumpIf(invoker.ADSMode == 1, "ADSHold");
			HC2G AAAAA 1 
			{
				if(JustPressed(BT_ATTACK)) {return ResolveState("Fire2");}
				return JM_WeaponReady(WRF_ALLOWRELOAD|WRF_NOFIRE);
			}
			TNT1 A 0 A_JumpIf(invoker.ADSMode == 2 && PressingAltFire(), "ADSHold"); //Hybrid

		ADSToggle:
			HC2G A 1 
			{
				if(JustPressed(BT_ALTATTACK)) {SetWeaponState("UnZoom");}
				return JM_WeaponReady(WRF_ALLOWRELOAD|WRF_NOSECONDARY);
			}
			Loop;
		//Hold and Hybrid
		ADSHold:
			TNT1 A 0 {invoker.isHoldingAim = true;}
			HC2G A 1 
			{
				if(!PressingAltFire()) {SetWeaponState("UnZoom");}
				return JM_WeaponReady(WRF_ALLOWRELOAD|WRF_NOSECONDARY);
			}
			Loop;

		SniperReady:
			TNT1 A 0 A_JumpIf(invoker.ADSMode <= 0, "SniperToggle");
			TNT1 A 0 A_JumpIf(invoker.ADSMode == 1, "SniperHold");
			TNT1 A 0 A_JumpIf(PressingFire(), "Fire2");
			HC2Z DDDDD 1 
			{
				if(JustPressed(BT_ATTACK)) {return ResolveState("Fire2");}
				return JM_WeaponReady(WRF_ALLOWRELOAD|WRF_NOFIRE);
			}
			TNT1 A 0 A_JumpIf(invoker.ADSMode == 2 && PressingAltFire() , "SniperHold");

		SniperToggle:
			HC2Z D 1 
			{
				if(JustPressed(BT_ALTATTACK)) 
				{
					invoker.isZoomed = false;
					invoker.isHoldingAim = false;
					return ResolveState("SniperUnZoom");
				}
				return JM_WeaponReady(WRF_ALLOWRELOAD|WRF_NOSECONDARY);
			}
			Loop;
		//Sniper Hold and Hybrid
		SniperHold:
			TNT1 A 0 {invoker.isHoldingAim = true;}
			HC2Z D 1 
			{
				if(!PressingAltFire()) 
				{
					invoker.isZoomed = false;
					invoker.isHoldingAim = false;
					return ResolveState("SniperUnZoom");
				}
				return JM_WeaponReady(WRF_ALLOWRELOAD|WRF_NOSECONDARY);
			}
			Loop;

		Unzoom:
			HCRA A 0 {
				invoker.isZoomed = false;
				invoker.isHoldingAim = false;
				A_SetInventory("HCR_3XZoom",0);
				A_SetInventory("HCR_6XZoom",0);
				A_StartSound("weapon/adsdown",0);
				A_ZoomFactor(1.0);
				A_SetCrossHair(invoker.GetXHair(8));
			}
			HCRZ FEDCBA 1;
			Goto ReadyToFire;

		GrenadeFire:
			HCRA A 0 A_JumpIf(MO_UBGLFired() == false, 3);
			TNT1 A 0 A_JumpIfInventory("MO_RocketAmmo",1,2);
			HCRG A 1 A_Print("Out of Rocket Ammo");
			Goto Ready;
			TNT1 AA 0;
			HCRA A 0 A_JumpIf(MO_UBGLFired() == true, "ReloadGrenade");
			HCRA A 0 MO_SetGrenade(true);
			HCRA A 0 A_TakeInventory("MO_RocketAmmo",1,TIF_NOTAKEINFINITE);
			HCRH A 1  bright
			{
				A_StartSound("hcr/glfire",0);
				A_Overlay(PSP_MUZZLESMOKE, "GrenMuzzleSmoke");
				A_FireProjectile("HCRGrenade",0,0,0,0);
				A_AlertMonsters();
			}
			HCRH BC 1 bright JM_GunRecoil(-1.0, .25);
			HCRH D 1;
			HCRH EF 1 JM_GunRecoil(0.5, .10);
			HCRH F 4 A_WeaponReady(WRF_NOFIRE);
			TNT1 A 0 A_JumpIfInventory("MO_RocketAmmo",1,2);
			Goto ReadyToFire;
		ReloadGrenade:
			TNT1 AAAA 0;
			HRG1 AB 1 A_WeaponReady(WRF_NOFIRE);
			HRG1 C 1 A_StartSound("hcr/grenadeopen",0);
			TNT1 A 0 A_Jumpif(invoker.OwnerHasSpeed(), 2);
			HRG1 DEFGH 1;
			TNT1 A 0 A_Jumpif(invoker.OwnerHasSpeed(), 3);
			TNT1 A 0;
			HRG1 I 1;
			TNT1 AA 0;
			TNT1 A 0 MO_EjectCase("EmptyGrenadeShell", 15, 9, 10, -1, -1, -1);
			HRG1 JKLM 1;
			HRG1 N 12 {if(invoker.OwnerHasSpeed()) A_SetTics(6);}
			HRG1 OP 1;
			TNT1 A 0 A_StartSound("hcr/grenadeload",0);
			TNT1 A 0 A_Jumpif(invoker.OwnerHasSpeed(), 1);
			HRG1 QRS 1;
			TNT1 A 0 A_StartSound("hcr/grenadeshellin",0);
			TNT1 A 0 A_Jumpif(invoker.OwnerHasSpeed(), 1);
			HRG1 TUV 1;
			TNT1 A 0 A_Jumpif(invoker.OwnerHasSpeed(), 1);
			HRG1 WXY 1;
			HRG1 Z 8 {if(invoker.OwnerHasSpeed()) A_SetTics(4);}
			HCRA A 0 MO_SetGrenade(false);
			HRG2 A 2 A_StartSound("hcr/grenadeclose",0);
			HRG2 BBCCDEFGH 1;
			Goto ReadyToFire;

		GrenMuzzleSmoke:
			TNT1 A 0
			{
				A_OverlayFlags(OverlayID(), PSPF_FORCEALPHA, true);
				A_OverlayAlpha(OverlayID(), 0.75);
			}
			HMZH A 1 bright;
			HMZH b 1 BRIGHT;
			HMZH C 1 BRIGHT;
			Stop;

		MuzzleSmoke:
			TNT1 A 0
			{
				A_OverlayFlags(OverlayID(), PSPF_FORCEALPHA, true);
				A_OverlayAlpha(OverlayID(), 0.6);
			}
			HMZF ABC 1 bright;
			Stop;

		ZoomedFlash:
			HC2M AB 1 BRIGHT A_AttachLightDef('GunLighting', 'GunFireLight');
			TNT1 A 0 A_RemoveLight('GunLighting');
			STOP;
	
		NoAmmo:
		HCRG AA 0;
		HCRG A 0 A_JumpIf(invoker.ammo2.amount >= 1, "Reload");
		HCRG A 0 A_StartSound("weapon/rifleempty",0);
		TNT1 A 0 A_JumpIf(Invoker.isZoomed, "NoAmmoZoomed");
		HCRG A 1;
		Goto ReadyToFire;

		NoAmmoZoomed:
			HC2Z D 0 A_JumpIf(CountInv("HCR_3XZoom") || CountInv("HCR_6XZoom") >= 1, 2);
			HC2G A 0;
			#### # 1;
			Goto Ready2;

        Reload:
			AR1G A 0 MO_CheckReload(12,1, "DoAnEmptyReload", null, "ReadyToFire");
		ReloadAnimation:
			HCRA A 0 {
				invoker.isZoomed = false;
				invoker.isHoldingAim = false;
				A_ZoomFactor(1.0);
				A_SetInventory("HCR_3XZoom",0);
				A_SetInventory("HCR_6XZoom",0);
				MO_SetHMRCrosshair();
			}
			TNT1 A 0 A_StartSound("hcr/reloadRaise", 7);
			
			HCRR ABCD 1 JM_WeaponReady(WRF_NOFIRE);
			HCRA A 0 A_JumpIf(invoker.OwnerHasSpeed(), 1);
			HCRR EF 1;
			HCRA A 0 A_JumpIf(invoker.OwnerHasSpeed(), 1);
			HCRR GHIJ 1 JM_WeaponReady(WRF_NOFIRE);
			HCRR A 0 A_StartSound("hcr/magbutton",1);
			HCRA A 0 A_JumpIf(invoker.OwnerHasSpeed(), 1);
			HCRR K 1;
			HCRR L 8
			{
				JM_WeaponReady(WRF_NOFIRE);
				{if(invoker.OwnerHasSpeed()) A_SetTics(5);}
			}
			HCRR MN 1 JM_WeaponReady(WRF_NOFIRE);
			HCRA A 0 A_JumpIf(invoker.OwnerHasSpeed(), 1);
			HCRR OP 1;
			HCRR P 4 {if(invoker.OwnerHasSpeed()) A_SetTics(2);}
			HCRR Q 1 A_StartSound("hcr/magout", CHAN_AUTO);

			HCRR A 0 MO_SetEmptyHMRSprite("HR4R");//Set empty reload sprite
			#### RS 1 JM_WeaponReady(WRF_NOFIRE);
			#### TU 1 JM_WeaponReady(WRF_NOFIRE);

			AR12 A 0 A_JumpIf(CountInv("HCRAmmo") >= 1, 2);
			HCRR A 0 {MO_EjectCasing("ARMagazine", ejectpitch: frandom(-20, -15), speed: frandom(4, 5),  offset:(28, 16, -13));}
			HCRR V 16 {if(invoker.OwnerHasSpeed()) A_SetTics(8);}
			HCRA A 0 A_JumpIf(invoker.OwnerHasSpeed(), 1);
			HCRR W 1 JM_WeaponReady(WRF_NOFIRE);
			HCRA A 0 A_JumpIf(invoker.OwnerHasSpeed(), 1);
			HCRR X 1 JM_WeaponReady(WRF_NOFIRE);
			HCRR YYZZ 1 JM_WeaponReady(WRF_NOFIRE);
			HCRA A 0 A_JumpIf(invoker.OwnerHasSpeed(), 2);
			1CRR AAA 1 JM_WeaponReady(WRF_NOFIRE);
			HCRA A 0 A_JumpIf(invoker.OwnerHasSpeed(), 2);
			1CRR BBC 1 JM_WeaponReady(WRF_NOFIRE);
			AR10 A 0 A_StartSound("hcr/magin", CHAN_AUTO);
			HCRA A 0 A_JumpIf(invoker.OwnerHasSpeed(), 1);
			1CRR CC 1 JM_WeaponReady(WRF_NOFIRE);
			1CRR D 1 JM_WeaponReady(WRF_NOFIRE);
			HCRA A 0 A_JumpIf(invoker.OwnerHasSpeed(), 1);
			1CRR EE 1 JM_WeaponReady(WRF_NOFIRE);
			AR10 A 0 JM_ReloadGun("HCRAmmo", "MO_HighCaliber",12,3);
			HCRA A 0 A_JumpIf(invoker.OwnerHasSpeed(), 1);
			1CRR FFG 1 JM_WeaponReady(WRF_NOFIRE);
			HCRA A 0 A_JumpIf(invoker.OwnerHasSpeed(), 1);
			1CRR HIJ 1 JM_WeaponReady(WRF_NOFIRE);
			1CRR K 6 {if(invoker.OwnerHasSpeed()) A_SetTics(3);}
			HCRA A 0 A_JumpIf(CountInv("HCRIsEmpty") >= 1, "Chamber");
			HCRA A 0 A_JumpIf(invoker.OwnerHasSpeed(), 1);
			AR10 A 0 A_StartSound("hcr/reloadend", CHAN_AUTO);
			1CRR LMN 1 JM_WeaponReady(WRF_NOFIRE);
			HCRA A 0 A_JumpIf(invoker.OwnerHasSpeed(), 1);
			1CRR OPQ 1;
			HCRR BA 1;
            Goto ReadyToFire;

		DoAnEmptyReload:
			TNT1 A 0 A_SetInventory("HCRIsEmpty",1);
			Goto ReloadAnimation;

		Chamber:
			HCRA A 0 A_SetInventory("HCRIsEmpty",0);
			HR4R XYZ 1;
			HCRI Q 1;
			HCRA A 0 A_StartSound("hcr/boltback", 0);
			HCRI RRSSSTUU 1;
			HCRI U 2 {if(invoker.OwnerHasSpeed()) A_SetTics(1);}
			HCRA A 0 A_StartSound("hcr/boltfwd", 0);
			HCRA A 0 A_JumpIf(invoker.OwnerHasSpeed(), 2);
			HCRI VWXYZ 1;
			HCRA A 0 A_JumpIf(invoker.OwnerHasSpeed(), 2);
			HCRI Z 1 A_StartSound("hcr/inspectEnd", 6);
			HCRI "[\]" 1;
			HCRA A 0 A_JumpIf(invoker.OwnerHasSpeed(), 1);
			1CRI AB 1;
			GOTO ReadyToFire;
		
		FlashKick:
			HR4K ABCDEFGHIJKLMO 1;// JM_WeaponReady();
			Goto ReadyToFire;
		
		FlashAirKick:
			HR4K ABCDEFGHHIJJKLMO 1;// JM_WeaponReady();
			Goto ReadyToFire;

		FlashKickFast:
			HR4K ABCDEFHKLMO 1;// JM_WeaponReady();
			Goto ReadyToFire;
		
		FlashAirKickFast:
			HR4K ABCDEFGHIJKLMO 1;// JM_WeaponReady();
			Goto ReadyToFire;
    }

	action void MO_SetGrenade(bool fired = false)
	{
		invoker.hcrFiredGrenade = fired;
	}

	action bool MO_UBGLFired()
	{
		return invoker.hcrFiredGrenade;
	}

	action void MO_SetHMRCrosshair()
	{
		{
				if(FindInventory("HCR_GLMode"))
				{
					A_SetCrossHair(invoker.GetXHair(17));
				}
				else 
				{A_SetCrossHair(invoker.GetXHair(8));}
		}
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		hcrFiredGrenade = false;
		isZoomed = false;
		isHoldingAim = false;
	}

	action void MO_FireHMR()
	{
		A_FireBullets(5.6, 0, 1, 55, "UpdatedBulletPuff",FBF_NORANDOM);
		A_StartSound("hcr/fire", 0);
		A_AlertMonsters();
	}

	action void MO_SetEmptyHMRSprite(string lump)
	{
		if(invoker.Ammo1.amount < 1) {MO_SetWeaponSprite(lump, OverlayID());}
	}

} 

Class HCRAmmo : Ammo
{
	Default
	{
    Inventory.Amount 0;
	Inventory.MaxAmount 12;
	Ammo.BackpackAmount 0;
	Ammo.BackpackMaxAmount 12;
	Inventory.Icon "HCRCA0";
	+INVENTORY.IGNORESKILL;
	}
}

Class HCRGrenade : Actor
{
	override string GetObituary (Actor victim, Actor inflictor, Name mod, bool playerattack)
    {
        if(mod == "ExplosiveImpact")
		{
			return "$OB_HEAVYRIFLE_GRENADESPLASH";
		}
        return "$OB_HEAVYRIFLE_GRENADE";
    }

	int timer;
	Default
	{
	Radius 8;
	Height 8;
	DamageFunction (35);
	Speed 50;
	Scale 0.5;
	BounceSound "hcr/grenade";
	BounceType "Doom";
	Projectile;
	BounceFactor 0.5;
	Obituary "$OB_HEAVYRIFLE_GRENADE";
//	ReactionTime 30;
	DamageType "Explosive";
	-NOGRAVITY
    +BLOODSPLATTER
	+EXTREMEDEATH
	+FORCEXYBILLBOARD
	+CANBOUNCEWATER
	}
	States
	{
	Spawn:
		SHRP O 0;
	SpawnLoop:
		SHRP O 0 A_SpawnItemEx("MO_GrenadeSmokeTrail",flags:SXF_NOCHECKPOSITION,0);
		SHRP O 1 {timer++;}
		SHRP O 0 A_JumpIf(timer >= 55, "Explode");
		Loop;
	Death:
		SHRP O 0 A_SpawnItemEx("MO_GrenadeSmokeTrail",flags:SXF_NOCHECKPOSITION,0);
		SHRP O 1 {timer++;}
		SHRP O 0 A_JumpIf(timer >= 55, "Explode");
		Loop;
	XDeath:
	Explode:
		TNT1 A 0 A_StopSound(CHAN_7);
		TNT1 A 0 A_StartSound("40mmExplosion");
		TNT1 A 0 A_StartSound("fraggrenade/farexplosion", 8);
		TNT1 A 1 A_SpawnItemEx("RocketExplosionFX",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
		TNT1 A 0 A_Explode(125, 180, damagetype: "ExplosiveImpact");
		TNT1 A 0 DESTROY();
		Stop;
	}
}