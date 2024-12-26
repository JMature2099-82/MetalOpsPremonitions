//////////////////////////////////
// LEVER ACTION SHOTGUN	//
/////////////////////////////////
class LeverShotgun : JMWeapon //replaces Shotgun
{
	Default
	{
		Weapon.AmmoUse 0;
		Weapon.AmmoGive 7;
		Weapon.AmmoType1 "MO_ShotShell";
        Weapon.AmmoType2 "LeverShottyAmmo";
		Inventory.PickupMessage "$GOTLVRSHOT";
		Obituary "%o was terminated by %k's Lever Shotgun.";
		Weapon.SelectionOrder 1300;
		Tag "$TAG_LVRSHOT";
		Inventory.PickupSound "weapons/levershotty/pickup";
		Inventory.AltHUDIcon "W87CA0";
		JMWeapon.inspectToken "NeverUsedLAS";
		+Weapon.NoAlert
	}
	States
	{
	Inspect:
		W87I AB 1 JM_WeaponReady();
		W87A A 0 A_StartSound("weapons/levershotty/down", CHAN_AUTO);
		W87I CD 1 JM_WeaponReady();
		W87I E 10 JM_WeaponReady();
		W8R4 AB 1 JM_WeaponReady();
		W8R4 C 1 A_StartSound("weapons/levershotty/chamber", 1);
		W8R4 DEFGHI 1 JM_WeaponReady();
		W8R4 I 9 JM_WeaponReady();
		W8R4 JK 1 JM_WeaponReady();
		W8R4 L 1 A_StartSound("weapons/levershotty/up", 1);
		W821 FG 1 JM_WeaponReady();
		Goto ReadyToFire;
	ContinueSelect:
		TNT1 AAAAAAAAAAAAAAAAAA 0 A_Raise();
	Ready:
		TNT1 A 0 JM_CheckInspectIfDone;
	SelectAnimation:
		TNT1 A 0 A_StartSound("weapons/levershotty/select",1);
		W87S ABCDEF 1;
    ReadyToFire:
		W87G A 1 JM_WeaponReady(WRF_ALLOWRELOAD);
		W87G A 0 A_JumpIf(PressingFire(), "Fire");
		W87G A 0 A_JumpIf(PressingAltFire(), "AltFire");
		Loop;
	Deselect:
		TNT1 A 0 A_SetCrosshair(invoker.GetXHair(4));
		W87S FEDCBA 1;
	DeselectFast:
		TNT1 A 0 A_Lower(12);
		Wait;
	
	Select:
		TNT1 A 0;
		TNT1 A 0 A_SetCrosshair(invoker.GetXHair(4));
		Goto ClearAudioAndResetOverlays;
	Fire:
		PSTG A 0 MO_CheckMag;
		W87F A 1 BRIGHT {
			A_FireBullets (random(3, 6), frandom(2,5), 9, 12, "ShotgunShellPuff", FBF_NORANDOM,0,"MO_BulletTracer",0);
			A_StartSound ("weapons/levershotty/fire", CHAN_WEAPON);
			JM_UseAmmo("LeverShottyAmmo",1);
			 JM_CheckForQuadDamage();
			A_AlertMonsters();
			A_GunFlash();
		}
		W87F B 1 BRIGHT JM_GunRecoil(-1.2,.09);
		 W87F C 1 BRIGHT JM_GunRecoil(-1.2,.09);
		//possible recoil
		W87F D 1 JM_GunRecoil(+0.4,.13);
		W87F E 1 JM_GunRecoil(+0.1,.13);
		W87G A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
		W87F FFF 1;
        Goto Lever;
    Lever:
		W87A A 0 A_JumpIf(CountInv("LeverShottyAmmo") < 1, "TerminatorLever");
        W87P ABCD 1;
        W87A A 0 A_StartSound("weapons/levershotty/down", CHAN_AUTO);
		W87A A 0 SetInventory("Levering",0);
		W87G A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
		W87P EGH 1;
		W87G A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
		W87P IJ 1;
		TNT1 A 0 A_SpawnItemEx("ShotgunCasing",28, -32, random(17,20), random(-5,0), random(-5,-2), random(5,8));
		PSTG A 0 JM_WeaponReady(WRF_NOFIRE); //Quick switch
		W87G A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
		W87P KLMM 1 JM_WeaponReady(WRF_NOFIRE);
        W87A A 0 A_StartSound("weapons/levershotty/up", CHAN_AUTO);
		W87G A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
        W87P IIHG 1 JM_WeaponReady(WRF_NOFIRE);
		W87G A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
		W87P FED 1 JM_WeaponReady(WRF_NOFIRE);
		W87G A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
		W87P CBA 1 JM_WeaponReady(WRF_NOFIRE);
		W87G A 1 A_ReFire();
		PSTG A 0 MO_CheckMag;
		Goto ReadyToFire;
	TerminatorLever: //From M1887 BDv21 add-on
	   W87G A 0 SetInventory("Levering",1);   
	   W87T ABCD 1 JM_WeaponReady(WRF_NOFIRE);
	   W87G A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
	   W87T EFG 1 JM_WeaponReady(WRF_NOFIRE);
//	   W87G A 0 A_WeaponReady(WRF_NOFIRE| WRF_NOBOB);//Allows quick switch\
	   W87J j 0 A_StartSound("weapons/levershotty/down", CHAN_AUTO);
	   W87A A 0 A_SpawnItemEx("ShotgunCasing",24, 10, 8, random(3,5), random(6,10), random(6,9));
	   W87T HIJKL 1 JM_WeaponReady(WRF_NOFIRE);
//	   W87J NO 1;
	W87G A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
	   W87T MNO 1 JM_WeaponReady(WRF_NOFIRE);
	   W87G A 0 SetInventory("Levering",0);   
	   PSTG A 0 JM_WeaponReady(WRF_NOFIRE); //Quick switch
	   W87G A 0 A_StartSound("weapons/levershotty/up", CHAN_AUTO);
	   W87G A 0 A_JumpIfInventory("MO_PowerSpeed",1,3);
	   W87T PQRSSTU 1 JM_WeaponReady(WRF_NOFIRE);
	   W87G A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
	   W87T VWXYZ 1 JM_WeaponReady(WRF_NOFIRE);
	   W87G A 0;
	   PSTG A 0 MO_CheckMag;
	   Goto ReadyToFire;

	Flash:
			TNT1 A 2 A_AttachLightDef('GunLighting', 'GunFireLight');
			TNT1 A 0 A_RemoveLight('GunLighting');
			Stop;
	
	AltFire:
		PSTG A 0 MO_CheckMag;
		W87F A 1 BRIGHT {
			A_FireBullets (random(3, 6), frandom(2,6.7), 9, 12, "ShotgunShellPuff", FBF_NORANDOM,0,"MO_BulletTracer",0);
			A_StartSound ("weapons/levershotty/fire", CHAN_WEAPON);
			JM_UseAmmo("LeverShottyAmmo",1);
			 JM_CheckForQuadDamage();
			A_AlertMonsters();
			A_GunFlash();
		}
		W87F B 1 BRIGHT JM_GunRecoil(-1.2,.09);
		 W87A A 1 JM_GunRecoil(-1.2,.09);
		W87A B 1 JM_GunRecoil(+0.4,.09);
		W87A C 1 JM_GunRecoil(+0.1,.09);
		W87A D 1;// A_StartSound("weapons/levershotty/down", CHAN_AUTO);
		W87A E 1;
		TNT1 A 0 A_SpawnItemEx("ShotgunCasing",28, -3, random(17,20), random(-5,0), random(-5,-2), random(8,12));
		W87A F 1 A_StartSound("weapons/levershotty/down", CHAN_AUTO);
		W87A F 1 A_WeaponOffset(0,35);
		W87A F 1 A_WeaponOffset(0,38);
		W87A F 1 A_WeaponOffset(0,40);
		W87A F 1 A_WeaponOffset(0,37);
		W87A FED 1 A_WeaponOffset(0,33);
		W87A C 1 A_StartSound("weapons/levershotty/up", CHAN_AUTO);
		W87A BA 1;
		PSTG A 0 MO_CheckMag;
		Goto ReadyToFire;
	Reload:
		PSTG A 0 A_JumpIfInventory("LeverShottyAmmo",6,"ReadyToFire");
		PSTG A 0 A_JumpIfInventory("MO_ShotShell",1,1);
		goto ReadyToFire;
		W8R1 A 1 JM_WeaponReady(WRF_NOFIRE);
		W87J A 0 A_StartSound("weapons/levershotty/down", CHAN_AUTO);
		W8R1 BC 1 JM_WeaponReady(WRF_NOFIRE);
		PSTG A 0 A_JumpIfInventory("LeverShottyAmmo",6,"ReadyToLoadLast");
//		W87G A 0 A_JumpIfInventory("MO_PowerSpeed",1,4);
		W8R1 DEEEEEEEEE 1 JM_WeaponReady(WRF_NOFIRE);
		W8R1 FG 1 JM_WeaponReady(WRF_NOFIRE);
		//Sound here
		W87G A 0 A_StartSound("weapons/levershotty/shellelevator", 1);
		W87G A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
		W8R1 HIJK 1 JM_WeaponReady(WRF_NOFIRE);
		W87G A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
		W8R1 LMNOP 1 JM_WeaponReady(WRF_NOFIRE);
		W8R1 P 6 {
			JM_WeaponReady(WRF_NOFIRE);
			if(CountInv("MO_PowerSpeed") == 1) {A_SetTics(3);}
		}
		//W87G AAAAAAAAAA 1 A_WeaponOffset(0,10,WOF_ADD);
		//W87G A 5;
	ShellLoop:
		TNT1 A 0 A_JumpIfInventory("LeverShottyAmmo",5,"ExtraShell");
		TNT1 A 0 A_JumpIfInventory("MO_ShotShell",1,1);
		Goto DoneReload;
		W8R2 AB 1 JM_WeaponReady(WRF_NOFIRE);
		W8R2 C 1 {
			A_StartSound("weapons/levershotty/load", 1);
			return JM_WeaponReady(WRF_NOFIRE);
			}
		W87G A 0 JM_LoadShell("LeverShottyAmmo","MO_ShotShell",1);
		W8R2 DE 1;
		W8R2 FGHI 1
		{
			if(JustPressed(BT_ATTACK)) {return ResolveState("Fire");}
			if(JustPressed(BT_ALTATTACK)) {return ResolveState("AltFire");}
			return JM_WeaponReady(WRF_NOFIRE);
		}
		W87G A 0 A_JumpIf(invoker.OwnerHasSpeed(), 3);
		W8R2 IIIIIIIII 1 
		{
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
		W8R1 QR 1 JM_WeaponReady(WRF_NOFIRE);
		W8R1 S 1 A_StartSound("weapons/levershotty/up", CHAN_WEAPON);
		W8R1 TUV 1 JM_WeaponReady(WRF_NOFIRE);
		W8R1 V 6 
		{
			if(CountInv("MO_PowerSpeed") == 1) {A_SetTics(3);}
			return JM_WeaponReady(WRF_NOFIRE);
		}
		W8R1 W 1 A_StartSound("weapons/levershotty/down", CHAN_6);
		W87G A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
		W8R1 XX 1 JM_WeaponReady(WRF_NOFIRE);
		W87G A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
		W8R1 YY 1 JM_WeaponReady(WRF_NOFIRE);
		W87G A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
		W8R1 ZZZ 1 JM_WeaponReady(WRF_NOFIRE);
		W821 A 1 A_StartSound("weapons/levershotty/up", CHAN_7);
		W821 BCDEFG 1 JM_WeaponReady(WRF_NOFIRE);
		goto ReadyToFire;
	ExtraShell:
		W87G A 0 A_JumpIfInventory("LeverShottyAmmo",6,"ChamberLastShell");
		W8R3 AB 1 JM_WeaponReady();
		W8R3 C 1 
		{
			A_StartSound("weapons/levershotty/chamber", 1);
			JM_WeaponReady();
		}
		PISG A 0 JM_LoadShell("LeverShottyAmmo","MO_ShotShell",1);
		W8R3 DEFGHI 1 JM_WeaponReady();
		W8R3 I 12 {
			if(CountInv("MO_PowerSpeed") == 1) {A_SetTics(8);}
			return JM_WeaponReady();
		}
		PISG A 0 A_ReFire();
	ChamberLastShell:
		W8R4 AB 1 JM_WeaponReady();
		W8R4 C 1 {
			A_StartSound("weapons/levershotty/chamber", 1);
			JM_WeaponReady();
		}
		PISG A 0 JM_LoadShell("LeverShottyAmmo","MO_ShotShell",1);
		W8R4 DEFGHI 1 JM_WeaponReady();
		W8R4 I 9 
		{
			if(CountInv("MO_PowerSpeed") == 1) {A_SetTics(5);}
			return JM_WeaponReady();
		}
		W8R4 JK 1 JM_WeaponReady();
		W8R4 L 1 
		{
			A_StartSound("weapons/levershotty/up", 1);
			JM_WeaponReady();
		}
		W821 FG 1 JM_WeaponReady();
		GOTO ReadyToFire;
	
	ReadyToLoadLast:
		W8R3 II 7
		{
			if(CountInv("MO_PowerSpeed") == 1) {A_SetTics(4);}
			return JM_WeaponReady();
		}
		Goto ChamberLastShell;
		
	FlashKick:
		W87P ABCDEF 1;
		W87P F 4;
		W87P EEDCBA 1;
		Goto ReadyToFire;
	FlashAirKick:
		W87P ABCDEF 1;
		W87P F 6;
		W87P EEDCBA 1;
		Goto ReadyToFire;
	Spawn:
		W87C A -1;
		Stop;
	}
	
	//This is so that the shell loading of the inventory give and take is in one function for the Shotgun
	action void JM_LoadShell(name type, name reserve, int c)
	{
		TakeInventory(reserve, c, notakeinfinite: TRUE);
		GiveInventory(type, c);
	}
}

class Levering : Inventory
{	
	Default {Inventory.MaxAmount 1;}
}

class LeverShottyAmmo : Ammo
{
	Default
	{
		Inventory.Amount 0;
		Inventory.MaxAmount 7;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount 7;
		Inventory.Icon "W87CA0";
		+INVENTORY.IGNORESKILL;
	}
}