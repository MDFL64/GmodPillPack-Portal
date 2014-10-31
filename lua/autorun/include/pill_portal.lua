AddCSLuaFile()

pk_pills.register("portal_turret",{
	parent="cturret",
	printName="Turret",
	side="wild",
	model="models/props/turret_01.mdl",
	attack={
		mode= "auto",
		func=function(ply,ent,tbl)
			ent.formTable.aim.attachment="LFT_Gun2_Muzzle"
			pk_pills.common.shoot(ply,ent,tbl)
			ent.formTable.aim.attachment="RT_Gun2_Muzzle"
			pk_pills.common.shoot(ply,ent,tbl)
		end,
		damage=2
	},
	aim={
		fixTracers=true
	},
	sounds={
		loop_alarm=false,
		auto_ping=false
	},
	canAim=function(ply,ent)
		if !ent.setup_laser then
			local effectdata = EffectData()
			effectdata:SetEntity(ent)
			effectdata:SetFlags(1)
			util.Effect("turret_lazer",effectdata,true,true)
			ent.setup_laser=true
		end
		return ent.active
	end
})

pk_pills.register("portal_cube",{
	printName="Storage Cube",
	type="phys",
	side="harmless",
	model="models/props/metal_box.mdl",
	default_rp_cost=1000,
	driveType="roll",
	driveOptions={
		power=6000,
		jump=30000,
		rotcap=1000
	}
})

pk_pills.register("portal_lovecube",{
	printName="Companion Cube",
	parent="portal_cube",
	default_rp_cost=10000,
	skin=1
})

pk_pills.register("portal_ball",{
	printName="Storage Ball",
	parent="portal_cube",
	model="models/props/sphere.mdl",
	driveOptions={
		power=2000,
		jump=60000,
		rotcap=false
	}
})

pk_pills.register("portal_rocketsentry",{
	printName="Rocket Sentry",
	side="wild",
	type="phys",
	model="models/props_bts/rocket_sentry.mdl",
	boxPhysics={Vector(-20,-20,-20),Vector(20,20,20)},
	userSpawn= {
		type="wall",
		ang=Angle(90,0,0)
	},
	seqInit="open",
	spawnFrozen=true,
	camera={
		offset=Vector(0,0,60),
		dist=80
	},
	aim={
		xPose="aim_yaw",
		yPose="aim_pitch",
		xInvert=true,
		xOffset=-90,
		xDef=180,
		attachment="barrel"
	},
	canAim=function(ply,ent)
		if ent:GetCycle()==1 and !ent.setup_laser then
			local effectdata = EffectData()
			effectdata:SetEntity(ent)
			effectdata:SetFlags(0)
			util.Effect("turret_lazer",effectdata,true,true)
			ent.setup_laser=true
		end
		return ent:GetCycle()==1 and !ent.locked
	end,
	useDefAim=function(ply,ent)
		return ent:GetCycle()<1
	end,
	attack={
		mode= "trigger",
		func=function(ply,ent)
			//ent.locked=true
			if !ent.formTable.canAim(ply,ent) then return end
			//ent.busy=true
			ent.locked=true
			ent:PillSound("lock1")
			ent:PillSound("lock2")
			ent:SetSkin(1)
			timer.Simple(1,function()
				if !IsValid(ent) then return end
				local a = ent:GetAttachment(ent:LookupAttachment("barrel"))
				
				local rocket = ents.Create("pill_proj_rocket")
				rocket:SetModel("models/props_bts/rocket.mdl")
				rocket:SetPos(a.Pos) //(ply:EyePos()+ply:EyeAngles():Forward()*100)
				rocket:SetAngles(a.Ang)
				rocket.sound="weapons/rpg/rocket1.wav"
				rocket.trail="trails/smoke.vmt"
				//rocket.tcolor=HSVToColor(math.Rand(0,360),1,1)
				rocket:Spawn()
				rocket:SetOwner(ply)

				ent:PillSound("shoot")

				ent:SetSkin(2)
			end)
			timer.Simple(2,function()
				if !IsValid(ent) then return end
				ent.locked=false
				ent:SetSkin(0)
			end)
		end
	},
	health=100,
	sounds={
		lock1="weapons/rocket/rocket_locking_beep1.wav",
		lock2="weapons/rocket/rocket_locked_beep1.wav",
		shoot="weapons/rocket/rocket_fire1.wav"
	}
})

pk_pills.register("portal_chell",{
	printName="Test Subject",
	model="models/Player/chell.mdl",
	type="ply",
	default_rp_cost=600,
	anims={
		default={
			idle="idle",
			walk="run",
			crouch="crouchidle",
			crouch_walk="crouchwalk",
			glide="standing_jump",
			jump="standing_jump",
		}
	},
	aim={
		xPose="aim_yaw",
		yPose="aim_pitch"
	},
	moveSpeed={
		walk=300,
		ducked=40
	},
	loadout={"pill_wep_holstered"},
	noFallDamage=true,
	health=100,
	movePoseMode="xy"
})

pk_pills.register("portal_core",{
	printName="Morality Core",
	model="models/props_bts/glados_ball_reference.mdl",
	side="harmless",
	type="phys",
	default_rp_cost=2000,
	spawnOffset=Vector(0,0,50),
	driveType="fly",
	driveOptions={
		speed=10,
		rotation=90
	},
	health=100,
	damageFromWater=-1
})

pk_pills.register("portal_core_curious",{
	printName="Curiosity Core",
	parent="portal_core",
	skin=1,
	seqInit="look_02",
	sounds={
		vocalize=table.Add(pk_pills.helpers.makeList("vo/aperture_ai/escape_02_sphere_curiosity-0#.wav",9),pk_pills.helpers.makeList("vo/aperture_ai/escape_02_sphere_curiosity-#.wav",10,18))
	},
	attack={
		mode="trigger",
		func = function(ply,ent)
			ent:PillSound("vocalize")
		end
	}
})

pk_pills.register("portal_core_angry",{
	printName="Anger Core",
	parent="portal_core_curious",
	skin=2,
	seqInit="look_03",
	sounds={
		vocalize=table.Add(pk_pills.helpers.makeList("vo/aperture_ai/escape_02_sphere_anger-0#.wav",0,9),pk_pills.helpers.makeList("vo/aperture_ai/escape_02_sphere_anger-#.wav",10,21))
	}
})

pk_pills.register("portal_core_cake",{
	printName="Cakemix Core",
	parent="portal_core_curious",
	skin=3,
	seqInit="look_04",
	sounds={
		vocalize=table.Add(pk_pills.helpers.makeList("vo/aperture_ai/escape_02_sphere_cakemix-0#.wav",9),pk_pills.helpers.makeList("vo/aperture_ai/escape_02_sphere_cakemix-#.wav",10,41))
	}
})