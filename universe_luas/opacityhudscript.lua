if SERVER then
resource.AddFile("resource/fonts/Abandoned-Bold.ttf")
end
if CLIENT then
print("* * * * * * * *\n* Opacity Hud *\n* * * * * * * *\ncl_opacityhud_settings")
local img_health = Material("materials/opacityhud/health.png")
CreateClientConVar("cl_opacityhud_opacity_bg", 155, true, false, "", 0, 255)
CreateClientConVar("cl_opacityhud_opacity_text", 155, true, false, "", 0, 255)
CreateClientConVar("cl_opacityhud_draw", 1, true, false, "", 0, 1)
CreateClientConVar("cl_opacityhud_showpb", 1, true, false, "", 0, 1)
CreateClientConVar("cl_opacityhud_pbcolormode", 0, true, false, "", 0, 1)
CreateClientConVar("cl_opacityhud_pb_r", 128, true, false, "", 0, 255)
CreateClientConVar("cl_opacityhud_pb_g", 0, true, false, "", 0, 255)
CreateClientConVar("cl_opacityhud_pb_b", 255, true, false, "", 0, 255)
CreateClientConVar("cl_opacityhud_bg_r", 0, true, false, "", 0, 255)
CreateClientConVar("cl_opacityhud_bg_g", 0, true, false, "", 0, 255)
CreateClientConVar("cl_opacityhud_bg_b", 0, true, false, "", 0, 255)
CreateClientConVar("cl_opacityhud_radius", 14, true, false)

function reset()
	GetConVar("cl_opacityhud_opacity_bg"):SetInt(GetConVar("cl_opacityhud_opacity_bg"):GetDefault())
	GetConVar("cl_opacityhud_opacity_text"):SetInt(GetConVar("cl_opacityhud_opacity_text"):GetDefault())
	GetConVar("cl_opacityhud_draw"):SetInt(GetConVar("cl_opacityhud_draw"):GetDefault())
	GetConVar("cl_opacityhud_pbcolormode"):SetInt(GetConVar("cl_opacityhud_pbcolormode"):GetDefault())
	GetConVar("cl_opacityhud_pb_r"):SetInt(GetConVar("cl_opacityhud_pb_r"):GetDefault())
	GetConVar("cl_opacityhud_pb_g"):SetInt(GetConVar("cl_opacityhud_pb_g"):GetDefault())
	GetConVar("cl_opacityhud_pb_b"):SetInt(GetConVar("cl_opacityhud_pb_b"):GetDefault())
	GetConVar("cl_opacityhud_bg_r"):SetInt(GetConVar("cl_opacityhud_bg_r"):GetDefault())
	GetConVar("cl_opacityhud_bg_g"):SetInt(GetConVar("cl_opacityhud_bg_g"):GetDefault())
	GetConVar("cl_opacityhud_bg_b"):SetInt(GetConVar("cl_opacityhud_bg_b"):GetDefault())
	GetConVar("cl_opacityhud_radius"):SetInt(GetConVar("cl_opacityhud_radius"):GetDefault())
	GetConVar("cl_opacityhud_showpb"):SetInt(GetConVar("cl_opacityhud_showpb"):GetDefault())
end

function bool_to_number(value)
	return value and 1 or 0
end
--reset command
concommand.Add("cl_opacityhud_reset", function()
	reset()
end)
--settings panel
concommand.Add("cl_opacityhud_settings", function()
	local Frame = vgui.Create("DFrame")
	Frame:SetSize(350, 500) 
	Frame:SetTitle("Opacity HUD Settings") 
	Frame:SetVisible(true) 
	Frame:SetDraggable(true) 
	Frame:ShowCloseButton(true) 
	Frame:MakePopup()
	Frame:Center()
	Frame.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(62, 63, 79))
	end
	
	local DScrollPanel = vgui.Create("DScrollPanel", Frame)
	DScrollPanel:Dock(FILL)

	local ResetButton = DScrollPanel:Add("DButton", Frame)
	ResetButton:SetText("Reset")
	ResetButton:SetTextColor(Color(255,255,255))
	ResetButton:SetPos(50, 0)
	ResetButton:SetSize(250, 30)
	ResetButton.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(83, 146, 230))
	end
	ResetButton.DoClick = function()
		reset()
		Frame:Close()
	end
	
	--Background color
	local BgColorLabel = DScrollPanel:Add("DLabel")
	BgColorLabel:SetText("Background color")
	BgColorLabel:SetTextColor(Color(255,255,255))
	BgColorLabel:SetPos(75, 30)
	BgColorLabel:SetSize(300, 30)
	
	local BgColorMixer = DScrollPanel:Add("DColorMixer")
	BgColorMixer:SetPos(50, 55)
	BgColorMixer:SetColor(Color(GetConVarNumber("cl_opacityhud_bg_r"), GetConVarNumber("cl_opacityhud_bg_g"), GetConVarNumber("cl_opacityhud_bg_b"), GetConVarNumber("cl_opacityhud_opacity_bg")))
	
	function BgColorMixer:ValueChanged()
		GetConVar("cl_opacityhud_bg_r"):SetInt(BgColorMixer:GetColor().r)
		GetConVar("cl_opacityhud_bg_g"):SetInt(BgColorMixer:GetColor().g)
		GetConVar("cl_opacityhud_bg_b"):SetInt(BgColorMixer:GetColor().b)
		GetConVar("cl_opacityhud_opacity_bg"):SetInt(BgColorMixer:GetColor().a)
	end
	
	--Progress color
	local PbColorLabel = DScrollPanel:Add("DCheckBoxLabel")
	PbColorLabel:SetText("Indicator color")
	PbColorLabel:SetTextColor(Color(255,255,255))
	PbColorLabel:SetPos(75, 295)
	PbColorLabel:SetSize(300, 30)
	PbColorLabel:SizeToContents()
	PbColorLabel:SetValue(tobool(GetConVarNumber("cl_opacityhud_pbcolormode")))

	function PbColorLabel:OnChange()
		GetConVar("cl_opacityhud_pbcolormode"):SetInt(bool_to_number(PbColorLabel:GetChecked()))
	end
	
	local PbColorMixer = DScrollPanel:Add("DColorMixer")
	PbColorMixer:SetPos(50, 315)
	PbColorMixer:SetColor(Color(GetConVarNumber("cl_opacityhud_pb_r"), GetConVarNumber("cl_opacityhud_pb_g"), GetConVarNumber("cl_opacityhud_pb_b")))
	
	function PbColorMixer:ValueChanged()
		GetConVar("cl_opacityhud_pb_r"):SetInt(PbColorMixer:GetColor().r)
		GetConVar("cl_opacityhud_pb_g"):SetInt(PbColorMixer:GetColor().g)
		GetConVar("cl_opacityhud_pb_b"):SetInt(PbColorMixer:GetColor().b)
	end
	--Radius
	local RadiusLabel = DScrollPanel:Add("DLabel")
	RadiusLabel:SetText("Corner radius")
	RadiusLabel:SetTextColor(Color(255,255,255))
	RadiusLabel:SetPos(75, 550)
	RadiusLabel:SetSize(300, 30)
	local RadiusNumberWang = DScrollPanel:Add("DNumberWang")
	RadiusNumberWang:SetPos(200, 555)
	RadiusNumberWang:SetValue(GetConVarNumber("cl_opacityhud_radius"))
	RadiusNumberWang:SetMinMax(0, 1000)
	function RadiusNumberWang:OnValueChanged(value)
		GetConVar("cl_opacityhud_radius"):SetFloat(value)
	end
	--Text opacity
	local TextOpacityLabel = DScrollPanel:Add("DLabel")
	TextOpacityLabel:SetText("Text opacity")
	TextOpacityLabel:SetTextColor(Color(255,255,255))
	TextOpacityLabel:SetPos(75, 570)
	TextOpacityLabel:SetSize(300, 30)
	local TextOpacityNumberWang = DScrollPanel:Add("DNumberWang")
	TextOpacityNumberWang:SetPos(200, 575)
	TextOpacityNumberWang:SetValue(GetConVarNumber("cl_opacityhud_opacity_text"))
	TextOpacityNumberWang:SetMinMax(0, 255)
	function TextOpacityNumberWang:OnValueChanged(value)
		GetConVar("cl_opacityhud_opacity_text"):SetFloat(value)
	end
	--Show progressbar
	local ShowPbLabel = DScrollPanel:Add("DCheckBoxLabel")
	ShowPbLabel:SetText("Show indicators")
	ShowPbLabel:SetTextColor(Color(255,255,255))
	ShowPbLabel:SetPos(75, 590)
	ShowPbLabel:SetSize(300, 30)
	ShowPbLabel:SizeToContents()
	ShowPbLabel:SetValue(tobool(GetConVarNumber("cl_opacityhud_showpb")))

	function ShowPbLabel:OnChange()
		GetConVar("cl_opacityhud_showpb"):SetInt(bool_to_number(ShowPbLabel:GetChecked()))
	end
	
	--Show
	local ShowLabel = DScrollPanel:Add("DCheckBoxLabel")
	ShowLabel:SetText("Show Opacity HUD")
	ShowLabel:SetTextColor(Color(255,255,255))
	ShowLabel:SetPos(75, 610)
	ShowLabel:SetSize(300, 30)
	ShowLabel:SizeToContents()
	ShowLabel:SetValue(tobool(GetConVarNumber("cl_opacityhud_draw")))

	function ShowLabel:OnChange()
		GetConVar("cl_opacityhud_draw"):SetInt(bool_to_number(ShowLabel:GetChecked()))
	end
end)

-- Hide
local hide = {
	CHudAmmo = true,
	CHudSecondaryAmmo = true,
	CHudHealth = true,
	CHudBattery = true,
}

hook.Add("HUDShouldDraw", "HideDefaults", function(name)
	if hide[name] then
		return false
	end
end)

-- Fonts
surface.CreateFont("OpacityHudFont",
{
	font = "Abandoned",
	extended = false,
	size = 28,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
})
-- Draw
hook.Add("HUDPaint", "OpacityHUD", function()

	if not tobool(GetConVarNumber("cl_drawhud")) then
		return
	end
	if not tobool(GetConVarNumber("cl_opacityhud_draw")) then
		return
	end
	if not LocalPlayer():Alive() then
		return
	end
	
	local playerHealth = LocalPlayer():Health()
	local playerHealthString
	local playerArmor = LocalPlayer():Armor()
	local playerArmorString
	local setColor = Color(0, 255, 0)
	local setColorSecondary = Color(0, 155, 0)
	local widthHealthBar
	local widthArmorBar
	
	if playerHealth <= 0 then
		playerHealthString = 0
	else
		playerHealthString = LocalPlayer():Health()
	end
	
	if playerArmor > 0 then
		playerArmorString = LocalPlayer():Armor()
	end
	
	if playerHealth > 100 then
		widthHealthBar = 170
	else
		widthHealthBar = math.floor(170 * (LocalPlayer():Health() / LocalPlayer():GetMaxHealth()))
	end
	
	if playerArmor > 100 then
		widthArmorBar = 90
	else
		widthArmorBar = math.floor(90 * (LocalPlayer():Armor()/LocalPlayer():GetMaxArmor()))
	end
	
	if playerHealth < 100000000 then
		if playerHealth >= 100 then
			setColor = Color(0, 255, 0)
			setColorSecondary = Color(0, 155, 0)
		elseif playerHealth < 50 and playerHealth >= 20 then
			setColor = Color(255, 128, 0)
			setColorSecondary = Color(155, 78, 0)
		elseif playerHealth < 20 then
			setColor = Color(255, 0, 0)
			setColorSecondary = Color(155, 0, 0)
		end
	else
		playerHealthString = "..."
	end
	
	if playerArmor >= 10000 then
		playerArmorString = "..."
	else
		playerArmorString = playerArmor
	end
	
	--Screen H & W
	local H = ScrH() - 80
	local W = ScrW() - 325
	
	--HP
	draw.RoundedBoxEx(GetConVarNumber("cl_opacityhud_radius"), 25, H, 170, 65, Color(GetConVarNumber("cl_opacityhud_bg_r"), GetConVarNumber("cl_opacityhud_bg_g"), GetConVarNumber("cl_opacityhud_bg_b"), GetConVarNumber("cl_opacityhud_opacity_bg")), true, true, false, false)
	if tobool(GetConVarNumber("cl_opacityhud_showpb")) then
		if tobool(GetConVarNumber("cl_opacityhud_pbcolormode")) then
			draw.RoundedBox(0, 25, H + 59, 170, 6, Color(GetConVarNumber("cl_opacityhud_pb_r")/2, GetConVarNumber("cl_opacityhud_pb_g")/2, GetConVarNumber("cl_opacityhud_pb_b")/2))
			draw.RoundedBox(0, 25, H + 59, widthHealthBar, 6, Color(GetConVarNumber("cl_opacityhud_pb_r"), GetConVarNumber("cl_opacityhud_pb_g"), GetConVarNumber("cl_opacityhud_pb_b")))
		else
			draw.RoundedBox(0, 25, H + 59, 170, 6, setColorSecondary)
			draw.RoundedBox(0, 25, H + 59, widthHealthBar, 6, setColor)
		end
	end
	draw.SimpleText(playerHealthString, "OpacityHudFont", 110, H + 30, Color(255, 255, 255, GetConVarNumber("cl_opacityhud_opacity_text")), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
	--ARMOR
	if playerArmor > 0 then
		draw.RoundedBoxEx(GetConVarNumber("cl_opacityhud_radius"), 205, H, 90, 65, Color(GetConVarNumber("cl_opacityhud_bg_r"), GetConVarNumber("cl_opacityhud_bg_g"), GetConVarNumber("cl_opacityhud_bg_b"), GetConVarNumber("cl_opacityhud_opacity_bg")), true, true, false, false)
	if tobool(GetConVarNumber("cl_opacityhud_showpb")) then	
		if tobool(GetConVarNumber("cl_opacityhud_pbcolormode")) then
			draw.RoundedBox(0, 205, H + 59, 90, 6, Color(GetConVarNumber("cl_opacityhud_pb_r")/2, GetConVarNumber("cl_opacityhud_pb_g")/2, GetConVarNumber("cl_opacityhud_pb_b")/2))
			draw.RoundedBox(0, 205, H + 59, widthArmorBar, 6, Color(GetConVarNumber("cl_opacityhud_pb_r"), GetConVarNumber("cl_opacityhud_pb_g"), GetConVarNumber("cl_opacityhud_pb_b")))
		else
			draw.RoundedBox(0, 205, H + 59, 90, 6, Color(0, 80, 215))
			draw.RoundedBox(0, 205, H + 59, widthArmorBar, 6, Color(0, 128, 255))
		end
	end
		draw.SimpleText(playerArmorString, "OpacityHudFont", 250, H+30, Color(255, 255, 255, GetConVarNumber("cl_opacityhud_opacity_text")), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	--AMMO
	local plyWeapon = LocalPlayer():GetActiveWeapon()
	local playerClipAmmo, playerSecondaryAmmo, playerTotalAmmo, playerClipAmmoMax = 0, 0, 0, 0
	local playerClipAmmoString = ""
	local playerTotalAmmoString = ""
	local playerSecondaryAmmoString = ""
	local playerClipAmmoMaxString = ""
	local widthAmmoBar
	
	if plyWeapon and plyWeapon:IsValid() then
		playerClipAmmo = plyWeapon:Clip1()
		playerClipAmmoMax = plyWeapon:GetMaxClip1()
		playerSecondaryAmmo = LocalPlayer():GetAmmoCount(plyWeapon:GetSecondaryAmmoType())
		playerTotalAmmo = LocalPlayer():GetAmmoCount(plyWeapon:GetPrimaryAmmoType())
	end
	
	if(playerSecondaryAmmo >= 100000) then
		playerSecondaryAmmoString = "..."
	else
		playerSecondaryAmmoString = playerSecondaryAmmo
	end
	
	if(playerClipAmmo >= 1000) then
		playerClipAmmoString = "..."
	else
		playerClipAmmoString = playerClipAmmo
	end
	
	if(playerClipAmmoMax >= 1000) then
		playerClipAmmoMaxString = "..."
	else
		playerClipAmmoMaxString = playerClipAmmoMax
	end
	
	if(playerTotalAmmo >= 100000) then
		playerTotalAmmoString = "..."
	else
		playerTotalAmmoString = playerTotalAmmo
	end
	
	if playerClipAmmo > playerClipAmmoMax then
		widthAmmoBar = 125
	else
		widthAmmoBar = math.floor(125 * (playerClipAmmo/playerClipAmmoMax))
	end
	
	if plyWeapon and plyWeapon:IsValid() and not LocalPlayer():InVehicle() then
	
		if playerClipAmmo ~= -1 and playerTotalAmmo ~= -1 then
			draw.RoundedBoxEx(GetConVarNumber("cl_opacityhud_radius"), W+175, H -85, 125, 150, Color(GetConVarNumber("cl_opacityhud_bg_r"), GetConVarNumber("cl_opacityhud_bg_g"), GetConVarNumber("cl_opacityhud_bg_b"), GetConVarNumber("cl_opacityhud_opacity_bg")), true, true, true, true)
		if tobool(GetConVarNumber("cl_opacityhud_pbcolormode")) then
			if tobool(GetConVarNumber("cl_opacityhud_showpb")) then
				draw.RoundedBox(0, W+175, H -12, 125, 6, Color(GetConVarNumber("cl_opacityhud_pb_r")/2, GetConVarNumber("cl_opacityhud_pb_g")/2, GetConVarNumber("cl_opacityhud_pb_b")/2))
				draw.RoundedBox(0, W+175, H -12, widthAmmoBar, 6, Color(GetConVarNumber("cl_opacityhud_pb_r"), GetConVarNumber("cl_opacityhud_pb_g"), GetConVarNumber("cl_opacityhud_pb_b")))
			end
		else
			if tobool(GetConVarNumber("cl_opacityhud_showpb")) then
				draw.RoundedBox(0, W+175, H -12, 125, 5, Color(155, 78, 0))
				draw.RoundedBox(0, W+175, H -12, widthAmmoBar, 5, Color(255, 128, 0))
			end
		end
			draw.SimpleText(playerClipAmmoString.."/"..playerClipAmmoMaxString, "OpacityHudFont", W+237, H - 48, Color(255, 255, 255, GetConVarNumber("cl_opacityhud_opacity_text")), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(playerTotalAmmoString, "OpacityHudFont", W+237, H + 28, Color(255, 255, 255, GetConVarNumber("cl_opacityhud_opacity_text")), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			if(playerClipAmmo > playerClipAmmoMax) then
				draw.SimpleText("+1", "OpacityHudFont", W+145, H - 48, Color(255, 255, 255, GetConVarNumber("cl_opacityhud_opacity_text")), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		elseif playerClipAmmo == -1 and playerTotalAmmo > 0 then
			draw.RoundedBoxEx(GetConVarNumber("cl_opacityhud_radius"), W+175, H -85, 125, 150, Color(GetConVarNumber("cl_opacityhud_bg_r"), GetConVarNumber("cl_opacityhud_bg_g"), GetConVarNumber("cl_opacityhud_bg_b"), GetConVarNumber("cl_opacityhud_opacity_bg")), true, true, true, true)
		if tobool(GetConVarNumber("cl_opacityhud_pbcolormode")) then
			if tobool(GetConVarNumber("cl_opacityhud_showpb")) then
				draw.RoundedBox(0, W+175, H -12, 125, 6, Color(GetConVarNumber("cl_opacityhud_pb_r")/2, GetConVarNumber("cl_opacityhud_pb_g")/2, GetConVarNumber("cl_opacityhud_pb_b")/2))
				draw.RoundedBox(0, W+175, H -12, widthAmmoBar, 6, Color(GetConVarNumber("cl_opacityhud_pb_r"), GetConVarNumber("cl_opacityhud_pb_g"), GetConVarNumber("cl_opacityhud_pb_b")))
			end
		else
			if tobool(GetConVarNumber("cl_opacityhud_showpb")) then
				draw.RoundedBox(0, W+175, H -12, 125, 5, Color(155, 78, 0))
				draw.RoundedBox(0, W+175, H -12, widthAmmoBar, 5, Color(255, 128, 0))
			end
		end
			draw.SimpleText("- / -", "OpacityHudFont", W+237, H - 48, Color(255, 255, 255, GetConVarNumber("cl_opacityhud_opacity_text")), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(playerTotalAmmoString, "OpacityHudFont", W+237, H + 28, Color(255, 255, 255, GetConVarNumber("cl_opacityhud_opacity_text")), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
		if playerSecondaryAmmo > 0 then
			draw.RoundedBoxEx(GetConVarNumber("cl_opacityhud_radius"), W+175, H -150, 125, 50, Color(0, 70, 70, GetConVarNumber("cl_opacityhud_opacity_bg")), true, true, true, true)
			draw.SimpleText(playerSecondaryAmmoString, "OpacityHudFont", W+237, H - 123, Color(0, 255, 255, GetConVarNumber("cl_opacityhud_opacity_text")), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
	end
end)
end