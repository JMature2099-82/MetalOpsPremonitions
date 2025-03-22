class MO_KeyClass : Key abstract
{
	Default
	{
	+DONTGIB;
	+NOTDMATCH;
	Radius 20;
	Height 16;
	Inventory.pickupsound "misc/keycard";
	Inventory.InterHubAmount 0;
	}
}

class MO_SkullKeyClass : MO_KeyClass
{
	Default
	{
		Inventory.PickUpSound "misc/skullkey";
	}
}

class MO_RedCard : MO_KeyClass replaces RedCard
{
	Default
	{
	Species "RedCard";
	Inventory.PickupMessage "$GOTREDCARD";
	Inventory.Icon "KEYRA0";
	}
	States
	{
		Spawn:
		KEYR A 10;
		KEYR B 10 bright;
		Loop;
	}
}

class MO_YellowCard : MO_KeyClass replaces YellowCard
{
	Default
	{
	Species "YellowCard";
	Inventory.Icon "KEYYA0";
	Inventory.PickupMessage "$GOTYELWCARD";
	}
	States
	{
		Spawn:
		KEYY A 10;
		KEYY B 10 bright;
		Loop;
	}
}

class MO_BlueCard : MO_KeyClass replaces BlueCard
{
	Default
	{
	Species "BlueCard";
	Inventory.PickupMessage "$GOTBLUECARD";
	Inventory.Icon "KEYBA0";
	}
	States
	{
		Spawn:
		KEYB A 10;
		KEYB B 10 bright;
		Loop;
	}
}

class MO_RedSkull : MO_SkullKeyClass replaces RedSkull
{
	Default
	{
	Inventory.PickupMessage "$GOTREDSKUL";
	Species "RedSkull";
	Inventory.Icon "SKLRA0";
	}
	States
	{
		Spawn:
		SKLR A 10;
		SKLR B 10 bright;
		Loop;
	}
}

class MO_BlueSkull : MO_SkullKeyClass replaces BlueSkull
{
	Default
	{
	Inventory.PickupMessage "$GOTBLUESKUL";
	Species "BlueSkull";
	Inventory.Icon "SKLBA0";
	}
	States
	{
		Spawn:
		SKLB A 10;
		SKLB B 10 bright;
		Loop;
	}
}

class MO_YellowSkull : MO_SkullKeyClass replaces YellowSkull
{
	Default
	{
	Inventory.PickupMessage "$GOTYELWSKUL";
	Species "YellowSkull";
	Inventory.Icon "SKLYA0";
	}
	States
	{
		Spawn:
		SKLY A 10;
		SKLY B 10 bright;
		Loop;
	}
}