local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/qwrt5589/BHJB/de6f3075dcbbf696d615b647d1b675f05aef4395/%E8%BE%B0ui.txt"))()

local rainbowBorderAnimation
local currentBorderColorScheme = "彩虹颜色"
local animationSpeed = 2
local borderEnabled = true
local borderInitialized = false

local COLOR_SCHEMES = {
    ["彩虹颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FF0000")),ColorSequenceKeypoint.new(0.16, Color3.fromHex("FFA500")),ColorSequenceKeypoint.new(0.33, Color3.fromHex("FFFF00")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("00FF00")),ColorSequenceKeypoint.new(0.66, Color3.fromHex("0000FF")),ColorSequenceKeypoint.new(0.83, Color3.fromHex("4B0082")),ColorSequenceKeypoint.new(1, Color3.fromHex("EE82EE"))}),"palette"},
    ["黑红颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("000000")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("FF0000")),ColorSequenceKeypoint.new(1, Color3.fromHex("000000"))}),"alert-triangle"},
    ["蓝白颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FFFFFF")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("1E90FF")),ColorSequenceKeypoint.new(1, Color3.fromHex("FFFFFF"))}),"droplet"},
    ["紫金颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FFD700")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("8A2BE2")),ColorSequenceKeypoint.new(1, Color3.fromHex("FFD700"))}),"crown"},
    ["蓝黑颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("000000")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("0000FF")),ColorSequenceKeypoint.new(1, Color3.fromHex("000000"))}),"moon"},
    ["绿紫颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("00FF00")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("800080")),ColorSequenceKeypoint.new(1, Color3.fromHex("00FF00"))}),"zap"},
    ["粉蓝颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FF69B4")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("00BFFF")),ColorSequenceKeypoint.new(1, Color3.fromHex("FF69B4"))}),"heart"},
    ["橙青颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FF4500")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("00CED1")),ColorSequenceKeypoint.new(1, Color3.fromHex("FF4500"))}),"sun"},
    ["红金颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FF0000")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("FFD700")),ColorSequenceKeypoint.new(1, Color3.fromHex("FF0000"))}),"award"},
    ["银蓝颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("C0C0C0")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("4682B4")),ColorSequenceKeypoint.new(1, Color3.fromHex("C0C0C0"))}),"star"},
    ["霓虹颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FF00FF")),ColorSequenceKeypoint.new(0.25, Color3.fromHex("00FFFF")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("FFFF00")),ColorSequenceKeypoint.new(0.75, Color3.fromHex("FF00FF")),ColorSequenceKeypoint.new(1, Color3.fromHex("00FFFF"))}),"sparkles"},
    ["森林颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("228B22")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("32CD32")),ColorSequenceKeypoint.new(1, Color3.fromHex("228B22"))}),"tree"},
    ["火焰颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FF4500")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("FF0000")),ColorSequenceKeypoint.new(1, Color3.fromHex("FF8C00"))}),"flame"},
    ["海洋颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("000080")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("1E90FF")),ColorSequenceKeypoint.new(1, Color3.fromHex("00BFFF"))}),"waves"},
    ["日落颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FF4500")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("FF8C00")),ColorSequenceKeypoint.new(1, Color3.fromHex("FFD700"))}),"sunset"},
    ["银河颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("4B0082")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("8A2BE2")),ColorSequenceKeypoint.new(1, Color3.fromHex("9370DB"))}),"galaxy"},
    ["糖果颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FF69B4")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("FF1493")),ColorSequenceKeypoint.new(1, Color3.fromHex("FFB6C1"))}),"candy"},
    ["金属颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("C0C0C0")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("A9A9A9")),ColorSequenceKeypoint.new(1, Color3.fromHex("696969"))}),"shield"}
}

local function createRainbowBorder(window, colorScheme, speed)
    if not window or not window.UIElements then
        wait(1)
        if not window or not window.UIElements then
            return nil, nil
        end
    end
    
    local mainFrame = window.UIElements.Main
    if not mainFrame then
        return nil, nil
    end
    
    local existingStroke = mainFrame:FindFirstChild("RainbowStroke")
    if existingStroke then
        local glowEffect = existingStroke:FindFirstChild("GlowEffect")
        if glowEffect then
            local schemeData = COLOR_SCHEMES[colorScheme or currentBorderColorScheme]
            if schemeData then
                glowEffect.Color = schemeData[1]
            end
        end
        return existingStroke, rainbowBorderAnimation
    end
    
    if not mainFrame:FindFirstChildOfClass("UICorner") then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 16)
        corner.Parent = mainFrame
    end
    
    local rainbowStroke = Instance.new("UIStroke")
    rainbowStroke.Name = "RainbowStroke"
    rainbowStroke.Thickness = 1.5
    rainbowStroke.Color = Color3.new(1, 1, 1)
    rainbowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    rainbowStroke.LineJoinMode = Enum.LineJoinMode.Round
    rainbowStroke.Enabled = borderEnabled
    rainbowStroke.Parent = mainFrame
    
    local glowEffect = Instance.new("UIGradient")
    glowEffect.Name = "GlowEffect"
    
    local schemeData = COLOR_SCHEMES[colorScheme or currentBorderColorScheme]
    if schemeData then
        glowEffect.Color = schemeData[1]
    else
        glowEffect.Color = COLOR_SCHEMES["彩虹颜色"][1]
    end
    
    glowEffect.Rotation = 0
    glowEffect.Parent = rainbowStroke
    
    return rainbowStroke, nil
end

local function startBorderAnimation(window, speed)
    if not window or not window.UIElements then
        return nil
    end
    
    local mainFrame = window.UIElements.Main
    if not mainFrame then
        return nil
    end
    
    local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
    if not rainbowStroke or not rainbowStroke.Enabled then
        return nil
    end
    
    local glowEffect = rainbowStroke:FindFirstChild("GlowEffect")
    if not glowEffect then
        return nil
    end
    
    if rainbowBorderAnimation then
        rainbowBorderAnimation:Disconnect()
        rainbowBorderAnimation = nil
    end
    
    local animation
    animation = game:GetService("RunService").Heartbeat:Connect(function()
        if not rainbowStroke or rainbowStroke.Parent == nil or not rainbowStroke.Enabled then
            animation:Disconnect()
            return
        end
        
        local time = tick()
        glowEffect.Rotation = (time * speed * 60) % 360
    end)
    
    rainbowBorderAnimation = animation
    return animation
end

local function initializeRainbowBorder(scheme, speed)
    speed = speed or animationSpeed
    
    local rainbowStroke, _ = createRainbowBorder(Window, scheme, speed)
    if rainbowStroke then
        if borderEnabled then
            startBorderAnimation(Window, speed)
        end
        borderInitialized = true
        return true
    end
    return false
end

local function playSound()
    pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://9047002353"
        sound.Volume = 0.3
        sound.Parent = game:GetService("SoundService")
        sound:Play()
        game:GetService("Debris"):AddItem(sound, 2)
    end)
end

local Window = WindUI:CreateWindow({
    Title = "<font color='#FFA500'>辰脚本</font><font color='#FFFF00'>路西法</font>",
    IconTransparency = 0.5,
    IconThemed = true,
    Author = "作者:路西法",
    Folder = "辰脚本",
    Size = UDim2.fromOffset(580, 200),
    Transparent = true,
    Theme = "Dark",
    User = {
        Enabled = true,
        Callback = function() print("用户信息") end,
        Anonymous = false
    },
})


spawn(function()
    wait(0.5)
    initializeRainbowBorder("彩虹颜色", animationSpeed)
end)

Window:Tag({
    Title = "QQ;1693323219",
    Color = Color3.fromHex("#FFA500")
})

Window:Tag({
    Title = "辰脚本",
    Color = Color3.fromHex("#0000FF")
})

local TimeTag = Window:Tag({
    Title = "作者路西法",
    Color = Color3.fromHex("#800080")
})

WindUI:Notify({
    Title = "<font color='#008000'>不⭕钱</font>",
    Content = "<font color='#00FFFF'>带给你快乐的脚本</font>",
    Duration = 10,
    Icon = "bird",
})


local SettingsTab = Window:Tab({
    Title = "边框设置",
    Icon = "palette",
    Locked = false,
})

SettingsTab:Toggle({
    Title = "启用边框",
    Desc = "开关霓虹灯边框效果",
    Default = borderEnabled,
    Callback = function(value)
        borderEnabled = value
        local mainFrame = Window.UIElements and Window.UIElements.Main
        if mainFrame then
            local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
            if rainbowStroke then
                rainbowStroke.Enabled = value
                if value and not rainbowBorderAnimation then
                    startBorderAnimation(Window, animationSpeed)
                elseif not value and rainbowBorderAnimation then
                    rainbowBorderAnimation:Disconnect()
                    rainbowBorderAnimation = nil
                end
                
                WindUI:Notify({
                    Title = "边框",
                    Content = value and "已启用" or "已禁用",
                    Duration = 2,
                    Icon = value and "eye" or "eye-off"
                })
            end
        end
    end
})

local colorSchemeNames = {}
for name, _ in pairs(COLOR_SCHEMES) do
    table.insert(colorSchemeNames, name)
end
table.sort(colorSchemeNames)

SettingsTab:Dropdown({
    Title = "边框颜色",
    Desc = "选择喜欢的颜色组合",
    Values = colorSchemeNames,
    Value = "彩虹颜色",
    Callback = function(value)
        currentBorderColorScheme = value
        local success = initializeRainbowBorder(value, animationSpeed)
        playSound()
    end
})

SettingsTab:Slider({
    Title = "边框转动速度",
    Desc = "调整边框旋转的快慢",
    Value = { 
        Min = 1,
        Max = 10,
        Default = 5,
    },
    Callback = function(value)
        animationSpeed = value
        if rainbowBorderAnimation then
            rainbowBorderAnimation:Disconnect()
            rainbowBorderAnimation = nil
        end
        if borderEnabled then
            startBorderAnimation(Window, animationSpeed)
        end
        playSound()
    end
})

SettingsTab:Slider({
    Title = "边框粗细",
    Desc = "调整边框的粗细",
    Value = { 
        Min = 1,
        Max = 5,
        Default = 1.5,
    },
    Step = 0.5,
    Callback = function(value)
        local mainFrame = Window.UIElements and Window.UIElements.Main
        if mainFrame then
            local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
            if rainbowStroke then
                rainbowStroke.Thickness = value
            end
        end
        playSound()
    end
})

SettingsTab:Slider({
    Title = "圆角大小",
    Desc = "调整UI圆角的大小",
    Value = { 
        Min = 0,
        Max = 20,
        Default = 16,
    },
    Callback = function(value)
        local mainFrame = Window.UIElements and Window.UIElements.Main
        if mainFrame then
            local corner = mainFrame:FindFirstChildOfClass("UICorner")
            if not corner then
                corner = Instance.new("UICorner")
                corner.Parent = mainFrame
            end
            corner.CornerRadius = UDim.new(0, value)
        end
        playSound()
    end
})

SettingsTab:Button({
    Title = "随机颜色",
    Icon = "palette",
    Callback = function()
        local randomColor = colorSchemeNames[math.random(1, #colorSchemeNames)]
        currentBorderColorScheme = randomColor
        initializeRainbowBorder(randomColor, animationSpeed)
        playSound()
    end
})


Window:OnClose(function()
    if rainbowBorderAnimation then
        rainbowBorderAnimation:Disconnect()
        rainbowBorderAnimation = nil
    end
end)

Window:OnDestroy(function()
    if rainbowBorderAnimation then
        rainbowBorderAnimation:Disconnect()
        rainbowBorderAnimation = nil
    end
end)

local Tab = Window:Tab({
    Title = "公告",
    Icon = "layout-grid",
    Locked = false,
})

local Paragraph = Tab:Paragraph({
    Title = "欢迎使用",
    Desc = "希望能给你带来快乐",    
    Thumbnail = "rbxassetid://72368339506794",
    ThumbnailSize = 0,
})

local Paragraph = Tab:Paragraph({
    Title = "永不⭕钱",
    Desc = "作者：路西法",    
    Thumbnail = "rbxassetid://72368339506794",
    ThumbnailSize = 0,
})


local Tabs = {
    Main = Window:Section({ Title = "脚本", Opened = true }),
    Settings = Window:Section({ Title = "作者:路西法", Opened = true }),
    Utilities = Window:Section({ Title = "QQ1693323219", Opened = true })
}

local Tab = Tabs.Main:Tab({
    Title = "功能",
    Icon = "settings",
    Locked = false,
})

local Slider = Tab:Slider({
    Title = "售卖要求最低背包数量",
    Value = {
        Min = 0,
        Max = math.huge,
        Default = 50
    },
    Callback = function(value)
        MaxFruits = value
    end
})

local Toggle = Tab:Toggle({
    Title = "自动收集加售卖",
    Default = false,
    Callback = function(state)
        AutoCollectAndSell = state
        task.spawn(function()
            while task.wait(1) and AutoCollectAndSell do
                pcall(function()
                    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        if #game.Players.LocalPlayer.Backpack:GetChildren() > MaxFruits then
                            local oldpos = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.NPCS["Sell Stands"]["Shop Stand"].CFrame* CFrame.new(0, 0, 3)
                            wait(0.5)
                            game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("Sell_Inventory"):FireServer()
                            wait(1)
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldpos
                        end
                        for _, plot in pairs(workspace.Farm:GetChildren()) do
                            local important = plot:FindFirstChild("Important") or plot:FindFirstChild("Importanert")
                            if important and important:FindFirstChild("Data") and important.Data:FindFirstChild("Owner") then
                                if important.Data.Owner.Value == game.Players.LocalPlayer.Name then
                                    for _, prompt in ipairs(plot.Important.Plants_Physical:GetDescendants()) do
                                        if prompt:IsA("ProximityPrompt") then
                                            prompt.MaxActivationDistance = math.huge
                                            fireproximityprompt(prompt)
                                        end
                                    end
                                    break
                                end
                            end
                        end
                    end
                end)
            end
        end)
    end
})

local Toggle = Tab:Toggle({
    Title = "自动收集",
    Default = false,
    Callback = function(state)
        AutoCollect = state
        task.spawn(function()
            while task.wait(1) and AutoCollect do
                pcall(function()
                    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        for _, plot in pairs(workspace.Farm:GetChildren()) do
                            local important = plot:FindFirstChild("Important") or plot:FindFirstChild("Importanert")
                            if important and important:FindFirstChild("Data") and important.Data:FindFirstChild("Owner") then
                                if important.Data.Owner.Value == game.Players.LocalPlayer.Name then
                                    for _, prompt in ipairs(plot.Important.Plants_Physical:GetDescendants()) do
                                        if prompt:IsA("ProximityPrompt") then
                                            prompt.MaxActivationDistance = math.huge
                                            fireproximityprompt(prompt)
                                        end
                                    end
                                    break
                                end
                            end
                        end
                    end
                end)
            end
        end)
    end
})

local Toggle = Tab:Toggle({
    Title = "自动收集2.0",
    Default = false,
    Callback = function(state)
        AutoCollect = state
        task.spawn(function()
            while task.wait(1) and AutoCollect do
                pcall(function()
                    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        for _, plot in pairs(workspace.Farm:GetChildren()) do
                            local important = plot:FindFirstChild("Important") or plot:FindFirstChild("Importanert")
                            if important and important:FindFirstChild("Data") and important.Data:FindFirstChild("Owner") then
                                if important.Data.Owner.Value == game.Players.LocalPlayer.Name then
                                    for _, prompt in ipairs(plot.Important.Plants_Physical:GetDescendants()) do
                                        if prompt:IsA("ProximityPrompt") then
                                            game.Players.LocalPlayer.Character.Humanoid:MoveTo(prompt.Parent.Position)
                                            prompt.MaxActivationDistance = math.huge
                                            fireproximityprompt(prompt)
                                        end
                                    end
                                    break
                                end
                            end
                        end
                    end
                end)
            end
        end)
    end
})

local Toggle = Tab:Toggle({
    Title = "自动售卖",
    Default = false,
    Callback = function(state)
        AutoSell = state
        task.spawn(function()
            while task.wait(1) and AutoSell do
                pcall(function()
                    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        if #game.Players.LocalPlayer.Backpack:GetChildren() > MaxFruits then
                            local oldpos = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.NPCS["Sell Stands"]["Shop Stand"].CFrame* CFrame.new(0, 0, 3)
                            wait(0.5)
                            game:GetService("ReplicatedStorage").GameEvents.Sell_Item:FireServer()
                            game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("Sell_Inventory"):FireServer()
                            wait(1)
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldpos
                        end
                    end
                end)
            end
        end)
    end
})

local Toggle = Tab:Toggle({
    Title = "自动种植",
    Default = false,
    Callback = function(state)
        AutoPlant = state
        task.spawn(function()
            while task.wait(1) and AutoPlant do
                pcall(function()
                    if game.Players.LocalPlayer.Character.HumanoidRootPart then
                        local seedType, tool
                        for _, item in ipairs(game.Players.LocalPlayer.Character:GetChildren()) do
                            if item:IsA("Tool") and item.Name:find("Seed") then
                                seedType = item.Name:match("^(.-) Seed")
                                tool = item
                                break
                            end
                        end
                        if not tool then
                            for _, item in ipairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                                if item:IsA("Tool") and item.Name:find("Seed") then
                                    seedType = item.Name:match("^(.-) Seed")
                                    tool = item
                                    break
                                end
                            end
                        end
                        if tool and seedType then
                            if tool.Parent == game.Players.LocalPlayer.Backpack then
                                game.Players.LocalPlayer.Character:WaitForChild("Humanoid"):EquipTool(tool)
                                repeat task.wait() until tool.Parent == game.Players.LocalPlayer.Character
                            end
                            game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("Plant_RE"):FireServer(Vector3.new(math.floor(game.Players.LocalPlayer.Character.HumanoidRootPart.Position.X), 0.1, math.floor(game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Z)), seedType)
                        end
                    end
                end)
            end
        end)
    end
})

local Toggle = Tab:Toggle({
    Title = "显示种子刷新时间",
    Default = false,
    Callback = function(state)
        local TimeGui = game.CoreGui:FindFirstChild("TimeGui")
        if not TimeGui then
            TimeGui = Instance.new("ScreenGui")
            TimeGui.Name = "TimeGui"
            TimeGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            TimeGui.Parent = game.CoreGui

            local TimeLabel = Instance.new("TextLabel")
            TimeLabel.Name = "TimeLabel"
            TimeLabel.BackgroundColor3 = Color3.new(1, 1, 1)
            TimeLabel.BackgroundTransparency = 1
            TimeLabel.BorderColor3 = Color3.new(0, 0, 0)
            TimeLabel.Position = UDim2.new(0.80, 0, 0.00090, 0)
            TimeLabel.Size = UDim2.new(0, 135, 0, 50)
            TimeLabel.Font = Enum.Font.GothamSemibold
            TimeLabel.Text = "种子下次更新时间: " .. game:GetService("Players").LocalPlayer.PlayerGui.Seed_Shop.Frame.Frame.Timer.Text
            TimeLabel.TextColor3 = Color3.new(1, 1, 1)
            TimeLabel.TextScaled = true
            TimeLabel.TextSize = 14
            TimeLabel.TextWrapped = true
            TimeLabel.Parent = TimeGui

            local UIGradient = Instance.new("UIGradient")
            UIGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
                ColorSequenceKeypoint.new(0.10, Color3.fromRGB(255, 127, 0)),
                ColorSequenceKeypoint.new(0.20, Color3.fromRGB(255, 255, 0)),
                ColorSequenceKeypoint.new(0.30, Color3.fromRGB(0, 255, 0)),
                ColorSequenceKeypoint.new(0.40, Color3.fromRGB(0, 255, 255)),
                ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 0, 255)),
                ColorSequenceKeypoint.new(0.60, Color3.fromRGB(139, 0, 255)),
                ColorSequenceKeypoint.new(0.70, Color3.fromRGB(255, 0, 0)),
                ColorSequenceKeypoint.new(0.80, Color3.fromRGB(255, 127, 0)),
                ColorSequenceKeypoint.new(0.90, Color3.fromRGB(255, 255, 0)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 255, 0))
            }
            UIGradient.Rotation = 360
            UIGradient.Parent = TimeLabel
        end
        TimeGui.Enabled = state
        TimeGui.TimeLabel.Visible = state

        local TweenService = game:GetService("TweenService")
        local tweeninfo = TweenInfo.new(7, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1)
        local tween = TweenService:Create(TimeGui.TimeLabel.UIGradient, tweeninfo, {Rotation = 360})
        tween:Play()

        if state then
            game:GetService("RunService").RenderStepped:Connect(function()
                TimeGui.TimeLabel.Text = "时间: " .. game:GetService("Players").LocalPlayer.PlayerGui.Seed_Shop.Frame.Frame.Timer.Text
            end)
        end
    end
})

local selectedSeed
local Dropdown = Tab:Dropdown({
    Title = "选择种子",
    Desc = "请选择要购买的种子",
    Values = {"Carrot","Strawberry","Blueberry","Orange Tulip","Tomato","Corn","Daffodil","Watermelon","Pumpkin","Apple","Bamboo","Coconut","Cactus","Dragon Fruit","Mango","Grape"},
    Callback = function(value)
        selectedSeed = value
    end
})

local Toggle = Tab:Toggle({
    Title = "自动购买种子",
    Default = false,
    Callback = function(state)
        AutoBuySeeds = state
        task.spawn(function()
            while task.wait(0.2) and AutoBuySeeds do
                pcall(function()
                    game:GetService("ReplicatedStorage").GameEvents.BuySeedStock:FireServer(selectedSeed)
                end)
            end
        end)
    end
})

local Button = Tab:Button({
    Title = "购买种子",
    Callback = function()
        game:GetService("ReplicatedStorage").GameEvents.BuySeedStock:FireServer(selectedSeed)
    end
})

local Toggle = Tab:Toggle({
    Title = "自动购买水壶",
    Default = false,
    Callback = function(state)
        AutoBuyWateringCan = state
        task.spawn(function()
            while task.wait(1) and AutoBuyWateringCan do
                pcall(function()
                    game:GetService("ReplicatedStorage").GameEvents.BuyGearStock:FireServer("Watering Can")
                end)
            end
        end)
    end
})
