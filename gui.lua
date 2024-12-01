local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "DengerNetwork | Apocalypse Rising 2",
    Icon = 0,
    LoadingTitle = "DengerNetwork",
    LoadingSubtitle = "by d3gr",
    Theme = "Default",

    ConfigurationSaving = {
        Enabled = false,
        FolderName = nil,
        FileName = "DengerNetwork"
    },

    KeySystem = true,
    KeySettings = {
        Title = "DengerNetwork | Key",
        Subtitle = "Developer Version",
        Note = "Can only be obtained from d3gr.",
        FileName = "Key",
        SaveKey = false,
        GrabKeyFromSite = false,
        Key = {"d3grisalpha"}
    }
})

local MainTab = Window:CreateTab("Main", nil)
local MainSection = MainTab:CreateSection("Visuals")

-- ESP Scripts
local tracersEnabled = false

local function enableESP()
    local RunService = game:GetService("RunService")
    local CoreGui = game:GetService("CoreGui")
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local camera = game.Workspace.CurrentCamera
    local lootBinsFolder = game.Workspace.Map.Shared.LootBins

    -- Create tracer line
    local function createTracer(crashsite)
        local line = Drawing.new("Line")
        line.Visible = false
        line.From = Vector2.new(0, 0)
        line.To = Vector2.new(0, 0)
        line.Color = Color3.fromRGB(255, 255, 255) -- White color for the tracer
        line.Thickness = 2
        line.Transparency = 1 -- Fully visible

        -- Update the tracer on each render step
        RunService.RenderStepped:Connect(function()
            if tracersEnabled then -- Only show tracers if enabled
                local pos, vis = camera:WorldToViewportPoint(crashsite.Position)
                if vis then
                    line.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2) -- center of screen
                    line.To = Vector2.new(pos.X, pos.Y) -- target position (crash site)
                    line.Visible = true
                else
                    line.Visible = false
                end
            else
                line.Visible = false -- Hide the tracer if tracers are disabled
            end
        end)
    end

    -- Function to create ESP for a folder
    local function createFolderESP(folder)
        local targetPart = nil
        for _, groupFolder in pairs(folder:GetChildren()) do
            if groupFolder:IsA("Folder") and groupFolder.Name == "Group" then
                for _, part in pairs(groupFolder:GetChildren()) do
                    if part:IsA("BasePart") then
                        targetPart = part
                        break
                    end
                end
                if targetPart then break end
            end
        end

        if not targetPart then return end

        -- Highlight ESP
        local highlight = Instance.new("Highlight")
        highlight.Adornee = targetPart
        highlight.FillColor = Color3.fromRGB(0, 255, 0)
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineTransparency = 0
        highlight.Parent = CoreGui

        -- Create Tracer for this folder (if it has a BasePart)
        createTracer(targetPart)

        -- Billboard GUI ESP (Optional)
        local billboard = Instance.new("BillboardGui")
        billboard.Adornee = targetPart
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.MaxDistance = math.huge
        billboard.Parent = CoreGui

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextScaled = true
        label.Font = Enum.Font.SourceSansBold
        label.TextStrokeTransparency = 0.5
        label.Parent = billboard

        RunService.RenderStepped:Connect(function()
            if targetPart and targetPart:IsDescendantOf(game.Workspace) then
                local distance = (player.Character.HumanoidRootPart.Position - targetPart.Position).Magnitude
                label.Text = string.format("%s\n%.2f studs", folder.Name, distance)
            else
                billboard.Enabled = false
            end
        end)
    end

    -- Setup ESP for existing folders
    for _, folder in pairs(lootBinsFolder:GetChildren()) do
        if folder:IsA("Folder") and folder.Name:match("SeahawkCrashsite") and not folder.Name:match("Rogue") then
            createFolderESP(folder)
        end
    end

    -- Update ESP when new folders are added
    lootBinsFolder.ChildAdded:Connect(function(folder)
        wait(0.1)
        if folder:IsA("Folder") and folder.Name:match("SeahawkCrashsite") and not folder.Name:match("Rogue") then
            createFolderESP(folder)
        end
    end)
end

local function disableESP()
    local CoreGui = game:GetService("CoreGui")
    for _, child in pairs(CoreGui:GetChildren()) do
        if child:IsA("Highlight") or child:IsA("BillboardGui") then
            child:Destroy()
        end
    end
    print("ESP turned off")
end

-- Create the toggle for ESP
local ToggleESP = MainTab:CreateToggle({
    Name = "HeliCrash ESP",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        if Value then
            enableESP() -- Turns on the ESP
        else
            disableESP() -- Turns off the ESP
        end
    end,
})

-- Create the toggle for Tracers
local ToggleTracers = MainTab:CreateToggle({
    Name = "HeliCrash Tracers",
    CurrentValue = false,
    Flag = "Toggle2",
    Callback = function(Value)
        tracersEnabled = Value -- Enable or disable tracers
    end,
})

-- Scripts tab for external scripts
local Tab = Window:CreateTab("Scripts", nil) -- Title, Image

-- RealZz Aimbot
Tab:CreateButton({
    Name = "RealZz Aimbot",
    Callback = function()
        loadstring(game:HttpGet("https://realzzhub.xyz/script.lua", true))()
    end
})

-- Unnamed ESP
Tab:CreateButton({
    Name = "Unnamed ESP",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/ic3w0lf22/Unnamed-ESP/master/UnnamedESP.lua', true))()
    end
})

-- Infinite Yield
Tab:CreateButton({
    Name = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end
})

-- Vital.wtf v4
Tab:CreateButton({
    Name = "vital.wtf | v4",
    Callback = function()
        loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/6faa356b7c76f8873c6f0bef2b7737e1.lua"))()
    end
})

-- Vital.wtf v5
Tab:CreateButton({
    Name = "vital.wtf | v5",
    Callback = function()
        loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/9a7b8f56a9c71e81ced3c6952379ce27.lua"))()
    end
})

local CreditsTab = Window:CreateTab("Credits", nil) -- Title, Image

-- Create a section for Credits
local CreditsSection = CreditsTab:CreateSection("Developer Info", "top") -- Title, Position

-- Add a label for Credits to d3gr
CreditsTab:CreateLabel("Credits to:")
local devLabel = CreditsTab:CreateLabel("d3ngr#0")
devLabel.TextColor3 = Color3.fromRGB(0, 255, 0) -- Green color for name
devLabel.TextSize = 16
devLabel.Font = Enum.Font.GothamBold
devLabel.TextStrokeTransparency = 0.7

-- Add a divider below the developer's name for separation
CreditsTab:CreateDivider()

local Section = CreditsTab:CreateSection("YOUTUBE")

-- Add a label for YouTube channel link and make it clickable
local youtubeLabel = CreditsTab:CreateLabel("YouTube Channel:")
youtubeLabel.TextSize = 14
youtubeLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- White color
youtubeLabel.Font = Enum.Font.Gotham
youtubeLabel.TextStrokeTransparency = 0.5

-- Create a TextButton that acts as a link to YouTube
local youtubeButton = CreditsTab:CreateButton({
    Name = "Visit Channel",
    Callback = function()
        -- Use the game:GetService("GuiService") to open the link in a browser.
        -- This works on Roblox Studio and should open the YouTube channel link.
        setclipboard("https://youtube.com/denger") -- Copy the link to clipboard as a workaround
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "YouTube Link Copied",
            Text = "YouTube channel link has been copied to your clipboard.",
            Duration = 3
        })
    end
})

local Divider = MainTab:CreateDivider()


local Section = MainTab:CreateSection("ESP")
-- Add a divider to separate sections

local tracersEnabled = false
local playerESPEnabled = false
local activeTracers = {}

local function enablePlayerESP()
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local CoreGui = game:GetService("CoreGui")
    local camera = game.Workspace.CurrentCamera
    local player = Players.LocalPlayer

    local function createPlayerESP(targetPlayer)
        local targetCharacter = targetPlayer.Character
        if not targetCharacter or not targetCharacter:FindFirstChild("HumanoidRootPart") then return end

        local highlight = Instance.new("Highlight")
        highlight.Adornee = targetCharacter.HumanoidRootPart
        highlight.FillColor = Color3.fromRGB(0, 0, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
        highlight.OutlineTransparency = 0
        highlight.Parent = CoreGui

        local billboard = Instance.new("BillboardGui")
        billboard.Adornee = targetCharacter.HumanoidRootPart
        billboard.Size = UDim2.new(0, 120, 0, 30)  -- Slightly bigger
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.MaxDistance = math.huge
        billboard.Parent = CoreGui

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextScaled = true
        label.Font = Enum.Font.SourceSansBold
        label.TextStrokeTransparency = 0.5
        label.Parent = billboard

        RunService.RenderStepped:Connect(function()
            if targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart") then
                local distance = (player.Character.HumanoidRootPart.Position - targetCharacter.HumanoidRootPart.Position).Magnitude
                label.Text = string.format("%s\n%.2f studs", targetPlayer.Name, distance)
            else
                billboard.Enabled = false
            end
        end)

        if tracersEnabled then
            local line = Drawing.new("Line")
            line.Visible = false
            line.From = Vector2.new(0, 0)
            line.To = Vector2.new(0, 0)
            line.Color = Color3.fromRGB(255, 255, 255)  -- White tracers
            line.Thickness = 2
            line.Transparency = 1
            activeTracers[targetPlayer] = line

            RunService.RenderStepped:Connect(function()
                if playerESPEnabled and tracersEnabled then
                    local pos, vis = camera:WorldToViewportPoint(targetCharacter.HumanoidRootPart.Position)
                    if vis then
                        line.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
                        line.To = Vector2.new(pos.X, pos.Y)
                        line.Visible = true
                    else
                        line.Visible = false
                    end
                else
                    line.Visible = false
                end
            end)
        end
    end

    for _, targetPlayer in pairs(Players:GetPlayers()) do
        if targetPlayer ~= player then
            createPlayerESP(targetPlayer)
        end
    end

    Players.PlayerAdded:Connect(function(targetPlayer)
        if targetPlayer ~= player then
            createPlayerESP(targetPlayer)
        end
    end)
end

local function disablePlayerESP()
    local CoreGui = game:GetService("CoreGui")
    for _, child in pairs(CoreGui:GetChildren()) do
        if child:IsA("Highlight") or child:IsA("BillboardGui") then
            child:Destroy()
        end
    end
    for _, tracer in pairs(activeTracers) do
        tracer.Visible = false
    end
    activeTracers = {}
    playerESPEnabled = false
    tracersEnabled = false
    print("Player ESP turned off")
end

local TogglePlayerESP = MainTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Flag = "Toggle3",
    Callback = function(Value)
        if Value then
            playerESPEnabled = true
            enablePlayerESP()
        else
            playerESPEnabled = false
            disablePlayerESP()
        end
    end,
})

local ToggleTracers = MainTab:CreateToggle({
    Name = "Player Tracers",
    CurrentValue = false,
    Flag = "Toggle4",
    Callback = function(Value)
        tracersEnabled = Value
        if not playerESPEnabled then
            for _, tracer in pairs(activeTracers) do
                tracer.Visible = false
            end
        end
    end,
})
