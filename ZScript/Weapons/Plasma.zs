class JM_PlasmaRifle : JMWeapon Replaces PlasmaRifle
{
	const PSP_MUZZLEFLASH = -60;
	action void JM_AddHeatBlastCharge()
	{
		int h = CountInv("HeatBlastShotCount");
		switch(h)
		{
			case 15:
				A_GiveInventory("HeatBlastLevel",1);
				A_StartSound("plasma/heatlevel1",10, CHANF_DEFAULT, 1.6);
				break;
			case 30:
				A_GiveInventory("HeatBlastLevel",1);
				A_StartSound("plasma/heatlevel2",10, CHANF_DEFAULT, 1.6);
				break;
			case 45:
				if(CountInv("HeatBlastFullyCharged") < 1)
				{
					A_GiveInventory("HeatBlastLevel",1);
					A_GiveInventory("HeatBlastFullyCharged",1);
					A_StartSound("plasma/heatlevel3",10, CHANF_DEFAULT, 1.6);
				}
				break;
			}
	}

	action void MO_AttachPlasmaLight(string plight, string hlight)
	{
		if(CountInv("HeatedRoundsReady") >= 1)
			A_AttachLightDef('GunLighting', hlight);
		else
			A_AttachLightDef('GunLighting', plight);
	}
	//MO_DummyPuff
//From PB.
//Rails / Beams things
//all this is done this way cause ideally, every weapon should have its own specific functions, though a generic version of this could be made for addons use or simple "laser" like things
	
	//////////////////////////////////////////////////////////
	//Plasma Rifle Beam
	//////////////////////////////////////////////////////////
	
	//plasma alt fire
	const bfgpartstep = 15;
	action void MO_FirePlasmaBeam()
	{
		//the first option is a lineattack cuz linetrace acts weird in some tipes of geometry (try one with the kinsie test map, in the elevator or the pool)
		//Actor p = LineAttack(angle,8000,pitch,20,'Disintegrate',"BFGBeamPuff",LAF_NOIMPACTDECAL|LAF_NORANDOMPUFFZ);
		//nvm just needed to substract hitdir to hitlocation, so it doesnt spawn in the wall
		vector3 destpos;
		FLineTraceData t;
		bool hit = linetrace(angle,8000,pitch,0,height * 0.5 - floorclip + player.mo.AttackZOffset*player.crouchFactor,data:t);
		
		destpos = t.hitlocation;
		destpos -= (t.hitdir * 2);
		
		vector3 dif = levellocals.vec3diff((pos.XY,pos.z + height * 0.5),destpos);
		vector3 dir = dif.unit();
		double dis = dif.length();
		
		int q = int(dis / bfgpartstep) + 1; //bfgpartstep is an arbitrary value representing the distance between particles, basically get the divide the total distance / steps between particles to get the number of particles
			
		vector3 actpos = (pos.XY,pos.z + height * 0.5);
		for(int i = 1; i <= q; i++)
		{
			actpos += (dir * bfgpartstep);
			MO_DrawBeamrailparticle(actpos);
		}
		
		//damage victim (if any)
		if(t.hitactor)
		{
			actor v = t.hitactor;
			int dmg = 6 * random(1,4); //so this is why it feels weaker, the original projectile deals 20 * random(1,8) damage, and damagemobj doesnt add randomization, so a little randomization may help here
			if(v && v.health > 0 && !isfriend(v))
				v.damagemobj(self,self,dmg,'Plasma');
		}
		
		//spawn puff if hit anything
		if(hit)
		{
			actor p = Spawn("PlasmaBeamPuff",destpos);
			if(p)
				p.target = self;
			
		}
	}

	action void MO_DrawBeamrailparticle(vector3 where)
	{
		FSpawnParticleParams beamrail;
//		int fm = random(1,5);
		beamrail.Texture = TexMan.CheckForTexture ("PAR2A0");
		beamrail.Color1 = "FFFFFF";
		beamrail.Style = STYLE_Add;
		beamrail.Flags = SPF_ROLL|SPF_FULLBRIGHT|SPF_NOTIMEFREEZE;
		beamrail.Vel = (random(-1,1),random(-1,1),random(-1,1)); 
		beamrail.Startroll = random(0,360);
		beamrail.RollVel = 0;
		beamrail.StartAlpha = 1.0;
		beamrail.FadeStep = -0.05;
		beamrail.Size = random(32,42);
		beamrail.SizeStep = -12;
		beamrail.Lifetime = random (2,3); 
		beamrail.Pos = where;
		Level.SpawnParticle(beamrail);
	}

	Default
	{
		Weapon.AmmoUse 0;
		Weapon.AmmoGive 20;
		Weapon.AmmoType1 "MO_Cell";
		Weapon.AmmoType2 "PlasmaAmmo";
		Inventory.PickupMessage "$GOTPLASMAGUN";
		Inventory.PickupSound "weapons/plasma/pickup";
		Obituary "$OB_PLASMABEAM";
		Tag "$TAG_PLASMA";
		+WEAPON.NOALERT;
		Weapon.SelectionOrder 100;
	}
	
	action void MO_SetPRCrosshair()
	{
		{
				if(FindInventory("HeatedRoundsReady"))
				{
					A_SetCrossHair(invoker.GetXHair(19));
				}
				else 
				{A_SetCrossHair(invoker.GetXHair(12));}
		}
	}

	States
	{
	ReadyToFire:
		2RGG A 0; //Initialize the sprite name into memory
		PRGG A 0 
		{
			if(CountInv("HeatedRoundsReady") == 1)
			{JM_SetWeaponSprite("2RGG");}
		}
	ReadyLoop:
		"####" A 1 JM_WeaponReady(WRF_ALLOWRELOAD);
		Loop;
	Deselect:
		PSTG A 0 MO_SetPRCrosshair;
		PRGS DCBA 1
		{
			if(CheckInventory("HeatedRoundsReady",1))
			{
				JM_SetWeaponSprite("1RGS");
			}
		} 
		PRGS A 0 A_Lower(12);
		Wait;
	Select:
		PRGG A 0;
		TNT1 A 0 MO_SetPRCrosshair;
		Goto ClearAudioAndResetOverlays;
		
	ContinueSelect:
		PRGG A 0 A_SetInventory("PlasmaRifleCooldownCount",0);
		TNT1 AAAAAAAAAAAAAAAAAA 0 A_Raise();
		Goto Ready;
		
	Ready:
		1RL1 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0; //Initialize the sprite name into memory
		1RL2 ABCDEFGHIJKLMNOPQRSTUVWXYZ 0; //Initialize the sprite name into memory
		1RL3 A 0; //Initialize the sprite name into memory
		1RGS ABCD 0;
	SelectAnimation:
		TNT1 A 0 A_StartSound("weapons/plasma/equip",1);
		PRGS ABCD 1
		{
			if(CheckInventory("HeatedRoundsReady",1))
			{
				JM_SetWeaponSprite("1RGS");
			}
		}
		Goto ReadyToFire;
		
	Fire:
		TNT1 A 0 MO_CheckMag;
		TNT1 A 0 JM_CheckForQuadDamage();
	FireContinue:
		TNT1 A 0 MO_CheckMag;
		3RGF A 0; //Initialize the sprite name into memory
		PRGF A 0
		{
			if(CheckInventory("HeatedRoundsReady",1))
			{
				JM_SetWeaponSprite("3RGF");
			}
		}
		"####" A 1 
		{
			if(CountInv("HeatedRoundsReady") == 1)
			{
				A_StartSound("weapons/plasma/superheatfire", CHAN_AUTO,CHANF_DEFAULT,0.6,ATTN_NORM);
				A_FireProjectile("JM_HeatedPlasmaBall", 0, FALSE);
				A_Overlay(PSP_MUZZLEFLASH, "MuzzleFlashHeated");
				JM_AddHeatBlastCharge();
				A_GiveInventory("HeatBlastShotCount",1);
			}
			Else
			{
				A_StartSound("weapons/plasma/fire", CHAN_AUTO,CHANF_DEFAULT,1,ATTN_NORM,1.2);
				A_FireProjectile("JM_PlasmaBall", 0, FALSE);
				A_Overlay(PSP_MUZZLEFLASH, "MuzzleFlash");
			}
			A_AlertMonsters();
			A_GunFlash();
			A_TakeInventory("PlasmaAmmo",1, TIF_NOTAKEINFINITE);
			A_GiveInventory("PlasmaRifleCooldownCount",1);		
		}
		"####" B 1 JM_GunRecoil(-1.1,+.03);
		"####" C 1;
		"####" A 0 A_JumpIf(PressingFire(), "FireContinue");
		"####" A 0 A_JumpIfInventory("PlasmaRifleCooldownCount",25,"Cooldown");
		"####" A 0 A_SetInventory("PlasmaRifleCooldownCount",0);
		"####" A 0 MO_CheckMag;
		Goto ReadyToFire;

	Flash:
			TNT1 A 2 MO_AttachPlasmaLight('PlasmaWepLight', 'HeatedPlasmaWepLight');
			TNT1 A 0 A_RemoveLight('GunLighting');
			Stop;

	Spawn:
		PLAS A -1;
		Stop;
	
	Cooldown:
		2RGN ABCDEFGHIJKLMNOPQ 0; //Initialize the sprite name into memory
		PRGN A 0
		{
			if(CheckInventory("HeatedRoundsReady",1))
			{
				JM_SetWeaponSprite("2RGN");
			}
		}
		"####" A 0 A_SetInventory("PlasmaRifleCooldownCount",0);
		"####" A 0 {
			A_StartSound("weapons/plasma/overheat",1);
			A_StartSound("weapons/plasma/cooldown",6);
			}
		"####" ABCDEFG 1;
		"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
		"####" HH 1 
		{
			A_WeaponOffset(random(-1,1), random(31,33));
			A_SpawnItemEx("PlasmaCoolSmoke1",23, -13, 38, random(0,1), 0, 0);
		}
		"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
		"####" HH 1 A_WeaponOffset(random(-2,2), random(31,33));
		"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
		"####" HH 1 {
			A_WeaponOffset(random(-1,1), random(31,33));
			A_SpawnItemEx("PlasmaCoolSmoke1",23, -13, 38, random(0,1), 0, 0);
		}
		"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
		"####" HH 1 A_WeaponOffset(random(-2,2), random(31,33));
		"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
		"####" II 1 {
			A_WeaponOffset(random(-1,1), random(31,33));
			A_SpawnItemEx("PlasmaCoolSmoke2",23, -15, 38, random(0,1), 0, 0);
		}
		"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
		"####" II 1 A_WeaponOffset(random(-2,2), random(31,33));
		"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
		"####" II 1 {
			A_WeaponOffset(random(-1,1), random(31,33));
			A_SpawnItemEx("PlasmaCoolSmoke2",23, -15, 38, random(0,1), 0, 0);
		}
		"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
		"####" II 1 A_WeaponOffset(random(-2,2), random(31,33));
		"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
		"####" JJ 1 {
			A_WeaponOffset(random(-1,1), random(31,33));
			A_SpawnItemEx("PlasmaCoolSmoke3",23, -17, 38, random(0,1), 0, 0);
		}
		"####" JJ 1 A_WeaponOffset(random(-2,2), random(31,33));
		"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
		"####" JJ 1 {
			A_WeaponOffset(random(-1,1), random(31,33));
			A_SpawnItemEx("PlasmaCoolSmoke3",23, -17, 38, random(0,1), 0, 0);
		}
		"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
		"####" JJ 1 A_WeaponOffset(random(-2,2), random(31,33));
		"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
		"####" KK 1 A_WeaponOffset(random(-1,1), random(31,33));
		"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
		"####" KK 1 A_WeaponOffset(random(-2,2), random(31,33));
		"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
		"####" KK 1 A_WeaponOffset(random(-1,1), random(31,33));
		"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
		"####" KK 1 A_WeaponOffset(random(-2,2), random(31,33));
		"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,3);
		"####" K 1 A_WeaponOffset(0,32);
		"####" LMNOPQ 1 A_WeaponOffset(0,32);
		"####" A 0 A_SetInventory("PlasmaRifleCooldownCount",0);
		"####" A 0 A_JumpIfInventory("PlasmaAmmo",1,"ReadyToFire");
		Goto Reload;
	
	AltFire:
		TNT1 A 0;
		TNT1 A 0 MO_CheckMag;
		TNT1 A 0 {
			if(CountInv("HeatedRoundsReady") >=1 && CountInv("HeatBlastLevel") >= 1)
			{
				JM_CheckForQuadDamage();
				return ResolveState("HeatBlast");
			}
			if(CountInv("HeatedRoundsREady") < 1)
			{
				return ResolveState("FireBeam");
			}
			return ResolveState(Null);
		}
		Goto ReadyToFire;

	FireBeam:
		PRGF A 0;
		PRGG A 0 A_StartSound("plasma/laser/fire",1, CHANF_LOOP);
		PRGG A 3 A_WeaponOffset(0,34);
		PRGA A 3;
		TNT1 A 0 A_JumpIf(JustReleased(BT_ALTATTACK), "CheckForCooldown");
	HoldBeam:
		TNT1 A 0 MO_CheckMag(where: "StopBeam");
		PRGG A 0 A_StartSound("plasma/laser/fireloop",4);
		PRGG A 0 A_Overlay(PSP_MUZZLEFLASH, "MuzzleFlash");
		PRGG A 0 A_AttachLightDef('GunLighting', 'PlasmaWepLight');
		PRGA BB 1 
		{
			JM_CheckForQuadDamage();
			A_WeaponOffset(random(-1,1), random(32, 34));
			MO_FirePlasmaBeam();
			A_OverlayOffset(PSP_MUZZLEFLASH, 0, 18);
			A_AlertMonsters();
		}
		PRGG A 0 JM_GunRecoil(-0.9, .09);
		PRGG A 0 A_Overlay(PSP_MUZZLEFLASH, "MuzzleFlash");
		PRGA CC 1
		{
			JM_CheckForQuadDamage();
			A_WeaponOffset(random(-1,1), random(32, 34));
			MO_FirePlasmaBeam();
			A_OverlayOffset(PSP_MUZZLEFLASH, 0, 18);
			A_AlertMonsters();
			A_TakeInventory("PlasmaAmmo",1);
		}
		TNT1 A 0 A_JumpIf(PressingAltFire(), "HoldBeam");
		StopBeam:
		TNT1 A 0 A_RemoveLight('GunLighting');
		TNT1 A 0 A_StopSound(4);
		TNT1 A 0 A_StartSound("plasma/laser/loopstop",1);		
		PRGA B 1;
		PRGA A 1 A_WeaponOffset(0,32);
		PRGG A 1;
		Goto Cooldown;
	
	DoNothing:
		TNT1 A 0;
		Goto ReadyToFire;
		
	
	ActionSpecial:
		TNT1 A 0;
		1RGW A 0; //Initialize the sprite name into memory
		PRGW A 0
		{
			if(CheckInventory("HeatedRoundsReady",1))
			{
				JM_SetWeaponSprite("1RGW");
			}
		}
//		TNT1 A 0 A_JumpIfInventory("HeatedPlasmaMode", "SwitchToNormal")
		"####" ABCDEF 1;
		"####" G 1 A_StartSound("plasma/beep",0);
		"####" H 1 A_StartSound("plasma/special1",9);
		"####" IJKLMN 1;
		"####" A 0
		{
			if(CheckInventory("HeatedRoundsReady",1))
			{
				A_Print("Plasma rounds selected");
				A_SetInventory("HeatedRoundsReady",0);
			}
			else
			{
				A_Print("Heated Plasma rounds selected");
				A_SetInventory("HeatedRoundsReady",1);
			}
		}
		#### A 0 MO_SetPRCrosshair;
		Goto ReadyToFire;
			
	HeatBlast:
		2RGG A 0 A_JumpIfInventory("PlasmaAmmo",15,1);
		Goto ReadyToFire;
		3RGF A 1 
		{
			A_AlertMonsters();
			if(CountInv("HeatBlastFullyCharged") == 1)
			{A_FireProjectile("JM_SuperHeatBlastMissile", 0, FALSE, 0, 5, 0);}
			else
			{A_FireProjectile("JM_HeatBlastMissile", 0, FALSE, 0, 5, 0);}
			A_StartSound("weapons/plasma/heatblast", CHAN_AUTO,CHANF_DEFAULT,1,ATTN_NORM,1.2);
			A_TakeInventory("PlasmaAmmo",15);
			A_TakeInventory("HeatBlastLevel",3);
			A_TakeInventory("HeatBlastFullyCharged",1);
			A_TakeInventory("HeatBlastShotCount",45);
		}
		3RGF B 1 JM_GunRecoil(-2.15,+.03);
		2RGA A 1 JM_GunRecoil(-2.15,+.03);
		2RGA BCD 1 JM_GunRecoil(-1.75,+.03);
		2RGA EFF 1;
		2RGA EDCBA 1;
		Goto Cooldown;
	Reload:
		PSTG A 0 A_JumpIfInventory("PlasmaRifleCooldownCount",25,"Cooldown");
		PSTG A 0 A_JumpIfInventory("PlasmaAmmo",60,"ReadyToFire");
		PSTG A 0 A_JumpIfInventory("MO_Cell",1,1);
		goto ReadyToFire;
		PRL1 A 0
		{
			if(CheckInventory("HeatedRoundsReady",1))
			{
			JM_SetWeaponSprite("1RL1");
			}
		}
		"####" AB 1;
		"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
		"####" DE 1; 
		PRL3 A 0
		{
			if(CheckInventory("HeatedRoundsReady",1))
			{
			JM_SetWeaponSprite("1RL3");
			}
		}
		"####" AB 1 JM_WeaponReady(WRF_NOFIRE);
		"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,5);
		"####" CDE 1 JM_WeaponReady(WRF_NOFIRE);
		"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
		"####" F 1 JM_WeaponReady(WRF_NOFIRE);
		"####" G 1 JM_WeaponReady(WRF_NOFIRE);
		"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,3);
		"####" HH 1 JM_WeaponReady(WRF_NOFIRE);
		"####" AA 0;
		"####" A 0 A_StartSound("weapons/plasma/cellout",2);
		"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,2);
		"####" H 1;
		"####" IJKLM 1 JM_WeaponReady(WRF_NOFIRE);
		PRL3 N 1 JM_WeaponReady(WRF_NOFIRE);
		PRGN A 0 A_JumpIf(CountInv("PlasmaAmmo") >= 1, 2);
		PRGN A 0 {MO_EjectCasing("EmptyCell", speed: frandom(4,7), offset: (24, -7, -20));}
		PSTF A 0 A_JumpIfInventory("MO_PowerSpeed",1,4);
		PRL3 OOOO 1 JM_WeaponReady(WRF_NOFIRE);
		PSTF A 0 A_JumpIfInventory("MO_PowerSpeed",1,3);
		PRL1 GGGGGH 1 JM_WeaponReady(WRF_NOFIRE);
		PSTF A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
		PRL1 IJ 1 JM_WeaponReady(WRF_NOFIRE);
		PSTF A 0 A_StartSound("weapons/plasma/cellin", 0);
		PRL1 KLM 1;
		PRL1 N 1 JM_WeaponReady(WRF_NOFIRE);
		PRL1 O 1;
		PSTG A 0 JM_ReloadGun("PlasmaAmmo", "MO_Cell",60,1);
	DoneReload:
		PRL1 PQ 1 JM_WeaponReady(WRF_NOFIRE);
		PRL1 R 1 A_StartSound("weapons/plasma/poweredon", 4);
		PRL1 A 0
		{
			if(CheckInventory("HeatedRoundsReady",1))
			{
			JM_SetWeaponSprite("1RL1");
			}
		}
		"####" STUVWX 1 JM_WeaponReady(WRF_NOFIRE);
		"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,5);
		"####" YYYYYYYYZ 1 JM_WeaponReady(WRF_NOFIRE);
		"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,1);
		PRL2 ABCD 1
		{
			JM_WeaponReady(WRF_NOFIRE);
			if(CheckInventory("HeatedRoundsReady",1))
			{
			JM_SetWeaponSprite("1RL2");
			}
		}
		Goto ReadyToFire;
		
	FlashKick:
		"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,"FlashKickFast");
		PRL1 ABCDE 1
		{
			if(CheckInventory("HeatedRoundsReady",1))
			{
			JM_SetWeaponSprite("1RL1");
			}
		}
		PRL3 ABCCBA 1
		{
			if(CheckInventory("HeatedRoundsReady",1))
			{
			JM_SetWeaponSprite("1RL3");
			}
		}
		PRL1 EDCBA 1
		{
			if(CheckInventory("HeatedRoundsReady",1))
			{
			JM_SetWeaponSprite("1RL1");
			}
		}
		Goto ReadyToFire;
	FlashAirKick:
		"####" A 0 A_JumpIfInventory("MO_PowerSpeed",1,"FlashAirKickFast");
		PRL1 ABCDE 1
		{
			if(CheckInventory("HeatedRoundsReady",1))
			{
			JM_SetWeaponSprite("1RL1");
			}
		}
		PRL3 ABCCCCBA 1
		{
			if(CheckInventory("HeatedRoundsReady",1))
			{
			JM_SetWeaponSprite("1RL3");
			}
		}
		PRL1 EDCBA 1
		{
			if(CheckInventory("HeatedRoundsReady",1))
			{
			JM_SetWeaponSprite("1RL1");
			}
		}
		Goto ReadyToFire;
	
	FlashKickFast:
		PRL1 ABCDE 1
		{
			if(CheckInventory("HeatedRoundsReady",1))
			{
			JM_SetWeaponSprite("1RL1");
			}
		}
		PRL3 ABCBA 1
		{
			if(CheckInventory("HeatedRoundsReady",1))
			{
			JM_SetWeaponSprite("1RL3");
			}
		}
		PRL1 DCBA 1
		{
			if(CheckInventory("HeatedRoundsReady",1))
			{
			JM_SetWeaponSprite("1RL1");
			}
		}
		Goto ReadyToFire;
	
	FlashAirKickFast:
		PRL1 ABCDE 1
		{
			if(CheckInventory("HeatedRoundsReady",1))
			{
			JM_SetWeaponSprite("1RL1");
			}
		}
		PRL3 ABCCBA 1
		{
			if(CheckInventory("HeatedRoundsReady",1))
			{
			JM_SetWeaponSprite("1RL3");
			}
		}
		PRL1 EDCBA 1
		{
			if(CheckInventory("HeatedRoundsReady",1))
			{
			JM_SetWeaponSprite("1RL1");
			}
		}
		Goto ReadyToFire;
		
	MuzzleFlash:
		TNT1 A 0 A_Jump(255, "M1","M2","M3","M4", "M5", "M6");
	M1:
		PRMZ AB 1 BRIGHT;
		Stop;
	M2:
		PRMZ CD 1 BRIGHT;
		Stop;
	M3:
		PRMZ EB 1 BRIGHT;
		Stop;
	M4:
		PRMZ AD 1 BRIGHT;
		Stop;
	M5:
		PRMZ CB 1 BRIGHT;
		STOP;
	M6:
		PRMZ ED 1 BRIGHT;
		STOP;
	
	MuzzleFlashHeated:
		TNT1 A 0 A_Jump(255, "HM1","HM2","HM3","HM4", "HM5", "HM6");
	HM1:
		PRMZ FG 1 BRIGHT;
		Stop;
	HM2:
		PRMZ HI 1 BRIGHT;
		Stop;
	HM3:
		PRMZ JG 1 BRIGHT;
		Stop;
	HM4:
		PRMZ FI 1 BRIGHT;
		Stop;
	HM5:
		PRMZ HG 1 BRIGHT;
		STOP;
	HM6:
		PRMZ JI 1 BRIGHT;
		STOP;
	}
}

class PlasmaRifleCooldownCount : Inventory
{
	Default
	{
		Inventory.Amount 1;
		Inventory.MaxAmount 25;
	}
}

class PlasmaAmmo : Ammo
{
	Default
	{
		Inventory.Amount 0;
		Inventory.MaxAmount 60;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount 60;
		Inventory.Icon "PLASA0";
		+INVENTORY.IGNORESKILL;
	}
}

class JM_PlasmaBall : FastProjectile replaces PlasmaBall
{
	Default
	{
		Radius 13;
		Height 8;
		Speed 70;
		DamageFunction 30;
		Scale 0.4;
		Projectile;
		+RANDOMIZE
		+ZDOOMTRANS
		RenderStyle "Add";
		Alpha 0.85;
		SeeSound "None";
		DeathSound "weapons/plasma/ballexp";
		Obituary "$OB_PLASMA";
		DamageType "Plasma";
		+NOTELEPORT;
		Decal "Scorch";
	}
	States
	{
 	Spawn:
		PB01 ABCDE 1 Bright Light("PlasmaBallLight");
		Loop;
	Death:
	    NULL A 0;
		NULL A 0 A_Scream();
		NULL A 0; //A_SpawnDebris("PlasmaSpark")
		NULL A 0 A_SpawnItem("MO_PlasmaSmoke");
		TNT1 A 0; //bright A_SpawnItem("BoomBlue")
		TNT1 AAA 0 A_SpawnItemEx("BlueLightningMini", Random(-4, 4), Random(-4, 4), Random(-4, 4), 0, 0, 0, 0, 0, 64);
		TNT1 AA 0 A_SpawnItemEx("BlueLightningTiny", Random(-4, 4), Random(-4, 4), Random(-4, 4), 0, 0, 0, 0, 0, 128);
		TNT1 A 0 A_SpawnItemEx("BlueLightningSmall", Random(-4, 4), Random(-4, 4), Random(-4, 4), 0, 0, 0, 0, 0, 192);
		TNT1 A 0 A_SpawnItem("PlasmaExplosion");
		TNT1 AAAAAAAAA 0 A_SpawnProjectile("EnhancedPlasmaSpark1", 2, 0, frandom(0,1)*frandom (-180, 180),  flags:CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH, pitch: pitch - frandom(0,1)*frandom (30, 360));
		TNT1 AAAAA 0 A_SpawnProjectile("EnhancedPlasmaSpark2", 2, 0, frandom(0,1)*frandom (-180, 180), flags:CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH, pitch: pitch - frandom(0,1)*frandom (30, 360));
		TNT1 AA 0 A_SpawnProjectile("EnhancedPlasmaSpark3", 2, 0, frandom(0,1)*frandom (-180, 180), flags:CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH, pitch: pitch - frandom(0,1)*frandom (30, 360));
		Stop;
	}
}

class JM_HeatedPlasmaBall : JM_PlasmaBall
{
	Default
	{
		Obituary "$OB_HEATPLASMA";
		DeathSound "weapons/plasma/htballexp";
		DamageFunction(30);
	}
	States
	{
 	Spawn:
		PB02 ABCDE 1 Bright Light("HeatedPlasmaBallLight");
		Loop;
	Death:
		NULL A 0;
		NULL A 0; //A_SpawnDebris("PlasmaSpark")
		NULL A 0 A_Scream();
		NULL A 0 A_SpawnItem("MO_PlasmaSmoke");
		TNT1 A 0; //bright A_SpawnItem("BoomBlue")
		TNT1 AAA 0 A_SpawnItemEx("RedLightningMini", Random(-4, 4), Random(-4, 4), Random(-4, 4), 0, 0, 0, 0, 0, 64);
		TNT1 AA 0 A_SpawnItemEx("RedLightningTiny", Random(-4, 4), Random(-4, 4), Random(-4, 4), 0, 0, 0, 0, 0, 128);
		TNT1 A 0 A_SpawnItemEx("RedLightningSmall", Random(-4, 4), Random(-4, 4), Random(-4, 4), 0, 0, 0, 0, 0, 192);
		TNT1 AAAAAAAAA 0 A_SpawnProjectile("EnhancedHPlasmaSpark1", 2, 0, frandom(0,1)*frandom (-180, 180),  flags:CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH, pitch: pitch - frandom(0,1)*frandom (30, 360));
		TNT1 AAAAA 0 A_SpawnProjectile("EnhancedHPlasmaSpark2", 2, 0, frandom(0,1)*frandom (-180, 180), flags:CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH, pitch: pitch - frandom(0,1)*frandom (30, 360));
		TNT1 AA 0 A_SpawnProjectile("EnhancedHPlasmaSpark3", 2, 0, frandom(0,1)*frandom (-180, 180), flags:CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH, pitch: pitch - frandom(0,1)*frandom (30, 360));
		TNT1 A 0 A_SpawnItem("HeatedPlasmaExplosion");
		Stop;
	}
}

class PlasmaExplosion : BaseVisualSFX
{
	Default
	{
	  Radius 0;
	  Height 0;
	  RenderStyle "Add";
	  Scale 0.2;
	  Alpha 0.7;
	}
	States
	  {
	  Spawn:
		NULL A 0;
		NULL A 0; //A_SpawnItem("BlueExplosionFlare")
		PLXP ABCDEFGH 2 Bright A_FadeOut(0.05);
		stop;
	  }
}

class HeatedPlasmaExplosion : PlasmaExplosion
{
	States
	  {
	  Spawn:
		NULL A 0;
		NULL A 0; //A_SpawnItem("BlueExplosionFlare")
		PHXP ABCDEFGH 2 Bright A_FadeOut(0.05);
		stop;
	  }
}

class JM_HeatBlastSFX : Actor
{
		States
		{
		Spawn:
		TNT1 A 0;
		TNT1 A 0 A_SpawnItemEx("HeatBlastShockwave2Red",15,0,0,6,0,0);
		TNT1 A 0 A_SpawnItemEx("HeatBlastShockwaveRed",6,0,0,3,0,0);
		TNT1 A 0 
		{
				A_SpawnItemEx("RedLightningLarge");
				A_SpawnItemEx("RedLightningSmall");
				A_SpawnItemEx("RedLightningMedium");
		}
		TNT1 AAA 1;
		TNT1 A 0 
			{
				A_SpawnItemEx("RedLightningLarge");
				A_SpawnItemEx("RedLightningSmall");
				A_SpawnItemEx("RedLightningMedium");
			}
		Stop;
	}
}
class JM_HeatBlastMissile : FastProjectile
{
	Default
	{
		Speed 70;
		DamageFunction (175);
		DeathSound "NULLSND";
		Radius 13;
		Height 8;
		Scale 0.4;
		Projectile;
		+RANDOMIZE
		+ZDOOMTRANS
		RenderStyle "Add";
		Alpha 0.85;
		SeeSound "None";
		Obituary "%o was fried by %k's Heat Blast.";
		DamageType "Plasma";
		+NOTELEPORT;
		Decal "Scorch";
//		+ripper;
//		RipperCount 3;
	}
	States
	{
		Spawn:
		TNT1 A 0;
		TNT1 A 0 A_SpawnItemEx("HeatBlastWaveAttack");
		TNT1 A 1 A_SpawnItemEx("JM_HeatBlastSFX",flags:SXF_NOCHECKPOSITION);
		TNT1 A 0 A_Quake(2,4,0,4,0);
		TNT1 A 1 A_RadiusThrust(1000, 110, 0);
		TNT1 A 1 A_Explode(10,40,0);
		STOP;
	}
}

Class HeatBlastWaveAttack : Actor
{
	States
	{
		Spawn:
		TNT1 A 0;
		TNT1 A 1 A_Explode(45,110,0);
		TNT1 A 1 A_RadiusThrust(1000, 110, 0);
		TNT1 A 1 A_Explode(45,110,0);
		TNT1 A 1 A_RadiusThrust(1000, 110, 0);
		TNT1 A 1 A_Explode(45,110,0);
		TNT1 A 1 A_RadiusThrust(1000, 110, 0);
		Stop;
	}
}

class JM_SuperHeatBlastMissile : JM_HeatBlastMissile
{
	default{Damagefunction(300);}
	States
	{
		Spawn:
		TNT1 A 0;
		TNT1 A 0 A_SpawnItemEx("HeatBlastWaveAttack");
		TNT1 A 1 A_SpawnItemEx("JM_HeatBlastSFX",flags:SXF_NOCHECKPOSITION);
		TNT1 A 0 A_Quake(2,4,0,4,0);
		TNT1 A 1 A_RadiusThrust(1000, 110, 0);
		TNT1 A 1 A_Explode(10,40,0);
		TNT1 AAA 1;
		Stop;
	}
}

Class PlasmaBeamTrail : Actor
{
	Default
	{
	+FORCEXYBILLBOARD
	+THRUACTORS
	+NOGRAVITY
	+RANDOMIZE
	+Missile
	Renderstyle "add";
	Alpha 0.6;
	scale 0.3;
	}
	States
	{
	Spawn:
		PAR2 A 4 Bright;
		Stop;
	}
}

class HeatBlastShotCount : Inventory
{Default{Inventory.MaxAmount 45;}}
class HeatBlastLevel : Inventory
{Default{Inventory.MaxAmount 3;}}
class HeatBlastFullyCharged : MO_ZSToken{}
class HeatedRoundsReady : MO_ZSToken{}
class SuperHeatedShotCounter : Inventory
{Default{Inventory.MaxAmount 25;}}