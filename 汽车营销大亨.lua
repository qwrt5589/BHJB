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

local Toggle = Tab:Toggle({
    Title = "自动刷钱",
    Default = false,
    Callback = function(state)
        Auto = state
        task.spawn(function()
            while task.wait() do
                if not Auto then
                    break
                end
                local part = Instance.new("Part")
                part.Position = Vector3.new(0,60,0)
                part.Size = Vector3.new(1000,5,1000)
                part.Anchored = true
                part.Name = "Keaths Platform"
                part.CollisionGroupId = 5
                part.Parent = workspace

                local part2 = Instance.new("Part")
                part2.Position = Vector3.new(0,10,0)
                part2.Size = Vector3.new(1000,5,1000)
                part2.Anchored = true
                part2.Name = "Keaths Platform"
                part2.CollisionGroupId = 5
                part2.Parent = workspace

                local part3 = Instance.new("Part")
                part3.Position = Vector3.new(0,99,0)
                part3.Size = Vector3.new(1000,5,1000)
                part3.Anchored = true
                part3.Name = "Keaths Platform"
                part3.CollisionGroupId = 5
                part3.Parent = workspace

                while Auto do
                    wait(0.1)
                    local chr = game.Players.LocalPlayer.Character
                    local car = chr.Humanoid.SeatPart.Parent.Parent
                    car:PivotTo(CFrame.new(0,0,0))
                    wait(0.81)
                    car:PivotTo(part.CFrame)
                    wait(1)
                    car:PivotTo(part2.CFrame)
                    wait(1)
                    car:PivotTo(part3.CFrame)
                end
            end
        end)
    end
})

local Toggle = Tab:Toggle({
    Title = "自动建造",
    Default = false,
    Callback = function(state)
        getfenv().buyer = state
        while getfenv().buyer do
            task.wait()
            local function plot()
                for i,v in pairs(workspace.Tycoons:GetDescendants()) do
                    if v.Name == "Owner" and v.ClassName == "StringValue" and v.Value == game.Players.LocalPlayer.Name then
                        tycoon = v.Parent
                    end
                end
                return tycoon
            end
            pcall(function()
                for i,v in pairs(plot().Dealership.Purchases:GetChildren()) do 
                    if getfenv().buyer == true and v.TycoonButton.Button.Transparency == 0 then
                        game:GetService("ReplicatedStorage").Remotes.Build:FireServer("BuyItem", v.Name)
                        wait(0.3)
                    end 
                end   
            end)
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "自动完成赛季11比赛",
    Default = false,
    Callback = function(state)
        season = state
        task.spawn(function()
            while task.wait() do
                if not season then
                    break
                end
                for i, v in pairs(game:GetService("Workspace").Races.Season.Checkpoints:GetDescendants()) do
                    if v.Name == "IsActive" and v.Value == true and v.Parent.Name ~= "20" then
                        local chr = game:GetService("Players").LocalPlayer.Character
                        local car = chr.Humanoid.SeatPart.Parent.Parent
                        car:PivotTo(CFrame.new(v.Parent.Checkpoint.Position))
                        task.wait(0.2)
                    elseif v.Name == "IsActive" and v.Value == true and v.Parent.Name == "20" then
                        local chr = game:GetService("Players").LocalPlayer.Character
                        local car = chr.Humanoid.SeatPart.Parent.Parent
                        car:PivotTo(CFrame.new(v.Parent.Checkpoint.Position))
                        task.wait(0.2)
                        car:PivotTo(CFrame.new(v.Parent.Parent.Parent.GoalPart.Position))
                    end
                    task.wait(0.2)
                end
            end
        end)
    end
})

local Toggle = Tab:Toggle({
    Title = "自动完成圆形赛",
    Default = false,
    Callback = function(state)
        oval = state
        task.spawn(function()
            while task.wait() do
                if not oval then
                    break
                end
                for i, v in pairs(game:GetService("Workspace").Races.Race.Oval.Checkpoints:GetDescendants()) do
                    if v.Name == "IsActive" and v.Value == true and v.Parent.Name ~= "4" then
                        local chr = game:GetService("Players").LocalPlayer.Character
                        local car = chr.Humanoid.SeatPart.Parent.Parent
                        car:PivotTo(CFrame.new(v.Parent.Checkpoint.Position))
                        task.wait(0.2)
                    elseif v.Name == "IsActive" and v.Value == true and v.Parent.Name == "4" then
                        local chr = game:GetService("Players").LocalPlayer.Character
                        local car = chr.Humanoid.SeatPart.Parent.Parent
                        car:PivotTo(CFrame.new(v.Parent.Checkpoint.Position))
                        task.wait(0.2)
                        car:PivotTo(CFrame.new(v.Parent.Parent.Parent.GoalPart.Position))
                    end
                    task.wait(0.2)
                end
            end
        end)
    end
})

local Toggle = Tab:Toggle({
    Title = "自动完成卡丁车赛",
    Default = false,
    Callback = function(state)
        gokart = state
        task.spawn(function()
            while task.wait() do
                if not gokart then
                    break
                end
                for i, v in pairs(game:GetService("Workspace").Races.Race.Gokart.Checkpoints:GetDescendants()) do
                    if v.Name == "IsActive" and v.Value == true and v.Parent.Name ~= "9" then
                        local chr = game:GetService("Players").LocalPlayer.Character
                        local car = chr.Humanoid.SeatPart.Parent.Parent
                        car:PivotTo(CFrame.new(v.Parent.Checkpoint.Position))
                        task.wait(0.2)
                    elseif v.Name == "IsActive" and v.Value == true and v.Parent.Name == "9" then
                        local chr = game:GetService("Players").LocalPlayer.Character
                        local car = chr.Humanoid.SeatPart.Parent.Parent
                        car:PivotTo(CFrame.new(v.Parent.Checkpoint.Position))
                        task.wait(0.2)
                        car:PivotTo(CFrame.new(v.Parent.Parent.Parent.GoalPart.Position))
                    end
                    task.wait(0.2)
                end
            end
        end)
    end
})

local Toggle = Tab:Toggle({
    Title = "自动完成转圈赛",
    Default = false,
    Callback = function(state)
        circuit = state
        task.spawn(function()
            while task.wait() do
                if not circuit then
                    break
                end
                for i, v in pairs(game:GetService("Workspace").Races.Race.Circuit.Checkpoints:GetDescendants()) do
                    if v.Name == "IsActive" and v.Value == true and v.Parent.Name ~= "13" then
                        local chr = game:GetService("Players").LocalPlayer.Character
                        local car = chr.Humanoid.SeatPart.Parent.Parent
                        car:PivotTo(CFrame.new(v.Parent.Checkpoint.Position))
                        task.wait(0.2)
                    elseif v.Name == "IsActive" and v.Value == true and v.Parent.Name == "13" then
                        local chr = game:GetService("Players").LocalPlayer.Character
                        local car = chr.Humanoid.SeatPart.Parent.Parent
                        car:PivotTo(CFrame.new(v.Parent.Checkpoint.Position))
                        task.wait(0.2)
                        car:PivotTo(CFrame.new(v.Parent.Parent.Parent.GoalPart.Position))
                    end
                    task.wait(0.2)
                end
            end
        end)
    end
})

local Toggle = Tab:Toggle({
    Title = "自动完成漂移赛",
    Default = false,
    Callback = function(state)
        _G.racetest3 = state
        if _G.racetest3 == false then
            local distance = math.huge
            for a,b in pairs(workspace.DriftTrack:GetDescendants()) do
                if b.Name == "DriftAsphalt" and b.Parent.Name == "Model" then
                    local Dist = (Vector3.new(-2567.529296875, 601.9335327148438, 2018.6964111328125) - b.Position).magnitude
                    if Dist < distance then
                        distance = Dist
                        partvelo = b
                    end
                end
            end
            partvelo.Velocity = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector*0
        end
        while _G.racetest3 do
            wait()
            if game:GetService("Players").LocalPlayer.PlayerGui.Menu.Race.Visible == false then
                local chr = game.Players.LocalPlayer.Character
                local car = chr.Humanoid.SeatPart.Parent.Parent
                car:PivotTo(CFrame.new(-2502.25146484375, 601.9251708984375, 2013.3966064453125))
                car.Engine.Velocity = Vector3.new(0,0,0)
                chr.Head.Anchored = true
                car.Engine.Velocity = Vector3.new(0,0,0)
                wait(1)
                car.Engine.Velocity = Vector3.new(0,0,0)
                chr.Head.Anchored = false
                car.Engine.Velocity = Vector3.new(0,0,0)
                wait(1)
                workspace.Races.RaceHandler.StartLobby:FireServer("Drift")
                partvelo = nil
                repeat wait()
                    if game.Players.LocalPlayer:DistanceFromCharacter(Vector3.new(-2502.25146484375, 601.9251708984375, 2013.3966064453125)) > 10 then
                        car:PivotTo(CFrame.new(-2502.25146484375, 601.9251708984375, 2013.3966064453125))
                        car.Engine.Velocity = Vector3.new(0,0,0)
                        wait(0.1)
                        workspace.Races.RaceHandler.StartLobby:FireServer("Drift")
                    end
                until game:GetService("Players").LocalPlayer.PlayerGui.Menu.Race.Visible == true or _G.racetest3 == false
            elseif game:GetService("Players").LocalPlayer.PlayerGui.Menu.Race.Visible == true then
                if partvelo == nil then
                    local distance = math.huge
                    for a,b in pairs(workspace.DriftTrack:GetDescendants()) do
                        if b.Name == "DriftAsphalt" and b.Parent.Name == "Model" then
                            local Dist = (Vector3.new(-2567.529296875, 601.9335327148438, 2018.6964111328125) - b.Position).magnitude
                            if Dist < distance then
                                distance = Dist
                                partvelo = b
                            end
                        end
                    end
                    partvelo.Velocity = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector*1000
                end
                if game.Players.LocalPlayer:DistanceFromCharacter(partvelo.Position) > 10 then
                    local chr = game.Players.LocalPlayer.Character
                    local car = chr.Humanoid.SeatPart.Parent.Parent
                    car:PivotTo(partvelo.CFrame)
                end
                task.wait()
            end
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "自动完成警察抓小偷赛",
    Default = false,
    Callback = function(state)
        police = state
        task.spawn(function()
            while task.wait() do
                if not police then
                    break
                end
                for i, v in pairs(game:GetService("Workspace").Races.Police.Checkpoints:GetDescendants()) do
                    if v.Name == "IsActive" and v.Value == true and v.Parent.Name ~= "18" then
                        local chr = game:GetService("Players").LocalPlayer.Character
                        local car = chr.Humanoid.SeatPart.Parent.Parent
                        car:PivotTo(CFrame.new(v.Parent.Checkpoint.Position))
                        task.wait(0.2)
                    elseif v.Name == "IsActive" and v.Value == true and v.Parent.Name == "18" then
                        local chr = game:GetService("Players").LocalPlayer.Character
                        local car = chr.Humanoid.SeatPart.Parent.Parent
                        car:PivotTo(CFrame.new(v.Parent.Checkpoint.Position))
                        task.wait(0.2)
                        car:PivotTo(CFrame.new(v.Parent.Parent.Parent.GoalPart.Position))
                    end
                    task.wait(0.2)
                end
            end
        end)
    end
})

local Toggle = Tab:Toggle({
    Title = "自动完成城市赛",
    Default = false,
    Callback = function(state)
        city = state
        task.spawn(function()
            while task.wait() do
                if not city then
                    break
                end
                for i, v in pairs(game:GetService("Workspace").Races.City.City.Checkpoints:GetDescendants()) do
                    if v.Name == "IsActive" and v.Value == true and v.Parent.Name ~= "17" then
                        local chr = game:GetService("Players").LocalPlayer.Character
                        local car = chr.Humanoid.SeatPart.Parent.Parent
                        car:PivotTo(CFrame.new(v.Parent.Checkpoint.Position))
                        task.wait(0.2)
                    elseif v.Name == "IsActive" and v.Value == true and v.Parent.Name == "17" then
                        local chr = game:GetService("Players").LocalPlayer.Character
                        local car = chr.Humanoid.SeatPart.Parent.Parent
                        car:PivotTo(CFrame.new(v.Parent.Checkpoint.Position))
                        task.wait(0.2)
                        car:PivotTo(CFrame.new(v.Parent.Parent.Parent.GoalPart.Position))
                    end
                    task.wait(0.2)
                end
            end
        end)
    end
})

local Toggle = Tab:Toggle({
    Title = "自动完成公路赛",
    Default = false,
    Callback = function(state)
        highway = state
        task.spawn(function()
            while task.wait() do
                if not highway then
                    break
                end
                for i, v in pairs(game:GetService("Workspace").Races.City.Highway.Checkpoints:GetDescendants()) do
                    if v.Name == "IsActive" and v.Value == true and v.Parent.Name ~= "23" then
                        local chr = game:GetService("Players").LocalPlayer.Character
                        local car = chr.Humanoid.SeatPart.Parent.Parent
                        car:PivotTo(CFrame.new(v.Parent.Checkpoint.Position))
                        task.wait(0.2)
                    elseif v.Name == "IsActive" and v.Value == true and v.Parent.Name == "23" then
                        local chr = game:GetService("Players").LocalPlayer.Character
                        local car = chr.Humanoid.SeatPart.Parent.Parent
                        car:PivotTo(CFrame.new(v.Parent.Checkpoint.Position))
                        task.wait(0.2)
                        car:PivotTo(CFrame.new(v.Parent.Parent.Parent.GoalPart.Position))
                    end
                    task.wait(0.2)
                end
            end
        end)
    end
})

local Toggle = Tab:Toggle({
    Title = "自动完成山脉赛",
    Default = false,
    Callback = function(state)
        mountain = state
        task.spawn(function()
            while task.wait() do
                if not mountain then
                    break
                end
                for i, v in pairs(game:GetService("Workspace").Races.Mountain.Checkpoints:GetDescendants()) do
                    if v.Name == "IsActive" and v.Value == true and v.Parent.Name ~= "26" then
                        local chr = game:GetService("Players").LocalPlayer.Character
                        local car = chr.Humanoid.SeatPart.Parent.Parent
                        car:PivotTo(CFrame.new(v.Parent.Checkpoint.Position))
                        task.wait(0.2)
                    elseif v.Name == "IsActive" and v.Value == true and v.Parent.Name == "26" then
                        local chr = game:GetService("Players").LocalPlayer.Character
                        local car = chr.Humanoid.SeatPart.Parent.Parent
                        car:PivotTo(CFrame.new(v.Parent.Checkpoint.Position))
                        task.wait(0.2)
                        car:PivotTo(CFrame.new(v.Parent.Parent.Parent.GoalPart.Position))
                    end
                    task.wait(0.2)
                end
            end
        end)
    end
})

local Toggle = Tab:Toggle({
    Title = "自动完成海绵赛",
    Default = false,
    Callback = function(state)
        Sponge = state
        task.spawn(function()
            while task.wait() do
                if not Sponge then
                    break
                end
                local chr = game.Players.LocalPlayer.Character
                local car = chr.Humanoid.SeatPart.Parent.Parent
                car:PivotTo(workspace.Races.SpongeBobRace.Checkpoints["1"].Checkpoint.CFrame)
                wait(1)
                car:PivotTo(workspace.Races.SpongeBobRace.Checkpoints["2"].Checkpoint.CFrame)
                wait(0.1)
                car:PivotTo(workspace.Races.SpongeBobRace.Checkpoints["3"].Checkpoint.CFrame)
                wait(1)
                car:PivotTo(workspace.Races.SpongeBobRace.Checkpoints["4"].Checkpoint.CFrame)
                wait(0.1)
                car:PivotTo(workspace.Races.SpongeBobRace.Checkpoints["5"].Checkpoint.CFrame)
                wait(1)
                car:PivotTo(workspace.Races.SpongeBobRace.Checkpoints["6"].Checkpoint.CFrame)
                wait(0.1)
                car:PivotTo(workspace.Races.SpongeBobRace.Checkpoints["7"].Checkpoint.CFrame)
                wait(1)
                car:PivotTo(workspace.Races.SpongeBobRace.Checkpoints["8"].Checkpoint.CFrame)
                car:PivotTo(workspace.Races.SpongeBobRace.Checkpoints["9"].Checkpoint.CFrame)
                wait(1)
                car:PivotTo(workspace.Races.SpongeBobRace.Checkpoints["10"].Checkpoint.CFrame)
                wait(0.2)
                car:PivotTo(part.CFrame)
            end
        end)
    end
})