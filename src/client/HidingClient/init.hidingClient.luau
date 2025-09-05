--FIX ME: Countdowns periodically continue after client clicks button to leave spot

local hideEvent, hideEndEvent, plr, activated = game.ReplicatedStorage.Events.HideEvent, game.ReplicatedStorage.Events.HideEndEvent, game.Players.LocalPlayer, game.Players.LocalPlayer.PlayerGui:WaitForChild("hideGUI").HidingLabel.TextButton.buttonActivated

hideEvent.OnClientEvent:Connect(function(humWalk, location, hidingPlayer)-- event listener from hidingprompt
	
	-- hiding countdown
	for i = 30, 1, -1 do
		local GUI2, button = plr.PlayerGui.hideGUI.HidingLabel, plr.PlayerGui.hideGUI.HidingLabel.TextButton
		button.Activated:Connect(function()
			hideEndEvent:FireServer(plr)
			GUI2.Visible = false
			button.Visible = false
		end)
		if button.buttonActivated.Value == true then
			break
		end
			
		GUI2.Visible = true
		button.Visible = true
		GUI2.Text = "Hiding for: \n" .. i
		wait(1)
		GUI2.Visible = false
		button.Visible = false
	end
	
	--fires event for end of hiding
	hideEndEvent:FireServer(plr)
end)