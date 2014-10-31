AddCSLuaFile()

pk_pills.register("portal2_turret",{
	parent="portal_turret",
	model="models/npcs/turret/turret.mdl",
	printName="Turret"
})

pk_pills.register("portal2_turret_sideways",{
	parent="portal2_turret",
	model="models/npcs/turret/turret_backwards.mdl",
	printName="Backwards Turret",
	aim={
		xPose="aim_pitch",
		yPose="aim_yaw",
		xInvert=true,
		yInvert=true,
		xOffset=180,
		attachment="LFT_Gun1_Muzzle"
	},
	attack={
		func=function(ply,ent,tbl)
			ent.formTable.aim.attachment="LFT_Gun2_Muzzle"
			pk_pills.common.shoot(ply,ent,tbl)
		end
	},
})

pk_pills.register("portal2_turret_defect",{
	parent="portal2_turret",
	model="models/npcs/turret/turret_skeleton.mdl",
	printName="Defective Turret"
})

pk_pills.register("portal2_hermit",{
	printName="Hermit Cube",
	side="harmless",
	type="phys",
	model="models/npcs/monsters/monster_a.mdl",
	default_rp_cost=800,
	spawnOffset=Vector(0,0,20),
	attack={
		mode="auto",
		func=function(ply,ent,tbl)
			ent:PillSound("move")

			local phys = ent:GetPhysicsObject()
			local trace = util.QuickTrace(ent:GetPos(),-ent:GetAngles():Up()*50,ent)

			if IsValid(phys) and trace.Hit then
				local angs = ply:EyeAngles()
				local curAngs = ent:GetAngles()
				angs.pitch=0
				local yawforce = (angs.yaw-curAngs.yaw)*3
				phys:ApplyForceCenter(angs:Forward()*5000+Vector(0,0,5000))
				phys:AddAngleVelocity(Vector(0,0,yawforce))
			end
		end,
		delay=.5
	},
	attack2={
		mode="trigger",
		func = function(ply,ent)
			ent:PillSound("vocalize")
		end
	},
	sounds={
		move=pk_pills.helpers.makeList("npc/box_monster/box_monster_leg_kick_0#.wav",4),
		vocalize=table.Add(pk_pills.helpers.makeList("npc/box_monster/box_monster_chitter_0#.wav",9),pk_pills.helpers.makeList("npc/box_monster/box_monster_chitter_#.wav",10,20))
	},
	health=50
})
--[[
pk_pills.register("portal2_cube",{
	printName="Storage Cube",
	parent="portal_cube",
	model=""
	/*type="phys",
	side="harmless",
	model="models/props/metal_box.mdl",
	default_rp_cost=1000,
	driveType="roll",
	driveOptions={
		power=6000,
		jump=30000,
		rotcap=1000
	}*/
})

pk_pills.register("portal2_lovecube",{
	printName="Companion Cube",
	parent="portal_cube",
	default_rp_cost=10000,
	skin=1
})

pk_pills.register("portal2_ball",{
	printName="Storage Ball",
	parent="portal_cube",
	model="models/props/sphere.mdl",
	driveOptions={
		power=2000,
		jump=60000,
		rotcap=false
	}
})
]]

// todo models/props_underground/underground_weighted_cube.mdl

pk_pills.register("portal2_core_wheatley",{
	printName="Wheatley",
	model="models/npcs/personality_sphere/personality_sphere.mdl",
	parent="portal_core",
	seqInit="sphere_idle_neutral",
	skin=1,
	options=function() return {
		{skin=0},
		{skin=1}
	} end
})

pk_pills.register("portal2_core_glad",{
	printName="GLaDOS Core",
	model="models/npcs/glados/glados_small_head.mdl",
	parent="portal_core"
})

pk_pills.register("portal2_core_space",{
	printName="Space Core",
	model="models/npcs/personality_sphere/personality_sphere_skins.mdl",
	parent="portal_core_curious",
	seqInit="core01_idle",
	skin=2,
	sounds={
		vocalize=pk_pills.helpers.makeList("vo/aperture_ai/space#.wav",87)
	}
})

pk_pills.register("portal2_core_rick",{
	printName="Rick",
	model="models/npcs/personality_sphere/personality_sphere_skins.mdl",
	parent="portal_core_curious",
	seqInit="core03_idle",
	skin=1,
	sounds={
		vocalize=pk_pills.helpers.makeList("vo/aperture_ai/rick#.wav",30)
	}
})

pk_pills.register("portal2_core_facts",{
	printName="Factoid Core",
	model="models/npcs/personality_sphere/personality_sphere_skins.mdl",
	parent="portal_core_curious",
	seqInit="core02_idle",
	skin=3,
	sounds={
		vocalize=pk_pills.helpers.makeList("vo/aperture_ai/fact#.wav",65)
	}
})

pk_pills.register("portal2_core_bomb",{
	printName="Explosive Core",
	model="models/npcs/personality_sphere_angry.mdl",
	parent="portal_core",
	trail={
		texture="trails/laser.vmt",
		width=40,
		color=Color(255,0,0)
	},
	attack={
		mode="trigger",
		func= function(ply,ent)
			ent:PillDie()
		end
	},
	diesOnExplode=true,
	die=function(ply,ent)
		local explode = ents.Create("env_explosion")
		explode:SetPos(ent:GetPos())
		explode:Spawn()
		explode:SetOwner(ply)
		explode:SetKeyValue("iMagnitude","100")
		explode:Fire("Explode",0,0)
	end,
	driveOptions={
		speed=20
	},
})

pk_pills.register("portal2_tater",{
	printName="PotatOS",
	type="phys",
	side="harmless",
	model="models/npcs/potatos/world_model/potatos_wmodel.mdl",
	default_rp_cost=800,
	health=10,
	driveType="roll",
	driveOptions={
		power=80,
		jump=2000,
		burrow=4
	}
})