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

local Tab = Tabs.Main:Tab({
    Title = "恶魔学",
    Icon = "settings",
    Locked = false,
})

local Button = Tab:Button({
    Title = "获取鬼魂当前房间",
    Callback = function()
        local crntroom = workspace:WaitForChild("Ghost"):GetAttribute("CurrentRoom")
        
        if stuff.sayInchat then
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("AskSpiritBoxFromUI"):FireServer(
                "鬼魂在"..string.lower(crntroom)
            )
        else
            WindUI:Notify({
                Title = "鬼魂信息",
                Content = crntroom,
                Duration = 5
            })
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "在聊天中显示鬼魂信息",
    Default = false,
    Callback = function(Value)
        stuff.sayInchat = Value
    end
})

local Toggle = Tab:Toggle({
    Title = "鬼魂接近通知(仅在狩猎时有效)",
    Default = false,
    Callback = function(Value)
        stuff.ghostSeePlayerEnabled = Value
        
        task.spawn(function()
            while stuff.ghostSeePlayerEnabled do
                task.wait(1)
                local distanceGhost = (workspace:WaitForChild("Ghost"):WaitForChild("HumanoidRootPart").Position - 
                    game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude

                if distanceGhost <= stuff.ghostSeePlayerDistance and distanceGhost >= 5 and 
                    workspace:WaitForChild("Ghost"):GetAttribute("Hunting") then
                    
                    WindUI:Notify({
                        Title = "鬼魂警告",
                        Content = "鬼魂距离你"..tostring(math.floor(distanceGhost)).."单位",
                        Duration = 3.5
                    })
                end
            end
        end)
    end
})

local Toggle = Tab:Toggle({
    Title = "鬼魂狩猎事件通知",
    Default = false,
    Callback = function(Value)
        if Value then
            stuff.warningHunt = workspace:WaitForChild("Ghost"):GetAttributeChangedSignal("Hunting"):Connect(function()
                if workspace:WaitForChild("Ghost"):GetAttribute("Hunting") == true then
                    WindUI:Notify({
                        Title = "狩猎警告",
                        Content = "鬼魂开始狩猎!",
                        Duration = 5
                    })
                else
                    WindUI:Notify({
                        Title = "狩猎警告",
                        Content = "鬼魂结束狩猎!",
                        Duration = 5
                    })
                end
            end)
        elseif stuff.warningHunt then
            stuff.warningHunt:Disconnect()
            stuff.warningHunt = nil
        end
    end
})

local Button = Tab:Button({
    Title = "触发所有盐堆",
    Callback = function()
        local SaltPiles = workspace.SaltPiles:GetChildren()
        local NormalPiles = {}
        
        for _, d in pairs(SaltPiles) do
            if d.Name == "SaltLine" then
                table.insert(NormalPiles, d)
            end
        end

        if #NormalPiles > 0 then
            for _, d in pairs(NormalPiles) do
                task.spawn(function()
                    firetouchinterest(workspace.Ghost.Torso, d:WaitForChild("GhostTracker"), 0)
                    firetouchinterest(workspace.Ghost.Torso, d:WaitForChild("GhostTracker"), 1)
                end)
            end
        else
            WindUI:Notify({
                Title = "盐堆触发",
                Content = "没有盐堆!",
                Duration = 3.5
            })
        end
    end
})

local Button = Tab:Button({
    Title = "检查是否为无头骑士",
    Callback = function()
        local isHeadless = workspace:WaitForChild("Ghost"):GetAttribute("Headless")
        
        WindUI:Notify({
            Title = "无头骑士检查",
            Content = isHeadless and "鬼魂是无头骑士!" or "鬼魂不是无头骑士",
            Duration = 3.5
        })
    end
})

local Button = Tab:Button({
    Title = "检查鬼魂球体",
    Callback = function()
        WindUI:Notify({
            Title = "鬼魂球体检查",
            Content = workspace:FindFirstChild("GhostOrb") and "有鬼魂球体" or "没有鬼魂球体",
            Duration = 3.5
        })
    end
})

local Button = Tab:Button({
    Title = "检查手印",
    Callback = function()
        WindUI:Notify({
            Title = "手印检查",
            Content = #workspace.Handprints:GetChildren() > 0 and "有手印" or "没有手印",
            Duration = 3.5
        })
    end
})

local Button = Tab:Button({
    Title = "检查激光可见性",
    Callback = function()
        local ghostLaserVisible = workspace:WaitForChild("Ghost"):GetAttribute("LaserVisible") and 
            workspace:WaitForChild("Ghost"):GetAttribute("Transparency") < 1
        
        WindUI:Notify({
            Title = "激光可见性检查",
            Content = ghostLaserVisible and "鬼魂对激光可见!" or 
                "鬼魂对激光不可见\n这可能是错误，请确保将激光投影仪放在鬼魂喜欢的房间",
            Duration = ghostLaserVisible and 3.5 or 7.5
        })
    end
})

local Toggle = Tab:Toggle({
    Title = "通知聊天消息",
    Default = false,
    Callback = function(Value)
        if Value then
            for _, d in pairs(game.Players:GetChildren()) do
                if d ~= game.Players.LocalPlayer then
                    stuff.playerChatted[d.Name] = d.Chatted:Connect(function(msg)
                        local topName = d.Name
                        
                        if workspace:WaitForChild("Ragdolls"):FindFirstChild(d.Name) then
                            topName = topName.. " (死亡)"
                        end
                        
                        WindUI:Notify({
                            Title = topName.." 说:",
                            Content = msg,
                            Duration = 10
                        })

                        if stuff.sayInchat2 then
                            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("AskSpiritBoxFromUI"):FireServer(
                                topName.." 说: ".. msg
                            )
                        end
                    end)
                end
            end
        else
            for _, d in pairs(stuff.playerChatted) do
                d:Disconnect()
            end
            stuff.playerChatted = {}
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "在聊天中通知消息",
    Default = false,
    Callback = function(Value)
        stuff.sayInchat2 = Value
    end
})

local Button = Tab:Button({
    Title = "使用激光扫描仪",
    Callback = function()
        local function ridarScan()
            local v1 = game:GetService("ReplicatedStorage")
            local v2 = game:GetService("UserInputService")
            local u3 = game:GetService("RunService")
            local u4 = game:GetService("Players").LocalPlayer
            local v5 = u4:WaitForChild("PlayerScripts")
            local u8 = v5:WaitForChild("Events")
            local u9 = workspace:FindFirstChild("LIDAR_V2") or Instance.new("Folder")
            local u10 = workspace.CurrentCamera
            local u11 = nil
            local u12 = false

            u9.Name = "LIDAR_V2"
            u9.Parent = workspace

            local function GenerateScreenPoints(p13, p14, p15)
                local v16 = p14 * p15
                local v17 = v16 * p13
                local v18 = math.ceil(v17)
                local v19 = v16 / v18
                local v20 = math.sqrt(v19)
                local v21 = p15 / v20
                local v22 = math.floor(v21)
                local v23 = p14 / v20
                local v24 = math.floor(v23)
                local v25 = {}
                for v26 = 0, v22 - 1 do
                    for v27 = 0, v24 - 1 do
                        if v18 <= #v25 then
                            break
                        end
                        local v28 = math.random
                        local v29 = v27 * v20
                        local v30 = (v27 + 1) * v20 - 1
                        local v31 = v28(v29, (math.min(v30, p14)))
                        local v32 = math.random
                        local v33 = v26 * v20
                        local v34 = (v26 + 1) * v20 - 1
                        local v35 = v32(v33, (math.min(v34, p15)))
                        local v36 = Vector2.new
                        table.insert(v25, v36(v31, v35))
                    end
                end
                return v25
            end

            local function GetColorFromScreenPosition(p37)
                local v38 = Vector2.new(u10.ViewportSize.X / 2, u10.ViewportSize.Y / 2)
                local v39 = (p37 - v38).Magnitude / (v38.Magnitude * 0.7)
                local v40 = math.clamp(v39, 0, 1)
                local v41
                if v40 < 0.5 then
                    local v42 = v40 * 2
                    v41 = Color3.new(1 - v42, v42, 0)
                else
                    local v43 = (v40 - 0.5) * 2
                    v41 = Color3.new(v43, 1, v43)
                end
                local v44, v45, v46 = v41:ToHSV()
                return Color3.fromHSV(v44, v45, v46 * 0.7)
            end

            local function CreateLidarSpheres(p47, p48)
                local v49 = p48:ViewportPointToRay(p47.X, p47.Y)
                local v50 = RaycastParams.new()
                v50.FilterDescendantsInstances = { u4.Character }
                v50.FilterType = Enum.RaycastFilterType.Exclude
                local v51 = workspace:Raycast(v49.Origin, v49.Direction * 1000, v50)
                if v51 then
                    local v52 = v5.ItemControllers:WaitForChild("LIDAR Scanner").Part:Clone()
                    v52.Position = v51.Position
                    v52.Color = GetColorFromScreenPosition(p47)
                    v52.Parent = u9
                end
            end

            local function RenderLidarOutput()
                local v53 = u10.ViewportSize.X
                local v54 = u10.ViewportSize.Y
                local v55 = GenerateScreenPoints(0.001, v53, v54)
                workspace.LIDAR:ClearAllChildren()
                local v56 = workspace:FindFirstChild("Ghost"):Clone()
                for _, v57 in v56:GetDescendants() do
                    if v57:IsA("BasePart") then
                        v57.CanCollide = false
                        v57.CanQuery = true
                        v57.Anchored = true
                        v57.CollisionGroup = "Default"
                        v57.Transparency = 1
                    end
                end
                v56.Parent = workspace
                for v58, v59 in ipairs(v55) do
                    if v58 % 100 == 0 then
                        u3.Heartbeat:Wait()
                    end
                    CreateLidarSpheres(v59, u10)
                end
                v56:Destroy()
            end

            RenderLidarOutput()
        end

        ridarScan()
    end
})

local Button = Tab:Button({
    Title = "通知所有稀有物品",
    Callback = function()
        local found = false

        for _, d in pairs(workspace:WaitForChild("Items"):GetChildren()) do
            if d:GetAttribute("ItemName") then
                local NameItem = d:GetAttribute("ItemName")
                local er = true

                if d:GetAttribute("Uninteractable") == true or d:GetAttribute("Broken") == true then
                    er = false
                end

                if er and (NameItem == "Energy Drink" or NameItem == "Music Box" or 
                    NameItem == "Umbra Board" or NameItem == "Energy Watch" or tonumber(d.Name) >= 100) then
                    
                    found = true
                    WindUI:Notify({
                        Title = "稀有物品警告",
                        Content = "发现稀有物品 "..NameItem,
                        Duration = 3.5
                    })

                    local hightlight = Instance.new("Highlight")
                    hightlight.Parent = d
                    hightlight.FillColor = Color3.fromRGB(37, 161, 255)
                    game:GetService("Debris"):AddItem(hightlight,5)
                end
            end
        end

        if not found then
            WindUI:Notify({
                Title = "稀有物品警告",
                Content = "未找到稀有物品",
                Duration = 3.5
            })
        end
    end
})

local Button = Tab:Button({
    Title = "切换保险丝盒",
    Callback = function()
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("ToggleFuseBox"):FireServer()
    end
})

local Button = Tab:Button({
    Title = "获取当前房间温度",
    Callback = function()
        local room = game.Players.LocalPlayer:GetAttribute("CurrentRoom")
        
        if workspace:WaitForChild("Map"):WaitForChild("Rooms"):FindFirstChild(room) and 
            workspace:WaitForChild("Map"):WaitForChild("Rooms"):WaitForChild(room):GetAttribute("Temperature") then
            
            WindUI:Notify({
                Title = "房间温度检查",
                Content = room.."的温度是 "..tostring(workspace:WaitForChild("Map"):WaitForChild("Rooms"):WaitForChild(room):GetAttribute("Temperature")),
                Duration = 3.5
            })
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "通知鬼魂房间温度低于0°C",
    Default = false,
    Callback = function(Value)
        if Value then
            local room = workspace:WaitForChild("Ghost"):GetAttribute("FavoriteRoom")
            
            if workspace:WaitForChild("Map"):WaitForChild("Rooms"):WaitForChild(room):GetAttribute("Temperature") <= 0 then
                WindUI:Notify({
                    Title = "房间温度检查(鬼魂)",
                    Content = room.."的温度低于0°C!",
                    Duration = 3.5
                })
            end

            workspace:WaitForChild("Map"):WaitForChild("Rooms"):WaitForChild(room):GetAttributeChangedSignal("Temperature"):Connect(function()
                if workspace:WaitForChild("Map"):WaitForChild("Rooms"):WaitForChild(room):GetAttribute("Temperature") <= 0 then
                    WindUI:Notify({
                        Title = "房间温度检查(鬼魂)",
                        Content = room.."的温度低于0°C!",
                        Duration = 3.5
                    })
                end
            end)
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "穿门无碰撞",
    Default = false,
    Callback = function(Value)
        for _, d in pairs(workspace.Doors:GetChildren()) do
            task.spawn(function()
                for _, d22 in pairs(d:WaitForChild("Door"):GetChildren()) do
                    if d22:IsA("BasePart") and d22.Name ~= "GhostTracker" then
                        d22.CanCollide = not Value
                    end
                end
            end)
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "最大亮度",
    Default = false,
    Callback = function(Value)
        if Value then
            game.Lighting.Brightness = 2
            game.Lighting.ClockTime = 14
            game.Lighting.GlobalShadows = false
            game.Lighting.OutdoorAmbient = Color3.fromRGB(209, 209, 209)
        else
            game.Lighting.Brightness = 0
            game.Lighting.ClockTime = 0
            game.Lighting.GlobalShadows = true
            game.Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "刷门(卡顿)",
    Default = false,
    Callback = function(Value)
        task.spawn(function()
            while Value do
                task.wait()
                for _, d in pairs(workspace.Doors:GetChildren()) do
                    if d:GetAttribute("Locked") ~= true then
                        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("ClientChangeDoorState"):FireServer(d:WaitForChild("Door"))
                    end
                end
            end
        end)
    end
})

local Toggle = Tab:Toggle({
    Title = "刷灯(卡顿)",
    Default = false,
    Callback = function(Value)
        task.spawn(function()
            while Value do
                task.wait()
                for _, d in pairs(workspace.Map.Rooms:GetChildren()) do
                    if d:FindFirstChild("LightSwitch") then
                        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("UseLightSwitch"):FireServer(d)
                    end
                end
            end
        end)
    end
})

local Button = Tab:Button({
    Title = "让所有物品消失",
    Callback = function()
        task.spawn(function()
            while task.wait() do
                for _, d in pairs(workspace.Items:GetChildren()) do
                    if d.PrimaryPart then
                        local newForce = Instance.new("BodyPosition",d.PrimaryPart)
                        newForce.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
                        newForce.Position = Vector3.new(1000000,1000000,1000000)
                    end
                end

                for _, d in pairs(game.Players:GetChildren()) do
                    local Tools = d:WaitForChild("ToolsHolder")

                    for _, d in pairs(Tools:GetChildren()) do
                        if d.PrimaryPart then
                            local newForce = Instance.new("BodyPosition",d.PrimaryPart)
                            newForce.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
                            newForce.Position = Vector3.new(1000000,1000000,1000000)
                        end
                    end
                end
            end
        end)
    end
})

local Tab = Tabs.Main:Tab({
    Title = "成为乞丐",
    Icon = "settings",
    Locked = false,
})

local Toggle = Tab:Toggle({
    Title = "自动乞讨",
    Icon = "check",
    Default = false,
    Callback = function(Value)
        _G.AutoFastMoney = Value
        if Value then
            local plrs = game:GetService("Players")
            local rs = game:GetService("ReplicatedStorage")
            local me = plrs.LocalPlayer
            local char = me.Character or me.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart")
            local bases = workspace:WaitForChild("Bases")
            local ev = rs.Remotes:WaitForChild("MinigameEvent")
            local run = game:GetService("RunService")

            local function findBase()
                for _,b in pairs(bases:GetChildren()) do
                    local o = b:FindFirstChild("Owner")
                    if o then
                        local v = o.Value
                        if v == me or tostring(v) == me.Name or tonumber(v) == me.UserId then
                            return b
                        end
                    end
                end
            end

            local b = findBase()
            if b then
                local beg = b:WaitForChild("BegPrompt")
                local prompt = beg:WaitForChild("ProximityPrompt")
                
                hrp.CFrame = beg.CFrame + Vector3.new(0,3,0)
                fireproximityprompt(prompt)
                
                while _G.AutoFastMoney do
                    run.RenderStepped:Wait()
                    ev:FireServer(true)
                end
            end
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "自动购买员工",
    Icon = "check",
    Default = false,
    Callback = function(Value)
        _G.AutoBuyEmployees = Value
        if Value then
            local Replicate = game:GetService("ReplicatedStorage")
            local BuyEmployee = Replicate.Remotes.BuyEmployee
            task.spawn(function()
                while _G.AutoBuyEmployees do 
                    for i = 1, 75 do 
                        if i ~= 13 and i ~= 14 then 
                            BuyEmployee:FireServer(i)
                            task.wait(0.3)
                        end 
                    end 
                end 
            end)
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "自动升级",
    Icon = "check",
    Default = false,
    Callback = function(Value)
        _G.AutoBuyUpgrades = Value
        if Value then
            local Replicate = game:GetService("ReplicatedStorage")
            local Upgrade = Replicate.Remotes.Upgrade
            task.spawn(function()
                while _G.AutoBuyUpgrades do 
                    task.wait(0.1)
                    Upgrade:FireServer("Beg Power")
                    Upgrade:FireServer("Income")
                    Upgrade:FireServer("Box Tier")
                    Upgrade:FireServer("Alley Tier")
                end 
            end)
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "金钱光环",
    Icon = "check",
    Default = false,
    Callback = function(Value)
        _G.MoneyAura = Value
        if Value then
            local Money = workspace:WaitForChild("Money")
            local HRP = player.Character:WaitForChild("HumanoidRootPart")
            task.spawn(function()
                while _G.MoneyAura do
                    local OldCFrame = HRP.CFrame
                    for _,v in pairs(Money:GetDescendants()) do
                        if v:IsA("ProximityPrompt") and v.Parent:IsA("BasePart") then
                            HRP.CFrame = v.Parent.CFrame + Vector3.new(0,3,0)
                            fireproximityprompt(v,0,true)
                        end
                    end
                    HRP.CFrame = OldCFrame
                    task.wait(0.5)
                end 
            end)
        end
    end
})
end

local Tab = Tabs.Main:Tab({
    Title = "躲避",
    Icon = "settings",
    Locked = false,
})

-- 自动获胜按钮
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

local Tab = Tabs.Main:Tab({
    Title = "极速传奇",
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
            Title = "李浩天：",
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
            Title = "李浩天：",
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
            Title = "李浩天：",
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
            Title = "李浩天：",
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
            Title = "李浩天：",
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
            Title = "李浩天：",
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
            Title = "李浩天：",
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
            Title = "李浩天：",
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
            Title = "李浩天：",
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
            Title = "李浩天：",
            Content = state and "已开启自动刷圈" or "已关闭自动刷圈",
            Icon = state and "check" or "x",
            Duration = 2
        })
    end
})

local Button = Tab:Button({
    Title = "传送至城市（出生点）",
    Icon = "bell",
    Callback = function()
game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-568.6292114257812, 3.1723721027374268, 412.86492919921875)
        WindUI:Notify({
            Title = "李浩天：",
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
            Title = "李浩天：",
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
            Title = "李浩天：",
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
            Title = "李浩天：",
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
            Title = "李浩天：",
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
            Title = "李浩天：",
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
            Title = "李浩天：",
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
            Title = "李浩天：",
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
            Title = "李浩天：",
            Content = "传送成功",
            Icon = "bell",
            Duration = 3
        })
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
            Title = "李浩天：",
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
            Title = "李浩天：",
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
            Title = "李浩天：",
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
            Title = "李浩天：",
            Content = state and "已开启自动买尾迹" or "已关闭自动买尾迹",
            Icon = state and "check" or "x",
            Duration = 2
        })
    end
})

local Tab = Tabs.Main:Tab({
    Title = "建造你的基地",
    Icon = "settings",
    Locked = false,
})

local rangeAttackEnabled = false

local Toggle = Tab:Toggle({
    Title = "自动挥舞拳头",
    Value = false,
    Callback = function(value)
        rangeAttackEnabled = value
        if rangeAttackEnabled then
            while rangeAttackEnabled do
                local args = {
                    [1] = true,
                    [2] = Vector3.new(0, 0, 0),  
                    [3] = 50,                  
                    [4] = Enum.Material.Water,    
                    [5] = "RangeAttack"        
                }
                
                game:GetService("ReplicatedStorage").Remotes.Events.ToolState:FireServer(unpack(args))
                wait()
            end
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "范围攻击",
    Value = false,
    Callback = function(value)
        rangeAttackEnabled = value
        if value then
            spawn(function()
                while rangeAttackEnabled do
                    for _, enemy in next, workspace.Characters:GetChildren() do
                        if enemy:IsA("Model") and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") then
                            if enemy ~= game.Players.LocalPlayer.Character and enemy.Humanoid.Health > 0 then
                                local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                                if distance <= 999 then 
                                    local args = {
                                        [1] = true,
                                        [2] = enemy.HumanoidRootPart.Position,  
                                        [3] = 50,                    
                                        [4] = Enum.Material.Water,   
                                        [5] = "RangeAttack"          
                                    }
                                    
                                    pcall(function()
                                        game:GetService("ReplicatedStorage").Remotes.Events.ToolState:FireServer(unpack(args))
                                    end)
                                end
                            end
                        end
                    end
                    
                    wait()
                end
            end)
        end
    end
})

local Tab = Tabs.Main:Tab({
    Title = "力量传奇",
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

local Tab = Tabs.Main:Tab({
    Title = "墨水游戏",
    Icon = "settings",
    Locked = false,
})

local Toggle = Tab:Toggle({
    Title = "透视躲藏者",
    Value = false,    
    Callback = function(state) 
        hiderESPEnabled = state
        if state then
            ESP.AddFolder("HiderESPFolder")
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player:GetAttribute("IsHider") then
                    ESP.AddESP("HiderESPFolder", "躲藏者 " .. player.Name, player.Character, Color3.new(0, 0, 1))
                end
            end
            
            Players.PlayerAdded:Connect(function(player)
                if hiderESPEnabled and player:GetAttribute("IsHider") then
                    ESP.AddESP("HiderESPFolder", "躲藏者 " .. player.Name, player.Character, Color3.new(0, 0, 1))
                end
            end)
        else
            ESP.Clear("HiderESPFolder")
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "透视搜查者",
    Value = false,    
    Callback = function(state) 
        hunterESPEnabled = state
        if state then
            ESP.AddFolder("HunterESPFolder")
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player:GetAttribute("IsHunter") then
                    ESP.AddESP("HunterESPFolder", "搜查者 " .. player.Name, player.Character, Color3.new(1, 0, 0))
                end
            end
            
            Players.PlayerAdded:Connect(function(player)
                if hunterESPEnabled and player:GetAttribute("IsHunter") then
                    ESP.AddESP("HunterESPFolder", "搜查者 " .. player.Name, player.Character, Color3.new(1, 0, 0))
                end
            end)
        else
            ESP.Clear("HunterESPFolder")
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "透视真假玻璃",
    Value = false,    
    Callback = function(state) 
        glassESPEnabled = state
        if state then
            ESP.AddFolder("GlassESPFolder")
            for _, v in next, workspace.GlassBridge.GlassHolder:GetChildren() do
                if v.Name:find("ClonedPanel") then
                    for _, panelChild in next, v:GetChildren() do
                        for _, glassPart in next, panelChild:GetChildren() do
                            if glassPart.Name == "glasspart" and glassPart:FindFirstChild("TouchInterest") then
                                ESP.AddESP("GlassESPFolder", "假玻璃", glassPart, Color3.new(0, 1, 0))
                            end
                        end
                    end
                end
            end
        else
            ESP.Clear("GlassESPFolder")
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "ESP玻璃",
    Value = false,    
    Callback = function(state) 
        pcall(function()
            local GlassHolder = workspace.GlassBridge.GlassHolder
            for _, PanelPair in ipairs(GlassHolder:GetChildren()) do
                for _, Panel in ipairs(PanelPair:GetChildren()) do
                    local GlassPart = Panel:FindFirstChild("glasspart")
                    if GlassPart then
                        if state then
                            local Color = GlassPart:GetAttribute("exploitingisevil") and Color3.fromRGB(248, 87, 87) or Color3.fromRGB(28, 235, 87)
                            GlassPart.Color = Color
                            GlassPart.Transparency = 0
                            GlassPart.Material = Enum.Material.Neon
                        else
                            GlassPart.Color = Color3.fromRGB(106, 106, 106)
                            GlassPart.Transparency = 0.45
                            GlassPart.Material = Enum.Material.SmoothPlastic
                        end
                    end
                end
            end
        end)
    end
})

local Tab = Tab:Tab({
    Title = "123木头人",
    Icon = "layout-grid",
    Locked = false,
})

local polygon = {
    Vector2.new(-52, -515),
    Vector2.new(115, -515),
    Vector2.new(115, 84),
    Vector2.new(-216, 84)
}

local lastUpdate = tick()
local updateInterval = 0.1

local Button = Tab:Button({
    Title = "帮助玩家到终点，同时你自己也可以(木头人关)",
    Callback = function()
        local foundPlayer = false
        
        if tick() - lastUpdate < updateInterval then
            WindUI:Notify({
                Title = "帮助玩家",
                Content = "操作过于频繁，请稍后再试",
                Icon = "clock",
                Duration = 1,
            })
            return
        end
        lastUpdate = tick()
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local liveChar = workspace:FindFirstChild("Live") and workspace.Live:FindFirstChild(player.Name)
                local hrp = liveChar and liveChar:FindFirstChild("HumanoidRootPart")

                if hrp then
                    local posXZ = Vector2.new(hrp.Position.X, hrp.Position.Z)
                    local inside = false
                    local j = #polygon
                    for i = 1, #polygon do
                        local xi, zi = polygon[i].X, polygon[i].Y
                        local xj, zj = polygon[j].X, polygon[j].Y
                        if ((zi > posXZ.Y) ~= (zj > posXZ.Y)) and
                            (posXZ.X < (xj - xi) * (posXZ.Y - zi) / (zj - zi + 1e-9) + xi) then
                            inside = not inside
                        end
                        j = i
                    end
                    
                    if inside then
                        local prompt = hrp:FindFirstChild("CarryPrompt")

                        if prompt and prompt:IsA("ProximityPrompt") and prompt.Enabled then
                            WindUI:Notify({
                                Title = "帮助玩家",
                                Content = "正在帮助: " .. player.Name,
                                Icon = "user-check",
                                Duration = 1,
                            })
                            
                            pcall(function()
                                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                if hrp then
                                    hrp.CFrame = hrp.CFrame + Vector3.new(0, 2, 0)
                                end
                                task.wait(0.4)
                                if fireproximityprompt then
                                    pcall(fireproximityprompt, prompt)
                                elseif prompt and prompt:IsA("ProximityPrompt") then
                                    prompt:InputHoldBegin()
                                    task.wait(0.1)
                                    prompt:InputHoldEnd()
                                end
                                task.wait(0.7)
                                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                if hrp then
                                    hrp.CFrame = CFrame.new(-46, 1024, 110)
                                end
                            end)
                            
                            WindUI:Notify({
                                Title = "帮助完成",
                                Content = "已完成帮助: " .. player.Name,
                                Icon = "check-circle",
                                Duration = 1,
                            })
                            foundPlayer = true
                            break
                        end
                    end
                end
            end
        end
        
        if not foundPlayer then
            WindUI:Notify({
                Title = "帮助玩家",
                Content = "没有可帮助的玩家",
                Icon = "user-x",
                Duration = 1,
            })
        end
    end
})

local lastJumpTime = 0
UserInputService.JumpRequest:Connect(function()
    if isInfiniteJumpEnabled and tick() - lastJumpTime > 0.1 then
        lastJumpTime = tick()
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.FloorMaterial ~= Enum.Material.Air then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)

local lastNoclipCheck = 0
RunService.Stepped:Connect(function()
    if isNoclipEnabled and LocalPlayer.Character then
        if tick() - lastNoclipCheck > 0.1 then
            lastNoclipCheck = tick()
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    if part.CanCollide then
                        noclipParts[part] = true
                        part.CanCollide = false
                    end
                end
            end
        end
    end
end)

local lastCombatUpdate = 0
local updateInterval = 0.1
RunService.RenderStepped:Connect(function()
    local now = tick()
    if now - lastCombatUpdate < updateInterval then return end
    lastCombatUpdate = now
    
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return
    end

    local rootPart = character.HumanoidRootPart
    local nearestTarget = nil
    local nearestDistance = math.huge

    if now - lastEspUpdate > 0.5 then
        lastEspUpdate = now
        if isEspEnabled then
            for _, model in ipairs(workspace:GetDescendants()) do
                if model:IsA("Model") and not model:IsDescendantOf(Players) and not model:IsDescendantOf(character) then
                    local modelName = model.Name:lower()
                    if modelName:find("guard") or modelName:find("guy") or modelName:find("squid") then
                        local part = model:FindFirstChildWhichIsA("BasePart")
                        if part then
                            local distance = (part.Position - rootPart.Position).Magnitude
                            if distance < nearestDistance then
                                nearestTarget = model
                                nearestDistance = distance
                            end
                            
                            if not espCache[part] then
                                local espBox = Instance.new("BoxHandleAdornment")
                                espBox.Name = "ESP"
                                espBox.Adornee = part
                                espBox.Size = part.Size
                                espBox.Color3 = Color3.fromRGB(255, 0, 0)
                                espBox.AlwaysOnTop = true
                                espBox.ZIndex = 10
                                espBox.Transparency = 0.25
                                espBox.AdornCullingMode = Enum.AdornCullingMode.Never
                                espBox.Parent = part
                                espCache[part] = espBox
                            end
                        end
                    end
                end
            end
        end
    end

    if isAimbotEnabled and nearestTarget then
        local targetPart = nearestTarget:FindFirstChild("Head") or nearestTarget:FindFirstChild("Torso")
        if targetPart then
            local cameraPos = workspace.CurrentCamera.CFrame.Position
            local targetDir = (targetPart.Position - cameraPos).Unit
            local currentCFrame = workspace.CurrentCamera.CFrame
            local newCFrame = currentCFrame:Lerp(CFrame.new(cameraPos, targetPart.Position), aimbotLerpFactor)
            workspace.CurrentCamera.CFrame = newCFrame
        end
    end
end)

if game.BindToClose then
    pcall(function()
        game:BindToClose(function()
            for part, _ in pairs(noclipParts) do
                if part and part.Parent then
                    part.CanCollide = true
                end
            end
            
            for _, esp in pairs(espCache) do
                if esp and esp.Parent then
                    esp:Destroy()
                end
            end
            
            ESP.Clear("HiderESPFolder")
            ESP.Clear("HunterESPFolder")
            ESP.Clear("GlassESPFolder")
            
            pcall(function()
                local GlassHolder = workspace.GlassBridge.GlassHolder
                for _, PanelPair in ipairs(GlassHolder:GetChildren()) do
                    for _, Panel in ipairs(PanelPair:GetChildren()) do
                        local GlassPart = Panel:FindFirstChild("glasspart")
                        if GlassPart then
                            GlassPart.Color = Color3.fromRGB(106, 106, 106)
                            GlassPart.Transparency = 0.45
                            GlassPart.Material = Enum.Material.SmoothPlastic
                        end
                    end
                end
            end)
        end)
    end)
end

local Tab = Tabs.Main:Tab({
    Title = "汽车营销大亨",
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

local Tab = Tabs.Main:Tab({
    Title = "请捐赠",
    Icon = "settings",
    Locked = false,
})

local autoThanks = false
local thanksMessages = {
    "谢谢爸爸捐赠!",
    "感谢爸爸支持!",
    "谢谢爸爸捐赠!"
}

local Toggle = Tab:Toggle({
    Title = "捐赠自动感谢",
    Desc = "收到捐赠后自动发送感谢消息",
    Default = false,
    Callback = function(Value)
        autoThanks = Value
        if Value then
            game.Players.LocalPlayer.leaderstats.Raised.Changed:Connect(function()
                if autoThanks then
                    local randomMsg = thanksMessages[math.random(1, #thanksMessages)]
                    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(randomMsg, "All")
                end
            end)
        end
    end
})

local antiAFK = false
local Toggle = Tab:Toggle({
    Title = "防止AFK",
    Default = false,
    Callback = function(Value)
        antiAFK = Value
        if Value then
            local VirtualInputManager = game:GetService("VirtualInputManager")
            task.spawn(function()
                while antiAFK do
                    task.wait(30)
                    VirtualInputManager:SendKeyEvent(true, "W", false, game)
                    task.wait(0.1)
                    VirtualInputManager:SendKeyEvent(false, "W", false, game)
                end
            end)
        end
    end
})

local autoTalk = false
local talkInterval = 60 
local talkMessages = {
    "欢迎来到我的摊位!",
    "请支持我",
    "请多多捐赠支持!",
    "我是最好的!",
    "谢谢大家的支持!"
}

local Toggle = Tab:Toggle({
    Title = "自动说话",
    Desc = "定期自动发送消息",
    Default = false,
    Callback = function(Value)
        autoTalk = Value
        if Value then
            task.spawn(function()
                while autoTalk do
                    for i = 1, 5 do 
                        if not autoTalk then break end
                        local randomMsg = talkMessages[math.random(1, #talkMessages)]
                        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(randomMsg, "All")
                        task.wait(1) 
                    end
                    task.wait(talkInterval - 5) 
                end
            end)
        end
    end
})

local Slider = Tab:Slider({
    Title = "说话间隔(秒)",
    Desc = "设置自动说话的间隔时间",
    Value = {
        Min = 10,
        Max = 300,
        Default = 60
    },
    Callback = function(Value)
        talkInterval = Value
    end
})

local Slider = Tab:Slider({
    Title = "自定义说话内容",
    Desc = "输入自定义的说话内容(用逗号分隔)",
    Placeholder = "消息1,消息2,消息3",
    Callback = function(Value)
        if Value and Value ~= "" then
            local newMessages = {}
            for msg in string.gmatch(Value, "([^,]+)") do
                table.insert(newMessages, msg:gsub("^%s*(.-)%s*$", "%1"))
            end
            if #newMessages > 0 then
                talkMessages = newMessages
                WindUI:Notify({
                    Title = "说话内容已更新",
                    Content = "已设置 " .. #newMessages .. " 条自定义消息",
                    Duration = 3
                })
            end
        end
    end
})

local Tab = Tabs.Main:Tab({
    Title = "元素力量大亨",
    Icon = "settings",
    Locked = false,
})

local Toggle = Tab:Toggle({
    Title = "自动建造",
    Default = false,
    Callback = function(state)
        setting.autobuild = state
        task.spawn(function()
            while setting.autobuild and task.wait() do
                for _,v in next,workspace.Tycoons:GetChildren() do
                    if v.Name == game.Players.LocalPlayer.Name then
                        for _,a in next,v.Buttons:GetChildren() do
                            if a.Button.Color == Color3.fromRGB(0,127,0) then
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = a.Button.CFrame
                            end
                        end
                    end
                end
            end
        end)
    end
})

local Toggle = Tab:Toggle({
    Title = "自动收集钱",
    Default = false,
    Callback = function(state)
        setting.autocollect = state
        task.spawn(function()
            while setting.autocollect and task.wait(5) do
                for _,v in next,workspace.Tycoons:GetChildren() do
                    if v.Name == game.Players.LocalPlayer.Name then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Auxiliary.Collector.Collect.CFrame
                    end
                end
            end
        end)
    end
})

local Toggle = Tab:Toggle({
    Title = "自动收集钱箱",
    Default = false,
    Callback = function(state)
        setting.autocollectcrate = state
        task.spawn(function()
            while setting.autocollectcrate and task.wait() do
                for _,v in next,workspace:GetChildren() do
                    if v.Name == "BalloonCrate" then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Crate.CFrame
                        fireproximityprompt(v.Crate.ProximityPrompt)
                    end
                end
            end
        end)
    end
})

local Toggle = Tab:Toggle({
    Title = "自动收集boss掉的钱",
    Default = false,
    Callback = function(state)
        setting.autocollectdollar = state
        task.spawn(function()
            while setting.autocollectdollar and task.wait() do
                for _,v in next,workspace:GetChildren() do
                    if v.Name == "Dollar" then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
                    end
                end
            end
        end)
    end
})

local Toggle = Tab:Toggle({
    Title = "自动收集宝箱",
    Default = false,
    Callback = function(state)
        setting.autocollectchest = state
        task.spawn(function()
            while setting.autocollectchest and task.wait() do
                for _, v in pairs(workspace.Treasure.Chests:GetChildren()) do
                    if v.Name == "Chest" then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
                        fireproximityprompt(v.ProximityPrompt)
                    end
                end
            end
        end)
    end
})

local Button = Tab:Button({
    Title = "传送一次中心",
    Callback = function()
        local oldpos = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        wait(0.5)
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.Map.Center.CFrame
        wait(0.3)
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldpos
    end
})

local Tab = Tabs.Main:Tab({
    Title = "在超市生活一周",
    Icon = "settings",
    Locked = false,
})

local Toggle = Tab:Toggle({
    Title = "自动收集食物",
    Default = false,
    Callback = function(state)
        while state and task.wait() do
            for _,v in next,workspace.Map.Util.Items:GetChildren() do
                if v.ToolStats.ItemType.Value == "Food" then
                    game:GetService("ReplicatedStorage").Remotes.RequestPickupItem:FireServer(v)
                end
            end
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "自动收集手电筒",
    Default = false,
    Callback = function(state)
        while state and task.wait() do
            for _,v in next,workspace.Map.Util.Items:GetChildren() do
                if v.ToolStats.ItemType.Value == "Flashlight" then
                    game:GetService("ReplicatedStorage").Remotes.RequestPickupItem:FireServer(v)
                end
            end
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "自动收集近战武器",
    Default = false,
    Callback = function(state)
        while state and task.wait() do
            for _,v in next,workspace.Map.Util.Items:GetChildren() do
                if v.ToolStats.ItemType.Value == "Melee" then
                    game:GetService("ReplicatedStorage").Remotes.RequestPickupItem:FireServer(v)
                end
            end
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "自动收集枪",
    Default = false,
    Callback = function(state)
        while state and task.wait() do
            for _,v in next,workspace.Map.Util.Items:GetChildren() do
                if v.ToolStats.ItemType.Value == "Gun" then
                    game:GetService("ReplicatedStorage").Remotes.RequestPickupItem:FireServer(v)
                end
            end
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "自动收集药品",
    Default = false,
    Callback = function(state)
        while state and task.wait() do
            for _,v in next,workspace.Map.Util.Items:GetChildren() do
                if v.ToolStats.ItemType.Value == "Health" then
                    game:GetService("ReplicatedStorage").Remotes.RequestPickupItem:FireServer(v)
                end
            end
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "自动装弹",
    Default = false,
    Callback = function(state)
        while state and task.wait() do
            game:GetService("ReplicatedStorage").Remotes.Weapon.GunReloaded:FireServer(v, 1)
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "自动开枪",
    Default = false,
    Callback = function(state)
        while state and task.wait() do
            for _, v in next, game.Players.LocalPlayer.Backpack:GetChildren() do
                if v:FindFirstChild("ToolStats") and v.ToolStats:FindFirstChild("Ammo") then
                    for _,e in next,workspace.Enemies:GetChildren() do
                        if e.Humanoid.Health > 0 then
                            local BulletsPerShot = v.ToolStats.BulletsPerShot.Value
                            local DirectionTbl = {}
                            for i = 1, BulletsPerShot do
                                table.insert(DirectionTbl, Vector3.new(e.Head.Position.X, e.Head.Position.Y, e.Head.Position.Z).Unit)
                            end
                            local args = {
                                [1] = {
                                    ["FiringPlayer"] = game:GetService("Players").LocalPlayer,
                                    ["FiredTime"] = os.time,
                                    ["FiringPlayerUserId"] = game.Players.LocalPlayer.UserId,
                                    ["Origin"] = Vector3.new(game.Players.LocalPlayer.Character:GetPivot().Position),
                                    ["UID"] = game.Players.LocalPlayer.UserId .. "_1",
                                    ["WeaponInstance"] = v,
                                    ["ThisBulletProperties"] = {
                                        ["BulletSpread"] = v.ToolStats.BulletSpread.Value,
                                        ["BulletsPerShot"] = v.ToolStats.BulletsPerShot.Value,
                                        ["BulletPenetration"] = v.ToolStats.BulletPenetration.Value,
                                        ["BulletSpeed"] = v.ToolStats.BulletSpeed.Value,
                                        ["FireSound"] = v.ToolStats.FireSound.Value,
                                        ["BulletSize"] = v.ToolStats.BulletSize.Value
                                    },
                                    ["DirectionTbl"] = DirectionTbl
                                }
                            }
                            game:GetService("ReplicatedStorage").Remotes.Weapon.GunFired:FireServer(unpack(args))
                        end
                    end
                end
            end
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "修改超级枪",
    Default = false,
    Callback = function(state)
        while state and task.wait() do
            for _,v in next,game.Players.LocalPlayer.Backpack:GetChildren() do
                if v.ToolStats:FindFirstChild("Ammo") then
                    v.ToolStats.ReloadTime.Value = 0
                    v.ToolStats.FireDelay.Value = 0
                    v.ToolStats.Ammo.Value = math.huge
                    v.ToolStats.Damage.Value = math.huge
                end
            end
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "无限体力和饥饿度",
    Default = false,
    Callback = function(state)
        while state and task.wait() do
            game.Players.LocalPlayer.Character.CharacterData.MaxStamina.Value = math.huge
            game.Players.LocalPlayer.Character.CharacterData.MaxEnergy.Value = math.huge
            game.Players.LocalPlayer.Character.CharacterData.Energy.Value = game.Players.LocalPlayer.Character.CharacterData.MaxEnergy.Value
            game.Players.LocalPlayer.Character.CharacterData.Stamina.Value = game.Players.LocalPlayer.Character.CharacterData.MaxStamina.Value
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "夜晚自动躲避",
    Default = false,
    Callback = function(state)
        while state and task.wait() do
            if game:GetService("ReplicatedStorage").GameInfo.TimeOfDay.Value == "Night" then
                oldpos = game.Players.LocalPlayer.Character:GetPivot().Position
                repeat task.wait()
                    game.Players.LocalPlayer.Character:PivotTo(CFrame.new(306.18927001953125, 36.67450714111328, -519.2435913085938))
                    game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
                until game:GetService("ReplicatedStorage").GameInfo.TimeOfDay.Value ~= "Night"
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(oldpos)
                game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
            else
                task.wait()
            end
        end
    end
})

local Tab = Tabs.Main:Tab({
    Title = "自然灾害",
    Icon = "settings",
    Locked = false,
})

local Button = Tab:Button({
    Title = "指南针（可以用下面的地方显示不了地图）",
    Desc = "要使用的话就必须买指南针",
    Callback = function()
        local p = game.Players.LocalPlayer
        local r, c, h = game.ReplicatedStorage.Remotes.Compass, p.Backpack:WaitForChild("Compass"), p.Character:WaitForChild("Humanoid")
        h:EquipTool(c)
        task.wait()
        r:FireServer("Vote Map", 3)
        r:FireServer("Vote Map", 4)
        task.wait()
        h:UnequipTools()
            
        WindUI:Notify({
            Title = "通知",
            Content = "加载成功",
            Duration = 1,
            Icon = "layout-grid",
        })                        
    end
})

local Button = Tab:Button({
    Title = "黑洞",
    Desc = "点击加载",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Super-ring-Parts-V6-28581"))()
        
        WindUI:Notify({
            Title = "通知",
            Content = "加载成功",
            Duration = 3,
            Icon = "layout-grid",
        })        
    end
})

local Button = Tab:Button({
    Title = "物理磁铁",
    Desc = "可以把下面的东西吸上来可以踩",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/cytj777i/6669178/main/%E5%8D%95%E4%B8%80%E7%89%A9%E4%BD%93%E9%A3%9E%E8%A1%8C%E8%BD%BD%E8%87%AA%E5%B7%B1%E6%9C%80%E7%BB%88%E4%BC%98%E5%8C%96%E7%89%88"))()       
        WindUI:Notify({
            Title = "通知",
            Content = "加载成功",
            Duration = 1,
            Icon = "layout-grid",
        })                                
    end
})

local Button = Tab:Button({
    Title = "无敌少侠",
    Desc = "用了它，你就会变成城市超人",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Invinicible-Flight-R15-45414"))()
        WindUI:Notify({
            Title = "通知",
            Content = "加载成功",
            Duration = 1,
            Icon = "layout-grid",
        })                        
    end
})

local Button = Tab:Button({
    Title = "防止摔跤伤害",
    Desc = "就算掉下去了，也毫发无伤，掉到水里面也会死的",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/cytj777i/Fall-injury/main/防止摔落伤害"))()
        WindUI:Notify({
            Title = "通知",
            Content = "加载成功",
            Duration = 1,
            Icon = "layout-grid",
        })                        
    end
})

local Tab = Tabs.Main:Tab({
    Title = "植物大战脑红",
    Icon = "settings",
    Locked = false,
})

local Toggle = Tab:Toggle({
    Title = "杀戮光环",
    Icon = "check",
    Default = false,
    Callback = function(Value)
        _G.AutoAttack = Value
        if Value then
            local RS = game:GetService("ReplicatedStorage")
            local Event = RS.Remotes.AttacksServer.WeaponAttack
            local Players = game:GetService("Players")
            local Player = Players.LocalPlayer
            local Char = Player.Character or Player.CharacterAdded:Wait()
            local HRP = Char:WaitForChild("HumanoidRootPart")

            Player.CharacterAdded:Connect(function(c)
                Char = c
                HRP = c:WaitForChild("HumanoidRootPart")
            end)

            task.spawn(function()
                while _G.AutoAttack do
                    local targets = {}
                    for _, mob in ipairs(workspace.ScriptedMap.Brainrots:GetChildren()) do
                        local pp = mob.PrimaryPart or mob:FindFirstChild("HumanoidRootPart")
                        if pp and (pp.Position - HRP.Position).Magnitude <= DistanceForKillAura then
                            table.insert(targets, mob.Name)
                        end
                    end
                    if #targets > 0 then
                        Event:FireServer(targets)
                    end
                    task.wait()
                end
            end)
        end
    end
})

local Slider = Tab:Slider({
    Title = "攻击范围[20默认]",
    Value = tostring(DefaultKillAuraDistance),
    Callback = function(value)
        local numValue = tonumber(value)
        if numValue then
            DistanceForKillAura = numValue
        end
    end
})

local autoSell = false  
local Toggle = Tab:Toggle({
    Title = "自动出售脑红",
    Default = false,
    Callback = function(state)
        autoSell = state
        if autoSell then
            task.spawn(function()
                while autoSell do
                    local success, errorMsg = pcall(function()
                        game:GetService("ReplicatedStorage").Remotes.ItemSell:FireServer()
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end
})

local sellInterval = 0.1
local Slider = Tab:Slider({
    Title = "出售间隔",
    Value = {
        Min = 0.05,
        Max = 1,
        Default = 0.1
    },
    Callback = function(Value)
        sellInterval = Value
    end
})

local autoSell = false  
local Toggle = Tab:Toggle({
    Title = "自动出售植物",
    Default = false,
    Callback = function(state)
        autoSell = state
        if autoSell then
            task.spawn(function()
                while autoSell do
                    local success, errorMsg = pcall(function()
                        local args = {
                            [2] = true
                        }
                        game:GetService("ReplicatedStorage").Remotes.ItemSell:FireServer(unpack(args))
                    end)
                    task.wait(sellInterval)
                end
            end)
        end
    end
})

local sellInterval = 0.1
local Slider = Tab:Slider({
    Title = "出售间隔",
    Value = {
        Min = 0.05,
        Max = 1,
        Default = 0.1
    },
    Callback = function(Value)
        sellInterval = Value
    end
})

local Tab = Tab:Tab({Title = "购买功能", Icon = "settings"})

local seedList = {
    "Cactus Seed",
    "Strawberry Seed", 
    "Pumpkin Seed",
    "Sunflower Seed",
    "Dragon Fruit Seed",
    "Eggplant Seed",
    "Watermelon Seed",
    "Grape Seed",
    "Cocotank Seed",
    "Carnivorous Plant Seed",
    "Mr Carrot Seed",
    "Tomatrio Seed",
    "Shroombino Seed",
    "Mango Seed",
    "King Limone Seed"
}

local chineseNames = {
    ["Cactus Seed"] = "仙人掌种子",
    ["Strawberry Seed"] = "草莓种子",
    ["Pumpkin Seed"] = "南瓜种子",
    ["Sunflower Seed"] = "向日葵种子",
    ["Dragon Fruit Seed"] = "火龙果种子",
    ["Eggplant Seed"] = "茄子种子",
    ["Watermelon Seed"] = "西瓜种子",
    ["Grape Seed"] = "葡萄种子",
    ["Cocotank Seed"] = "可可坦克种子",
    ["Carnivorous Plant Seed"] = "食人植物种子",
    ["Mr Carrot Seed"] = "胡萝卜先生种子",
    ["Tomatrio Seed"] = "番茄三重奏种子",
    ["Shroombino Seed"] = "蘑菇宾诺种子",
    ["Mango Seed"] = "芒果种子",
    ["King Limone Seed"] = "柠檬王种子"
}

local chineseSeedOptions = {}
for engName, chsName in pairs(chineseNames) do
    chineseSeedOptions[chsName] = engName
end

local chineseSeedList = {}
for _, chsName in pairs(chineseNames) do
    table.insert(chineseSeedList, chsName)
end

local selectedSeeds = {}
local Dropdown = Tab:Dropdown({
    Title = "选择要购买的种子",
    Values = chineseSeedList,
    Value = {},
    Multi = true,
    Callback = function(selectedChineseNames)
        selectedSeeds = {}
        for _, chsName in ipairs(selectedChineseNames) do
            local engName = chineseSeedOptions[chsName]
            if engName then
                table.insert(selectedSeeds, engName)
            end
        end
    end
})

local Button = Tab:Button({
    Title = "购买一次选中种子",
    Callback = function()
        for _, seedName in ipairs(selectedSeeds) do
            local args = {
                [1] = seedName,
                [2] = true
            }
            game:GetService("ReplicatedStorage").Remotes.BuyItem:FireServer(unpack(args))
            
            WindUI:Notify({
                Title = "购买成功",
                Content = "已购买: " .. chineseNames[seedName],
                Duration = 2,
                Icon = "shopping-cart"
            })
            task.wait(0.1)
        end
    end
})

local autoBuyEnabled = false
local buyConnection

local Toggle = Tab:Toggle({
    Title = "自动购买选中种子",
    Value = false,
    Callback = function(state)
        autoBuyEnabled = state
        if buyConnection then
            buyConnection:Disconnect()
            buyConnection = nil
        end
        if state then
            buyConnection = RunService.Heartbeat:Connect(function()
                for _, seedName in ipairs(selectedSeeds) do
                    local args = {
                        [1] = seedName,
                        [2] = true
                    }
                    game:GetService("ReplicatedStorage").Remotes.BuyItem:FireServer(unpack(args))
                    task.wait(0.2)
                end
            end)
        end
    end
})

local Button = Tab:Button({
    Title = "强制停止自动购买[防bug可不用]",
    Callback = function()
        autoBuyEnabled = false
        if buyConnection then
            buyConnection:Disconnect()
            buyConnection = nil
        end
        WindUI:Notify({
            Title = "已停止",
            Content = "已停止自动购买",
            Duration = 2,
            Icon = "stop-circle"
        })
    end
})

local Tab = Tabs.Main:Tab({
    Title = "种植花园",
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

