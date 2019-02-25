surface.CreateFont( "WpnInfoHead", {
	font = "Bebas Neue",
	size = 111,
	weight = 0,
	antialias = true
} )

surface.CreateFont( "WpnInfoBody", {
	font = "Bebas Neue",
	size = 88,
	weight = 0,
	antialias = true
} )

surface.CreateFont( "WpnInfoHead_hud", {
	font = "Bebas Neue",
	size = 48,
	weight = 0,
	antialias = true
} )

surface.CreateFont( "WpnInfoBody_hud", {
	font = "Bebas Neue",
	size = 37,
	weight = 0,
	antialias = true
} )

local wpninfo = {}

wpninfo.tttweaponnames =
{
	
	[ "pistol_name" ] = "Pistol",
	[ "knife_name" ] = "Knife",
	[ "rifle_name" ] = "Rifle",
	[ "shotgun_name" ] = "Shotgun",
	[ "sipistol_name" ] = "Silenced Pistol",
	[ "flare_name" ] = "Flare Gun",
	[ "newton_name" ] = "Newton Launcher",
	[ "grenade_smoke" ] = "Smoke Grenade",
	[ "grenade_fire" ] = "Incendiary Grenade",
	[ "c4" ] = "C4 Explosive",
	[ "tele_name" ] = "Teleporter",
	[ "magnet_name" ] = "Magneto-stick",
	[ "dna_name" ] = "DNA Scanner",
	[ "decoy_name" ] = "Decoy",
	[ "unarmed_name" ] = "Holstered"

}

wpninfo.fonts =
{

	head = "WpnInfoHead",
	body = "WpnInfoBody",
	head_hud = "WpnInfoHead_hud",
	body_hud = "WpnInfoBody_hud"

}

wpninfo.colors =
{

	background = Color( 13, 13, 13, 150 ),
	text = Color( 255, 255, 255, 255 )
	
}

wpninfo.infos =
{

	name = "N/A",
	slot = "0",
	damage = "N/A",
	clipsize = "N/A",
	automatic = "NO",
	spread = "0",
	recoil = "0",
	firerate = "0",
	ammo = "N/A"

}


local function getweaponinfo(ent)
	
	// Name
	if wpninfo.tttweaponnames[ ent:GetPrintName() ] then

		wpninfo.infos.name = wpninfo.tttweaponnames[ ent:GetPrintName() ]

	else

		wpninfo.infos.name = ent:GetPrintName()

	end
	
	//Slot
	wpninfo.infos.slot = ent.Slot + 1

	// Damage
	if pcall(
		function() 
			if ent.Primary.Damage > 1 then 
				wpninfo.infos.damage = ent.Primary.Damage
			end
		end) then
		wpninfo.infos.damage = ent.Primary.Damage
	elseif pcall(
		function()
			if ent.Damage > 1 then
				wpninfo.infos.damage = ent.Damage
			end
		end) then
		wpninfo.infos.damage = ent.Damage
	else
		wpninfo.infos.damage = "0"
		print("'damage' not found!")
	end
		
	// Clip Size
	if ent.Primary.ClipSize > 0 then
		wpninfo.infos.clipsize = ent.Primary.ClipSize
	end
		
	// Automatic
	if ent.Primary.Automatic == true then
		wpninfo.infos.automatic = "YES"				
	end

	// Spread
	if pcall(
		function()
			if ent.Primary.Cone < 42 then
				wpninfo.infos.spread = ent.Primary.Cone
			end
		end) then
		wpninfo.infos.spread = ent.Primary.Cone
	elseif pcall(
		function()
			if ent.AimSpread < 42 then
				wpninfo.infos.spread = ent.AimSpread
			end
		end) then
		wpninfo.infos.spread = ent.AimSpread
	else
		wpninfo.infos.spread = "0"
		print("'spread' not found!")
	end
	
	
	// Recoil
	if pcall(
		function()
			if ent.Primary.Recoil < 42 then
				wpninfo.infos.recoil = ent.Primary.Recoil
			end
		end) then
		wpninfo.infos.recoil = ent.Primary.Recoil
	elseif pcall(
		function()
			if ent.Recoil < 42 then
				wpninfo.infos.recoil = ent.Recoil
			end
		end) then
		wpninfo.infos.recoil = ent.Recoil
	else
		wpninfo.infos.recoil = "0"
		print("'recoil' not found!")
	end
	
	//Fire Rate
	if pcall(
		function() 
			wpninfo.infos.firerate = math.Round( 60/ent.Primary.Delay )
		end) then
		wpninfo.infos.firerate = math.Round( 60/ent.Primary.Delay )
	elseif pcall(
		function()
			wpninfo.infos.firerate = math.Round( 60/ent.FireDelay )
		end) then
		wpninfo.infos.firerate = math.Round( 60/ent.FireDelay )
	else
		wpninfo.infos.firerate = "0"
		print("'delay' not found!")
	end
	
	//Ammo
	wpninfo.infos.ammo = ent.Primary.Ammo
	
end



local function drawwpninfo()

	local x, y, width, height, panelwidth, panelheight, desc, padding, position, angle, scale
	local ply = LocalPlayer()
	local wpn = ply:GetActiveWeapon()
	local ent = util.TraceLine(
	{

		start = ply:GetShootPos(),
		endpos = ply:GetShootPos() + ( ply:GetAimVector() * 222 ),
		filter = ply,
		mask = MASK_SHOT_HULL

	} ).Entity

	local function getnewy( text )

		width, height = surface.GetTextSize( text )
		return y + height

	end

	if IsValid( ent ) then
		
		padding = 42
		
		angle = Angle( 0, ply:EyeAngles().y - 90, 90 )
		scale = 0.04

		
		// Display informations about weapons
		if ent:IsWeapon() and ent:IsScripted() then
		
			getweaponinfo(ent) 
			
			if string.len(wpninfo.infos.name) > 17 then
				panelwidth = 666 + string.len(wpninfo.infos.name) * 7
			else
				panelwidth = 666
			end
			
			panelheight = 842
			
			x = -panelwidth / 2
			y = 0

			position = ent:GetPos() + Vector( 0, 0, 42 + math.sin( CurTime() * 1.3 ) * 2.3 )	

			// Draw the informations about the weapon
			cam.Start3D2D( position, angle, scale )
			
				draw.RoundedBox( 27, x, y, panelwidth, panelheight, wpninfo.colors.background )
					
					
					desc = wpninfo.infos.name
					draw.DrawText( desc, wpninfo.fonts.head, 0, y + 7, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
					
					y = getnewy( desc )
					desc = "SlotNr: "
					draw.DrawText( desc, wpninfo.fonts.body, x + padding, y, wpninfo.colors.text, TEXT_ALIGN_LEFT )
					draw.DrawText( wpninfo.infos.slot, wpninfo.fonts.body, x + panelwidth - padding, y, wpninfo.colors.text, TEXT_ALIGN_RIGHT )
					
					y = getnewy( desc )
					desc = "Damage: "
					draw.DrawText( desc, wpninfo.fonts.body, x + padding, y, wpninfo.colors.text, TEXT_ALIGN_LEFT )
					draw.DrawText( wpninfo.infos.damage, wpninfo.fonts.body, x + panelwidth - padding, y, wpninfo.colors.text, TEXT_ALIGN_RIGHT )
					
					y = getnewy( desc )
					desc = "Mag. Size: "
					draw.DrawText( desc, wpninfo.fonts.body, x + padding, y, wpninfo.colors.text, TEXT_ALIGN_LEFT )
					draw.DrawText( wpninfo.infos.clipsize, wpninfo.fonts.body, x + panelwidth - padding, y, wpninfo.colors.text, TEXT_ALIGN_RIGHT )
					
					y = getnewy( desc )
					desc = "Automatic: "
					draw.DrawText( desc, wpninfo.fonts.body, x + padding, y, wpninfo.colors.text, TEXT_ALIGN_LEFT )
					draw.DrawText( wpninfo.infos.automatic, wpninfo.fonts.body, x + panelwidth - padding, y, wpninfo.colors.text, TEXT_ALIGN_RIGHT )
					
					y = getnewy( desc )
					desc = "Spread: "
					draw.DrawText( desc, wpninfo.fonts.body, x + padding, y, wpninfo.colors.text, TEXT_ALIGN_LEFT )
					draw.DrawText( wpninfo.infos.spread, wpninfo.fonts.body, x + panelwidth - padding, y, wpninfo.colors.text, TEXT_ALIGN_RIGHT )
					
					y = getnewy( desc )
					desc = "Recoil: "
					draw.DrawText( desc, wpninfo.fonts.body, x + padding, y, wpninfo.colors.text, TEXT_ALIGN_LEFT )
					draw.DrawText( wpninfo.infos.recoil, wpninfo.fonts.body, x + panelwidth - padding, y, wpninfo.colors.text, TEXT_ALIGN_RIGHT )
					
					y = getnewy( desc )
					desc = "Firerate: "
					draw.DrawText( desc, wpninfo.fonts.body, x + padding, y, wpninfo.colors.text, TEXT_ALIGN_LEFT )
					draw.DrawText( wpninfo.infos.firerate .. "RPM", wpninfo.fonts.body, x + panelwidth - padding, y, wpninfo.colors.text, TEXT_ALIGN_RIGHT )
					
					y = getnewy( desc )
					desc = "Ammo: "
					draw.DrawText( desc, wpninfo.fonts.body, x + padding, y, wpninfo.colors.text, TEXT_ALIGN_LEFT )
					draw.DrawText( wpninfo.infos.ammo, wpninfo.fonts.body, x + panelwidth - padding, y, wpninfo.colors.text, TEXT_ALIGN_RIGHT )
					
			cam.End3D2D()
			
			
		// Display information about ammunitions
		elseif ent.Type and ent.AmmoType and ent.Type == "anim" then
			
			width, height = surface.GetTextSize(ent.AmmoType)

			panelwidth = width + padding > 500 and width + padding * 4 or 500
			panelheight = 200
			x = -panelwidth / 2
			y = 0

			position = ent:GetPos() + Vector( 0, 0, 23 + math.sin( CurTime() * 1.3 ) * 2.3 )
			
			cam.Start3D2D( position, angle, scale )

				// If the player current weapon uses the ammo the player is looking at the RoundedBox you be green
				draw.RoundedBox( 30, x, y, panelwidth, panelheight, (wpn:IsWeapon() and wpn.Primary and (wpn.Primary.Ammo == ent.AmmoType) and Color( 41, 163, 92, 100 ) or wpninfo.colors.background) )
				draw.DrawText( ent.AmmoType, wpninfo.fonts.body, 0, y + padding, wpninfo.colors.text, TEXT_ALIGN_CENTER )

			cam.End3D2D()

		end

	end

end



local function drawwpninfoonscore()
	
	local x, y, width, height, panelwidth, panelheight, desc, padding
	local ply = LocalPlayer()
	local wpn = ply:GetActiveWeapon()
	
	if ply:KeyDown(IN_SCORE) then
	
		local function getnewy( text )

			width, height = surface.GetTextSize( text )
			return y + height

		end

		if IsValid( wpn ) then
		
			padding = 17

			// Display informations about weapons
			if wpn:IsWeapon() and wpn:IsScripted() then
			
				getweaponinfo(wpn)
				
				panelwidth = 300
				panelheight = 330
			
				x = ScrW() - panelwidth
				y = (ScrH()/2) - (panelheight / 2)

				// Draw the informations about the weapon
				
				draw.RoundedBox( 13, x, y, panelwidth, panelheight, wpninfo.colors.background )
				
					desc = wpninfo.infos.name
					draw.DrawText( desc, wpninfo.fonts.head_hud, x + (panelwidth/2), y + 3, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
				
					y = getnewy( desc )
					desc = "Damage: "
					draw.DrawText( desc, wpninfo.fonts.body_hud, x + padding, y, wpninfo.colors.text, TEXT_ALIGN_LEFT )
					draw.DrawText( wpninfo.infos.damage, wpninfo.fonts.body_hud, x + panelwidth - padding, y, wpninfo.colors.text, TEXT_ALIGN_RIGHT )
				
					y = getnewy( desc )
					desc = "Mag. Size: "
					draw.DrawText( desc, wpninfo.fonts.body_hud, x + padding, y, wpninfo.colors.text, TEXT_ALIGN_LEFT )
					draw.DrawText( wpninfo.infos.clipsize, wpninfo.fonts.body_hud, x + panelwidth - padding, y, wpninfo.colors.text, TEXT_ALIGN_RIGHT )
					
					y = getnewy( desc )
					desc = "Automatic: "
					draw.DrawText( desc, wpninfo.fonts.body_hud, x + padding, y, wpninfo.colors.text, TEXT_ALIGN_LEFT )
					draw.DrawText( wpninfo.infos.automatic, wpninfo.fonts.body_hud, x + panelwidth - padding, y, wpninfo.colors.text, TEXT_ALIGN_RIGHT )
					
					y = getnewy( desc )
					desc = "Spread: "
					draw.DrawText( desc, wpninfo.fonts.body_hud, x + padding, y, wpninfo.colors.text, TEXT_ALIGN_LEFT )
					draw.DrawText( wpninfo.infos.spread, wpninfo.fonts.body_hud, x + panelwidth - padding, y, wpninfo.colors.text, TEXT_ALIGN_RIGHT )
					
					y = getnewy( desc )
					desc = "Recoil: "
					draw.DrawText( desc, wpninfo.fonts.body_hud, x + padding, y, wpninfo.colors.text, TEXT_ALIGN_LEFT )
					draw.DrawText( wpninfo.infos.recoil, wpninfo.fonts.body_hud, x + panelwidth - padding, y, wpninfo.colors.text, TEXT_ALIGN_RIGHT )
				
					y = getnewy( desc )
					desc = "Firerate: "
					draw.DrawText( desc, wpninfo.fonts.body_hud, x + padding, y, wpninfo.colors.text, TEXT_ALIGN_LEFT )
					draw.DrawText( wpninfo.infos.firerate .. "RPM", wpninfo.fonts.body_hud, x + panelwidth - padding, y, wpninfo.colors.text, TEXT_ALIGN_RIGHT )
				
					y = getnewy( desc )
					desc = "Ammo: "
					draw.DrawText( desc, wpninfo.fonts.body_hud, x + padding, y, wpninfo.colors.text, TEXT_ALIGN_LEFT )
					draw.DrawText( wpninfo.infos.ammo, wpninfo.fonts.body_hud, x + panelwidth - padding, y, wpninfo.colors.text, TEXT_ALIGN_RIGHT )
			
			end
		end
	end
end


hook.Add( "PostDrawOpaqueRenderables", "drawwpn", drawwpninfo )
hook.Add( "HUDDrawScoreBoard", "drawwpnonscore", drawwpninfoonscore )