--[[
================================================================================
  👑 KING AKBAR - INDO HANGOUT HUB (WINDUI + SILENT MODE AFK) 👑
================================================================================
--]]

-- ============================================================================
-- // 0. LOAD WINDUI (SAFE)
-- ============================================================================
local WindUI
do
    local ok, result = pcall(function()
        return loadstring(game:HttpGet(
            "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
        ))()
    end)
    if ok and result then
        WindUI = result
    else
        warn("[King Akbar] WindUI gagal load: " .. tostring(result))
        return
    end
end

-- ============================================================================
-- // 0.5 BYPASS PAUSE (HANCURKAN NETWORK PAUSE)
-- ============================================================================
pcall(function()
    local CoreGui = game:GetService("CoreGui")
    if CoreGui:FindFirstChild("RobloxGui") then
        local pauseScript = CoreGui.RobloxGui:FindFirstChild("CoreScripts/NetworkPause")
        if pauseScript then
            pauseScript:Destroy()
        end
    end
end)

-- ============================================================================
-- // 1. SERVICES & DEVICE DETECTOR
-- ============================================================================
local Services = {
    Players           = game:GetService("Players"),
    RunService        = game:GetService("RunService"),
    UserInput         = game:GetService("UserInputService"),
    TweenSvc          = game:GetService("TweenService"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    CoreGui           = game:GetService("CoreGui"),
    VirtualUser       = game:GetService("VirtualUser")
}

local LocalPlayer = Services.Players.LocalPlayer
local IsMobile = Services.UserInput.TouchEnabled and not Services.UserInput.MouseEnabled

-- ============================================================================
-- // 2. SPLASH SCREEN (KING AKBAR STYLE)
-- ============================================================================
do
    local sg = Instance.new("ScreenGui")
    sg.Name = "KingAkbarSplash"; sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true; sg.DisplayOrder = 999
    sg.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local bg = Instance.new("Frame", sg)
    bg.Size = UDim2.fromScale(1,1); bg.BackgroundColor3 = Color3.fromHex("#0a0a0a")
    bg.BorderSizePixel = 0; bg.ZIndex = 1

    local grad = Instance.new("UIGradient", bg)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("#0a0a0a")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("#1e1e1e")),
    }); grad.Rotation = 135

    local ct = Instance.new("Frame", bg)
    ct.Size = UDim2.fromOffset(500, 300); ct.Position = UDim2.fromScale(0.5, 0.5)
    ct.AnchorPoint = Vector2.new(0.5, 0.5); ct.BackgroundTransparency = 1; ct.ZIndex = 2

    local function mkLabel(txt, yOff, sz)
        local l = Instance.new("TextLabel", ct)
        l.Size = UDim2.fromOffset(500, 70); l.Position = UDim2.fromOffset(0, yOff)
        l.BackgroundTransparency = 1; l.Text = txt; l.TextSize = sz
        l.Font = Enum.Font.GothamBold; l.TextColor3 = Color3.fromHex("#ffffff")
        l.TextTransparency = 1; l.ZIndex = 3; return l
    end

    local icon = Instance.new("ImageLabel", ct)
    icon.Size = UDim2.fromOffset(120, 120); icon.Position = UDim2.fromOffset(190, -40)
    icon.BackgroundTransparency = 1; icon.Image = "rbxassetid://91115084979317"
    icon.ImageTransparency = 1; icon.ZIndex = 3

    local title = mkLabel("King Akbar", 70, IsMobile and 38 or 50)
    local tg = Instance.new("UIGradient", title)
    tg.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromHex("#ffffff")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("#aaaaaa")),
        ColorSequenceKeypoint.new(1,   Color3.fromHex("#555555")),
    }); tg.Rotation = 45

    local stat = mkLabel("Mempersiapkan mesin memancing...", 200, 12)
    stat.Font = Enum.Font.Gotham; stat.TextColor3 = Color3.fromHex("#555555")
    stat.TextXAlignment = Enum.TextXAlignment.Left; stat.Position = UDim2.fromOffset(50, 200)

    local line = Instance.new("Frame", ct)
    line.Size = UDim2.fromOffset(0, 2); line.Position = UDim2.fromOffset(250, 152)
    line.AnchorPoint = Vector2.new(0.5, 0); line.BackgroundColor3 = Color3.fromHex("#444444")
    line.BorderSizePixel = 0; line.ZIndex = 3

    local barBg = Instance.new("Frame", ct)
    barBg.Size = UDim2.fromOffset(400, 5); barBg.Position = UDim2.fromOffset(50, 190)
    barBg.BackgroundColor3 = Color3.fromHex("#222222"); barBg.BackgroundTransparency = 1
    barBg.BorderSizePixel = 0; barBg.ZIndex = 3
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

    local bar = Instance.new("Frame", barBg)
    bar.Size = UDim2.fromOffset(0, 5); bar.BackgroundColor3 = Color3.fromHex("#ffffff")
    bar.BorderSizePixel = 0; bar.ZIndex = 4
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

    local function tw(obj, props, t)
        Services.TweenSvc:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play()
    end

    task.spawn(function()
        tw(icon,  { ImageTransparency = 0 }, 0.5); task.wait(0.15)
        tw(title, { TextTransparency  = 0 }, 0.6); task.wait(0.35)
        tw(line,  { Size = UDim2.fromOffset(400, 2) }, 0.7); task.wait(0.4)
        tw(barBg, { BackgroundTransparency = 0 }, 0.3)
        tw(stat,  { TextTransparency = 0 }, 0.3)

        for _, s in ipairs({
            { "Memuat UI Library...", 0.30 },
            { "Mengecek Server Indo Hangout...", 0.60 },
            { "Welcome, King Akbar!", 1.00 },
        }) do
            stat.Text = s[1]
            tw(bar, { Size = UDim2.fromOffset(400 * s[2], 5) }, 0.5)
            task.wait(0.55)
        end

        task.wait(0.3)
        for _, p in ipairs({ bg, icon, title, line, barBg, bar, stat }) do
            local prop = p == stat and "TextTransparency"
                or (p == icon  and "ImageTransparency" or "BackgroundTransparency")
            if p == title then prop = "TextTransparency" end
            tw(p, { [prop] = 1 }, 0.4)
        end
        task.wait(0.8); sg:Destroy()
    end)
    task.wait(3)
end

-- ============================================================================
-- // 3. CREATE WINDOW (WINDUI)
-- ============================================================================
local wSz  = IsMobile and UDim2.fromOffset(420, 320) or UDim2.fromOffset(580, 460)
local mnSz = IsMobile and Vector2.new(600, 300) or Vector2.new(600, 350)
local mxSz = IsMobile and Vector2.new(650, 400) or Vector2.new(850, 560)

local Window = WindUI:CreateWindow({
    Title                       = "King Akbar - Indo Hangout",
    Icon                        = "crown",
    Author                      = "King Akbar",
    Folder                      = "KingAkbarHub",
    Size                        = wSz,
    MinSize                     = mnSz,
    MaxSize                     = mxSz,
    Transparent                 = false,
    Background                  = "rbxassetid://127295801178451",
    BackgroundImageTransparency = 0.5,
    Theme                       = "Dark",
    Resizable                   = true,
    SideBarWidth                = 210,
    HideSearchBar               = false,
    ScrollBarEnabled            = true,
})

-- ============================================================================
-- // 4. TABS
-- ============================================================================
local MainTab = Window:Tab({ Title = "Main", Icon = "anchor", Border = true })
local AutomaticTab = Window:Tab({ Title = "Automatic", Icon = "shopping-cart", Border = true })
local SettingsTab = Window:Tab({ Title = "Settings", Icon = "settings", Border = true })

-- ============================================================================
-- // 5. CORE VARIABLES & LOGIC
-- ============================================================================
local RodEvent = Services.ReplicatedStorage:WaitForChild("Events"):WaitForChild("RemoteEvent"):WaitForChild("Rod")
local SellEvent = Services.ReplicatedStorage:WaitForChild("Events"):WaitForChild("RemoteFunction"):WaitForChild("SellFish")
local ReelingGui = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Reeling")

getgenv().AutoFishing = false
getgenv().AutoSell = false
getgenv().AutoSellInterval = 1 
getgenv().AntiAFK = false

local lagiNungguIkan = false
local sellTimer = 0
local antiAfkConnection = nil

-- FITUR 1: Aimbot Minigame (Target Ngikutin Merah)
pcall(function()
    Services.RunService:UnbindFromRenderStep("AimbotMancing")
end)

Services.RunService:BindToRenderStep("AimbotMancing", 2000, function()
    if getgenv().AutoFishing and ReelingGui.Enabled then
        local redBar = ReelingGui:FindFirstChild("RedBar", true)
        local whiteBar = ReelingGui:FindFirstChild("WhiteBar", true)
        
        if redBar and whiteBar then
            whiteBar.Position = redBar.Position
        end
    end
end)

-- FITUR 2: Smart Auto-Throw (Bypass Remote)
task.spawn(function()
    while task.wait(0.5) do
        if getgenv().AutoFishing then
            local character = LocalPlayer.Character
            local pegangPancingan = character and character:FindFirstChildOfClass("Tool")
            
            if not pegangPancingan then
                lagiNungguIkan = false
                continue
            end

            if ReelingGui.Enabled then
                lagiNungguIkan = false
            else
                if not lagiNungguIkan then
                    task.wait(1.5) 
                    RodEvent:FireServer("Equipped")
                    task.wait(0.2)
                    RodEvent:FireServer("Throw")
                    lagiNungguIkan = true 
                end
            end
        end
    end
end)

-- FITUR 3: Smart Auto-Sell (Sistem Timer per Menit)
task.spawn(function()
    while task.wait(1) do 
        if getgenv().AutoSell then
            sellTimer = sellTimer + 1
            local batasWaktu = getgenv().AutoSellInterval * 60 

            if sellTimer >= batasWaktu then
                sellTimer = 0 
                pcall(function()
                    SellEvent:InvokeServer("SellFish", "Sell All")
                end)
            end
        else
            sellTimer = 0 
        end
    end
end)

-- FITUR 4: Anti AFK Logic
local function ToggleAntiAFK(state)
    getgenv().AntiAFK = state
    
    if state then
        pcall(function()
            for _, v in pairs(getconnections(LocalPlayer.Idled)) do
                v:Disable()
            end
        end)
        
        if not antiAfkConnection then
            antiAfkConnection = LocalPlayer.Idled:Connect(function()
                if getgenv().AntiAFK then
                    Services.VirtualUser:CaptureController()
                    Services.VirtualUser:ClickButton2(Vector2.new())
                end
            end)
        end
    else
        pcall(function()
            for _, v in pairs(getconnections(LocalPlayer.Idled)) do
                v:Enable()
            end
        end)
        
        if antiAfkConnection then
            antiAfkConnection:Disconnect()
            antiAfkConnection = nil
        end
    end
end

-- ============================================================================
-- // 6. UI CONTENT (SECTIONS & TOGGLES)
-- ============================================================================

-- [ MAIN TAB ] --
local FishingSection = MainTab:Section({ Title = "Auto Fishing Settings" })

FishingSection:Toggle({
    Title    = "Auto Fishing (AFK)",
    Icon     = "zap",
    State    = false,
    Callback = function(state)
        getgenv().AutoFishing = state
    end
})

-- [ AUTOMATIC TAB ] --
local SellSection = AutomaticTab:Section({ Title = "Automatic Sell Settings" })

SellSection:Toggle({
    Title    = "Automatic Sell All",
    Icon     = "coins",
    State    = false,
    Callback = function(state)
        getgenv().AutoSell = state
        if state then
            sellTimer = 0 
        end
    end
})

SellSection:Input({
    Title    = "Interval Waktu (Menit)",
    Icon     = "clock",
    Value    = tostring(getgenv().AutoSellInterval),
    Placeholder = "Masukkan angka (menit)...",
    Callback = function(val)
        local angka = tonumber(val)
        if angka and angka > 0 then
            getgenv().AutoSellInterval = angka
            sellTimer = 0 
        end
    end
})

-- [ SETTINGS TAB ] --
local GeneralSection = SettingsTab:Section({ Title = "General Settings" })

GeneralSection:Toggle({
    Title    = "Anti AFK",
    Icon     = "shield",
    State    = false,
    Callback = function(state)
        ToggleAntiAFK(state)
    end
})

-- ============================================================================
-- // 7. OPEN BUTTON (KING AKBAR STYLE) & INIT
-- ============================================================================
Window:EditOpenButton({
    Title           = "Open King Akbar",
    Icon            = "crown",
    CornerRadius    = UDim.new(0, 12),
    StrokeThickness = 2,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("#ffffff")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("#0a0a0a")),
    }),
    Enabled   = true,
    Draggable = true,
})

Window:SetIconSize(47)
WindUI:SetTheme("dark")
MainTab:Select()
