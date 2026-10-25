Class MO_BulletPuff : BulletPuff //Inherits from base BulletPuff to fix a sound glitch with the Revenant Tracer playing the riochet sound repeatedly
{
	Default
	{
	-ALLOWPARTICLES;
	-DONTSPLASH;
	-EXPLODEONWATER;
	+NOEXTREMEDEATH;
    +FORCEXYBILLBOARD;
	+THRUACTORS;
	+NOCLIP;
	+NOGRAVITY;
	RenderStyle "Add";
	Scale .1;
	Alpha 0.8;
	VSpeed 0;
	Decal "BulletChip";
	Height 1;
	}
	States
	{
		Spawn:
		TNT1 A 0;
		TNT1 A 0 A_SpawnItemEX("BulletImpactSmoke");
		SPRK AAA 0 A_SpawnProjectile("MO_RocketSmokeTrail", 2, 0, random(0, 360), flags:CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH, pitch: random(0, 360));
		SPRK A 0 A_SpawnItemEx("SparkSpray", 2, 0, 0, 0, 0, 0, 0);
		SPRK A 0 A_SpawnItemEx("GunsmokeSpray", -2, random(-2, 2), random(-2, 2), 0, 1.5+random(0,10)*0.1, random(-5,5)*0.1, 0);
		TNT1 AAA 0 A_SpawnProjectile("EnhancedHitSpark1", 2, 0, frandom(0,1)*frandom (-180, 180),  flags:CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH, pitch: pitch - frandom(0,1)*frandom (30, 360));
		TNT1 AA 0 A_SpawnProjectile("EnhancedHitSpark2", 2, 0, frandom(0,1)*frandom (-180, 180), flags:CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH, pitch: pitch - frandom(0,1)*frandom (30, 360));
		TNT1 A 0 A_SpawnProjectile("EnhancedHitSpark3", 2, 0, frandom(0,1)*frandom (-180, 180), flags:CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH, pitch: pitch - frandom(0,1)*frandom (30, 360));
		TNT1 A 0
		{
			if(CVar.FindCVar("mo_bulletsparksound").GetBool() == False)
			{return resolvestate("NoSound");}
			return resolvestate(null);
		}
		TNT1 A 0 A_StartSound("ricochet",7);
		NoSound:
		TNT1 A 1 A_SpawnItemEx("BulletRicochet",0,0,0,0,0,0);
		TNT1 A 1 BRIGHT;
		STOP;
	}
}

Class UpdatedBulletPuff : MO_BulletPuff{}

Class KatanaPuff : UpdatedBulletPuff
{
	Default
	{
		DamageType "Cut"; //For Brutal Doom Monsters only compatiblity
		-ALLOWPARTICLES
		Decal "SwordSlashMark";
		+NOINTERACTION;	
	} 
	
	States
	{
		Spawn:
		Melee:
		TNT1 CD 4;
		Stop;
		
		Death:
		Crash:
			TNT1 A 0 A_StartSound("Weapons/Katana/Miss");
			TNT1 A 0 A_SpawnDebris("Sparky");
			TNT1 AAA 0 A_SpawnProjectile("EnhancedHitSpark1", 2, 0, frandom(0,1)*frandom (-180, 180),  flags:CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH, pitch: pitch - frandom(0,1)*frandom (30, 360));
			TNT1 AA 0 A_SpawnProjectile("EnhancedHitSpark2", 2, 0, frandom(0,1)*frandom (-180, 180), flags:CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH, pitch: pitch - frandom(0,1)*frandom (30, 360));
			TNT1 A 0 A_SpawnProjectile("EnhancedHitSpark3", 2, 0, frandom(0,1)*frandom (-180, 180), flags:CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH, pitch: pitch - frandom(0,1)*frandom (30, 360));
			BPUF ABCD 1 bright Light("BulletHitLight");
			STOP;
	}
}

class KatanaPuff2 : KatanaPuff // Same as KatanaPuff but it spawns the flipped decal
{Default {Decal "SwordSlashMarkFlipped";}}

class MO_SawPuff : KatanaPuff
{
	Default
	{
		DamageType "Saw";
	}

	States
	{
		Spawn:
		Melee:
		Death:
		Crash:
			TNT1 A 0 A_StartSound("Chainsword/hitwall");
			TNT1 A 0 A_SpawnDebris("Sparky");
			TNT1 AAA 0 A_SpawnProjectile("EnhancedHitSpark1", 2, 0, frandom(0,1)*frandom (-180, 180),  flags:CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH, pitch: pitch - frandom(0,1)*frandom (30, 360));
			TNT1 AA 0 A_SpawnProjectile("EnhancedHitSpark2", 2, 0, frandom(0,1)*frandom (-180, 180), flags:CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH, pitch: pitch - frandom(0,1)*frandom (30, 360));
			TNT1 A 0 A_SpawnProjectile("EnhancedHitSpark3", 2, 0, frandom(0,1)*frandom (-180, 180), flags:CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH, pitch: pitch - frandom(0,1)*frandom (30, 360));
			BPUF ABCD 1 bright Light("BulletHitLight");
			STOP;
	}
}

class MO_SawPuff2 : MO_SawPuff
{Default {Decal "SwordSlashMarkFlipped";}}

class MinigunPuff : UpdatedBulletPuff
{
	Default
	{
		DamageType "Minigun"; //For Brutal Doom Monsters only compatiblity, to shred up the monsters
	} 
}

class ShotgunShellPuff : UpdatedBulletPuff
{
	Default
	{
		DamageType "Shotgun"; //For Brutal Doom Monsters only compatiblity, to shred up the monsters
	} 
}

class ShotgunPuff20GA : ShotgunShellPuff
{
	States
	{
		Spawn:
		TNT1 A 0;
		TNT1 A 0 A_SpawnItemEX("BulletImpactSmoke");
		SPRK A 0 A_SpawnItemEx("SparkSpray", 2, 0, 0, 0, 0, 0, 0);
		SPRK AAA 0 A_SpawnProjectile("MO_RocketSmokeTrail", 2, 0, random(0, 360), flags:CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH, pitch: random(0, 360));
		SPRK A 0 A_SpawnItemEx("LittleGunsmokeSpray", -2, random(-2, 2), random(-2, 2), 0, 1.5+random(0,10)*0.1, random(-5,5)*0.1, 0);
		TNT1 AAA 0 A_SpawnProjectile("EnhancedHitSpark1", 2, 0, frandom(0,1)*frandom (-180, 180),  flags:CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH, pitch: pitch - frandom(0,1)*frandom (30, 360));
		TNT1 AA 0 A_SpawnProjectile("EnhancedHitSpark2", 2, 0, frandom(0,1)*frandom (-180, 180), flags:CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH, pitch: pitch - frandom(0,1)*frandom (30, 360));
		TNT1 A 0 A_SpawnProjectile("EnhancedHitSpark3", 2, 0, frandom(0,1)*frandom (-180, 180), flags:CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH, pitch: pitch - frandom(0,1)*frandom (30, 360));
		TNT1 A 0
		{
			if(CVar.FindCVar("mo_bulletsparksound").GetBool() == False)
			{return resolvestate("NoSound");}
			return resolvestate(null);
		}
		TNT1 A 0 A_StartSound("ricochet",7);
		NoSound:
		TNT1 A 1 A_SpawnItemEx("BulletRicochet",0,0,0,0,0,0);
		TNT1 A 1 BRIGHT;
		STOP;
	}
}

class MO_SSGPuff : UpdatedBulletPuff
{
	Default
	{
		DamageType "SSG"; //For Brutal Doom Monsters only compatiblity, to shred up the monsters
	} 
}

class KickingPuff : UpdatedBulletPuff
{	
	Default
	{
		DamageType "Kick";
		+NODECAL;
		-ALLOWPARTICLES;
		ProjectileKickback 300;
		Obituary "%k gave %o a taste of %p boot.";
	} 
	States
	{
		Spawn:
//		Melee:
		TNT1 CD 4;
		Stop;

		Melee:
			TNT1 A 1 A_RadiusThrust(3, -1, RTF_NOTMISSILE|RTF_NOIMPACTDAMAGE);
			Stop;
		Crash:
			TNT1 A 0 A_SpawnItemEx("KickSmoke");
			TNT1 A 1 A_StartSound("playerkick/footwall", 3);
			TNT1 AA 4;
			STOP;
	}
}

class ChainsawBashPuff : KickingPuff
{
	Default
	{
		Obituary "$OB_CHAINSWORDBASH";
	}
	States
	{
		Crash:
			TNT1 A 0 A_SpawnItemEx("KickSmoke");
			TNT1 A 1 A_StartSound("Chainsword/BashHit", 3);
			TNT1 AA 4;
			STOP;
	}
}

Class BerserkKickPuff : KickingPuff
{
	Default
	{
		DamageType "ExtremePunches"; //For Brutal Doom Monsters only compatiblity
		-ALLOWPARTICLES
		ProjectileKickback 800;
	} 
}

class BerserkChainsawBashPuff : ChainsawBashPuff 
{
	Default
	{
		ProjectileKickback 800;
	}
}

Class PlasmaBeamPuff : UpdatedBulletPuff
{
	Default
	{
		Decal "none";
		Scale 0.07;
		DamageType "Plasma";
	}
	
	States
	{
	Spawn:
	Crash:
		TNT1 AAA 0 A_SpawnItemEx("BlueLightningMini", Random(-4, 4), Random(-4, 4), Random(-4, 4), 0, 0, 0, 0, 0, 64);
		TNT1 AA 0 A_SpawnItemEx("BlueLightningTiny", Random(-4, 4), Random(-4, 4), Random(-4, 4), 0, 0, 0, 0, 0, 128);
		TNT1 A 0 A_SpawnItemEx("BlueLightningSmall", Random(-4, 4), Random(-4, 4), Random(-4, 4), 0, 0, 0, 0, 0, 192);
		TNT1 AAA 0 A_SpawnProjectile("EnhancedPlasmaSpark1", 2, 0, frandom(0,1)*frandom (-180, 180),  flags:CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH, pitch: pitch - frandom(0,1)*frandom (30, 360));
		TNT1 AA 0 A_SpawnProjectile("EnhancedPlasmaSpark2", 2, 0, frandom(0,1)*frandom (-180, 180), flags:CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH, pitch: pitch - frandom(0,1)*frandom (30, 360));
		TNT1 AA 0 A_SpawnProjectile("EnhancedPlasmaSpark3", 2, 0, frandom(0,1)*frandom (-180, 180), flags:CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH, pitch: pitch - frandom(0,1)*frandom (30, 360));
		TNT1 AAAA 1 LIGHT("PlasmaBallLight");
		Stop;
	}
}

Class Sparky : Actor
{
  Default
  {
  +NoTeleport;
  +ForceXYBillboard;
  +missile;
  +dontsplash;
  Health 4;
  Radius 3;
  Height 6;
  Speed 0.1;
  BounceType "Doom";
  RenderStyle "ADD";
  Alpha 0.85;
  Scale 0.04;
  Mass 0;
  }
  States
  {
  Spawn:
    BPUF ABCD 1 bright A_FadeOut(0.05);
    loop;
  }
}

//From Particle Fire Enhancer Mod (v0.8) by Z86
Class MO_BulletTracer : FastProjectile
{
	Default
	{
	RenderStyle "Add";
	Alpha 0.8;
	YScale 0.12;
	XScale 0.3;
	Speed 300;
	radius 10;
	height 8;
	damage 0;
	+PAINLESS;
	SeeSound "Whizby";
	}
	States
	{
	Spawn:
		TRAC A 1 bright;
		loop;
	Death:
		TNT1 A 0;
		stop;
	}
}

Class MO_BFG10KShotTracer : MO_BulletTracer
{

	Default
	{
		Speed 400;
		SeeSound "none";
		YScale 0.75;
		XScale 0.75;
	}
	States
	{
		Spawn:
			TNT1 AA 0
			{
				A_SpawnItemEx("GreenLightningTiny", -Vel.x, -Vel.y, -Vel.z, Vel.x, Vel.y, Vel.z, 0, SXF_ABSOLUTEMOMENTUM|SXF_ABSOLUTEPOSITION, 172);
				A_SpawnItemEx("GreenLightningSmall", -Vel.x, -Vel.y, -Vel.z, Vel.x, Vel.y, Vel.z, 0, SXF_ABSOLUTEMOMENTUM|SXF_ABSOLUTEPOSITION, 216);
				A_SpawnItemEx("GreenLightningMedium", -Vel.x, -Vel.y, -Vel.z, Vel.x, Vel.y, Vel.z, 0, SXF_ABSOLUTEMOMENTUM|SXF_ABSOLUTEPOSITION, 248);
			}
			BFS1 AB 1 BRIGHT Light("BFG10KBallLight");
			LOOP;
	}
}