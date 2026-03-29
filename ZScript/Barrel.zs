//Mostly based on the Smooth Doom barrels.
//Update: Now uses the CVP barrels, thanks iamcarrotmaster for giving me permission
class MO_ExplosiveBarrel : Actor
{
	int age;
	Default
	{
		Health 20;
		Radius 10;
		Height 42;
		+SOLID
		+SHOOTABLE
		+NOBLOOD
		+ACTIVATEMCROSS
		+DONTGIB
		+NOICEDEATH
		+OLDRADIUSDMG
		Obituary "$OB_BARREL";
		damagefactor "Blood", 0.0; damagefactor "BlueBlood", 0.0; damagefactor "GreenBlood", 0.0;	damagefactor "Avoid", 0.0;
		damagefactor "KillMe", 0.0;  damagefactor "TeleportRemover", 0.0; damagefactor "Slide", 0.0;
		+Windthrust
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

	States
	{
	Spawn:
		TNT1 A 0 Nodelay;
	Idle:
		BARL abcdefghijkl 3;
		Loop;
	Death:
		B3XP A 8 BRIGHT;
		B3XP B 6 BRIGHT;
		B3XP C 4 BRIGHT;
		TNT1 A 0 A_SpawnItemEx("BarrelExplosion",flags:SXF_NOCHECKPOSITION);
		TNT1 A 1050 BRIGHT A_BarrelDestroy;
		TNT1 A 5 A_Respawn;
		Wait;
	}
}

//This is basically the standard barrel but it has a lower quality explosion.
 //This was mainly made for Valiant: Vaccinated Editon's MAP17 and MAP18, and Sunlust's MAP30.
class MO_PerformanceBarrel : MO_ExplosiveBarrel
{
	States
	{
		Death:
		B3XP A 8 BRIGHT;
		B3XP B 6 BRIGHT;
		B3XP C 4 BRIGHT;
		TNT1 A 0 A_SpawnItemEx("CheapBarrelExplosion",flags:SXF_NOCHECKPOSITION);
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

Class BarrelExplosion : BaseVisualSFX
{
	Default
	{
		DamageType "Explosive";
		+NOGRAVITY
		+NOINTERACTION
		Obituary "$OB_BARREL";
		+BLOODLESSIMPACT
	}
	States
	{
		Spawn:
		TNT1 A 0 NoDelay Bright 
		{
				A_SpawnItemEx ("BarrelShrapnelA",random(0,3),random(0,3),random(4,8),random (5, -2),random (5, -2),random (6, 10),0,SXF_NOCHECKPOSITION | SXF_SETMASTER,0);
				A_SpawnItemEx ("BarrelShrapnelB",random(0,3),random(0,3),random(4,8),random (5, -2),random (5, -2),random (6, 10),0,SXF_NOCHECKPOSITION | SXF_SETMASTER,0);
				A_SpawnItemEx ("BarrelShrapnelC",random(0,3),random(0,3),random(4,8),random (5, -2),random (5, -2),random (6, 10),0,SXF_NOCHECKPOSITION | SXF_SETMASTER,0);
				A_SpawnItemEx ("BarrelShrapnelB",random(0,3),random(0,3),random(4,8),random (5, -2),random (5, -2),random (6, 10),0,SXF_NOCHECKPOSITION | SXF_SETMASTER,0);
				A_SpawnItemEx("BarrelExplosionFX",0,0,15,0,0,0,0,SXF_NOCHECKPOSITION,0);
				A_SpawnItemEx("MO_ShockWave",0,0,12, flags:SXF_NOCHECKPOSITION);
				A_StartSound("world/barrelexpl");
				A_StartSound("FarExplosion",8);
				RadiusAttack(self, 200, 200); //FIXED THE INCORRECT OBITUARY BUG!
				A_SpawnItemEx("MO_BarrelBottomRemains", flags: SXF_NOCHECKPOSITION);
		}
		TNT1 AAAA 0 A_SpawnItemEx("MO_BigSlowExplosionSmoke", 0, 0, 0, 0.10*random(-11, 11), 0.10*random(-11, 11), 0.10*random(1, 11));
		TNT1 AAAAAAAAA 0 A_SpawnItemEx("MO_ExplosionSmoke", 0, 0, 0, 0.10*random(-11, 11), 0.10*random(-11, 11), 0.10*random(1, 11));
		TNT1 AAAA 0 A_SpawnItemEx("MO_SmallFastExplosionSmoke", 0, 0, 0, 0.10*random(-11, 11), 0.10*random(-11, 11), 0.10*random(1, 11));
		TNT1 A 1 bright;
		Stop;
	}
}
Class CheapBarrelExplosion : BarrelExplosion
{
	States
	{
		Spawn:
		TNT1 A 0 Nodelay
		{
			A_StartSound("world/barrelexpl");
			A_StartSound("FarExplosion",8);
			RadiusAttack(self, 200, 200); //FIXED THE INCORRECT OBITUARY BUG!
		}
		B3XP D 4;
		b3xp EFGHIJKLMN 2 Bright;
		Stop;
	}
}

class PerformanceBarrelLPP : LevelPostProcessor //Replaces the barrel with another one with a low quality explosion
{
	protected void Apply(Name checksum, String mapname)
    {
		switch(checksum)
		{
			case 'FD332E22812A10FDCF438A2AE9847AE2': //Valiant VE MAP07
			case 'E4EAA1C784272D128257DD42BF99107C': // Valiant VE MAP18
			case '41EFE03223E41935849F64114C5CB471': // Sunlust MAP30
				for (int i = 0; i < GetThingCount(); i++)
				{
					int ednum = GetThingEdNum(i);
					if(ednum == 2035)
					{
						SetThingEdNum(i, 29011); 
					}
				}
				break;
		}
	}
}

