//Mostly based on the Smooth Doom barrels.
//Update: Now uses the CVP barrels, thanks iamcarrotmaster for giving me permission
class MO_ExplosiveBarrel : ExplosiveBarrel replaces ExplosiveBarrel
{
	bool isSunlust; //For Sunlust's Map 30 for the crushers as the beginning of the level.
	int age;
	Default
	{
		DeathSound "world/barrelexpl";
		Obituary "$OB_BARREL";
		+Windthrust
	}

	override void PostBeginPlay()
	{
		isSunlust = true;
	}

	override int DamageMobj (Actor inflictor, Actor source, int damage, Name mod, int flags, double angle)
	{
		if (mod == "Kick" || mod == "LowKick" || mod == "ExtremePunches" || mod == "Melee")
		{
			ThrustThingZ(0,10,0,1);
			ThrustThing(angle*256/360, 10, 0, 0);
			return 0;
		}
		return super.DamageMobj(inflictor, source, damage, mod, flags, angle);
	}

	//This is for Sunlust's Map 30 when the barrels at the beginning get crushed when the map starts.
	override void Tick()
	{
		super.Tick();
		age++;
		if(age >= 35)
		{
			self.isSunlust = false;
		}
	}
		

	States
	{
	Spawn:
		BARL abcdefghijkl 3;
		Loop;
	Death:
		B3XP A 8 BRIGHT;
		B3XP B 6 BRIGHT;
		B3XP C 4 BRIGHT;
	Death.Crush:
		BEXP E 0 A_JumpIf(invoker.isSunlust, "PerformanceDeath");
		bexp E 0 Bright 
		{
				A_SpawnItemEx ("BarrelShrapnelA",random(0,3),random(0,3),random(4,8),random (5, -2),random (5, -2),random (6, 10),0,SXF_NOCHECKPOSITION | SXF_SETMASTER,0);
				A_SpawnItemEx ("BarrelShrapnelB",random(0,3),random(0,3),random(4,8),random (5, -2),random (5, -2),random (6, 10),0,SXF_NOCHECKPOSITION | SXF_SETMASTER,0);
				A_SpawnItemEx ("BarrelShrapnelC",random(0,3),random(0,3),random(4,8),random (5, -2),random (5, -2),random (6, 10),0,SXF_NOCHECKPOSITION | SXF_SETMASTER,0);
				A_SpawnItemEx ("BarrelShrapnelB",random(0,3),random(0,3),random(4,8),random (5, -2),random (5, -2),random (6, 10),0,SXF_NOCHECKPOSITION | SXF_SETMASTER,0);
				A_SpawnItemEx("BarrelExplosionFX",0,0,12,0,0,0,0,SXF_NOCHECKPOSITION,0);
				A_SpawnItemEx("MO_ShockWave",flags:SXF_NOCHECKPOSITION);
				A_Scream();
				A_StartSound("FarExplosion",8);
				A_Explode();
				A_SpawnItemEx("MO_BarrelBottomRemains", flags: SXF_NOCHECKPOSITION);
		}
		TNT1 A 1050 BRIGHT A_BarrelDestroy;
		TNT1 A 5 A_Respawn;
		Wait;
	PerformanceDeath:
		TNT1 A 0
		{
			A_Scream();
			A_StartSound("FarExplosion",8);
			A_Explode();
		}
		b3xp DEFGHIJKLMN 2 Bright;
		TNT1 A 1050 Bright A_BarrelDestroy;
		TNT1 A 5 A_Respawn;
		Wait;
	}
}

//Effects
class MO_BarrelBottomRemains : actor
{
	Default
	{
		Scale 0.9;
		Radius 2;
		Height 5;
	}
	States
	{
		Spawn:
			BARP DE 0;
			BARP D -1 {frame = random(3,4);}
			Stop;
	}
}

Class BarrelShrapnelBase : actor
{
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		frame = shrapFrame;
	}

	int ShrapFrame;
	Property ShrapnelFrame : shrapFrame;
	Default
	{
		Radius 2;
		Height 2;
		Speed 10;
		Mass 1;
		Gravity 0.9;
		Mass 15;
		Scale 0.5;
		BounceFactor 0.4;
		BounceCount 4;
		+MISSILE
		+NOBLOCKMAP
		+NOTELEPORT
		+MOVEWITHSECTOR
		+ROLLSPRITE
		//+CLIENTSIDEONLY
		+THRUACTORS
		+DontSplash
		+FLOORCLIP
		BounceType "Doom";
		BarrelShrapnelBase.ShrapnelFrame 0;
	}
		States {
			Spawn:
				BARP # 0;
				#### # 1;
				Goto Spinning;
			Spinning:
				"####" "#" 1 A_Setroll(roll+22.5);
				Loop;
			Death:
				"####" "#" 0 A_SetRoll(0);
				"####" "#" 1;
				"####" "#" 300;
				"####" "###############" 2 A_FadeOut(0.1);
				Stop;
			CacheTextures:
				BARP ABC 0;
				Stop;
	}
}

Class BarrelShrapnelA : BarrelShrapnelBase
{
	Default
	{
		BarrelShrapnelBase.ShrapnelFrame 0;
	}
}

Class BarrelShrapnelB : BarrelShrapnelBase
{
	Default
	{
		BarrelShrapnelBase.ShrapnelFrame 1;
	}
}

Class BarrelShrapnelC : BarrelShrapnelBase
{
	Default
	{
		BarrelShrapnelBase.ShrapnelFrame 2;
	}
}