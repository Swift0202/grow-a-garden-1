local ESP_LUA_URL    = "https://api.luarmor.net/files/v3/loaders/d8824b23a4d9f2e0d62b4e69397d206b.lua"
local FULL_LUA_URL   = "https://raw.githubusercontent.com/Swift0202/grow-a-garden-1/refs/heads/main/coed.lua"
local GITHUB_KEY_URL = "https://raw.githubusercontent.com/Swift0202/grow-a-garden-1/refs/heads/main/key.lua"
local PLAYER_LIST_URL = "https://raw.githubusercontent.com/Swift0202/grow-a-garden-1/refs/heads/main/playyer.lua"

local HttpService = game:GetService("HttpService")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SeeYouUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local function makeFrame(props)
    local f = Instance.new("Frame")
    f.Size = props.Size
    f.Position = props.Position
    f.BackgroundTransparency = props.BackgroundTransparency or 0
    f.Parent = props.Parent
    f.LayoutOrder = props.LayoutOrder or 0

    local grad = Instance.new("UIGradient", f)
    grad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, props.GradientFrom),
        ColorSequenceKeypoint.new(1, props.GradientTo),
    }
    grad.Rotation = props.GradientRotation or 90

    local corner = Instance.new("UICorner", f)
    corner.CornerRadius = UDim.new(0, 16)
    local stroke = Instance.new("UIStroke", f)
    stroke.Thickness = 2
    stroke.Color = props.StrokeColor or Color3.fromRGB(255,255,255)
    stroke.Transparency = 0.7

    return f
end

local function makeButton(text, parent, posY, colorFrom, colorTo, callback)
    local btn = makeFrame{
        Size             = UDim2.new(0, 240, 0, 50),
        Position         = UDim2.new(0.5, -120, posY, 0),
        Parent           = parent,
        GradientFrom     = colorFrom,
        GradientTo       = colorTo,
        StrokeColor      = Color3.fromRGB(255,255,255),
        GradientRotation = 0,
    }
    btn.Name = text:gsub(" ", "") .. "Btn"

    local click = Instance.new("TextButton", btn)
    click.Size = UDim2.new(1, 0, 1, 0)
    click.BackgroundTransparency = 1
    click.Text = text
    click.Font = Enum.Font.GothamSemibold
    click.TextSize = 20
    click.TextColor3 = Color3.fromRGB(255,255,255)
    click.AutoButtonColor = false
    click.MouseEnter:Connect(function()
        btn.UIStroke.Transparency = 0.3
    end)
    click.MouseLeave:Connect(function()
        btn.UIStroke.Transparency = 0.7
    end)
    click.MouseButton1Click:Connect(callback)

    return btn
end

local mainFrame = makeFrame{
    Size         = UDim2.new(0, 400, 0, 380),
    Position     = UDim2.new(0.5, -200, 0.5, -190),
    Parent       = screenGui,
    GradientFrom = Color3.fromRGB(40, 40, 40),
    GradientTo   = Color3.fromRGB(30, 30, 30),
    StrokeColor  = Color3.fromRGB(200,200,200),
    BackgroundTransparency = 0.3
}

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, -40, 0, 50)
title.Position = UDim2.new(0, 20, 0, 20)
title.BackgroundTransparency = 1
title.Text = "💣 Swift Shop"
title.Font = Enum.Font.GothamBlack
title.TextSize = 28
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextXAlignment = Enum.TextXAlignment.Left

local keyBox = makeFrame{
    Size            = UDim2.new(1, -40, 0, 50),
    Position        = UDim2.new(0, 20, 0, 90),
    Parent          = mainFrame,
    GradientFrom    = Color3.fromRGB(60,60,60),
    GradientTo      = Color3.fromRGB(50,50,50),
    StrokeColor     = Color3.fromRGB(180,180,180),
}
local input = Instance.new("TextBox", keyBox)
input.Size = UDim2.new(1, -20, 1, -10)
input.Position = UDim2.new(0, 10, 0, 5)
input.BackgroundTransparency = 1
input.Text = "กรุณากรอก Key"
input.PlaceholderText = ""
input.ClearTextOnFocus = true
input.Font = Enum.Font.Gotham
input.TextSize = 20
input.TextColor3 = Color3.fromRGB(230,230,230)

local feedbackLabel = Instance.new("TextLabel", mainFrame)
feedbackLabel.Size = UDim2.new(1, -40, 0, 30)
feedbackLabel.Position = UDim2.new(0, 20, 0, 300)
feedbackLabel.BackgroundTransparency = 1
feedbackLabel.Text = ""
feedbackLabel.Font = Enum.Font.Gotham
feedbackLabel.TextSize = 18
feedbackLabel.TextColor3 = Color3.fromRGB(255,100,100)
feedbackLabel.TextXAlignment = Enum.TextXAlignment.Center

local function safeLoad(url)
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    if success and result then
        local loadedFunc, loadError = loadstring(result)
        if loadedFunc then
            local runSuccess, runError = pcall(loadedFunc)
            if not runSuccess then
                warn("Error while running script from:", url, runError)
            end
        else
            warn("Error while compiling script from:", url, loadError)
        end
    else
        warn("Error while fetching script from:", url, result)
    end
end

local function checkKey()
    local key = input.Text
    if key == "" or key == "กรุณากรอก Key" then
        feedbackLabel.TextColor3 = Color3.fromRGB(255,100,100)
        feedbackLabel.Text = "กรุณากรอก Key ก่อน"
        return
    end

    -- ดึง Key
    local okKey, dataKey = pcall(function()
        return game:HttpGet(GITHUB_KEY_URL)
    end)
    if not okKey then
        feedbackLabel.TextColor3 = Color3.fromRGB(255,100,100)
        feedbackLabel.Text = "ไม่สามารถเชื่อมต่อ GitHub สำหรับ Key"
        return
    end

    -- ดึง Player List
    local okPlayer, dataPlayer = pcall(function()
        return game:HttpGet(PLAYER_LIST_URL)
    end)
    if not okPlayer then
        feedbackLabel.TextColor3 = Color3.fromRGB(255,100,100)
        feedbackLabel.Text = "ไม่สามารถเชื่อมต่อ GitHub สำหรับรายชื่อผู้เล่น"
        return
    end

    -- เช็ก Key
    local keyFound = false
    for line in dataKey:gmatch("[^\r\n]+") do
        if line == key then
            keyFound = true
            break
        end
    end

    -- เช็กชื่อผู้เล่น
    local playerFound = false
    local playerName = game.Players.LocalPlayer.Name
    for line in dataPlayer:gmatch("[^\r\n]+") do
        if line == playerName then
            playerFound = true
            break
        end
    end

    -- ถ้าทั้ง Key และ Player ถูกต้อง
    if keyFound and playerFound then
        feedbackLabel.TextColor3 = Color3.fromRGB(100,255,100)
        feedbackLabel.Text = "✔️ Key และ ชื่อผู้เล่น ถูกต้อง! กำลังโหลด..."
        task.wait(1)

        -- โหลดและรันแบบปลอดภัย
        task.spawn(function()
            safeLoad(FULL_LUA_URL)
            task.wait(0.5)
            safeLoad(ESP_LUA_URL)
        end)

        -- ปิด UI
        task.wait(0.5)
        if screenGui then
            screenGui:Destroy()
        end
    else
        feedbackLabel.TextColor3 = Color3.fromRGB(255,100,100)
        if not keyFound and not playerFound then
            feedbackLabel.Text = "❌ Key และ ชื่อผู้เล่น ไม่ถูกต้อง"
        elseif not keyFound then
            feedbackLabel.Text = "❌ Key ไม่ถูกต้อง"
        else
            feedbackLabel.Text = "❌ ไม่พบชื่อผู้เล่นในระบบ"
        end
    end
end

makeButton("📝 ตรวจสอบ Key", mainFrame, 0.45, Color3.fromRGB(85,170,255), Color3.fromRGB(75,150,235), checkKey)
makeButton("❌ ปิดโปรแกรม",   mainFrame, 0.65, Color3.fromRGB(255,85,85),   Color3.fromRGB(235,75,75), function()
    screenGui:Destroy()
    print("โปรแกรมถูกปิดแล้ว")
end)
