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
    Size = UDim2.fromOffset(500, 200),
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
    Title = "动画包",
    Icon = "false",
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

local Tab = Tabs.Main:Tab({
    Title = "玩家",
    Icon = "settings",
    Locked = false,
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

local Tab = Tabs.Main:Tab({
    Title = "反管理",
    Icon = "settings",
    Locked = false,
})

local Toggle = Tab:Toggle({
    Title = "反管理",
    Default = false,
    Callback = function(state) 
        antiadmin = state
    end
})

local Tab = Tabs.Main:Tab({
    Title = "攻击",
    Icon = "settings",
    Locked = false,
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

local Tab = Tabs.Main:Tab({
    Title = "功能",
    Icon = "settings",
    Locked = false,
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

local Tab = Tabs.Main:Tab({
    Title = "枪皮美化",
    Icon = "settings",
    Locked = false,
})

local Dropdown = Tab:Dropdown({
    Title = "选择一个皮肤",
    Values = { 
        "烟火", "虚空", "纯金", "暗物质", "反物质", "神秘", "虚空神秘", "战术", "纯金战术", 
        "白未来", "黑未来", "圣诞未来", "礼物包装", "猩红", "收割者", "虚空收割者", "圣诞玩具",
        "荒地", "隐形", "像素", "钻石像素", "黄金零下", "绿水晶", "生物", "樱花", "精英", 
        "黑樱花", "彩虹激光", "蓝水晶", "紫水晶", "红水晶", "零下", "虚空射线", "冰冻钻石",
        "虚空梦魇", "金雪", "爱国者", "MM2", "声望", "酷化", "蒸汽", "海盗", "玫瑰", "黑玫瑰",
        "激光", "烟花", "诅咒背瓜", "大炮", "财富", "黄金大炮", "四叶草", "自由", "黑曜石", "赛博朋克"
    },
    Callback = function(Value) 
        if Value == "烟火" then
            skinsec = "Sparkler"
        elseif Value == "虚空" then
            skinsec = "Void"
        elseif Value == "纯金" then
            skinsec = "Solid Gold"
        elseif Value == "暗物质" then
            skinsec = "Dark Matter"
        elseif Value == "反物质" then
            skinsec = "Anti Matter"
        elseif Value == "神秘" then
            skinsec = "Hystic"
        elseif Value == "虚空神秘" then
            skinsec = "Void Mystic"
        elseif Value == "战术" then
            skinsec = "Tactical"
        elseif Value == "纯金战术" then
            skinsec = "Solid Gold Tactical"
        elseif Value == "白未来" then
            skinsec = "Future White"
        elseif Value == "黑未来" then
            skinsec = "Future Black"
        elseif Value == "圣诞未来" then
            skinsec = "Christmas Future"
        elseif Value == "礼物包装" then
            skinsec = "Gift Wrapped"
        elseif Value == "猩红" then
            skinsec = "Crimson Blood"
        elseif Value == "收割者" then
            skinsec = "Reaper"
        elseif Value == "虚空收割者" then
            skinsec = "Void Reaper"
        elseif Value == "圣诞玩具" then
            skinsec = "Christmas Toy"
        elseif Value == "荒地" then
            skinsec = "Wasteland"
        elseif Value == "隐形" then
            skinsec = "Invisible"
        elseif Value == "像素" then
            skinsec = "Pixel"
        elseif Value == "钻石像素" then
            skinsec = "Diamond Pixel"
        elseif Value == "黄金零下" then
            skinsec = "Frozen-Gold"
        elseif Value == "绿水晶" then
            skinsec = "Atomic Nature"
        elseif Value == "生物" then
            skinsec = "Biohazard"
        elseif Value == "樱花" then
            skinsec = "Sakura"
        elseif Value == "精英" then
            skinsec = "Elite"
        elseif Value == "黑樱花" then
            skinsec = "Death Blossom-Gold"
        elseif Value == "彩虹激光" then
            skinsec = "Rainbowlaser"
        elseif Value == "蓝水晶" then
            skinsec = "Atomic Water"
        elseif Value == "紫水晶" then
            skinsec = "Atomic Amethyst"
        elseif Value == "红水晶" then
            skinsec = "Atomic Flame"
        elseif Value == "零下" then
            skinsec = "Sub-Zero"
        elseif Value == "虚空射线" then
            skinsec = "Void-Ray"
        elseif Value == "冰冻钻石" then
            skinsec = "Frozen Diamond"
        elseif Value == "虚空梦魇" then
            skinsec = "Void Nightmare"
        elseif Value == "金雪" then
            skinsec = "Golden Snow"
        elseif Value == "爱国者" then
            skinsec = "Patriot"
        elseif Value == "MM2" then
            skinsec = "MM2 Barrett"
        elseif Value == "声望" then
            skinsec = "Prestige Barnett"
        elseif Value == "酷化" then
            skinsec = "Skin Walter"
        elseif Value == "蒸汽" then
            skinsec = "Steampunk"
        elseif Value == "海盗" then
            skinsec = "Pirate"
        elseif Value == "玫瑰" then
            skinsec = "Rose"
        elseif Value == "黑玫瑰" then
            skinsec = "Black Rose"
        elseif Value == "激光" then
            skinsec = "Hyperlaser"
        elseif Value == "烟花" then
            skinsec = "Firework"
        elseif Value == "诅咒背瓜" then
            skinsec = "Cursed Pumpkin"
        elseif Value == "大炮" then
            skinsec = "Cannon"
        elseif Value == "财富" then
            skinsec = "Firework"
        elseif Value == "黄金大炮" then
            skinsec = "Gold Cannon"
        elseif Value == "四叶草" then
            skinsec = "Lucky Clover"
        elseif Value == "自由" then
            skinsec = "Freedom"
        elseif Value == "黑曜石" then
            skinsec = "Obsidian"
        elseif Value == "赛博朋克" then
            skinsec = "Cyberpunk"
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "开启美化",
    Value = false,
    Callback = function(start) 
        autoskin = start
        if autoskin then
            local it = require(game:GetService("ReplicatedStorage").devv).load("v3item").inventory
            local b1 = require(game:GetService('ReplicatedStorage').devv).load('v3item').inventory.items
            for i, item in next, b1 do 
                if item.type == "Gun" then
                    it.skinUpdate(item.name, skinsec)
                end
            end
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "开启全枪虚空美化",
    Value = false,
    Callback = function(start) 
        skinvoid = start
        if skinvoid then
            local it = require(game:GetService("ReplicatedStorage").devv).load("v3item").inventory
            local b1 = require(game:GetService('ReplicatedStorage').devv).load('v3item').inventory.items
            for i, item in next, b1 do 
                if item.type == "Gun" then
                    table.insert(require(game:GetService("ReplicatedStorage").devv.shared.Indicies.skins.bin.Special.Void).compatabilities, item.name)
                    it.skinUpdate(item.name, "Void")
                end
            end
        end
    end
})

local Tab = Tabs.Main:Tab({
    Title = "自动区",
    Icon = "settings",
    Locked = false,
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

local Tab = Tabs.Main:Tab({
    Title = "绕过区",
    Icon = "settings",
    Locked = false,
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

local Tab = Tabs.Main:Tab({
    Title = "美化区",
    Icon = "settings",
    Locked = false,
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

local Tab = Tabs.Main:Tab({
    Title = "免费物品",
    Icon = "settings",
    Locked = false,
})

local function upgradeFistsToNukeLauncher()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    pcall(function()
        local itemSystem = require(ReplicatedStorage.devv).load("v3item")
        local inventory = itemSystem.inventory
        
        local fistsItem = nil
        for guid, item in pairs(inventory.items) do
            if item.name == "Fists" then
                fistsItem = item
                break
            end
        end
        
        local nukeLauncherData = {
            name = "Admin Nuke Launcher",
            guid = "admin_nuke_launcher_"..tostring(tick()),
            modelName = "Nuke Launcher",
            subtype = "Nuke Launcher",
            adminOnly = true,
            canDrop = false,
            unpurchasable = true,
            ammo = 99999999,
            startAmmo = -1,
            maxAmmo = -1,
            overrideProjectileProperties = {disableNukeFlash = true},
            reloadTime = 0,
            reloadType = "mag",
            firemode = "auto",
            numProjectiles = 1,
            fireDebounce = 0.2,
            viewportOffsets = fistsItem and fistsItem.viewportOffsets or {
                hotbar = {dist = 2.75, offset = CFrame.new(0.25, 0, 0), rotoffset = CFrame.Angles(-0.7853981633974483, -0.7853981633974483, 0.7853981633974483)},
                ammoHUD = {dist = 2, offset = CFrame.new(0, 0, 0), rotoffset = CFrame.Angles(-1.3744467859455345, 0, 3.3379421944391554)}
            },
            TPSOffsets = fistsItem and fistsItem.TPSOffsets or {},
            FPSOffsets = fistsItem and fistsItem.FPSOffsets or {}
        }
        
        if inventory.add then
            inventory.add(nukeLauncherData, false)
            if inventory.currentItemsData then
                table.insert(inventory.currentItemsData, nukeLauncherData)
            end
        end
        
        if fistsItem then
            local fistsCopy = {
                name = "Fists",
                guid = "fists_copy_"..tostring(tick()),
                permanent = true,
                cannotDiscard = true,
                doMakeModel = false,
                debounce = 0.3,
                damageTable = {meleepunch = 15, meleemegapunch = 200, meleekick = 20, meleejumpKick = 20},
                viewportOffsets = fistsItem.viewportOffsets,
                TPSOffsets = fistsItem.TPSOffsets or {},
                FPSOffsets = fistsItem.FPSOffsets or {}
            }
            if inventory.add then
                inventory.add(fistsCopy, false)
            end
        end
        
        if inventory.rerender then
            inventory:rerender()
        end
    end)
end

local Button = Tab:Button({
    Title = "获取管理员核弹发射器",
    Callback = function()
        upgradeFistsToNukeLauncher()
    end
})

local function getAdminRPG()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    pcall(function()
        local itemSystem = require(ReplicatedStorage.devv).load("v3item")
        local inventory = itemSystem.inventory
        
        local rpgData = {
            name = "Admin RPG",
            guid = "admin_rpg_"..tostring(tick()),
            modelName = "RPG",
            subtype = "RPG",
            adminOnly = true,
            canDrop = false,
            unpurchasable = true,
            ammo = 99999999,
            startAmmo = -1,
            maxAmmo = -1,
            reloadTime = 0,
            reloadType = "mag",
            firemode = "auto",
            numProjectiles = 1,
            fireDebounce = 0.02,
            recoilAdd = 0,
            maxRecoil = 0,
            recoilDiminishFactor = 0,
            recoilFastDiminishFactor = 0
        }
        
        if inventory.add then
            inventory.add(rpgData, false)
            if inventory.currentItemsData then
                table.insert(inventory.currentItemsData, rpgData)
            end
        end
        
        if inventory.rerender then
            inventory:rerender()
        end
    end)
end

local function getAdminAK47()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    pcall(function()
        local itemSystem = require(ReplicatedStorage.devv).load("v3item")
        local inventory = itemSystem.inventory
        
        local ak47Data = {
            name = "Admin AK-47",
            guid = "admin_ak47_"..tostring(tick()),
            modelName = "Gold AK-47",
            subtype = "AK-47",
            adminOnly = true,
            canDrop = false,
            unpurchasable = true,
            damage = 10,
            ammo = 999999999,
            startAmmo = -1,
            maxAmmo = -1,
            firemode = "auto",
            numProjectiles = 8,
            fireDebounce = 0.01
        }
        
        if inventory.add then
            inventory.add(ak47Data, false)
            if inventory.currentItemsData then
                table.insert(inventory.currentItemsData, ak47Data)
            end
        end
        
        if inventory.rerender then
            inventory:rerender()
        end
    end)
end

local Button = Tab:Button({Title = "获取管理员RPG", Callback = getAdminRPG})
local Button = Tab:Button({Title = "获取管理员AK-47", Callback = getAdminAK47})

local function getAllBalloons()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    pcall(function()
        local itemSystem = require(ReplicatedStorage.devv).load("v3item")
        local inventory = itemSystem.inventory
        
        local fistsItem = nil
        for guid, item in pairs(inventory.items) do
            if item.name == "Fists" then
                fistsItem = item
                break
            end
        end
        
        local hdir = ReplicatedStorage.devv.shared.Indicies.v3items.bin.Holdable
        if hdir then
            for _, hmd in pairs(hdir:GetChildren()) do
                if hmd:IsA("ModuleScript") then
                    pcall(function()
                        local hdat = require(hmd)
                        if hdat and hdat.name and hdat.holdableType == "Balloon" then
                            local hnew = {
                                name = hdat.name,
                                guid = hdat.name:gsub("%s", "_"):lower() .. "_" .. tostring(tick()),
                                modelName = hdat.modelName or hdat.name,
                                holdableType = "Balloon",
                                multiplier = hdat.multiplier or 0.5,
                                movespeedAdd = hdat.movespeedAdd or 0,
                                canDrop = false,
                                cannotDiscard = true,
                                permanent = true,
                                unpurchasable = true,
                                TPSOffsets = hdat.TPSOffsets or {},
                                viewportOffsets = hdat.viewportOffsets or (fistsItem and fistsItem.viewportOffsets)
                            }
                            if inventory.add then
                                inventory.add(hnew, false)
                                if inventory.currentItemsData then
                                    table.insert(inventory.currentItemsData, hnew)
                                end
                            end
                        end
                    end)
                end
            end
        end
        
        if fistsItem then
            local fistsCopy = {
                name = "Fists",
                guid = "fists_copy_" .. tostring(tick()),
                permanent = true,
                cannotDiscard = true,
                doMakeModel = false,
                debounce = 0.3,
                damageTable = {
                    meleepunch = 15,
                    meleemegapunch = 200,
                    meleekick = 20,
                    meleejumpKick = 20
                },
                viewportOffsets = fistsItem.viewportOffsets,
                TPSOffsets = fistsItem.TPSOffsets or {},
                FPSOffsets = fistsItem.FPSOffsets or {}
            }
            if inventory.add then
                inventory.add(fistsCopy, false)
            end
        end
        
        if inventory.rerender then
            inventory:rerender()
        end
    end)
end

local function getDollarBalloon()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    pcall(function()
        local itemSystem = require(ReplicatedStorage.devv).load("v3item")
        local inventory = itemSystem.inventory
        
        local fistsItem = nil
        for guid, item in pairs(inventory.items) do
            if item.name == "Fists" then
                fistsItem = item
                break
            end
        end
        
        local dollarBalloonData = {
            name = "Dollar Balloon",
            guid = "dollar_balloon_" .. tostring(tick()),
            modelName = "Dollar Balloon",
            holdableType = "Balloon",
            multiplier = 0.8,
            movespeedAdd = 8,
            canDrop = false,
            cannotDiscard = true,
            permanent = true,
            unpurchasable = true,
            TPSOffsets = {
                hold = CFrame.new(0, 0, 0) * CFrame.Angles(0, math.pi, 0)
            },
            viewportOffsets = {
                hotbar = {
                    dist = 4,
                    offset = CFrame.new(0, 0, 0),
                    rotoffset = CFrame.Angles(0, 0, 0)
                },
                ammoHUD = {
                    dist = 5,
                    offset = CFrame.new(0, 0, 0),
                    rotoffset = CFrame.Angles(0, 0, 0)
                }
            }
        }
        
        if inventory.add then
            inventory.add(dollarBalloonData, false)
            if inventory.currentItemsData then
                table.insert(inventory.currentItemsData, dollarBalloonData)
            end
        end
        
        if fistsItem then
            local fistsCopy = {
                name = "Fists",
                guid = "fists_copy_" .. tostring(tick()),
                permanent = true,
                cannotDiscard = true,
                doMakeModel = false,
                debounce = 0.3,
                damageTable = {
                    meleepunch = 15,
                    meleemegapunch = 200,
                    meleekick = 20,
                    meleejumpKick = 20
                },
                viewportOffsets = fistsItem.viewportOffsets,
                TPSOffsets = fistsItem.TPSOffsets or {},
                FPSOffsets = fistsItem.FPSOffsets or {}
            }
            if inventory.add then
                inventory.add(fistsCopy, false)
            end
        end
        
        if inventory.rerender then
            inventory:rerender()
        end
    end)
end

local Button = Tab:Button({Title = "获取所有气球", Callback = getAllBalloons})
local Button = Tab:Button({Title = "获取美金球", Callback = getDollarBalloon})

local Tab = Tabs.Main:Tab({
    Title = "其他功能",
    Icon = "settings",
    Locked = false,
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

