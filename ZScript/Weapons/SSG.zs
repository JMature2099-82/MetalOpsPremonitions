//SuperShotgun

class MO_SSG : MO_Weapon replaces SuperShotgun
{
	int shotCount; //only here if infinite ammo cheats or powerup is detected
    Default
    {
        Weapon.AmmoUse1 1;
        Weapon.AmmoGive2 8;
        Weapon.AmmoType1 "SSGAmmo";
		Weapon.AmmoType2 "MO_ShotShell";
        Inventory.PickupMessage "You got the Double Barrel Flak Shotgun! (Slot 3)";
        Obituary "$OB_MPSSHOTGUN";
        Tag "Double Barrel Flak Shotgun";
		Inventory.PickupSound "weap/ssg/pickup";
		Weapon.SelectionOrder 400;
		+WEAPON.NOAUTOSWITCHTO
		+WEAPON.AMMO_OPTIONAL;
    }

	action void MO_AddShotCount(int i)
	{
		if(invoker.OwnerHasInfiniteAmmo())
		invoker.shotCount = invoker.shotCount + i;
	}

	action void MO_ResetShotCount()
	{
		invoker.shotCount = 0;
	}

	action int MO_CheckShotCount()
	{
		if(invoker.OwnerHasInfiniteAmmo())
		return invoker.shotCount;
		else
		return 0;
	}

	action void MO_FireSSG()
	{
		for(int i = 2; i > 0; i--) 
		{
			A_FireProjectile("FlakChunk2",random(-2,2),0,18,16);
			A_FireProjectile("FlakChunk1",random(-2,2),0,15,-13);
			A_FireProjectile("FlakChunk3",random(-2,2),0,13,6);
			A_FireProjectile("FlakChunk4",random(-2,2),0,0,-15);
			A_FireProjectile("FlakChunk4",random(-2,2),0,0,-15);
			A_FireProjectile("FlakChunk1",random(-2,2),0,-13,8);
			A_FireProjectile("FlakChunk2",random(-2,2),0,-15,12);
			A_FireProjectile("FlakChunk3",random(-2,2),0,-18,6);
		}
		MO_AddShotCount(2);
	}

	//Right Alt Fire
	action void MO_FireSSG2()
	{
		A_FireProjectile("FlakChunk2",random(-2,2),0,18,16);
		A_FireProjectile("FlakChunk1",random(-2,2),0,15,-13);
		A_FireProjectile("FlakChunk3",random(-2,2),0,13,6);
		A_FireProjectile("FlakChunk4",random(-2,2),0,0,-15);
		MO_AddShotCount(1);
	}

	//Left Alt Fire
	action void MO_FireSSG3()
	{
		A_FireProjectile("FlakChunk4",random(-2,2),0,0,-15);
		A_FireProjectile("FlakChunk1",random(-2,2),0,-13,8);
		A_FireProjectile("FlakChunk2",random(-2,2),0,-15,12);
		A_FireProjectile("FlakChunk3",random(-2,2),0,-18,6);
		MO_AddShotCount(1);
	}

    States
    {
		Ready:
        ReadyToFire:
            SG2S D 1 JM_WeaponReady(WRF_ALLOWRELOAD);
            Loop;

		Select:
			TNT1 A 0;
			TNT1 A 0 A_SetCrosshair(invoker.GetXHair(6));
		ContinueSelect:
			MGNG A 0 MO_Raise();
		SelectAnimation:
			TNT1 A 0 A_JumpIf(CountInv("SSGAmmo") < 1,"ReloadAnimation");
		JustSelectTheSSG:
            TNT1 A 0 A_StartSound("weapons/ssg/draw", 0);
            SG2S ABCD 1;
			Goto Ready;

		Deselect:
			TNT1 A 0 A_SetCrosshair(invoker.GetXHair(6));
			 SG2S DCBA 1;
			 TNT1 A 0 A_Lower(12);
			 Wait;

        Fire:
            SG2S A 0 MO_JumpIfLessAmmo(2, "AltFire2");
			SG2S AAA 0;
			SG2S A 0 A_JumpIf(MO_CheckShotCount() >= 1, "AltFire2");
            SG2F A 1 BRIGHT
            {
				for(int i = 2; i > 0; --i)
				{if (!invoker.DepleteAmmo(false, true,  forceammouse: true)) {return;}}
                A_StartSound("weapons/ssg/fire", 1);
				JM_CheckForQuadDamage();
                MO_FireSSG();
            }
            SG2F B 1 BRIGHT JM_GunRecoil(-2.1, .12);
            SG2F C 1 JM_GunRecoil(-1.86, .12);
            SG2F DEF 1 JM_GunRecoil(.4, .12);
			SG2F GHIJ 1;
            SG2S D 3;
			SG2S A 0 JM_WeaponReady(WRF_NOFIRE);
            SG2S A 0 A_JumpIfInventory("MO_ShotShell", 1, "Reload");
			SG2S A 0 A_JumpIf(MO_CheckShotCount() >= 2, "Reload");
            Goto ReadyToFire;

        AltFire:
            SG2S A 0 MO_JumpIfLessAmmo(2, "AltFire2");
			SG2S AAA 0;
			SG2S A 0 A_JumpIf(MO_CheckShotCount() >= 1, "AltFire2");
            SG2A A 1 BRIGHT
            {
                A_StartSound("weapons/ssg/altfire", 1);
                MO_FireSSG2(); //Left
                {if (!invoker.DepleteAmmo(false, true)) {return;}}
				JM_CheckForQuadDamage();
            }
            SG2A B 1 BRIGHT JM_GunRecoil(-1.1, .12);
            SG2F C 1 JM_GunRecoil(-1.1, .12);
            SG2F DE 1 JM_GunRecoil(0.3, .12);
			SG2F HIJ 1;
            SG2S D 1;
            Goto ReadyToFire;
        
        AltFire2:
			SG2S A 0 MO_JumpIfLessAmmo;
            SG2A C 1 BRIGHT
            {
                A_StartSound("weapons/ssg/altfire", 1);
                MO_FireSSG3(); //Left
                {if (!invoker.DepleteAmmo(false, true)) {return;}}
				JM_CheckForQuadDamage();
            }
            SG2A D 1 BRIGHT JM_GunRecoil(-1.1, -.12);
            SG2F C 1 JM_GunRecoil(-1.1, -.12);
            SG2F DE 1  JM_GunRecoil(-.5, -.12);
			SG2F HIJ 1;
            SG2S D 1;
            Goto Reload;

        Reload:
			SG2S A 0 A_JumpIf(MO_CheckShotCount() >= 2, 3);
			SG2S A 0 MO_CheckReload(2,1,null,null, "ReadyToFire");
			SG2S AAA 0;
            SGR1 ABCD 1;
            SGR1 E 1 A_StartSound("weapons/ssg/opengun", 6);
		ContinueReload:
            SGR1 F 1;
            SGR1 a 0 A_JumpIf(CountInv("SSGAmmo") == 1, "HalfReload");
            SGR1 G 1
            {
                A_Overlay(2, "ReloadSmokeRight",false);
                A_Overlay(3, "ReloadSmokeLeft",false);
                MO_EjectCase("FlakShotgunCasing", 19, 3, 11, random(-4, -2), random(-5,-4), random(5,6));
				MO_EjectCase("FlakShotgunCasing", 19, -3, 11, random(-4, -2), random(-5,-4), random(5,6));
                A_StartSound("weapons/ssg/opengas", 7,CHANF_DEFAULT,1);
            }
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
            SGR1 HIJK 1; //JM_WeaponReady(WRF_NOFIRE);
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,3);
            SGR1 KKKK 1; 
			TNT1 A 0 A_JumpIf(CountInv("MO_ShotShell") == 1, "ReloadLastShell");
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
            SGR1 LMNO 1;// JM_WeaponReady(WRF_NOFIRE);
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			SGR1 PQRS 1;// JM_WeaponReady(WRF_NOFIRE);
			SGR1 A 0 JM_ReloadGun("SSGAmmo", invoker.AmmoType2, invoker.Ammo1.MaxAmount,1);
			SGR1 A 0 MO_ResetShotCount();
            SGR1 T 1 
			{
				A_StartSound("weapons/ssg/fullinsert", 0);
				JM_WeaponReady(WRF_NOFIRE);
			}
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
            SGR1 UVWX 1 JM_WeaponReady(WRF_NOFIRE);
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,3);
			SGR1 YZZZZ 1 JM_WeaponReady(WRF_NOFIRE);
        DoneReloadingThisShit:
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
            SGR2 ABC 1 JM_WeaponReady(WRF_NOFIRE);
            SGR2 D 1 A_StartSound("weapons/ssg/closegun", 1);
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
            SGR2 EFGH 1 JM_WeaponReady(WRF_NOFIRE);
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			SGR2 IJKLMN 1 JM_WeaponReady(WRF_NOFIRE);
            Goto REadyToFire;
        HalfReload:
            SGR7 A 1
            {
                A_Overlay(2, "ReloadSmokeRight",false);
				MO_EjectCase("FlakShotgunCasing", 19, 3, 11, random(-4, -2), random(-5,-4), random(5,6));
                A_StartSound("weapons/ssg/opengas", 7);
				JM_WeaponReady(WRF_NOFIRE);
            }
            SGR7 BCDE 1 JM_WeaponReady(WRF_NOFIRE);
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
            SGR7 EEF 1 JM_WeaponReady(WRF_NOFIRE);
		ReloadLastShell:
			TNT1 A 0;
			SGR8 A 0 A_JumpIf(CountInv("MO_ShotShell") == 1,2);
			SGR7 A 0;
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
            "####" GHIJK 1 JM_WeaponReady(WRF_NOFIRE);
			"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			"####" KLMN 1 JM_WeaponReady(WRF_NOFIRE);
			"####" A 0 JM_ReloadGun("SSGAmmo", invoker.AmmoType2, invoker.Ammo1.MaxAmount,1);
			"####" A 0 MO_ResetShotCount();
            "####" T 0 A_StartSound("weapons/ssg/singleinsert", 0);
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
            SGR7 OO 1 JM_WeaponReady(WRF_NOFIRE);
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
			SGR7 PP 1 JM_WeaponReady(WRF_NOFIRE);
			SGR7 QR 1 JM_WeaponReady(WRF_NOFIRE);
			TNT1 A 0 A_JumpIfInventory("MO_PowerSpeed",1,3);
            TNT1 AAAAA 1 JM_WeaponReady(WRF_NOFIRE);
            Goto DoneReloadingThisShit;
        Spawn:
            SGN2 A -1;
            Stop;
        
		ReloadAnimation:
			  TNT1 A 0 A_JumpIfInventory("MO_ShotShell",1,1);
			  Goto JustSelectTheSSG;
			  SGR1 F 1 A_WeaponOffset(-33, 65);
			  SGR1 F 1 A_WeaponOffset(-22, 54);
			  SGR1 F 1 A_WeaponOffset(-11, 43);
			  SGR1 F 0 A_WeaponOffset(0,32);
			  SGR1 F 0 A_StartSound("weapons/ssg/opengun", 6);
			  Goto ContinueReload;
			  
        //Thank you Emerald!
        ReloadSmokeRight:
        SSGS AB 1 BRIGHT;//A_fireprojectile("SmokeSpawner",0,0,-5,-1);
        SSGS CDEF 1 BRIGHT;
        stop;
        ReloadSmokeLeft:
        SSGS GH 1 BRIGHT;// A_fireprojectile("SmokeSpawner",0,0,-8,-2);
        SSGS IJKL 1 BRIGHT;
        stop;

        LeftShellOut:
            SSGH ABCD 1;
            stop;
        RightShellOut:
            SSGH EFGH 1;
            stop;
			
		FlashKick:
			SG2K ABCDEFG 1;// JM_WeaponReady();
			SG2K GGFFEDCBA 1;// JM_WeaponReady();
			Goto ReadyToFire;
		
		FlashAirKick:
			SG2K ABCDEFG 1;// JM_WeaponReady();
			SG2K G 5;
			SG2K GGFEDCBA 1;// JM_WeaponReady();
			Goto ReadyToFire;
    }

    //This is so that the shell loading of the inventory give and take is in one function.
	//Original made for the Lever and Pump shotguns but modified for the SSG
	action void JM_ReloadSSG(int magMax, int reserveTake)
	{
		for(int i = 0; i < magMax; i++)
		{
			if(invoker.Ammo1.amount < 1 || invoker.Ammo2.amount == invoker.Ammo2.MaxAmount) 
			return;
			
			A_GiveInventory(Invoker.AmmoType2, 1);
			A_TakeInventory(Invoker.AmmoType1, reserveTake, TIF_NOTAKEINFINITE);
		}
	}
}

class SSGAmmo : Ammo
{
	Default
	{
		Inventory.Amount 0;
		Inventory.MaxAmount 2;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount 2;
		Inventory.Icon "SGN2A0";
		+INVENTORY.IGNORESKILL;
	}
}

//Iamcarrotmaster told me that these will have improved sprites, thanks carrot!
Class FlakChunk1 : Actor
{
	int projAge;
    Default
    {
	Radius 3;
	Height 4;
	Obituary "$OB_SUPERSHOTGUN_FLAK";
	Speed 55;
	DamageFunction (random(15, 21));
	Mass 200;
	Scale 0.4;
	Gravity 0.9;
	Damagetype 'Cutless';
	+MISSILE;
	+BLOODSPLATTER;
	+ROLLSPRITE;
    BounceType "Doom";
	+NOTELEPORT;
	BounceFactor 0.65;
//	SeeSound "weapons/smcasebounce";
	BounceSound "weapons/smcasebounce";
//	MissileType "FlakTrail";
    }

	override void Tick()
	{
		Super.Tick();
		projAge++;
		
		if(projAge >= 140)
			SetStateLabel("Death");
	}

	States
	{
		Spawn:
			FLAS A 1 Bright {
				A_SpawnProjectile("SmallYellowFlare", 0, 0, 0, 0);
	//			A_SpawnItemEx("FlakTrail",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
				A_SetRoll(Roll+45);
			}
			loop;
		Death:
			EXPL AAA 0 A_SpawnProjectile ("MO_GunSmoke", 4, 0, random (0, 360), CMF_AIMOFFSET|CMF_BADPITCH, random (0, 360));
			Stop;
	}
}

Class FlakChunk2 : FlakChunk1
{
    Default
    {Damagetype 'Saw';}
	States
	{
		Spawn:
			FLAS B 1 Bright {
				A_SpawnProjectile("SmallYellowFlare", 0, 0, 0, 0);
//				A_SpawnItemEx("FlakTrail",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
				A_SetRoll(Roll+45);
			}
			loop;
	}
}

Class FlakChunk3 : FlakChunk1
{   
    Default
	{Damagetype 'Blast';}
    States
    {
		Spawn:
			FLAS C 1 Bright {
				A_SpawnProjectile("SmallYellowFlare", 0, 0, 0, 0);
//				A_SpawnItemEx("FlakTrail",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
				A_SetRoll(Roll+45);
			}
			loop;
    }
}

Class FlakChunk4 : FlakChunk1
{
	Default{Damagetype 'Shotgun';}
    States
    {
		Spawn:
			FLAS D 1 Bright {
				A_SpawnProjectile("SmallYellowFlare", 0, 0, 0, 0);
//				A_SpawnItemEx("FlakTrail",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
				A_SetRoll(Roll+45);
			}
			loop;
    }
}