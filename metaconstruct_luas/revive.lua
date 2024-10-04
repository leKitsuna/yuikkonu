timer.Create("Detect LocalPlayerDie", 1, 0, function()
	if IsValid(LocalPlayer()) and LocalPlayer():Alive() then return end
	RunConsoleCommand("chatsounds_say", "lead pipe")
	RunConsoleCommand("aowl", "revive")
end)