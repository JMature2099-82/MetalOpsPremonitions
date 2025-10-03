//RZ-40 Razorhand
class DoChainswordBash : MO_Token{}
class ChainswordSwingLeft : MO_Token{}

class MO_Chainsword: MO_Weapon
{
	Default	
	{
		Weapon.KickBack 0;
		Weapon.SelectionOrder 2200;
		Inventory.PickupMessage "$GOTCHAINSWORD";
		Inventory.PickupSound "Chainsword/Up";
		Obituary "$OB_MPCHAINSAW";
		Tag "$TAG_CHAINSWORD";
		Inventory.AltHudIcon "KATAN0";
		+WEAPON.MELEEWEAPON
		+WEAPON.NOAUTOSWITCHTO
		+WEAPON.NOAUTOFIRE;
	}

//This is a shortcut function for the chainsword's sawing attack when the attack buttons are released.
//attack = the button used for attack. Example: BT_ATTACK
//st = The state label to jump to when the attack button is released.
	action void MO_CSwordAttack(int attack, statelabel st)
	{
		if(PressingWhichInput(attack)) {
		//Doing a  projectile instead because the A_Saw hit sound wasn't looping properly.
			A_FireProjectile("MO_ChainswordAttack", spawnheight: 2);
			}
		else
		{SetWeaponState(st);}
	}

	action void MO_CSwordBash()
	{
		FTranslatedLineTarget t;
		int dmg = 35;
		double ang = angle + Random2() * (5.625 / 256);
        double pitch = AimLineAttack(ang, 64, null, 0., ALF_CHECK3D);
		
		if(invoker.OwnerHasBerserk())
		{	
			if(health < 30)
			LineAttack(ang, 68, pitch, dmg * 3, 'ExtremePunches', "BerserkChainsawBashPuff", LAF_ISMELEEATTACK,t);
			else
			 LineAttack(ang, 68, pitch, dmg * 2, 'ExtremePunches', "BerserkChainsawBashPuff", LAF_ISMELEEATTACK,t);
		}
		else
		{
			LineAttack(ang, 68, pitch, dmg, 'Kick', "ChainsawBashPuff", LAF_ISMELEEATTACK,t);
		}
		
        if (t.linetarget)
        {
			A_StartSound("Chainsword/BashHit",4);
		}
	}

	States
	{

	Spawn:
		CSWR D -1;
		Stop;

	SelectAnimation:
		CSWS DCBA 1;
		CSWS A 2;
		TNT1 A 0 A_StartSound("Chainsword/Press",0);
		CSWS AA 2 A_WeaponOffset(-1, 4, WOF_ADD);
		TNT1 A 0 A_StartSound("Chainsword/Up", 0);
		CSWS AA 2 A_WeaponOffset(1,-4, WOF_ADD);
		CSWG C 3;
	Ready:
		TNT1 A 0 A_GunFlash("IdleAnimationOffset");
		TNT1 A 0 A_StartSound("Chainsword/Idle",1,CHANF_LOOPING);
	ReadyToFire:
		CSWG CD 3 JM_WeaponReady;
		Loop;

	Deselect:
		TNT1 A 0
		{
			A_WeaponOffset(0,32);
			A_StopSound(1);
			A_StopSound(6);
			A_StartSound("Chainsword/Deselect",0);
		}
		CSWS ABCD 1;
		TNT1 A 2;
		TNT1 A 0 A_Lower;
		Wait;

	Select:
		TNT1 A 1;
		TNT1 A 0 A_SetCrosshair(99);
	ContinueSelect:
		TNT1 A 0 MO_Raise;
		Goto SelectAnimation;

	//Melee Bash Attack
	ActionSpecial:
		TNT1 A 0 A_GunFlash(NULL);
		CSWS AB 1;
		SAWG A 0 A_JumpIf(invoker.OwnerHasSpeed(), 2);
		CSWS CD 1;	
		TNT1 AAA 0;
		TNT1 A 0 A_StartSound("Chainsword/Bash",CHAN_AUTO);
		SAWG A 0 A_JumpIf(invoker.OwnerHasSpeed(), 2);
		CSWB A 1;
		CSWB BC 1;
		CSWB D 1 MO_CSwordBash();
		SAWG A 0 A_JumpIf(invoker.OwnerHasSpeed(), 2);
		CSWB E 1;
		CSWB F 2 MO_SetHasteTics(1);
		SAWG A 0 A_JumpIf(invoker.OwnerHasSpeed(), 2);
		CSWB GGH 1;
		SAWG A 0 A_JumpIf(invoker.OwnerHasSpeed(), 2);
		CSWB IJK 1;
		TNT1 A 1;
		SAWG A 0 A_JumpIf(invoker.OwnerHasSpeed(), 2);
		CSWS DCBA 1;
		CSWG A 0 A_SetInventory("SpecialAction",0);
		Goto Ready;

	Fire:
		SAWG A 0 
		{
			A_StopSound(1);
			A_WeaponOffset(0,32);
			A_GunFlash(NULL);
			A_StartSound("Chainsword/Start",CHAN_AUTO, CHANF_OVERLAP);
		}
		CSWG EFGH 1;
	ClassicFireHold:
		CSWG ABAB 2
		{
			A_WeaponOffset(random(-2,-1), random(31,35), WOF_INTERPOLATE);
			MO_CSwordAttack(BT_ATTACK, "ClassicFireEnd");
		}
//		SAWG A 0 A_StopSound(0);
		TNT1 A 0 A_StartSound("Chainsword/Loop",CHAN_6,CHANF_LOOPING|CHANF_OVERLAP);
	ClassicFireEnd:
		SAWG B 0 A_ReFire("ClassicFireHold");
		SAWG A 0 A_WeaponOffset(0,32);
		SAWG A 0 A_StopSound(6);
		SAWG A 0 A_StartSound("Chainsword/Stop",0);
		CSWG HGFE 1;
		Goto Ready;

	AltFire:
		SAWG A 0 A_StopSound(1);
		SAWG A 0 A_WeaponOffset(0,32);
		SAWG A 0 A_GunFlash(NULL);
		SAWG A 0 A_StartSound("Chainsword/Start",0, CHANF_OVERLAP);
		CSWS A 1;
		CSWG IJK 1;
		TNT1 A 3;
	Swing1:
		CSW1 A 1;
		CSW1 BC 1;
//		SAWG A 0 A_StopSound(0);
		TNT1 A 0 A_StartSound("Chainsword/Loop",CHAN_6,CHANF_LOOPING|CHANF_OVERLAP);
		CSW1 D 1 A_Saw("", "Machete/Yum", 30, "MO_SawPuff",  SF_NORANDOM|SF_NOPULLIN|SF_NOTURN, 80, 3, 0);
		SAWG A 0 A_JumpIfCloser(80, "SwingHitLoop");
		CSW1 E 1;
	SwingFinished:
		CSW1 FG 1;
		TNT1 A 0 A_SetInventory("ChainswordSwingLeft",1);
		TNT1 A 8;
		TNT1 A 0 A_Refire("Swing2");
		TNT1 A 0 A_SetInventory("ChainswordSwingLeft",0);
		TNT1 A 0 A_StopSound(6);
		TNT1 A 0 A_StartSound("Chainsword/Stop",6);
		CSWG KJI 1;
		Goto Ready;

	SwingHitLoop:
		CSW1 H 1 MO_CSwordAttack(BT_ALTATTACK, "SwingHitEnd");
		CSW1 I 1;
		SAWG A 0 A_JumpIfCloser(90, "SwingHitLoop");
		Goto SwingHitEnd;
		
	SwingHitEnd:
		CSW1 J 1;
		Goto SwingFinished;

	Swing2:
		CSW2 ABC 1;
		CSW2 D 1 A_Saw("", "Machete/Yum", 30, "MO_SawPuff2",  SF_NORANDOM|SF_NOPULLIN|SF_NOTURN, 80, 3, 0);
		SAWG A 0 A_JumpIfCloser(80, "SwingHit2Loop");
		CSW2 E 1;
	Swing2Finished:
		CSW2 FG 1;
		TNT1 A 0 A_SetInventory("ChainswordSwingLeft",0);
		TNT1 A 8;
		TNT1 A 0 A_Refire("Swing1");
		TNT1 A 0 A_StopSound(6);
		TNT1 A 0 A_StartSound("Chainsword/Stop",6);
		CSWG KJI 1;
		Goto Ready;

	SwingHit2Loop:
		CSW2 H 1 MO_CSwordAttack(BT_ALTATTACK, "SwingHit2End");
		CSW2 I 1;
		SAWG A 0 A_JumpIfCloser(90, "SwingHit2Loop");
		Goto SwingHit2End;
		
	SwingHit2End:
		CSW2 J 1;
		Goto Swing2Finished;

	IdleAnimationOffset:
		TNT1 C 3 A_WeaponOffset(1, -1, WOF_ADD);
		TNT1 D 3 A_WeaponOffset(-1,-1, WOF_ADD);
		TNT1 C 3 A_WeaponOffset(-1,1, WOF_ADD);
		TNT1 D 3 A_WeaponOffset(1,1, WOF_ADD);
		Loop;

	FlashKick:
		SAWG A 0 A_GunFlash(NULL);
		SAWG A 0 A_WeaponOffset(0,32);
		"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,"FlashKickFast");
		CSWK ABCDE 1;
		CSWK FGH 2;
		CSWK IJKLM 1;
		CSWG C 1;
		GOTO Ready;	

	FlashAirKick:
		SAWG A 0 A_GunFlash(NULL);
		SAWG A 0 A_WeaponOffset(0,32);
		"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,"FlashAirKickFast");
		CSWK ABCDEFFF 1;
		CSWK GH 2;
		CSWK IIJKLM 1;
		CSWG C 1;
		GOTO Ready;

	FlashAirKickFast:
		SAWG A 0 A_WeaponOffset(0,32);
		CSWK ABCDEF 1;
		CSWK GH 1;
		CSWK IJKLM 1;
		CSWG C 1;
		GOTO Ready;

	FlashKickFast:
		SAWG A 0 A_WeaponOffset(0,32);
		CSWK ABCDE 1;
		CSWK FG 1;
		CSWK IJKLM 1;
		CSWG C 1;
		GOTO Ready;
	
	FlashEquipmentToss:
		SAWG A 0 A_GunFlash(NULL);
		CSWS ABCD 1;
		Goto ThrowThatShitForReal;
	
	FlashEquipmentTossEnd:
		SAWG A 0 A_GunFlash(NULL);
		CSWS DCBA 1;
		Goto Ready;

	}
}

//Based from Brutal Doom's Saw Horizontal Attack
//The reason why it's a projectile rather than using A_Saw is because
//the cutting sound would cut off and not loop properly. This old
//method fixed that. I'll probably find a way later but for now this will do.
Class MO_ChainswordAttack : FastProjectile
{
    Default
    {
        Speed 22;
		Damage 2;
		Height 2;
		Radius 3;
        SeeSound "NULLSND";
	    DeathSound "NULLSND";
		DamageType "CUT";
		Obituary "$OB_CHAINSWORD";
		+FORCEXYBILLBOARD
		+EXTREMEDEATH
		+BLOODSPLATTER
    }
	States
	{
		Spawn:
			TNT1 AAA 1;
            Stop;

		Death:
		Crash:
		TNT1 A 0 A_SpawnItemEx("MO_SawPuff");
		TNT1 A 0 A_StartSound("Chainsword/Hitwall",CHAN_WEAPON);
		TNT1 A 0 Radius_Quake(2,3,0,4,0);
		TNT1 A 10;
		Stop;

		XDeath:
		TNT1 A 0 A_StartSound("Chainsword/Flesh",CHAN_WEAPON);
		TNT1 A 0 Radius_Quake(2,3,0,4,0);
		TNT1 A 10;
		Stop;
    }
}