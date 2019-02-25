if SERVER then
	
	AddCSLuaFile("cl_weapon_information.lua")

else

	include("cl_weapon_information.lua")

end