
local player = game.Players.LocalPlayer
local pGui = player:WaitForChild("PlayerGui")
local folders = workspace:WaitForChild("GAMEFOLDERS")
local customersFolder = folders:WaitForChild("Customers"):WaitForChild("Alive")
local npcFolder = folders:WaitForChild("NPCs")
local meleeEvent = game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("MeleeHitEvent")


local isRunning = false


local targetNames = {
    ["Poor Customer"] = true,
    ["Normal Customer"] = true,
    ["Rich Customer"] = true,
    ["Gold Customer"] = true,
    ["Diamond Customer"] = true,
    ["Special Customer"] = true
}


local screenGui = Instance.new("ScreenGui", pGui)
screenGui.Name = "EliteFarmGUI"
screenGui.ResetOnSpawn = false 

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 220, 0, 120)
mainFrame.Position = UDim2.new(0.5, -110, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true 

local uiCorner = Instance.new("UICorner", mainFrame)
uiCorner.CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Kill All Made by: Midas93939"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 14

local startBtn = Instance.new("TextButton", mainFrame)
startBtn.Size = UDim2.new(0, 200, 0, 35)
startBtn.Position = UDim2.new(0, 10, 0, 35)
startBtn.Text = "START"
startBtn.Font = Enum.Font.SourceSansBold
startBtn.TextSize = 18
startBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
startBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", startBtn)

local stopBtn = Instance.new("TextButton", mainFrame)
stopBtn.Size = UDim2.new(0, 200, 0, 35)
stopBtn.Position = UDim2.new(0, 10, 0, 75)
stopBtn.Text = "STOP"
stopBtn.Font = Enum.Font.SourceSansBold
stopBtn.TextSize = 18
stopBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
stopBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", stopBtn)

local function runAttack()
    while isRunning do
        local targetsFound = false
        
        
        for _, npc in pairs(npcFolder:GetChildren()) do
            if not isRunning then break end
            if npc.Name == "Cop" and npc:FindFirstChild("HeadHitbox") then
                targetsFound = true
                local hitbox = npc.HeadHitbox
                
                -- Attacks based on the Cop's current position
                local copArgs = {
                    [1] = hitbox,
                    [2] = hitbox.Position,
                    [3] = Vector3.new(0.53, 0, -0.84),
                    [4] = 20
                }
                meleeEvent:FireServer(unpack(copArgs))
            end
        end

        
        for _, customer in pairs(customersFolder:GetChildren()) do
            if not isRunning then break end
            if targetNames[customer.Name] and customer:FindFirstChild("HumanoidRootPart") then
                targetsFound = true
                local root = customer.HumanoidRootPart
                
                local customerArgs = {
                    [1] = root,
                    [2] = root.Position,
                    [3] = Vector3.new(0, 0, 0),
                    [4] = 20
                }
                meleeEvent:FireServer(unpack(customerArgs))
            end
        end
        
        
        if not targetsFound then
            task.wait(0.5) -- Lower frequency when no enemies exist
        else
            task.wait(0.1) -- Attack speed (Increase for faster hits)
        end
    end
end


startBtn.MouseButton1Click:Connect(function()
    if not isRunning then
        isRunning = true
        startBtn.Text = "STATUS: ACTIVE"
        startBtn.BackgroundColor3 = Color3.fromRGB(39, 174, 96)
        task.spawn(runAttack)
    end
end)

stopBtn.MouseButton1Click:Connect(function()
    isRunning = false
    startBtn.Text = "START"
    startBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
end)
