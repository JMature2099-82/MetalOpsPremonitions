//BFG
class MO_BFG10KFire : MO_ZSToken{}

class MO_BFG9000 : MO_Weapon// replaces BFG9000
{
	action void MO_FireBFG10KShot()
	{
			A_FireBullets(0, 0, 1, 0, "MO_BFG10KShot");
			A_StartSound("bfg/10kfire",0);
			A_FireProjectile("MO_BFG10KShotTracer",0,0,0,0);
			JM_CheckForQuadDamage();
	}

	action void MO_PlayBFGSound()
	{
			A_StartSound("weapons/bfg/startfire", 1);
			A_StartSound("weapons/bfg/chargelayer", 0, CHANF_DEFAULT,1);
	}

	action void MO_SetBFGCrosshair()
	{
		{
				if(FindInventory("MO_BFG10KFire"))
				{
					A_SetCrossHair(invoker.GetXHair(18));
				}
				else 
				{A_SetCrossHair(invoker.GetXHair(14));}
		}
	}

	Default
	{
		Height 20;
		Weapon.AmmoUse1 10;
		Weapon.AmmoGive1 40;
		Weapon.AmmoType "MO_Cell";
		+WEAPON.NOAUTOFIRE;
		Inventory.PickupMessage "$MO_GOTBFG9000";
		Tag "$TAG_MO_BFG9000";
		Inventory.PickupSound "weapons/bfg/draw";
		Weapon.SelectionOrder 2800;
		Obituary "$OBMO_BFG9000";
	}
	States
	{
	SelectAnimation:
		TNT1 A 0 A_StartSound("weapons/bfg/draw",1);
		B7SS ABCDEF 1;
	Ready:
	ReadyToFire:
		B7GG A 0 A_StartSound("weapons/bfg/idleloop", 6, CHANF_LOOPING);
	ReadyLoop:
		BF7G A 0 JM_WeaponReady;
		B7GG AABBCCDDEE 1 JM_WeaponReady;
		Loop;

	Deselect:
		TNT1 A 0 MO_SetBFGCrosshair;
		TNT1 A 0 A_StopSound(6);
		B7SS FEDCBA 1;
		B7GG A 0 A_Lower;
		Wait;

	Select:
		TNT1 A 0;	
		TNT1 A 0 MO_SetBFGCrosshair;
	ContinueSelect:
		TNT1 A 0 MO_Raise();
		Goto SelectAnimation;

	Fire:
		BFGA A 0 A_JumpIfInventory("MO_BFG10KFire",1,"Fire2");
		BFGA A 0 A_JumpIfInventory("MO_Cell",40,1);
		Goto ReadyToFire;
		B7GF A 1 BRIGHT 
		{
			A_GunFlash();
			MO_PlayBFGSound();
		}
		B7GF B 1 BRIGHT;
		B7GF C 1 BRIGHT;
		B7GF D 1 BRIGHT;
        B7GF E 1 BRIGHT;
		B7GF B 1 BRIGHT;
		B7GF C 1 BRIGHT;
		B7GF D 1 BRIGHT;
		B7GF E 1 BRIGHT;
		B7GF B 1 BRIGHT;
		B7GF C 1 BRIGHT;
		B7GF D 1 BRIGHT;
        B7GF EFGH 1 BRIGHT;
        B7GF EFGH 1 BRIGHT;

		B7GF EFGHHI 1 BRIGHT;
        B7GF J 1 
		{
			A_StartSound("weapons/bfg/FIRE", 1);
			for(int i = 4; i > 0; --i)
			{
				if(!invoker.DepleteAmmo(false,true))
				return;
			}
		}
        B7GF K 1 A_FireProjectile("MO_BFGBall",0,0,0,0,0);
		TNT1 A 0 JM_CheckForQuadDamage();
        B7GF L 1 JM_GunRecoil(-5.0, 1.75);
		B7GF M 1
		{
			JM_GunRecoil(-3.3, 1.24);
			A_ZoomFactor(0.94);
		}
		B7GF N 1
		{
			JM_GunRecoil(-2.0, 1);
			A_ZoomFactor(0.97);
		}
		B7GF O 1
		{
			JM_GunRecoil(-1.0, .75);
			A_ZoomFactor(1.0);
		}
		B7GF PQQQRRRR 1 JM_GunRecoil(.5, -.17);
        B7GF SSTTU 1;
		TNT1 A 0 A_ReFire("Fire");
		Goto ReadyToFire;
	
	Flash:
		TNT1 A 26 A_AttachLightDef('GunLighting', 'BFGLightLow');
		TNT1 A 1;
		TNT1 A 2 A_AttachLightDef('GunLighting', 'BFGLight');
		Goto GunLightingDone;

	BFG10KFlash:
		TNT1 A 3 A_AttachLightDef('GunLighting', 'BFGLight');
		TNT1 A 1 A_RemoveLight('GunLighting');
		Stop;

	ActionSpecial:
		TNT1 A 0 A_JumpIfInventory("MO_BFG10KFire",1, "ReturnTo9K");
		TNT1 A 0 A_SetInventory("MO_BFG10KFire",1);
		TNT1 A 0 A_Print("BFG10K Fire", 1);
	ActionSpecialAnim:
		TNT1 A 0 MO_SetBFGCrosshair;
		B7GA A 0 A_StartSound("bfg/switch",1); 
		B7GG FFGHIJ 2;
		TNT1 A 0 A_SetInventory("SpecialAction",0);
		Goto ReadyToFire;
	ReturnTo9K:
		TNT1 A 0 A_Print("Classic BFG Fire", 1);
		TNT1 A 0 A_SetInventory("MO_BFG10KFire",0);
		Goto ActionSpecialAnim;

	//BFG10K Fire mode
	Fire2:
		BFGA A 0 A_JumpIfInventory("MO_Cell",10,1);
		Goto ReadyToFire;
		B7GG A 6;
		B7GG FG 1;
		B7GG H 1 A_WeaponOffset(0,33);
		B7GG H 1 A_WeaponOffset(0,34);
	Fire2Hold:
		BFGA A 0 A_JumpIfInventory("MO_Cell",10,1);
		Goto ReadyToFire;
		B7GA A 0
		{
			MO_FireBFG10KShot();
			A_GunFlash("BFG10KFlash");
			A_WeaponOffset(0,32);
		}
		B7GF KLMN 1 JM_GunRecoil(-.75, .05);
		B7GF TU 1;
		B7GG A 3;
		TNT1 A 0 A_ReFire("Fire2Hold");
		Goto ReadyToFire;
		
	FlashKick:
		B7GK A 0 A_JumpIf(invoker.OwnerHasSpeed(), "FlashKickFast");
		B7GK ABCDEFGGGFFEDCBA 1;
		Goto ReadyToFire;
	FlashKickFast:
		B7GK ABCDEFGGFEDCBA 1;
		Goto ReadyToFire;
		
	FlashAirKick:
		B7GK A 0 A_JumpIf(invoker.OwnerHasSpeed(), "FlashAirKickFast");
		B7GK ABCDEFGGGGGFFEDCBA 1;
		Goto ReadyToFire;
	FlashAirKickFast:
		B7GK ABCDEFGGGGFFFEDCBA 1;
		Goto ReadyToFire;
	Spawn:
		B7UG A -1;
		Stop;
	}
}
//BFG effects, code from Particle Fire Enhancer Mod (v0.8) by Z86
Class MO_BFGBall : BFGBall replaces BFGBall
{
	Default
	{
	  Alpha 1;
	  Scale 1.25;
	  DeathSound "weapons/bfg/explosion";
	  DamageType "Desintegrate";
	  DamageFunction 600;
	  +NOTELEPORT;
	  +ZDOOMTRANS;
		Obituary "$OBMO_BFG9000";
	}
  States
  {
  Spawn:
    NULL A 0;
	NULL A 0 A_StartSound("weapons/bfg/ballfly",6,CHANF_LOOPING,1);
	TNT1 A 0
	{
		for(int i = 3; i > 0; i--)
		{
			A_SpawnItemEx("GreenLightningTiny", -Vel.x, -Vel.y, -Vel.z, Vel.x, Vel.y, Vel.z, 0, SXF_ABSOLUTEMOMENTUM|SXF_ABSOLUTEPOSITION, 172);
			A_SpawnItemEx("GreenLightningSmall", -Vel.x, -Vel.y, -Vel.z, Vel.x, Vel.y, Vel.z, 0, SXF_ABSOLUTEMOMENTUM|SXF_ABSOLUTEPOSITION, 216);
			A_SpawnItemEx("GreenLightningMedium", -Vel.x, -Vel.y, -Vel.z, Vel.x, Vel.y, Vel.z, 0, SXF_ABSOLUTEMOMENTUM|SXF_ABSOLUTEPOSITION, 248);
		}
	}
    BFS1 AB 2 bright Light("BFGBallLight") A_SpawnItem("BFGTrail");
    loop;
  Death:
    NULL A 0;
	NULL A 0 A_StartSound("weapons/bfg/explosionfar",7,CHANF_DEFAULT,0.65);
	NULL A 0 A_StopSound(6);
    NULL AAAAAAAAAAAAAAAAAAAAAAAAAA 0 A_SpawnItemEx("BFGParticle", 0,0,0, (Random(-5,5)), (Random(-5,5)), (Random(-5,5)), 0, SXF_ABSOLUTEMOMENTUM|SXF_NOCHECKPOSITION);
	NULL AAAAAAAAAAAAAAAAAAAAAAAAAA 0 A_SpawnItemEx("BFGParticle", 0,0,0, (Random(-5,5)), (Random(-5,5)), (Random(-5,5)), 0, SXF_ABSOLUTEMOMENTUM|SXF_NOCHECKPOSITION);
	NULL AAAAAAAAAAAAAAAAAAAAAAAAAA 0 A_SpawnItemEx("BFGParticle", 0,0,0, (Random(-5,5)), (Random(-5,5)), (Random(-5,5)), 0, SXF_ABSOLUTEMOMENTUM|SXF_NOCHECKPOSITION);
	NULL AAAAAAAAAAAAAAAAAAAAAAAAAA 0 A_SpawnItemEx("BFGParticle", 0,0,0, (Random(-5,5)), (Random(-5,5)), (Random(-5,5)), 0, SXF_ABSOLUTEMOMENTUM|SXF_NOCHECKPOSITION);
    NULL A 0;
	NULL A 0 A_Explode(250, 200,0);
	//TNT1 A 0 A_SpawnItemEx("GreenFlareBFG8", 0, 0, 0, 0, 0, 0, 0, 0, 0);
	//TNT1 A 0 A_SpawnItemEx("GreenFlareBFG2", 0, 0, 0, 0, 0, 0, 0, 0, 0);
	//TNT1 A 0 A_SpawnItemEx("GreenFlareBFG3", 0, 0, 0, 0, 0, 0, 0, 0, 0);
	TNT1 AAA 0 A_SpawnItemEx("GreenLightningMedium", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 112);
	TNT1 AA 0 A_SpawnItemEx("GreenLightningLarge", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 144);
	NULL A 0 A_SpawnItem("BFGExplosion");
	NULL A 0 A_SpawnItem("MO_GreenShockWave");
	TNT1 A 4 bright;
	TNT1 AAA 0 A_SpawnItemEx("GreenLightningMedium", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 96);
	TNT1 AA 0 A_SpawnItemEx("GreenLightningLarge", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 128);
    TNT1 A 4 bright;
	//TNT1 A 0 A_SpawnItemEx("GreenFlareBFG4", 0, 0, 0, 0, 0, 0, 0, 0, 0)
	//TNT1 A 0 A_SpawnItemEx("GreenFlareBFG6", 0, 0, 0, 0, 0, 0, 0, 0, 0)
	//TNT1 A 0 A_SpawnItemEx("GreenFlareBFG7", 0, 0, 0, 0, 0, 0, 0, 0, 0)	
	TNT1 AAA 0 A_SpawnItemEx("GreenLightningMedium", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 96);
	TNT1 AA 0 A_SpawnItemEx("GreenLightningLarge", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 112);
	TNT1 A 4 bright;
	TNT1 AAA 0 A_SpawnItemEx("GreenLightningMedium", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 96);
	TNT1 AA 0 A_SpawnItemEx("GreenLightningLarge", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 128);
	TNT1 A 4 bright;
	//TNT1 A 0 A_SpawnItemEx("GreenFlareBFG1", 0, 0, 0, 0, 0, 0, 0, 0, 0)
	//TNT1 A 0 A_SpawnItemEx("GreenFlareBFG5", 0, -24, 0, 0, 0, 0, 0, 0, 0)
	//TNT1 A 0 A_SpawnItemEx("GreenFlareBFG5", 0, 24, 0, 0, 0, 0, 0, 0, 0)
	TNT1 AAA 0 A_SpawnItemEx("GreenLightningHuge", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 112);
    NULL A 8 bright A_BFGSpray;  // See BFGExtra	
	TNT1 AAAA 0 A_SpawnItemEx("GreenLightningTiny", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 96);
	TNT1 AAA 0 A_SpawnItemEx("GreenLightningSmall", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 128);
	TNT1 AA 0 A_SpawnItemEx("GreenLightningMedium", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 192);
	NULL A 3 bright;
	TNT1 AAAA 0 A_SpawnItemEx("GreenLightningTiny", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 96);
	TNT1 AAA 0 A_SpawnItemEx("GreenLightningSmall", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 128);
	TNT1 AA 0 A_SpawnItemEx("GreenLightningMedium", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 192);
	NULL A 3 bright;
	TNT1 AAAA 0 A_SpawnItemEx("GreenLightningTiny", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 96);
	TNT1 AAA 0 A_SpawnItemEx("GreenLightningSmall", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 128);
	TNT1 AA 0 A_SpawnItemEx("GreenLightningMedium", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 192);
	NULL A 10 bright;
	TNT1 AAA 0 A_SpawnItemEx("GreenLightningSmall", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 128);
	TNT1 AA 0 A_SpawnItemEx("GreenLightningMedium", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 192);
	NULL A 3 bright;
	TNT1 AAAA 0 A_SpawnItemEx("GreenLightningTiny", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 96);
	TNT1 AAA 0 A_SpawnItemEx("GreenLightningSmall", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 128);
	TNT1 AA 0 A_SpawnItemEx("GreenLightningMedium", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 192);
	NULL A 3 bright;
	TNT1 AAAA 0 A_SpawnItemEx("GreenLightningTiny", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 96);
	TNT1 AAA 0 A_SpawnItemEx("GreenLightningSmall", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 128);
    stop;
  }
}

class BFGExplosion : BaseVisualSFX
{
	Default
	{
	  +NoGravity
	  +NoInteraction
	  +NoBlockmap
	  Scale 1.25;
	  Renderstyle "Translucent";
	  Alpha 0.76;
	}
  States
  {
  Spawn:
    TNT1 A 0;
	TNT1 A 0 A_SpawnItemEx("GreenExplosionFlare", 0, 0, 6, 0, 0, 0, 0, 0, 0);
	//NULL A 0 A_SpawnItem("BoomGreen")
    TNT1 AAAAAAAAAAAAAA 0 A_SpawnItemEx("LLGreenFireLarge", Random(-3, 3), Random(-8, 8), Random(-3, 3), (0.01)*Random(-90, 90), (0.016)*Random(-90, 90), (0.01)*Random(-90, 90), 0, SXF_NOCHECKPOSITION, 8);
    BFGB ABCDEFG 2 Bright A_FadeOut(0.05);
    stop;
  }
}

class BFG10KExplosion : BFGExplosion
{
	Default
	{
	  Renderstyle "Translucent";
	  Alpha 0.6;
	}
  States
  {
  Spawn:
    TNT1 A 0;
	TNT1 A 0 A_SpawnItemEx("GreenExplosionFlare", 0, 0, 6, 0, 0, 0, 0, 0, 0);
	//NULL A 0 A_SpawnItem("BoomGreen")
    TNT1 AAAAAAA 0 A_SpawnItemEx("LLGreenFireLarge", Random(-3, 3), Random(-8, 8), Random(-3, 3), (0.01)*Random(-90, 90), (0.016)*Random(-90, 90), (0.01)*Random(-90, 90), 0, SXF_NOCHECKPOSITION, 8);
    BFGB ABCDEFG 1 Bright;
    stop;
  }
}

Class BFGTrail : BaseVisualSFX
{
	Default
	{
	  RenderStyle "Add";
	  Scale 0.15;
	  Alpha 0.9;
	}
  States
  {
  Spawn:
    BFBC A 1 Bright A_FadeOut(0.02);
    loop;
  }
}

Class BFGParticle : Actor
{
	Default
	{
	  +NOGRAVITY;
	  +NOTELEPORT;
	  +ForceXYBillboard;
	  +CLIENTSIDEONLY;
	  +Doombounce;
	  +missile;
	  +THRUACTORS;
	  +dontsplash;
	  Bouncecount 3;
	  Radius 3;
	  Height 6;
	  Speed 6;
	  RenderStyle 'Add';
	  Alpha 0.9;
	  Scale 0.12;
	}
  States
  {
  Spawn:
    BFPA A 1 bright A_FadeOut(0.01);
    loop;
  }
}

class MO_BFGExtra : BFGExtra replaces BFGExtra
{
	Default
	{
	Alpha 1;
	Scale 0.5;
	Obituary "$OBMO_BFG9000SPLSH";
	}
  States
  {
  Spawn:
    NULL A 0;
	NULL A 0;//A_SpawnDebris("GreenPlasmaSpark");
	NULL A 0;// A_SpawnItem("GreenPlasmaSmoke");
	NULL A 0 A_SpawnItem("GreenExplosionFlareSmallFaded");
	//TNT1 A 0 A_SpawnItemEx("GreenFlareBFG2", 0, 0, 0, 0, 0, 0, 0, 0, 0)
	//TNT1 A 0 A_SpawnItemEx("GreenFlareBFG3", 0, 0, 0, 0, 0, 0, 0, 0, 0)
	TNT1 AAAAAAAAAAAAAA 0 A_SpawnItemEx("LLGreenFireSmall", Random(-3, 3), Random(-4, 4), Random(-3, 3), (0.01)*Random(-90, 90), (0.01)*Random(-90, 90), (0.01)*Random(-90, 90), 0, SXF_NOCHECKPOSITION, 8);
	//NULL A 0 A_SpawnItem("BoomGreenSmall")
	BFXF A 6 bright Light("BFGXLight1");
	TNT1 AAA 0 A_SpawnItemEx("GreenLightningTiny", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 96);
	TNT1 AA 0 A_SpawnItemEx("GreenLightningSmall", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 128);
	TNT1 A 0 A_SpawnItemEx("GreenLightningMedium", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 192);
	BFXF B 6 bright Light("BFGXLight2");
	TNT1 AAA 0 A_SpawnItemEx("GreenLightningTiny", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 96);
	TNT1 AA 0 A_SpawnItemEx("GreenLightningSmall", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 128);
	BFXF C 6 bright Light("BFGXLight2");
	TNT1 AAA 0 A_SpawnItemEx("GreenLightningTiny", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 96);
	TNT1 AA 0 A_SpawnItemEx("GreenLightningSmall", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 128);
	BFXF D 6 bright Light("BFGXLight1");
	TNT1 AAA 0 A_SpawnItemEx("GreenLightningTiny", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 96);
	TNT1 AA 0 A_SpawnItemEx("GreenLightningSmall", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 128);
	BFXF E 6 bright Light("BFGXLight1");
	TNT1 AAA 0 A_SpawnItemEx("GreenLightningTiny", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 96);
	TNT1 AA 0 A_SpawnItemEx("GreenLightningSmall", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 128);
    //BFXF ABCDE 6 bright
    stop;
  }
}

Class MO_BFG10KShot : Actor
{
  Default
  {
    Radius 11;
    Height 8;
    Speed 20;
    DamageFunction 75 ;
    DamageType "extreme";
    Renderstyle "Add";
    Alpha 0.75;
    +NoBlockMap
    +NoGravity
    +ActivateImpact
    +ActivatePCross
    +NoTeleport
    +PuffOnActors
    +PuffGetsOwner
    +ForceRadiusDmg
	 Obituary "$OBMO_BFG10K";
  }

  States
  {
  Spawn:
    BFE1 A 0 Bright;
	BFE1 A 0 A_StartSound("bfg/10expl", 7);
	BFE1 A 0 A_StartSound("bfg/10explfar", CHAN_AUTO, attenuation: ATTN_NONE);
    BFE1 A 0 Bright A_Explode(160, 128, XF_HURTSOURCE);
	BFE1 A 0 A_SpawnItemEx("BFG10KExplosion",flags:SXF_NOCHECKPOSITION);
	BFE1 A 0 A_SpawnItemEx("MO_GreenShockWaveSmall", flags:SXF_NOCHECKPOSITION);
	TNT1 AAAAA 0 A_SpawnProjectile ("MO_GreenExplosionFlames", 2, 0, random (0, 360), 2, random (0, 360));
    TNT1 A 2 bright;
	TNT1 AAA 0 A_SpawnItemEx("GreenLightningTiny", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 96);
	TNT1 AA 0 A_SpawnItemEx("GreenLightningSmall", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 128);
    TNT1 A 2 bright;
	TNT1 AAA 0 A_SpawnItemEx("GreenLightningTiny", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 96);
	TNT1 AA 0 A_SpawnItemEx("GreenLightningSmall", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 112);
	TNT1 A 2 bright;
	TNT1 AAA 0 A_SpawnItemEx("GreenLightningSmall", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 96);
	TNT1 AA 0 A_SpawnItemEx("GreenLightningMedium", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 128);
	TNT1 A 2 bright;
	TNT1 AAA 0 A_SpawnItemEx("GreenLightningLarge", Random(-8, 8), Random(-8, 8), Random(-8, 8), 0, 0, 0, 0, 0, 112);
    Stop;
  }
}