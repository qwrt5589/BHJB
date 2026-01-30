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

local Tab = Window:Tab({
    Title = "服务器脚本",
    Icon = "layout-grid",
    Locked = false,
})

local plr = game.Players.LocalPlayer

local scriptData = {
    ["泰坦训练模拟器"] = "loadstring(game:HttpGet('https://raw.githubusercontent.com/qwrt5589/BHJB/main/泰坦训练.lua'))()",
    ["俄亥俄州"] = "loadstring(game:HttpGet('https://raw.githubusercontent.com/qwrt5589/BHJB/main/辰俄亥俄州.lua'))()",
    ["躲避"] = "loadstring(game:HttpGet('https://raw.githubusercontent.com/qwrt5589/BHJB/main/躲避.lua'))()",
    ["请捐赠"] = "loadstring(game:HttpGet('https://raw.githubusercontent.com/qwrt5589/BHJB/main/请捐赠.lua'))()",
    ["自然灾害"] = "loadstring(game:HttpGet('https://raw.githubusercontent.com/qwrt5589/BHJB/main/自然灾害.lua'))()",
    ["种植花园"] = "loadstring(game:HttpGet('https://raw.githubusercontent.com/qwrt5589/BHJB/main/种植花园.lua'))()",
    ["盲射"] = "loadstring(game:HttpGet('https://raw.githubusercontent.com/qwrt5589/BHJB/main/盲射.lua'))()",
    ["汽车营销大亨"] = "loadstring(game:HttpGet('https://raw.githubusercontent.com/qwrt5589/BHJB/main/汽车营销大亨.lua'))()",
    ["植物大战脑红"] = "loadstring(game:HttpGet('https://raw.githubusercontent.com/qwrt5589/BHJB/main/植物大战脑红.lua'))()",
    ["极速传奇"] = "loadstring(game:HttpGet('https://raw.githubusercontent.com/qwrt5589/BHJB/main/极速传奇.lua'))()",
    ["恶魔学"] = "loadstring(game:HttpGet('https://raw.githubusercontent.com/qwrt5589/BHJB/main/恶魔学.lua'))()",
    ["建造你的基地"] = "loadstring(game:HttpGet('https://raw.githubusercontent.com/qwrt5589/BHJB/main/建造你的基地.lua'))()",
    ["墨水游戏"] = "loadstring(game:HttpGet('https://raw.githubusercontent.com/qwrt5589/BHJB/main/墨水游戏.lua'))()",
    ["在超市生活一周"] = "loadstring(game:HttpGet('https://raw.githubusercontent.com/qwrt5589/BHJB/main/在超市生活一周.lua'))()",
    ["元素力量大亨"] = "loadstring(game:HttpGet('https://raw.githubusercontent.com/qwrt5589/BHJB/main/元素力量大亨.lua'))()"
}

local Dropdown = Tab:Dropdown({
    Title = "选择要启动的服务器脚本",
    Values = { 
        "泰坦训练模拟器", "俄亥俄州", "躲避", "请捐赠", "自然灾害", 
        "种植花园", "盲射", "汽车营销大亨", "植物大战脑红", "极速传奇", 
        "恶魔学", "建造你的基地", "墨水游戏", "在超市生活一周", "元素力量大亨"
    },
    Callback = function(Value) 
        if not plr.Character then
            WindUI:Notify({
                Title = "错误",
                Content = "角色不存在",
                Duration = 3,
                Icon = "alert-triangle"
            })
            return
        end
        
        local scriptCode = scriptData[Value]
        if scriptCode then
            WindUI:Notify({
                Title = "脚本启动",
                Content = "正在启动: " .. Value,
                Duration = 3,
                Icon = "loader"
            })
            
            -- 播放音效
            pcall(function()
                local sound = Instance.new("Sound")
                sound.SoundId = "rbxassetid://9047002353"
                sound.Volume = 0.3
                sound.Parent = game:GetService("SoundService")
                sound:Play()
                game:GetService("Debris"):AddItem(sound, 2)
            end)
            
            -- 执行脚本
            pcall(function()
                loadstring(scriptCode)()
            end)
            
            WindUI:Notify({
                Title = "脚本状态",
                Content = Value .. " 已启动",
                Duration = 3,
                Icon = "check-circle"
            })
        else
            WindUI:Notify({
                Title = "错误",
                Content = "找不到脚本: " .. Value,
                Duration = 3,
                Icon = "alert-triangle"
            })
        end
    end
})

local Button = Tab:Button({
    Title = "一键启动所有脚本",
    Callback = function()
        WindUI:Notify({
            Title = "批量启动",
            Content = "正在启动所有脚本，可能会造成卡顿",
            Duration = 5,
            Icon = "loader"
        })
        
        local successCount = 0
        local failCount = 0
        
        for scriptName, scriptCode in pairs(scriptData) do
            pcall(function()
                loadstring(scriptCode)()
                successCount = successCount + 1
            end)
            
            if not pcall(function() loadstring(scriptCode)() end) then
                failCount = failCount + 1
            end
            
            wait(0.1)
        end
        
        WindUI:Notify({
            Title = "批量启动完成",
            Content = string.format("成功: %d, 失败: %d", successCount, failCount),
            Duration = 5,
            Icon = check-circle
        })
    end
})

local Tabs = {
    Main = Window:Section({ Title = "脚本", Opened = true }),
    Settings = Window:Section({ Title = "作者:路西法", Opened = true }),
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

local Slider = Tab:Slider({
    Title = "物理 Speed",
    Placeholder = "输入物理速度 (最低0，最高无上限)",
    Default = "",
    Description = "例如: 150",
    Callback = function(value)
        local numValue = tonumber(value)
        if numValue and numValue >= 0 then
            PhysicsSpeedValue = numValue
            WindUI:Notify({Title = "速度设置", Content = "Physics速度已设置为: " .. numValue})
        else
            WindUI:Notify({Title = "错误", Content = "请输入有效的数字 (≥ 0)"})
        end
    end
})

local Button = Tab:Button({
    Title = "启用物理 Speed",
    Callback = function()
        if PhysicsSpeedValue == nil then
            WindUI:Notify({Title = "错误", Content = "请先输入Physics速度值"})
            return
        end
        
        if PhysicsEnabled then
            WindUI:Notify({Title = "提示", Content = "Physics速度已在运行"})
            return
        end
        
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local root = character:WaitForChild("HumanoidRootPart")
        
        PhysicsBV = Instance.new("BodyVelocity")
        PhysicsBV.Velocity = Vector3.new(0, 0, 0)
        PhysicsBV.MaxForce = Vector3.new(math.huge, 0, math.huge)
        PhysicsBV.Parent = root
        
        PhysicsEnabled = true
        
        game:GetService("RunService").Heartbeat:Connect(function()
            if not PhysicsEnabled then return end
            if character:FindFirstChild("Humanoid") then
                local moveDirection = character.Humanoid.MoveDirection
                PhysicsBV.Velocity = moveDirection * PhysicsSpeedValue
            end
        end)
        
        WindUI:Notify({Title = "Physics Speed", Content = "已启用, 速度: " .. PhysicsSpeedValue})
    end
})

local Button = Tab:Button({
    Title = "禁用物理 Speed",
    Callback = function()
        if PhysicsBV then
            PhysicsBV:Destroy()
            PhysicsBV = nil
        end
        PhysicsEnabled = false
        WindUI:Notify({Title = "Physics Speed", Content = "已禁用"})
    end
})

local Slider = Tab:Slider({
    Title = "传送 Speed",
    Placeholder = "输入传送距离 (最低0，最高无上限)",
    Default = "",
    Description = "例如: 5",
    Callback = function(value)
        local numValue = tonumber(value)
        if numValue and numValue >= 0 then
            TeleportSpeedValue = numValue
            WindUI:Notify({Title = "距离设置", Content = "Teleport距离已设置为: " .. numValue})
        else
            WindUI:Notify({Title = "错误", Content = "请输入有效的数字 (≥ 0)"})
        end
    end
})

local Button = Tab:Button({
    Title = "启用Teleport Speed",
    Callback = function()
        if TeleportSpeedValue == nil then
            WindUI:Notify({Title = "错误", Content = "请先输入Teleport距离值"})
            return
        end
        
        if TeleportEnabled then
            WindUI:Notify({Title = "提示", Content = "Teleport速度已在运行"})
            return
        end
        
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local root = character:WaitForChild("HumanoidRootPart")
        
        TeleportEnabled = true
        
        game:GetService("RunService").Heartbeat:Connect(function()
            if not TeleportEnabled then return end
            if character:FindFirstChild("Humanoid") then
                local moveDirection = character.Humanoid.MoveDirection
                if moveDirection.Magnitude > 0 then
                    root.CFrame = root.CFrame + (moveDirection * TeleportSpeedValue)
                end
            end
        end)
        
        WindUI:Notify({Title = "Teleport Speed", Content = "已启用, 距离: " .. TeleportSpeedValue})
    end
})

local Button = Tab:Button({
    Title = "禁用传送 Speed",
    Callback = function()
        TeleportEnabled = false
        WindUI:Notify({Title = "Teleport Speed", Content = "已禁用"})
    end
})

local Slider = Tab:Slider({
    Title = "跳跃高度2",
    Placeholder = "输入跳跃高度 (最低0，最高无上限)",
    Default = "",
    Description = "例如: 150",
    Callback = function(value)
        local numValue = tonumber(value)
        if numValue and numValue >= 0 then
            JumpPowerValue = numValue
            WindUI:Notify({Title = "高度设置", Content = "跳跃高度已设置为: " .. numValue})
        else
            WindUI:Notify({Title = "错误", Content = "请输入有效的数字 (≥ 0)"})
        end
    end
})

local Button = Tab:Button({
    Title = "启用跳跃高度2",
    Callback = function()
        if JumpPowerValue == nil then
            WindUI:Notify({Title = "错误", Content = "请先输入跳跃高度"})
            return
        end
        
        if JumpEnabled then
            WindUI:Notify({Title = "提示", Content = "跳跃高度已在运行"})
            return
        end
        
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        
        humanoid.JumpPower = JumpPowerValue
        
        JumpEnabled = true
        
        game:GetService("RunService").Heartbeat:Connect(function()
            if not JumpEnabled then return end
            if humanoid.JumpPower ~= JumpPowerValue then
                humanoid.JumpPower = JumpPowerValue
            end
        end)
        
        WindUI:Notify({Title = "Jump Power", Content = "已启用, 跳跃高度: " .. JumpPowerValue})
    end
})

local Button = Tab:Button({
    Title = "禁用跳跃高度2",
    Callback = function()
        JumpEnabled = false
        
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = 50
        end
        
        WindUI:Notify({Title = "Jump Power", Content = "已禁用"})
    end
})

local downloadInput = Tab:Input({
    Title = "下载文件URL",
    Placeholder = "输入文件下载链接",
    Default = "",
    Description = "例如: https://raw.githubusercontent.com/xxxxx(其他的链接也可以)",
    Callback = function(url)
        
    end
})

local Button = Tab:Button({
    Title = "下载文件",
    Callback = function()
        local url = downloadInput.Value
        if url == "" or url == nil then
            WindUI:Notify({
                Title = "下载失败",
                Content = "请输入有效的URL",
                Duration = 5
            })
            return
        end
        
        if string.find(url:lower(), "loadstring") and string.find(url:lower(), "game:httpget") then
            WindUI:Notify({
                Title = "下载失败",
                Content = "URL格式错误",
                Duration = 5
            })
            return
        end
        
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        
        if success and content then
            local filename = "downloaded_file(您下载的文件).txt"
            local lastSlash = string.match(url, "([^/]+)$")
            if lastSlash then
                filename = lastSlash
                filename = string.gsub(filename, "%?.*", "")
            end
            
            local writeSuccess, writeError = pcall(function()
                writefile(filename, content)
            end)
            
            if writeSuccess then
                WindUI:Notify({
                    Title = "下载成功",
                    Content = "文件已保存: " .. filename,
                    Duration = 5
                })
                
                wait(3)
                
                WindUI:Notify({
                    Title = "文件位置提示",
                    Content = "文件保存在脚本工作目录下的: " .. filename .. "\n请查看执行器的文件管理器",
                    Duration = 8
                })
            else
                WindUI:Notify({
                    Title = "下载失败",
                    Content = "文件保存失败: " .. tostring(writeError),
                    Duration = 5
                })
            end
        else
            WindUI:Notify({
                Title = "下载失败",
                Content = "无法从URL获取内容: " .. tostring(content),
                Duration = 5
            })
        end
    end
})

local Button = Tab:Button({
    Title = "提升fps",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/smalldesikon/hun/ee906e570c0f5b22e580a20decaba23757533569/fps"))()
    end
})

local Button = Tab:Button({
    Title = "好用隐身",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/3Rnd9rHf"))()
    end
})

local Toggle = Tab:Toggle({
    Title = "无限跳(可开关)",
    Default = false,
    Callback = function(Value)
        Jump = Value
        game:GetService("UserInputService").JumpRequest:Connect(function()
            if Jump then
                game.Players.LocalPlayer.Character.Humanoid:ChangeState("Jumping")
            end
        end)
    end
})

local Button = Tab:Button({
    Title = "无限跳(关不了)",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/V5PQy3y0", true))()
    end
})

local Button = Tab:Button({
    Title = "飞行(by天下布武)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Twbtx/tiamxiabuwu/main/t%20x%20b%20w%20fly"))()
    end
})

local Button = Tab:Button({
    Title = "司空同款飞行",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
    end
})

local Button = Tab:Button({
    Title = "阿尔飞行",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/5zJu3hfN"))()
    end
})

local Button = Tab:Button({
    Title = "踏空行走",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Float'))()
    end
})

local Button = Tab:Button({
    Title = "无头加短腿美化",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Permanent-Headless-And-korblox-Script-4140"))()
    end
})

local Button = Tab:Button({
    Title = "动态模糊",
    Callback = function()
        local camera = workspace.CurrentCamera
        local blurAmount = 10
        local blurAmplifier = 5
        local lastVector = camera.CFrame.LookVector
        
        local motionBlur = Instance.new("BlurEffect", camera)
        
        local runService = game:GetService("RunService")
        
        workspace.Changed:Connect(function(property)
            if property == "CurrentCamera" then
                print("Changed")
                local camera = workspace.CurrentCamera
                if motionBlur and motionBlur.Parent then
                    motionBlur.Parent = camera
                else
                    motionBlur = Instance.new("BlurEffect", camera)
                end
            end
        end)
        
        runService.Heartbeat:Connect(function()
            if not motionBlur or motionBlur.Parent == nil then
                motionBlur = Instance.new("BlurEffect", camera)
            end
            
            local magnitude = (camera.CFrame.LookVector - lastVector).magnitude
            motionBlur.Size = math.abs(magnitude)*blurAmount*blurAmplifier/2
            lastVector = camera.CFrame.LookVector
        end)
    end
})

local Toggle = Tab:Toggle({
    Title = "穿墙模式",
    Default = false,
    Callback = function(state)
        _G.noclip = state
        
        if state then
            if not game:GetService('Players').LocalPlayer.Character:FindFirstChild("LowerTorso") then
                local connection = game:GetService("RunService").Stepped:Connect(function()
                    if not _G.noclip then connection:Disconnect() return end
                    game.Players.LocalPlayer.Character.Head.CanCollide = false
                    game.Players.LocalPlayer.Character.Torso.CanCollide = false
                end)
            else
                if _G.InitNC ~= true then
                    _G.NCFunc = function(part)
                        local pos = game:GetService('Players').LocalPlayer.Character.LowerTorso.Position.Y
                        if _G.noclip and part.Position.Y > pos then
                            part.CanCollide = false
                        end
                    end
                    _G.InitNC = true
                end
                game:GetService('Players').LocalPlayer.Character.Humanoid.Touched:Connect(_G.NCFunc)
            end
        else
            if game.Players.LocalPlayer.Character then
                for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "夜视",
    Default = false,
    Callback = function(a)
        if a then
            game.Lighting.Ambient = Color3.new(1, 1, 1)
        else
            game.Lighting.Ambient = Color3.new(0, 0, 0)
        end
    end
})

local Button = Tab:Button({
    Title = "秒互动(无法关闭)",
    Callback = function()
        game.ProximityPromptService.PromptButtonHoldBegan:Connect(function(v)
            v.HoldDuration = 0
        end)
    end
})

local Toggle = Tab:Toggle({
    Title = "自动互动",
    Default = false,
    Callback = function(state)
        if state then
            autoInteract = true
            while autoInteract do
                for _, descendant in pairs(workspace:GetDescendants()) do
                    if descendant:IsA("ProximityPrompt") then
                        fireproximityprompt(descendant)
                    end
                end
                task.wait(0.2)
            end
        else
            autoInteract = false
        end
    end
})

local Button = Tab:Button({
    Title = "一键偷别人的东西",
    Callback = function()
        for i,v in pairs (game.Players:GetChildren()) do
            wait()
            for i,b in pairs (v.Backpack:GetChildren()) do
                b.Parent = game.Players.LocalPlayer.Backpack
            end
        end
    end
})

local Button = Tab:Button({
    Title = "通用透视1(关不掉)",
    Callback = function()
        while wait(1) do
            local players = game.Players:GetPlayers()
            
            for i,v in pairs(players) do
                local esp = Instance.new("Highlight")
                esp.Name = v.Name
                esp.FillTransparency = 0.5
                esp.FillColor = Color3.new(0, 0, 0)
                esp.OutlineColor = Color3.new(255, 255, 255)
                esp.OutlineTransparency = 0
                esp.Parent = v.Character
            end
        end
    end
})

local Button = Tab:Button({
    Title = "通用透视2",
    Callback = function()
        local getnamecallmethod = getnamecallmethod
        local Speaker = cloneref(game:GetService("Players")).LocalPlayer
        local OldNameCall
        OldNameCall = hookmetamethod(game, "__namecall", function(self, ...)
            if self ~= Speaker or getnamecallmethod() ~= "IsInGroup" then
                return OldNameCall(self, ...)
            end
            return true
        end)
        hookfunction(Speaker.IsInGroup, function(self, ...)
            return true
        end)
        
        loadstring(game:GetObjects("rbxassetid://10092697033")[1].Source)()
    end
})

local Button = Tab:Button({
    Title = "↓↓以下的透视有bug↓↓",
    Callback = function()
        
    end
})

local Button = Tab:Button({
    Title = "关闭所有透视(关不了上面的透视)",
    Callback = function()
        if getgenv().HealthBarESP then
            for player, espData in pairs(getgenv().HealthBarESP) do
                if espData and espData.Billboard then
                    espData.Billboard:Destroy()
                end
            end
            getgenv().HealthBarESP = nil
        end
        
        if getgenv().PlayerHighlight then
            if getgenv().PlayerHighlight.TeamConnection then
                getgenv().PlayerHighlight.TeamConnection:Disconnect()
            end
            for player, highlightData in pairs(getgenv().PlayerHighlight.Table) do
                if highlightData and highlightData.Highlight then
                    highlightData.Highlight:Destroy()
                end
            end
            getgenv().PlayerHighlight = nil
        end
        
        if getgenv().NPCHighlight then
            if getgenv().NPCHighlight.ScanConnection then
                getgenv().NPCHighlight.ScanConnection:Disconnect()
            end
            if getgenv().NPCHighlight.DescendantConnection then
                getgenv().NPCHighlight.DescendantConnection:Disconnect()
            end
            for npc, highlightData in pairs(getgenv().NPCHighlight.Table) do
                if highlightData and highlightData.Highlight then
                    highlightData.Highlight:Destroy()
                end
            end
            getgenv().NPCHighlight = nil
        end
        
        if getgenv().NPCESP then
            if getgenv().NPCESP.ScanConnection then
                getgenv().NPCESP.ScanConnection:Disconnect()
            end
            if getgenv().NPCESP.DescendantConnection then
                getgenv().NPCESP.DescendantConnection:Disconnect()
            end
            for npc, espData in pairs(getgenv().NPCESP.Table) do
                if espData then
                    if espData.Billboard then espData.Billboard:Destroy() end
                    if espData.Highlight then espData.Highlight:Destroy() end
                end
            end
            getgenv().NPCESP = nil
        end
        
        if getgenv().EnemyPlayerESP then
            if getgenv().EnemyPlayerESP.Connection then
                getgenv().EnemyPlayerESP.Connection:Disconnect()
            end
            for player, espData in pairs(getgenv().EnemyPlayerESP.Table) do
                if espData then
                    if espData.Billboard then espData.Billboard:Destroy() end
                    if espData.Highlight then espData.Highlight:Destroy() end
                end
            end
            getgenv().EnemyPlayerESP = nil
        end
        
        if getgenv().EnemyNPCESP then
            if getgenv().EnemyNPCESP.ScanConnection then
                getgenv().EnemyNPCESP.ScanConnection:Disconnect()
            end
            if getgenv().EnemyNPCESP.DescendantConnection then
                getgenv().EnemyNPCESP.DescendantConnection:Disconnect()
            end
            for npc, espData in pairs(getgenv().EnemyNPCESP.Table) do
                if espData then
                    if espData.Billboard then espData.Billboard:Destroy() end
                    if espData.Highlight then espData.Highlight:Destroy() end
                end
            end
            getgenv().EnemyNPCESP = nil
        end
        
        if getgenv().DistanceESP then
            if getgenv().DistanceESP.Connection then
                getgenv().DistanceESP.Connection:Disconnect()
            end
            for player, espData in pairs(getgenv().DistanceESP.Table) do
                if espData and espData.Billboard then
                    espData.Billboard:Destroy()
                end
            end
            getgenv().DistanceESP = nil
        end
        
        if getgenv().ToolESP then
            if getgenv().ToolESP.Connection then
                getgenv().ToolESP.Connection:Disconnect()
            end
            for player, espData in pairs(getgenv().ToolESP.Table) do
                if espData then
                    if espData.Billboard then espData.Billboard:Destroy() end
                    if espData.Highlight then espData.Highlight:Destroy() end
                    if espData.ToolConnection then espData.ToolConnection:Disconnect() end
                end
            end
            getgenv().ToolESP = nil
        end
        
        if ESPConnection then
            ESPConnection:Disconnect()
            ESPConnection = nil
        end
        CleanupESP()
        
        ESPData = {
            BoxESP = false,
            SkeletonESP = false,
            NameESP = false,
            TracerESP = false
        }
        
        local Players = game:GetService("Players")
        local Workspace = game:GetService("Workspace")
        
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                local healthBar = player.Character:FindFirstChild("HealthBar_" .. player.Name)
                if healthBar then healthBar:Destroy() end
                
                local distanceDisplay = player.Character:FindFirstChild("DistanceDisplay_" .. player.Name)
                if distanceDisplay then distanceDisplay:Destroy() end
                
                local highlight = player.Character:FindFirstChild("PlayerHighlight")
                if highlight then highlight:Destroy() end
                
                local enemyESP = player.Character:FindFirstChild("EnemyPlayerESP_" .. player.Name)
                if enemyESP then enemyESP:Destroy() end
                
                local enemyHighlight = player.Character:FindFirstChild("EnemyPlayerHighlight")
                if enemyHighlight then enemyHighlight:Destroy() end
                
                for _, child in ipairs(player.Character:GetDescendants()) do
                    if child:IsA("BillboardGui") and (string.find(child.Name, "ToolESP_") or string.find(child.Name, "EnemyPlayerESP_")) then
                        child:Destroy()
                    end
                    if child:IsA("Highlight") and (string.find(child.Name, "ToolHighlight_") or string.find(child.Name, "EnemyPlayerHighlight")) then
                        child:Destroy()
                    end
                end
            end
        end
        
        for _, descendant in pairs(Workspace:GetDescendants()) do
            if descendant:IsA("Model") then
                for _, child in ipairs(descendant:GetDescendants()) do
                    if child:IsA("Highlight") and (child.Name == "NPCHighlight" or child.Name == "NPCESP_Highlight" or string.find(child.Name, "EnemyNPCHighlight")) then
                        child:Destroy()
                    end
                    
                    if child:IsA("BillboardGui") and (string.find(child.Name, "NPCESP_") or string.find(child.Name, "EnemyNPCESP_")) then
                        child:Destroy()
                    end
                end
            end
        end
        
        if getgenv().OriginalCameraProperties then
            workspace.CurrentCamera.CameraType = getgenv().OriginalCameraProperties.CameraType
            workspace.CurrentCamera.CameraSubject = getgenv().OriginalCameraProperties.CameraSubject
            getgenv().OriginalCameraProperties = nil
        end
        
        if getgenv().WallhackConnection then
            getgenv().WallhackConnection:Disconnect()
            getgenv().WallhackConnection = nil
        end
        
        if getgenv().BulletTrack then
            local GameMetaTable = getrawmetatable(game)
            setreadonly(GameMetaTable, false)
            GameMetaTable.__namecall = getgenv().BulletTrack.OldNamecall
            setreadonly(GameMetaTable, true)
            getgenv().BulletTrack = nil
        end
        
        if BulletTrack.oldHook then
            removeHook()
        end
        BulletTrack.enabled = false
        
        WindUI:Notify({Title = "透视", Content = "所有透视已关闭"})
    end
})

local Toggle = Tab:Toggle({
    Title = "透视所有玩家",
    Default = false,
    Callback = function(value)
        if value then
            local Players = game:GetService("Players")
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character then
                    local head = player.Character:FindFirstChild("Head")
                    if head then
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "PlayerESP_" .. player.Name
                        highlight.FillColor = Color3.fromRGB(255, 0, 0)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
                        highlight.FillTransparency = 0.3
                        highlight.OutlineTransparency = 0.3
                        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        highlight.Parent = head
                    end
                end
            end
        else
            for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                if player.Character then
                    local head = player.Character:FindFirstChild("Head")
                    if head then
                        local esp = head:FindFirstChild("PlayerESP_" .. player.Name)
                        if esp then
                            esp:Destroy()
                        end
                    end
                end
            end
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "血量条显示",
    Default = false,
    Callback = function(Value)
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local ESPTable = {}

        if Value then
            local function CreateHealthBar(player)
                if ESPTable[player] then return end
                
                local character = player.Character
                if not character then return end
                
                local humanoid = character:WaitForChild("Humanoid", 5)
                local head = character:WaitForChild("Head", 5)
                
                if not humanoid or not head then return end
                
                if head:FindFirstChild("HealthBar_" .. player.Name) then
                    head:FindFirstChild("HealthBar_" .. player.Name):Destroy()
                end
                
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "HealthBar_" .. player.Name
                billboard.Adornee = head
                billboard.Size = UDim2.new(0, 80, 0, 15)
                billboard.StudsOffset = Vector3.new(0, 2.5, 0)
                billboard.AlwaysOnTop = true
                billboard.ResetOnSpawn = false
                billboard.Parent = head
                
                local background = Instance.new("Frame")
                background.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
                background.BackgroundTransparency = 0.3
                background.Size = UDim2.new(1, 0, 1, 0)
                background.BorderSizePixel = 0
                background.Parent = billboard
                
                local healthBar = Instance.new("Frame")
                healthBar.BackgroundColor3 = Color3.new(0, 1, 0)
                healthBar.BorderSizePixel = 0
                healthBar.Size = UDim2.new(humanoid.Health / humanoid.MaxHealth, 0, 1, 0)
                healthBar.Parent = background
                
                local healthText = Instance.new("TextLabel")
                healthText.Size = UDim2.new(1, 0, 1, 0)
                healthText.BackgroundTransparency = 1
                healthText.Text = tostring(math.floor(humanoid.Health))
                healthText.TextColor3 = Color3.new(1, 1, 1)
                healthText.TextStrokeTransparency = 0
                healthText.TextSize = 12
                healthText.Font = Enum.Font.GothamBold
                healthText.Parent = background
                
                ESPTable[player] = {
                    Billboard = billboard,
                    HealthBar = healthBar,
                    HealthText = healthText,
                    Humanoid = humanoid
                }
                
                local healthConnection
                healthConnection = humanoid.HealthChanged:Connect(function()
                    UpdateHealthBar(player)
                end)
                
                local characterRemovingConnection
                characterRemovingConnection = player.CharacterRemoving:Connect(function()
                    if ESPTable[player] then
                        RemoveHealthBar(player)
                    end
                end)
                
                ESPTable[player].Connections = {
                    HealthChanged = healthConnection,
                    CharacterRemoving = characterRemovingConnection
                }
            end

            local function UpdateHealthBar(player)
                local espData = ESPTable[player]
                if not espData then return end
                
                local humanoid = espData.Humanoid
                if not humanoid or humanoid.Health <= 0 then
                    RemoveHealthBar(player)
                    return
                end
                
                local healthPercent = humanoid.Health / humanoid.MaxHealth
                espData.HealthBar.Size = UDim2.new(healthPercent, 0, 1, 0)
                espData.HealthText.Text = tostring(math.floor(humanoid.Health))
                
                if healthPercent > 0.7 then
                    espData.HealthBar.BackgroundColor3 = Color3.new(0, 1, 0)
                elseif healthPercent > 0.3 then
                    espData.HealthBar.BackgroundColor3 = Color3.new(1, 1, 0)
                else
                    espData.HealthBar.BackgroundColor3 = Color3.new(1, 0, 0)
                end
            end

            local function RemoveHealthBar(player)
                local espData = ESPTable[player]
                if espData then
                    if espData.Connections then
                        for _, connection in pairs(espData.Connections) do
                            if connection then
                                connection:Disconnect()
                            end
                        end
                    end
                    
                    if espData.Billboard and espData.Billboard.Parent then
                        espData.Billboard:Destroy()
                    end
                    
                    ESPTable[player] = nil
                end
            end

            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    if player.Character then
                        coroutine.wrap(CreateHealthBar)(player)
                    end
                    player.CharacterAdded:Connect(function(character)
                        wait(1)
                        CreateHealthBar(player)
                    end)
                end
            end
            
            Players.PlayerAdded:Connect(function(player)
                player.CharacterAdded:Connect(function(character)
                    wait(1)
                    CreateHealthBar(player)
                end)
            end)
            
            Players.PlayerRemoving:Connect(function(player)
                if ESPTable[player] then
                    RemoveHealthBar(player)
                end
            end)
            
            getgenv().HealthBarESP = ESPTable
            
        else
            for player, espData in pairs(ESPTable) do
                RemoveHealthBar(player)
            end
            
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("Head") then
                    local head = player.Character.Head
                    local healthBar = head:FindFirstChild("HealthBar_" .. player.Name)
                    if healthBar then
                        healthBar:Destroy()
                    end
                end
            end
            
            table.clear(ESPTable)
            if getgenv().HealthBarESP then
                getgenv().HealthBarESP = nil
            end
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "高亮显示玩家",
    Default = false,
    Callback = function(Value)
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local HighlightTable = {}

        if Value then
            local function GetTeamColor(player)
                if player.Team then
                    return player.Team.TeamColor.Color
                else
                    return Color3.new(0.5, 0.5, 0.5)
                end
            end

            local function CreatePlayerHighlight(player)
                if HighlightTable[player] then return end
                
                local character = player.Character
                if not character then return end
                
                local teamColor = GetTeamColor(player)
                
                local highlight = Instance.new("Highlight")
                highlight.Name = "PlayerHighlight"
                highlight.FillColor = teamColor
                highlight.FillTransparency = 0.7
                highlight.OutlineColor = Color3.new(1, 1, 1)
                highlight.OutlineTransparency = 0
                highlight.Adornee = character
                highlight.Parent = character
                
                HighlightTable[player] = {
                    Highlight = highlight,
                    TeamColor = teamColor
                }
            end

            local function UpdatePlayerHighlight(player)
                local highlightData = HighlightTable[player]
                if highlightData and highlightData.Highlight then
                    local teamColor = GetTeamColor(player)
                    highlightData.Highlight.FillColor = teamColor
                    highlightData.TeamColor = teamColor
                end
            end

            local function RemovePlayerHighlight(player)
                local highlightData = HighlightTable[player]
                if highlightData and highlightData.Highlight then
                    highlightData.Highlight:Destroy()
                end
                HighlightTable[player] = nil
            end

            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    if player.Character then
                        CreatePlayerHighlight(player)
                    end
                    player.CharacterAdded:Connect(function()
                        CreatePlayerHighlight(player)
                    end)
                end
            end
            
            Players.PlayerAdded:Connect(function(player)
                player.CharacterAdded:Connect(function()
                    CreatePlayerHighlight(player)
                end)
            end)
            
            local teamChangedConnection
            teamChangedConnection = game:GetService("RunService").Heartbeat:Connect(function()
                for player, highlightData in pairs(HighlightTable) do
                    if player and player.Team then
                        local currentTeamColor = GetTeamColor(player)
                        if highlightData.TeamColor ~= currentTeamColor then
                            UpdatePlayerHighlight(player)
                        end
                    end
                end
            end)
            
            getgenv().PlayerHighlight = {
                Table = HighlightTable,
                TeamConnection = teamChangedConnection
            }
            
        else
            if getgenv().PlayerHighlight then
                if getgenv().PlayerHighlight.TeamConnection then
                    getgenv().PlayerHighlight.TeamConnection:Disconnect()
                end
                
                for player, highlightData in pairs(getgenv().PlayerHighlight.Table) do
                    RemovePlayerHighlight(player)
                end
                
                getgenv().PlayerHighlight = nil
            end
            
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character then
                    local highlight = player.Character:FindFirstChild("PlayerHighlight")
                    if highlight then
                        highlight:Destroy()
                    end
                end
            end
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "高亮显示NPC",
    Default = false,
    Callback = function(Value)
        local RunService = game:GetService("RunService")
        local Workspace = game:GetService("Workspace")
        
        if Value then
            local NPCHighlightTable = {}
            
            local function IsNPC(model)
                if not model:IsA("Model") then return false end
                
                local humanoid = model:FindFirstChildOfClass("Humanoid")
                if not humanoid then return false end
                
                local isPlayer = false
                for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                    if player.Character == model then
                        isPlayer = true
                        break
                    end
                end
                
                return not isPlayer and humanoid.Health > 0
            end
            
            local function CreateNPCHighlight(npc)
                if NPCHighlightTable[npc] then return end
                
                local highlight = Instance.new("Highlight")
                highlight.Name = "NPCHighlight"
                highlight.FillColor = Color3.new(1, 0.5, 0)
                highlight.FillTransparency = 0.7
                highlight.OutlineColor = Color3.new(1, 1, 1)
                highlight.OutlineTransparency = 0
                highlight.Adornee = npc
                highlight.Parent = npc
                
                NPCHighlightTable[npc] = {
                    Highlight = highlight
                }
            end
            
            local function RemoveNPCHighlight(npc)
                local highlightData = NPCHighlightTable[npc]
                if highlightData and highlightData.Highlight then
                    highlightData.Highlight:Destroy()
                end
                NPCHighlightTable[npc] = nil
            end
            
            local function ScanForNPCs()
                for _, descendant in pairs(Workspace:GetDescendants()) do
                    if IsNPC(descendant) then
                        CreateNPCHighlight(descendant)
                    end
                end
            end
            
            ScanForNPCs()
            
            local scanConnection
            scanConnection = RunService.Heartbeat:Connect(function()
                for _, descendant in pairs(Workspace:GetDescendants()) do
                    if IsNPC(descendant) and not NPCHighlightTable[descendant] then
                        CreateNPCHighlight(descendant)
                    end
                end
                
                for npc, highlightData in pairs(NPCHighlightTable) do
                    if not npc:IsDescendantOf(Workspace) then
                        RemoveNPCHighlight(npc)
                    end
                end
            end)
            
            local descendantAddedConnection
            descendantAddedConnection = Workspace.DescendantAdded:Connect(function(descendant)
                if IsNPC(descendant) then
                    CreateNPCHighlight(descendant)
                end
            end)
            
            getgenv().NPCHighlight = {
                Table = NPCHighlightTable,
                ScanConnection = scanConnection,
                DescendantConnection = descendantAddedConnection
            }
            
        else
            if getgenv().NPCHighlight then
                if getgenv().NPCHighlight.ScanConnection then
                    getgenv().NPCHighlight.ScanConnection:Disconnect()
                end
                if getgenv().NPCHighlight.DescendantConnection then
                    getgenv().NPCHighlight.DescendantConnection:Disconnect()
                end
                
                for npc, highlightData in pairs(getgenv().NPCHighlight.Table) do
                    RemoveNPCHighlight(npc)
                end
                
                getgenv().NPCHighlight = nil
            end
            
            for _, descendant in pairs(Workspace:GetDescendants()) do
                if descendant:IsA("Model") then
                    for _, child in ipairs(descendant:GetChildren()) do
                        if child:IsA("Highlight") and child.Name == "NPCHighlight" then
                            child:Destroy()
                        end
                    end
                end
            end
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "透视NPC",
    Default = false,
    Callback = function(Value)
        local RunService = game:GetService("RunService")
        local Workspace = game:GetService("Workspace")
        
        if Value then
            local NPCESPTable = {}
            
            local function IsNPC(model)
                if not model:IsA("Model") then return false end
                
                local humanoid = model:FindFirstChildOfClass("Humanoid")
                if not humanoid then return false end
                
                local isPlayer = false
                for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                    if player.Character == model then
                        isPlayer = true
                        break
                    end
                end
                
                return not isPlayer and humanoid.Health > 0
            end
            
            local function CreateNPCESP(npc)
                if NPCESPTable[npc] then return end
                
                local head = npc:FindFirstChild("Head") or npc:FindFirstChild("HumanoidRootPart")
                if not head then return end
                
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "NPCESP_" .. npc.Name
                billboard.Adornee = head
                billboard.Size = UDim2.new(0, 150, 0, 30)
                billboard.StudsOffset = Vector3.new(0, 3, 0)
                billboard.AlwaysOnTop = true
                billboard.Parent = head
                
                local textLabel = Instance.new("TextLabel")
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.BackgroundTransparency = 1
                textLabel.Text = npc.Name
                textLabel.TextColor3 = Color3.new(1, 1, 1)
                textLabel.TextStrokeTransparency = 0
                textLabel.TextSize = 14
                textLabel.Font = Enum.Font.Gotham
                textLabel.Parent = billboard
                
                local highlight = Instance.new("Highlight")
                highlight.Name = "NPCESP_Highlight"
                highlight.FillColor = Color3.new(0.5, 0, 0.5)
                highlight.FillTransparency = 0.7
                highlight.OutlineColor = Color3.new(1, 1, 1)
                highlight.OutlineTransparency = 0
                highlight.Adornee = npc
                highlight.Parent = npc
                
                NPCESPTable[npc] = {
                    Billboard = billboard,
                    Highlight = highlight
                }
            end
            
            local function RemoveNPCESP(npc)
                local espData = NPCESPTable[npc]
                if espData then
                    if espData.Billboard then
                        espData.Billboard:Destroy()
                    end
                    if espData.Highlight then
                        espData.Highlight:Destroy()
                    end
                    NPCESPTable[npc] = nil
                end
            end
            
            local function ScanForNPCs()
                for _, descendant in pairs(Workspace:GetDescendants()) do
                    if IsNPC(descendant) then
                        CreateNPCESP(descendant)
                    end
                end
            end
            
            ScanForNPCs()
            
            local scanConnection
            scanConnection = RunService.Heartbeat:Connect(function()
                for _, descendant in pairs(Workspace:GetDescendants()) do
                    if IsNPC(descendant) and not NPCESPTable[descendant] then
                        CreateNPCESP(descendant)
                    end
                end
                
                for npc, espData in pairs(NPCESPTable) do
                    if not npc:IsDescendantOf(Workspace) then
                        RemoveNPCESP(npc)
                    end
                end
            end)
            
            local descendantAddedConnection
            descendantAddedConnection = Workspace.DescendantAdded:Connect(function(descendant)
                if IsNPC(descendant) then
                    CreateNPCESP(descendant)
                end
            end)
            
            getgenv().NPCESP = {
                Table = NPCESPTable,
                ScanConnection = scanConnection,
                DescendantConnection = descendantAddedConnection
            }
            
        else
            if getgenv().NPCESP then
                if getgenv().NPCESP.ScanConnection then
                    getgenv().NPCESP.ScanConnection:Disconnect()
                end
                if getgenv().NPCESP.DescendantConnection then
                    getgenv().NPCESP.DescendantConnection:Disconnect()
                end
                
                for npc, espData in pairs(getgenv().NPCESP.Table) do
                    RemoveNPCESP(npc)
                end
                
                getgenv().NPCESP = nil
            end
            
            for _, descendant in pairs(Workspace:GetDescendants()) do
                if descendant:IsA("Model") then
                    for _, child in ipairs(descendant:GetDescendants()) do
                        if child:IsA("BillboardGui") and string.find(child.Name, "NPCESP_") then
                            child:Destroy()
                        end
                        if child:IsA("Highlight") and child.Name == "NPCESP_Highlight" then
                            child:Destroy()
                        end
                    end
                end
            end
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "透视敌方玩家",
    Default = false,
    Callback = function(Value)
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local ESPTable = {}

        if Value then
            local function IsEnemyPlayer(player)
                if player == LocalPlayer then return false end
                
                local localTeam = LocalPlayer.Team
                local playerTeam = player.Team
                
                if not localTeam or not playerTeam or localTeam ~= playerTeam then
                    return true
                end
                
                return false
            end

            local function CreateEnemyPlayerESP(player)
                if ESPTable[player] or not IsEnemyPlayer(player) then return end
                
                local character = player.Character
                if not character then return end
                
                local head = character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
                if not head then return end
                
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "EnemyPlayerESP_" .. player.Name
                billboard.Adornee = head
                billboard.Size = UDim2.new(0, 150, 0, 30)
                billboard.StudsOffset = Vector3.new(0, 3, 0)
                billboard.AlwaysOnTop = true
                billboard.Parent = head
                
                local textLabel = Instance.new("TextLabel")
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.BackgroundTransparency = 1
                textLabel.Text = player.Name
                textLabel.TextColor3 = Color3.new(1, 0, 0)
                textLabel.TextStrokeTransparency = 0
                textLabel.TextSize = 14
                textLabel.Font = Enum.Font.GothamBold
                textLabel.Parent = billboard
                
                local highlight = Instance.new("Highlight")
                highlight.Name = "EnemyPlayerHighlight"
                highlight.FillColor = Color3.new(1, 0, 0)
                highlight.FillTransparency = 0.7
                highlight.OutlineColor = Color3.new(1, 1, 1)
                highlight.OutlineTransparency = 0
                highlight.Adornee = character
                highlight.Parent = character
                
                ESPTable[player] = {
                    Billboard = billboard,
                    Highlight = highlight
                }
            end

            local function RemoveEnemyPlayerESP(player)
                local espData = ESPTable[player]
                if espData then
                    if espData.Billboard then
                        espData.Billboard:Destroy()
                    end
                    if espData.Highlight then
                        espData.Highlight:Destroy()
                    end
                    ESPTable[player] = nil
                end
            end

            local function UpdateEnemyPlayers()
                for _, player in pairs(Players:GetPlayers()) do
                    if IsEnemyPlayer(player) then
                        if not ESPTable[player] and player.Character then
                            CreateEnemyPlayerESP(player)
                        end
                    else
                        if ESPTable[player] then
                            RemoveEnemyPlayerESP(player)
                        end
                    end
                end
            end

            for _, player in pairs(Players:GetPlayers()) do
                if IsEnemyPlayer(player) and player.Character then
                    CreateEnemyPlayerESP(player)
                end
                player.CharacterAdded:Connect(function()
                    if IsEnemyPlayer(player) then
                        CreateEnemyPlayerESP(player)
                    end
                end)
            end
            
            Players.PlayerAdded:Connect(function(player)
                player.CharacterAdded:Connect(function()
                    if IsEnemyPlayer(player) then
                        CreateEnemyPlayerESP(player)
                    end
                end)
            end)
            
            local teamCheckConnection
            teamCheckConnection = game:GetService("RunService").Heartbeat:Connect(function()
                UpdateEnemyPlayers()
            end)
            
            getgenv().EnemyPlayerESP = {
                Table = ESPTable,
                Connection = teamCheckConnection
            }
            
        else
            if getgenv().EnemyPlayerESP then
                if getgenv().EnemyPlayerESP.Connection then
                    getgenv().EnemyPlayerESP.Connection:Disconnect()
                end
                
                for player, espData in pairs(getgenv().EnemyPlayerESP.Table) do
                    RemoveEnemyPlayerESP(player)
                end
                
                getgenv().EnemyPlayerESP = nil
            end
            
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character then
                    local esp = player.Character:FindFirstChild("EnemyPlayerESP_" .. player.Name)
                    if esp then
                        esp:Destroy()
                    end
                    local highlight = player.Character:FindFirstChild("EnemyPlayerHighlight")
                    if highlight then
                        highlight:Destroy()
                    end
                end
            end
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "透视敌方NPC",
    Default = false,
    Callback = function(Value)
        local RunService = game:GetService("RunService")
        local Workspace = game:GetService("Workspace")
        
        if Value then
            local EnemyNPCESPTable = {}
            
            local function IsEnemyNPC(model)
                if not model:IsA("Model") then return false end
                
                local humanoid = model:FindFirstChildOfClass("Humanoid")
                if not humanoid then return false end
                
                local isPlayer = false
                for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                    if player.Character == model then
                        isPlayer = true
                        break
                    end
                end
                
                if isPlayer then return false end
                
                local localTeam = game.Players.LocalPlayer.Team
                local npcTeam = model:FindFirstChild("Team") or model:FindFirstChildOfClass("Team")
                
                if not localTeam or not npcTeam or localTeam ~= npcTeam then
                    return true
                end
                
                return false
            end
            
            local function CreateEnemyNPCESP(npc)
                if EnemyNPCESPTable[npc] then return end
                
                local head = npc:FindFirstChild("Head") or npc:FindFirstChild("HumanoidRootPart")
                if not head then return end
                
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "EnemyNPCESP_" .. npc.Name
                billboard.Adornee = head
                billboard.Size = UDim2.new(0, 150, 0, 30)
                billboard.StudsOffset = Vector3.new(0, 3, 0)
                billboard.AlwaysOnTop = true
                billboard.Parent = head
                
                local textLabel = Instance.new("TextLabel")
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.BackgroundTransparency = 1
                textLabel.Text = npc.Name
                textLabel.TextColor3 = Color3.new(1, 0, 0)
                textLabel.TextStrokeTransparency = 0
                textLabel.TextSize = 14
                textLabel.Font = Enum.Font.Gotham
                textLabel.Parent = billboard
                
                local highlight = Instance.new("Highlight")
                highlight.Name = "EnemyNPCHighlight"
                highlight.FillColor = Color3.new(1, 0, 0)
                highlight.FillTransparency = 0.7
                highlight.OutlineColor = Color3.new(1, 1, 1)
                highlight.OutlineTransparency = 0
                highlight.Adornee = npc
                highlight.Parent = npc
                
                EnemyNPCESPTable[npc] = {
                    Billboard = billboard,
                    Highlight = highlight
                }
            end
            
            local function RemoveEnemyNPCESP(npc)
                local espData = EnemyNPCESPTable[npc]
                if espData then
                    if espData.Billboard then
                        espData.Billboard:Destroy()
                    end
                    if espData.Highlight then
                        espData.Highlight:Destroy()
                    end
                    EnemyNPCESPTable[npc] = nil
                end
            end
            
            local function ScanForEnemyNPCs()
                for _, descendant in pairs(Workspace:GetDescendants()) do
                    if IsEnemyNPC(descendant) then
                        CreateEnemyNPCESP(descendant)
                    end
                end
            end
            
            ScanForEnemyNPCs()
            
            local scanConnection
            scanConnection = RunService.Heartbeat:Connect(function()
                for _, descendant in pairs(Workspace:GetDescendants()) do
                    if IsEnemyNPC(descendant) and not EnemyNPCESPTable[descendant] then
                        CreateEnemyNPCESP(descendant)
                    end
                end
                
                for npc, espData in pairs(EnemyNPCESPTable) do
                    if not npc:IsDescendantOf(Workspace) or not IsEnemyNPC(npc) then
                        RemoveEnemyNPCESP(npc)
                    end
                end
            end)
            
            local descendantAddedConnection
            descendantAddedConnection = Workspace.DescendantAdded:Connect(function(descendant)
                if IsEnemyNPC(descendant) then
                    CreateEnemyNPCESP(descendant)
                end
            end)
            
            getgenv().EnemyNPCESP = {
                Table = EnemyNPCESPTable,
                ScanConnection = scanConnection,
                DescendantConnection = descendantAddedConnection
            }
            
        else
            if getgenv().EnemyNPCESP then
                if getgenv().EnemyNPCESP.ScanConnection then
                    getgenv().EnemyNPCESP.ScanConnection:Disconnect()
                end
                if getgenv().EnemyNPCESP.DescendantConnection then
                    getgenv().EnemyNPCESP.DescendantConnection:Disconnect()
                end
                
                for npc, espData in pairs(getgenv().EnemyNPCESP.Table) do
                    RemoveEnemyNPCESP(npc)
                end
                
                getgenv().EnemyNPCESP = nil
            end
            
            for _, descendant in pairs(Workspace:GetDescendants()) do
                if descendant:IsA("Model") then
                    for _, child in ipairs(descendant:GetDescendants()) do
                        if child:IsA("BillboardGui") and string.find(child.Name, "EnemyNPCESP_") then
                            child:Destroy()
                        end
                        if child:IsA("Highlight") and string.find(child.Name, "EnemyNPCHighlight") then
                            child:Destroy()
                        end
                    end
                end
            end
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "esp",
    Default = false,
    Callback = function(state)
        pcall(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character then
                    if state then
                        local highlight = Instance.new("Highlight")
                        highlight.Parent = player.Character
                        highlight.Adornee = player.Character

                        local billboard = Instance.new("BillboardGui")
                        billboard.Parent = player.Character
                        billboard.Adornee = player.Character
                        billboard.Size = UDim2.new(0, 100, 0, 100)
                        billboard.StudsOffset = Vector3.new(0, 3, 0)
                        billboard.AlwaysOnTop = true

                        local nameLabel = Instance.new("TextLabel")
                        nameLabel.Parent = billboard
                        nameLabel.Size = UDim2.new(1, 0, 1, 0)
                        nameLabel.BackgroundTransparency = 1
                        nameLabel.Text = player.Name
                        nameLabel.TextColor3 = Color3.new(1, 1, 1)
                        nameLabel.TextStrokeTransparency = 0.5
                        nameLabel.TextScaled = true

                        local circle = Instance.new("ImageLabel")
                        circle.Parent = billboard
                        circle.Size = UDim2.new(0, 50, 0, 50)
                        circle.Position = UDim2.new(0.5, 0, 0.5, 0)
                        circle.AnchorPoint = Vector2.new(0.5, 0.5)
                        circle.BackgroundTransparency = 1
                        circle.Image = "rbxassetid://2200552246"
                    else
                        if player.Character:FindFirstChildOfClass("Highlight") then
                            player.Character:FindFirstChildOfClass("Highlight"):Destroy()
                        end
                        if player.Character:FindFirstChildOfClass("BillboardGui") then
                            player.Character:FindFirstChildOfClass("BillboardGui"):Destroy()
                        end
                    end
                end
            end
        end)
    end
})

local Toggle = Tab:Toggle({
    Title = "方框透视",
    Default = false,
    Callback = function(Value)
        ESPData.BoxESP = Value
        if not ESPConnection and (ESPData.BoxESP or ESPData.SkeletonESP or ESPData.NameESP or ESPData.TracerESP) then
            StartESP()
        elseif ESPConnection and not (ESPData.BoxESP or ESPData.SkeletonESP or ESPData.NameESP or ESPData.TracerESP) then
            StopESP()
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "骨骼透视",
    Default = false,
    Callback = function(Value)
        ESPData.SkeletonESP = Value
        if not ESPConnection and (ESPData.BoxESP or ESPData.SkeletonESP or ESPData.NameESP or ESPData.TracerESP) then
            StartESP()
        elseif ESPConnection and not (ESPData.BoxESP or ESPData.SkeletonESP or ESPData.NameESP or ESPData.TracerESP) then
            StopESP()
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "名称透视",
    Default = false,
    Callback = function(Value)
        ESPData.NameESP = Value
        if not ESPConnection and (ESPData.BoxESP or ESPData.SkeletonESP or ESPData.NameESP or ESPData.TracerESP) then
            StartESP()
        elseif ESPConnection and not (ESPData.BoxESP or ESPData.SkeletonESP or ESPData.NameESP or ESPData.TracerESP) then
            StopESP()
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "透视线条",
    Default = false,
    Callback = function(Value)
        ESPData.TracerESP = Value
        if not ESPConnection and (ESPData.BoxESP or ESPData.SkeletonESP or ESPData.NameESP or ESPData.TracerESP) then
            StartESP()
        elseif ESPConnection and not (ESPData.BoxESP or ESPData.SkeletonESP or ESPData.NameESP or ESPData.TracerESP) then
            StopESP()
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "距离显示",
    Default = false,
    Callback = function(Value)
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local RunService = game:GetService("RunService")
        local DistanceTable = {}

        if Value then
            local function CreateDistanceDisplay(player)
                if DistanceTable[player] then return end
                
                local character = player.Character
                if not character then return end
                
                local head = character:FindFirstChild("Head")
                if not head then return end
                
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "DistanceDisplay_" .. player.Name
                billboard.Adornee = head
                billboard.Size = UDim2.new(0, 80, 0, 20)
                billboard.StudsOffset = Vector3.new(0, 2, 0)
                billboard.AlwaysOnTop = true
                billboard.Parent = head
                
                local textLabel = Instance.new("TextLabel")
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.BackgroundTransparency = 1
                textLabel.Text = "0m"
                textLabel.TextColor3 = Color3.new(1, 1, 1)
                textLabel.TextStrokeTransparency = 0
                textLabel.TextScaled = true
                textLabel.Font = Enum.Font.GothamBold
                textLabel.Parent = billboard
                
                DistanceTable[player] = {
                    Billboard = billboard,
                    TextLabel = textLabel
                }
            end

            local function UpdateDistance()
                for player, espData in pairs(DistanceTable) do
                    if player.Character and player.Character:FindFirstChild("Head") and 
                       LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                       
                        local distance = (player.Character.Head.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                        espData.TextLabel.Text = string.format("%.1fm", distance)
                    end
                end
            end
            
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    if player.Character then
                        CreateDistanceDisplay(player)
                    end
                    player.CharacterAdded:Connect(function()
                        CreateDistanceDisplay(player)
                    end)
                end
            end
            
            Players.PlayerAdded:Connect(function(player)
                player.CharacterAdded:Connect(function()
                    CreateDistanceDisplay(player)
                end)
            end)
            
            local connection = RunService.Heartbeat:Connect(UpdateDistance)
            
            getgenv().DistanceESP = {
                Table = DistanceTable,
                Connection = connection
            }
            
        else
            if getgenv().DistanceESP then
                if getgenv().DistanceESP.Connection then
                    getgenv().DistanceESP.Connection:Disconnect()
                end
                
                for player, espData in pairs(getgenv().DistanceESP.Table) do
                    if espData and espData.Billboard then
                        espData.Billboard:Destroy()
                    end
                end
                
                getgenv().DistanceESP = nil
            end
            
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character then
                    local distanceDisplay = player.Character:FindFirstChild("DistanceDisplay_" .. player.Name)
                    if distanceDisplay then
                        distanceDisplay:Destroy()
                    end
                end
            end
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "透视手中物品",
    Default = false,
    Callback = function(Value)
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local LocalPlayer = Players.LocalPlayer
        
        if Value then
            local ToolESPTable = {}
            
            local function CreateToolESP(player)
                if ToolESPTable[player] then return end
                
                local character = player.Character
                if not character then return end
                
                local function findEquippedTool()
                    local rightHand = character:FindFirstChild("RightHand")
                    if rightHand then
                        for _, tool in ipairs(character:GetChildren()) do
                            if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                                local handle = tool.Handle
                                
                                for _, weld in ipairs(handle:GetChildren()) do
                                    if weld:IsA("Weld") and weld.Part1 == rightHand then
                                        return tool
                                    end
                                end
                            end
                        end
                    end
                    
                    for _, tool in ipairs(character:GetChildren()) do
                        if tool:IsA("Tool") then
                            return tool
                        end
                    end
                    
                    return nil
                end
                
                local tool = findEquippedTool()
                if not tool then return end
                
                local handle = tool:FindFirstChild("Handle")
                if not handle then return end
                
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "ToolESP_" .. player.Name
                billboard.Adornee = handle
                billboard.Size = UDim2.new(0, 200, 0, 40)
                billboard.StudsOffset = Vector3.new(0, 2, 0)
                billboard.AlwaysOnTop = true
                billboard.Parent = handle
                
                local frame = Instance.new("Frame")
                frame.BackgroundColor3 = Color3.new(1, 0.5, 0)
                frame.BackgroundTransparency = 0.2
                frame.Size = UDim2.new(1, 0, 1, 0)
                frame.Parent = billboard
                
                local uiCorner = Instance.new("UICorner")
                uiCorner.CornerRadius = UDim.new(0, 5)
                uiCorner.Parent = frame
                
                local textLabel = Instance.new("TextLabel")
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.BackgroundTransparency = 1
                textLabel.Text = tool.Name
                textLabel.TextColor3 = Color3.new(1, 1, 1)
                textLabel.TextStrokeTransparency = 0
                textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                textLabel.TextScaled = true
                textLabel.Font = Enum.Font.GothamBold
                textLabel.Parent = frame
                
                local highlight = Instance.new("Highlight")
                highlight.Name = "ToolHighlight_" .. player.Name
                highlight.FillColor = Color3.new(1, 0.5, 0)
                highlight.FillTransparency = 0.7
                highlight.OutlineColor = Color3.new(1, 1, 1)
                highlight.OutlineTransparency = 0
                highlight.Adornee = tool
                highlight.Parent = tool
                
                ToolESPTable[player] = {
                    Billboard = billboard,
                    Highlight = highlight,
                    Tool = tool
                }
                
                local toolConnection
                toolConnection = character.ChildAdded:Connect(function(child)
                    if child:IsA("Tool") then
                        wait(0.1)
                        RemoveToolESP(player)
                        CreateToolESP(player)
                    end
                end)
                
                ToolESPTable[player].ToolConnection = toolConnection
            end
            
            local function RemoveToolESP(player)
                local espData = ToolESPTable[player]
                if espData then
                    if espData.Billboard then
                        espData.Billboard:Destroy()
                    end
                    if espData.Highlight then
                        espData.Highlight:Destroy()
                    end
                    if espData.ToolConnection then
                        espData.ToolConnection:Disconnect()
                    end
                    ToolESPTable[player] = nil
                end
            end
            
            local checkConnection
            checkConnection = RunService.Heartbeat:Connect(function()
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        if not ToolESPTable[player] then
                            CreateToolESP(player)
                        else
                            local espData = ToolESPTable[player]
                            if espData and espData.Tool and not player.Character:FindFirstChild(espData.Tool.Name) then
                                RemoveToolESP(player)
                                CreateToolESP(player)
                            end
                        end
                    end
                end
            end)
            
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    if player.Character then
                        CreateToolESP(player)
                    end
                    player.CharacterAdded:Connect(function()
                        wait(1)
                        CreateToolESP(player)
                    end)
                end
            end
            
            Players.PlayerAdded:Connect(function(player)
                player.CharacterAdded:Connect(function()
                    wait(1)
                    CreateToolESP(player)
                end)
            end)
            
            getgenv().ToolESP = {
                Table = ToolESPTable,
                Connection = checkConnection
            }
            
        else
            if getgenv().ToolESP then
                if getgenv().ToolESP.Connection then
                    getgenv().ToolESP.Connection:Disconnect()
                end
                
                for player, espData in pairs(getgenv().ToolESP.Table) do
                    RemoveToolESP(player)
                end
                
                getgenv().ToolESP = nil
            end
            
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character then
                    for _, child in ipairs(player.Character:GetDescendants()) do
                        if child:IsA("BillboardGui") and string.find(child.Name, "ToolESP_") then
                            child:Destroy()
                        end
                    end
                    
                    for _, child in ipairs(player.Character:GetDescendants()) do
                        if child:IsA("Highlight") and string.find(child.Name, "ToolHighlight_") then
                            child:Destroy()
                        end
                    end
                end
            end
        end
    end
})

local Dropdown = Tab:Dropdown({
    Title = "选择玩家名称",
    Values = playerList,
    Callback = function(value)
        selectedPlayer = value
    end
})

local Button = Tab:Button({
    Title = "刷新列表",
    Callback = function()
        refreshPlayerList(true)
        Dropdown:Refresh(playerList)
    end
})

local Button = Tab:Button({
    Title = "传送到玩家旁边",
    Callback = function()
        if selectedPlayer and Players:FindFirstChild(selectedPlayer) then
            local targetPlayer = Players[selectedPlayer]
            if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                tp(targetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0))
            end
        end
    end
})

local Button = Tab:Button({
    Title = "重置人物",
    Callback = function()
        game.Players.LocalPlayer.Character.Humanoid.Health = 0
    end
})

local Button = Tab:Button({
    Title = "重进服务器",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(
            game.PlaceId,
            game.JobId,
            game:GetService("Players").LocalPlayer
        )
    end
})

local Button = Tab:Button({
    Title = "离开服务器",
    Callback = function()
        game:Shutdown()
    end
})

local Button = Tab:Button({
    Title = "移动锁",
    Callback = function()
        local ShiftlockStarterGui = Instance.new("ScreenGui")
        local ImageButton = Instance.new("ImageButton")
        ShiftlockStarterGui.Name = "Shiftlock (StarterGui)"
        ShiftlockStarterGui.Parent = game.CoreGui
        ShiftlockStarterGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        ShiftlockStarterGui.ResetOnSpawn = false

        ImageButton.Parent = ShiftlockStarterGui
        ImageButton.Active = true
        ImageButton.Draggable = true
        ImageButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ImageButton.BackgroundTransparency = 1.000
        ImageButton.Position = UDim2.new(0.921914339, 0, 0.552375436, 0)
        ImageButton.Size = UDim2.new(0.0636147112, 0, 0.0661305636, 0)
        ImageButton.SizeConstraint = Enum.SizeConstraint.RelativeXX
        ImageButton.Image = "http://www.roblox.com/asset/?id=182223762"
        
        local function TLQOYN_fake_script()
            local script = Instance.new("LocalScript", ImageButton)

            local MobileCameraFramework = {}
            local Players = game.Players
            local runservice = game:GetService("RunService")
            local CAS = game:GetService("ContextActionService")
            local Player = Players.LocalPlayer
            local character = Player.Character or Player.CharacterAdded:Wait()
            local root = character:WaitForChild("HumanoidRootPart")
            local humanoid = character.Humanoid
            local camera = workspace.CurrentCamera
            local button = script.Parent
            uis = game:GetService("UserInputService")
            ismobile = uis.TouchEnabled
            button.Visible = ismobile
            
            local states = {
                OFF = "rbxasset://textures/ui/mouseLock_off@2x.png",
                ON = "rbxasset://textures/ui/mouseLock_on@2x.png"
            }
            local MAX_LENGTH = 900000
            local active = false
            local ENABLED_OFFSET = CFrame.new(1.7, 0, 0)
            local DISABLED_OFFSET = CFrame.new(-1.7, 0, 0)
            local rootPos = Vector3.new(0,0,0)
            
            local function UpdatePos()
                if Player.Character and Player.Character:FindFirstChildOfClass"Humanoid" and Player.Character:FindFirstChildOfClass"Humanoid".RootPart then
                    rootPos = Player.Character:FindFirstChildOfClass"Humanoid".RootPart.Position
                end
            end
            
            local function UpdateImage(STATE)
                button.Image = states[STATE]
            end
            
            local function UpdateAutoRotate(BOOL)
                if Player.Character and Player.Character:FindFirstChildOfClass"Humanoid" then
                    Player.Character:FindFirstChildOfClass"Humanoid".AutoRotate = BOOL
                end
            end
            
            local function GetUpdatedCameraCFrame()
                if game:GetService"Workspace".CurrentCamera then
                    return CFrame.new(rootPos, Vector3.new(game:GetService"Workspace".CurrentCamera.CFrame.LookVector.X * MAX_LENGTH, rootPos.Y, game:GetService"Workspace".CurrentCamera.CFrame.LookVector.Z * MAX_LENGTH))
                end
            end
            
            local function EnableShiftlock()
                UpdatePos()
                UpdateAutoRotate(false)
                UpdateImage("ON")
                if Player.Character and Player.Character:FindFirstChildOfClass"Humanoid" and Player.Character:FindFirstChildOfClass"Humanoid".RootPart then
                    Player.Character:FindFirstChildOfClass"Humanoid".RootPart.CFrame = GetUpdatedCameraCFrame()
                end
                if game:GetService"Workspace".CurrentCamera then
                    game:GetService"Workspace".CurrentCamera.CFrame = camera.CFrame * ENABLED_OFFSET
                end
            end
            
            local function DisableShiftlock()
                UpdatePos()
                UpdateAutoRotate(true)
                UpdateImage("OFF")
                if game:GetService"Workspace".CurrentCamera then
                    game:GetService"Workspace".CurrentCamera.CFrame = camera.CFrame * DISABLED_OFFSET
                end
                pcall(function()
                    active:Disconnect()
                    active = nil
                end)
            end
            
            UpdateImage("OFF")
            active = false
            
            function ShiftLock()
                if not active then
                    active = runservice.RenderStepped:Connect(function()
                        EnableShiftlock()
                    end)
                else
                    DisableShiftlock()
                end
            end
            
            local ShiftLockButton = CAS:BindAction("ShiftLOCK", ShiftLock, false, "On")
            CAS:SetPosition("ShiftLOCK", UDim2.new(0.8, 0, 0.8, 0))
            
            button.MouseButton1Click:Connect(function()
                if not active then
                    active = runservice.RenderStepped:Connect(function()
                        EnableShiftlock()
                    end)
                else
                    DisableShiftlock()
                end
            end)
            
            return MobileCameraFramework
        end
        
        coroutine.wrap(TLQOYN_fake_script)()
        
        local function OMQRQRC_fake_script()
            local script = Instance.new("LocalScript", ShiftlockStarterGui)

            local Players = game.Players
            local UserInputService = game:GetService("UserInputService")
            local Settings = UserSettings()
            local GameSettings = Settings.GameSettings
            local ShiftLockController = {}
            
            while not Players.LocalPlayer do
                wait()
            end
            
            local LocalPlayer = Players.LocalPlayer
            local Mouse = LocalPlayer:GetMouse()
            local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
            local ScreenGui, ShiftLockIcon, InputCn
            local IsShiftLockMode = true
            local IsShiftLocked = true
            local IsActionBound = false
            local IsInFirstPerson = false
            
            ShiftLockController.OnShiftLockToggled = Instance.new("BindableEvent")
            
            local function isShiftLockMode()
                return LocalPlayer.DevEnableMouseLock and GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch and LocalPlayer.DevComputerMovementMode ~= Enum.DevComputerMovementMode.ClickToMove and GameSettings.ComputerMovementMode ~= Enum.ComputerMovementMode.ClickToMove and LocalPlayer.DevComputerMovementMode ~= Enum.DevComputerMovementMode.Scriptable
            end
            
            if not UserInputService.TouchEnabled then
                IsShiftLockMode = isShiftLockMode()
            end
            
            local function onShiftLockToggled()
                IsShiftLocked = not IsShiftLocked
                ShiftLockController.OnShiftLockToggled:Fire()
            end
            
            local initialize = function()
                print("enabled")
            end
            
            function ShiftLockController:IsShiftLocked()
                return IsShiftLockMode and IsShiftLocked
            end
            
            function ShiftLockController:SetIsInFirstPerson(isInFirstPerson)
                IsInFirstPerson = isInFirstPerson
            end
            
            local function mouseLockSwitchFunc(actionName, inputState, inputObject)
                if IsShiftLockMode then
                    onShiftLockToggled()
                end
            end
            
            local function disableShiftLock()
                if ScreenGui then
                    ScreenGui.Parent = nil
                end
                IsShiftLockMode = false
                Mouse.Icon = ""
                if InputCn then
                    InputCn:disconnect()
                    InputCn = nil
                end
                IsActionBound = false
                ShiftLockController.OnShiftLockToggled:Fire()
            end
            
            local onShiftInputBegan = function(inputObject, isProcessed)
                if isProcessed then
                    return
                end
                if inputObject.UserInputType ~= Enum.UserInputType.Keyboard or inputObject.KeyCode == Enum.KeyCode.LeftShift or inputObject.KeyCode == Enum.KeyCode.RightShift then
                end
            end
            
            local function enableShiftLock()
                IsShiftLockMode = isShiftLockMode()
                if IsShiftLockMode then
                    if ScreenGui then
                        ScreenGui.Parent = PlayerGui
                    end
                    if IsShiftLocked then
                        ShiftLockController.OnShiftLockToggled:Fire()
                    end
                    if not IsActionBound then
                        InputCn = UserInputService.InputBegan:connect(onShiftInputBegan)
                        IsActionBound = true
                    end
                end
            end
            
            GameSettings.Changed:connect(function(property)
                if property == "ControlMode" then
                    if GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch then
                        enableShiftLock()
                    else
                        disableShiftLock()
                    end
                elseif property == "ComputerMovementMode" then
                    if GameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove then
                        disableShiftLock()
                    else
                        enableShiftLock()
                    end
                end
            end)
            
            LocalPlayer.Changed:connect(function(property)
                if property == "DevEnableMouseLock" then
                    if LocalPlayer.DevEnableMouseLock then
                        enableShiftLock()
                    else
                        disableShiftLock()
                    end
                elseif property == "DevComputerMovementMode" then
                    if LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.ClickToMove or LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.Scriptable then
                        disableShiftLock()
                    else
                        enableShiftLock()
                    end
                end
            end)
            
            LocalPlayer.CharacterAdded:connect(function(character)
                if not UserInputService.TouchEnabled then
                    initialize()
                end
            end)
            
            if not UserInputService.TouchEnabled then
                initialize()
                if isShiftLockMode() then
                    InputCn = UserInputService.InputBegan:connect(onShiftInputBegan)
                    IsActionBound = true
                end
            end
            
            enableShiftLock()
            return ShiftLockController
        end
        
        coroutine.wrap(OMQRQRC_fake_script)()
    end
})

local Button = Tab:Button({
    Title = "点击传送工具",
    Callback = function()
        mouse = game.Players.LocalPlayer:GetMouse()
        tool = Instance.new("Tool")
        tool.RequiresHandle = false
        tool.Name = "Click Teleport"
        tool.Activated:connect(function()
            local pos = mouse.Hit+Vector3.new(0,2.5,0)
            pos = CFrame.new(pos.X,pos.Y,pos.Z)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = pos
        end)
        tool.Parent = game.Players.LocalPlayer.Backpack
    end
})

local Button = Tab:Button({
    Title = "玩家进入游戏 退出游戏通知",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/boyscp/scriscriptsc/main/bbn.lua"))()
    end
})

local Button = Tab:Button({
    Title = "egro假延迟",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-roblox-egor-script-53041"))()
    end
})

local Button = Tab:Button({
    Title = "打飞机r6",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/wa3v2Vgm/raw"))()
    end
})

local Button = Tab:Button({
    Title = "打飞机r15",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/YZoglOyJ/raw"))()
    end
})

local Button = Tab:Button({
    Title = "无敌少侠",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Invinicible-Flight-R15-45414"))()
    end
})

local Button = Tab:Button({
    Title = "摔落无伤害(可创飞人)",
    Callback = function()
        loadstring(game:HttpGet("http://rawscripts.net/raw/Universal-Script-Touch-fling-script-22447"))()
    end
})

local Button = Tab:Button({
    Title = "飞车(by皮空)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/smalldesikon/eyidfki/main/%E9%A3%9E%E8%BD%A6(%E6%BA%90%E7%A0%81).lua"))()
    end
})

local Button = Tab:Button({
    Title = "飞行v1",
    Callback = function()
        loadstring("\108\111\97\100\115\116\114\105\110\103\40\103\97\109\101\58\72\116\116\112\71\101\116\40\34\104\116\116\112\115\58\47\47\112\97\115\116\101\98\105\110\46\99\111\109\47\114\97\119\47\90\66\122\99\84\109\49\102\34\41\41\40\41\10")()
    end
})

local Button = Tab:Button({
    Title = "冷飞行",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/odhdshhe/-V3.0/refs/heads/main/%E9%A3%9E%E8%A1%8C%E8%84%9A%E6%9C%ACV3(%E5%85%A8%E6%B8%B8%E6%88%8F%E9%80%9A%E7%94%A8)%20(1).txt"))()
    end
})

local Button = Tab:Button({
    Title = "反挂机v2",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/9fFu43FF"))()
    end
})

local Button = Tab:Button({
    Title = "死亡笔记",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/dingding123hhh/tt/main/%E6%AD%BB%E4%BA%A1%E7%AC%94%E8%AE%B0%20(1).txt"))()
    end
})

local Button = Tab:Button({
    Title = "爬墙跳脚本(装逼用)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ScpGuest666/Random-Roblox-script/refs/heads/main/Roblox%20WallHop%20V4%20script"))()
    end
})

local Button = Tab:Button({
    Title = "fenny甩飞gui",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/fe-flinger-gui-works-anywhere_1756291955889_SwfaGHMWsT.txt"))()
    end
})

local Toggle = Tab:Toggle({
    Title = "防甩飞",
    Default = false,
    Callback = function(Value)
        AntiFlingEnabled = Value
        
        if Value then
            local Services = setmetatable({}, {__index = function(Self, Index)
                local NewService = game.GetService(game, Index)
                if NewService then
                    Self[Index] = NewService
                end
                return NewService
            end})

            local LocalPlayer = Services.Players.LocalPlayer

            local function PlayerAdded(Player)
                local Detected = false
                local Character
                local PrimaryPart

                local function CharacterAdded(NewCharacter)
                    Character = NewCharacter
                    repeat
                        wait()
                        PrimaryPart = NewCharacter:FindFirstChild("HumanoidRootPart")
                    until PrimaryPart
                    Detected = false
                end

                CharacterAdded(Player.Character or Player.CharacterAdded:Wait())
                local charAddedConn = Player.CharacterAdded:Connect(CharacterAdded)
                
                local heartbeatConn = Services.RunService.Heartbeat:Connect(function()
                    if not AntiFlingEnabled then return end
                    
                    if (Character and Character:IsDescendantOf(workspace)) and (PrimaryPart and PrimaryPart:IsDescendantOf(Character)) then
                        if PrimaryPart.AssemblyAngularVelocity.Magnitude > 50 or PrimaryPart.AssemblyLinearVelocity.Magnitude > 100 then
                            Detected = true
                            for i,v in ipairs(Character:GetDescendants()) do
                                if v:IsA("BasePart") then
                                    v.CanCollide = false
                                    v.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                                    v.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                                    v.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0)
                                end
                            end
                            PrimaryPart.CanCollide = false
                            PrimaryPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                            PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                            PrimaryPart.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0)
                        end
                    end
                end)
                
                AntiFlingConnections[Player] = {
                    CharacterAdded = charAddedConn,
                    Heartbeat = heartbeatConn
                }
            end

            for i,v in ipairs(Services.Players:GetPlayers()) do
                if v ~= LocalPlayer then
                    PlayerAdded(v)
                end
            end
            
            local playerAddedConn = Services.Players.PlayerAdded:Connect(PlayerAdded)
            AntiFlingConnections.Global = {PlayerAdded = playerAddedConn}
            
        else
            for player, connections in pairs(AntiFlingConnections) do
                if player == "Global" then
                    if connections.PlayerAdded then
                        connections.PlayerAdded:Disconnect()
                    end
                else
                    if connections.CharacterAdded then
                        connections.CharacterAdded:Disconnect()
                    end
                    if connections.Heartbeat then
                        connections.Heartbeat:Disconnect()
                    end
                end
            end
            AntiFlingConnections = {}
        end
    end
})

local Button = Tab:Button({
    Title = "防甩飞",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ChinaQY/Scripts/Main/AntiFling.lua"))()
    end
})

local Button = Tab:Button({
    Title = "可选人甩飞",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/A8Kfs9KV/raw", true))()
    end
})

local Button = Tab:Button({
    Title = "触摸甩飞",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/LiarRise/FLN-X/refs/heads/main/README.md"))()
    end
})

local Button = Tab:Button({
    Title = "kenny甩飞",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/DHJB%E7%94%A9%E9%A3%9E.txt"))()
    end
})

local Button = Tab:Button({
    Title = "一键甩飞所有人",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/zqyDSUWX"))()
    end
})

local Button = Tab:Button({
    Title = "甩飞中心",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/3LD4D0/OP-FLING-GUI/c1fd15bf3114e6c9e4b76951b7d516c123836efe/OP%20FLING%20GUI%20R6%20AND%20R15"))()
    end
})

local Button = Tab:Button({
    Title = "电脑键盘",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/advxzivhsjjdhxhsidifvsh/mobkeyboard/main/main.txt", true))()
    end
})

local Button = Tab:Button({
    Title = "改fps",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/gclich/FPS-X-GUI/main/FPS_X.lua"))()
    end
})

local Button = Tab:Button({
    Title = "反踢出",
    Callback = function()
        local vu = game:GetService("VirtualUser")
        game:GetService("Players").LocalPlayer.Idled:connect(function()
            vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            wait(1)
            vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        end)
    end
})

local Button = Tab:Button({
    Title = "fpsBooster(很猛的提升fps)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/JoshzzAlteregooo/JoshzzFpsBoosterVersion3/refs/heads/main/JoshzzNewFpsBooster"))()
    end
})

local Button = Tab:Button({
    Title = "fps显示",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/d9j82YJr/raw",true))()
    end
})

local Button = Tab:Button({
    Title = "自动弹钢琴",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Tac's-Piano-Stuff-Talentless-script-made-by-hellohellohell012321-44088"))()
    end
})

local Button = Tab:Button({
    Title = "显示北京时间",
    Callback = function()
        local LBLG = Instance.new("ScreenGui", getParent)
        local LBL = Instance.new("TextLabel", getParent)
        local player = game.Players.LocalPlayer

        LBLG.Name = "LBLG"
        LBLG.Parent = game.CoreGui
        LBLG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        LBLG.Enabled = true
        LBL.Name = "LBL"
        LBL.Parent = LBLG
        LBL.BackgroundColor3 = Color3.new(0, 3, 1)
        LBL.BackgroundTransparency = 1
        LBL.BorderColor3 = Color3.new(0, 3, 1)
        LBL.Position = UDim2.new(0.75,0,0.010,0)
        LBL.Size = UDim2.new(0, 133, 0, 30)
        LBL.Font = Enum.Font.GothamSemibold
        LBL.Text = "TextLabel"
        LBL.TextColor3 = Color3.new(0, 3, 3)
        LBL.TextScaled = true
        LBL.TextSize = 14
        LBL.TextWrapped = true
        LBL.Visible = true

        local FpsLabel = LBL
        local Heartbeat = game:GetService("RunService").Heartbeat
        local LastIteration, Start
        local FrameUpdateTable = { }

        local function HeartbeatUpdate()
            LastIteration = tick()
            for Index = #FrameUpdateTable, 1, -1 do
                FrameUpdateTable[Index + 1] = (FrameUpdateTable[Index] >= LastIteration - 1) and FrameUpdateTable[Index] or nil
            end
            FrameUpdateTable[1] = LastIteration
            local CurrentFPS = (tick() - Start >= 1 and #FrameUpdateTable) or (#FrameUpdateTable / (tick() - Start))
            CurrentFPS = CurrentFPS - CurrentFPS % 1
            FpsLabel.Text = ("当前时间:"..os.date("%H").."时"..os.date("%M").."分"..os.date("%S"))
        end
        Start = tick()
        Heartbeat:Connect(HeartbeatUpdate)
    end
})

local Button = Tab:Button({
    Title = "解帧",
    Callback = function()
        loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-FpsBoost-9260"))()
    end
})

local Button = Tab:Button({
    Title = "飞檐走壁",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/zXk4Rq2r"))()
    end
})

local Button = Tab:Button({
    Title = "夜视仪",
    Callback = function()
        _G.OnShop = true
        loadstring(game:HttpGet('https://raw.githubusercontent.com/DeividComSono/Scripts/main/Scanner.lua'))()
    end
})

local Button = Tab:Button({
    Title = "反挂机",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/9fFu43FF"))()
    end
})

local Button = Tab:Button({
    Title = "转圈",
    Callback = function()
        loadstring(game:HttpGet('https://pastebin.com/raw/r97d7dS0', true))()
    end
})

local Button = Tab:Button({
    Title = "操人脚本",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/bzmhRgKL"))();
    end
})

local Button = Tab:Button({
    Title = "甩人",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/zqyDSUWX"))()
    end
})

local Button = Tab:Button({
    Title = "替身",
    Callback = function()
        loadstring(game:HttpGet(('https://raw.githubusercontent.com/SkrillexMe/SkrillexLoader/main/SkrillexLoadMain')))()
    end
})

local Button = Tab:Button({
    Title = "爬墙",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/zXk4Rq2r"))()
    end
})

local Button = Tab:Button({
    Title = "工具挂",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Bebo-Mods/BeboScripts/main/StandAwekening.lua"))()
    end
})

local Button = Tab:Button({
    Title = "铁拳",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/0Ben1/fe/main/obf_rf6iQURzu1fqrytcnLBAvW34C9N55kS9g9G3CKz086rC47M6632sEd4ZZYB0AYgV.lua.txt'))()
    end
})

local Button = Tab:Button({
    Title = "↓以下是开发脚本↓",
    Callback = function()
        
    end
})


local Button = Tab:Button({
    Title = "乌托邦spy",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Klinac/scripts/main/utopia_spy.lua", true))()
    end
})

local Button = Tab:Button({
    Title = "Cobaltspy",
    Callback = function()
        loadstring(game:HttpGet("https://github.com/notpoiu/cobalt/releases/latest/download/Cobalt.luau"))()
    end
})

local Button = Tab:Button({
    Title = "夜spyv3",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Angelo17123/NightSpyV3/refs/heads/main/NightSpy%20V4"))()
    end
})

local Button = Tab:Button({
    Title = "httpsSPY",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Hm5011/hussain/refs/heads/main/Links%20Spy"))()
    end
})

local Button = Tab:Button({
    Title = "Webhook拦截器webhookspy",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/offperms/emplicswebhookspy/main/release"))()
    end
})

local Button = Tab:Button({
    Title = "RedCodespy",
    Callback = function()
        loadstring(game:HttpGet(('https://raw.githubusercontent.com/RedCodeCheat/Roblox/refs/heads/main/RedCode_Remote_Spy.lua')))() 
    end
})

local Button = Tab:Button({
    Title = "HTTPspy",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/293jOse0ejd8du/HttpSpy/refs/heads/main/main.lua"))() 
    end
})

local Button = Tab:Button({
    Title = "库尔斯克斯RSPY",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/nizartitwaniii/Register-Roblox-/refs/heads/main/Protected_2944435597543940.txt"))() 
    end
})

local Button = Tab:Button({
    Title = "SpyOS",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/RENBex6969/SpyOS/refs/heads/main/SpyOS_a2.lua"))() 
    end
})

local Button = Tab:Button({
    Title = "杰森SPY",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/wjF5j5YD"))() 
    end
})

local Button = Tab:Button({
    Title = "Hydroxide",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/iK4oS/backdoor.exe/v8/src/main.lua'))()
    end
})

local Button = Tab:Button({
    Title = "SimpleAdmin",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/exxtremestuffs/SimpleAdmin/main/SimpleAdmin.lua"))()
    end
})

local Button = Tab:Button({
    Title = "Remote Spy",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/470n1/RemoteSpy/main/Main.lua"))()
    end
})

local Button = Tab:Button({
    Title = "Owl Hub",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/CriShoux/OwlHub/master/OwlHub.txt"))()
    end
})

local Button = Tab:Button({
    Title = "Fluxus",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/FluxusByte/Fluxus.Public/main/Fluxus"))()
    end
})

local Button = Tab:Button({
    Title = "Script Dumper",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/FilteringEnabled/ScriptDumper/main/ScriptDumper.lua"))()
    end
})

local Button = Tab:Button({
    Title = "Elysian",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ElysianManager/Elysian/main/Loader.lua"))()
    end
})

local Button = Tab:Button({
    Title = "ProtoSmasher Compat",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ProtoSmasher/Scripts/main/Loader"))()
    end
})

local Button = Tab:Button({
    Title = "Anti AFK",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/FilteringEnabled/FE-AntiAFK/main/src.lua"))()
    end
})

local Button = Tab:Button({
    Title = "坐标提取器",
    Callback = function()
        local ScreenGui = Instance.new("ScreenGui")
        local MainFrame = Instance.new("Frame")
        local TitleBar = Instance.new("Frame")
        local TitleLabel = Instance.new("TextLabel")
        local MinimizeButton = Instance.new("TextButton")
        local CloseButton = Instance.new("TextButton")
        local ContentFrame = Instance.new("Frame")
        local CurrentPosLabel = Instance.new("TextLabel")
        local PosDisplay = Instance.new("TextBox")
        local ButtonsFrame = Instance.new("Frame")
        local RefreshButton = Instance.new("TextButton")
        local CopyButton = Instance.new("TextButton")
        local TeleportFrame = Instance.new("Frame")
        local TeleportLabel = Instance.new("TextLabel")
        local TeleportInput = Instance.new("TextBox")
        local TeleportButton = Instance.new("TextButton")
        local StatusLabel = Instance.new("TextLabel")

        ScreenGui.Name = "CoordinateExtractor"
        ScreenGui.Parent = game.CoreGui
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

        MainFrame.Name = "MainFrame"
        MainFrame.Parent = ScreenGui
        MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        MainFrame.BorderSizePixel = 0
        MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
        MainFrame.Size = UDim2.new(0, 400, 0, 300)
        MainFrame.Active = true

        TitleBar.Name = "TitleBar"
        TitleBar.Parent = MainFrame
        TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TitleBar.BorderSizePixel = 0
        TitleBar.Size = UDim2.new(1, 0, 0, 40)

        TitleLabel.Name = "TitleLabel"
        TitleLabel.Parent = TitleBar
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Size = UDim2.new(0.7, 0, 1, 0)
        TitleLabel.Font = Enum.Font.GothamBold
        TitleLabel.Text = "坐标提取器 v2.0"
        TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TitleLabel.TextSize = 18

        MinimizeButton.Name = "MinimizeButton"
        MinimizeButton.Parent = TitleBar
        MinimizeButton.BackgroundColor3 = Color3.fromRGB(60, 150, 200)
        MinimizeButton.BorderSizePixel = 0
        MinimizeButton.Position = UDim2.new(0.8, 0, 0.1, 0)
        MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
        MinimizeButton.Font = Enum.Font.GothamBold
        MinimizeButton.Text = "_"
        MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        MinimizeButton.TextSize = 16

        CloseButton.Name = "CloseButton"
        CloseButton.Parent = TitleBar
        CloseButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        CloseButton.BorderSizePixel = 0
        CloseButton.Position = UDim2.new(0.9, 0, 0.1, 0)
        CloseButton.Size = UDim2.new(0, 30, 0, 30)
        CloseButton.Font = Enum.Font.GothamBold
        CloseButton.Text = "X"
        CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        CloseButton.TextSize = 16

        ContentFrame.Name = "ContentFrame"
        ContentFrame.Parent = MainFrame
        ContentFrame.BackgroundTransparency = 1
        ContentFrame.Position = UDim2.new(0, 0, 0, 40)
        ContentFrame.Size = UDim2.new(1, 0, 1, -40)

        CurrentPosLabel.Name = "CurrentPosLabel"
        CurrentPosLabel.Parent = ContentFrame
        CurrentPosLabel.BackgroundTransparency = 1
        CurrentPosLabel.Position = UDim2.new(0.05, 0, 0.05, 0)
        CurrentPosLabel.Size = UDim2.new(0.9, 0, 0, 25)
        CurrentPosLabel.Font = Enum.Font.Gotham
        CurrentPosLabel.Text = "当前位置:"
        CurrentPosLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        CurrentPosLabel.TextSize = 16
        CurrentPosLabel.TextXAlignment = Enum.TextXAlignment.Left

        PosDisplay.Name = "PosDisplay"
        PosDisplay.Parent = ContentFrame
        PosDisplay.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        PosDisplay.BorderSizePixel = 0
        PosDisplay.Position = UDim2.new(0.05, 0, 0.15, 0)
        PosDisplay.Size = UDim2.new(0.9, 0, 0, 60)
        PosDisplay.Font = Enum.Font.Gotham
        PosDisplay.PlaceholderText = "点击刷新获取当前位置..."
        PosDisplay.Text = ""
        PosDisplay.TextColor3 = Color3.fromRGB(255, 255, 255)
        PosDisplay.TextSize = 14
        PosDisplay.TextWrapped = true
        PosDisplay.TextXAlignment = Enum.TextXAlignment.Left
        PosDisplay.TextYAlignment = Enum.TextYAlignment.Top

        ButtonsFrame.Name = "ButtonsFrame"
        ButtonsFrame.Parent = ContentFrame
        ButtonsFrame.BackgroundTransparency = 1
        ButtonsFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
        ButtonsFrame.Size = UDim2.new(0.9, 0, 0, 40)

        RefreshButton.Name = "RefreshButton"
        RefreshButton.Parent = ButtonsFrame
        RefreshButton.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
        RefreshButton.BorderSizePixel = 0
        RefreshButton.Size = UDim2.new(0.48, 0, 1, 0)
        RefreshButton.Font = Enum.Font.GothamBold
        RefreshButton.Text = "刷新位置"
        RefreshButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        RefreshButton.TextSize = 16

        CopyButton.Name = "CopyButton"
        CopyButton.Parent = ButtonsFrame
        CopyButton.BackgroundColor3 = Color3.fromRGB(60, 180, 100)
        CopyButton.BorderSizePixel = 0
        CopyButton.Position = UDim2.new(0.52, 0, 0, 0)
        CopyButton.Size = UDim2.new(0.48, 0, 1, 0)
        CopyButton.Font = Enum.Font.GothamBold
        CopyButton.Text = "复制坐标"
        CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        CopyButton.TextSize = 16

        TeleportFrame.Name = "TeleportFrame"
        TeleportFrame.Parent = ContentFrame
        TeleportFrame.BackgroundTransparency = 1
        TeleportFrame.Position = UDim2.new(0.05, 0, 0.6, 0)
        TeleportFrame.Size = UDim2.new(0.9, 0, 0, 80)

        TeleportLabel.Name = "TeleportLabel"
        TeleportLabel.Parent = TeleportFrame
        TeleportLabel.BackgroundTransparency = 1
        TeleportLabel.Size = UDim2.new(1, 0, 0, 25)
        TeleportLabel.Font = Enum.Font.Gotham
        TeleportLabel.Text = "输入坐标传送到指定位置 (格式: X,Y,Z):"
        TeleportLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TeleportLabel.TextSize = 14
        TeleportLabel.TextXAlignment = Enum.TextXAlignment.Left

        TeleportInput.Name = "TeleportInput"
        TeleportInput.Parent = TeleportFrame
        TeleportInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        TeleportInput.BorderSizePixel = 0
        TeleportInput.Position = UDim2.new(0, 0, 0.3, 0)
        TeleportInput.Size = UDim2.new(0.7, 0, 0, 35)
        TeleportInput.Font = Enum.Font.Gotham
        TeleportInput.PlaceholderText = "例如: 100,50,200"
        TeleportInput.Text = ""
        TeleportInput.TextColor3 = Color3.fromRGB(255, 255, 255)
        TeleportInput.TextSize = 14

        TeleportButton.Name = "TeleportButton"
        TeleportButton.Parent = TeleportFrame
        TeleportButton.BackgroundColor3 = Color3.fromRGB(200, 120, 60)
        TeleportButton.BorderSizePixel = 0
        TeleportButton.Position = UDim2.new(0.72, 0, 0.3, 0)
        TeleportButton.Size = UDim2.new(0.28, 0, 0, 35)
        TeleportButton.Font = Enum.Font.GothamBold
        TeleportButton.Text = "传送"
        TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TeleportButton.TextSize = 16

        StatusLabel.Name = "StatusLabel"
        StatusLabel.Parent = ContentFrame
        StatusLabel.BackgroundTransparency = 1
        StatusLabel.Position = UDim2.new(0.05, 0, 0.9, 0)
        StatusLabel.Size = UDim2.new(0.9, 0, 0, 20)
        StatusLabel.Font = Enum.Font.Gotham
        StatusLabel.Text = "就绪"
        StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        StatusLabel.TextSize = 12
        StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

        local function updatePosition()
            local character = game.Players.LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local position = character.HumanoidRootPart.Position
                PosDisplay.Text = string.format("X: %.2f\nY: %.2f\nZ: %.2f", position.X, position.Y, position.Z)
                StatusLabel.Text = "位置已更新"
                StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            else
                StatusLabel.Text = "错误: 无法找到角色"
                StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            end
        end

        local function copyToClipboard()
            if PosDisplay.Text ~= "" then
                setclipboard(PosDisplay.Text)
                StatusLabel.Text = "坐标已复制到剪贴板"
                StatusLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
            else
                StatusLabel.Text = "错误: 没有坐标可复制"
                StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            end
        end

        local function teleportToPosition()
            local inputText = TeleportInput.Text
            local coords = {}

            for coord in string.gmatch(inputText, "[%d%.%-]+") do
                table.insert(coords, tonumber(coord))
            end

            if #coords == 3 then
                local character = game.Players.LocalPlayer.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    character.HumanoidRootPart.CFrame = CFrame.new(coords[1], coords[2], coords[3])
                    StatusLabel.Text = "传送成功"
                    StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
                    updatePosition()
                else
                    StatusLabel.Text = "错误: 无法找到角色"
                    StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                end
            else
                StatusLabel.Text = "错误: 坐标格式不正确"
                StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            end
        end

        local UIS = game:GetService("UserInputService")
        local dragging
        local dragInput
        local dragStart
        local startPos

        local function update(input)
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end

        TitleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = MainFrame.Position

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        TitleBar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                dragInput = input
            end
        end)

        UIS.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                update(input)
            end
        end)

        local isMinimized = false
        local originalSize = MainFrame.Size

        MinimizeButton.MouseButton1Click:Connect(function()
            if isMinimized then
                MainFrame.Size = originalSize
                ContentFrame.Visible = true
                MinimizeButton.Text = "_"
                isMinimized = false
            else
                originalSize = MainFrame.Size
                MainFrame.Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, 40)
                ContentFrame.Visible = false
                MinimizeButton.Text = "□"
                isMinimized = true
            end
        end)

        RefreshButton.MouseButton1Click:Connect(updatePosition)
        CopyButton.MouseButton1Click:Connect(copyToClipboard)
        TeleportButton.MouseButton1Click:Connect(teleportToPosition)
        CloseButton.MouseButton1Click:Connect(function()
            ScreenGui:Destroy()
        end)

        updatePosition()

        TeleportInput.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                teleportToPosition()
            end
        end)
    end
})

local Button = Tab:Button({
    Title = "复制坐标脚本(无法关闭)",
    Callback = function()
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local UserInputService = game:GetService("UserInputService")
        local player = Players.LocalPlayer

        local coordSystem = {
            isEnabled = true,
            gui = nil,
            updateConn = nil,
            currentPos = Vector3.new(0, 0, 0)
        }

        local function createCoordUI()
            local gui = Instance.new("ScreenGui")
            gui.Name = "Coord"
            gui.Parent = player.PlayerGui

            local container = Instance.new("Frame")
            container.Size = UDim2.new(0, 240, 0, 60)
            container.Position = UDim2.new(1, -250, 0, 10)
            container.BackgroundTransparency = 1
            container.Parent = gui

            local coordFrame = Instance.new("Frame")
            coordFrame.Size = UDim2.new(0, 200, 1, 0)
            coordFrame.BackgroundColor3 = Color3.new(0, 0, 0)
            coordFrame.BackgroundTransparency = 0.7
            coordFrame.BorderSizePixel = 1
            coordFrame.Parent = container

            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.TextColor3 = Color3.new(1, 1, 1)
            textLabel.Font = Enum.Font.SourceSansBold
            textLabel.TextSize = 14
            textLabel.Text = "坐标加载别乱动(警告)"
            textLabel.Parent = coordFrame

            local copyBtn = Instance.new("TextButton")
            copyBtn.Size = UDim2.new(0, 35, 1, 0)
            copyBtn.Position = UDim2.new(0, 205, 0, 0)
            copyBtn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
            copyBtn.BackgroundTransparency = 0.5
            copyBtn.Text = "复制坐标"
            copyBtn.TextColor3 = Color3.new(1, 1, 1)
            copyBtn.TextSize = 14
            copyBtn.BorderSizePixel = 1
            copyBtn.Parent = container

            copyBtn.MouseButton1Click:Connect(function()
                if setclipboard and coordSystem.currentPos then
                    local coordStr = string.format("X: %.2f, Y: %.2f, Z: %.2f",
                        coordSystem.currentPos.X,
                        coordSystem.currentPos.Y,
                        coordSystem.currentPos.Z
                    )
                    setclipboard(coordStr)
                end
            end)

            local isDragging = false
            local dragStartPos = nil
            local containerStartPos = nil

            container.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    isDragging = true
                    dragStartPos = input.Position
                    containerStartPos = container.Position
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if isDragging and input.UserInputType == Enum.UserInputType.Touch then
                    local delta = input.Position - dragStartPos
                    container.Position = UDim2.new(
                        containerStartPos.X.Scale,
                        containerStartPos.X.Offset + delta.X,
                        containerStartPos.Y.Scale,
                        containerStartPos.Y.Offset + delta.Y
                    )
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch and isDragging then
                    isDragging = false
                end
            end)

            return { gui = gui, container = container, text = textLabel }
        end

        coordSystem.gui = createCoordUI()

        local function formatCoord(pos)
            return string.format("X: %.2f\nY: %.2f\nZ: %.2f", pos.X, pos.Y, pos.Z)
        end

        local function updateCoord()
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                coordSystem.currentPos = root.Position
                coordSystem.gui.text.Text = formatCoord(root.Position)
            else
                coordSystem.gui.text.Text = "路西法nb"
                coordSystem.currentPos = nil
            end
        end

        coordSystem.updateConn = RunService.Heartbeat:Connect(updateCoord)
        updateCoord()

        game:GetService("Players").LocalPlayer.PlayerGui.ChildRemoved:Connect(function(child)
            if child == coordSystem.gui then
                if coordSystem.updateConn then
                    coordSystem.updateConn:Disconnect()
                end
            end
        end)
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
