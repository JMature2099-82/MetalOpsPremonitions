//Combat Armors
class MO_BaseArmor : BasicArmorPickup abstract
{
	override String PickupMessage()
	{
		return String.Format("%s \c-(+%d AP, %d%% protection)",GetTag(), SaveAmount, SavePercent);
	}
}

//Armor Bonuses
class MO_BaseArmor2 : BasicArmorBonus abstract
{
	override String PickupMessage()
	{
		return String.Format("%s \c-(+%d AP)",GetTag(), SaveAmount);
	}
}


class MO_ArmorBonus : MO_BaseArmor2
{
	Default
	{
	  Radius 20;
	  Height 16;
	  Tag "$TAG_ARMBONUS";
	  Inventory.Icon "ARM1A0";
	  Armor.SavePercent 33.335;
	  Armor.SaveAmount 2;
	  Armor.MaxSaveAmount 300; // 300 so that it doesn't break item count
	  +COUNTITEM;
	  inventory.pickupsound "misc/armorbonus";
	  +INVENTORY.ALWAYSPICKUP;
	}
	  States
	  {
	  Spawn:
		B0N2 ABCDCB 6;
		Loop;
	  }
}

class MO_GeminusArmorBonus : MO_ArmorBonus
{
	Default
	{
		 Tag "$TAG_ARMBONUS2";
		Armor.SaveAmount 3;
		inventory.pickupsound "gemarmorbonus";
	}
	States
	{
		Spawn:
		80N2 ABCDCB 6;
		Loop;
	}
}

class MO_TrebleArmorBonus : MO_ArmorBonus
{
	Default
	{
		Tag "$TAG_ARMBONUS3";
		Armor.SaveAmount 4;
		inventory.pickupsound "trebarmorbonus";
	}
	States
	{
		Spawn:
		90N2 ABCDCB 6;
		Loop;
	}
}
		

class MO_LightArmor : MO_BaseArmor replaces GreenArmor
{
	Default
	{
	 Radius 20;
	  Height 16;
	  Tag "$TAG_LIGHTARM";
	  Inventory.Icon "ARM1A0";
	  Armor.SavePercent 33.335;
	  Armor.SaveAmount 100;
	  Inventory.PickupSound "misc/armorup";
	 }
	  States
	  {
	  Spawn:
		ARM1 A -1;
		Stop;
	  }
}

class MO_HeavyArmor : MO_BaseArmor replaces BlueArmor
{
	Default
	{
	 Radius 20;
	  Height 16;
	  Tag "$TAG_HEAVYARM";
	  Inventory.Icon "ARM2A0";
	  Armor.SavePercent 50;
	  Armor.SaveAmount 200;
	  Inventory.PickupSound "misc/armorup";
	}
	  States
	  {
	  Spawn:
		ARM2 A -1;
		Stop;
	  }
}