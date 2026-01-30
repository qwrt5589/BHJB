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
    Title = "自动区",
    Icon = "settings",
    Locked = false,
})

local Toggle = Tab:Toggle({
    Title = "自动获胜",
    Default = false,
    Callback = function(state)
        ActiveAutoWin = state
        if ActiveAutoWin then
            WindUI:Notify({
                Title = "提示提示",
                Content = "自动获胜已开启",
                Duration = 4
            })
            
            spawn(function()
                while ActiveAutoWin do
                    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                    local rootPart = character:FindFirstChild("HumanoidRootPart")

                    if character and rootPart then
                        if character:GetAttribute("Downed") then
                            ReplicatedStorage.Events.Player.ChangePlayerMode:FireServer(true)
                            task.wait(0.5)
                        end

                        if not character:GetAttribute("Downed") then
                            local securityPart = Instance.new("Part")
                            securityPart.Name = "SecurityPartTemp"
                            securityPart.Size = Vector3.new(10, 1, 10)
                            securityPart.Position = Vector3.new(0, 500, 0)
                            securityPart.Anchored = true
                            securityPart.Transparency = 1
                            securityPart.CanCollide = true
                            securityPart.Parent = Workspace

                            rootPart.CFrame = securityPart.CFrame + Vector3.new(0, 3, 0)
                            task.wait(0.5)
                            securityPart:Destroy()
                        end
                    end
                    task.wait(0.1)
                end
            end)
        else
            WindUI:Notify({
                Title = "提示提示",
                Content = "自动获胜已关闭",
                Duration = 4
            })
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "自动刷钱",
    Default = false,
    Callback = function(state)
        ActiveAutoFarmMoney = state
        if ActiveAutoFarmMoney then
            WindUI:Notify({
                Title = "提示提示",
                Content = "自动刷钱已开启",
                Duration = 4
            })
            
            spawn(function()
                while ActiveAutoFarmMoney do
                    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                    local rootPart = character and character:FindFirstChild("HumanoidRootPart")

                    if character and rootPart then
                        if character:GetAttribute("Downed") then
                            ReplicatedStorage.Events.Player.ChangePlayerMode:FireServer(true)
                            task.wait(0.5)
                        end

                        local downedPlayerFound = false
                        local playersInGame = Workspace:FindFirstChild("Game") and Workspace.Game:FindFirstChild("Players")
                        if playersInGame then
                            for _, v in pairs(playersInGame:GetChildren()) do
                                if v:IsA("Model") and v:FindFirstChildOfClass("Humanoid") and v:GetAttribute("Downed") then
                                    rootPart.CFrame = v.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                                    ReplicatedStorage.Events.Character.Interact:FireServer("Revive", true, v)
                                    task.wait(0.5)
                                    downedPlayerFound = true
                                    break
                                end
                            end
                        end

                        if not downedPlayerFound then
                        end

                        local securityPart = Instance.new("Part")
                        securityPart.Name = "SecurityPartTemp"
                        securityPart.Size = Vector3.new(10, 1, 10)
                        securityPart.Position = Vector3.new(0, 500, 0)
                        securityPart.Anchored = true
                        securityPart.Transparency = 1
                        securityPart.CanCollide = true
                        securityPart.Parent = Workspace
                        rootPart.CFrame = securityPart.CFrame + Vector3.new(0, 3, 0)

                    else
                    end
                    task.wait(1)
                end
            end)
        else
            WindUI:Notify({
                Title = "提示提示",
                Content = "自动刷钱已关闭",
                Duration = 4
            })
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "自动比赛",
    Desc = "当有比赛时自动参加比赛",
    Value = false,
    Callback = function(state) 
        local zdbskq = state
        if state then
            while zdbskq do
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("raceEvent"):FireServer("joinRace")
            wait(0.000000000000000000000000000000000000000000000000000000000000000000000000001)
            end
        end
        WindUI:Notify({
            Title = "路西法：",
            Content = state and "已开启自动比赛" or "已关闭自动比赛",
            Icon = state and "check" or "x",
            Duration = 2
        })
    end
})

local Toggle = Tab:Toggle({
    Title = "自动刷速度V2",
    Desc = "可在任意地方使用（不稳定）",
    Value = false,
    Callback = function(state) 
        local zdsdkq = state
        if state then
            while zdsdkq do
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("questsEvent"):FireServer("collectQuest",Instance.new("Folder", nil))
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("questsEvent"):FireServer("collectQuest",Instance.new("Folder", nil))
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("questsEvent"):FireServer("collectQuest",Instance.new("Folder", nil))
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("questsEvent"):FireServer("collectQuest",Instance.new("Folder", nil))
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("questsEvent"):FireServer("collectQuest",Instance.new("Folder", nil))
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("questsEvent"):FireServer("collectQuest",Instance.new("Folder", nil))
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("questsEvent"):FireServer("collectQuest",Instance.new("Folder", nil))
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("questsEvent"):FireServer("collectQuest",Instance.new("Folder", nil))
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("questsEvent"):FireServer("collectQuest",Instance.new("Folder", nil))
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("questsEvent"):FireServer("collectQuest",Instance.new("Folder", nil))
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("questsEvent"):FireServer("collectQuest",Instance.new("Folder", nil))
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("questsEvent"):FireServer("collectQuest",Instance.new("Folder", nil))
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("questsEvent"):FireServer("collectQuest",Instance.new("Folder", nil))
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("questsEvent"):FireServer("collectQuest",Instance.new("Folder", nil))
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("questsEvent"):FireServer("collectQuest",Instance.new("Folder", nil))
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("questsEvent"):FireServer("collectQuest",Instance.new("Folder", nil))
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("questsEvent"):FireServer("collectQuest",Instance.new("Folder", nil))
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("questsEvent"):FireServer("collectQuest",Instance.new("Folder", nil))
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("questsEvent"):FireServer("collectQuest",Instance.new("Folder", nil))
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("questsEvent"):FireServer("collectQuest",Instance.new("Folder", nil))
            wait(0.000000000000000000000000000000000000000000000000000000000000000000000000001)
            end
        end
        WindUI:Notify({
            Title = "路西法：",
            Content = state and "已开启自动刷速度" or "已关闭自动刷速度",
            Icon = state and "check" or "x",
            Duration = 2
        })
    end
})

local Toggle = Tab:Toggle({
    Title = "自动买宠物",
    Desc = "快速获得宠物，消耗钻石",
    Value = false,
    Callback = function(state) 
        local mcwkq = state
        if state then
            while mcwkq do
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("openCrystalRemote"):InvokeServer("openCrystal","Jungle Crystal")
            wait(0.000000000000000000000000000000000000000000000000000000000000000000000000001)
            end
        end
        WindUI:Notify({
            Title = "路西法：",
            Content = state and "已开启自动买宠物" or "已关闭自动买宠物",
            Icon = state and "check" or "x",
            Duration = 2
        })
    end
})

local Toggle = Tab:Toggle({
    Title = "自动买尾迹",
    Desc = "快速获得尾迹，消耗钻石",
    Value = false,
    Callback = function(state) 
        local mwjkq = state
        if state then
            while mwjkq do
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("openCrystalRemote"):InvokeServer("openCrystal","Inferno Crystal")
            wait(0.000000000000000000000000000000000000000000000000000000000000000000000000001)
            end
        end
        WindUI:Notify({
            Title = "路西法：",
            Content = state and "已开启自动买尾迹" or "已关闭自动买尾迹",
            Icon = state and "check" or "x",
            Duration = 2
        })
    end
})

local Toggle = Tab:Toggle({
    Title = "自动投票",
    Default = false,
    Callback = function(state)
        autoVoteEnabled = state
        if autoVoteEnabled then
            WindUI:Notify({
                Title = "提示提示",
                Content = "自动投票已开启",
                Duration = 4
            })
            
            if not voteConnection then
                voteConnection = game:GetService("RunService").Heartbeat:Connect(function()
                    fireVoteServer(selectedMapNumber)
                end)
            end
        else
            WindUI:Notify({
                Title = "提示提示",
                Content = "自动投票已关闭",
                Duration = 4
            })
            
            if voteConnection then
                voteConnection:Disconnect()
                voteConnection = nil
            end
        end
    end
})

local autoXP = false
local Toggle = Tab:Toggle({
    Title = "自动刷经验 150",
    Desc = "",
    Locked = false,
    Callback = function(Value)
		autoXP = Value
		while autoXP do
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", "City")			
			wait()
		end	
    end
})

local cssdkq = false
local Toggle = Tab:Toggle({
    Title = "自动刷速度",
    Desc = "城市内使用",
    Value = cssdkq,
    Callback = function(state) 
        cssdkq = state
        if state then
            while cssdkq do
                game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","City")
    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","City")
    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","City")
    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","City")
    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","City")
    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","City")
    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","City")
    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","City")
    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","City")
    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","City")
    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","City")
    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","City")
    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","City")
    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","City")
    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","City")
    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","City")
    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","City")
    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","City")
            wait(0.000000000000000000000000000000000000000000000000000000000000000000000000001)
            end
        end
        WindUI:Notify({
            Title = "路西法：",
            Content = state and "已开启自动刷速度" or "已关闭自动刷速度",
            Icon = state and "check" or "x",
            Duration = 2
        })
    end
})

local bxsdkq = false
local Toggle = Tab:Toggle({
    Title = "自动刷速度",
    Desc = "白雪城市内使用",
    Value = bxsdkq,
    Callback = function(state) 
        bxsdkq = state
        if state then
            while bxsdkq do
                game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Snow City")
            wait(0.000000000000000000000000000000000000000000000000000000000000000000000000001)
            end
        end
        WindUI:Notify({
            Title = "路西法：",
            Content = state and "已开启自动刷速度" or "已关闭自动刷速度",
            Icon = state and "check" or "x",
            Duration = 2
        })
    end
})

local dysdkq = false
local Toggle = Tab:Toggle({
    Title = "自动刷速度",
    Desc = "岩浆城市内使用",
    Value = dysdkq,
    Callback = function(state) 
        dysdkq = state
        if state then
            while dysdkq do
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Magma City")
            wait(0.000000000000000000000000000000000000000000000000000000000000000000000000001)
            end
        end
        WindUI:Notify({
            Title = "路西法：",
            Content = state and "已开启自动刷速度" or "已关闭自动刷速度",
            Icon = state and "check" or "x",
            Duration = 2
        })
    end
})

local cqsdkq = false
local Toggle = Tab:Toggle({
    Title = "自动刷速度",
    Desc = "传奇公路内使用",
    Value = cqsdkq,
    Callback = function(state) 
        cqsdkq = state
        if state then
            while cqsdkq do
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Legends Highway")
            wait(0.000000000000000000000000000000000000000000000000000000000000000000000000001)
            end
        end
        WindUI:Notify({
            Title = "路西法：",
            Content = state and "已开启自动刷速度" or "已关闭自动刷速度",
            Icon = state and "check" or "x",
            Duration = 2
        })
    end
})

local Toggle = Tab:Toggle({
    Title = "自动重生",
    Desc = "可重生时将自动重生",
    Value = false,
    Callback = function(state) 
        local cskq = state
        if state then
            while cskq do
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("rebirthEvent"):FireServer("rebirthRequest")
            wait(0.000000000000000000000000000000000000000000000000000000000000000000000000001)
            end
        end
        WindUI:Notify({
            Title = "路西法：",
            Content = state and "已开启自动重生" or "已关闭自动重生",
            Icon = state and "check" or "x",
            Duration = 2
        })
    end
})

local Toggle = Tab:Toggle({
    Title = "自动刷钻石",
    Desc = "城市内使用",
    Value = false,
    Callback = function(state) 
        local cszskq = state
        if state then
            while cszskq do
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","City")
            wait(0.000000000000000000000000000000000000000000000000000000000000000000000000001)
            end
        end
        WindUI:Notify({
            Title = "路西法：",
            Content = state and "已开启自动刷钻石" or "已关闭自动刷钻石",
            Icon = state and "check" or "x",
            Duration = 2
        })
    end
})

local Toggle = Tab:Toggle({
    Title = "自动刷钻石",
    Desc = "白雪城市内使用",
    Value = false,
    Callback = function(state) 
        local bxzskq = state
        if state then
            while bxzskq do
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Snow City")
            wait(0.000000000000000000000000000000000000000000000000000000000000000000000000001)
            end
        end
        WindUI:Notify({
            Title = "路西法：",
            Content = state and "已开启自动刷钻石" or "已关闭自动刷钻石",
            Icon = state and "check" or "x",
            Duration = 2
        })
    end
})

local Toggle = Tab:Toggle({
    Title = "自动刷钻石",
    Desc = "岩浆城市内使用",
    Value = false,
    Callback = function(state) 
        local yjzskq = state
        if state then
            while yjzskq do
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Magma City")
            wait(0.000000000000000000000000000000000000000000000000000000000000000000000000001)
            end
        end
        WindUI:Notify({
            Title = "路西法：",
            Content = state and "已开启自动刷钻石" or "已关闭自动刷钻石",
            Icon = state and "check" or "x",
            Duration = 2
        })
    end
})

local Toggle = Tab:Toggle({
    Title = "自动刷钻石",
    Desc = "传奇公路内使用",
    Value = false,
    Callback = function(state) 
        local cqzskq = state
        if state then
            while cqzskq do
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Legends Highway")
            wait(0.000000000000000000000000000000000000000000000000000000000000000000000000001)
            end
        end
        WindUI:Notify({
            Title = "路西法：",
            Content = state and "已开启自动刷钻石" or "已关闭自动刷钻石",
            Icon = state and "check" or "x",
            Duration = 2
        })
    end
})

local q = {
    CFrame.new(-278.8976135253906, 66.09315490722656, -10946.564453125),
    CFrame.new(3980.05029296875, 159.91925048828125, 5589.21533203125),
    CFrame.new(137.6853485107422, 75.40111541748047, -5972.4873046875),
    CFrame.new(-15376.439453125, 412.2984619140625, 4475.322265625),
    CFrame.new(-489.440673828125, 98.277099609375, 2502.03564453125),
    CFrame.new(-15167.5068359375, 382.1965026855469, 4888.2900390625),
    CFrame.new(2094.217041015625, 251.98931884765625, 12877.951171875),
    CFrame.new(-1645.1728515625, 69.02545928955078, 5337.923828125),
    CFrame.new(-13254.447265625, 222.44158935546875, 4891.56005859375),
    CFrame.new(-533.439208984375, 58.4377326965332, 209.794921875),
    CFrame.new(473.2319641113281, 66.08084106445312, -10867.8388671875),
    CFrame.new(2333.369873046875, 161.6602325439453, 13369.1240234375),
    CFrame.new(5392.5322265625, 297.8348388671875, 5885.2138671875),
    CFrame.new(3806.247802734375, 299.41748046875, 7225.6806640625),
    CFrame.new(1664.3343505859375, 80.900390625, 12589.7109375),
    CFrame.new(1769.7236328125, 80.90105438232422, 12879.7958984375),
    CFrame.new(-11097.05859375, 200.84193420410156, 4465.34375),
    CFrame.new(-13140.974609375, 200.84193420410156, 4465.39599609375),
    CFrame.new(-536.3781127929688, 58.43798065185547, -133.1399688720703),
    CFrame.new(2485.461181640625, 135.55299377441406, 12384.6455078125),
    CFrame.new(1173.287109375, 92.03070831298828, -6024.24365234375),
    CFrame.new(-85.52466583251953, 115.9759750366211, -107.73560333251953),
    CFrame.new(1805.7076416015625, 90.94168853759766, 4617.30712890625),
    CFrame.new(-350.6163330078125, 66.06715393066406, -8732.2490234375),
    CFrame.new(5666.32861328125, 326.5240478515625, 6494.826171875),
    CFrame.new(4516.66845703125, 221.20545959472656, 7181.7421875),
    CFrame.new(-1746.5504150390625, 150.5835418701172, 5372.54248046875),
    CFrame.new(5361.96826171875, 297.8207092285156, 7025.44482421875),
    CFrame.new(4650.1669921875, 221.213134765625, 5608.54345703125),
    CFrame.new(-12993.1826171875, 200.82785034179688, 5222.71337890625),
    CFrame.new(355.5094299316406, 111.75679779052734, -10924.6923828125),
    CFrame.new(1942.0057373046875, 93.18344116210938, -2047.2164306640625),
    CFrame.new(-15156.52734375, 355.08978271484375, 4141.91357421875),
    CFrame.new(2062.114990234375, 159.88404846191406, 4374.28076171875),
    CFrame.new(230.04505920410156, 94.17676544189453, 80.71623229980469),
}

local Toggle = Tab:Toggle({
    Title = "自动刷圈",
    Desc = "传奇公路内使用",
    Value = false,
    Callback = function(state) 
        local sqkq = state
        if state then
            while sqkq do
                for _, zdsq in ipairs(q) do
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = zdsq
                    wait(0.0000000000000000000000000000000000000000000000000000000000000000000000001)
                end
            wait(0.000000000000000000000000000000000000000000000000000000000000000000000000001)
            end
        else
game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-568.6292114257812, 3.1723721027374268, 412.86492919921875)
        end
        WindUI:Notify({
            Title = "路西法：",
            Content = state and "已开启自动刷圈" or "已关闭自动刷圈",
            Icon = state and "check" or "x",
            Duration = 2
        })
    end
})

local Tab = Tabs.Main:Tab({
    Title = "功能",
    Icon = "settings",
    Locked = false,
})

local selectedMapNumber = 1
local autoVoteEnabled = false
local voteConnection = nil

local function fireVoteServer(selectedMapNumber)
    local eventsFolder = ReplicatedStorage:WaitForChild("Events", 10)
    if eventsFolder then
        local playerFolder = eventsFolder:WaitForChild("Player", 10)
        if playerFolder then
            local voteEvent = playerFolder:WaitForChild("Vote", 10)
            if voteEvent and typeof(voteEvent) == "Instance" and voteEvent:IsA("RemoteEvent") then
                local args = {
                    [1] = selectedMapNumber
                }
                voteEvent:FireServer(unpack(args))
            end
        end
    end
end

local Dropdown = Tab:Dropdown({
    Title = "选择地图",
    Values = {"地图 1", "地图 2", "地图 3", "地图 4"},
    Default = "地图 1",
    Callback = function(value)
        if value == "地图 1" then
            selectedMapNumber = 1
        elseif value == "地图 2" then
            selectedMapNumber = 2
        elseif value == "地图 3" then
            selectedMapNumber = 3
        elseif value == "地图 4" then
            selectedMapNumber = 4
        end
        WindUI:Notify({
            Title = "提示提示",
            Content = "已选择: " .. value,
            Duration = 4
        })
    end
})

local Button = Tab:Button({
    Title = "投票",
    Callback = function()
        fireVoteServer(selectedMapNumber)
        WindUI:Notify({
            Title = "提示提示",
            Content = "已投票给地图 " .. selectedMapNumber,
            Duration = 4
        })
    end
})



local autoReviveEnabled = false
local lastCheckTime = 0
local checkInterval = 5

local Button = Tab:Button({
    Title = "复活自己",
    Callback = function()
        local player = LocalPlayer
        local character = player.Character
        if character and character:GetAttribute("Downed") then
            ReplicatedStorage.Events.Player.ChangePlayerMode:FireServer(true)
            WindUI:Notify({
                Title = "提示提示",
                Content = "✅已复活!",
                Duration = 4
            })
        else
            WindUI:Notify({
                Title = "提示提示",
                Content = "你还没有倒地!",
                Duration = 4
            })
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "自动复活自己",
    Default = false,
    Callback = function(state)
        autoReviveEnabled = state
        if autoReviveEnabled then
            WindUI:Notify({
                Title = "提示提示",
                Content = "自动复活已开启",
                Duration = 4
            })
        else
            WindUI:Notify({
                Title = "提示提示",
                Content = "自动复活已关闭",
                Duration = 4
            })
        end
    end
})

game:GetService("RunService").Heartbeat:Connect(function()
    if autoReviveEnabled then
        if tick() - lastCheckTime >= checkInterval then
            lastCheckTime = tick()
            local player = LocalPlayer
            local character = player.Character
            if character and character:GetAttribute("Downed") then
                ReplicatedStorage.Events.Player.ChangePlayerMode:FireServer(true)
            end
        end
    end
end)

local Tab = Tabs.Main:Tab({
    Title = "传送区",
    Icon = "settings",
    Locked = false,
})

local Button = Tab:Button({
    Title = "传送至城市（出生点）",
    Icon = "bell",
    Callback = function()
game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-568.6292114257812, 3.1723721027374268, 412.86492919921875)
        WindUI:Notify({
            Title = "路西法：",
            Content = "传送成功",
            Icon = "bell",
            Duration = 3
        })
    end
})

local Button = Tab:Button({
    Title = "传送至神秘洞穴",
    Icon = "bell",
    Callback = function()
game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-9683.048828125, 58.352359771728516, 3136.626953125)
        WindUI:Notify({
            Title = "路西法：",
            Content = "传送成功",
            Icon = "bell",
            Duration = 3
        })
    end
})

local Button = Tab:Button({
    Title = "传送至白雪城市",
    Icon = "bell",
    Callback = function()
game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-866.3868408203125, 3.222372055053711, 2165.70654296875)
        WindUI:Notify({
            Title = "路西法：",
            Content = "传送成功",
            Icon = "bell",
            Duration = 3
        })
    end
})

local Button = Tab:Button({
    Title = "传送至地狱洞穴",
    Icon = "bell",
    Callback = function()
game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-11041.357421875, 58.352359771728516, 4111.8251953125)
        WindUI:Notify({
            Title = "路西法：",
            Content = "传送成功",
            Icon = "bell",
            Duration = 3
        })
    end
})

local Button = Tab:Button({
    Title = "传送至熔岩城市",
    Icon = "bell",
    Callback = function()
game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1616.8270263671875, 3.2723801136016846, 4330.65234375)
        WindUI:Notify({
            Title = "路西法：",
            Content = "传送成功",
            Icon = "bell",
            Duration = 3
        })
    end
})

local Button = Tab:Button({
    Title = "传送至水手路线",
    Icon = "bell",
    Callback = function()
game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1618.4071044921875, 8.759234428405762, 4892.44091796875)
        WindUI:Notify({
            Title = "路西法：",
            Content = "传送成功",
            Icon = "bell",
            Duration = 3
        })
    end
})

local Button = Tab:Button({
    Title = "传送至电光洞穴",
    Icon = "bell",
    Callback = function()
game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-13107.9892578125, 58.352359771728516, 4099.099609375)
        WindUI:Notify({
            Title = "路西法：",
            Content = "传送成功",
            Icon = "bell",
            Duration = 3
        })
    end
})

local Button = Tab:Button({
    Title = "传送至传奇公路",
    Icon = "bell",
    Callback = function()
game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(3673.601318359375, 70.75231170654297, 5588.7958984375)
        WindUI:Notify({
            Title = "路西法：",
            Content = "传送成功",
            Icon = "bell",
            Duration = 3
        })
    end
})

local Button = Tab:Button({
    Title = "传送至丛林洞穴",
    Icon = "bell",
    Callback = function()
game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-15266.7880859375, 239.7072296142578, 3769.77490234375)
        WindUI:Notify({
            Title = "路西法：",
            Content = "传送成功",
            Icon = "bell",
            Duration = 3
        })
    end
})
