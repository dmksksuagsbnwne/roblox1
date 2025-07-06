local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "CustomMenu"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

-- НЕОНОВАЯ ТЕМА
local neonColor = Color3.fromRGB(0, 178, 255)
local darkColor = Color3.fromRGB(20, 20, 20)
local darkTransp = 0.25

-- ПОЛОЖЕНИЕ ПО ЦЕНТРУ
local function centerPosition(width, height)
	local vp = workspace.CurrentCamera.ViewportSize
	return UDim2.new(0, (vp.X - width) / 2, 0, (vp.Y - height) / 2)
end

-- ЗНАЧОК
local icon = Instance.new("TextButton", gui)
icon.Size = UDim2.new(0, 50, 0, 50)
icon.Position = UDim2.new(1, -60, 0.5, -25)
icon.BackgroundColor3 = Color3.new(1,1,1)
icon.Text = "1"
icon.TextColor3 = Color3.new(0,0,0)
icon.Font = Enum.Font.GothamBold
icon.TextScaled = true
icon.BorderColor3 = Color3.new(0,0,0)
Instance.new("UICorner", icon).CornerRadius = UDim.new(1, 0)

-- МЕНЮ
local menu = Instance.new("Frame", gui)
menu.Size = UDim2.new(0, 320, 0, 270)
menu.Position = centerPosition(320, 270)
menu.BackgroundColor3 = darkColor
menu.BackgroundTransparency = darkTransp
menu.BorderColor3 = neonColor
menu.Visible = false
menu.Active = true
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 12)

-- ЗАГОЛОВОК
local title = Instance.new("TextLabel", menu)
title.Size = UDim2.new(1, -20, 0, 35)
title.Position = UDim2.new(0, 10, 0, 10)
title.BackgroundTransparency = 1
title.Text = "Custom Menu"
title.TextColor3 = neonColor
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left

-- КНОПКА ЗАКРЫТЬ
local closeBtn = Instance.new("TextButton", menu)
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -38, 0, 10)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
closeBtn.TextColor3 = neonColor
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextScaled = true
closeBtn.BorderColor3 = neonColor
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

-- ПЕРЕКЛЮЧАТЕЛИ
local function createToggle(text, y)
	local btn = Instance.new("TextButton", menu)
	btn.Size = UDim2.new(1, -20, 0, 35)
	btn.Position = UDim2.new(0, 10, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
	btn.BorderColor3 = neonColor
	btn.Text = text..": OFF"
	btn.Font = Enum.Font.Gotham
	btn.TextColor3 = neonColor
	btn.TextScaled = true
	btn.AutoButtonColor = false
	btn:SetAttribute("State", false)
	btn.MouseButton1Click:Connect(function()
		local state = not btn:GetAttribute("State")
		btn:SetAttribute("State", state)
		btn.Text = text..": "..(state and "ON" or "OFF")
	end)
	return btn
end

local infJumpBtn = createToggle("Infinite Jump", 60)
local godBtn = createToggle("God Mode", 110)

-- СКОРОСТЬ
local speedLabel = Instance.new("TextLabel", menu)
speedLabel.Size = UDim2.new(1, -20, 0, 25)
speedLabel.Position = UDim2.new(0, 10, 0, 160)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = neonColor
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextScaled = true
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Text = "Speed: 16"

local speedInput = Instance.new("TextBox", menu)
speedInput.Size = UDim2.new(0, 60, 0, 30)
speedInput.Position = UDim2.new(0, 10, 0, 190)
speedInput.BackgroundColor3 = Color3.fromRGB(30,30,30)
speedInput.TextColor3 = neonColor
speedInput.Font = Enum.Font.Gotham
speedInput.TextScaled = true
speedInput.ClearTextOnFocus = false
speedInput.Text = "16"
speedInput.BorderColor3 = neonColor

local speedBar = Instance.new("Frame", menu)
speedBar.Size = UDim2.new(1, -90, 0, 15)
speedBar.Position = UDim2.new(0, 80, 0, 200)
speedBar.BackgroundColor3 = Color3.fromRGB(40,40,40)
speedBar.BorderColor3 = neonColor
Instance.new("UICorner", speedBar).CornerRadius = UDim.new(0, 8)

local handle = Instance.new("Frame", speedBar)
handle.Size = UDim2.new(16/999, 0, 1, 0)
handle.BackgroundColor3 = neonColor
handle.BorderColor3 = neonColor
handle.Active = true
Instance.new("UICorner", handle).CornerRadius = UDim.new(0, 8)

-- СКОРОСТЬ УСТАНОВКА
local function setSpeed(val)
	val = tonumber(val)
	if not val then return end
	val = math.clamp(val, 1, 999)
	speedLabel.Text = "Speed: " .. val
	speedInput.Text = tostring(val)
	handle.Size = UDim2.new(val/999, 0, 1, 0)
	local h = player.Character and player.Character:FindFirstChild("Humanoid")
	if h then h.WalkSpeed = val end
end

speedInput.FocusLost:Connect(function()
	setSpeed(speedInput.Text)
end)

local draggingSlider = false
speedBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingSlider = true
	end
end)
speedBar.InputEnded:Connect(function() draggingSlider = false end)

UIS.InputChanged:Connect(function(input)
	if draggingSlider then
		local pos = input.Position.X - speedBar.AbsolutePosition.X
		local ratio = math.clamp(pos / speedBar.AbsoluteSize.X, 0, 1)
		setSpeed(math.floor(1 + ratio * 998))
	end
end)

-- ИКОНКА -> МЕНЮ
icon.MouseButton1Click:Connect(function()
	menu.Position = centerPosition(320, 270)
	menu.Visible = true
	icon.Visible = false
end)

-- МЕНЮ -> ИКОНКА
closeBtn.MouseButton1Click:Connect(function()
	menu.Visible = false
	icon.Position = UDim2.new(1, -60, 0.5, -25)
	icon.Visible = true
end)

-- БЕСКОНЕЧНЫЙ ПРЫЖОК
UIS.JumpRequest:Connect(function()
	if infJumpBtn:GetAttribute("State") then
		local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
		if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
	end
end)

-- ЗАЩИТА
RS.Stepped:Connect(function()
	local char = player.Character
	if not char then return end
	local h = char:FindFirstChildOfClass("Humanoid")
	local root = char:FindFirstChild("HumanoidRootPart")
	if h and godBtn:GetAttribute("State") then
		h.Health = h.MaxHealth
		h:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
	end
	if root and root.Position.Y < workspace.FallenPartsDestroyHeight then
		root.CFrame = CFrame.new(0, 10, 0)
		if h then h.Health = h.MaxHealth end
	end
end)

player.CharacterAdded:Connect(function(c)
	c:WaitForChild("Humanoid").WalkSpeed = 16
end)

setSpeed(16)

-- ПЕРЕТАСКИВАНИЕ (работает и с пальцем, и с мышью)
local function makeDraggable(frame, ignore)
	local dragging = false
	local dragStart, startPos

	local function isInIgnored(pos)
		for _, obj in pairs(ignore or {}) do
			local abs = obj.AbsolutePosition
			local size = obj.AbsoluteSize
			if pos.X >= abs.X and pos.X <= abs.X + size.X and pos.Y >= abs.Y and pos.Y <= abs.Y + size.Y then
				return true
			end
		end
		return false
	end

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			if not isInIgnored(input.Position) then
				dragging = true
				dragStart = input.Position
				startPos = frame.Position
			end
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

makeDraggable(menu, {speedBar})
makeDraggable(icon)
