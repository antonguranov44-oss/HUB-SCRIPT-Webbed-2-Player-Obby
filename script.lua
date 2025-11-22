--[[
    🕷️ WEBBED! GOD MODE
    By: Yan4hic
    
    FIXES:
    - 🚫 REMOVED SCROLLING: Pages are now static Frames. No more floating buttons bug.
    - 🔒 ANCHORED LAYOUT: Buttons are strictly bound to the menu container.
    - 🎨 VISUALS: All animations, gradients, and the "alive" background kept.
--]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

-- === GLOBAL VARS ===
local Remote = ReplicatedStorage:WaitForChild("RemoteEvent", 5)
local TitleFont = Enum.Font.FredokaOne 
local BodyFont = Enum.Font.GothamBold

-- === FUNCTIONS ===
function GetSpider()
    if Workspace:FindFirstChild("SPIDERS") and Workspace.SPIDERS:FindFirstChild(LocalPlayer.Name) then
        return Workspace.SPIDERS[LocalPlayer.Name]
    end
    return nil
end

function GetRoot()
    local spider = GetSpider()
    if spider then
        return spider:FindFirstChild("Root") or spider:FindFirstChild("HumanoidRootPart")
    end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return LocalPlayer.Character.HumanoidRootPart
    end
    return nil
end

-- === GUI CREATION ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WebbedGod_V1.2_Fixed"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

-- 1. MAIN FRAME
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 360)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true -- ВАЖНО: Обрезает все лишнее
MainFrame.Active = true 
MainFrame.Parent = ScreenGui

-- Закругление
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 16)
Corner.Parent = MainFrame

-- ОБВОДКА С ГРАДИЕНТОМ
local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 3
Stroke.Color = Color3.fromRGB(255, 255, 255)
Stroke.Parent = MainFrame

local StrokeGradient = Instance.new("UIGradient")
StrokeGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 60, 90)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 0, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 60, 90))
}
StrokeGradient.Rotation = 45
StrokeGradient.Parent = Stroke

-- АНИМИРОВАННЫЙ ФОН
local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 150, 170))
}
MainGradient.Rotation = 0
MainGradient.Parent = MainFrame

spawn(function()
    while MainFrame.Parent do
        MainGradient.Rotation = MainGradient.Rotation + 0.2
        StrokeGradient.Rotation = StrokeGradient.Rotation - 0.5
        task.wait(0.02)
    end
end)

-- 2. SIDEBAR
local SideBar = Instance.new("Frame")
SideBar.Name = "SideBar"
SideBar.Size = UDim2.new(0, 140, 1, 0)
SideBar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
SideBar.BackgroundTransparency = 0.6
SideBar.BorderSizePixel = 0
SideBar.Parent = MainFrame

local SideCorner = Instance.new("UICorner")
SideCorner.CornerRadius = UDim.new(0, 16)
SideCorner.Parent = SideBar

-- Заголовок
local TitleBox = Instance.new("Frame")
TitleBox.Size = UDim2.new(1, 0, 0, 70)
TitleBox.BackgroundTransparency = 1
TitleBox.Parent = SideBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, 0, 1, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "WEBBED\nGOD"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.Font = TitleFont
TitleText.TextSize = 26
TitleText.TextStrokeTransparency = 0.8
TitleText.Parent = TitleBox

local VerText = Instance.new("TextLabel")
VerText.Size = UDim2.new(1, 0, 0, 20)
VerText.Position = UDim2.new(0,0,0.8,0)
VerText.BackgroundTransparency = 1
VerText.Text = "V1.2"
VerText.TextColor3 = Color3.fromRGB(255, 60, 90)
VerText.Font = BodyFont
VerText.TextSize = 12
VerText.Parent = TitleBox

-- Контейнер вкладок
local TabsBox = Instance.new("Frame")
TabsBox.Size = UDim2.new(1, 0, 1, -100) 
TabsBox.Position = UDim2.new(0, 0, 0, 80)
TabsBox.BackgroundTransparency = 1
TabsBox.Parent = SideBar

local TabList = Instance.new("UIListLayout")
TabList.Parent = TabsBox
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.Padding = UDim.new(0, 10)
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- WATERMARK
local Watermark = Instance.new("TextLabel")
Watermark.Size = UDim2.new(1, 0, 0, 20)
Watermark.Position = UDim2.new(0, 0, 1, -25)
Watermark.BackgroundTransparency = 1
Watermark.Text = "By: Yan4hic"
Watermark.TextColor3 = Color3.fromRGB(255, 255, 255)
Watermark.TextTransparency = 0.5
Watermark.Font = BodyFont
Watermark.TextSize = 11
Watermark.Parent = SideBar

-- 3. CONTENT (ГДЕ КНОПКИ)
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "Content"
ContentFrame.Size = UDim2.new(1, -150, 1, -20)
ContentFrame.Position = UDim2.new(0, 150, 0, 10)
ContentFrame.BackgroundTransparency = 1
-- ВАЖНО: ClipsDescendants тут, чтобы контент не вылезал
ContentFrame.ClipsDescendants = true 
ContentFrame.Parent = MainFrame

-- === 🌌 ФИЗИКА ===
local dragging, dragInput, dragStart, startPos
local lastMousePos = Vector2.new(0,0)
local currentRot = 0
local targetRot = 0

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position; lastMousePos = UserInputService:GetMouseLocation()
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
SideBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position; lastMousePos = UserInputService:GetMouseLocation()
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
UserInputService.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)

RunService.RenderStepped:Connect(function(dt)
    if dragging and dragInput then
        local currentMousePos = UserInputService:GetMouseLocation()
        local delta = dragInput.Position - dragStart
        local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        MainFrame.Position = MainFrame.Position:Lerp(targetPos, 0.2)
        local mouseDelta = currentMousePos - lastMousePos
        targetRot = math.clamp(mouseDelta.X * 0.4, -8, 8) 
        lastMousePos = currentMousePos
    else
        targetRot = 0
    end
    currentRot = currentRot + (targetRot - currentRot) * (10 * dt)
    MainFrame.Rotation = currentRot
end)

-- === ВКЛАДКИ (ТЕПЕРЬ ОБЫЧНЫЕ FRAME, НЕ SCROLL) ===
local Pages = {}
local TabButtons = {}

local function CreatePage(name)
    -- ИЗМЕНЕНО: ScrollingFrame -> Frame
    local Page = Instance.new("Frame") 
    Page.Name = name.."_Page"
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.Parent = ContentFrame
    
    local Layout = Instance.new("UIListLayout")
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 8)
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Layout.Parent = Page
    
    local Pad = Instance.new("UIPadding")
    Pad.PaddingTop = UDim.new(0, 5)
    Pad.PaddingBottom = UDim.new(0, 10)
    Pad.Parent = Page
    Pages[name] = Page
    return Page
end

local function SwitchTab(name)
    for n, p in pairs(Pages) do p.Visible = (n == name) end
    for n, b in pairs(TabButtons) do
        local scale = b:FindFirstChild("UIScale")
        if n == name then
            TweenService:Create(b, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(255, 60, 90), BackgroundTransparency = 0.85}):Play()
            if scale then TweenService:Create(scale, TweenInfo.new(0.3), {Scale = 1.05}):Play() end
        else
            TweenService:Create(b, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(150, 150, 150), BackgroundTransparency = 1}):Play()
            if scale then TweenService:Create(scale, TweenInfo.new(0.3), {Scale = 1}):Play() end
        end
    end
end

local function CreateTabBtn(text, icon, pageName)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.85, 0, 0, 40)
    Btn.BackgroundTransparency = 1
    Btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Text = "  " .. icon .. "  " .. text
    Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    Btn.Font = BodyFont
    Btn.TextSize = 13
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.Parent = TabsBox
    
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
    local S = Instance.new("UIStroke", Btn); S.Thickness = 1.5; S.Color = Color3.fromRGB(255, 60, 90); S.Transparency = 0.5; S.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local G = Instance.new("UIGradient", Btn); G.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(180,180,180))}
    local Scale = Instance.new("UIScale", Btn)

    Btn.MouseEnter:Connect(function() if Pages[pageName].Visible == false then TweenService:Create(Scale, TweenInfo.new(0.2), {Scale = 1.05}):Play() end end)
    Btn.MouseLeave:Connect(function() if Pages[pageName].Visible == false then TweenService:Create(Scale, TweenInfo.new(0.2), {Scale = 1}):Play() end end)
    Btn.MouseButton1Down:Connect(function() TweenService:Create(Scale, TweenInfo.new(0.1), {Scale = 0.95}):Play() end)
    Btn.MouseButton1Up:Connect(function() TweenService:Create(Scale, TweenInfo.new(0.1), {Scale = 1.05}):Play() end)

    Btn.MouseButton1Click:Connect(function() SwitchTab(pageName) end)
    TabButtons[pageName] = Btn
end

-- === КНОПКИ ===
local function CreateButton(parent, text, callback, isToggle)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.96, 0, 0, 42) 
    Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = BodyFont
    Btn.TextSize = 14
    Btn.AutoButtonColor = false
    Btn.Parent = parent
    
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 10)
    local S = Instance.new("UIStroke", Btn); S.Thickness = 1.5; S.Color = Color3.fromRGB(80, 80, 90); S.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local G = Instance.new("UIGradient", Btn); G.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 150, 160))}; G.Rotation = 90
    local Scale = Instance.new("UIScale", Btn)
    
    Btn.MouseEnter:Connect(function() TweenService:Create(Scale, TweenInfo.new(0.2), {Scale = 1.02}):Play(); TweenService:Create(G, TweenInfo.new(0.2), {Rotation = 45}):Play() end)
    Btn.MouseLeave:Connect(function() TweenService:Create(Scale, TweenInfo.new(0.2), {Scale = 1}):Play(); TweenService:Create(G, TweenInfo.new(0.2), {Rotation = 90}):Play() end)
    
    local active = false
    Btn.MouseButton1Click:Connect(function()
        if isToggle then
            active = not active
            if active then
                TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 60, 90)}):Play()
                Btn.Text = text .. " [ON]"
            else
                TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}):Play()
                Btn.Text = text
            end
            callback(active)
        else
            TweenService:Create(Scale, TweenInfo.new(0.1), {Scale = 0.95}):Play()
            task.wait(0.1)
            TweenService:Create(Scale, TweenInfo.new(0.1), {Scale = 1.02}):Play()
            callback()
        end
    end)
end

local function CreateInput(parent, icon, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0.96, 0, 0, 42)
    Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    Frame.Parent = parent
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)
    
    local Ico = Instance.new("TextLabel")
    Ico.Size = UDim2.new(0.15, 0, 1, 0)
    Ico.BackgroundTransparency = 1; Ico.Text = icon; Ico.TextSize = 20; Ico.Parent = Frame
    local Box = Instance.new("TextBox")
    Box.Size = UDim2.new(0.8, 0, 1, 0); Box.Position = UDim2.new(0.15, 0, 0, 0); Box.BackgroundTransparency = 1
    Box.Text = default; Box.TextColor3 = Color3.fromRGB(255, 255, 255); Box.Font = BodyFont; Box.TextSize = 14; Box.TextXAlignment = Enum.TextXAlignment.Left; Box.Parent = Frame
    Box.FocusLost:Connect(function() callback(Box.Text) end)
end

-- ===============================
-- SETUP & CONTENT
-- ===============================

local HomePage = CreatePage("Home")
local BiomePage = CreatePage("Biomes")
local SkinPage = CreatePage("Skins")

CreateTabBtn("Main", "🏠", "Home")
CreateTabBtn("Biomes", "🌍", "Biomes")
CreateTabBtn("Skins", "🎨", "Skins")

-- [HOME]
CreateButton(HomePage, "✂️ CUT WEB (ALPHA)", function()
    local spider = GetSpider()
    if spider then
        for _, v in pairs(spider:GetDescendants()) do if v:IsA("RopeConstraint") or v:IsA("SpringConstraint") or v:IsA("Constraint") or v:IsA("Beam") then v:Destroy() end end
        if spider:FindFirstChild("Details") then for _, v in pairs(spider.Details:GetChildren()) do if v:IsA("Constraint") then v:Destroy() end end end
    end
end, false)

local currentSpeed = 16
CreateInput(HomePage, "⚡", "16 (Speed)", function(txt) local n = tonumber(txt); if n then currentSpeed = n end end)
RunService.Stepped:Connect(function() local r = GetRoot(); if r and r.Parent and r.Parent:FindFirstChild("Humanoid") then r.Parent.Humanoid.WalkSpeed = currentSpeed end end)

local ctpEnabled = false
CreateButton(HomePage, "🖱️ PRESS 'Q' TO TP", function(state) ctpEnabled = state end, true)
UserInputService.InputBegan:Connect(function(input, proc)
    if not proc and ctpEnabled and input.KeyCode == Enum.KeyCode.Q then
        local root = GetRoot(); if root then
            local targetPos = Mouse.Hit.p + Vector3.new(0, 3, 0); root.CFrame = CFrame.new(targetPos)
            if Remote then pcall(function() Remote:FireServer("SpawnCheckpoint", targetPos) end) end
            local ring = Instance.new("Part"); ring.Anchored=true; ring.CanCollide=false; ring.CFrame=CFrame.new(targetPos)
            ring.Transparency=0.5; ring.BrickColor=BrickColor.new("Really red"); ring.Parent=Workspace; Debris:AddItem(ring, 1)
        end
    end
end)

local flyEnabled = false
local bv, bg
CreateButton(HomePage, "✈️ SPIDER FLY (ALPHA)", function(state)
    flyEnabled = state
    local root = GetRoot(); if not root then return end
    if flyEnabled then
        root.CustomPhysicalProperties = nil
        bv = Instance.new("BodyVelocity", root); bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bg = Instance.new("BodyGyro", root); bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge); bg.P = 9000
        spawn(function()
            while flyEnabled and root.Parent do
                RunService.RenderStepped:Wait()
                local cam = Camera.CFrame; local move = Vector3.new()
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cam.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cam.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cam.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cam.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0, 1, 0) end
                bg.CFrame = cam; bv.Velocity = move * 60
            end
            if bv then bv:Destroy() end; if bg then bg:Destroy() end
        end)
    else if bv then bv:Destroy() end; if bg then bg:Destroy() end end
end, true)

local noclipConnection = nil
CreateButton(HomePage, "👻 NOCLIP (ALPHA)", function(state)
    if noclipConnection then noclipConnection:Disconnect(); noclipConnection = nil 
        local c = LocalPlayer.Character; if c then for _,p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=true end end end
        local s = GetSpider(); if s then for _,p in pairs(s:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=true end end end
    end
    if state then
        noclipConnection = RunService.Stepped:Connect(function()
            local c = LocalPlayer.Character; if c then for _,p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end
            local s = GetSpider(); if s then for _,p in pairs(s:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end
        end)
    end
end, true)

-- [BIOMES]
local Levels = {{Name="Spawn",ID=0,Icon="🌿"},{Name="Snow",ID=1,Icon="❄️"},{Name="Desert",ID=2,Icon="🌵"},{Name="Jungle",ID=3,Icon="🌴"},{Name="Magma",ID=4,Icon="🔥"},{Name="End",ID=5,Icon="🏁"}}
for _, lvl in ipairs(Levels) do
    CreateButton(BiomePage, lvl.Icon.." TP: "..lvl.Name, function()
        if Remote then Remote:FireServer("SpawnCheckpoint", lvl.ID) end
        game:GetService("StarterGui"):SetCore("SendNotification", {Title="Teleport", Text="Warping to "..lvl.Name})
    end, false)
end

-- [SKINS]
if Workspace:FindFirstChild("CLAIMSKINS") then
    for _, skin in pairs(Workspace.CLAIMSKINS:GetChildren()) do
        if skin:IsA("Model") or skin:IsA("BasePart") then
            CreateButton(SkinPage, "Get: "..skin.Name, function()
                local root = GetRoot(); local target = (skin:IsA("Model") and skin.PrimaryPart) or skin
                if root and target then
                    root.CFrame = target.CFrame * CFrame.new(0, 3, 0)
                    if Remote then Remote:FireServer("SpawnCheckpoint", target.CFrame.p) end
                end
            end, false)
        end
    end
else
    local lbl = Instance.new("TextLabel", SkinPage)
    lbl.Size = UDim2.new(1,0,0,30); lbl.BackgroundTransparency=1; lbl.Text="No Skins Found"; lbl.TextColor3=Color3.new(1,1,1); lbl.Font=BodyFont
end

-- EASTER EGGS
local function SpawnEasterEgg(text)
    local eggGui = Instance.new("ScreenGui"); eggGui.Name="Egg"; eggGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    local eggLabel = Instance.new("TextLabel"); eggLabel.Size = UDim2.new(1, 0, 0, 100); eggLabel.Position = UDim2.new(0, 0, 0.4, 0)
    eggLabel.BackgroundTransparency = 1; eggLabel.Text = text; eggLabel.TextColor3 = Color3.new(1,1,1)
    eggLabel.Font = TitleFont; eggLabel.TextSize = 40; eggLabel.TextTransparency = 1; eggLabel.Parent = eggGui
    local g = Instance.new("UIGradient", eggLabel); g.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,128)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0,255,255))}
    Instance.new("UIStroke", eggLabel).Thickness=3
    eggLabel.Rotation = -15
    TweenService:Create(eggLabel, TweenInfo.new(0.5, Enum.EasingStyle.Back), {TextTransparency=0, Rotation=0, TextSize=55}):Play()
    spawn(function() while eggLabel.Parent do g.Rotation=g.Rotation+2; task.wait(0.05) end end)
    task.wait(5); TweenService:Create(eggLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {TextTransparency=1, Position=UDim2.new(0,0,0.3,0)}):Play()
    task.wait(0.5); eggGui:Destroy()
end
UserInputService.InputBegan:Connect(function(i,p) if not p and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
    if i.KeyCode==Enum.KeyCode.D then SpawnEasterEgg("Даша приветос") elseif i.KeyCode==Enum.KeyCode.A then SpawnEasterEgg("Денес пашел нахуй (я любя)") elseif i.KeyCode==Enum.KeyCode.W then SpawnEasterEgg("Америка сосо, привэт") elseif i.KeyCode==Enum.KeyCode.S then SpawnEasterEgg("Комик пидарас") end
end end)

-- TOGGLE
local isOpen = true
UserInputService.InputBegan:Connect(function(i, p)
    if not p and i.KeyCode == Enum.KeyCode.M then
        isOpen = not isOpen
        if isOpen then
            MainFrame.Visible = true; MainFrame.Size = UDim2.new(0, 0, 0, 0)
            TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Size = UDim2.new(0, 520, 0, 360)}):Play()
        else
            local t = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
            t:Play(); t.Completed:Connect(function() if not isOpen then MainFrame.Visible = false end end)
        end
    end
end)

SwitchTab("Home")
game:GetService("StarterGui"):SetCore("SendNotification", {Title="WEBBED GOD V1.2"; Text="FIXED & LOADED!"; Duration=5})
