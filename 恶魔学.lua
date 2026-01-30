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
    Title = "鬼魂区",
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

local Tab = Tabs.Main:Tab({
    Title = "功能",
    Icon = "settings",
    Locked = false,
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