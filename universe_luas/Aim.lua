local zoomActivated = false
local lerpFOV = 0

hook.Add("AdjustMouseSensitivity", "zoom_rewrite", function(default)
    if not zoomActivated then return end
    return 1 - (lerpFOV * 0.5)
end, HOOK_LOW)

hook.Add("CreateMove", "zoom_rewrite", function(cmd)
    zoomActivated = hook.Run("HUDShouldDraw", "CHudZoom") and cmd:KeyDown(IN_ZOOM)
    cmd:RemoveKey(IN_ZOOM)
end)

local mult = 0
local FT = FrameTime()

hook.Add("RenderScene", "zoom_rewrite", function()
    FT = FrameTime()
    lerpFOV = Lerp(FT * 12, lerpFOV, zoomActivated and 1 or 0)

    if zoomActivated then
        mult = mult + FT * 1000
        mult = mult > 256 and 256 or mult
    else
        mult = lerpFOV
    end
end)

hook.Remove("HUDPaint", "zoom_rewrite")

function GAMEMODE:CalcView( ply, origin, angles, fov, znear, zfar )
    local Vehicle    = ply:GetVehicle()
    local Weapon    = ply:GetActiveWeapon()

    local view = {
        ["origin"] = origin,
        ["angles"] = angles,
        ["fov"] = fov * (1 - lerpFOV) + (38 * lerpFOV),
        ["znear"] = znear,
        ["zfar"] = r_farz_client,
        ["drawviewer"] = false,
    }

    if ( IsValid( Vehicle ) ) then return hook.Run( "CalcVehicleView", Vehicle, ply, view ) end
    if ( drive.CalcView( ply, view ) ) then return view end

    player_manager.RunClass( ply, "CalcView", view )

    if ( IsValid( Weapon ) ) then

        local func = Weapon.CalcView
        if ( func ) then
            local origin, angles, fov = func( Weapon, ply, Vector( view.origin ), Angle( view.angles ), view.fov ) -- Note: Constructor to copy the object so the child function can't edit it.
            view.origin, view.angles, view.fov = origin or view.origin, angles or view.angles, fov or view.fov
        end

    end

    return view
end