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
    Title = "<font color='#FFA500'>辰脚本</font><font color='#FFFF00'>李浩天</font>",
    IconTransparency = 0.5,
    IconThemed = true,
    Author = "作者:李浩天",
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
    Title = "作者李浩天",
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
    Desc = "作者：李浩天",    
    Thumbnail = "rbxassetid://72368339506794",
    ThumbnailSize = 0,
})


local Tabs = {
    Main = Window:Section({ Title = "脚本", Opened = true }),
    Settings = Window:Section({ Title = "作者:李浩天", Opened = true }),
    Utilities = Window:Section({ Title = "QQ1693323219", Opened = true })
}

local Tab = Tabs.Main:Tab({
    Title = "通用",
    Icon = "settings",
    Locked = false,
})

local Toggle = Tab:Toggle({
    Title = "快跑开关",
    Desc = "开关",
    Locked = false,
    Default = false,
    Callback = function(v)
        if v == true then
            sudu = game:GetService("RunService").Heartbeat:Connect(function()
                if game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character.Humanoid and game:GetService("Players").LocalPlayer.Character.Humanoid.Parent then
                    if game:GetService("Players").LocalPlayer.Character.Humanoid.MoveDirection.Magnitude > 0 then
                        game:GetService("Players").LocalPlayer.Character:TranslateBy(game:GetService("Players").LocalPlayer.Character.Humanoid.MoveDirection * Speed / 10)
                    end
                end
            end)
        elseif not v and sudu then
            sudu:Disconnect()
            sudu = nil
        end
    end
})

local Slider = Tab:Slider({
    Title = "快速跑步『推荐调2』",
    Value = {
        Min = 1,
        Max = 10,
        Default = 1,
    },
    Increment = 0.1,
    Callback = function(king)
        local tspeed = king
        local hb = game:GetService("RunService").Heartbeat
        local tpwalking = true
        local player = game:GetService("Players")
        local lplr = player.LocalPlayer
        local chr = lplr.Character
        local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
        while tpwalking and hb:Wait() and chr and hum and hum.Parent do
            if hum.MoveDirection.Magnitude > 0 then
                if tspeed then
                    chr:TranslateBy(hum.MoveDirection * tonumber(tspeed))
                else
                    chr:TranslateBy(hum.MoveDirection)
                end
            end
        end
    end
})

local Slider = Tab:Slider({
    Title = "移动速度",
    Min = 1,
    Max = 600,
    Default = game.Players.LocalPlayer.Character.Humanoid.WalkSpeed,
    Callback = function(a)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = a
    end
})

local Slider = Tab:Slider({
    Title = "跳跃高度",
    Min = 1,
    Max = 600,
    Default = game.Players.LocalPlayer.Character.Humanoid.JumpPower,
    Callback = function(a)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = a
    end
})

local Slider = Tab:Slider({
    Title = "重力设置",
    Min = 1,
    Max = 500,
    Default = workspace.Gravity,
    Callback = function(a)
        workspace.Gravity = a
    end
})

local Slider = Tab:Slider({
    Title = "视野缩放距离",
    Min = 0,
    Max = 2500,
    Default = game:GetService("Players").LocalPlayer.CameraMaxZoomDistance,
    Callback = function(value)
        game:GetService("Players").LocalPlayer.CameraMaxZoomDistance = value
    end
})

local Slider = Tab:Slider({
    Title = "广角设置",
    Min = 1,
    Max = 120,
    Default = fovValue,
    Callback = function(value)
        fovValue = value
        workspace.CurrentCamera.FieldOfView = value
    end
})

local Slider = Tab:Slider({
    Title = "设置血量",
    Min = 0,
    Max = 999999999,
    Default = game.Players.LocalPlayer.Character.Humanoid.Health,
    Callback = function(value)
        local numValue = tonumber(value)
        if numValue and numValue >= 0 then
            local character = game.Players.LocalPlayer.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.Health = numValue
                WindUI:Notify({Title = "血量设置", Content = "血量已设置为: " .. numValue})
            else
                WindUI:Notify({Title = "错误", Content = "角色或Humanoid不存在"})
            end
        else
            WindUI:Notify({Title = "错误", Content = "请输入有效的数字 (≥ 0)"})
        end
    end
})

local Button = Tab:Button({
    Title = "恢复视野",
    Callback = function()
        Workspace.CurrentCamera.FieldOfView = 70
    end
})

local Button = Tab:Button({
    Title = "最大视野缩放",
    Callback = function()
        game:GetService("Players").LocalPlayer.CameraMaxZoomDistance = 200000
    end
})

local Button = Tab:Button({
    Title = "视野缩放128",
    Callback = function()
        game:GetService("Players").LocalPlayer.CameraMaxZoomDistance = 128
    end
})

local Tab = Tabs.Main:Tab({
    Title = "变身",
    Icon = "settings",
    Locked = false,
})

local Button = Tab:Button({
    Title = "John doe forsaken变身",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-John-doe-forsaken-v1-58705"))()
    end
})

local Button = Tab:Button({
    Title = "无敌大摆锤变身",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Ban-Hammer-Script-58232"))()
    end
})

local Button = Tab:Button({
    Title = "Lua Hammer变身",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Lua-Hammer-56507"))()
    end
})

local Button = Tab:Button({
    Title = "Ban hammer变身",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Ban-hammer-v0-47112"))()
    end
})

local Button = Tab:Button({
    Title = "变身脚本5",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/JwUdxg8y"))()
    end
})

local Button = Tab:Button({
    Title = "忍者键盘变身",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/gObl00x/Pendulum-Fixed-AND-Others-Scripts/refs/heads/main/Server%20Admin"))()
    end
})

local Button = Tab:Button({
    Title = "Caducus The fallen god变身",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-FE-Caducus-The-fallen-god-REQUIRES-REANIMATION-TO-WORK-47600"))()
    end
})

local Button = Tab:Button({
    Title = "Brick Hamman变身",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Brick-Hamman-Converted-49804"))()
    end
})

local Button = Tab:Button({
    Title = "Hacker X变身",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ian49972/SCRIPTS/refs/heads/main/Hacker%20X"))()
    end
})

local Button = Tab:Button({
    Title = "变身脚本10",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/m7r4Qeu1"))()
    end
})

local Button = Tab:Button({
    Title = "变身脚本11",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/TEST19983/Reslasjd/refs/heads/main/attac"))()
    end
})

local Button = Tab:Button({
    Title = "托马斯火车变身",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Sugm4Bullet1/LuaXXccL/refs/heads/main/Thomas"))()
    end
})

local Button = Tab:Button({
    Title = "Banisher变身",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/retpirato/Roblox-Scripts/refs/heads/master/Banisher.lua"))()
    end
})

local Button = Tab:Button({
    Title = "Studio Dummy变身",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ian49972/SCRIPTS/refs/heads/main/Studio%20Dummy"))()
    end
})

local Button = Tab:Button({
    Title = "变身脚本15",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/XNVWznPH"))()
    end
})

local Button = Tab:Button({
    Title = "Soul Reaper变身",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/gObl00x/My-Converts/refs/heads/main/Soul%20Reaper.lua"))()
    end
})

local Button = Tab:Button({
    Title = "Sin Unleashed变身",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/gitezgitgit/Sin-Unleashed/refs/heads/main/Sin%20Unleashed.lua.txt"))()
    end
})

local Button = Tab:Button({
    Title = "Shadow Ravager变身",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/retpirato/Roblox-Scripts/refs/heads/master/Shadow%20Ravager.lua"))()
    end
})

local Button = Tab:Button({
    Title = "小丑变身",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/HappyCow91/RobloxScripts/refs/heads/main/ClientSided/clown.lua"))()
    end
})

local Button = Tab:Button({
    Title = "RUIN IX变身",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ian49972/SCRIPTS/refs/heads/main/RUIN%20IX"))()
    end
})

local Button = Tab:Button({
    Title = "RUIN EX变身",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ian49972/SCRIPTS/refs/heads/main/RUIN%20EX"))()
    end
})

local Button = Tab:Button({
    Title = "变身脚本22",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/KPYbrH1C"))()
    end
})

local Button = Tab:Button({
    Title = "Red Sword Pickaxe变身",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ProBypasserHax1/Idkkk/refs/heads/main/Red%20Sword%20Pickaxe.txt"))()
    end
})

local Button = Tab:Button({
    Title = "revenge hands变身",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/nicolasbarbosa323/sin-dragon/refs/heads/main/reevenge%20hands.txt"))()
    end
})

local Button = Tab:Button({
    Title = "Project 44033514变身",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/gitezgitgit/Project-2044033514/refs/heads/main/Project%2044033514.lua.txt"))()
    end
})

local Button = Tab:Button({
    Title = "变身脚本26",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/CtVFoMMq/raw"))()
    end
})

local Button = Tab:Button({
    Title = "pandora变身",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ian49972/SCRIPTS/refs/heads/main/pandora"))()
    end
})

local Button = Tab:Button({
    Title = "Omni God变身",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ian49972/SCRIPTS/refs/heads/main/Omni%20God"))()
    end
})

local Button = Tab:Button({
    Title = "Mr.Pixels变身",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/gObl00x/My-Converts/refs/heads/main/Mr.Pixels.lua"))()
    end
})

local Button = Tab:Button({
    Title = "Mr.Bye Bye变身",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/gObl00x/My-Converts/refs/heads/main/Mr.Bye%20Bye.lua"))()
    end
})

local Button = Tab:Button({
    Title = "Client Replication变身",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Client-Replication-the-ss-loadstring-script-27393"))()
    end
})

local Button = Tab:Button({
    Title = "Lost Hope Scythe变身",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/gObl00x/My-Converts/refs/heads/main/Lost%20Hope%20Scythe.lua"))()
    end
})

local Button = Tab:Button({
    Title = "kitcher gun变身",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/nicolasbarbosa323/rare/refs/heads/main/kitcher%20gun.lua"))()
    end
})

local Button = Tab:Button({
    Title = "Kirito Blades变身",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/nicolasbarbosa323/the-angel/refs/heads/main/Kirito%20Blades.txt"))()
    end
})

local Button = Tab:Button({
    Title = "变身脚本35",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/yraarJ7m"))()
    end
})

local Button = Tab:Button({
    Title = "Internal War变身",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/gObl00x/My-Converts/refs/heads/main/Internal%20War.lua"))()
    end
})

local Button = Tab:Button({
    Title = "Incension Reborn变身",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ian49972/SCRIPTS/refs/heads/main/Incension%20Reborn"))()
    end
})

local Button = Tab:Button({
    Title = "Genkadda omega变身",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/nicolasbarbosa323/grakkeda/refs/heads/main/Roblox%20Genkadda%20omega%20leaked.txt"))()
    end
})

local Tab = Tabs.Main:Tab({
    Title = "泰坦训练模拟器",
    Icon = "settings",
    Locked = false,
})

local Button = Tab:Button({
   Title = "世界 1",
   Callback = function()
      game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1203.50305, 840.185364, 918.393005, 0, -1, 0, 1, 0, -0, 0, 0, 1)
   end,
})

local Button = Tab:Button({
   Title = "世界 2",
   Callback = function()
      game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(11219.3359, 841.420715, 712.564453, 0, 1, 0, 1, 0, 0, 0, 0, -1)
   end,
})

local Button = Tab:Button({
   Title = "竞技场",
   Callback = function()
      game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-9118.18945, 854.962524, 840.383057, 0, -1, 0, 1, 0, -0, 0, 0, 1)
   end,
})

local Button = Tab:Button({
   Title = "蜜蜂蛋 (需要：250钻石)",
   Callback = function()
      local args = {"Egg_1_1", 1}
      game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.5.1"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("EggHatchService"):WaitForChild("RE"):WaitForChild("Hatch"):FireServer(unpack(args))
   end,
})

local Button = Tab:Button({
   Title = "水果蛋 (需要：3500钻石)",
   Callback = function()
      local args = {"Egg_1_2", 1}
      game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.5.1"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("EggHatchService"):WaitForChild("RE"):WaitForChild("Hatch"):FireServer(unpack(args))
      game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(11219.3359, 841.420715, 712.564453, 0, 1, 0, 1, 0, 0, 0, 0, -1)
   end,
})

local Button = Tab:Button({
   Title = "天使蛋 (需要：25000钻石)",
   Callback = function()
      local args = {"Egg_1_3", 1}
      game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.5.1"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("EggHatchService"):WaitForChild("RE"):WaitForChild("Hatch"):FireServer(unpack(args))
   end,
})

local Button = Tab:Button({
   Title = "死神蛋 (需要：50击杀)",
   Callback = function()
      local args = {"Egg_1_4", 1}
      game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.5.1"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("EggHatchService"):WaitForChild("RE"):WaitForChild("Hatch"):FireServer(unpack(args))
   end,
})

local Button = Tab:Button({
   Title = "梦魇蛋 (需要：300000钻石)",
   Callback = function()
      local args = {"Egg_1_5", 1}
      game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.5.1"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("EggHatchService"):WaitForChild("RE"):WaitForChild("Hatch"):FireServer(unpack(args))
   end,
})

local Button = Tab:Button({
   Title = "死亡蛋 (需要：16分钟)",
   Callback = function()
      game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.5.1"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("OnlineRewardService"):WaitForChild("RF"):WaitForChild("ClaimOnlineQuestReward"):InvokeServer()
   end,
})

local Button = Tab:Button({
   Title = "万圣节蛋 (需要：25分钟)",
   Callback = function()
      game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.5.1"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("OnlineRewardService"):WaitForChild("RF"):WaitForChild("ClaimHalloweenQuestReward"):InvokeServer()
   end,
})

local Button = Tab:Button({
   Title = "开启自动刷取",
   Callback = function()
      while true do 
         game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_knit@1.5.1").knit.Services.TrainService.RE.Train:FireServer() 
         wait(0.001) 
      end
   end,
})

local Button = Tab:Button({
   Title = "超级转生界面",
   Callback = function()
      game:GetService("Players").LocalPlayer.PlayerGui.SuperRebirthGui.Enabled = true
   end,
})

local Button = Tab:Button({
   Title = "升级转生界面",
   Callback = function()
      game:GetService("Players").LocalPlayer.PlayerGui.RebirthUpgradeGui.Enabled = true
   end,
})

local Button = Tab:Button({
   Title = "装备扭蛋",
   Callback = function()
      game:GetService("Players").LocalPlayer.PlayerGui.EventGui.Enabled = true
   end,
})

local Button = Tab:Button({
   Title = "万圣节活动",
   Callback = function()
      game:GetService("Players").LocalPlayer.PlayerGui.HalloweenQuestGui.Enabled = true
   end,
})

local Button = Tab:Button({
   Title = "长期每日奖励",
   Callback = function()
      game:GetService("Players").LocalPlayer.PlayerGui.LongDailyRewardGui.Enabled = true
   end,
})

local Button = Tab:Button({
   Title = "科技界面",
   Callback = function()
      game:GetService("Players").LocalPlayer.PlayerGui.ItemGui.Enabled = true
   end,
})

local Button = Tab:Button({
   Title = "快速旋转",
   Callback = function()
      game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.5.1"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("SpinningWheelService"):WaitForChild("RF"):WaitForChild("StartSpin"):InvokeServer()
   end,
})

local Button = Tab:Button({
   Title = "宠物图鉴",
   Callback = function()
      game:GetService("Players").LocalPlayer.PlayerGui.PetIndexGui.Enabled = true
   end,
})

local Tab = Tabs.Main:Tab({
    Title = "俄亥俄州",
    Icon = "settings",
    Locked = false,
})

local Dropdown = Tab:Dropdown({
    Title = "选择一个r15动画包",
    Values = { 
        "吸血鬼", "英雄", "经典僵尸", "法师", "幽灵", 
        "长者", "漂浮", "宇航员", "忍者", "狼人", 
        "卡通", "海盗", "潜行", "玩具", "骑士", 
        "自信", "流行明星", "公主", "牛仔", "巡逻", 
        "僵尸FE"
    },
    Callback = function(Value) 
        if not plr.Character or not plr.Character:FindFirstChild("Animate") then
            return
        end
        
        local Animate = plr.Character.Animate
        Animate.Disabled = true
        StopAnim()
        
        if Value == "吸血鬼" then
            Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=1083445855"
            Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=1083450166"
            Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=1083473930"
            Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=1083462077"
            Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=1083455352"
            Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=1083439238"
            Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=1083443587"
        elseif Value == "英雄" then
            Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=616111295"
            Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=616113536"
            Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=616122287"
            Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=616117076"
            Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=616115533"
            Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=616104706"
            Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=616108001"
        elseif Value == "经典僵尸" then
            Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=616158929"
            Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=616160636"
            Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=616168032"
            Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=616163682"
            Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=616161997"
            Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=616156119"
            Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=616157476"
        elseif Value == "法师" then
            Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=707742142"
            Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=707855907"
            Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=707897309"
            Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=707861613"
            Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=707853694"
            Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=707826056"
            Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=707829716"
        elseif Value == "幽灵" then
            Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=616006778"
            Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=616008087"
            Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=616010382"
            Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=616013216"
            Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=616008936"
            Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=616003713"
            Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=616005863"
        elseif Value == "长者" then
            Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=845397899"
            Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=845400520"
            Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=845403856"
            Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=845386501"
            Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=845398858"
            Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=845392038"
            Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=845396048"
        elseif Value == "漂浮" then
            Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=616006778"
            Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=616008087"
            Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=616013216"
            Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=616010382"
            Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=616008936"
            Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=616003713"
            Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=616005863"
        elseif Value == "宇航员" then
            Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=891621366"
            Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=891633237"
            Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=891667138"
            Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=891636393"
            Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=891627522"
            Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=891609353"
            Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=891617961"
        elseif Value == "忍者" then
            Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=656117400"
            Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=656118341"
            Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=656121766"
            Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=656118852"
            Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=656117878"
            Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=656114359"
            Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=656115606"
        elseif Value == "狼人" then
            Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=1083195517"
            Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=1083214717"
            Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=1083178339"
            Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=1083216690"
            Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=1083218792"
            Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=1083182000"
            Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=1083189019"
        elseif Value == "卡通" then
            Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=742637544"
            Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=742638445"
            Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=742640026"
            Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=742638842"
            Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=742637942"
            Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=742636889"
            Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=742637151"
        elseif Value == "海盗" then
            Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=750781874"
            Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=750782770"
            Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=750785693"
            Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=750783738"
            Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=750782230"
            Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=750779899"
            Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=750780242"
        elseif Value == "潜行" then
            Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=1132473842"
            Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=1132477671"
            Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=1132510133"
            Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=1132494274"
            Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=1132489853"
            Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=1132461372"
            Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=1132469004"
        elseif Value == "玩具" then
            Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=782841498"
            Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=782845736"
            Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=782843345"
            Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=782842708"
            Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=782847020"
            Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=782843869"
            Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=782846423"
        elseif Value == "骑士" then
            Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=657595757"
            Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=657568135"
            Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=657552124"
            Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=657564596"
            Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=658409194"
            Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=658360781"
            Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=657600338"
        elseif Value == "自信" then
            Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=1069977950"
            Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=1069987858"
            Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=1070017263"
            Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=1070001516"
            Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=1069984524"
            Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=1069946257"
            Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=1069973677"
        elseif Value == "流行明星" then
            Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=1212900985"
            Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=1212900985"
            Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=1212980338"
            Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=1212980348"
            Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=1212954642"
            Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=1213044953"
            Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=1212900995"
        elseif Value == "公主" then
            Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=941003647"
            Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=941013098"
            Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=941028902"
            Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=941015281"
            Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=941008832"
            Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=940996062"
            Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=941000007"
        elseif Value == "牛仔" then
            Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=1014390418"
            Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=1014398616"
            Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=1014421541"
            Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=1014401683"
            Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=1014394726"
            Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=1014380606"
            Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=1014384571"
        elseif Value == "巡逻" then
            Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=1149612882"
            Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=1150842221"
            Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=1151231493"
            Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=1150967949"
            Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=1150944216"
            Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=1148811837"
            Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=1148863382"
        elseif Value == "僵尸FE" then
            Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=3489171152"
            Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=3489171152"
            Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=3489174223"
            Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=3489173414"
            Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=616161997"
            Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=616156119"
            Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=616157476"
        end
        
        if plr.Character and plr.Character:FindFirstChild("Humanoid") then
            plr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
        Animate.Disabled = false
    end
})

local Slider = Tab:Slider({
    Title = "移动速度",
    Min = 1,
    Max = 15,
    Default = 1,
    Callback = function(value) 
        speed = value
    end
})

local Toggle = Tab:Toggle({
    Title = "启动加速",
    Default = false,
    Callback = function(state) 
        if state then
            startTPWalk()
        else
            stopTPWalk()
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "启动连跳",
    Default = false,
    Callback = function(state) 
        if state then
            if flyjump then flyjump:Disconnect() end
            flyjump = UserInputService.JumpRequest:Connect(function()
                local character = speaker.Character
                if character then
                    local humanoid = character:FindFirstChildWhichIsA("Humanoid")
                    if humanoid then
                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end)
        else
            if flyjump then
                flyjump:Disconnect()
                flyjump = nil
            end
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "反管理[如有遗留 请提出]",
    Default = false,
    Callback = function(state) 
        antiadmin = state
    end
})

local Dropdown = Tab:Dropdown({
    Title = "选择一个攻击方式",
    Values = { "超级拳", "普通拳", "踢", "飞踢"},
    Callback = function(Value) 
        if Value == "超级拳" then
            hitMOD = "meleemegapunch"
        elseif Value == "普通拳" then
            hitMOD = "meleepunch"
        elseif Value == "踢" then
            hitMOD = "meleekick"
        elseif Value == "飞踢" then
            hitMOD = "meleejumpKick"
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "启动杀戮",
    Default = false,
    Callback = function(state) 
        autokill = state
    end
})

local Toggle = Tab:Toggle({
    Title = "启动踩踏",
    Default = false,
    Callback = function(state) 
        autostomp = state
    end
})

local Toggle = Tab:Toggle({
    Title = "启动抓取",
    Default = false,
    Callback = function(state) 
        grabplay = state
    end
})

local Dropdown = Tab:Dropdown({
    Title = "选择一个护甲类型",
    Values = { "轻型护甲100", "重型护甲2000", "军用护甲3500", "EOD护甲7500"},
    Callback = function(Value) 
        if Value == "轻型护甲100" then
            jiahit = "Light Vest"
        elseif Value == "重型护甲2000" then
            jiahit = "Heavy Vest"
        elseif Value == "军用护甲3500" then
            jiahit = "Military Vest"
        elseif Value == "EOD护甲7500" then
            jiahit = "EOD Vest"
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "自动穿甲",
    Default = false,
    Callback = function(state) 
        autojia = state
    end
})

local Toggle = Tab:Toggle({
    Title = "自动装备拳头",
    Default = false,
    Callback = function(state) 
        autoFists = state
    end
})

local Toggle = Tab:Toggle({
    Title = "防倒地",
    Default = false,
    Callback = function(Value)
        AutoKnockReset = Value
        if Value then
            task.spawn(function()
                while AutoKnockReset do
                    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
                        melee.Set(lp, "knocked", false)
                        melee.Replicate("knocked")
                    end
                    wait()
                end
            end)
        end
    end
})

local Dropdown = Tab:Dropdown({
    Title = "选择回血物品",
    Values = {"绷带", "饼干"},
    Callback = function(option)
        if option == "绷带" then
            selectedHealItem = "Bandage"
        elseif option == "饼干" then
            selectedHealItem = "Cookie"
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "自动回血",
    Default = false,
    Callback = function(Value)
        if healThread then
            task.cancel(healThread)
            healThread = nil
        end

        if Value then
            healThread = task.spawn(function()
                while true do
                    task.wait()
                    Signal.InvokeServer("attemptPurchase", selectedHealItem)
                    for _, v in next, b1 do
                        if v.name == selectedHealItem then
                            local healItemGuid = v.guid
                            local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                            local Humanoid = Character:WaitForChild('Humanoid')
                            if Humanoid.Health >= 38 and Humanoid.Health < Humanoid.MaxHealth then
                                Signal.FireServer("equip", healItemGuid)
                                Signal.FireServer("useConsumable", healItemGuid)
                                Signal.FireServer("removeItem", healItemGuid)
                            end
                            break
                        end
                    end
                end
            end)
        end
    end
})

local Dropdown = Tab:Dropdown({
    Title = "选择口罩类型",
    Values = {"口罩", "小丑面具", "蓝色头巾", "黑色头巾", "红色头巾"},
    Callback = function(option)
        if option == "口罩" then
            selectedMask = "Surgeon Mask"
        elseif option == "小丑面具" then
            selectedMask = "Hockey Mask"
        elseif option == "蓝色头巾" then
            selectedMask = "Blue Bandana"
        elseif option == "黑色头巾" then
            selectedMask = "Black Bandana"
        elseif option == "红色头巾" then
            selectedMask = "Red Bandana"
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "自动口罩(多种)",
    Default = false,
    Callback = function(Value)
        autoMaskEnabled2 = Value
        
        if not Value then return end
        
        task.spawn(function()
            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer
            local Signal = require(game:GetService("ReplicatedStorage").devv).load("Signal")
            local item = require(game:GetService("ReplicatedStorage").devv).load("v3item")

            local function purchaseAndEquipMask()
                if not autoMaskEnabled2 then return end
                
                local hasMask = false
                for _, v in pairs(item.inventory.items) do
                    if v.name == selectedMask then
                        hasMask = true
                        break
                    end
                end

                if not hasMask then
                    Signal.InvokeServer("attemptPurchase", selectedMask)
                    task.wait()
                end

                for _, v in pairs(item.inventory.items) do
                    if v.name == selectedMask then
                        Signal.FireServer("equip", v.guid)
                        Signal.FireServer("wearMask", v.guid)
                        break
                    end
                end
            end

            purchaseAndEquipMask()

            local conn
            conn = LocalPlayer.CharacterAdded:Connect(function(char)
                char:WaitForChild("HumanoidRootPart")
                task.wait()
                purchaseAndEquipMask()
            end)

            while autoMaskEnabled2 do
                task.wait()
            end

            if conn then conn:Disconnect() end
        end)
    end
})

local Button = Tab:Button({
    Title = "变身警察",
    Callback = function()
        local function fastInteractProximityPrompt(proximityPrompt)
            if not proximityPrompt or not proximityPrompt:IsA("ProximityPrompt") then
                return false
            end
            
            local originalRequiresLineOfSight = proximityPrompt.RequiresLineOfSight
            local originalHoldDuration = proximityPrompt.HoldDuration
            
            proximityPrompt.RequiresLineOfSight = false
            proximityPrompt.HoldDuration = 0
            
            for i = 1, 5 do
                fireproximityprompt(proximityPrompt)
                task.wait(0.01)
            end
            
            proximityPrompt.RequiresLineOfSight = originalRequiresLineOfSight
            proximityPrompt.HoldDuration = originalHoldDuration
            
            return true
        end

        local function interactAtPosition(position)
            local Players = game:GetService("Players")
            local localPlayer = Players.LocalPlayer
            local character = localPlayer.Character
            if not character then return false end
            
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if not rootPart then return false end
            
            local originalPosition = rootPart.CFrame
            
            rootPart.CFrame = CFrame.new(position)
            task.wait(0.2) 
            
            local closestPrompt = nil
            local closestDistance = math.huge
            
            for _, prompt in pairs(workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") then
                    local promptParent = prompt.Parent
                    if promptParent and (promptParent:IsA("MeshPart") or promptParent:IsA("Part")) then
                        local distance = (rootPart.Position - promptParent.Position).Magnitude
                        
                        if distance < closestDistance then
                            closestDistance = distance
                            closestPrompt = prompt
                        end
                    end
                end
            end
            
            local interacted = false
            if closestPrompt then
                interacted = fastInteractProximityPrompt(closestPrompt)
            end
            rootPart.CFrame = originalPosition
            
            return interacted
        end
        interactAtPosition(Vector3.new(580.19, 26.67, -873.15))
        interactAtPosition(Vector3.new(587.30, 26.66, -871.14))
    end
})

local Button = Tab:Button({
    Title = "小丑头套",
    Callback = function()
        local function fastInteractProximityPrompt(proximityPrompt)
            if not proximityPrompt or not proximityPrompt:IsA("ProximityPrompt") then
                return false
            end
            
            local originalRequiresLineOfSight = proximityPrompt.RequiresLineOfSight
            local originalHoldDuration = proximityPrompt.HoldDuration
            
            proximityPrompt.RequiresLineOfSight = false
            proximityPrompt.HoldDuration = 0
            
            for i = 1, 5 do
                fireproximityprompt(proximityPrompt)
                task.wait(0.01)
            end
            
            proximityPrompt.RequiresLineOfSight = originalRequiresLineOfSight
            proximityPrompt.HoldDuration = originalHoldDuration
            
            return true
        end

        local function interactAtPosition(position)
            local Players = game:GetService("Players")
            local localPlayer = Players.LocalPlayer
            local character = localPlayer.Character
            if not character then return false end
            
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if not rootPart then return false end
            
            local originalPosition = rootPart.CFrame
            
            rootPart.CFrame = CFrame.new(position)
            task.wait(0.2) 
            
            local closestPrompt = nil
            local closestDistance = math.huge
            
            for _, prompt in pairs(workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") then
                    local promptParent = prompt.Parent
                    if promptParent and (promptParent:IsA("MeshPart") or promptParent:IsA("Part")) then
                        local distance = (rootPart.Position - promptParent.Position).Magnitude
                        
                        if distance < closestDistance then
                            closestDistance = distance
                            closestPrompt = prompt
                        end
                    end
                end
            end
            
            local interacted = false
            if closestPrompt then
                interacted = fastInteractProximityPrompt(closestPrompt)
            end
            rootPart.CFrame = originalPosition
            
            return interacted
        end
        interactAtPosition(Vector3.new(1124.44, 16.84, 113.32))
    end
})

local Toggle = Tab:Toggle({
    Title = "自动全图ATM",
    Default = false,
    Callback = function(state) 
        autoATM = state
        if autoATM then
            while autoATM and task.wait() do
                local ATMsFolder = workspace:FindFirstChild("ATMs")
                local Players = game:GetService("Players")
                local localPlayer = Players.LocalPlayer

                if ATMsFolder and localPlayer.Character then
                    for _, atm in ipairs(ATMsFolder:GetChildren()) do
                        if atm:IsA("Model") then
                            local hp = atm:GetAttribute("health")
                            if hp ~= 0 then
                                for _, part in ipairs(atm:GetChildren()) do
                                    if part.Name == "Main" and part:IsA("BasePart") then
                                        localPlayer.Character.HumanoidRootPart.CFrame = part.CFrame
                                        wait(0.1)
                                        atm:SetAttribute("health", 0)
                                        break
                                    end
                                end
                                break
                            end
                        end
                    end
                end
            end
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "自动全图活动道具",
    Default = false,
    Callback = function(state) 
        autoWSJDJ = state
        if autoWSJDJ then
            while autoWSJDJ and task.wait() do
                local WSJHD = workspace:FindFirstChild("Halloween")
                local Players = game:GetService("Players")
                local localPlayer = Players.LocalPlayer

                if WSJHD and localPlayer.Character then
                    for _, WSJRW in ipairs(WSJHD:GetChildren()) do
                        if WSJRW:IsA("Model") then
                            local hp = WSJRW:GetAttribute("health")
                            if hp ~= 0 then
                                for _, part in ipairs(WSJRW:GetChildren()) do
                                    if part.Name == "Hitbox" and part:IsA("BasePart") then
                                        localPlayer.Character.HumanoidRootPart.CFrame = part.CFrame
                                        wait(0.5)
                                        WSJRW:SetAttribute("health", 0)
                                        wait(0.5)
                                        break
                                    end
                                end
                                break
                            end
                        end
                    end
                end
            end
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "自动捡全图糖果",
    Default = false,
    Callback = function(state) 
        autocandy = state
    end
})

local Toggle = Tab:Toggle({
    Title = "自动捡全图现金",
    Default = false,
    Callback = function(state) 
        autocash1 = state
    end
})

local Toggle = Tab:Toggle({
    Title = "自动抢银行",
    Default = false,
    Callback = function(state) 
        autobank = state
    end
})

local Toggle = Tab:Toggle({
    Title = "自动抢戒指",
    Default = false,
    Callback = function(state) 
        autoring11 = state
    end
})

local Toggle = Tab:Toggle({
    Title = "自动拾取贵重物品",
    Default = false,
    Callback = function(state) 
        autogzwp = state
        if autogzwp then
            while autogzwp and wait() do 
                local Players = game:GetService("Players")
                local localPlayer = Players.LocalPlayer
                local rootPart = localPlayer.Character.HumanoidRootPart
                for _, l in pairs(game.Workspace.Game.Entities.ItemPickup:GetChildren()) do
                    for _, v in pairs(l:GetChildren()) do
                        if v:IsA("MeshPart") or v:IsA("Part") then
                            local e = v:FindFirstChildOfClass("ProximityPrompt")
                            if e and (e.ObjectText == "Green Lucky Block" or e.ObjectText == "Orange Lucky Block" or e.ObjectText == "Purple Lucky Block" or e.ObjectText == "Blue Candy Cane" or e.ObjectText == "Suitcase Nuke" or e.ObjectText == "Nuke Launcher" or e.ObjectText == "Easter Basket" or e.ObjectText == "Gold Cup" or e.ObjectText == "Gold Crown" or e.ObjectText == "Pearl Necklace" or e.ObjectText == "Treasure Map"or e.ObjectText == "Spectral Scythe" or e.ObjectText == "Bunny Balloon" or e.ObjectText == "Ghost Balloon" or e.ObjectText == "Clover Balloon" or e.ObjectText == "Bat Balloon" or e.ObjectText == "Gold Clover Balloon" or e.ObjectText == "Golden Rose" or e.ObjectText == "Black Rose" or e.ObjectText == "Heart Balloon" or e.ObjectText == "Skull Balloon" or e.ObjectText == "Money Printer") then
                                rootPart.CFrame = v.CFrame * CFrame.new(0, 2, 0)
                                e.RequiresLineOfSight = false
                                e.HoldDuration = 0
                                fireproximityprompt(e)
                            end
                        end
                    end
                end
            end
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "自动拾取宝石",
    Default = false,
    Callback = function(state) 
        autobs = state
        if autobs then
            while autobs and wait() do 
                local Players = game:GetService("Players")
                local localPlayer = Players.LocalPlayer
                local rootPart = localPlayer.Character.HumanoidRootPart

                for _, l in pairs(game.Workspace.Game.Entities.ItemPickup:GetChildren()) do
                    for _, v in pairs(l:GetChildren()) do
                        if v:IsA("MeshPart") or v:IsA("Part") then
                            local e = v:FindFirstChildOfClass("ProximityPrompt")
                            if e and (e.ObjectText == "Amethyst" or e.ObjectText == "Sapphire" or e.ObjectText == "Emerald"  or e.ObjectText == "Topaz"  or e.ObjectText == "Ruby"  or e.ObjectText == "Diamond Ring"  or e.ObjectText == "Diamond" or e.ObjectText == "Void Gem" or e.ObjectText == "Dark Matter Gem" or e.ObjectText == "Rollie" or e.ObjectText == "Gold Bar") then
                                rootPart.CFrame = v.CFrame * CFrame.new(0, 2, 0)
                                e.RequiresLineOfSight = false
                                e.HoldDuration = 0
                                fireproximityprompt(e)
                            end
                        end
                    end
                end
            end
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "自动开启保险",
    Default = false,
    Callback = function(state) 
        bxbx = state
        if bxbx then
            while bxbx and wait() do  -- 每 0.1 秒检测一次（避免卡顿）
                local epoh2 = game:GetService("Players")
                local epoh3 = epoh2.LocalPlayer.Character.HumanoidRootPart
                local Players = game:GetService("Players")
                local localPlayer = Players.LocalPlayer
                if localPlayer.Character then
                    local rootPart = localPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        for _, obj in ipairs(workspace.Game.Entities.GoldJewelSafe:GetDescendants()) do
                            if obj:IsA("ProximityPrompt") and (obj.ActionText == "Crack Chest" or obj.ActionText == "Crack Safe") and obj.Enabled then
                                if bxbx then
                                    obj.RequiresLineOfSight = false -- 修改 RequiresLineOfSight 为 false
                                    obj.HoldDuration = 0 -- 修改 HoldDuration 为 0
                                    local target = obj.Parent and obj.Parent.Parent
                                    if target and target:IsA("BasePart") then
                                        local snow4 = target.CFrame * CFrame.new(0, 2, 2)
                                        local snow5 = game:GetService("Players")
                                        local snow6 = snow5.LocalPlayer.Character.HumanoidRootPart
                                        snow6.CFrame = snow4
                                        wait(0.5) -- 等待传送完成
                                        fireproximityprompt(obj) -- 触发 ProximityPrompt
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "自动购买撬锁",
    Default = false,
    Callback = function(state) 
        lock = state
        if lock then
            while lock and wait() do  -- 每 0.1 秒检测一次（避免卡顿）
                local Players = game:GetService("Players")
                local localPlayer = Players.LocalPlayer
                if localPlayer.Character then
                    local rootPart = localPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        Signal.InvokeServer("attemptPurchase", "Lockpick")
                    end
                end
            end
        end
    end
})

local Button = Tab:Button({
    Title = "绕过表情动作系统",
    Callback = function()
        for _, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Emotes.Frame.ScrollingFrame:GetDescendants()) do
            if v.Name == "Locked" then
                v.Visible = false
            end
        end
    end
})

local Button = Tab:Button({
    Title = "绕过移动经销商系统",
    Callback = function()
        game:GetService("Players").LocalPlayer:SetAttribute("mobileDealer",true)local ReplicatedStorage=game:GetService("ReplicatedStorage")local mobileDealer=require(ReplicatedStorage.devv.shared.Indicies.mobileDealer)for category,items in pairs(mobileDealer)do for _,item in ipairs(items)do item.stock=999999 end end local ReplicatedStorage=game:GetService("ReplicatedStorage")local mobileDealer=require(ReplicatedStorage.devv.shared.Indicies.mobileDealer)table.insert(mobileDealer.Gun,{itemName="Acid Gun",stock=999999})table.insert(mobileDealer.Gun,{itemName="Candy Bucket",stock=999999})
    end
})

local Button = Tab:Button({
    Title = "绕过战斗状态系统",
    Callback = function()
        for _, func in pairs(getgc(true)) do
            if type(func) == "function" then
                local info = debug.getinfo(func)
                if info.name == "isInCombat" or (info.source and info.source:find("combatIndicator")) then
                    hookfunction(func, function() 
                        return false 
                    end)
                end
            end
        end
    end
})

local Button = Tab:Button({
    Title = "普通气球美化美金气球",
    Callback = function()
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" and rawget(v, "name") == "Balloon" and rawget(v, "holdableType") == "Balloon" then
                v.name, v.cost, v.unpurchasable, v.multiplier, v.movespeedAdd, v.cannotDiscard = "Dollar Balloon", 200, true, 0.8, 8, true
                if v.TPSOffsets then v.TPSOffsets.hold = CFrame.new(0, 0, 0) * CFrame.Angles(0, math.pi, 0) end
                if v.viewportOffsets and v.viewportOffsets.hotbar then v.viewportOffsets.hotbar.dist = 4 end
                v.canDrop, v.dropCooldown, v.craft = nil
                break
            end
        end

        for _, item in pairs(require(game.ReplicatedStorage.devv.client.Objects.v3item.modules.inventory).items) do
            if item.name == "Dollar Balloon" then
                for _, btn in pairs({item.button, item.backpackButton}) do
                    if btn and btn.resetModelSkin then btn:resetModelSkin() end
                end
            end
        end
    end
})

local Button = Tab:Button({
    Title = "普通气球美化黑玫瑰气球",
    Callback = function()
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" and rawget(v, "name") == "Balloon" and rawget(v, "holdableType") == "Balloon" then
                v.name, v.cost, v.unpurchasable, v.multiplier, v.movespeedAdd, v.cannotDiscard = "Black Rose", 200, true, 0.75, 12, true
                if v.TPSOffsets then v.TPSOffsets.hold = CFrame.new(0, 0.5, 0) end
                if v.viewportOffsets and v.viewportOffsets.hotbar then v.viewportOffsets.hotbar.dist = 3 end
                v.canDrop, v.dropCooldown, v.craft = nil
                break
            end
        end

        for _, item in pairs(require(game.ReplicatedStorage.devv.client.Objects.v3item.modules.inventory).items) do
            if item.name == "Black Rose" then
                for _, btn in pairs({item.button, item.backpackButton}) do
                    if btn and btn.resetModelSkin then btn:resetModelSkin() end
                end
            end
        end
    end
})

local Button = Tab:Button({
    Title = "美化钱包",
    Callback = function()
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" and rawget(v, "name") == "Wallet" then
                v.name = "Duffel Bag"
                v.modelName = "Duffel Bag"
                v.subtype = "Wallet"
                if v.TPSOffsets then
                    v.TPSOffsets.hold = CFrame.new(-0.1, -1, 0.1)
                end
                if v.viewportOffsets and v.viewportOffsets.hotbar then
                    v.viewportOffsets.hotbar.offset = CFrame.new(0.1, 0.2, -2.5)
                    v.viewportOffsets.hotbar.rotoffset = CFrame.Angles(0.7853981633974483, 2.6179938779914944, 0)
                end
                break
            end
        end

        local inventory = require(game.ReplicatedStorage.devv.client.Objects.v3item.modules.inventory)
        for _, item in pairs(inventory.items) do
            if item.name == "Duffel Bag" then
                if item.button and item.button.resetModelSkin then
                    item.button:resetModelSkin()
                end
                if item.backpackButton and item.backpackButton.resetModelSkin then
                    item.backpackButton:resetModelSkin()
                end
            end
        end
    end
})

local Button = Tab:Button({
    Title = "即时互动",
    Callback = function() 
        workspace.DescendantAdded:Connect(function(obj)
            if obj:IsA("ProximityPrompt") then
                obj.HoldDuration = 0
            end
        end)

        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                obj.HoldDuration = 0
            end
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "防虚空",
    Default = false,
    Callback = function(state)
        if state then
            -- 启用防虚空
            if antivoidloop then antivoidloop:Disconnect() end
            local OrgDestroyHeight = workspace.FallenPartsDestroyHeight
            antivoidloop = RunService.Stepped:Connect(function()
                local character = speaker.Character
                if character then
                    local root = getRoot(character)
                    if root and root.Position.Y <= OrgDestroyHeight + 25 then
                        root.Velocity = root.Velocity + Vector3.new(0, 250, 0)
                    end
                end
            end)
        else
            -- 关闭防虚空
            if antivoidloop then
                antivoidloop:Disconnect()
                antivoidloop = nil
            end
        end
    end
})
