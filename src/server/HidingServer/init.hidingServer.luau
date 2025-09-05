--FIX ME: Add graphical timers for countdowns on cooldown
--DEV IDEA: Lower time limit to 15 seconds???
--DEV IDEA: Keep speed in mind as pacing may be adjust to speed up gameplay. (MARKED WITH ***)
--DEV IDEA: Move to module script?? 

--Variables
local proxPrompt, hideEvent, hideEndEvent = script.Parent, game.ReplicatedStorage.Events.HideEvent,game.ReplicatedStorage.Events.HideEndEvent
local x
local y
local z
local hidingPlayer = nil

local connection = proxPrompt.Triggered:Connect(function(plr) --prox prompt trigger
	plr.PlayerGui.ScreenGui.HidingLabel.TextButton.buttonActivated.Value = false
	print("Trigger") --testing
	
	-- Variable Declaration
	local hideVal, hideCooldown, charChild, seekerVal = plr.Backpack:WaitForChild("HidingVal"), plr.Backpack:WaitForChild("HideCooldown"), plr.Character:GetChildren(), plr.Backpack:WaitForChild("seekerVal")
	
	--Boolean for hiding players. If value is true they cannot be tagged.
	hideVal.Value = true
	
	--Conditional for checking if a player engaged hiding, is not in hiding, is not the seeker, and there is not a player already hiding in selected spot
	if hideVal.Value == true and hideCooldown.Value == false and seekerVal.Value == false and hidingPlayer == nil then
		print("Conditional Passed") -- testing
		hidingPlayer = plr.Name  --Hiding player value updated to prevent others from hiding in the same spot
		
		--Definition of players position before hiding (for future use)
		x = plr.Character:WaitForChild("HumanoidRootPart").CFrame.X
		y = plr.Character:WaitForChild("HumanoidRootPart").CFrame.Y
		z = plr.Character:WaitForChild("HumanoidRootPart").CFrame.Z
		
		--Places player in hiding spot, sets walkspeed to 0, and sets player transparency to 1 (invisible)
		plr.Character:WaitForChild("HumanoidRootPart").CFrame = script.Parent.Parent.CFrame
		local humWalk = plr.Character:WaitForChild("Humanoid").WalkSpeed
		plr.Character:WaitForChild("Humanoid").WalkSpeed = 0
		for bodyPart in ipairs(charChild) do
			if charChild[bodyPart]:IsA("BasePart") then
				charChild[bodyPart].Transparency = 1
			elseif	charChild[bodyPart]:IsA("Accessory") then
				local handle = charChild[bodyPart]:WaitForChild("Handle")
				handle.Transparency = 1
			end
		end
		hideEvent:FireClient(plr) -- signals hidingClient for countdown
	end
end)



local connectionTwo = hideEndEvent.OnServerEvent:Connect(function(plr) --ending event for hiding signaled from hidingClient
	
	--Resets walkspeed and player location
	plr.Character:WaitForChild("Humanoid").WalkSpeed = 16
	plr.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(x, y, z)
	
	--variables
	local hideVal, hideCooldown, charChild, seekerVal = plr.Backpack.HidingVal, plr.Backpack.HideCooldown, plr.Character:GetChildren(), plr.Backpack.seekerVal
	
	--Sanity check for hiding player, For loop to remove transparency from player
	if plr.Name == hidingPlayer then
		hideVal.Value = false
		for bodyPart in ipairs(charChild) do
			if charChild[bodyPart]:IsA("BasePart") then
				charChild[bodyPart].Transparency = 0

			elseif charChild[bodyPart]:IsA("Accessory") then
				local handle = charChild[bodyPart]:WaitForChild("Handle")
				handle.Transparency = 0
			end
		end
	end

    --disconnect connection to hide
    connection:Disconnect()
	
	--resets hiding player value to allow others to hide in spot
	plr.PlayerGui.ScreenGui.HidingLabel.Visible = false
	plr.PlayerGui.ScreenGui.HidingLabel.TextButton.Visible = false
	plr.PlayerGui.ScreenGui.HidingLabel.TextButton.buttonActivated.Value = true
	hidingPlayer = nil
	
	--plr cooldown initiated
	hideCooldown.Value = true
	wait(15)
	hideCooldown.Value = false
	--player can hide again
end)

--Disconnect second connection to end hiding
--Possibly disconnecting before the end of hiding??
connectionTwo:Disconnect()