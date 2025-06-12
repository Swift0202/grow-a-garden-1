--== Global Player Setup ==--
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Net = require(ReplicatedStorage.Modules.Core.Net)

local player = Players.LocalPlayer
local character, hrp, humanoid
local isUnderground = false
local isDestroyed = false
local originalY = nil
local fakeCharacter = nil
local supportPart = nil
local undergroundOffset = -10

local function setupCharacter()
	character = player.Character or player.CharacterAdded:Wait()
	character:WaitForChild("HumanoidRootPart")
	character:WaitForChild("Humanoid")
	hrp = character:FindFirstChild("HumanoidRootPart")
	humanoid = character:FindFirstChild("Humanoid")
end

setupCharacter()
player.CharacterAdded:Connect(setupCharacter)


--== Enhanced ESP + FOV UI (Refined UI) ==--

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- GUI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "ESP_FOV_UI"

local container = Instance.new("Frame", gui)
container.Size = UDim2.new(0, 320, 0, 260)
container.Position = UDim2.new(0, 30, 0.35, 0)
container.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
container.BackgroundTransparency = 0.3
container.BorderSizePixel = 0
container.Active = true
container.Draggable = true

local uicorner = Instance.new("UICorner", container)
uicorner.CornerRadius = UDim.new(0, 10)


-- เพิ่มหัวข้อ Swift Shop (🎮) อยู่ตรงกลางบนของ container ด้วยสีแดงและพื้นหลังโปร่งใสมากขึ้น
local headerLabel = Instance.new("TextLabel")
headerLabel.Size = UDim2.new(1, 0, 0, 30)
headerLabel.BackgroundTransparency = 1
headerLabel.Text = "🎮 Swift Shop"
headerLabel.Font = Enum.Font.GothamBold
headerLabel.TextSize = 22
headerLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
headerLabel.TextStrokeTransparency = 0.6
headerLabel.TextXAlignment = Enum.TextXAlignment.Center
headerLabel.LayoutOrder = -999
headerLabel.Parent = container

local layout = Instance.new("UIListLayout", container)
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.FillDirection = Enum.FillDirection.Vertical
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top

-- Create Toggle Section
local function createToggleSection(labelText, defaultState, onToggle)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(0.95, 0, 0, 40)
    section.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", section)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Text = labelText
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.TextColor3 = Color3.fromRGB(230, 230, 235)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left

    local button = Instance.new("TextButton", section)
    button.Size = UDim2.new(0, 60, 0, 26)
    button.Position = UDim2.new(1, -65, 0.5, -13)
    button.Text = defaultState and "ON" or "OFF"
    button.Font = Enum.Font.GothamSemibold
    button.TextSize = 14
    button.TextColor3 = defaultState and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 165)
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 50)

    local btnCorner = Instance.new("UICorner", button)
    btnCorner.CornerRadius = UDim.new(0, 6)

    button.MouseButton1Click:Connect(function()
        defaultState = not defaultState
        button.Text = defaultState and "ON" or "OFF"
        button.TextColor3 = defaultState and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 165)
        onToggle(defaultState)
    end)

    section.Parent = container
    return section
end

-- ESP Logic
local espEnabled = false
local espConnections = {}

local function createESP(player)
    if player == LocalPlayer then return end
    if player.Character and player.Character:FindFirstChild("Head") then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP"
        billboard.Adornee = player.Character.Head
        billboard.Size = UDim2.new(0, 100, 0, 40)
        billboard.StudsOffset = Vector3.new(0, 2, 0)
        billboard.AlwaysOnTop = true

        local label = Instance.new("TextLabel", billboard)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = player.Name
        label.TextColor3 = Color3.fromRGB(255, 255, 0)
        label.TextStrokeTransparency = 0.5
        label.TextScaled = true
        label.Font = Enum.Font.GothamSemibold

        billboard.Parent = player.Character

        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_HIGHLIGHT"
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.new(1, 1, 1)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Adornee = player.Character
        highlight.Parent = player.Character
    end
end

local function removeESP(player)
    if player.Character then
        for _, v in ipairs(player.Character:GetDescendants()) do
            if v:IsA("BillboardGui") and v.Name == "ESP" then
                v:Destroy()
            elseif v:IsA("Highlight") and v.Name == "ESP_HIGHLIGHT" then
                v:Destroy()
            end
        end
    end
end


-- Separator


createToggleSection("ESP", espEnabled, function(state)
    espEnabled = state
    if espEnabled then
        for _, plr in ipairs(Players:GetPlayers()) do
            createESP(plr)
        end
        table.insert(espConnections, Players.PlayerAdded:Connect(function(plr)
            plr.CharacterAdded:Connect(function()
                if espEnabled then createESP(plr) end
            end)
        end))
        table.insert(espConnections, Players.PlayerRemoving:Connect(function(plr)
            removeESP(plr)
        end))
    else
        for _, plr in ipairs(Players:GetPlayers()) do
            removeESP(plr)
        end
        for _, conn in ipairs(espConnections) do
            if conn then conn:Disconnect() end
        end
        table.clear(espConnections)
    end
end)

-- FOV UI will remain in original structure but could be added here

-- Delete Key: Reset and close UI
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.Delete then
        for _, plr in ipairs(Players:GetPlayers()) do
            removeESP(plr)
        end
        for _, conn in ipairs(espConnections) do
            if conn then conn:Disconnect() end
        end
        table.clear(espConnections)
        gui:Destroy()
    end
end)


-- FOV Logic
local fovEnabled = false
local fovRadius = 150
local blockCheckEnabled = true

-- Create FOV Section

-- Separator


wait()

local sep_esp_fov = Instance.new("Frame", container)
sep_esp_fov.Size = UDim2.new(0.9, 0, 0, 1)
sep_esp_fov.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sep_esp_fov.BackgroundTransparency = 0.4
sep_esp_fov.BorderSizePixel = 0

local fovSpacer = Instance.new("Frame", container)
fovSpacer.Size = UDim2.new(1, 0, 0, 10)
fovSpacer.BackgroundTransparency = 1

local fovSection = Instance.new("Frame")
fovSection.Size = UDim2.new(0.95, 0, 0, 70)
fovSection.BackgroundTransparency = 1
fovSection.Parent = container

local fovLabel = Instance.new("TextLabel", fovSection)
fovLabel.Size = UDim2.new(1, 0, 0, 20)
fovLabel.Text = "FOV Aimbot"
fovLabel.Font = Enum.Font.GothamBold
fovLabel.TextSize = 18
fovLabel.TextColor3 = Color3.fromRGB(230, 230, 235)
fovLabel.BackgroundTransparency = 1
fovLabel.TextXAlignment = Enum.TextXAlignment.Left

local fovValue = Instance.new("TextLabel", fovSection)
fovValue.Position = UDim2.new(0, 0, 0, 25)
fovValue.Size = UDim2.new(1, 0, 0, 20)
fovValue.Text = "Size: " .. fovRadius
fovValue.Font = Enum.Font.Gotham
fovValue.TextSize = 14
fovValue.TextColor3 = Color3.fromRGB(140, 140, 145)
fovValue.BackgroundTransparency = 1
fovValue.TextXAlignment = Enum.TextXAlignment.Left

local plusBtn = Instance.new("TextButton", fovSection)
plusBtn.Size = UDim2.new(0, 24, 0, 24)
plusBtn.Position = UDim2.new(1, -95, 0, 0)
plusBtn.Text = "+"
plusBtn.Font = Enum.Font.GothamBold
plusBtn.TextSize = 14
plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
plusBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(1, 0)

local minusBtn = Instance.new("TextButton", fovSection)
minusBtn.Size = UDim2.new(0, 24, 0, 24)
minusBtn.Position = UDim2.new(1, -125, 0, 0)
minusBtn.Text = "-"
minusBtn.Font = Enum.Font.GothamBold
minusBtn.TextSize = 14
minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minusBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(1, 0)

plusBtn.MouseButton1Click:Connect(function()
    fovRadius = math.clamp(fovRadius + 10, 10, 500)
    fovValue.Text = "Size: " .. fovRadius
end)

minusBtn.MouseButton1Click:Connect(function()
    fovRadius = math.clamp(fovRadius - 10, 10, 500)
    fovValue.Text = "Size: " .. fovRadius
end)




local fovToggle = Instance.new("TextButton", fovSection)
fovToggle.Size = UDim2.new(0, 60, 0, 24)
fovToggle.Position = UDim2.new(1, -65, 0, 0)
fovToggle.Text = "OFF"
fovToggle.Font = Enum.Font.GothamSemibold
fovToggle.TextSize = 14
fovToggle.TextColor3 = Color3.fromRGB(160, 160, 165)
fovToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
Instance.new("UICorner", fovToggle).CornerRadius = UDim.new(0, 6)

fovToggle.MouseButton1Click:Connect(function()
    fovEnabled = not fovEnabled
    fovToggle.Text = fovEnabled and "ON" or "OFF"
    fovToggle.TextColor3 = fovEnabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 165)
end)



local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Color = Color3.fromRGB(0, 255, 0)
fovCircle.Thickness = 1
fovCircle.NumSides = 64
fovCircle.Filled = false

RunService.RenderStepped:Connect(function()
    local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    fovCircle.Position = center
    fovCircle.Radius = fovRadius
    fovCircle.Visible = fovEnabled
end)


-- Lock Target if enabled
local function getClosestTargetInFOV()
    local closest = nil
    local shortestDist = math.huge
    local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local headPos = head.Position
            local dist3D = (headPos - camera.CFrame.Position).Magnitude
            if dist3D <= 200 then
                local screenPoint, onScreen = camera:WorldToViewportPoint(headPos)
                if onScreen then
                    local origin = camera.CFrame.Position
                    local direction = (headPos - origin)
                    local raycastParams = RaycastParams.new()
                    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
                    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                    if blockCheckEnabled then
                        local result = workspace:Raycast(origin, direction, raycastParams)
                        if result and not result.Instance:IsDescendantOf(player.Character) then
                            continue
                        end
                    end
                    local dist2D = (Vector2.new(screenPoint.X, screenPoint.Y) - center).Magnitude
                    if dist2D <= fovRadius and dist2D < shortestDist then
                        shortestDist = dist2D
                        closest = head
                    end
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if fovEnabled then
        local target = getClosestTargetInFOV()
        if target then
            local camPos = camera.CFrame.Position
            camera.CFrame = CFrame.lookAt(camPos, target.Position)
        end
    end
end)


local sep = Instance.new("Frame")
sep.Size = UDim2.new(0.9, 0, 0, 1)
sep.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sep.BackgroundTransparency = 0.4
sep.BorderSizePixel = 0
sep.Parent = container

-- มุดดิน UI
local mudSection = Instance.new("Frame")
mudSection.Size = UDim2.new(0.95, 0, 0, 35)
mudSection.BackgroundTransparency = 1
mudSection.Parent = container

local mudLabel = Instance.new("TextLabel", mudSection)
mudLabel.Size = UDim2.new(0.7, 0, 1, 0)
mudLabel.Text = "Underground"
mudLabel.Font = Enum.Font.GothamBold
mudLabel.TextSize = 18
mudLabel.TextColor3 = Color3.fromRGB(230, 230, 235)
mudLabel.BackgroundTransparency = 1
mudLabel.TextXAlignment = Enum.TextXAlignment.Left

local mudButton = Instance.new("TextButton", mudSection)
mudButton.Size = UDim2.new(0, 60, 0, 26)
mudButton.Position = UDim2.new(1, -65, 0.5, -13)
mudButton.Text = "GO"
mudButton.Font = Enum.Font.GothamSemibold
mudButton.TextSize = 14
mudButton.TextColor3 = Color3.fromRGB(255, 255, 255)
mudButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
Instance.new("UICorner", mudButton).CornerRadius = UDim.new(0, 6)

-- Logic for มุดดิน (Underground)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Net = require(ReplicatedStorage.Modules.Core.Net)
local isUnderground = false
local fakeCharacter, supportPart, originalY
local function setupCharacter()
	character = player.Character or player.CharacterAdded:Wait()
	character:WaitForChild("HumanoidRootPart")
	character:WaitForChild("Humanoid")
	hrp = character:FindFirstChild("HumanoidRootPart")
	humanoid = character:FindFirstChild("Humanoid")
end
setupCharacter()
player.CharacterAdded:Connect(setupCharacter)

local function goUnderground()
	if not character or not hrp or not humanoid then setupCharacter() end
	if isUnderground then return end
	originalY = hrp.Position.Y
	fakeCharacter = character:Clone()
	if fakeCharacter then
		fakeCharacter.Name = "Fake_" .. character.Name
		for _, part in pairs(fakeCharacter:GetDescendants()) do
			if part:IsA("BasePart") then
				part.Anchored = true
				part.CanCollide = true
			elseif part:IsA("Script") or part:IsA("LocalScript") then
				part:Destroy()
			end
		end
		fakeCharacter.Parent = workspace
	end
	Net.send("apply_ragdoll", {
		name = "underground_escape",
		priority = 999,
		target_torque = 0,
		dont_eject_from_car = true
	})
	task.wait(0.05)
	humanoid:ChangeState(Enum.HumanoidStateType.Physics)
	hrp.Anchored = true
	local newPos = hrp.Position + Vector3.new(5, -10, 0)
	hrp.CFrame = CFrame.new(newPos)
	hrp.CanCollide = false
	supportPart = Instance.new("Part")
	supportPart.Size = Vector3.new(500, 2, 500)
	supportPart.Position = Vector3.new(newPos.X, newPos.Y - 2, newPos.Z)
	supportPart.Anchored = true
	supportPart.Transparency = 1
	supportPart.CanCollide = true
	supportPart.Name = "UndergroundSupport"
	supportPart.Parent = workspace
	task.wait(0.1)
	hrp.Anchored = false
	humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
	isUnderground = true
end

local function comeBackAbove()
	if not character or not hrp or not humanoid or not originalY then return end
	Net.send("clear_ragdoll")
	task.wait(0.05)
	humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	hrp.Anchored = false
	hrp.CanCollide = true
	hrp.CFrame = CFrame.new(Vector3.new(hrp.Position.X, originalY, hrp.Position.Z))
	if fakeCharacter then fakeCharacter:Destroy() end
	if supportPart then supportPart:Destroy() end
	isUnderground = false
end

mudButton.MouseButton1Click:Connect(function()
	if isUnderground then
		comeBackAbove()
	else
		goUnderground()
	end
end)



--== Underground Functionality from HAloo.lua ==--
-- LocalScript: SafeUndergroundBypass.lua

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Net = require(ReplicatedStorage.Modules.Core.Net)

local player = Players.LocalPlayer
local character, hrp, humanoid
local isUnderground = false
local isDestroyed = false
local originalY = nil
local fakeCharacter = nil
local supportPart = nil
local undergroundOffset = -10 -- ความลึกที่มุด

-- อัปเดตข้อมูลตัวละคร
local function setupCharacter()
	character = player.Character or player.CharacterAdded:Wait()
	character:WaitForChild("HumanoidRootPart")
	character:WaitForChild("Humanoid")
	hrp = character:FindFirstChild("HumanoidRootPart")
	humanoid = character:FindFirstChild("Humanoid")
end

setupCharacter()
player.CharacterAdded:Connect(setupCharacter)

-- ฟังก์ชันมุดดิน
local function goUnderground()
	if not character or not hrp or not humanoid then
		setupCharacter()
		repeat task.wait() until character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid")
		hrp = character:FindFirstChild("HumanoidRootPart")
		humanoid = character:FindFirstChild("Humanoid")
		if not hrp or not humanoid then return end
	end
	if isUnderground then return end

	originalY = hrp.Position.Y

	-- Clone ตัวละครเพื่อหลอกเซิร์ฟเวอร์
	fakeCharacter = character:Clone()
	if fakeCharacter then
		fakeCharacter.Name = "Fake_" .. (character.Name or "Unknown")
		for _, part in pairs(fakeCharacter:GetDescendants()) do
			if part:IsA("BasePart") then
				part.Anchored = true
				part.CanCollide = true
			elseif part:IsA("Script") or part:IsA("LocalScript") then
				part:Destroy()
			end
		end
		fakeCharacter.Parent = workspace
	end

	-- ขอ ragdoll ฝั่งเซิร์ฟเวอร์
	Net.send("apply_ragdoll", {
		name = "underground_escape",
		priority = 999,
		target_torque = 0,
		dont_eject_from_car = true
	})

	task.wait(0.05)
	humanoid:ChangeState(Enum.HumanoidStateType.Physics)
	hrp.Anchored = true

	-- ขยับไปด้านข้างเพื่อไม่ให้หัวทะลุพื้นแมพ
	local offsetPos = Vector3.new(5, undergroundOffset, 0)
	local newPos = hrp.Position + offsetPos
	hrp.CFrame = CFrame.new(newPos)
	hrp.CanCollide = false

	-- สร้างพื้นหลอกขนาดใหญ่ใต้ตัว
	supportPart = Instance.new("Part")
	supportPart.Size = Vector3.new(500, 2, 500)
	supportPart.Position = Vector3.new(newPos.X, newPos.Y - 2, newPos.Z)
	supportPart.Anchored = true
	supportPart.Transparency = 1
	supportPart.CanCollide = true
	supportPart.Name = "UndergroundSupport"
	supportPart.Parent = workspace

	task.wait(0.1)
	hrp.Anchored = false
	humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)

	isUnderground = true
	warn("[UndergroundBypass] มุดดินแล้ว")
end

-- กลับขึ้นดิน
local function comeBackAbove()
	if not character or not hrp or not humanoid then return end
	if not originalY then return end

	Net.send("clear_ragdoll")
	task.wait(0.05)

	humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	hrp.Anchored = false
	hrp.CanCollide = true

	local current = hrp.Position
	local newPos = Vector3.new(current.X, originalY, current.Z)
	hrp.CFrame = CFrame.new(newPos)

	if fakeCharacter and fakeCharacter.Parent then
		fakeCharacter:Destroy()
	end
	fakeCharacter = nil

	if supportPart and supportPart.Parent then
		supportPart:Destroy()
	end
	supportPart = nil

	isUnderground = false
	warn("[UndergroundBypass] กลับขึ้นพื้นแล้ว")
end

-- ปิดสคริปต์ถาวร
local function destroyScript()
	isDestroyed = true
	Net.send("clear_ragdoll")
	if fakeCharacter and fakeCharacter.Parent then
		fakeCharacter:Destroy()
	end
	if supportPart and supportPart.Parent then
		supportPart:Destroy()
	end
	warn("[UndergroundBypass] ปิดสคริปต์ถาวรแล้ว")
	local scr = script
	task.delay(0.5, function()
		scr:Destroy()
	end)
end

-- ควบคุมด้วยปุ่ม
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed or isDestroyed then return end

	if input.KeyCode == Enum.KeyCode.B then
		if isUnderground then
			comeBackAbove()
		else
			goUnderground()
		end
	elseif input.KeyCode == Enum.KeyCode.Delete then
		destroyScript()
	end
end)


-- ปุ่มเล็กควบคุม UI ทั้งหมด
local toggleImageBtn = Instance.new("ImageButton", gui)
toggleImageBtn.Size = UDim2.new(0, 30, 0, 30)
toggleImageBtn.Position = UDim2.new(0, 20, 0, 20)
toggleImageBtn.Image = "rbxassetid://91158140886557"
toggleImageBtn.BackgroundTransparency = 1
toggleImageBtn.ImageTransparency = 0
toggleImageBtn.BorderSizePixel = 2
toggleImageBtn.BorderColor3 = Color3.fromRGB(0, 0, 0)

local corner = Instance.new("UICorner", toggleImageBtn)
corner.CornerRadius = UDim.new(0, 6)

-- สลับแสดง/ซ่อน container หลัก (โดยที่ icon ไม่ถูกซ่อน)
local uiVisible = true
local function toggleUI()
    uiVisible = not uiVisible
    container.Visible = uiVisible
end
toggleImageBtn.MouseButton1Click:Connect(toggleUI)
