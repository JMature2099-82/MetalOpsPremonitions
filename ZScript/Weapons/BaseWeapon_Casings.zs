//A_Eject from Beautiful Doom by Jekyll Grim Payne
extend class MO_Weapon
{
	//Casing spawn function with math by Marisa Kirisame (see mk_matrix)
	action actor MO_EjectCase(class<Actor> itemtype, double xofs = 0, double yofs = 0, double zofs = 0, double xvel = 0, double yvel = 0, double zvel = 0) {
		if (!player || !player.mo)
			return null;
		PlayerInfo plr = player;
		PlayerPawn pmo = player.mo;
		Vector3 ofs = pmo.pos+(0,0,plr.viewheight-GetFloorTerrain().footclip);
		Vector3 x, y, z;
		[x, y, z] = Matrix4.getaxes(pmo.pitch,pmo.angle,pmo.roll);
		let targofs = ofs+x*xofs+y*yofs-z*zofs;
		if (!Level.IsPointInLevel(targofs))
			return null;
		let c = Spawn(itemtype,targofs);
		if (c) {
			c.vel = x*xvel+y*yvel+z*zvel;
			c.target = self;
			c.angle = angle;
			return c;
		}
		return null;
	}
	  /*
    Ejects a bullet casing to the side.
    Params:
     - casingType: Type of actor to eject.
     - left: If true, casing ejects to the left. Otherwise it ejects to the right.
     - ejectPitch: Pitch at which casing ejects, relative to view direction.
     - speed: Speed at which casing ejects.
     - accuracy: Random spread, in degrees.
     - offset: Offset from which casing is ejected, relative to center of view.
    */
//From ZScript Weapons Library.
    action void MO_EjectCasing(class<Actor> casingType, bool left = false, double ejectPitch = -45, double speed = 4,
                                double accuracy = 8, Vector3 offset = (24, 0, -10))
    {
        // Find offset vector
        // +y axis is to the right for offsets
        offset.y *= -1;

        // Rotate offset by pitch
        Vector2 xz = RotateVector((offset.x, offset.z), -pitch);
        offset.x = xz.x;
        offset.z = xz.y;

        // Rotate vector by angle
        offset.xy = RotateVector(offset.xy, angle);

        // Move to player camera
        offset.xy += pos.xy;
        offset.z += player.viewZ;

        // Find velocity vector
        Vector3 side = (Cos(angle + (left ? 90 : -90)), Sin(angle + (left ? 90 : -90)), 0);
        Vector3 up = (Cos(pitch-90) * Cos(angle), Cos(pitch-90) * Sin(angle), -Sin(pitch-90));
        Vector3 baseDirection = Cos(-ejectPitch) * side + Sin(-ejectPitch) * up;

        double baseAngle = VectorAngle(baseDirection.x, baseDirection.y);
        baseDirection.xy = RotateVector(baseDirection.xy, -baseAngle);
        double basePitch = -VectorAngle(baseDirection.x, baseDirection.z);

        double casAngle, casPitch;
        [casAngle, casPitch] = invoker.BulletAngle(accuracy, baseAngle, basePitch);

        let casing = Spawn(casingType, offset);
        casing.Vel3dFromAngle(speed, casAngle, casPitch);
        casing.vel += vel;
    }

	// Returns random angle and pitch within cone
    // I have no idea if there's a better way of doing this ¯\_(ツ)_/¯
    // Params:
    //  - accuracy: maximum angle b/w cone's axis, and bullet trajectory
    //  - angle: angle of axis
    //  - pitch: pitch of axis
    double, double BulletAngle(double accuracy, double angle, double pitch)
    {
        Vector3 v = (0, 0, 0);

        if (accuracy > 10)
        {
            // Generate random vector in sphere section
            Vector3 axis = (Cos(pitch) * Cos(angle), Cos(pitch) * Sin(angle), -Sin(pitch));
            while (v == (0, 0, 0) || v.Length() > 1 || ACos(axis dot v.Unit()) > accuracy)
            {
                v = (FRandom(-1, 1), FRandom(-1, 1), FRandom(-1, 1));
            }

            // Extract angle and pitch from trajectory
            angle = VectorAngle(v.x, v.y);
            pitch = -ASin(v.z / v.Length());
        }
        else if (accuracy > 0)
        {
            // Generate random vector in sphere around end of axis
            double r = Sin(accuracy);
            while (v == (0, 0, 0) || v.Length() > r)
            {
                v = (FRandom(-r, r), FRandom(-r, r), FRandom(-r, r));
            }

            Vector3 axis = (Cos(pitch) * Cos(angle), Cos(pitch) * Sin(angle), -Sin(pitch));
            v += axis;

            // Extract angle and pitch from trajectory
            angle = VectorAngle(v.x, v.y);
            pitch = -ASin(v.z / v.Length());
        }

        return angle, pitch;
    }
}