local FLSanity = {}
	
	function FLSanity.FLRemove(plr, target)
		plr.Backpack:FindFirstChild("Flashlight").Parent = game.ReplicatedStorage.Tools.UsedLights
		plr.Backpack.tags.Value += 1
		wait(1)
		local newSeeker = game.Players:GetPlayerFromCharacter(target.Parent)
		newSeeker.CharacterAdded:Wait()
		FLSanity.FLAdd(newSeeker)
        return
	end

	function FLSanity.FLAdd(plr)
		game.ReplicatedStorage.Tools.UsedLights:WaitForChild("Flashlight").Parent = plr.Backpack
		plr.Character:WaitForChild("Humanoid").WalkSpeed = 30
		plr.Backpack.seekerVal.Value = true
        return
	end

    function FLSanity.FLSanity()
        local playerList = game.Players:GetPlayers()

        for i in ipairs(playerList) do
            local plr = i:GetPlayerFromCharacter()
            local pack = plr.Backpack:GetChildren()

            for v in ipairs(pack) do
                if v.Name == "Flashlight" then
                    print("Flashlight found on " .. plr.Name)
                    return
                end
            end
        end
        print("Flashlight not found")
        FLSanity.FLSeeker(playerList)
        return
    end

return FLSanity
