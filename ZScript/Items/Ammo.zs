class MO_AmmoBase : Ammo abstract
{
	string Pk;
	name type;
	property AmmoType: type;


	override String PickupMessage()
	{
		CheckAmmoCount();
		return String.Format(Pk,GetTag(), amount);
	}

	void CheckAmmoCount()
	{
		if(amount > 1 && type != 'fuel') 
		Pk = "%ss \c-(+%d)";
		else Pk = "%s \c-(+%d)";
	}

	override Class<Ammo> GetParentAmmo ()
	{
		class<Object> type = GetClass();

		while (type.GetParentClass() != "MO_AmmoBase" && type.GetParentClass() != NULL)
		{
			type = type.GetParentClass();
		}
		return (class<Ammo>)(type);
	}

	Default
	{
		+DONTGIB
		+FLOORCLIP
		+INVENTORY.IGNORESKILL
	}
}

class MO_LowCaliber : MO_AmmoBase
{
	Default
	{
	  Tag "$TAG_LOWCALIBER";
	  Inventory.Amount 10;
	  Inventory.MaxAmount 200;
	  Ammo.BackpackAmount 30;
	  Ammo.BackpackMaxAmount 400;
	  Inventory.Icon "CLIPB0";
	  Inventory.PickUpSound "misc/ammopickup";
	  Scale 0.85;
	  MO_AmmoBase.AmmoType 'pistolcal';
	 }
	  States
	  {
	  Spawn:
		CLIP B -1;
		Stop;
	}
 }
 
class MO_LowCalBox : MO_LowCaliber
{
	Default
	{
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
 
 class MO_HighCaliber : MO_AmmoBase
{
	Default
	{
	  Tag "$TAG_HIGHCALIBER";
	  Inventory.Amount 10;
	  Inventory.MaxAmount 200;
	  Ammo.BackpackAmount 30;
	  Ammo.BackpackMaxAmount 400;
	  Inventory.Icon "CLIPA0";
	  Inventory.PickUpSound "misc/ammopickup";
	 MO_AmmoBase.AmmoType 'riflecal';
	 }
	  States
	  {
	  Spawn:
		CLIP A -1;
		Stop;
	}
 }
 
 class MO_HighCalBox : MO_HighCaliber
 {
	Default
	{
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


class MO_ShotShell : MO_AmmoBase 
{
	Default
	{
	 Tag "$TAG_SHELL";
	  Inventory.Amount 4;
	  Inventory.MaxAmount 50;
	  Ammo.BackpackAmount 8;
	  Ammo.BackpackMaxAmount 100;
	  Inventory.Icon "SHELA0";
	  Inventory.PickUpSound "misc/shells";
	 MO_AmmoBase.AmmoType 'shell';
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

Class MO_RocketAmmo : MO_AmmoBase replaces RocketAmmo
{
	Default
	{
	  Tag "$TAG_RCKT";
	  Inventory.Amount 1;
	  Inventory.MaxAmount 50;
	  Ammo.BackpackAmount 2;
	  Ammo.BackpackMaxAmount 100;
	  Inventory.Icon "R0CKA0";
	  Inventory.PickUpSound "misc/rocket";
	  Scale 0.45;
	  MO_AmmoBase.AmmoType 'rocket';
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
	Tag "$TAG_RCKT";
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


Class MO_Cell : MO_AmmoBase
{
  Default
  {
  Tag "$TAG_CELL";
  Inventory.Amount 20;
  Inventory.MaxAmount 300;
  Ammo.BackpackAmount 40;
  Ammo.BackpackMaxAmount 600;
  Inventory.Icon "CEL1A0";
  inventory.pickupsound "misc/cell";
  MO_AmmoBase.AmmoType 'cell';
  }
  States
  {
  Spawn:
	CEL1 BCDEFG 3;
    Loop;
  }
}

Class MO_CellPack: MO_Cell
{
  Default
  {
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

class MO_Fuel : MO_AmmoBase
{
	Default
	{
	  Tag "$TAG_FUEL";
	  Inventory.Amount 20;
	  Inventory.MaxAmount 300;
	  Ammo.BackpackAmount 40;
	  Ammo.BackpackMaxAmount 600;
	  Inventory.Icon "JRYCB0";
	  Inventory.PickupSound "misc/fuel";
	  MO_AmmoBase.AmmoType 'fuel';
	 }
	  States
	  {
	  Spawn:
		JRYP A -1;
		Stop;
	}
}

class MO_LargeFuelCan: MO_Fuel
{
	Default
	{
		Inventory.Amount 80;
	}
	States
	{
	  Spawn:
		JRYC A -1;
		Stop;
	}
}