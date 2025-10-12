extend class MO_Weapon
{
	bool OwnerHasSpeed()
	{
		return (owner.CountInv("MO_PowerSpeed") >= 1);
	}

	bool OwnerHasInfiniteAmmo()
	{
		return (owner.FindInventory("PowerInfiniteAmmo") || GetCvar("sv_infiniteammo"));
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

	bool OwnerHasBerserk()
	{
		return (owner.FindInventory("MO_PowerStrength"));
	}


//This is a custom function that replaces A_Raise for Metal Ops weapns!
//This function gets rid of the need for TNT1 AAAAAAAAAAAAAAAAAA 0 A_Raise(),
//the ClearAudioAndResetOverlays and ContinueSelect state, and also frees up the Ready state.
//This was added to simplify the weapons.
	action void MO_Raise()
	{
		A_Raise(12);
		A_WeaponOffset(0,32);
	
//This was originally from the ClearAudioAndResetOverlays state.
		MO_ResetBob();
		A_StopSound(CHAN_5);
		A_StopSound(CHAN_WEAPON);
		A_StopSound(CHAN_6);
		A_STOPSOUND(CHAN_7);
		invoker.isZoomed = false;
		invoker.isHoldingAim = false;
		A_SetInventory("MinigunSpin",0);
		A_SetInventory("SpecialAction",0);
		A_ZoomFactor(1);
		SetPlayerProperty(0,0,0);
		A_ClearOverlays(-8,8);
		A_OverlayFlags(-999, PSPF_PLAYERTRANSLATED, FALSE);
		A_RemoveLight('GunLighting');
	}

//Shortcut function for Haste when reloading. No more using
//if statements with A_SetTics. Use this for reloading if you have
//lines of code with more than one tic.
	action void MO_SetHasteTics(int tics)
	{
		if(invoker.OwnerHasSpeed())
		A_SetTics(tics);
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

	action void MO_KickAttack()
	{
		FTranslatedLineTarget t;
		int dmg = 35;
		double ang = angle + Random2() * (5.625 / 256);
        double pitch = AimLineAttack(ang, 64, null, 0., ALF_CHECK3D);
		
		if(invoker.OwnerHasBerserk())
		{	
			if(health < 30)
			LineAttack(ang, 75, pitch, dmg * 3, 'ExtremePunches', "BerserkKickPuff", LAF_ISMELEEATTACK,t);
			else
			 LineAttack(ang, 75, pitch, dmg * 2, 'ExtremePunches', "BerserkKickPuff", LAF_ISMELEEATTACK,t);
		}
		else
		{
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

	action void MO_SetWeaponSprite(string s, int overlay)
	{
		if(!player) return;
		 let psp = player.GetPSprite(overlay);
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

	//Put this function in the reload state. This replaces the old ammo checks that Metal Ops once used, similar to BD.
	//How doees this function work?
	//maxMag = The maximum amount of ammo for the gun magazine. Invoker.Ammo1.MaxAmount could be used.
	//EqualReserve = The reserve ammo that each gun uses per bullet.
	//emptyreload = The state used if the weapon has a different reload animation. Pass Null (without "") if this isn't the case.
	//partReload = The state used if the weapon has a partial reload, such as a tactical reload. Pass Null (without "") if this isn't the case.
	//fullOrEmpty = The state used if the weapon has no ammo or is full. Example: ReadyToFire, Empty, Ready.Empty
	action state MO_CheckReload(int maxMag, int EqualReserve, statelabel emptyreload, statelabel partReload, statelabel fullOrEmpty)
	{
		Ammo MagazineAmmo = invoker.Ammo1;
		Ammo ReserveAmmo = invoker.Ammo2;
		int magCount = MagazineAmmo.amount;
		int reserveCount = ReserveAmmo.amount;

		if(magCount >= maxMag)
		return ResolveState(fullOrEmpty);

		if(!invoker.OwnerHasSpeed() && magCount > EqualReserve || magCount >= maxMag)
		return ResolveState(partReload);

		if(reserveCount < EqualReserve)
		return ResolveState(fullOrEmpty);

		if(magCount <= 0)
		return ResolveState(emptyreload);

		return ResolveState(null);
	}

	action state MO_JumpIfLessAmmo(int m = 1, statelabel where = "Reload")
	{
		let wep = player.readyweapon;
		if(ResolveState(where) && invoker.Ammo1.amount  < m)
		{
			return ResolveState(where);
		}
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
				
	//By Matt. Perfect to go around the Return state/ResolveState headache (not really anymore)
	action void SetWeaponState(statelabel st,int layer=PSP_WEAPON)
    {
        if(player) player.setpsprite(layer,invoker.findstate(st));
    }
// Don't complain if this is an action state rather than an action void
// I found it easier an action state in terms of returning to state labels.
//Edit: IDK if i need this anymore since I converted almost every action into event handlers to be more
//responsive. I'll probably keep this for now in the future though.
	action state JM_WeaponReady(int wpflags = 0)
	{	
		A_WeaponReady(wpflags);
		if(ResolveState('ActionSpecial') && FindInventory("SpecialAction") && CheckIfInReady())
			return ResolveState('ActionSpecial');
		else	
			A_SetInventory("SpecialAction",0);
			return null;		
		
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
	
	action void JM_ReloadGun(Class<Inventory> magPool, Class<Inventory> reservePool, int magMax, int reserveTake)
	{
		for(int i = 0; i < magMax; i++)
		{
			if(CountInv(reservePool) < 1 || CountInv(magPool) == magMax) 
			return;	
			A_GiveInventory(magPool, 1);
			A_TakeInventory(reservePool, reserveTake, TIF_NOTAKEINFINITE);
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