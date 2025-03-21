Class MO_Token : Inventory 
{
	Default
	{
		Inventory.MaxAmount 1;
		+INVENTORY.UNDROPPABLE;
		-INVENTORY.INVBAR;
	}
}

Class MO_ZSToken : MO_Token{}

//Weapon tokens

Class FragSelected : MO_ZSToken{}

Class MolotovSelected : MO_ZSToken{}

Class GrenadeTimer : Inventory 
{Default{Inventory.MaxAmount 50;}}

Class GrenadeCookTimer : Inventory 
{Default{Inventory.MaxAmount 105;}}

Class Timer: Inventory
{Default{Inventory.MaxAmount 9999;}}

Class GrenadeThrownTimer : GrenadeCookTimer{}

Class GunIsEmpty : MO_ZSToken{}

Class SergeantClass : MO_ZSToken 
{}

Class SpecialAction : MO_ZSToken{}

Class SpecialAction2 : MO_ZSToken{}

//-------------------------------------------------- |
//			 			Weapon  tokens				                  |
//---------------------------------------------------| 

//Slot 2
Class NeverUsedSMG : MO_ZSToken{}
Class NeverUsedDeagle : MO_ZSToken{}

//Slot 3
Class NeverUsedPSG : MO_ZSToken{}
Class NeverUsedLAS : MO_ZSToken{}

//Slot 4
Class NeverUsedHCR : MO_ZSToken{} //Will come later
Class ARIsEmpty : MO_ZSToken{}

//For a future pickup system based on Castlevania: Rondo of Blood's subweapon pickup system, although the logic
//is mostly based on the Iron Snail mod.

Class MO_PumpShottyToken : MO_ZSToken{}
Class MO_LeverShottyToken : MO_ZSToken{}
Class MO_AssaultRifleToken : MO_ZSToken{}
Class MO_HCRToken : MO_ZSToken{} 
