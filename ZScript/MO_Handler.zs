
class MOps_Handler : EventHandler
{
	int kicktimer;
	const kickcooldown = 18;
	const fastkickcooldown = 15;
    override void WorldTick()
    {
        PlayerInfo plyr = players[ConsolePlayer];
		
		if(kicktimer > 0)
			kicktimer--;
    }

	override void PlayerDied(PlayerEvent e) //destroy gun lighting on Death
	{
		let pl = MO_PlayerBase(players[e.PlayerNumber].mo);
		if(pl)
		{
			pl.A_StopAllSounds();
			pl.A_RemoveLight('GunLighting');
		}
	}
	
// Key bind code by m8f
	private static ui bool isKeyForCommand(int key, string command)
	{
		Array<int> keys;
		bindings.getAllKeysForCommand(keys, command);
		uint nKeys = keys.size();
		for (uint i = 0; i < nKeys; ++i)
		{
		  if (keys[i] == key) return true;
		}
		return false;
	}
	
	override void CheckReplacement(replaceEvent e)
	{
		PlayerInfo p = players[consoleplayer];
		switch(e.Replacee.GetClassName())
		{
			case 'Pistol':
				if(p.mo is "MO_SergeantPlayer")
				{e.Replacement = "MO_Deagle";}
				else
				{e.Replacement = "MO_VengeanceStryker";}
				break;
			case 'Shotgun':
				e.Replacement = "ShotgunDropper";
				break;
			case 'Chaingun':
			case 'Minigun':
				e.Replacement = "ChaingunDropper";
				break;
			case 'PlasmaRifle':
				e.Replacement = "MO_PlasmaRifle";
				break;

			//Ammo
			case 'Shell':
				e.Replacement = "MO_ShotShell";
				break;
			case 'Shellbox':
				e.Replacement = "MO_ShellBox";
				break;

			case 'Cell':
			if(random(0,9) >= 5)
			{
				e.Replacement = "MO_Fuel";
				break;
			}
			else
			{
				e.Replacement = "MO_Cell";
				break;
			}
	
			case 'ID24Fuel':
				e.Replacement = "MO_Fuel";
				break;
			
			case 'ID24FuelTank':
				e.Replacement = "MO_LargeFuelCan";
				break;

			case 'ID24Incinerator':
				e.Replacement = "MO_Flamethrower";
				break;

			case 'Cellpack':
			if(random(0,9) >= 5)
			{
				e.Replacement = "MO_LargeFuelCan";
				break;
			}
			else
			{
				e.Replacement = "MO_CellPack";
				break;
			}
		}
		e.isFinal = false;
	}

	override bool InputProcess(InputEvent e) 
	{
		int KeyBind = e.KeyScan;
		for(int i = 0; i <= 10; ++i)
		{
			if (isKeyForCommand(KeyBind, "+User1") && e.type == InputEvent.Type_KeyDown) 
			{
				EventHandler.SendNetworkEvent("ThrowEquipment");
			}

			if (isKeyForCommand(KeyBind, "+Zoom") && e.type == InputEvent.Type_KeyDown) 
			{
				Console.PrintF("You pressed the Zoom key");
				//EventHandler.SendNetworkEvent("ThrowEquipment");
			}
		}
		return false;
	}

    override void NetworkProcess(ConsoleEvent e)
    {
        PlayerPawn pl = players[e.Player].mo;
        if(!pl)
         return;

        if (e.Name ~== "PrevThrowable")
        {
            let moweap = MO_Weapon(pl.player.readyweapon);

            int throwType = pl.CountInv("ThrowableType");

            switch(throwType)
            {
                case 1:
                    pl.SetInventory("ThrowableType", 0);
                    pl.A_Print("Frag Grenades Selected");
					pl.S_StartSound("FragGrenade/Pickup",3);
                    break;
                default:
                    pl.GiveInventory("ThrowableType", 1);
                    pl.A_Print("Molotov Cocktails Selected");
					pl.S_StartSound("MOLPKUP",3);
                    break;
            }
        }
		
		/*
		if (e.Name ~== "NextThrowable")
        {
            let moweap = MO_Weapon(pl.player.readyweapon);

            int throwType = pl.CountInv("ThrowableType");

            switch(throwType)
            {
                case 2:
                    pl.SetInventory("ThrowableType", 0);
                    break;
                default:
                    pl.GiveInventory("ThrowableType", 1);
                    break;
            }
        }*/

		if(e.Name ~== "ThrowEquipment")
		{
			let mo_wep = MO_Weapon(pl.player.readyweapon);
			if(!mo_wep) return;
			
			State TossThrowable = mo_wep.FindState("TossThrowable");
			if(TossThrowable != Null && (players[e.Player].weaponstate & WF_WEAPONREADY) || (mo_wep && mo_wep.CheckIfInReady()))
			{
				pl.player.SetPSprite(PSP_WEAPON, mo_wep.FindState("TossThrowable"));
			}
		}

		if (e.Name ~== "KickEm")
		{	
			if(kicktimer == 0)
			{
				
				//If the Player is alive, do the kick attack. If dead, do nothing.
				if((players[e.Player].playerstate == PST_LIVE))
				{
					let mo_wep = MO_Weapon(pl.player.readyweapon);
					if(!mo_wep)
					return;
	
					//set the cooldown
					if(mo_wep && mo_wep.OwnerHasSpeed())
					kicktimer = fastkickcooldown;
					else
					kicktimer = kickcooldown;
					
					let wp = pl.player.readyweapon;
					if(!wp)
					return;
					State Kick = wp.FindState("Kick");
					State FlashKick = wp.FindState("FlashKick");
					State FlashAirKick = wp.FindState("FlashAirKick");
					if(Kick != Null && !mo_wep.isZoomed)
					{
						pl.player.SetPSprite(-999, wp.FindState("Kick"));
						if(FlashKick != NULL && (players[e.Player].weaponstate & WF_WEAPONREADY) || (mo_wep && mo_wep.CheckIfInReady()))
						{
								if(FlashAirKick != Null && pl.Vel.Z != 0)
								pl.player.SetPSprite(PSP_Weapon, wp.FindState("FlashAirKick"));
								else
								pl.player.SetPSprite(PSP_Weapon, wp.FindState("FlashKick"));
						}
					}
				}
			}
		}
	}
}