class MOps_Handler : EventHandler
{
	int kicktimer;
	const kickcooldown = 18;
	const fastkickcooldown = 15;
    override void WorldTick()
    {
        PlayerInfo plyr = players[consoleplayer];

		if(kicktimer > 0)
			kicktimer--;
    }

	override void PlayerDied(PlayerEvent e) //destroy gun lighting on Death
	{
		let pl = MO_PlayerBase(players[e.PlayerNumber].mo);
//		let plrWep = JMWeapon(pl.readyweapon);

		if(pl)
		{
			pl.A_RemoveLight('GunLighting');
		}
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
				{e.Replacement = "MO_VengeanceStriker";}
				break;
			case 'Shotgun':
				e.Replacement = "ShotgunDropper";
				break;
			case 'Chaingun':
			case 'Minigun':
				e.Replacement = "ChaingunDropper";
				break;
		}
		e.isFinal = false;
	}

    override void NetworkProcess(ConsoleEvent e)
    {
        let pl = players[e.Player].mo;
        if(!pl)
         return;

        if (e.Name ~== "PrevThrowable")
        {
            let moweap = JMWeapon(pl.player.readyweapon);

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
            let moweap = JMWeapon(pl.player.readyweapon);

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

		if (e.Name ~== "KickEm")
		{	
			if(kicktimer == 0)
			{
				
				//If the Player is alive, do the kick attack. If dead, do nothing.
				if((players[e.Player].playerstate == PST_LIVE))
				{
					let mo_wep = JMWeapon(pl.player.readyweapon);
					if(!mo_wep)
					return;
	
					//set the cooldown
					if(mo_wep && mo_wep.OwnerHasSpeed())
					kicktimer = fastkickcooldown;
					else
					kicktimer = kickcooldown;
					
					let wp = pl.player.readyweapon;
					State Kick = wp.FindState("Kick");
					if(Kick != Null && !mo_wep.isZoomed)
					{
						pl.player.SetPSprite(-999, wp.FindState("Kick"));
						if((players[e.Player].weaponstate & WF_WEAPONREADY) || (mo_wep && mo_wep.CheckIfInReady()))
						{
								pl.player.SetPSprite(PSP_Weapon, wp.FindState("FlashKick"));
						}
					}
				}
			}
		}
	}
}