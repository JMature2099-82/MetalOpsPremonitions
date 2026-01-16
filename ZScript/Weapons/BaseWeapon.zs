class MO_Weapon : Weapon
{
	bool isFirstTime;
	property firstTime: isFirstTime;
	bool isHoldingAim;
	sound dryFireSound;
	property DryFireSound : dryFireSound;
	int adsMode;
	string inspectToken;
	property InspectToken: inspectToken;
	bool isZoomed;

	const prevBobRangeX = 0.3;
	const prevBobRangeY = 0.3;
	const prevBobSpeed = 1.5;

	//weapons should ALWAYS bob, fucking fight me -popguy
	override void DoEffect()
	{
		super.DoEffect();
		let player = owner.player;
		adsMode =  Cvar.GetCvar("mo_aimmode",player).GetInt();
		Cvar Bobbing = Cvar.GetCvar("MTOps_AlwaysBob",player);
		if (player && player.readyweapon)
		{
			player.WeaponState |= WF_WEAPONBOBBING;
		}
	}

	override void PostBeginPlay()
	{	
			isZoomed = false;
			isHoldingAim = false;
	}

	override void MarkPrecacheSounds()
	{
		Super.MarkPrecacheSounds();
		MarkSound(dryFireSound);
	}

    Default
    {
        Weapon.BobStyle "InverseSmooth";
        Weapon.BobRangeX 0.3;
		Weapon.BobRangeY 0.6;
		Weapon.BobSpeed 1.5;
        +DONTGIB;
        Inventory.PickupMessage "$GOTPLACEHOLDER";
    }
	
	States
	{
		
		Select:
		ContinueSelect:
			TNT1 A 0;
			TNT1 A 1 MO_Raise();
		SelectAnimation:
			TNT1 A 0;
			TNT1 A 1;
			Goto Ready;

		ClearAudioAndResetOverlays:
			TNT1 A 1;
			TNT1 A 0 {
				MO_ResetBob();
				A_StopSound(CHAN_5);
				A_StopSound(CHAN_WEAPON);
				A_StopSound(CHAN_6);
				A_STOPSOUND(CHAN_7);
				SetPlayerProperty(0,0,0);
				A_ClearOverlays(-8,8);
				A_OverlayFlags(PSP_KICK, PSPF_PLAYERTRANSLATED, FALSE);
				A_RemoveLight('GunLighting');
				}
			TNT1 A 0 A_Jump(255, "ContinueSelect");
			Loop;
		Deselect:
			TNT1 A 1 A_Lower();
			Loop;

		GunLightingDone:
			TNT1 A 2 A_RemoveLight('GunLighting');
			Stop;
			
		Ready:
		FIRE:
		ReallyReady:
			"####" A 0;
			"####" AAAA 1 A_Jump(256, "readytofire");
			Loop;

		BackToWeapon:
			TNT1 A 1 
			{
				if(ResolveState("FlashEquipmentTossEnd"))
					{return ResolveState("FlashEquipmentTossEnd");}
				else if(ResolveState("SelectAnimation"))
					{return ResolveState("SelectAnimation");}
				return ResolveState(Null);
			}
			Goto ReallyReady;
			
		Kick: //16 frames
			"####" A 0 A_ZoomFactor(1.0);
			"####" A 0 A_StopSound(CHAN_VOICE);
			"####" A 0 {invoker.isZoomed = False;}
			"####" A 0 A_JumpIf (vel.Z != 0, "AirKick");
			"####" A 0;
			"####" A 0 
			{
				SetPlayerProperty(0,1,0);
				A_OverlayFlags(PSP_KICK, PSPF_PLAYERTRANSLATED, TRUE);
				A_OverlayFlags(PSP_KICK, PSPF_ADDWEAPON, FALSE);
				A_OverlayOffset(PSP_KICK, -1, 32);
				If(invoker.OwnerHasSpeed()) {return ResolveState("KickFaster");}
				{return ResolveState(Null);}
			}
			KCK1 ABC 1;
			"####" A 0 A_StartSound("playerkick",0);
			KCK1 DEF 1;
			KCK1 G 1 MO_KickAttack;
			KCK1 GHG 1;
			KCK1 FEDCBA 1;
			TNT1 A 0 A_OverlayFlags(PSP_KICK,PSPF_PLAYERTRANSLATED,FALSE);
			TNT1 A 0 SetPlayerProperty(0,0,0);
			Stop;
		
		KickFaster:
			KCK1 ABC 1;
			"####" A 0 A_StartSound("playerkick",0);
			KCK1 DF 1;
			KCK1 G 1 MO_KickAttack;
			KCK1 HG 1;
			KCK1 FEDCA 1;
			TNT1 A 0 A_OverlayFlags(PSP_KICK,PSPF_PLAYERTRANSLATED,FALSE);
			TNT1 A 0 SetPlayerProperty(0,0,0);
			Stop;
		AirKick: //18 frames
			"####" A 0 ThrustThing(angle * 256 / 360, 3, 0, 0);
			"####" A 0 
			{
				A_OverlayFlags(PSP_KICK, PSPF_PLAYERTRANSLATED, TRUE);
				A_OverlayFlags(PSP_KICK, PSPF_ADDWEAPON, FALSE);
				A_OverlayOffset(PSP_KICK, -1, 32);
			}
			"####" A 0 A_JumpIf(invoker.OwnerHasSpeed(), "AirKickFaster");
			KCK2 ABC 1;
			"####" A 0 A_StartSound("playerkick",0);
			KCK2 DE 1;
			KCK2 F 1 MO_KickAttack;
			KCK2 GHHHHII 1;
			KCK2 JKLMN 1;
			"####" A 0 A_OverlayFlags(PSP_KICK, PSPF_PLAYERTRANSLATED, false);
			Stop;
		
		AirKickFaster:
			KCK2 ABC 1;
			"####" A 0 A_StartSound("playerkick",0);
			KCK2 DE 1;
			KCK2 F 1 MO_KickAttack;
			KCK2 GHHII 1;
			KCK2 JKLN 1;
			"####" A 0 A_OverlayFlags(PSP_KICK, PSPF_PLAYERTRANSLATED, false);
			Stop;
				
		FlashKick:
		FlashAirKick:
				TNT1 A 0 A_JumpIf(invoker.OwnerHasSpeed(), "FlashKickFast");
				TNT1 A 16;
				Goto ReallyReady;

		FlashKickFast:
				TNT1 A 14;
				Goto ReallyReady;
		
		//From the PB Add-on	
		TossThrowable:
			"####" "#" 1;
			"####" "#" 0 {
				if(player.readyweapon.GetClassName() == "MO_HeavyRifle" && CountInv("HCR_3XZoom") >= 1 || CountInv("HCR_6XZoom") >= 1)
				{
					A_Print("You can't throw while in sniper mode!");
					return ResolveState("ReallyReady");
				}
				if(CountInv("ThrowableType") == 1)
				{return ResolveState("ThrowMolotov");}
				else
				{return ResolveState("ThrowGrenade");}
				return resolvestate(null);
			}
			Goto Ready;
			
		FlashEquipmentToss:
		ThrowThatShitForReal:
			TNT1 A 1;
			TNT1 A 0
			{
				if(CountInv("ThrowableType") == 1)
				{return ResolveState("PrepareMolotovToss");}
				else
				{return ResolveState("PrepareGrenadeToss");}
				return resolvestate(null);
			}
			Goto Ready;
			
			
		ThrowMolotov:
			"####" "#" 0;
			"####" "#" 0 A_ZoomFactor(1.0);
			"####" "#" 0 A_StopSound(6);
			"####" "#" 0 A_StopSound(CHAN_VOICE);
			"####" "#" 0 MO_CheckEquipmentToss("MolotovAmmo",1, "PrepareMolotovToss");
			"####" "#" 0 A_Print("No Molotov Cocktails left");
			Goto ReallyReady;
		PrepareMolotovToss:
			"####" "#" 0 A_JumpIfInventory("MolotovAmmo", 1, 2);
			"####" "#" 0 A_Print("No Molotov Cocktails left");
			Goto ReallyReady;
			TNT1 AAA 0;
			TNT1 A 0 A_WeaponOffset(0,32);
			MTOV AB 1;
			TNT1 A 0 A_StartSound("Molotov/Open",0);
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			MTOV DEE 1;
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			MTOV FGH 1;
			MTOV I 1 A_StartSound("Molotov/Lit",1);
			MTOV JKL 1;
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			MTOV MNO 1;
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			MTOV P 1;
			MTOV Q 1 A_StartSound("Molotov/Flame",0,CHANF_DEFAULT,2.0);
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			MTOV RSTU 1;
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			MTOV V 1;
			MOLO A 0 A_StartSound("Molotov/Close", 5);
			MTOV WX 1;
			TNT1 A 0;
			TNT1 A 4 MO_SetHasteTics(2);
			TNT1 A 0 A_JumpIf(PressingWhichInput(BT_USER1), "PrepareMolotovHold");
			Goto TossMolotov;

		PrepareMolotovHold:
			TNT1 A 0 A_Overlay(-10, "AimThrowable");	
		HoldMolotov:
			TNT1 A 1;
			TNT1 A 0 A_JumpIf(PressingWhichInput(BT_USER1), "HoldMolotov");
			TNT1 A 0 A_Overlay(-10, "StopHandAim");	
			//HND1 I 2
		TossMolotov:
			TNT1 A 2;
			TNT1 A 0 A_StartSound("MOLTHRW",0,CHANF_DEFAULT,2.0);
			GRE1 AB 1;
			GRE1 C 1;
			MTOV A 0 
			{
				A_FireProjectile("MO_MolotovThrown",0,0,0,0,FPF_NOAUTOAIM,0);
				A_TakeInventory("MolotovAmmo", 1, TIF_NOTAKEINFINITE);
			}
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			GRE1 DEFG 1;
			GRE1 HI 1;
			TNT1 A 5 MO_SetHasteTics(3);
			TNT1 A 0 A_JumpIf(PressingWhichInput(BT_USER1), "PrepareMolotovToss");
			Goto BackToWeapon;

		AimThrowable:
			GRNH EDCB 1;
		AimThrowableLoop:
			GRNH A 1;
			Loop;

		StopHandAim:
			GRNH BCDE 1;
			TNT1 A 1;
			Stop;
		
		ExplodeOnYerFace:
			TNT1 A 1
			{
					A_Overlay(-10,"StopHandAim");
	//				ACS_NamedTerminate("GrenadeFuseTick",0);
					A_Explode(125, 220,XF_HURTSOURCE);
					A_AlertMonsters();
					A_StartSound("rocket/explosion", 0);
					A_SpawnItemEx("RocketExplosionFX",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
					A_SetInventory("GrenadeCookTimer",0);
			}
			TNT1 AAAAAA 1;
			Goto BackToWeapon;
			
		ThrowGrenade:
			"####" "#" 0 A_ZoomFactor(1.0);
			"####" "#" 0 A_StopSound(6);
			"####" "#" 0 A_StopSound(CHAN_VOICE);
			"####" "#" 0 MO_CheckEquipmentToss("GrenadeAmmo",1, "PrepareGrenadeToss");
			"####" "#" 0 A_Print("No Frag Grenades left");
			Goto ReallyReady;
		PrepareGrenadeToss:
			"####" "#" 0 A_JumpIfInventory("GrenadeAmmo", 1, 2);
			"####" "#" 0 A_Print("No Molotov Cocktails left");
			Goto ReallyReady;
			TNT1 AAA 0;
			TNT1 A 0 A_WeaponOffset(0,32);
			GREP ABCD 1;
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			GREP EFG 1;
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			GREP GH 1;
			TNT1 A 0 A_StartSound("FragGrenade/Pin",0);
			GREP H 1;
			TNT1 A 0 A_TakeInventory("GrenadeAmmo", 1, TIF_NOTAKEINFINITE);
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			GREP IJKL 1;
			TNT1 A 3 MO_SetHasteTics(1);
			TNT1 A 0 A_JumpIf(PressingWhichInput(BT_USER1), "CookingGrenade");
		TossTheGrenade:
//			TNT1 A 2 ACS_NamedTerminate("GrenadeFuseTick",0);
			GRE1 AB 1;
			TNT1 A 0 A_StartSound("FragGrenade/Throw",0,CHANF_DEFAULT,2.0);
			GRE1 C 1;
			MTOV A 0 A_FireProjectile("MO_ThrownGrenade",0,0,0,8,FPF_NOAUTOAIM,0);
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
			GRE1 DEFG 1;
			TNT1 A 0 A_SetInventory("GrenadeCookTimer",0);
			GRE1 HI 1;
			TNT1 A 4 MO_SetHasteTics(2);
			TNT1 A 0 A_JumpIf(PressingWhichInput(BT_USER1), "PrepareGrenadeToss");
			Goto BackToWeapon;

		CookingGrenade:
//			TNT1 A 0 ACS_NamedExecute("GrenadeFuseTick",0);
			TNT1 A 0 A_StartSound("FragGrenade/Timer", 7);
			TNT1 A 2;
			TNT1 A 0 A_Overlay(-10, "AimThrowable");	
//			TNT1 A 0 A_JumpIf(invoker.isCookingGrenade, "HoldGrenade");
		CookingGrenadeHold:
			TNT1 A 1 A_GiveInventory("GrenadeCookTimer", 1);			
			TNT1 A 0 A_JumpIf(CountInv("GrenadeCookTimer") == 105, "ExplodeOnYerFace");
			TNT1 A 0 A_JumpIf(PressingWhichInput(BT_USER1), "CookingGrenadeHold");
			TNT1 A 0 A_Overlay(-10, "StopHandAim");
			Goto TossTheGrenade;

		HoldGrenade:
			TNT1 A 1;
			TNT1 A 0 A_JumpIf(PressingWhichInput(BT_USER1), "HoldGrenade");
			TNT1 A 0 A_Overlay(-10, "StopHandAim");
			Goto TossTheGrenade;
		}
}

class JMWeapon : MO_Weapon{}