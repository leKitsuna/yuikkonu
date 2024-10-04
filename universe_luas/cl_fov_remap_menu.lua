
AddCSLuaFile()

-- i don't like writing UI code :(

--- panel logic
local fovPanel = nil

local function SetShowfovPanel(show)
    if not IsValid(fovPanel) then return end
    if show then
        fovPanel:Show()
        fovPanel:MakePopup()
    else fovPanel:Hide() end
end
local function CreatefovPanel()
    -- jerma panels
    fovPanel = vgui.Create("DFrame")
    fovPanel:SetSize(300, 100)
    fovPanel:SetTitle("#fovremap.ui.frame.fov.title")
    fovPanel:Center()

    local fovSlider = vgui.Create("DNumSlider", fovPanel)
    fovSlider:SetPos(10, 30)
    fovSlider:SetSize(280, 20)
    fovSlider:SetText("#fovremap.ui.numslider.fov.label")
    fovSlider:SetMin(20)
    fovSlider:SetMax(179)
    fovSlider:SetDecimals(1)
    fovSlider:SetConVar("cl_fov_remap_desired")

    local vmCheckbox = vgui.Create("DCheckBoxLabel", fovPanel)
	vmCheckbox:SetPos(10, 50)
	vmCheckbox:SetText("#fovremap.ui.checkbox.vmfixed.label")
	vmCheckbox:SetConVar("cl_fov_remap_vm_fixed")
	vmCheckbox:SizeToContents()
    vmCheckbox:SetValue(cvars.Bool("cl_fov_remap_vm_fixed"))

    local enabledCheckbox = vgui.Create("DCheckBoxLabel", fovPanel)
	enabledCheckbox:SetPos(10, 70)
	enabledCheckbox:SetText("#fovremap.ui.checkbox.enabled.label")
	enabledCheckbox:SetConVar("cl_fov_remap_enabled")
	enabledCheckbox:SizeToContents()
    enabledCheckbox:SetValue(cvars.Bool("cl_fov_remap_enabled"))

    SetShowfovPanel(false)
end

local function OpenFOVPanel()
    if not IsValid(fovPanel) then CreatefovPanel() end
    SetShowfovPanel(true)
end
local function CloseFOVPanel()
    SetShowfovPanel(false)
end
local function ToggleFOVPanel()
    if IsValid(fovPanel) and fovPanel:IsVisible() then
        CloseFOVPanel()
    else
        OpenFOVPanel()
    end
end

--- commands
concommand.Add("+fovpanel", OpenFOVPanel)
concommand.Add("-fovpanel", CloseFOVPanel)

concommand.Add("cl_fov_remap_toggle_panel", ToggleFOVPanel, nil, "Toggles the FOV panel.")
