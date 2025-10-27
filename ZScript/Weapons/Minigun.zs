//Minigun

class MO_MiniGun : MO_Weapon
{

	action void MO_SpawnMinigunCasings(string c1, string c2, vector3 ofs = (24, 0, -10))
	{
		MO_EjectCasing(c1, true, frandom(-50, -35), speed: frandom(4, 7), offset: ofs);
		MO_EjectCasing(c2, true, frandom(-50, -35), speed: frandom(4, 7), offset: ofs);
	}
	
	bool isHolding;
	bool isSpinning;
	Default
	{
		Weapon.AmmoUse 1;
		Weapon.AmmoGive 20;
		Weapon.AmmoType "MO_HighCaliber";
		Weapon.SelectionOrder 700;
		Inventory.PickupMessage "You got the Vulcan Minigun! (Slot 4)";
		Obituary "$OB_MPCHAINGUN";
		Tag "Vulcan Minigun";
		Inventory.PickupSound "weapons/minigun/pickup";
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		isHolding = false;
		isSpinning = false;
	}

	States
	{
	
	SelectAnimation:
		MGNG A 0 A_StartSound("weapons/minigun/pickup",0);
		MGNG IJKLMN 1;
	ReadyToFire:
	Ready:
		TNT1 A 0 A_JumpIfInventory("MinigunSpin",1,"ReadyToFire2");
		MGNG A 1 JM_WeaponReady();
		Loop;

	Deselect:
		TNT1 A 0 
		{
			A_SetCrosshair(invoker.GetXHair(9));
			invoker.isHolding = False;
		}
		TNT1 A 0 A_JumpIfInventory("MinigunSpin",1,"DeselectSpin");
		TNT1 A 0 A_StopSound(CHAN_WEAPON);
		TNT1 A 0 A_StopSound(CHAN_AUTO);
	ActuallySwitchWeapons:
		TNT1 A 0 SetInventory("MinigunSpin",0);
		MGNG OPQRST 1;
		TNT1 A 1;
		MGNG A 0 A_Lower(12);
		Wait;

	Select:
		TNT1 A 0;
		TNT1 A 0 
		{
			A_SetCrosshair(invoker.GetXHair(9));
			invoker.isHolding = False;
		}
	ContinueSelect:
		MGNG A 0 MO_Raise();
		MGNG A 0 SetInventory("MinigunSpin",0);
		Goto SelectAnimation;

	NewFire:
	Fire:
		TNT1 A 0 A_JumpIf(CountInv("MinigunSpin") == 1, "Hold");
		TNT1 A 0 A_CheckReload();
		TNT1 A 0 A_StartSound("weapons/minigun/start",0);
		MGNG BC 2;
		MGNG DEFGHAB 1;
		Goto Hold;
	Hold:
		TNT1 A 0 A_CheckReload();
		TNT1 A 0 A_StartSound("weapons/minigun/fire",1,CHANF_LOOP);
	HoldingFire:
		TNT1 A 0 A_CheckReload();
		MGNF A 1 BRIGHT{
			A_FireBullets(5.6, 0, 1, 20, "MiniGunPuff",FBF_USEAMMO|FBF_NORANDOM, 0,"MO_BulletTracer",0);
			A_Overlay(-5, "MuzzleFlash");
			MO_SpawnMinigunCasings("EmptyRifleBrass", "MinigunBeltLink", (37, -10, -17));
			JM_CheckForQuadDamage();
			}
		MGNF B 1 BRIGHT JM_GunRecoil(-0.4,0);
		TNT1 A 0 A_CheckReload();
		MGNF C 1 BRIGHT {
			A_FireBullets(5.6, 0, 1, 20, "MiniGunPuff",FBF_USEAMMO|FBF_NORANDOM, 0,"MO_BulletTracer",0);
			MO_SpawnMinigunCasings("EmptyRifleBrass", "MinigunBeltLink", (37, -10, -17));
			A_Overlay(-5, "MuzzleFlash");
			}
		MGNF D 1 BRIGHT JM_GunRecoil(-0.4,0);
		TNT1 A 0 A_CheckReload();
		MGNF E 1 BRIGHT{
			A_FireBullets(5.6, 0, 1, 20, "MiniGunPuff",FBF_USEAMMO|FBF_NORANDOM, 0,"MO_BulletTracer",0);
			MO_SpawnMinigunCasings("EmptyRifleBrass", "MinigunBeltLink", (37, -10, -17));
			A_Overlay(-5, "MuzzleFlash");
			JM_CheckForQuadDamage();
			}
		MGNF F 1 BRIGHT JM_GunRecoil(-0.4,0);
		TNT1 A 0 A_CheckReload();
		MGNF G 1 BRIGHT {
			A_FireBullets(5.6, 0, 1, 20, "MiniGunPuff",FBF_USEAMMO|FBF_NORANDOM, 0,"MO_BulletTracer",0);
			MO_SpawnMinigunCasings("EmptyRifleBrass", "MinigunBeltLink", (37, -10, -17));
			A_Overlay(-5, "MuzzleFlash");
			}
		MGNF H 1 BRIGHT JM_GunRecoil(-0.4,0);
		MGNG B 0 A_JumpIf(PressingFire(), "HoldingFire");
		Goto StopSpin;
	
	StopAltFire:
		TNT1 A 0 {
			invoker.isHolding = false;
			A_StopSound(1);
			A_StopSound(5);
			A_StopSound(4);
			}
		TNT1 A 0 A_SetInventory("MinigunSpin",0);
	StopSpin:
		TNT1 A 0 A_JumpIf(CountInv("MinigunSpin") == 1, "ReadyToFire2");
		TNT1 A 0
		{
			A_StopSound(CHAN_5);
			A_StopSound(CHAN_WEAPON);
			A_StopSound(CHAN_AUTO);
			A_StopSound(CHAN_6);
		}
		TNT1 A 0 A_StartSound("weapons/Minigun/stop",1);
		MGNG ABCDEF 1;
		MGNG GGHH 1;
		MGNG AABBCCDD 1;
		MGNG EEFFGGGHHH 1;
		Goto ReadyToFire;
	DeselectSpin:
		TNT1 A 0
		{
			A_StopSound(CHAN_5);
			A_StopSound(CHAN_WEAPON);
			A_StopSound(CHAN_AUTO);
			A_StopSound(CHAN_6);
			A_SetInventory("MinigunSpin",0);
		}
		TNT1 A 0 A_StartSound("weapons/Minigun/stop",1);
		MGNG ABCDEF 1;
		MGNG GGHH 1;
		MGNG AABBCCDD 1;
		MGNG EEFFGGGHHH 1;
		Goto ActuallySwitchWeapons;
	AltFire:
		TNT1 A 0 A_JumpIf(CountInv("MinigunSpin") == 1, "StopAltFire");
		TNT1 A 0 A_StartSound("weapons/minigun/start",0);
		TNT1 A 0 A_SetInventory("MinigunSpin",1);
		MGNG AAAABBBBCCCDDDD 1;
		MGNG EEEFFFGGHH 1;
		MGNG AABCD 1;
		TNT1 A 0 A_StartSound("Weapons/Minigun/Loop",6, CHANF_LOOPING);
		MGNG EFGH 1;
		TNT1 A 0 {
			if(invoker.ADSMode == 1) {invoker.isHolding = true;}
			if(invoker.ADSMode == 2 && PressingAltFire()) {invoker.isHolding = true;}
		}
	ReadyToFire2:
		TNT1 A 0 A_StartSound("Weapons/Minigun/Loop",6, CHANF_LOOPING);
		TNT1 A 0 A_StopSound(CHAN_WEAPON);
		MGNG ABCDEFGH 1 
		{
				if(invoker.isHolding && !PressingAltFire())
				{
					return ResolveState("StopAltFire");
				}
				else if(!invoker.isHolding && JustPressed(BT_ALTATTACK))
				{
					return ResolveState("StopAltFire");
				}
				return JM_WeaponReady(WRF_NOSECONDARY);
		}
		Loop;
	
	FlashDONE:
		TNT1 A 1 A_RemoveLight('GunLighting');
		Stop;
	
	MuzzleFlash:
		TNT1 A 0
		{
			A_AttachLightDef('GunLighting', 'GunFireLight');
			A_OverlayFlags(OverlayID(), PSPF_FORCEALPHA, true);
			A_OverlayScale(OverlayID(), 0.85);
			A_OverlayOffset(OverlayID(),7,10);
			A_OverlayAlpha(OverlayID(), 0.85);
		}
		TNT1 A 0 A_Jump(256, "M1", "M2", "M3", "M4");
		Goto FlashDone;
	M1:
		MGF1 AC 1 BRIGHT;
		Goto FlashDone;
	M2:
		MGF1 BD 1 BRIGHT;
		Goto FlashDone;
	M3:
		MGF1 AB 1 BRIGHT;
		Goto FlashDone;
	M4:
		MGF1 CD 1 BRIGHT;
		Goto FlashDone;
	Spawn:
		MGUN A -1;
		Stop;
	FlashKick:
		TNT1 A 0 A_JumpIfInventory("MinigunSpin",1,"FlashKickSpin");
		TNT1 A 0 A_JumpIfInventory("MO_POWERSPEED",1,"FlashKickFast");
		MG1K ABCDEFFGGFEDCBA 1;
		Goto ReadyToFire;
	FlashAirKick:
		TNT1 A 0 A_JumpIfInventory("MinigunSpin",1,"FlashAirKickSpin");
		TNT1 A 0 A_JumpIfInventory("MO_POWERSPEED",1,"FlashAirKickFast");
		MG1K ABCDEFFGGGFFEDCBA 1;
		Goto ReadyToFire;
	FlashKickSpin:
		TNT1 A 0 A_JumpIfInventory("MO_POWERSPEED",1,"FlashKickSpinFast");
		MG2K ABCDEFFGGHHIJKLM 1;
		MGNG H 1;
		Goto ReadyToFire;
	FlashAirKickSpin:
		TNT1 A 0 A_JumpIfInventory("MO_POWERSPEED",1,"FlashAirKickSpinFast");
		MG2K ABCDEFFGGHHIIJKLM 1;
		MGNG H 1;
		Goto ReadyToFire;
		
	FlashKickFast:
		MG1K ABCDEFGFEDCBA 1;
		Goto ReadyToFire;
	FlashAirKickFast:
		MG1K ABCDEFGGFEDCBA 1;
		Goto ReadyToFire;
	FlashKickSpinFast:
		MG2K ABCDEFGHIJKLM 1;
		Goto ReadyToFire;
	FlashAirKickSpinFast:
		MG2K ABCDEFGGHIJKLM 1;
		Goto ReadyToFire;
	}
}

Class MinigunSpin : Inventory
{
	Default{Inventory.MaxAmount 1;}
}

Class IsChangingWeapons : MinigunSpin{}