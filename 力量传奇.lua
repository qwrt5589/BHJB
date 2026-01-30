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
    Title = "修改区",
    Icon = "settings",
    Locked = false,
})

local Slider = Tab:Slider({
    Title = "修改力量",
    Value = configName,
    Callback = function(FXM)
      game:GetService("Players").LocalPlayer.leaderstats.Strength.Value = FXM  
    end
})

local Slider = Tab:Slider({
    Title = "修改重生",
    Value = configName,
    Callback = function(FXM)
        game:GetService("Players").LocalPlayer.leaderstats.Rebirths.Value = FXM
    end
})

local Slider = Tab:Slider({
    Title = "修改击杀",
    Value = configName,
    Callback = function(FXM)
        game:GetService("Players").LocalPlayer.leaderstats.Kills.Value = FXM
    end
})

local Slider = Tab:Slider({
    Title = "修改获胜",
    Value = configName,
    Callback = function(FXM)
        game:GetService("Players").LocalPlayer.leaderstats.Brawls.Value = FXM
    end
})

local Tab = Tabs.Main:Tab({
    Title = "功能",
    Icon = "settings",
    Locked = false,
})

local Toggle = Tab:Toggle({
    Title = "自动重生",
    Desc = "",
    Locked = false,
    Callback = function(Value)
    if Value then
        while Value do
            game:GetService("ReplicatedStorage").rEvents.rebirthRemote:InvokeServer("rebirthRequest")
            wait()
            end
        end        
    end
})

local Toggle = Tab:Toggle({
    Title = "自动修改体积为2",
    Desc = "",
    Locked = false,
    Callback = function(Value)
    if Value then
        while Value do
        game:GetService("ReplicatedStorage").rEvents.changeSpeedSizeRemote:InvokeServer("changeSize",2)
        wait()
    end
end
end
})

local Toggle = Tab:Toggle({
    Title = "自动传送肌肉之王",
    Desc = "",
    Locked = false,
    Callback = function(Value)
    if Value then
        while Value do
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-8625.9296875, 13.566278457641602, -5730.4736328125)
        wait()
    end
end
end
})

local Toggle = Tab:Toggle({
    Title = "0石头",
    Desc = "",
    Locked = false,
    Callback = function(Value)
    getgenv().RK0 = Value
    Jump = Value
    if Value then
        spawn(function()
            while Jump do
                local plr = game.Players.LocalPlayer
                if plr and plr.Character then
                    local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
                    local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        rootPart.CFrame = CFrame.new(15.53,0.76,2117.85)
                    end
                    local punch = plr.Backpack:FindFirstChild("Punch")
                    if punch and punch:IsA("Tool") and humanoid then
                        humanoid:EquipTool(punch)
                    end
                end
                wait(0.1)
            end
        end)
    else
        local plr = game.Players.LocalPlayer
        if plr and plr.Character then
            local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:UnequipTools()
            end
        end
    end
end
})

local Toggle = Tab:Toggle({
    Title = "10石头",
    Desc = "",
    Locked = false,
    Callback = function(Value)
    getgenv().RK0 = Value
    Jump = Value
    if Value then
        spawn(function()
            while Jump do
                local plr = game.Players.LocalPlayer
                if plr and plr.Character then
                    local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
                    local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        rootPart.CFrame = CFrame.new(-151.39,2.10,437.53)
                    end
                    local punch = plr.Backpack:FindFirstChild("Punch")
                    if punch and punch:IsA("Tool") and humanoid then
                        humanoid:EquipTool(punch)
                    end
                end
                wait(0.1)
            end
        end)
    else
        local plr = game.Players.LocalPlayer
        if plr and plr.Character then
            local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:UnequipTools()
            end
        end
    end
end
})

local Toggle = Tab:Toggle({
    Title = "100石头",
    Desc = "",
    Locked = false,
    Callback = function(Value)
    getgenv().RK0 = Value
    Jump = Value
    if Value then
        spawn(function()
            while Jump do
                local plr = game.Players.LocalPlayer
                if plr and plr.Character then
                    local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
                    local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        rootPart.CFrame = CFrame.new(164.47,1.24,-137.76)
                    end
                    local punch = plr.Backpack:FindFirstChild("Punch")
                    if punch and punch:IsA("Tool") and humanoid then
                        humanoid:EquipTool(punch)
                    end
                end
                wait(0.1)
            end
        end)
    else
        local plr = game.Players.LocalPlayer
        if plr and plr.Character then
            local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:UnequipTools()
            end
        end
    end
end
})

local Toggle = Tab:Toggle({
    Title = "5000石头",
    Desc = "",
    Locked = false,
    Callback = function(Value)
    getgenv().RK0 = Value
    Jump = Value
    if Value then
        spawn(function()
            while Jump do
                local plr = game.Players.LocalPlayer
                if plr and plr.Character then
                    local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
                    local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        rootPart.CFrame = CFrame.new(313.02,2.06,-559.59)
                    end
                    local punch = plr.Backpack:FindFirstChild("Punch")
                    if punch and punch:IsA("Tool") and humanoid then
                        humanoid:EquipTool(punch)
                    end
                end
                wait(0.1)
            end
        end)
    else
        local plr = game.Players.LocalPlayer
        if plr and plr.Character then
            local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:UnequipTools()
            end
        end
    end
end
})

local Toggle = Tab:Toggle({
    Title = "150000石头",
    Desc = "",
    Locked = false,
    Callback = function(Value)
    getgenv().RK0 = Value
    Jump = Value
    if Value then
        spawn(function()
            while Jump do
                local plr = game.Players.LocalPlayer
                if plr and plr.Character then
                    local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
                    local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        rootPart.CFrame = CFrame.new(-2514.23,1.07,-256.83)
                    end
                    local punch = plr.Backpack:FindFirstChild("Punch")
                    if punch and punch:IsA("Tool") and humanoid then
                        humanoid:EquipTool(punch)
                    end
                end
                wait(0.1)
            end
        end)
    else
        local plr = game.Players.LocalPlayer
        if plr and plr.Character then
            local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:UnequipTools()
            end
        end
    end
end
})

local Toggle = Tab:Toggle({
    Title = "400000石头",
    Desc = "",
    Locked = false,
    Callback = function(Value)
    getgenv().RK0 = Value
    Jump = Value
    if Value then
        spawn(function()
            while Jump do
                local plr = game.Players.LocalPlayer
                if plr and plr.Character then
                    local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
                    local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        rootPart.CFrame = CFrame.new(2186.48,8.09,1290.90)
                    end
                    local punch = plr.Backpack:FindFirstChild("Punch")
                    if punch and punch:IsA("Tool") and humanoid then
                        humanoid:EquipTool(punch)
                    end
                end
                wait(0.1)
            end
        end)
    else
        local plr = game.Players.LocalPlayer
        if plr and plr.Character then
            local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:UnequipTools()
            end
        end
    end
end
})

local Toggle = Tab:Toggle({
    Title = "750000石头",
    Desc = "",
    Locked = false,
    Callback = function(Value)
    getgenv().RK0 = Value
    Jump = Value
    if Value then
        spawn(function()
            while Jump do
                local plr = game.Players.LocalPlayer
                if plr and plr.Character then
                    local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
                    local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        rootPart.CFrame = CFrame.new(-7262.31,9.66,-1218.25)
                    end
                    local punch = plr.Backpack:FindFirstChild("Punch")
                    if punch and punch:IsA("Tool") and humanoid then
                        humanoid:EquipTool(punch)
                    end
                end
                wait(0.1)
            end
        end)
    else
        local plr = game.Players.LocalPlayer
        if plr and plr.Character then
            local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:UnequipTools()
            end
        end
    end
end
})

local Toggle = Tab:Toggle({
    Title = "100万石头",
    Desc = "",
    Locked = false,
    Callback = function(Value)
    getgenv().RK0 = Value
    Jump = Value
    if Value then
        spawn(function()
            while Jump do
                local plr = game.Players.LocalPlayer
                if plr and plr.Character then
                    local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
                    local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        rootPart.CFrame = CFrame.new(4132.50,991.64,-4035.54)
                    end
                    local punch = plr.Backpack:FindFirstChild("Punch")
                    if punch and punch:IsA("Tool") and humanoid then
                        humanoid:EquipTool(punch)
                    end
                end
                wait(0.1)
            end
        end)
    else
        local plr = game.Players.LocalPlayer
        if plr and plr.Character then
            local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:UnequipTools()
            end
        end
    end
end
})

local Toggle = Tab:Toggle({
    Title = "500万石头",
    Desc = "",
    Locked = false,
    Callback = function(Value)
    getgenv().RK0 = Value
    Jump = Value
    if Value then
        spawn(function()
            while Jump do
                local plr = game.Players.LocalPlayer
                if plr and plr.Character then
                    local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
                    local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        rootPart.CFrame = CFrame.new(-8985.91,17.23,-5989.86)
                    end
                    local punch = plr.Backpack:FindFirstChild("Punch")
                    if punch and punch:IsA("Tool") and humanoid then
                        humanoid:EquipTool(punch)
                    end
                end
                wait(0.1)
            end
        end)
    else
        local plr = game.Players.LocalPlayer
        if plr and plr.Character then
            local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:UnequipTools()
            end
        end
    end
end
})

local Toggle = Tab:Toggle({
    Title = "1000万石头",
    Desc = "",
    Locked = false,
    Callback = function(Value)
    getgenv().RK0 = Value
    Jump = Value
    if Value then
        spawn(function()
            while Jump do
                local plr = game.Players.LocalPlayer
                if plr and plr.Character then
                    local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
                    local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        rootPart.CFrame = CFrame.new(-7639.93,4.30,3007.76)
                    end
                    local punch = plr.Backpack:FindFirstChild("Punch")
                    if punch and punch:IsA("Tool") and humanoid then
                        humanoid:EquipTool(punch)
                    end
                end
                wait(0.1)
            end
        end)
    else
        local plr = game.Players.LocalPlayer
        if plr and plr.Character then
            local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:UnequipTools()
            end
        end
    end
end
})

local Button = Tab:Button({
    Title = "自动宝箱（传送+检测）[重复2次]",
    Desc = "",
    Locked = false,
    Callback = function()
    spawn(function()
        local repeatTimes = 2
        for cycle = 1, repeatTimes do
            local teleportPoints = {
                CFrame.new(-138.17,7.33,-276.85),        
                CFrame.new(4680.29,1001.05,-3689.63),    
                CFrame.new(2213.03,7.33,918.64),    
                CFrame.new(-6713.86,7.33,-1454.19),  
                CFrame.new(-2572.08,7.33,-556.94),        
                CFrame.new(40.71,7.33,410.27),    
                CFrame.new(-7914.54,4.30,3028.47)
            }
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local rootPart = character:WaitForChild("HumanoidRootPart")
            
            for _, targetCFrame in ipairs(teleportPoints) do
                rootPart.CFrame = targetCFrame
                task.wait(5)
            end
            task.wait(1)
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local chestRewards = ReplicatedStorage:FindFirstChild("chestRewards")
            local checkRemote = ReplicatedStorage:FindFirstChild("rEvents"):FindFirstChild("checkChestRemote")
            
            if not chestRewards or not checkRemote then
                task.wait(2)
                continue
            end
            
            local jk = {}
            for _, v in pairs(chestRewards:GetDescendants()) do
                if v.Name ~= "Light Karma Chest" and v.Name ~= "Evil Karma Chest" then
                    table.insert(jk, v.Name)
                end
            end
            
            for _, chestName in ipairs(jk) do
                checkRemote:InvokeServer(chestName)
                task.wait(2)
            end
            task.wait(3)
        end
    end)
end
})

local Button = Tab:Button({
    Title = "沙滩",
    Desc = "",
    Locked = false,
    Callback = function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-42.7, 3.7, 404.2)
end
})

local Button = Tab:Button({
    Title = "小岛（0-1000力量）",
    Desc = "",
    Locked = false,
    Callback = function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-37.636775970458984, 3.86960768699646, 1879.180908203125)
end
})

local Button = Tab:Button({
    Title = "冰霜健身房（1重生）",
    Desc = "",
    Locked = false,
    Callback = function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2623.022216796875, 3.716249465942383, -409.0733337402344)
end
})

local Button = Tab:Button({
    Title = "神话健身房（5重生）",
    Desc = "",
    Locked = false,
    Callback = function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2250.778076171875, 3.716248035430908, 1073.2266845703125)
end
})

local Button = Tab:Button({
    Title = "永恒健身房（15重生）",
    Desc = "",
    Locked = false,
    Callback = function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-6758.9638671875, 3.71626353263855, -1284.918701171875)
end
})

local Button = Tab:Button({
    Title = "传奇健身房（30重生）",
    Desc = "",
    Locked = false,
    Callback = function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(4603.28173828125, 987.869140625, -3897.86572265625)
end
})

local Button = Tab:Button({
    Title = "力量之王健身房（5重生）",
    Desc = "",
    Locked = false,
    Callback = function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-8625.9296875, 13.566278457641602, -5730.4736328125)
end
})

local Button = Tab:Button({
    Title = "狂野健身房（60重生）",
    Desc = "",
    Locked = false,
    Callback = function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-8693.0927734375, 8.93972396850586, 2400.66259765625)
end
})

local AutoTrainEnabled = false
local TrainThread = nil
local Toggle = Tab:Toggle({
    Title = "自动锻炼",
    Desc = "",
    Locked = false,
    Callback = function(Value)
    AutoTrainEnabled = Value
    if TrainThread then
        task.cancel(TrainThread)
        TrainThread = nil
    end
    if AutoTrainEnabled then
        TrainThread = task.spawn(function()
            while AutoTrainEnabled do
                local args = {[1] = "rep"}
                local muscleEvent = game.Players.LocalPlayer:FindFirstChild("muscleEvent")
                if muscleEvent then
                    muscleEvent:FireServer(unpack(args))
                end
                task.wait(0.1)
            end
        end)
    end
end
})

local AutoPunchEnabled = false
local PunchThread = nil
local Toggle = Tab:Toggle({
    Title = "自动挥拳",
    Desc = "",
    Locked = false,
    Callback = function(Value)
    AutoPunchEnabled = Value
    if PunchThread then
        task.cancel(PunchThread)
        PunchThread = nil
    end
    if AutoPunchEnabled then
        PunchThread = task.spawn(function()
            while AutoPunchEnabled do
                local args = {[1] = "punch", [2] = "rightHand"}
                local muscleEvent = game.Players.LocalPlayer:FindFirstChild("muscleEvent")
                if muscleEvent then
                    muscleEvent:FireServer(unpack(args))
                end
                task.wait(0.1)
            end
        end)
    end
 end
})

local Toggle = Tab:Toggle({
    Title = "自动哑铃",
    Desc = "",
    Locked = false,
    Callback = function(Value)
    for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v.ClassName == "Tool" and v.Name == "Weight" then
            v.Parent = game.Players.LocalPlayer.Character
            wait()
        end
    end
    if Value then
    local AutoRep = Value
        while AutoRep do
            game:GetService("Players").LocalPlayer.muscleEvent:FireServer("rep")
            wait()
        end
    end
end
})

local Toggle = Tab:Toggle({
    Title = "自动俯卧撑",
    Desc = "",
    Locked = false,
    Callback = function(Value)
    for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v.ClassName == "Tool" and v.Name == "Pushups" then
            v.Parent = game.Players.LocalPlayer.Character
            wait()
        end
    end
    if Value then
    local AutoRep = Value
        while AutoRep do
            game:GetService("Players").LocalPlayer.muscleEvent:FireServer("rep")
            wait()
        end
    end
end
})

local Toggle = Tab:Toggle({
    Title = "自动仰卧起坐",
    Desc = "",
    Locked = false,
    Callback = function(Value)
    for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v.ClassName == "Tool" and v.Name == "Situps" then
            v.Parent = game.Players.LocalPlayer.Character
            wait()
        end
    end
    if Value then
    local AutoRep = Value
        while AutoRep do
            game:GetService("Players").LocalPlayer.muscleEvent:FireServer("rep")
            wait()
        end
    end
end
})

local Toggle = Tab:Toggle({
    Title = "自动倒立",
    Desc = "",
    Locked = false,
    Callback = function(Value)
    for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v.ClassName == "Tool" and v.Name == "Handstands" then
            v.Parent = game.Players.LocalPlayer.Character
            wait()
        end
    end
    if Value then
    local AutoRep = Value
        while AutoRep do
            game:GetService("Players").LocalPlayer.muscleEvent:FireServer("rep")
            wait()
        end
    end
end
})

local Toggle = Tab:Toggle({
    Title = "自动练全部",
    Desc = "",
    Locked = false,
    Callback = function(Value)
    for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v.ClassName == "Tool" and v.Name == "Weight" or v.Name == "Handstands" or v.Name == "Pushups" or v.Name == "Situps" then
            v.Parent = game.Players.LocalPlayer.Character
            wait()
        end
    end
    if Value then
    local AutoRep = Value
        while AutoRep do
            game:GetService("Players").LocalPlayer.muscleEvent:FireServer("rep")
            wait()
        end
    end
end
})

local Toggle = Tab:Toggle({
    Title = "跑步机海滩10",
    Desc = "",
    Locked = false,
    Callback = function(treadmill)
    getgenv().spam = treadmill
while getgenv().spam do
wait()
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = 10
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(238.671112, 5.40315914, 387.713165, -0.0160072874, -2.90710176e-08, -0.99987185, -3.3434191e-09, 1, -2.90212157e-08, 0.99987185, 2.87843993e-09, -0.0160072874)
local oldpos = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
 
local localPlayer = Players.LocalPlayer
 
RunService:BindToRenderStep("move",
    Enum.RenderPriority.Character.Value + 1,
    function()
   	 if localPlayer.Character then
   		 local humanoid = localPlayer.Character:WaitForChild("Humanoid")
   		 if humanoid then
   			 humanoid:Move(Vector3.new(10000, 0, -1), true)
   		 end
   	 end
    end
)
end

if not getgenv().spam then
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
 
local localPlayer = Players.LocalPlayer
 
RunService:UnbindFromRenderStep("move",
    Enum.RenderPriority.Character.Value + 1,
    function()
   	 if localPlayer.Character then
   		 local humanoid = localPlayer.Character:FindFirstChild("Humanoid")
   		 if humanoid then
   			 humanoid:Move(Vector3.new(10000, 0, -1), true)
   		 end
   	 end
    end
)
end
end
})

local Toggle = Tab:Toggle({
    Title = "跑步机Frost-健身房-2000",
    Desc = "",
    Locked = false,
    Callback = function(treadmill)
    if game.Players.LocalPlayer.Agility.Value >= 2000 then
getgenv().spam = treadmill
while getgenv().spam do
wait()
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = 10
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(-3005.37866, 14.3221855, -464.697876, -0.015773816, -1.38508964e-08, 0.999875605, -5.13225586e-08, 1, 1.30429667e-08, -0.999875605, -5.11104332e-08, -0.015773816)
local oldpos = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
 
local localPlayer = Players.LocalPlayer
 
RunService:BindToRenderStep("move",
    Enum.RenderPriority.Character.Value + 1,
    function()
   	 if localPlayer.Character then
   		 local humanoid = localPlayer.Character:WaitForChild("Humanoid")
   		 if humanoid then
   			 humanoid:Move(Vector3.new(10000, 0, -1), true)
   		 end
   	 end
    end
)
end
end

if not getgenv().spam then
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
 
local localPlayer = Players.LocalPlayer
 
RunService:UnbindFromRenderStep("move",
    Enum.RenderPriority.Character.Value + 1,
    function()
   	 if localPlayer.Character then
   		 local humanoid = localPlayer.Character:FindFirstChild("Humanoid")
   		 if humanoid then
   			 humanoid:Move(Vector3.new(10000, 0, -1), true)
   		 end
   	 end
    end
)
end
end
})

local Toggle = Tab:Toggle({
    Title = "跑步机神话-健身房2000",
    Desc = "",
    Locked = false,
    Callback = function(treadmill)
    if game.Players.LocalPlayer.Agility.Value >= 2000 then
getgenv().spam = treadmill
while getgenv().spam do
wait()
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = 10
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(2571.23706, 15.6896839, 898.650391, 0.999968231, 2.23868635e-09, -0.00797206629, -1.73198844e-09, 1, 6.35660768e-08, 0.00797206629, -6.3550246e-08, 0.999968231)
local oldpos = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
 
local localPlayer = Players.LocalPlayer
 
RunService:BindToRenderStep("move",
    Enum.RenderPriority.Character.Value + 1,
    function()
   	 if localPlayer.Character then
   		 local humanoid = localPlayer.Character:WaitForChild("Humanoid")
   		 if humanoid then
   			 humanoid:Move(Vector3.new(10000, 0, -1), true)
   		 end
   	 end
    end
)
end
end

if not getgenv().spam then
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
 
local localPlayer = Players.LocalPlayer
 
RunService:UnbindFromRenderStep("move",
    Enum.RenderPriority.Character.Value + 1,
    function()
   	 if localPlayer.Character then
   		 local humanoid = localPlayer.Character:FindFirstChild("Humanoid")
   		 if humanoid then
   			 humanoid:Move(Vector3.new(10000, 0, -1), true)
   		 end
   	 end
    end
)
end
end
})

local Toggle = Tab:Toggle({
    Title = "永恒跑步机-健身房",
    Desc = "",
    Locked = false,
    Callback = function(treadmill)
    if game.Players.LocalPlayer.Agility.Value >= 3500 then
getgenv().spam = treadmill
while getgenv().spam do
wait()
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = 10
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(-7077.79102, 29.6702118, -1457.59961, -0.0322036594, -3.31122768e-10, 0.99948132, -6.44344267e-09, 1, 1.23684493e-10, -0.99948132, -6.43611742e-09, -0.0322036594)
local oldpos = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
 
local localPlayer = Players.LocalPlayer
 
RunService:BindToRenderStep("move",
    Enum.RenderPriority.Character.Value + 1,
    function()
   	 if localPlayer.Character then
   		 local humanoid = localPlayer.Character:WaitForChild("Humanoid")
   		 if humanoid then
   			 humanoid:Move(Vector3.new(10000, 0, -1), true)
   		 end
   	 end
    end
)
end
end

if not getgenv().spam then
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
 
local localPlayer = Players.LocalPlayer
 
RunService:UnbindFromRenderStep("move",
    Enum.RenderPriority.Character.Value + 1,
    function()
   	 if localPlayer.Character then
   		 local humanoid = localPlayer.Character:FindFirstChild("Humanoid")
   		 if humanoid then
   			 humanoid:Move(Vector3.new(10000, 0, -1), true)
   		 end
   	 end
    end
)
end
end
})

local Toggle = Tab:Toggle({
    Title = "跑步机传奇-健身房",
    Desc = "",
    Locked = false,
    Callback = function(treadmill)
    if game.Players.LocalPlayer.Agility.Value >= 3000 then
getgenv().spam = treadmill
while getgenv().spam do
wait()
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = 10
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(4370.82812, 999.358704, -3621.42773, -0.960604727, -8.41949266e-09, -0.27791819, -6.12478646e-09, 1, -9.12496567e-09, 0.27791819, -7.06329528e-09, -0.960604727)
local oldpos = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
 
local localPlayer = Players.LocalPlayer
 
RunService:BindToRenderStep("move",
    Enum.RenderPriority.Character.Value + 1,
    function()
   	 if localPlayer.Character then
   		 local humanoid = localPlayer.Character:WaitForChild("Humanoid")
   		 if humanoid then
   			 humanoid:Move(Vector3.new(10000, 0, -1), true)
   		 end
   	 end
    end
)
end
end

if not getgenv().spam then
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
 
local localPlayer = Players.LocalPlayer
 
RunService:UnbindFromRenderStep("move",
    Enum.RenderPriority.Character.Value + 1,
    function()
   	 if localPlayer.Character then
   		 local humanoid = localPlayer.Character:FindFirstChild("Humanoid")
   		 if humanoid then
   			 humanoid:Move(Vector3.new(10000, 0, -1), true)
   		 end
   	 end
    end
)
end
end
})

local Toggle = Tab:Toggle({
    Title = "沙滩",
    Desc = "",
    Locked = false,
    Callback = function(rack)
    if game.Players.LocalPlayer.leaderstats.Strength.Value >= 1000 then
getgenv().spam = rack
while getgenv().spam do
wait()
if game.Players.LocalPlayer.machineInUse.Value == nil then
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(232.627625, 3.67689133, 96.3039856, -0.963445187, -7.78685845e-08, -0.267905563, -7.92865222e-08, 1, -5.52570167e-09, 0.267905563, 1.5917589e-08, -0.963445187)
local vim = game:service("VirtualInputManager")
           vim:SendKeyEvent(true, "E", false, game)
else
local A_1 = "rep"
local A_2 = game:GetService("Workspace").machinesFolder["Squat Rack"].interactSeat
local Event = game:GetService("Players").LocalPlayer.muscleEvent
Event:FireServer(A_1, A_2)
end
end
end
if not getgenv().spam then
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Jump = true
end
end
})

local Toggle = Tab:Toggle({
    Title = "冰冻健身房",
    Desc = "",
    Locked = false,
    Callback = function(rack)
    if game.Players.LocalPlayer.leaderstats.Strength.Value >= 4000 then
getgenv().spam = rack
while getgenv().spam do
wait()
if game.Players.LocalPlayer.machineInUse.Value == nil then
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(-2629.13818, 3.36860609, -609.827454, -0.995664716, -2.67296816e-08, -0.0930150598, -1.90042453e-08, 1, -8.39415222e-08, 0.0930150598, -8.18099295e-08, -0.995664716)
local vim = game:service("VirtualInputManager")
           vim:SendKeyEvent(true, "E", false, game)
else
local A_1 = "rep"
local A_2 = game:GetService("Workspace").machinesFolder["Squat Rack"].interactSeat
local Event = game:GetService("Players").LocalPlayer.muscleEvent
Event:FireServer(A_1, A_2)
end
end
end
if not getgenv().spam then
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Jump = true
end
end
})

local Toggle = Tab:Toggle({
    Title = "传奇健身房",
    Desc = "",
    Locked = false,
    Callback = function(rack)
    getgenv().spam = rack
while getgenv().spam do
wait()
if game.Players.LocalPlayer.machineInUse.Value == nil then
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(4443.04443, 987.521484, -4061.12988, 0.83309716, 3.33018835e-09, 0.553126693, -2.87759438e-09, 1, -1.68654424e-09, -0.553126693, -1.86619012e-10, 0.83309716)
local vim = game:service("VirtualInputManager")
           vim:SendKeyEvent(true, "E", false, game)
else
local A_1 = "rep"
local A_2 = game:GetService("Workspace").machinesFolder["Squat Rack"].interactSeat
local Event = game:GetService("Players").LocalPlayer.muscleEvent
Event:FireServer(A_1, A_2)
end
end
if not getgenv().spam then
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Jump = true
end
end
})

local Toggle = Tab:Toggle({
    Title = "肌肉健身房",
    Desc = "",
    Locked = false,
    Callback = function(rack)
    getgenv().spam = rack
while getgenv().spam do
wait()
if game.Players.LocalPlayer.machineInUse.Value == nil then
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(-8757.37012, 13.2186356, -6051.24365, -0.902269304, 1.63610299e-08, -0.431172907, 1.71076486e-08, 1, 2.14606288e-09, 0.431172907, -5.44002754e-09, -0.902269304)
local vim = game:service("VirtualInputManager")
           vim:SendKeyEvent(true, "E", false, game)
else
local A_1 = "rep"
local A_2 = game:GetService("Workspace").machinesFolder["Squat Rack"].interactSeat
local Event = game:GetService("Players").LocalPlayer.muscleEvent
Event:FireServer(A_1, A_2)
end
end
if not getgenv().spam then
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Jump = true
end
end
})

local Toggle = Tab:Toggle({
    Title = "海滩",
    Desc = "",
    Locked = false,
    Callback = function(pull)
    if game.Players.LocalPlayer.leaderstats.Strength.Value >= 1000 then
getgenv().spam = pull
while getgenv().spam do
wait()
if game.Players.LocalPlayer.machineInUse.Value == nil then
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(-185.157745, 5.81071186, 104.747154, 0.227061391, -8.2363325e-09, 0.97388047, 5.58502826e-08, 1, -4.56432803e-09, -0.97388047, 5.54278827e-08, 0.227061391)
local vim = game:service("VirtualInputManager")
           vim:SendKeyEvent(true, "E", false, game)
else
local A_1 = "rep"
local A_2 = game:GetService("Workspace").machinesFolder["Legends Pullup"].interactSeat
local Event = game:GetService("Players").LocalPlayer.muscleEvent
Event:FireServer(A_1, A_2)
end
end
end
if not getgenv().spam then
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Jump = true
end
end
})

local Toggle = Tab:Toggle({
    Title = "神话",
    Desc = "",
    Locked = false,
    Callback = function(pull)
    if game.Players.LocalPlayer.leaderstats.Strength.Value >= 4000 then
getgenv().spam = pull
while getgenv().spam do
wait()
if game.Players.LocalPlayer.machineInUse.Value == nil then
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(2315.82104, 5.81071281, 847.153076, 0.993555248, 6.99809632e-08, 0.113349125, -7.05298859e-08, 1, 8.32554692e-10, -0.113349125, -8.82168916e-09, 0.993555248)
local vim = game:service("VirtualInputManager")
           vim:SendKeyEvent(true, "E", false, game)
else
local A_1 = "rep"
local A_2 = game:GetService("Workspace").machinesFolder["Legends Pullup"].interactSeat
local Event = game:GetService("Players").LocalPlayer.muscleEvent
Event:FireServer(A_1, A_2)
end
end
end
if not getgenv().spam then
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Jump = true
end
end
})

local Toggle = Tab:Toggle({
    Title = "传奇",
    Desc = "",
    Locked = false,
    Callback = function(pull)
    getgenv().spam = pull
while getgenv().spam do
wait()
if game.Players.LocalPlayer.machineInUse.Value == nil then
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(4305.08203, 989.963623, -4118.44873, -0.953815758, -7.58000382e-08, -0.30039227, -8.98859724e-08, 1, 3.30721512e-08, 0.30039227, 5.85457904e-08, -0.953815758)
local vim = game:service("VirtualInputManager")
           vim:SendKeyEvent(true, "E", false, game)
else
local A_1 = "rep"
local A_2 = game:GetService("Workspace").machinesFolder["Legends Pullup"].interactSeat
local Event = game:GetService("Players").LocalPlayer.muscleEvent
Event:FireServer(A_1, A_2)
end
end
if not getgenv().spam then
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Jump = true
end
end
})

local Toggle = Tab:Toggle({
    Title = "海滩",
    Desc = "",
    Locked = false,
    Callback = function(lift)
    if game.Players.LocalPlayer.leaderstats.Strength.Value >= 1500 then
getgenv().spam = lift
while getgenv().spam do
wait()
if game.Players.LocalPlayer.machineInUse.Value == nil then
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(136.606216, 3.67689133, 97.661499, -0.974106729, -1.89495477e-08, 0.226088539, -1.78365624e-08, 1, 6.96555214e-09, -0.226088539, 2.75254886e-09, -0.974106729)
local vim = game:service("VirtualInputManager")
           vim:SendKeyEvent(true, "E", false, game)
else
local A_1 = "rep"
local A_2 = game:GetService("Workspace").machinesFolder.Deadlift.interactSeat
local Event = game:GetService("Players").LocalPlayer.muscleEvent
Event:FireServer(A_1, A_2)
end
end
end
if not getgenv().spam then
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Jump = true
end
end
})

local Toggle = Tab:Toggle({
    Title = "传说健身房",
    Desc = "",
    Locked = false,
    Callback = function(lift)
    if game.Players.LocalPlayer.leaderstats.Strength.Value >= 5000 then
getgenv().spam = lift
while getgenv().spam do
wait()
if game.Players.LocalPlayer.machineInUse.Value == nil then
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(-2916.11572, 3.67689204, -212.97438, -0.241641939, -6.10995343e-08, 0.970365465, 6.65890596e-08, 1, 7.9547597e-08, -0.970365465, 8.38377616e-08, -0.241641939)
local vim = game:service("VirtualInputManager")
           vim:SendKeyEvent(true, "E", false, game)
else
local A_1 = "rep"
local A_2 = game:GetService("Workspace").machinesFolder.Deadlift.interactSeat
local Event = game:GetService("Players").LocalPlayer.muscleEvent
Event:FireServer(A_1, A_2)
end
end
end
if not getgenv().spam then
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Jump = true
end
end
})

local Toggle = Tab:Toggle({
    Title = "传奇健身房",
    Desc = "",
    Locked = false,
    Callback = function(lift)
    getgenv().spam = lift
while getgenv().spam do
wait()
if game.Players.LocalPlayer.machineInUse.Value == nil then
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(4538.42627, 987.829834, -4008.82007, -0.830109239, 2.21324914e-08, 0.557600796, 8.02302083e-08, 1, 7.97476361e-08, -0.557600796, 1.1093568e-07, -0.830109239)
local vim = game:service("VirtualInputManager")
           vim:SendKeyEvent(true, "E", false, game)
else
local A_1 = "rep"
local A_2 = game:GetService("Workspace").machinesFolder.Deadlift.interactSeat
local Event = game:GetService("Players").LocalPlayer.muscleEvent
Event:FireServer(A_1, A_2)
end
end
if not getgenv().spam then
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Jump = true
end
end
})

local Toggle = Tab:Toggle({
    Title = "肌肉之王",
    Desc = "",
    Locked = false,
    Callback = function(lift)
    getgenv().spam = lift
while getgenv().spam do
wait()
if game.Players.LocalPlayer.machineInUse.Value == nil then
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(-8768.4375, 13.5269203, -5681.62256, -0.997508109, -5.4007393e-10, 0.0705519542, 1.52984292e-10, 1, 9.81797044e-09, -0.0705519542, 9.80429782e-09, -0.997508109)
local vim = game:service("VirtualInputManager")
           vim:SendKeyEvent(true, "E", false, game)
else
local A_1 = "rep"
local A_2 = game:GetService("Workspace").machinesFolder.Deadlift.interactSeat
local Event = game:GetService("Players").LocalPlayer.muscleEvent
Event:FireServer(A_1, A_2)
end
end
if not getgenv().spam then
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Jump = true
end
end
})

local Toggle = Tab:Toggle({
    Title = "海滩",
    Desc = "",
    Locked = false,
    Callback = function(lift)
    if game.Players.LocalPlayer.leaderstats.Strength.Value >= 3000 then
getgenv().spam = lift
while getgenv().spam do
wait()
if game.Players.LocalPlayer.machineInUse.Value == nil then
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(-91.6730804, 3.67689133, -292.42868, -0.221022144, -2.21041621e-08, -0.975268781, 1.21414407e-08, 1, -2.54162646e-08, 0.975268781, -1.7458726e-08, -0.221022144)
local vim = game:service("VirtualInputManager")
           vim:SendKeyEvent(true, "E", false, game)
else
local A_1 = "rep"
local A_2 = game:GetService("Workspace").machinesFolder.Deadlift.interactSeat
local Event = game:GetService("Players").LocalPlayer.muscleEvent
Event:FireServer(A_1, A_2)
end
end
end
if not getgenv().spam then
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Jump = true
end
end
})

local Toggle = Tab:Toggle({
    Title = "神话",
    Desc = "",
    Locked = false,
    Callback = function(lift)
    if game.Players.LocalPlayer.leaderstats.Strength.Value >= 10000 then
getgenv().spam = lift
while getgenv().spam do
wait()
if game.Players.LocalPlayer.machineInUse.Value == nil then
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(2486.01733, 3.67689276, 1237.89331, 0.883595645, -2.06135038e-08, -0.468250751, -3.3286871e-09, 1, -5.03036404e-08, 0.468250751, 4.60067362e-08, 0.883595645)
local vim = game:service("VirtualInputManager")
           vim:SendKeyEvent(true, "E", false, game)
else
local A_1 = "rep"
local A_2 = game:GetService("Workspace").machinesFolder.Deadlift.interactSeat
local Event = game:GetService("Players").LocalPlayer.muscleEvent
Event:FireServer(A_1, A_2)
end
end
end
if not getgenv().spam then
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Jump = true
end
end
})

local Toggle = Tab:Toggle({
    Title = "传奇",
    Desc = "",
    Locked = false,
    Callback = function(lift)
    getgenv().spam = lift
while getgenv().spam do
wait()
if game.Players.LocalPlayer.machineInUse.Value == nil then
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(4189.96143, 987.829773, -3903.0166, 0.422592968, 0, 0.906319559, 0, 1, 0, -0.906319559, 0, 0.422592968)
local vim = game:service("VirtualInputManager")
           vim:SendKeyEvent(true, "E", false, game)
else
local A_1 = "rep"
local A_2 = game:GetService("Workspace").machinesFolder.Deadlift.interactSeat
local Event = game:GetService("Players").LocalPlayer.muscleEvent
Event:FireServer(A_1, A_2)
end
end
if not getgenv().spam then
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Jump = true
end
end
})

local Toggle = Tab:Toggle({
    Title = "肌肉之王",
    Desc = "",
    Locked = false,
    Callback = function(lift)
    getgenv().spam = lift
while getgenv().spam do
wait()
if game.Players.LocalPlayer.machineInUse.Value == nil then
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(8933.69434, 13.5269222, -5700.12598, -0.823058188, 6.96304259e-09, 0.567957044, -1.19721832e-08, 1, -2.96093621e-08, -0.567957044, -3.11699146e-08, -0.823058188)
local vim = game:service("VirtualInputManager")
           vim:SendKeyEvent(true, "E", false, game)
else
local A_1 = "rep"
local A_2 = game:GetService("Workspace").machinesFolder.Deadlift.interactSeat
local Event = game:GetService("Players").LocalPlayer.muscleEvent
Event:FireServer(A_1, A_2)
end
end
if not getgenv().spam then
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Jump = true
end
end