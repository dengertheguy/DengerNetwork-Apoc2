local Players = game:GetService("Players")
local player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Function to check if the player is "Dengerthepro"
local function isDeveloper(player)
    return player.Name == "Dengerthepro"
end

-- Commands system for the developer
if isDeveloper(player) then
    -- Function to kick a player
    local function kickPlayer(targetPlayerName)
        local targetPlayer = Players:FindFirstChild(targetPlayerName)
        if targetPlayer then
            targetPlayer:Kick("You have been kicked by the developer.")
            print(targetPlayerName .. " has been kicked!")
        else
            print("Player not found.")
        end
    end

    -- Function to send a message to the chat
    local function sendChatMessage(message)
        ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(message, "All")
    end

    -- Listen for chat messages
    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.OnMessageDoneFiltering.OnClientEvent:Connect(function(messageData)
        local message = messageData.Message
        local playerName = messageData.FromSpeaker
        
        -- Only allow commands if the player is "Dengerthepro"
        if playerName == "Dengerthepro" then
            -- Check for specific commands
            if message:sub(1, 5) == "!kick" then
                -- Extract player name from the command
                local targetPlayerName = message:sub(7)
                kickPlayer(targetPlayerName)
            elseif message:sub(1, 5) == "!say" then
                -- Extract message from the command
                local chatMessage = message:sub(6)
                sendChatMessage(chatMessage)
            end
        end
    end)
end
