//Throwables

class MolotovAmmo : Ammo
{
    Default
    {
        Inventory.Amount 1;
        Inventory.MaxAmount 6;
        Ammo.BackPackAmount 3;
        Ammo.BackPackMaxAmount 12;
        Inventory.PickUpMessage "You got a Molotov Cocktail.";
        Inventory.PickupSound "MOLPKUP";
        Inventory.Icon "MOLOV0";
		Inventory.AltHUDIcon "MOL0Z0";
        Scale 0.45;
        // +SHOOTABLE
		+INVENTORY.IGNORESKILL;
	}
        States
        {
        Spawn:
            MOLO V -1;
            Stop;
    }
}

//Taken from the Molotov Cocktails add-on for PB, Glass code from BD converted to ZScript
class MolotovGlassParticle: Actor //LargeGlassParticle1
{
    Default
    {
        Renderstyle "Translucent";
        Scale 0.6;
        Alpha 0.7;
        Speed 7;
        Mass 0;
        BounceFactor 0.5;
        +noteleport;
        +missile;
        +bounceonactors;
        +doombounce;
        +forcexybillboard;
        +CLIENTSIDEONLY;
        Gravity 0.7;
        height 1;
        radius 1;
    }
	States
    {
    Spawn:
	MOLG ABCDEFGH 3;
	Loop;
	Death:
	MOLG C 1;
	MOLG C -1;
    Stop;
    }
}

class MolotovThrown : Actor
{
    Default
    {
        Radius 2;
        Height 3;
        Projectile;
        Speed 30;
        DamageFunction 5;
        Gravity 0.7;
        Scale 0.2;
        +MISSILE;
        -NOGRAVITY;
        -BLOODSPLATTER;
        -EXTREMEDEATH;
        +EXPLODEONWATER;
        +SKYEXPLODE;
        +FLOORCLIP;
        +DONTGIB;
        +MTHRUSPECIES;
        +THRUSPECIES;
        +DontHarmSpecies;
        +NoExtremeDeath;
        DamageType "Fire";
        BounceFactor 0.5;
        WallBounceFactor 0.25;
        Health 5;
//        SeeSound "MOLOTOV/TOSS";
        DeathSound "Molotov/Burning";
        Obituary "%o was burned by %k's Molotov.";
    }
	States
	{
	Spawn:
		TNT1 A 0;
		Goto Spawn1;
	Spawn1:
	SpawnSpin:
		MOLP AABBCCDDEEFFGGHH 1 A_SpawnProjectile ("FlameTrails", 15, 0, random (0, 360), 2, random (50, 130));
		Loop;
	Death:
		TNT1 A 0 A_SCREAM();
		TNT1 A 0 A_StartSound ("Molotov/BREAK", CHAN_AUTO, CHANF_DEFAULT);
		TNT1 AAAAAAAAAA 0 A_SpawnProjectile("MolotovGlassParticle",random(5,60),random(-3,3),pitch+random (0, 360), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_SAVEPITCH,random(-70,-20));
		TNT1 A 0 A_Explode(75,85,XF_HURTSOURCE|XF_THRUSTLESS,false,75,0,0,"","Fire");
		TNT1 A 0 A_NoBlocking;
		TNT1 A 0 A_AlertMonsters();
		TNT1 AA 0 A_SpawnProjectile ("MolotovFlames3", 32, 0, pitch+random (0, 360), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_SAVEPITCH, random (10-30, -10));
		TNT1 AA 0 A_SpawnProjectile ("MolotovFlames2", 32, 0, pitch+random (0, 360), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_SAVEPITCH, random (-30, -10));
		TNT1 AA 0 A_SpawnProjectile ("MolotovFlames3", 32, 0, pitch+random (0, 360), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_SAVEPITCH, random (-30, -10));
		TNT1 AAAA 0 A_SpawnProjectile ("FireworkSFXType2", 32, 0, pitch+random (0, 360), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_SAVEPITCH, random (-25, -10));
		TNT1 A 0 A_SpawnItem("MolotovFlameDamage");
		TNT1 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 1 A_SpawnItemEx("MolotovFlames", random(-24,24), random(-30,30), random(-16,16), 1, 2, 1, 0, 128);
		Stop;
	}
}

Class MolotovFlameDamage : BaseVisualSFX
{
	int flameTimer;
	Default
	{	
		+DONTSPLASH
		+DONTTHRUST
		+NOTIMEFREEZE
		+NOTRIGGER
		-FORCEXYBILLBOARD
		-CLIENTSIDEONLY
		+BLOODLESSIMPACT
		Height 12;
		Radius 20;
		DamageType "Fire";
	}

	override void Tick()
	{
		Super.Tick();
		flameTimer++;
		if(flameTimer >= 105) self.Destroy();
	}

	States
	{
		Spawn:
		TNT1 A 0 NoDelay;
		TNT1 A 12;
		TNT1 A 0 A_Explode(random(10,16), 130, XF_HURTSOURCE|XF_NOSPLASH|XF_THRUSTLESS, true, 25);
		Loop;
	}
}
Class MO_ThrownGrenade : Actor
{
	int timer;
	bool grenExploded; //To fix a weird issue of the rested grenade sprite still being on screen after exploding.
	Default
	{
	Radius 6;
	Height 12;
	Projectile;
	Speed 36;
    DamageFunction (6);
    Gravity 0.7;
	Scale 0.25;
	Projectile;
	+MISSILE;
    -NOGRAVITY;
    -BLOODSPLATTER;
	+EXTREMEDEATH;
	+EXPLODEONWATER;
	+SKYEXPLODE;
	+BOUNCEONFLOORS;
	+BOUNCEONWALLS;
	+BOUNCEONCEILINGS;
	+NOTELEPORT;
	BounceType "Doom";
	+THRUSPECIES;
	BounceFactor 0.5;
	WallBounceFactor 0.25;
    Health 1;
    BounceSound "FragGrenade/Bounce";
	DeathSound "none";
	Obituary "%o got blown away by %k's frag grenade.";
	}

	States
	{
	Spawn:
		TNT1 A 0 NoDelay
		{
			let player = MO_PlayerBase(target);
			let nade = MO_ThrownGrenade(self);
			nade.timer = player.CountInv("GrenadeCookTimer");
		}
	SpawnLoop:
		GNDE AABBCCDDEEFF 1 
		{	
			timer++;
			if(waterlevel < 1) 
			{
					A_SpawnItemEx("MO_GrenadeSmokeTrail",-3,0,0,-1,0,0);
			}
			if(timer >= 105) {Return ResolveState("Explode");}
			return ResolveState(Null);
		}
		Loop;

	Death:
		GNDE G 0 {bXFLIP = random(0,1);}
	RestLoop:
	    GNDE G 1
		{	
			timer++;
			if(waterlevel < 1) 
			{
					A_SpawnItemEx("MO_GrenadeSmokeTrail",-3,0,0,-1,0,0);
			}
			if(timer >= 105) {Return ResolveState("Explode");}
			return ResolveState(Null);
		}
		#### # 0 A_JumpIf(timer >= 105, "Explode");
		Loop;

	XDeath:
	Explode:
		TNT1 A 0;
		TNT1 A 0 A_Explode(125, 220);
		TNT1 A 0 A_NoBlocking;
		TNT1 A 0 A_AlertMonsters();
		TNT1 A 0 A_StartSound("fraggrenade/explosion", 6);
		TNT1 A 0 A_StartSound("fraggrenade/farexplosion", 9);
		TNT1 A 0 A_SpawnItemEx("RocketExplosionFX",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
		TNT1 A 1;
		TNT1 A 0 Destroy();
		Stop;
	Disappear:
		TNT1 A -1;
		STOP;
	}
}

class GrenadeAmmo : Ammo
{
    Default
    {
        Inventory.Amount 1;
        Inventory.MaxAmount 8;
        Ammo.BackPackAmount 5;
        Ammo.BackPackMaxAmount 16;
        Inventory.PickUpMessage "You picked up a Frag Grenade.";
        Inventory.PickupSound "FragGrenade/Pickup";
        Inventory.Icon "PGRND0";
		Inventory.AltHUDIcon "PGRND0";
        Scale 0.6;
        // +SHOOTABLE
		+INVENTORY.IGNORESKILL;
	}
        States
        {
        Spawn:
            PGRN D -1;
            Stop;
    }
}