local hideFuncs = {}

--Begin the hide process (linked to proxprompt in specific spot)
function hideFuncs.Hide(plr, spot)
	
	-- Variable Declaration
	local hideVal, hideCooldown, charChild, seekerVal = plr.Backpack:WaitForChild("HidingVal"), plr.Backpack:WaitForChild("HideCooldown"), plr.Character:GetChildren(), plr.Backpack:WaitForChild("seekerVal")
	
	--Boolean for hiding players. If value is true they cannot be tagged.
	hideVal.Value = true
	
	--Conditional for checking if a player engaged hiding, is not in hiding, is not the seeker, and there is not a player already hiding in selected spot
	if hideVal.Value == true and hideCooldown.Value == false and seekerVal.Value == false then
        if spot.hidingPlayerBool.Value == false then
		    print("Conditional Passed") -- testing
		    spot.hidingPlayerBool.Value = true  --Hiding player value updated to prevent others from hiding in the same spot
		
		    --Definition of players position before hiding (for future use)
		    currPosition = plr.Character:WaitForChild("HumanoidRootPart").CFrame
		
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
            hideFuncs.CountStart(plr, spot, currPosition, humWalk)

	    end
        -- Returns that signal if the module failed (Checked in prox prompt script)
        -- Example 1: Returns to player GUI that there is a player hiding in that spot.
        -- Example 2: Returns an error report to server and prints into output (Testing only)
        return 1
    end
    return 2
end

function hideFuncs.HideEnd(plr, spot, origPosition, humWalk)
    local GUI2, button, hidingPlayerName, hidingPlayerBool = plr.PlayerGui.hideGUI.HidingLabel, plr.PlayerGui.hideGUI.HidingLabel.TextButton, spot.hidingPlayerName, spot.hidingPlayerBool
    local hideVal, charChild = plr.Backpack.HidingVal, plr.Character:GetChildren()
    GUI2.Visible = false
	button.Visible = false

    --Resets walkspeed and player location
	plr.Character:WaitForChild("Humanoid").WalkSpeed = humWalk
	plr.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(origPosition)

    --Sanity check for hiding player, For loop to remove transparency from player
	if plr.Name == hidingPlayerName then
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
    hidingPlayerBool.Value = false
    hidingPlayerName.Value = nil
end



function hideFuncs.CountStart(plr, spot, origPosition, humWalk)
    	-- hiding countdown
        -- DEV TEST: Does for loop break when hideEnd() is called??
	for i = 30, 1, -1 do
		local GUI2, button = plr.PlayerGui.hideGUI.HidingLabel, plr.PlayerGui.hideGUI.HidingLabel.TextButton
		button.Activated:Connect(hideFuncs.HideEnd(plr, spot, origPosition, humWalk))			
		GUI2.Visible = true
		button.Visible = true
		GUI2.Text = "Hiding for: \n" .. i
		wait(1)
		GUI2.Visible = false
		button.Visible = false
	end
    hideFuncs.HideEnd(plr, spot, origPosition, humWalk)
end

return hideFuncs