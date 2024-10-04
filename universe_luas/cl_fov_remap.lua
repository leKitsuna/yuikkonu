include("cl_fov_remap_menu.lua")
AddCSLuaFile()

-- steam deck beta for hl2 has a higher FOV limit
-- why can't this be in gmod
-- so that no one else has to make this

--- cvars
-- since i'm gonna have a migraine setting this up so that we use cached values, we're just gonna call :Get...() functions on deez
-- cvar values are probably cached anyway

local fov_desired = GetConVar("fov_desired")
local cl_fov_remap_vm = CreateClientConVar("cl_fov_remap_vm", cvars.Number("viewmodel_fov", 54), true, false, "The desired ViewModel FOV. Note that this will probably not work with SWEPs, but will work with stock Half-Life 2 weapons.")
local cl_fov_remap_vm_fixed = CreateClientConVar("cl_fov_remap_vm_fixed", 0, true, false, "ViewModel FOV does not follow player camera FOV?")
local cl_fov_remap_desired = CreateClientConVar("cl_fov_remap_desired", cvars.Number("fov_desired", 75), true, false, "The desired player camera FOV.")
local cl_fov_remap_enabled = CreateClientConVar("cl_fov_remap_enabled", 1, true, false, "Enable FOV Remap?")

--- cvar callbacks
local function UpdateVMFOV()
    if cl_fov_remap_vm_fixed:GetBool() or not cl_fov_remap_enabled:GetBool() then
        RunConsoleCommand("viewmodel_fov", cl_fov_remap_vm:GetFloat())
        return
    end
    -- since i had a stroke figuring out what i did here initially:
    -- - vm FOV is the same for any value of fov_desired
    -- - CalcView ruins this by modifying the fov of the player camera AND the viewmodel
    -- which means we'll:
    -- 1. get fov_desired
    -- 2. subtract that from our own desired FOV (say, we get 110 - 90 = 20 for an fov_desired of 90)
    -- 3. subtract THAT from the base vm FOV
    -- 4. set the viewmodel FOV to the result
    -- the formula used below is simplified
    RunConsoleCommand("viewmodel_fov", cl_fov_remap_vm:GetFloat() - cl_fov_remap_desired:GetFloat() + fov_desired:GetFloat())
end
cvars.AddChangeCallback("cl_fov_remap_vm", UpdateVMFOV, "FOVRemap.UpdateVMFOV")
cvars.AddChangeCallback("cl_fov_remap_vm_fixed", UpdateVMFOV, "FOVRemap.UpdateVMFOV")
cvars.AddChangeCallback("cl_fov_remap_desired", UpdateVMFOV, "FOVRemap.UpdateVMFOV")

-- calculation
local MinVanillaFOV = 20 -- we want zooming for example to be left alone and still be a "zoomed in" FOV
local function CalcFOV(fov)
    return math.Remap(fov, MinVanillaFOV, fov_desired:GetFloat(), MinVanillaFOV, cl_fov_remap_desired:GetFloat())
end

--- hook logic
local running = false
local function CalcView(ply, pos, angles, fov, ...)
    if running then return end -- don't want to go in a loop

    if IsValid(ply:GetVehicle()) and ply:GetVehicle():GetThirdPersonMode() then return end -- don't want vehicle tp to be affected by this
    if IsValid(ply:GetObserverTarget()) then return end -- don't want spectating to affect this
    if IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() == "gmod_camera" then return end -- don't want to affect gmod camera FOV
    
    running = true
    
    -- the following statements can be rearranged and modified
    -- ... if this hook should modify vanilla FOV, not custom FOV
    local t = hook.Run("CalcView", ply, pos, angles, fov, ...) or {
        origin = pos
    }
    t.fov = CalcFOV(t.fov or fov)

    running = false

    return t
end

-- this has to be at the end, else hook.Add(...) receives nil!
if cl_fov_remap_enabled:GetBool() then
    UpdateVMFOV()
    hook.Add("CalcView", "FOVRemap.CalcView", CalcView)
end
cvars.AddChangeCallback("cl_fov_remap_enabled", function ()
    UpdateVMFOV()
    if cl_fov_remap_enabled:GetBool() then
        hook.Add("CalcView", "FOVRemap.CalcView", CalcView)
    else
        hook.Remove("CalcView", "FOVRemap.CalcView")
    end
end, "FOVRemap.EnabledCallback")
