class MO_DickKickEm : CustomInventory
{
	bool kicking;
	Default
    {
		+INVENTORY.UNDROPPABLE
		-INVENTORY.INVBAR
		+INVENTORY.UNTOSSABLE
		Inventory.PickUpMessage "$GOTPLACEHOLDER";
    }
	States
	{
		Use:
	        TNT1 A 0 A_Overlay(PSP_KICK, "Kick",true);
			TNT1 A 0 A_OverlayOffset(PSP_KICK, 0, 32);
			TNT1 AAA 0;
			Fail;
		
		Kick: //16 frames
			TNT1 A 0 A_StopSound(CHAN_VOICE);
			TNT1 A 0 A_JumpIf (vel.Z != 0, "AirKick");
			TNT1 A 0 
			{
				SetPlayerProperty(0,1,0);
				A_OverlayFlags(PSP_KICK, PSPF_PLAYERTRANSLATED, TRUE);
				A_OverlayFlags(PSP_KICK, PSPF_ADDWEAPON, FALSE);
			}
			TNT1 A 0 A_JumpIf(invoker.MO_CheckHaste(), "KickFaster");
			KCK1 ABC 1;
			TNT1 A 0 A_StartSound("playerkick",0);
			KCK1 DEF 1;
			KCK1 G 1 MO_KickAttack();
			KCK1 GHG 1;
			KCK1 FEDCBA 1;
			TNT1 A 0 A_OverlayFlags(PSP_KICK,PSPF_PLAYERTRANSLATED,FALSE);
			TNT1 A 0 SetPlayerProperty(0,0,0);
			TNT1 A 0 {invoker.kicking = false;}
			Stop;
		
		KickFaster: //14 frames
			KCK1 ABC 1;
			TNT1 A 0 A_StartSound("playerkick",0);
			KCK1 DF 1;
			KCK1 G 1 MO_KickAttack();
			KCK1 HG 1;
			KCK1 FEDCA 1;
			TNT1 A 0 A_OverlayFlags(PSP_KICK,PSPF_PLAYERTRANSLATED,FALSE);
			TNT1 A 0 SetPlayerProperty(0,0,0);
			TNT1 A 0 {invoker.kicking = false;}
			Stop;
		AirKick: //18 frames
			TNT1 A 0 ThrustThing(angle * 256 / 360, 3, 0, 0);
			TNT1 A 0 
			{
				A_OverlayFlags(PSP_KICK, PSPF_PLAYERTRANSLATED, TRUE);
				A_OverlayFlags(PSP_KICK, PSPF_ADDWEAPON, FALSE);
			}
			TNT1 A 0 A_JumpIf(invoker.MO_CheckHaste(), "AirKickFaster");
			KCK2 ABC 1;
			TNT1 A 0 A_StartSound("playerkick",0);
			KCK2 DEF 1;
			KCK2 G 1 MO_KickAttack();
			KCK2 HHHHII 1;
			KCK2 JKLMN 1;
			TNT1 A 0 A_OverlayFlags(PSP_KICK, PSPF_PLAYERTRANSLATED, false);
			TNT1 A 0 {invoker.kicking = false;}
			Stop;
		
		AirKickFaster: //15 frames
			KCK2 ABC 1;
			TNT1 A 0 A_StartSound("playerkick",0);
			KCK2 DEF 1;
			KCK2 G 1 MO_KickAttack();
			KCK2 GHHII 1;
			KCK2 JKLN 1;
			TNT1 A 0 A_OverlayFlags(PSP_KICK, PSPF_PLAYERTRANSLATED, false);
			TNT1 A 0 {invoker.kicking = false;}
			Stop;

	}
	
	override void DoEffect()
    {
        Super.DoEffect();
		if(!owner) return;
		
		if(owner is "PlayerPawn" && JustPressedKick() && !kicking)
		{
			if(!CheckZoomed())
			{
				owner.UseInventory(self);
				kicking = true;
				CheckForFlashState();
			}
		}
    }
	
	bool MO_CheckHaste()
	{
		let weapon = MO_Weapon(owner.player.readyweapon);
		
		return weapon.OwnerHasSpeed();
	}
	
	void CheckForFlashState()
	{
		let weapon = MO_Weapon(owner.player.readyweapon);
        if(!weapon) return;

		
		bool zoomed = weapon.isZoomed;
		State FlashKick = weapon.FindState("FlashKick");
		State FlashAirKick = weapon.FindState("FlashAirKick");
		
		if(!zoomed)
		{
			if(FlashKick != NULL && (weapon && weapon.CheckIfInReady()))
			{
				if(FlashAirKick != NULL && owner.Vel.Z != 0)
				owner.player.SetPSprite(PSP_Weapon, weapon.FindState("FlashAirKick"));
				else
				owner.player.SetPSprite(PSP_Weapon, weapon.FindState("FlashKick"));
			}
		}
	}
	
	bool CheckZoomed()
	{
		let weapon = MO_Weapon(owner.player.readyweapon);
		
		return weapon.isZoomed;
	}
	
	bool JustPressedKick()
    {
        return owner.player.cmd.buttons & BT_ZOOM && !(owner.player.oldbuttons & BT_ZOOM);
    }
	
	action void MO_KickAttack()
	{
		let weapon = MO_Weapon(player.readyweapon);
		
		FTranslatedLineTarget t;
		int dmg = 35;
		double ang = angle + Random2() * (5.625 / 256);
        double pitch = AimLineAttack(ang, 64, null, 0., ALF_CHECK3D);
		
		if(!weapon) return;
		
		if(weapon.OwnerHasBerserk())
		{	
			if(player.health < 30)
			LineAttack(ang, 75, pitch, dmg * 3, 'ExtremePunches', "BerserkKickPuff", LAF_ISMELEEATTACK,t);
			else
			 LineAttack(ang, 75, pitch, dmg * 2, 'ExtremePunches', "BerserkKickPuff", LAF_ISMELEEATTACK,t);
		}
		else
		{
			if(player.health < 30)
			LineAttack(ang, 75, pitch, dmg * 1.5, 'Kick', "KickingPuff", LAF_ISMELEEATTACK,t);
			else
			LineAttack(ang, 75, pitch, dmg, 'Kick', "KickingPuff", LAF_ISMELEEATTACK,t);
		}
		
        if (t.linetarget)
        {
			Actor victim = t.linetarget;
			 if(victim.bISMONSTER)
				A_StartSound("playerkick/hit",1);
			else
				A_StartSound("playerkick/footwall",1);
        }
	}
}				
