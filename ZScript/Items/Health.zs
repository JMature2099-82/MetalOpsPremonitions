class MO_BaseHealth : Health abstract
{
	override String PickupMessage()
	{
		return String.Format("%s \c-(+%d HP)",GetTag(), Amount);
	}
}

class MO_HealthBonus : MO_BaseHealth// replaces HealthBonus
{
	Default
	{
	  +COUNTITEM;
	  +INVENTORY.ALWAYSPICKUP;
	  Inventory.Amount 2;
	  Inventory.MaxAmount 300;
	  Tag "$TAG_HTHBONUS";
	  Inventory.PickupSound "misc/healthbonus";
	}
	States
	{
	  Spawn:
		B0N1 ABCDCB 6;
		Loop;
	 }
}

class MO_CorruptedHealthBonus : MO_HealthBonus
{
	Default
	{
	  Inventory.Amount 3;
	  Inventory.PickupSound "doublehealth";
	  Tag "$TAG_HTHBONUS2";
	}
	States
	{
	  Spawn:
		80N1 ABCDCB 6;
		Loop;
	 }
}

class MO_SpiritualHealthBonus : MO_HealthBonus
{
	Default
	{
	  Inventory.Amount 4;
	  Inventory.PickupSound "triplehealth";
	  Tag "$TAG_HTHBONUS3";
	}
	States
	{
	  Spawn:
		90N1 ABCDCB 6;
		Loop;
	 }
}

Class MO_Stimpack: MO_BaseHealth replaces Stimpack
{
	Default
	{
	  Inventory.Amount 15;
	  Tag "$TAG_STIM";
	  Inventory.PickupSound "misc/stim";
	 }
  States
  {
  Spawn:
    5TIM A -1;
    Stop;
  }
}

Class MO_Medikit : MO_BaseHealth replaces Medikit
{
	Default
	{
	  Inventory.Amount 30;
	  Tag "$TAG_MEDIKIT";
	  Inventory.PickupSound "misc/medpack";
	}
  States
  {
  Spawn:
    MEDI A -1;
    Stop;
  }
}


Class MO_Berserk : CustomInventory// replaces Berserk
{
	Default
	{
		+COUNTITEM;
		+INVENTORY.ALWAYSPICKUP;
		Inventory.PickupMessage "$GOTZERK";
		Inventory.PickupSound "misc/zerkpak";
	}
	States
	{
		Spawn:
		PSTR A -1;
		Stop;
		
		Pickup:	
		TNT1 A 0 A_GiveInventory("MO_PowerStrength");
		TNT1 A 0 HealThing(100, 0);
		TNT1 A 0 A_SetBlend("Red", .9, 50);
		Stop;
	}
}

Class MO_PowerStrength : PowerStrength
{Default{PowerUp.Color "000000", 0;}}