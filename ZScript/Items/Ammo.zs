class MO_LowCaliber : Ammo
{
	Default
	{
	  Inventory.PickupMessage "Picked up a low caliber magazine.";
	  Inventory.Amount 10;
	  Inventory.MaxAmount 150;
	  Ammo.BackpackAmount 30;
	  Ammo.BackpackMaxAmount 300;
	  Inventory.Icon "CLIPB0";
	  Inventory.PickUpSound "misc/ammopickup";
	  Scale 0.85;
	 }
	  States
	  {
	  Spawn:
		CLIP B -1;
		Stop;
	}
 }
 
class MO_LowCalBox : MO_LowCaliber// replaces Clipbox
{
	Default
	{
	  Inventory.PickupMessage "Picked up a box of low caliber bullets.";
	  Inventory.Amount 50;
	  Inventory.PickUpSound "misc/ammobox";
	}
	  States
	  {
	  Spawn:
		AMOK A -1;
		Stop;
	  }
}
 
 class MO_HighCaliber : Ammo
{
	Default
	{
	  Inventory.PickupMessage "Picked up a high caliber magazine.";
	  Inventory.Amount 10;
	  Inventory.MaxAmount 200;
	  Ammo.BackpackAmount 30;
	  Ammo.BackpackMaxAmount 400;
	  Inventory.Icon "CLIPA0";
	  Inventory.PickUpSound "misc/ammopickup";
	 }
	  States
	  {
	  Spawn:
		CLIP A -1;
		Stop;
	}
 }
 
 class MO_HighCalBox : MO_HighCaliber// replaces Clipbox
 {
	Default
	{
	  Inventory.PickupMessage "Picked up a box of high caliber bullets.";
	  Inventory.Amount 50;
	  Inventory.PickUpSound "misc/ammobox";
	}
	  States
	  {
	  Spawn:
		AMM0 A -1;
		Stop;
	  }
}

class MO_Gasoline : Ammo
{
	Default
	{
	  Inventory.PickupMessage "Picked up a gasoline jerry can.";
	  Inventory.Amount 35;
	  Inventory.MaxAmount 300;
	  Ammo.BackpackAmount 90;
	  Ammo.BackpackMaxAmount 600;
	  Inventory.Icon "GASLN0";
	 }
	  States
	  {
	  Spawn:
		GASL N -1;
		Stop;
	}
}

class MO_ShotShell : Ammo 
{
	Default
	{
	  Inventory.PickupMessage "$GOTSHELLS";
	  Inventory.Amount 4;
	  Inventory.MaxAmount 50;
	  Ammo.BackpackAmount 8;
	  Ammo.BackpackMaxAmount 100;
	  Inventory.Icon "SHELA0";
	  Inventory.PickUpSound "misc/shells";
	  }
	  States
	  {
	  Spawn:
		SHEL A -1;
		Stop;
	  }
}
 	
Class MO_ShellBox : MO_ShotShell
{
	Default
	{
	  Inventory.PickupMessage "$GOTSHELLBOX"; // "Picked up a box of shotgun shells."
	  Inventory.Amount 20;
	  Inventory.PickUpSound "misc/shellbox";
	}
  States
  {
  Spawn:
    SBOX A -1;
    Stop;
  }
}

Class MO_RocketAmmo : Ammo replaces RocketAmmo
{
	Default
	{
	  Inventory.PickupMessage "$GOTROCKET"; // "Picked up a rocket."
	  Inventory.Amount 1;
	  Inventory.MaxAmount 50;
	  Ammo.BackpackAmount 1;
	  Ammo.BackpackMaxAmount 100;
	  Inventory.Icon "R0CKA0";
	  Inventory.PickUpSound "misc/rocket";
	  Scale 0.45;
	}
	  States
	  {
	  Spawn:
		R0CK A -1;
		Stop;
	  }
}


Class MO_RocketBox : MO_RocketAmmo replaces RocketBox
{
	Default
	{
	Inventory.PickupMessage "$GOTROCKBOX";
	Inventory.Amount 6;
	Inventory.PickUpSound "misc/rocketbox";
	Scale 1;
	}
	States
	{
	  Spawn:
		RBOX A -1;
		Stop;
	}
}

Class MO_Cell : Ammo replaces Cell
{
  Default
  {
  Inventory.PickupMessage "$GOTCELL";
  Inventory.Amount 20;
  Inventory.MaxAmount 300;
  Ammo.BackpackAmount 20;
  Ammo.BackpackMaxAmount 600;
  Inventory.Icon "CEL1A0";
  inventory.pickupsound "misc/cell";
  }
  States
  {
  Spawn:
	CEL1 BCDEFG 3;
    Loop;
  }
}

Class MO_CellPack: MO_Cell replaces Cellpack
{
  Default
  {
  Inventory.PickupMessage "$GOTCELLBOX";
  Inventory.Amount 100;
  inventory.pickupsound "misc/cellpak";
  }
  States
  {
  Spawn:
    CE1P ABCD 3;
    Loop;
  }
}
