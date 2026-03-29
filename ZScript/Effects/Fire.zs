//Currently using Brutal Doom Flames for now. Might consider making my own in the future.

Class FlameTrails : Actor
{
	Default
	{
		Radius 1;
		Height 1;
		Speed 3;
		PROJECTILE;
		-NOGRAVITY;
		+FORCEXYBILLBOARD;
		+CLIENTSIDEONLY;
		+THRUACTORS;
		+DOOMBOUNCE;
		RenderStyle "Add";
		damagetype "fire";
		Scale 0.5;
		Gravity 0;
		Alpha 0.75;
	}
	States
	{
    Spawn:
        TNT1 A 2;
        FRPR ABCDEFGH 3 BRIGHT;
        Stop;
	}
}

Class SmallFlameTrails: FlameTrails
{
		Default{Scale 0.3;}
}

Class MO_FlameTrails : FlameTrails{}

Class MO_SmallFlameTrails : SmallFlameTrails{}

Class MolotovFlames : Actor
{
	Default
	{
		Radius 8;
		Height 8;
		Speed 11;
		Scale .8;
		Mass 1;
		Damage 3;
		Renderstyle "Add";
		+NOBLOCKMAP;
		+MISSILE;
		+NOTELEPORT;
		+MOVEWITHSECTOR;
		+RIPPER;
		+BLOODLESSIMPACT ;
		-DONTSPLASH;
		DamageType "Fire";
		+THRUGHOST;
	}
    States
    {
    Spawn:
	    TNT1 A 0 A_JumpIf(waterlevel > 1, "Underwater");
        TNT1 A 2 A_SpawnProjectile ("FlameTrails", 0, 0, random (0, 360), 2, random (0, 180));
        Loop;
    Death:
	TNT1 AAAAAA 0 A_SpawnProjectile ("FlameTrails", 0, 0, random (0, 360), 2, random (0, 180));
	NF3R ABCDFEGHIJKLMNOP 1 BRIGHT;
	TNT1 A 0 A_SetScale(1.4, 0.7);
	
	NF3R ABCDFEGHIJKLMNOP 1 BRIGHT;
	TNT1 A 0 A_SetScale(1.2, 0.6);
	NF3R ACEGIKMO 1 BRIGHT;
	TNT1 A 0 A_SetScale(1.2, 0.5);
	NF3R ACEGIKMO 1 BRIGHT;
	TNT1 A 0 A_SetScale(1.0, 0.4);
	NF3R ACEGIKMO 1 BRIGHT;
	TNT1 A 0 A_SetScale(1.0, 0.3);
	NF3R ACEGIKMO 1 BRIGHT;
	TNT1 A 0 A_SetScale(1.0, 0.2);
	Stop;
     Underwater:
	 Splash:
	    TNT1 A 1;
        Stop;
    }
}

Class MolotovFlames2: MolotovFlames
{
	Default{speed 6;}
}

Class MolotovFlames3: MolotovFlames
{
	Default{speed 9;}
}

class FireworkSFXType1 : Actor
{
	Default
	{
	Radius 4;
	Height 4;
	Speed 18;
	PROJECTILE;
    +THRUGHOST;
	RenderStyle "Add";
	+MISSILE;
	-NOGRAVITY;
	Gravity 1;
	Alpha 1.0;
	}
	States
	{
	Spawn:
		TNT1 A 0 A_SpawnProjectile ("SmallFlameTrails", 2, 0, random (170, 200), 2, random (-20, 20));
		TNT1 A 1 A_SpawnItem ("SmallFlameTrails");
//		TNT1 A 1 A_SpawnItem("RedFlareSmall");
//		TNT1 A 1 A_SpawnItem("RedFlareSmall");
		Loop;
	
	Death:
		TNT1 A 1; //A_SpawnItemEx("TinyBurningPiece", random (-15, 15), random (-15, 15));
		Stop;
	}
}


Class FireworkSFXType2: FireworkSFXType1
{
	Default
	{
	Radius 2;
	Height 2;
	BounceType "Doom";
	Speed 11;
	WallBounceFactor 0.5;
	BounceFactor 0.2;
	}
	States
	{
	Death:
		TNT1 A 0;
		Stop;
	}
}

Class MO_ExplosionFlames: FlameTrails
{
	Default
	{
	Scale 2.2;
	Speed 2;
	+DOOMBOUNCE;
	}
	States
	{
    Spawn:
        EXPL A 3 BRIGHT;// A_SpawnItem("RedFlare",0,0);
		EXPL AA 0; //A_CustomMissile ("ExplosionSmokeHD", 0, 0, random (0, 360), 2, random (0, 360));
        EXPL BCDEFGH 3 BRIGHT;
        Stop;
	}
}

Class MO_GreenExplosionFlames : MO_ExplosionFlames
{
	Default
	{Scale 1.75;}
	States
	{
		Spawn:
        EXPG A 3 BRIGHT;// A_SpawnItem("RedFlare",0,0);
		EXPL AA 0; //A_CustomMissile ("ExplosionSmokeHD", 0, 0, random (0, 360), 2, random (0, 360));
        EXPG BCDEFGH 3 BRIGHT;
        Stop;
	}
}