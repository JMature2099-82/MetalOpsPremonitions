class MO_KeyWeapon : MO_Weapon  
{
    class<Weapon> prevWeapon;
    string soundName;
	Property KeySound : soundName;
	Default {  
        Inventory.PickupMessage "$GOTPLACEHOLDER";
		Tag "First Person Key Animations";
		Weapon.SlotNumber 0;
		+Weapon.CheatNotWeapon
		+Weapon.No_Auto_Switch
		+Weapon.NoAlert
		+Inventory.Undroppable
		+Inventory.Untossable
	//	MO_KeyWeapon.KeySound "misc/k_pkup";
	}
	
	States {
		Select:
		Ready:
		Fire:
        TossThrowable:
        ReallyReady:
			TNT1 A 2;
			NRKE A 0;
			Goto Animation;
		
		Animation:
            #### A 1;
			#### BCDEE 1 JM_WeaponReady(WRF_NOFIRE|WRF_NOSWITCH);
            #### F 6 JM_WeaponReady(WRF_NOFIRE|WRF_NOSWITCH);
            #### # 0 A_StartSound(invoker.soundName, 0);
			#### G 8 JM_WeaponReady(WRF_NOFIRE|WRF_NOSWITCH);
			#### HHIJBA 1 JM_WeaponReady(WRF_NOFIRE|WRF_NOSWITCH);
			TNT1 A 4 JM_WeaponReady(WRF_NOFIRE|WRF_NOSWITCH);
		Deselect:
			NRKE B 0 {
				A_TakeInventory("UsingAKey");
				if(invoker.prevWeapon == "MO_Katana") A_SetInventory("SelectKatanaFromKeys",1);
				A_SelectWeapon(invoker.prevWeapon, SWF_SelectPriority);
				A_TakeInventory(invoker.GetClassName());
				player.cheats &= ~CF_FROZEN;
			}
			Stop;
	}
} 

class MO_RedCardWeapon : MO_KeyWeapon
{Default{MO_KeyWeapon.KeySound "KEYUSE";}}

class MO_YellowCardWeapon : MO_RedCardWeapon
{
	States {
		Select:
		Ready:
			TNT1 A 2;
			NYKE A 0;
			Goto Animation;
	}
}

class MO_BlueCardWeapon : MO_RedCardWeapon
{
    States {
		Select:
		Ready:
			TNT1 A 2;
			NBKE A 0;
			Goto Animation;
	}
}

class MO_RedSkullWeapon : MO_KeyWeapon
{   
	Default{MO_KeyWeapon.KeySound "misc/skullkey";}
	States {
		Select:
		Ready:
			TNT1 A 2;
			NRSK A 0;
			Goto Animation;
	}
}

class MO_YellowSkullWeapon : MO_RedSkullWeapon
{
	States {
		Select:
		Ready:
			TNT1 A 2;
			NYSK A 0;
			Goto Animation;
	}
}

class MO_BlueSkullWeapon : MO_RedSkullWeapon
{
	States {
		Select:
		Ready:
			TNT1 A 2;
			NBSK A 0;
			Goto Animation;
	}
}
