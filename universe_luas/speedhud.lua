local speedUnitConVar = CreateClientConVar("hud_ups", "0", true, false, "Toggles metering between horizontal and horizontal-vertical units per second")

local function DrawHUD()
    local yellow = Color(255, 220, 0, 190)

    local w, h = 300, 30
    local x, y = math.floor(ScrW() / 2 - w / 2), ScrH() - h - 50
    local horizontalvelocity = math.Round(LocalPlayer():GetVelocity():Length2D())
	local bothvelocity = math.Round(LocalPlayer():GetVelocity():Length())

    local hvelocity = math.ceil(horizontalvelocity)
	local bvelocity = math.ceil(bothvelocity)

    local speedUnit = speedUnitConVar:GetBool() and hvelocity or bvelocity

    draw.SimpleText(
        speedUnit,
        "HudNumbers",
        ScrW() / 1.99,
        y,
        yellow,
        TEXT_ALIGN_LEFT
    )

    draw.SimpleText(
        "UPS",
        "CreditsText",
        ScrW() / 2.04 + 8,
        y + 11,
        yellow,
        TEXT_ALIGN_RIGHT
    )
end

local function DrawHUDBackground()
	local w, h = 330, 60
	local x, y = math.floor(ScrW() / 2 - w / 2), ScrH() - h - 30
	
	draw.RoundedBox(7, 890, 971, 150, 81, Color(0, 0, 0, 76))
end

hook.Add("HUDPaint", "DrawMyHUD", DrawHUD)
hook.Add("HUDPaintBackground", "DrawMyBackground", DrawHUDBackground)
