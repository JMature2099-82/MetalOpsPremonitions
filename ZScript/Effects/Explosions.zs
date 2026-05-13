Class RocketExplosionFX : Actor
{
	Default
	{
		Radius 0;
		Height 0;
		RenderStyle 'Add';
		Alpha 1;
		Scale 1.35;
	  +NOGRAVITY;
	  +NOINTERACTION;
	  +NOBLOCKMAP;
	  +NOTELEPORT;
	  +ForceXYBillboard;
	  +CLIENTSIDEONLY;
	}
	

	States
	{
		Spawn:
			TNT1 A 0;
			TNT1 A 1 A_Jump(256, "Effect1", "Effect2", "Effect3", "Effect4", "Effect5");
		Effect1:
			X203 ABCDE 1 bright;
			X203 FGHIJKLMNOPQRSTUVWXYZ 1 bright;
			Stop;
		Effect2:
			X204 ABCDE 1 bright;
			X204 FGHIJKLMNOPQ 1 bright;
			Stop;
		Effect3:
			X005 ABCDE 1 bright;
			X005 FGHIJKLMNOPQRSTUVWX 1 bright;
			Stop;
		Effect4:
			X006 ABCDE 1 bright;
			X006 FGHIJKLMNOP 1 bright;
			Stop;
		Effect5:
			X007 A 0 A_SetScale (1);
			X007 ABCDE 1 bright;
			X007 FGHIJKLMNOPQ 1 bright;
			Stop;
    }
}

Class BarrelExplosionFX : RocketExplosionFX
{
	States
	{
		Spawn:
			TNT1 A 0;
			TNT1 A 1 A_Jump(256, "Effect1", "Effect2", "Effect3");
		Effect1:
			X203 CDE 1 bright;
			X203 FGHIJKLMNOPQRSTUVWXYZ 1 bright;
			Stop;
		Effect2:
			X005 CDE 1 bright;
			X005 FGHIJKLMNOPQRSTUVWX 1 bright;
			Stop;
		Effect3:
			X007 A 0 A_SetScale (1);
			X007 ABCDE 1 bright;
			X007 FGHIJKLMNOPQ 1 bright;
			Stop;
    }
}