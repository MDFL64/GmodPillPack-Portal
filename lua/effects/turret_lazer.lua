function EFFECT:Init(effectdata)
	self.ent = effectdata:GetEntity()
	self.ply = self.ent:GetPillUser()
	self.red = effectdata:GetFlags()==1
end

function EFFECT:Think()
	if !IsValid(self.ent) or !IsValid(self.ply) then return false end

	local a = self.ent:GetAttachment(self.ent:LookupAttachment(self.red and "eyes" or "eye"))
	self.tr = util.QuickTrace(a.Pos,a.Ang:Forward()*99999,self.ent)

	self:SetPos(a.Pos)
	self:SetRenderBoundsWS(self:GetPos(),self.tr.HitPos)
	return true --todo
end
 
local lazerMat = Material("cable/physbeam")
local lazerMatRed = Material("cable/redlaser")
local dotMat = Material("sprites/light_glow02_add")
function EFFECT:Render()
	if !self.tr then return end
	if self.red then
		render.SetMaterial(lazerMatRed)
	else
		render.SetMaterial(lazerMat)
	end
	//render.SetColorModulation( number r, number g, number b )
	render.DrawBeam(self:GetPos(),self.tr.HitPos,1,0,self:GetPos():Distance(self.tr.HitPos)/300,Color(255,0,0))

	cam.Start3D(EyePos(),EyeAngles())
		render.SetMaterial(dotMat)
		local c = self.red and Color(240,60,60) or Color(130,190,240)
		render.DrawSprite(self.tr.HitPos, 8, 8, c) //color
	cam.End3D()
end