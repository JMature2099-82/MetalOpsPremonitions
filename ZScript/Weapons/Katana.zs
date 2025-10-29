/////////////////
//   Katana    //
////////////////

class KatanaBeamMode : MO_ZSToken{}

class LeftKatanaAttack : MO_ZSToken{} //For the JM_KatanaAttack function

class Katana: MO_Weapon replaces Fist
{
	  Default 
	  {	
	  Obituary "";
	  Tag "$TAG_KATA";	
	  +WEAPON.WIMPY_WEAPON;
	  +WEAPON.NOALERT;
	  +WEAPON.NO_AUTO_SWITCH
	  +INVENTORY.UNDROPPABLE
	  +WEAPON.NOAUTOSWITCHTO
	  Inventory.AltHudIcon "KATAN0";
	  Weapon.SelectionOrder 3700;
	  }

	 override string GetObituary (Actor victim, Actor inflictor, Name mod, bool playerattack)
	{
		static const string messages[] =
		{
			"$OB_KATANA",
			"$OB_KATANA2"
		};

		return messages[Random(0, messages.Size() - 1)];
	}
	
	  action void JM_KatanaAttack()
	  {
			int dmg = 25; 
			Class<Actor> puff;
			bool leftSwing = FindInventory("LeftKatanaAttack");
			
			if(invoker.OwnerHasBerserk()) {
				if(health < 30) 
				dmg = dmg * 4;
				else dmg = dmg * 2;
				}
			
			if(leftSwing) {puff = "KatanaPuff2";}
			else {puff = "KatanaPuff";}
			A_CustomPunch(dmg * random(1,3), TRUE, CPF_NOTURN, puff, 96, 0, 0, "none", "weapons/katana/hit");
	  }

	 action void JM_KatanaAltFire()
	 {
			int dmg = 75; 
			if(invoker.OwnerHasBerserk()) {
				if(health < 30) 
				dmg = dmg * 4;
				else dmg = dmg * 2;
				}
			A_CustomPunch(dmg * random(1,3), TRUE, CPF_NOTURN, "KatanaPuff", 96, 0, 0, "none", "weapons/katana/hit");
	}

	  States
	  {

	  Ready:
	  ReadyToFire:
		KTAG A 1 JM_WeaponReady();
		Loop;

	  Deselect:
		TNT1 A 0 A_SetCrosshair(99);
		TNT1 A 0 A_JumpIfHealthLower(0, "DeadDeselect");
		KTAG BCDEFG 1;
		KTAG HIJ 1;
		TNT1 A 0 A_STARTSOUND("weapons/katana/sheathe", CHAN_AUTO, CHANF_DEFAULT,0.7);
		KTAG KKLMNOP 1;
		TNT1 A 5;
		KTAG A 0 A_Lower(12);
		WAIT;

	  Select:
		  TNT1 A 0;
		  TNT1 A 0 A_SetCrosshair(99);
	ContinueSelect:
		  TNT1 A 0 MO_Raise(); 
	 SelectAnimation:
		TNT1 A 2;
		TNT1 A 0 A_StartSound("weapons/katana/draw",CHAN_AUTO);
		KTAG PONMLKJI 1;
		KTAG GFECB 1;
		Goto Ready;
	
	DeadDeselect:
		KTAK ABCDEF 1;
		TNT1 A 1;
		KTAG A 0 A_Lower(12);
		WAIT;


	  Fire:
		KTAF ABCD 1;
	  Swing1:
		TNT1 A 0 A_STARTSOUND("weapons/katana/swing", 7,CHANF_DEFAULT, 0.45);
		TNT1 A 0
		{
			A_SetInventory("LeftKatanaAttack",0);
			if(health <= 30 || CountInv("MO_PowerSpeed") == 1)
			return ResolveState(1);
			return resolveState(null);
		}
		KTAF EF 1;
		TNT1 A 0
		{
			if(health <= 30 || CountInv("MO_PowerSpeed") == 1)
			return ResolveState(2);
			return resolveState(null);
		}
		KTAF G 1;
		KTAF H 1 {
			 JM_CheckForQuadDamage();
			 JM_KatanaAttack();
		}
		KTAF IJ 1;
		TNT1 A 0
		{
			if(health <= 30 || CountInv("MO_PowerSpeed") == 1)
			return ResolveState(2);
			return resolveState(null);
		}
		TNT1 AAA 1;
		TNT1 A 0 A_JumpIf(PressingFire(), "Swing2");
		Goto ReturnToAction;
	Swing2:
		TNT1 A 0 A_STARTSOUND("weapons/katana/swing", 6);
		TNT1 A 0 A_SetInventory("LeftKatanaAttack",1);
		KTAF LM 1;
		TNT1 A 0
		{
			if(health <= 30 || CountInv("MO_PowerSpeed") == 1)
			return ResolveState(2);
			return resolveState(null);
		}
		KTAF NO 1;
		KTAF Q 1 {
			 JM_CheckForQuadDamage();
			 JM_KatanaAttack();
		}
		TNT1 A 0
		{
			if(health <= 30 || CountInv("MO_PowerSpeed") == 1)
			return ResolveState(2);
			return resolveState(null);
		}
		KTAF R 1;
		KTAF S 1;
		TNT1 A 0
		{
			if(health <= 30 || CountInv("MO_PowerSpeed") == 1)
			return ResolveState(2);
			return resolveState(null);
		}
		TNT1 AAA 1;
		TNT1 A 0 A_JumpIf(PressingFire(), "Swing1");
		Goto ReturnToAction;
	AltFire:
		KTAF AB 1;
		TNT1 A 0
		{
			if(health <= 30 || CountInv("MO_PowerSpeed") == 1)
			return ResolveState(2);
			return resolveState(null);
		}
		KTAF C 1;
		TNT1 A 0
		{
			if(health <= 30 || CountInv("MO_PowerSpeed") == 1)
			return ResolveState(1);
			return resolveState(null);
		}
		KTAH ABC 1;
	AltHold:
		KTAH C 1;
		TNT1 A 0 A_JumpIf(PressingAltFire(), "AltHold");
		TNT1 A 0
		{
			if(health <= 30 || CountInv("MO_PowerSpeed") == 1)
			return ResolveState(2);
			return resolveState(null);
		}
		KTAH DE 1;
		KTAH F 1 A_STARTSOUND("weapons/katana/swing", 6);
		KTAH G 1;
		KTAF H 1 {
			JM_CheckForQuadDamage();
			JM_KatanaAltFire();
		}
		TNT1 A 0
		{
			if(health <= 30 || CountInv("MO_PowerSpeed") == 1)
			return ResolveState(2);
			return resolveState(null);
		}
		KTAF I 1;
		KTAF J 1;
		TNT1 A 0
		{
			if(health <= 30 || CountInv("MO_PowerSpeed") == 1)
			return ResolveState(2);
			return resolveState(null);
		}
		TNT1 AAA 1;	
	ReturnToAction:
		KTAK FE 1;
		TNT1 A 0
		{
			A_SetInventory("LeftKatanaAttack",0);
			if(health <= 30 || CountInv("MO_PowerSpeed") == 1)
			return ResolveState(2);
			return resolveState(null);
		}
		KTAK DCBA 1;
		Goto ReadyToFire;
	 FlashKick:
		KTAK ABCDEF 1;
		KTAK F 4;
		KTAK EEDCBA 1;
		Goto ReadyToFire;
	FlashAirKick:
		KTAK ABCDEF 1;
		KTAK F 6;
		KTAK EEDCBA 1;
		Goto ReadyToFire;
   }
}