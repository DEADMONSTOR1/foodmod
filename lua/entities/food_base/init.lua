AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include( "shared.lua" )

function ENT:SpawnFunction( ply, tr, class )
	if ( !tr.Hit ) then return end
	local pos = tr.HitPos + tr.HitNormal * 4
	local ent = ents.Create( class )
	ent:SetPos( pos )
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Initialize()
	self:SetModel( self.foodModel )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	
	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
end

function ENT:Use( activator )

	local energy = activator:GetNWInt("Food", 0)
	activator:SetNWInt( "Food", math.Clamp( (energy or 0) + 30, 0, 100 ) )
	
	activator:EmitSound( self.foodSound, 50, 100 )
end

function DrainFood()
	for k,v in pairs(player.GetAll()) do
		if v:IsValid() and v:IsAlive() then
			local food = v:GetNWInt('Food', 0)
			v:SetNWInt('Food', tonumber('Food'), - 1)
		end
	end
	timer.Simple(6 , DrainFood)
end
timer.Simple(6 , DrainFood)

function PlayerSetFoodOnSpawn(ply)
	
	ply:SetNWInt('Food' , 50)
	
end
hook.Add('PlayerSpawn' , 'PlayerSetFoodOnSpawn', PlayerSetFoodOnSpawn)
