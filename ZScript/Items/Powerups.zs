mixin class PowerUpExpiringBase
{
	const playTimer = 105;
	int ExpireSoundTics;
}

mixin class MO_PowerUpWarning
{
	void PowerWarning(name pwrname, string b4pwrname, string expiresnd, string blend, string txtcolor, string wearmsg = "is wearing off")
	{
		string str = b4pwrname.." \c"..txtcolor..pwrname.."\c- "..wearmsg;
		if (Owner && EffectTics > 0)
		{
			switch(EffectTics)
			{
			case 105:
			case 70:
			case 35:
			Owner.A_StartSound(expiresnd, 1000, CHANF_OVERLAP, 1.0, ATTN_NONE);
			Owner.A_Print(str, 1);
			Owner.A_SetBlend(blend, .6, 10);
			break;
			}
		}
	}
}

class MO_BackPack : BackPack replaces Backpack
{
	Default
	{
	Inventory.PickupSound "misc/backpack";
	Inventory.PickupMessage "You got a backpack to store more ammo!";
	Height 26;
	}
	States
	{
		Spawn:
		BPAK A -1;
		Stop;
	}
}

class MO_AllMap : AllMap replaces AllMap
{
	Default
	{
		+COUNTITEM
		+INVENTORY.FANCYPICKUPSOUND
		+INVENTORY.ALWAYSPICKUP
		Inventory.MaxAmount 0;
		Inventory.PickupSound "misc/map";
		Inventory.PickupMessage "$GOTMAP"; // "Computer Area Map"
	}
	States
	{
	Spawn:
		PMAP ABCDCB 6 Bright;
		Loop;
	}
}

Class MO_Goggles : Infrared replaces Infrared
{
	override bool Use(bool pickup)
	{
		owner.A_SetBlend("Black", .8,20);
		return Super.Use(pickup);
	}
   Default
   {
	  +COUNTITEM;
	  +INVENTORY.AUTOACTIVATE;
	  +INVENTORY.ALWAYSPICKUP;
	  Inventory.MaxAmount 0;
	  Powerup.Type "MO_PowerLightAmp";
	  Inventory.PickupMessage "Tactical Night Vision Goggles";
	  inventory.pickupsound "misc/goggles";
	  Inventory.AltHudIcon "PVISA0";
  }
  States
  {
  Spawn:
    PVIS A 6 Bright;
    PVIS B 6;
    Loop;
  }
}

Class MO_PowerLightAmp : PowerLightAmp
{
	mixin MO_PowerUpWarning;
	override void DoEffect ()
    {
		if(!owner) return;
        Super.DoEffect();
		SetNVGStyle();
		SetNVGScanlines();
		Shader.SetEnabled(Owner.Player,"NiteVis",true);
		Shader.SetUniform1f(Owner.Player, "NiteVis","exposure",2);
		Shader.SetUniform1i(Owner.Player, "NiteVis","u_resfactor",resfactor);
		Shader.SetUniform1i(Owner.Player,"NiteVis","u_posterize",posterize);
		Shader.SetUniform3f(Owner.Player,"NiteVis","u_posfilter",posfilter);
		Shader.SetUniform1f(Owner.Player,"NiteVis","u_whiteclip",whiteclip);
		Shader.SetUniform1f(Owner.Player,"NiteVis","u_desat",desat);
		PowerWarning("Night Vision Goggles'", "The", "misc/goggleswarn", "00 aa 00", "d", "battery is running low");
	}
	
	override void EndEffect()
	{
		Super.EndEffect();
		if(!owner) return;
		Owner.A_StartSound("misc/gogglesend", 41);
		Owner.A_StopSound(40);
		owner.A_SetBlend("Black", .8,20);
		Shader.SetEnabled(Owner.Player,"nitevis",false);
	}
		
	Default
	{
		Inventory.AltHudIcon "PVISA0";
		+INVENTORY.NOSCREENBLINK;
	}
}

//Modified from Hideous Destructor
extend class MO_PowerLightAmp
{
	transient CVar NVGStyle;
	int style;
	bool hasScan;
	transient CVar NVGScanlines;
	int resfactor,scanfactor,hscan,vscan,posterize;
	double scanstrength,whiteclip,desat;
	vector3 posfilter,negfilter;

	void SetNVGStyle() {
		if (!NVGStyle) NVGStyle = CVar.GetCVar("mo_nvstyle",owner.player);
		int style = NVGStyle.GetInt();
		switch (style) {
			default:
			case 0: // Green Phosphor
				resfactor=1;hscan=1;vscan=0;scanfactor=8;scanstrength=0.1;posterize=24;posfilter=(0,1,0);whiteclip=0.25;desat=0.0;break;
			case 1: // White Phosphor
				resfactor=2;hscan=1;vscan=0;scanfactor=2;scanstrength=0.1;posterize=256;posfilter=(0.0,1.0,0.75);whiteclip=0.8;desat=0.0;break;
		}
	}
	void SetNVGScanlines() {
		if(!NVGScanlines) NVGScanlines = Cvar.GetCVar("mo_nvscanlines",owner.player);
		hasScan = NVGScanlines.GetBool();
		if(hasScan == true)
		{
			Shader.SetUniform1i(Owner.Player, "NiteVis","u_hscan",resfactor);
			Shader.SetUniform1f(Owner.Player, "NiteVis","u_scanstrength",scanstrength);
		}
		else
		{
			Shader.SetUniform1i(Owner.Player, "NiteVis","u_hscan",0);
			Shader.SetUniform1f(Owner.Player, "NiteVis","u_scanstrength",0);
		}
	}
}

//In the future I'm going try to remove the leaky suit feature
Class MO_RadSuit : RadSuit replaces Radsuit
{
  Default
  {
	  Height 46;
	  +INVENTORY.AUTOACTIVATE;
	  +INVENTORY.ALWAYSPICKUP;
	  Inventory.MaxAmount 0;
	  Inventory.PickupMessage "Radiation/Hazardous Environment Suit"; // "Radiation Shielding Suit"
	  Powerup.Type "MO_PowerIronFeet";
	  Inventory.PickupSound "misc/suit";
	  Inventory.AltHudIcon "SUITA0";
  }
  States
  {
  Spawn:
    SUIT A -1;// Bright
    Stop;
  }
}

Class MO_PowerIronFeet : PowerIronFeet
{
	mixin MO_PowerUpWarning;
	
	override void DoEffect ()
    {
		if(!owner) return;
        Super.DoEffect();
		PowerWarning("Hazardous Environment Suit", "The", "hazsuitwarn", "Green", "d", "is expiring");
	}
	
	override void AbsorbDamage (int damage, Name damageType, out int newdamage, Actor inflictor, Actor source, int flags)
	{
		if (damageType == 'Slime' || damageType == 'Disintegrate') //No More Leaky Suit
		{
			newdamage = 0;
		}
		else if (damageType == 'Ice' || damageType == 'Fire' || damageType == 'Burn' || damageType == 'Flames' ||
		damageType == 'Frost' || damageType == 'Freeze')
		{
			newdamage = damage / 2;
		}
	}
	
	override void EndEffect()
	{
		Super.EndEffect();
		if(!owner) return;
		Owner.A_StartSound("hazsuitended", 41);
		Owner.A_StopSound(40);
	}
	
	Default
	{
		Inventory.AltHudIcon "SUITA0";
		+INVENTORY.NOSCREENBLINK;
		Powerup.Mode "Full";
	}
}