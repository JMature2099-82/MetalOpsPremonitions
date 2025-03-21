extend class JMWeapon
{
	bool OwnerHasSpeed()
	{
		return (owner.CountInv("MO_PowerSpeed") >= 1);
	}

	 //Credits: Matt
    action bool JustPressed(int which) // "which" being any BT_* value, mentioned above or not
    {
        return player.cmd.buttons & which && !(player.oldbuttons & which);
    }
    action bool JustReleased(int which)
    {
        return !(player.cmd.buttons & which) && player.oldbuttons & which;
    }

    //Based on IsPressingInput from Project Brutality
    action bool PressingWhichInput(int which)
    {
        return player.cmd.buttons & which;
    }
	
	action void JM_CheckForQuadDamage()
	{
		If(CheckInventory("MO_PowerQuadDmg",1))
		{
			A_StartSound("powerup/quadfiring",70, CHANF_DEFAULT,3.0,ATTN_NONE);
		}
	}

//Holy shit I can't believe I got this working
	int GetXHair(int w)
	{
		static const string weaponPrefix[] =
		{
			"Pistol", "Deagle", "MP40", "SMG", "LAS", "PSG", "SSG", "Rifle", "HMR", "Chaingun",
			"RL", "RLGuided", "Plasma", "Rail", "BFG",  "Unmaker","Flamer", "HMR_GL", "BFG10K",
			"HeatPlasma"
		};
		string weaponCVar = "mo_xhair".. String.Format("%s", weaponPrefix[w]);
		if(owner.GetCvar("mo_customxhairs"))
		return owner.GetCvar(weaponCvar);
		else
		return 0;
	}
	
	action void JM_SetWeaponSprite(string s)
	{
		if(!player) return;
		 let psp = player.GetPSprite(PSP_WEAPON);
		 psp.sprite = GetSpriteIndex(s);
	}
	
	action bool PressingFire(){return player.cmd.buttons & BT_ATTACK;}
    action bool PressingAltfire(){return player.cmd.buttons & BT_ALTATTACK;}

	action state MO_CheckMag(int m = 1, statelabel where = "Reload")
	{
		if(invoker.Ammo2.amount  < m)
			return ResolveState(where);
		return ResolveState(Null);
	}

	//Based on the Set and Check functions from Project Brutality
	action void JM_SetInspect(bool type)
	{
		invoker.isFirstTime = type;
	}
	
	action bool JM_CheckInspect()
	{
		return invoker.isFirstTime;
	}

	action void JM_CheckInspectIfDone()
	{
			Actor theOwner = invoker.owner;
			let wep = player.readyweapon;
			State Inspect = wep.FindState("Inspect");
			bool notInspected = invoker.inspectToken != "" && theOwner.CountInv(invoker.inspectToken);
			if(notInspected && Inspect != NULL)
			{
				theOwner.TakeInventory(invoker.inspectToken,1);
				theOwner.player.SetPSprite(PSP_WEAPON,wep.FindState("Inspect"));
			}
	}

	action void MO_ZoomBob()
	{
		invoker.BobRangeX = .1;
		invoker.BobRangeY = .1;
		invoker.BobSpeed = .5;
	}

	action void MO_ResetBob()
	{
		invoker.BobRangeX = prevBobRangeX;
		invoker.BobRangeY = prevBobRangeY;
		invoker.BobSpeed = prevBobSpeed;
	}
				
	//By Matt. Perfect to go around the Return state/ResolveState headache
	action void SetWeaponState(statelabel st,int layer=PSP_WEAPON)
    {
        if(player) player.setpsprite(layer,invoker.findstate(st));
    }
// Don't complain if this is an action state rather than an action void
// I found it easier an action state in terms of returning to state labels.
	action state JM_WeaponReady(int wpflags = 0)
	{	
		A_WeaponReady(wpflags);
		if(JustPressed(BT_USER1))
		{
			if(CheckIfInReady())
			return ResolveState("TossThrowable");
		}
		if(JustPressed(BT_USER4) && CheckIfInReady())
		{
			State ActionSpecial = invoker.owner.player.ReadyWeapon.FindState("ActionSpecial");
			if(ActionSpecial != NULL)
				return ResolveState('ActionSpecial');
			else	
			return null;		
		}	
		return null;
	}
	
	action bool CheckIfInReady()
	{
		if ( (InStateSequence(invoker.owner.player.GetPSprite(PSP_WEAPON).Curstate,invoker.ResolveState("Ready")) || 
			  InStateSequence(invoker.owner.player.GetPSprite(PSP_WEAPON).Curstate,invoker.ResolveState("ReadyToFire"))||
			  InStateSequence(invoker.owner.player.GetPSprite(PSP_WEAPON).Curstate,invoker.ResolveState("ReadyToFire2"))||
			InStateSequence(invoker.owner.player.GetPSprite(PSP_WEAPON).Curstate,invoker.ResolveState("Ready2"))||
			InStateSequence(invoker.owner.player.GetPSprite(PSP_WEAPON).Curstate,invoker.ResolveState("ADSToggle"))||
			InStateSequence(invoker.owner.player.GetPSprite(PSP_WEAPON).Curstate,invoker.ResolveState("ADSHold"))||
			InStateSequence(invoker.owner.player.GetPSprite(PSP_WEAPON).Curstate,invoker.ResolveState("SniperReady"))||
			InStateSequence(invoker.owner.player.GetPSprite(PSP_WEAPON).Curstate,invoker.ResolveState("SniperToggle"))||
			InStateSequence(invoker.owner.player.GetPSprite(PSP_WEAPON).Curstate,invoker.ResolveState("SniperHold"))||
			  InStateSequence(invoker.owner.player.GetPSprite(PSP_WEAPON).Curstate,invoker.ResolveState("ReadyLoop"))
			 ) )
		{		
			return true;
		}
		return false;
	}
	
	action void JM_ReloadGun(name magammo, name reserve, int magMax, int reserveTake)
	{
		for(int i = 0; i < magMax; i++)
		{
			if(CountInv(reserve) < 1 || CountInv(magammo) == magMax) 
			return;
			
			A_GiveInventory(magammo, 1);
			A_TakeInventory(reserve, reserveTake, TIF_NOTAKEINFINITE);
		}
	}
	
//Basically A_TakeInventory but with the TIF_NOTAKEINIFNITE Flag built in, for the ammo
	action void JM_UseAmmo(name ammotype, int count)
	{
		A_TakeInventory(ammotype, count, TIF_NOTAKEINFINITE);
	}

	action void JM_GunRecoil(float gunPitch, float gunAngle)
	{
		CVar checkRecoil = CVar.GetCVar("mo_nogunrecoil", player);
		bool noRecoil = checkRecoil.GetBool();
		if(!noRecoil && GetCvar("freelook") == true)
		{
			A_SetPitch(pitch+gunPitch, SPF_INTERPOLATE);
			A_SetAngle(angle+gunAngle, SPF_INTERPOLATE);
		}
	}
}