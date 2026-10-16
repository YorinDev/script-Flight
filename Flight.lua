local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

pcall(function()
    if playerGui:FindFirstChild("main") then
        playerGui.main:Destroy()
    end
end)

local main = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local onof = Instance.new("TextButton")
local plus = Instance.new("TextButton")
local speed = Instance.new("TextLabel")
local mine = Instance.new("TextButton")

local speeds = 1
local nowe = false
local tpwalking = false

main.Name = "main"
main.ResetOnSpawn = false
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
main.Parent = playerGui

-- Helpers
local function createCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
    return c
end

local function createStroke(parent, thickness, color, transparency)
    local s = Instance.new("UIStroke")
    s.Thickness = thickness
    s.Color = color
    s.Transparency = transparency or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

local function createShadow(parent)
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.86
    shadow.BorderSizePixel = 0
    shadow.Position = parent.Position + UDim2.new(0, 0, 0, 8)
    shadow.Size = parent.Size
    shadow.ZIndex = math.max(parent.ZIndex - 1, 0)
    shadow.Parent = parent.Parent
    createCorner(shadow, 24)
    return shadow
end

local function styleButton(button, bgColor, textColor)
    button.AutoButtonColor = false
    button.BackgroundColor3 = bgColor
    button.BorderSizePixel = 0
    button.TextColor3 = textColor
    button.Font = Enum.Font.GothamSemibold
    createCorner(button, 16)
    createStroke(button, 1.2, Color3.fromRGB(220, 228, 240), 0.2)

    local originalBg = bgColor
    local originalSize = button.Size
    local hoverSize = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, originalSize.Y.Scale, originalSize.Y.Offset + 2)
    local hoverBg = Color3.new(
        math.clamp(bgColor.R + 0.06, 0, 1),
        math.clamp(bgColor.G + 0.06, 0, 1),
        math.clamp(bgColor.B + 0.06, 0, 1)
    )

    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = hoverBg,
            Size = hoverSize
        }):Play()
    end)

    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = originalBg,
            Size = originalSize
        }):Play()
    end)
end

-- Background blur-like overlay
local backdrop = Instance.new("Frame")
backdrop.Name = "Backdrop"
backdrop.Parent = main
backdrop.BackgroundColor3 = Color3.fromRGB(245, 248, 255)
backdrop.BackgroundTransparency = 1
backdrop.BorderSizePixel = 0
backdrop.Size = UDim2.new(1, 0, 1, 0)
backdrop.ZIndex = 1

-- Splash screen
local splash = Instance.new("Frame")
splash.Name = "Splash"
splash.Parent = main
splash.AnchorPoint = Vector2.new(0.5, 0.5)
splash.Position = UDim2.new(0.5, 0, 0.5, 0)
splash.Size = UDim2.new(0, 0, 0, 0)
splash.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
splash.BackgroundTransparency = 0.12
splash.BorderSizePixel = 0
splash.ZIndex = 5
createCorner(splash, 28)
createStroke(splash, 1.5, Color3.fromRGB(214, 224, 240), 0.05)

local splashShadow = createShadow(splash)
splashShadow.ZIndex = 4

local splashTitle = Instance.new("TextLabel")
splashTitle.Parent = splash
splashTitle.BackgroundTransparency = 1
splashTitle.Size = UDim2.new(1, -40, 0, 54)
splashTitle.Position = UDim2.new(0, 20, 0, 42)
splashTitle.Font = Enum.Font.GothamBold
splashTitle.Text = "Made by Yorin"
splashTitle.TextColor3 = Color3.fromRGB(35, 45, 60)
splashTitle.TextTransparency = 1
splashTitle.TextSize = 28
splashTitle.ZIndex = 6

local splashSub = Instance.new("TextLabel")
splashSub.Parent = splash
splashSub.BackgroundTransparency = 1
splashSub.Size = UDim2.new(1, -40, 0, 28)
splashSub.Position = UDim2.new(0, 20, 0, 96)
splashSub.Font = Enum.Font.Gotham
splashSub.Text = "Loading Flight interface..."
splashSub.TextColor3 = Color3.fromRGB(98, 108, 124)
splashSub.TextTransparency = 1
splashSub.TextSize = 15
splashSub.ZIndex = 6

local progressBarBg = Instance.new("Frame")
progressBarBg.Parent = splash
progressBarBg.BackgroundColor3 = Color3.fromRGB(238, 242, 248)
progressBarBg.BackgroundTransparency = 0.05
progressBarBg.BorderSizePixel = 0
progressBarBg.Position = UDim2.new(0, 20, 1, -44)
progressBarBg.Size = UDim2.new(1, -40, 0, 12)
progressBarBg.ZIndex = 6
createCorner(progressBarBg, 50)

local progressBar = Instance.new("Frame")
progressBar.Parent = progressBarBg
progressBar.BackgroundColor3 = Color3.fromRGB(94, 171, 255)
progressBar.BorderSizePixel = 0
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.ZIndex = 7
createCorner(progressBar, 50)

-- Main panel
Frame.Parent = main
Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame.BackgroundTransparency = 0.15
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.5, -180, 0.5, -130)
Frame.Size = UDim2.new(0, 360, 0, 260)
Frame.Visible = false
Frame.ZIndex = 10
createCorner(Frame, 26)
createStroke(Frame, 1.5, Color3.fromRGB(214, 224, 240), 0.05)
local frameShadow = createShadow(Frame)
frameShadow.ZIndex = 9

-- Drag support
local dragging = false
local dragInput, dragStart, startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    Frame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
    frameShadow.Position = Frame.Position + UDim2.new(0, 0, 0, 8)
end

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        updateInput(input)
    end
end)

-- Header
local header = Instance.new("Frame")
header.Parent = Frame
header.BackgroundTransparency = 1
header.Size = UDim2.new(1, -24, 0, 72)
header.Position = UDim2.new(0, 12, 0, 12)
header.ZIndex = 11

local icon = Instance.new("TextLabel")
icon.Parent = header
icon.BackgroundColor3 = Color3.fromRGB(232, 246, 255)
icon.BackgroundTransparency = 0.04
icon.BorderSizePixel = 0
icon.Size = UDim2.new(0, 42, 0, 42)
icon.Position = UDim2.new(0, 0, 0, 4)
icon.Font = Enum.Font.GothamBold
icon.Text = "F"
icon.TextColor3 = Color3.fromRGB(58, 113, 180)
icon.TextSize = 24
icon.ZIndex = 12
createCorner(icon, 14)

local title = Instance.new("TextLabel")
title.Parent = header
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 54, 0, 1)
title.Size = UDim2.new(1, -150, 0, 28)
title.Font = Enum.Font.GothamBold
title.Text = "Flight"
title.TextColor3 = Color3.fromRGB(34, 42, 56)
title.TextSize = 28
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 12

local subtitle = Instance.new("TextLabel")
subtitle.Parent = header
subtitle.BackgroundTransparency = 1
subtitle.Position = UDim2.new(0, 54, 0, 30)
subtitle.Size = UDim2.new(1, -150, 0, 20)
subtitle.Font = Enum.Font.Gotham
subtitle.Text = "Script by Yorin"
subtitle.TextColor3 = Color3.fromRGB(118, 127, 142)
subtitle.TextSize = 14
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.ZIndex = 12

local stateHolder = Instance.new("Frame")
stateHolder.Parent = header
stateHolder.BackgroundColor3 = Color3.fromRGB(246, 248, 252)
stateHolder.BackgroundTransparency = 0.08
stateHolder.BorderSizePixel = 0
stateHolder.AnchorPoint = Vector2.new(1, 0)
stateHolder.Position = UDim2.new(1, 0, 0, 2)
stateHolder.Size = UDim2.new(0, 84, 0, 36)
stateHolder.ZIndex = 12
createCorner(stateHolder, 14)

local stateDot = Instance.new("Frame")
stateDot.Parent = stateHolder
stateDot.BackgroundColor3 = Color3.fromRGB(168, 176, 190)
stateDot.BorderSizePixel = 0
stateDot.Position = UDim2.new(0, 12, 0.5, -5)
stateDot.Size = UDim2.new(0, 10, 0, 10)
stateDot.ZIndex = 13
createCorner(stateDot, 99)

local stateText = Instance.new("TextLabel")
stateText.Parent = stateHolder
stateText.BackgroundTransparency = 1
stateText.Position = UDim2.new(0, 28, 0, 0)
stateText.Size = UDim2.new(1, -28, 1, 0)
stateText.Font = Enum.Font.GothamBold
stateText.Text = "OFF"
stateText.TextColor3 = Color3.fromRGB(88, 96, 110)
stateText.TextSize = 14
stateText.ZIndex = 13

local divider1 = Instance.new("Frame")
divider1.Parent = Frame
divider1.BackgroundColor3 = Color3.fromRGB(234, 239, 246)
divider1.BorderSizePixel = 0
divider1.Position = UDim2.new(0, 16, 0, 86)
divider1.Size = UDim2.new(1, -32, 0, 1)
divider1.ZIndex = 11

-- Speed section
local speedTitle = Instance.new("TextLabel")
speedTitle.Parent = Frame
speedTitle.BackgroundTransparency = 1
speedTitle.Position = UDim2.new(0, 16, 0, 98)
speedTitle.Size = UDim2.new(1, -32, 0, 18)
speedTitle.Font = Enum.Font.GothamBold
speedTitle.Text = "SPEED"
speedTitle.TextColor3 = Color3.fromRGB(59, 73, 96)
speedTitle.TextSize = 18
speedTitle.TextXAlignment = Enum.TextXAlignment.Left
speedTitle.ZIndex = 12

local speedSub = Instance.new("TextLabel")
speedSub.Parent = Frame
speedSub.BackgroundTransparency = 1
speedSub.Position = UDim2.new(0, 16, 0, 120)
speedSub.Size = UDim2.new(1, -32, 0, 16)
speedSub.Font = Enum.Font.Gotham
speedSub.Text = "Movement multiplier"
speedSub.TextColor3 = Color3.fromRGB(132, 141, 157)
speedSub.TextSize = 13
speedSub.TextXAlignment = Enum.TextXAlignment.Left
speedSub.ZIndex = 12

mine.Name = "mine"
mine.Parent = Frame
mine.Position = UDim2.new(0, 16, 0, 146)
mine.Size = UDim2.new(0, 72, 0, 46)
mine.Text = "-"
mine.TextSize = 28
mine.ZIndex = 12
styleButton(mine, Color3.fromRGB(246, 248, 252), Color3.fromRGB(53, 66, 84))

speed.Name = "speed"
speed.Parent = Frame
speed.BackgroundTransparency = 1
speed.Position = UDim2.new(0.5, -40, 0, 142)
speed.Size = UDim2.new(0, 80, 0, 54)
speed.Font = Enum.Font.GothamBold
speed.Text = tostring(speeds)
speed.TextColor3 = Color3.fromRGB(36, 48, 66)
speed.TextSize = 42
speed.ZIndex = 12

plus.Name = "plus"
plus.Parent = Frame
plus.Position = UDim2.new(1, -88, 0, 146)
plus.Size = UDim2.new(0, 72, 0, 46)
plus.Text = "+"
plus.TextSize = 28
plus.ZIndex = 12
styleButton(plus, Color3.fromRGB(232, 243, 255), Color3.fromRGB(44, 93, 157))

local divider2 = Instance.new("Frame")
divider2.Parent = Frame
divider2.BackgroundColor3 = Color3.fromRGB(234, 239, 246)
divider2.BorderSizePixel = 0
divider2.Position = UDim2.new(0, 16, 0, 212)
divider2.Size = UDim2.new(1, -32, 0, 1)
divider2.ZIndex = 11

local modeTitle = Instance.new("TextLabel")
modeTitle.Parent = Frame
modeTitle.BackgroundTransparency = 1
modeTitle.Position = UDim2.new(0, 16, 0, 222)
modeTitle.Size = UDim2.new(1, -32, 0, 18)
modeTitle.Font = Enum.Font.GothamBold
modeTitle.Text = "FLIGHT MODE"
modeTitle.TextColor3 = Color3.fromRGB(59, 73, 96)
modeTitle.TextSize = 18
modeTitle.TextXAlignment = Enum.TextXAlignment.Left
modeTitle.ZIndex = 12

onof.Name = "onof"
onof.Parent = Frame
onof.Position = UDim2.new(0, 16, 1, -58)
onof.Size = UDim2.new(1, -32, 0, 42)
onof.Text = "fly"
onof.TextSize = 22
onof.ZIndex = 12
styleButton(onof, Color3.fromRGB(242, 245, 250), Color3.fromRGB(70, 78, 92))

local flyDot = Instance.new("Frame")
flyDot.Parent = onof
flyDot.BackgroundColor3 = Color3.fromRGB(168, 176, 190)
flyDot.BorderSizePixel = 0
flyDot.Position = UDim2.new(0, 16, 0.5, -6)
flyDot.Size = UDim2.new(0, 12, 0, 12)
flyDot.ZIndex = 13
createCorner(flyDot, 99)

local function syncShadow()
    frameShadow.Position = Frame.Position + UDim2.new(0, 0, 0, 8)
    frameShadow.Size = Frame.Size
end
syncShadow()

local function setVisualState(enabled)
    if enabled then
        TweenService:Create(stateHolder, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(230, 244, 233)}):Play()
        TweenService:Create(stateDot, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(68, 181, 88)}):Play()
        TweenService:Create(onof, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(233, 246, 236), TextColor3 = Color3.fromRGB(45, 116, 58)}):Play()
        TweenService:Create(flyDot, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(68, 181, 88)}):Play()
        stateText.Text = "ON"
    else
        TweenService:Create(stateHolder, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(246, 248, 252)}):Play()
        TweenService:Create(stateDot, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(168, 176, 190)}):Play()
        TweenService:Create(onof, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(242, 245, 250), TextColor3 = Color3.fromRGB(70, 78, 92)}):Play()
        TweenService:Create(flyDot, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(168, 176, 190)}):Play()
        stateText.Text = "OFF"
    end
end
setVisualState(false)

pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "Flight";
        Text = "Script by Yorin";
        Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150";
        Duration = 5;
    })
end)

local function beginTpWalking()
    tpwalking = false
    for i = 1, speeds do
        task.spawn(function()
            local hb = RunService.Heartbeat
            tpwalking = true
            local chr = player.Character
            local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
            while tpwalking and hb:Wait() and chr and hum and hum.Parent do
                if hum.MoveDirection.Magnitude > 0 then
                    chr:TranslateBy(hum.MoveDirection)
                end
            end
        end)
    end
end

onof.MouseButton1Down:Connect(function()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        return
    end

    if nowe == true then
        nowe = false
        setVisualState(false)

        humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
        humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
    else
        nowe = true
        setVisualState(true)

        beginTpWalking()

        if character:FindFirstChild("Animate") then
            character.Animate.Disabled = true
        end

        local Hum = character:FindFirstChildOfClass("Humanoid") or character:FindFirstChildOfClass("AnimationController")
        if Hum then
            for _, v in next, Hum:GetPlayingAnimationTracks() do
                v:AdjustSpeed(0)
            end
        end

        humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
        humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
    end

    if humanoid.RigType == Enum.HumanoidRigType.R6 then
        local plr = player
        local torso = plr.Character and plr.Character:FindFirstChild("Torso")
        if not torso then return end

        local ctrl = {f = 0, b = 0, l = 0, r = 0}
        local lastctrl = {f = 0, b = 0, l = 0, r = 0}
        local maxspeed = 50
        local speedValue = 0

        local bg = Instance.new("BodyGyro", torso)
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = torso.CFrame

        local bv = Instance.new("BodyVelocity", torso)
        bv.velocity = Vector3.new(0, 0.1, 0)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)

        if nowe == true then
            plr.Character.Humanoid.PlatformStand = true
        end

        while nowe == true or (plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health == 0) do
            RunService.RenderStepped:Wait()

            if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                speedValue = speedValue + .5 + (speedValue / maxspeed)
                if speedValue > maxspeed then speedValue = maxspeed end
            elseif speedValue ~= 0 then
                speedValue = speedValue - 1
                if speedValue < 0 then speedValue = 0 end
            end

            if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
                bv.velocity = ((workspace.CurrentCamera.CFrame.LookVector * (ctrl.f + ctrl.b)) + ((workspace.CurrentCamera.CFrame * CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b) * .2, 0).Position) - workspace.CurrentCamera.CFrame.Position)) * speedValue
                lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
            elseif speedValue ~= 0 then
                bv.velocity = ((workspace.CurrentCamera.CFrame.LookVector * (lastctrl.f + lastctrl.b)) + ((workspace.CurrentCamera.CFrame * CFrame.new(lastctrl.l + lastctrl.r, (lastctrl.f + lastctrl.b) * .2, 0).Position) - workspace.CurrentCamera.CFrame.Position)) * speedValue
            else
                bv.velocity = Vector3.new(0, 0, 0)
            end

            bg.cframe = workspace.CurrentCamera.CFrame * CFrame.Angles(-math.rad((ctrl.f + ctrl.b) * 50 * speedValue / maxspeed), 0, 0)
        end

        bg:Destroy()
        bv:Destroy()
        if plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") then
            plr.Character.Humanoid.PlatformStand = false
        end
        if plr.Character and plr.Character:FindFirstChild("Animate") then
            plr.Character.Animate.Disabled = false
        end
        tpwalking = false
    else
        local plr = player
        local upperTorso = plr.Character and plr.Character:FindFirstChild("UpperTorso")
        if not upperTorso then return end

        local ctrl = {f = 0, b = 0, l = 0, r = 0}
        local lastctrl = {f = 0, b = 0, l = 0, r = 0}
        local maxspeed = 50
        local speedValue = 0

        local bg = Instance.new("BodyGyro", upperTorso)
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = upperTorso.CFrame

        local bv = Instance.new("BodyVelocity", upperTorso)
        bv.velocity = Vector3.new(0, 0.1, 0)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)

        if nowe == true then
            plr.Character.Humanoid.PlatformStand = true
        end

        while nowe == true or (plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health == 0) do
            task.wait()

            if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                speedValue = speedValue + .5 + (speedValue / maxspeed)
                if speedValue > maxspeed then speedValue = maxspeed end
            elseif speedValue ~= 0 then
                speedValue = speedValue - 1
                if speedValue < 0 then speedValue = 0 end
            end

            if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
                bv.velocity = ((workspace.CurrentCamera.CFrame.LookVector * (ctrl.f + ctrl.b)) + ((workspace.CurrentCamera.CFrame * CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b) * .2, 0).Position) - workspace.CurrentCamera.CFrame.Position)) * speedValue
                lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
            elseif speedValue ~= 0 then
                bv.velocity = ((workspace.CurrentCamera.CFrame.LookVector * (lastctrl.f + lastctrl.b)) + ((workspace.CurrentCamera.CFrame * CFrame.new(lastctrl.l + lastctrl.r, (lastctrl.f + lastctrl.b) * .2, 0).Position) - workspace.CurrentCamera.CFrame.Position)) * speedValue
            else
                bv.velocity = Vector3.new(0, 0, 0)
            end

            bg.cframe = workspace.CurrentCamera.CFrame * CFrame.Angles(-math.rad((ctrl.f + ctrl.b) * 50 * speedValue / maxspeed), 0, 0)
        end

        bg:Destroy()
        bv:Destroy()
        if plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") then
            plr.Character.Humanoid.PlatformStand = false
        end
        if plr.Character and plr.Character:FindFirstChild("Animate") then
            plr.Character.Animate.Disabled = false
        end
        tpwalking = false
    end
end)

player.CharacterAdded:Connect(function(char)
    task.wait(0.7)
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.PlatformStand = false
    end
    if char:FindFirstChild("Animate") then
        char.Animate.Disabled = false
    end
    nowe = false
    tpwalking = false
    setVisualState(false)
end)

plus.MouseButton1Down:Connect(function()
    speeds = speeds + 1
    speed.Text = tostring(speeds)
    if nowe == true then
        beginTpWalking()
    end
end)

mine.MouseButton1Down:Connect(function()
    if speeds == 1 then
        speed.Text = "min = 1"
        task.wait(0.8)
        speed.Text = tostring(speeds)
    else
        speeds = speeds - 1
        speed.Text = tostring(speeds)
        if nowe == true then
            beginTpWalking()
        end
    end
end)

-- Intro animation
Frame.Size = UDim2.new(0, 360, 0, 260)
Frame.Position = UDim2.new(0.5, -180, 0.5, -130)
syncShadow()
Frame.Visible = false

TweenService:Create(backdrop, TweenInfo.new(0.35), {BackgroundTransparency = 0.35}):Play()
TweenService:Create(splash, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, 330, 0, 160)}):Play()
TweenService:Create(splashShadow, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, 330, 0, 160), Position = splash.Position + UDim2.new(0, 0, 0, 8)}):Play()

local splashTextTween = TweenService:Create(splashTitle, TweenInfo.new(0.35), {TextTransparency = 0})
local splashSubTween = TweenService:Create(splashSub, TweenInfo.new(0.35), {TextTransparency = 0})

task.wait(0.22)
splashTextTween:Play()
splashSubTween:Play()
TweenService:Create(progressBar, TweenInfo.new(1.9, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()

task.wait(2.4)
TweenService:Create(splashTitle, TweenInfo.new(0.25), {TextTransparency = 1}):Play()
TweenService:Create(splashSub, TweenInfo.new(0.25), {TextTransparency = 1}):Play()
TweenService:Create(splash, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1, Size = UDim2.new(0, 360, 0, 170)}):Play()
TweenService:Create(splashShadow, TweenInfo.new(0.35), {BackgroundTransparency = 1, Size = UDim2.new(0, 360, 0, 170), Position = splash.Position + UDim2.new(0, 0, 0, 8)}):Play()
TweenService:Create(progressBarBg, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
TweenService:Create(progressBar, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()

task.wait(0.38)
splash.Visible = false
splashShadow.Visible = false
Frame.Visible = true
Frame.BackgroundTransparency = 1
frameShadow.BackgroundTransparency = 1
Frame.Size = UDim2.new(0, 320, 0, 220)
Frame.Position = UDim2.new(0.5, -160, 0.5, -110)
syncShadow()

TweenService:Create(Frame, TweenInfo.new(0.42, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
    BackgroundTransparency = 0.15,
    Size = UDim2.new(0, 360, 0, 260),
    Position = UDim2.new(0.5, -180, 0.5, -130)
}):Play()
TweenService:Create(frameShadow, TweenInfo.new(0.42), {
    BackgroundTransparency = 0.86,
    Size = UDim2.new(0, 360, 0, 260),
    Position = UDim2.new(0.5, -180, 0.5, -122)
}):Play()
TweenService:Create(backdrop, TweenInfo.new(0.45), {BackgroundTransparency = 1}):Play()

task.wait(0.05)
syncShadow()
