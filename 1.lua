-- Удалим старый GUI, если есть
if game.Players.LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("CustomMenu") then
	game.Players.LocalPlayer.PlayerGui.CustomMenu:Destroy()
end

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "CustomMenu"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

local neonColor = Color3.fromRGB(0, 178, 255)
local darkColor = Color3.fromRGB(20, 20, 20)

-- Кнопка-значок
local icon = Instance.new("TextButton", gui)
icon.Size = UDim2.new(0, 50, 0, 50)
icon.Position = UDim2.new(1, -60, 0.5, -25)
icon.Text = "1"
icon.TextColor3 = neonColor
icon.BackgroundColor3 = darkColor
icon.BorderColor3 = neonColor
icon.Font = Enum.Font.GothamBlack
icon.TextScaled = true
Instance.new("UICorner", icon).CornerRadius = UDim.new(1, 0)

-- Главное меню
local menu = Instance.new("Frame", gui)
menu.Size = UDim2.new(0, 320, 0, 270)
menu.Position = icon.Position
menu.BackgroundColor3 = darkColor
menu.BackgroundTransparency = 0.15
menu.BorderColor3 = neonColor
menu.Visible = false
menu.Active = true
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 12)

-- Перетаскивание меню
local draggingMenu = false
local offsetMenu = Vector2.zero

menu.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		local mouse = input.Position
		local bar = menu:FindFirstChild("SpeedBar")
		if not (bar and mouse.X >= bar.AbsolutePosition.X and mouse.X <= bar.AbsolutePosition.X + bar.AbsoluteSize.X
			and mouse.Y >= bar.AbsolutePosition.Y and mouse.Y <= bar.AbsolutePosition.Y + bar.AbsoluteSize.Y) then
			draggingMenu = true
			offsetMenu = mouse - menu.AbsolutePosition
		end
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingMenu = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if draggingMenu and input.UserInputType == Enum.UserInputType.MouseMovement then
		menu.Position = UDim2.new(0, input.Position.X - offsetMenu.X, 0, input.Position.Y - offsetMenu.Y)
	end
end)

-- Перетаскивание значка
local draggingIcon = false
local offsetIcon = Vector2.zero

icon.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingIcon = true
		offsetIcon = input.Position - icon.AbsolutePosition
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingIcon = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if draggingIcon and input.UserInputType == Enum.UserInputType.MouseMovement then
		icon.Position = UDim2.new(0, input.Position.X - offsetIcon.X, 0, input.Position.Y - offsetIcon.Y)
	end
end)

-- Переключение
icon.MouseButton1Click:Connect(function()
	menu.Position = icon.Position
	icon.Visible = false
	menu.Visible = true
end)

local function makeButton(name, y)
	local btn = Instance.new("TextButton", menu)
	btn.Size = UDim2.new(1, -20, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.BorderColor3 = neonColor
	btn.Text = name .. ": OFF"
	btn.TextScaled = true
	btn.Font = Enum.Font.Gotham
	btn.TextColor3 = neonColor
	btn:SetAttribute("State", false)
	btn.MouseButton1Click:Connect(function()
		local newState = not btn:GetAttribute("State")
		btn:SetAttribute("State", newState)
		btn.Text = name .. ": " .. (newState and "ON" or "OFF")
	end)
	return btn
end

local infJumpBtn = makeButton("Infinite Jump", 10)
local godBtn = makeButton("God Mode", 50)

local speedLabel = Instance.new("TextLabel", menu)
speedLabel.Size = UDim2.new(1, -20, 0, 20)
speedLabel.Position = UDim2.new(0, 10, 0, 90)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: 16"
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextColor3 = neonColor

local speedInput = Instance.new("TextBox", menu)
speedInput.Size = UDim2.new(0, 60, 0, 25)
speedInput.Position = UDim2.new(0, 10, 0, 115)
speedInput.Text = "16"
speedInput.ClearTextOnFocus = false
speedInput.Font = Enum.Font.Gotham
speedInput.TextScaled = true
speedInput.TextColor3 = neonColor
speedInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
speedInput.BorderColor3 = neonColor

local bar = Instance.new("Frame", menu)
bar.Name = "SpeedBar"
bar.Size = UDim2.new(1, -90, 0, 10)
bar.Position = UDim2.new(0, 80, 0, 125)
bar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
bar.BorderColor3 = neonColor

local handle = Instance.new("Frame", bar)
handle.Size = UDim2.new(0.016, 0, 1, 0)
handle.BackgroundColor3 = neonColor
handle.BorderColor3 = neonColor
handle.Active = true

local function setSpeed(value)
	value = math.clamp(tonumber(value) or 16, 1, 999)
	speedLabel.Text = "Speed: " .. value
	speedInput.Text = tostring(value)
	local char = player.Character
	if char and char:FindFirstChild("Humanoid") then
		char.Humanoid.WalkSpeed = value
	end
	handle.Size = UDim2.new(value / 999, 0, 1, 0)
end

speedInput.FocusLost:Connect(function()
	setSpeed(speedInput.Text)
end)

bar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		local rel = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
		setSpeed(math.floor(1 + rel * 998))
	end
end)

local draggingHandle = false
handle.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then draggingHandle = true end
end)
handle.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then draggingHandle = false end
end)
UIS.InputChanged:Connect(function(i)
	if draggingHandle and i.UserInputType == Enum.UserInputType.MouseMovement then
		local rel = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
		setSpeed(math.floor(1 + rel * 998))
	end
end)

-- Кнопка закрытия
local close = Instance.new("TextButton", menu)
close.Size = UDim2.new(0, 25, 0, 25)
close.Position = UDim2.new(1, -30, 0, 5)
close.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
close.BorderColor3 = neonColor
close.Text = "X"
close.TextColor3 = neonColor
close.Font = Enum.Font.GothamBold
close.TextScaled = true
Instance.new("UICorner", close).CornerRadius = UDim.new(1, 0)
close.MouseButton1Click:Connect(function()
	menu.Visible = false
	icon.Position = menu.Position
	icon.Visible = true
end)

-- Инф. прыжок
UIS.JumpRequest:Connect(function()
	if infJumpBtn:GetAttribute("State") then
		local h = player.Character and player.Character:FindFirstChild("Humanoid")
		if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
	end
end)

-- Год-мод + защита от бездны
RS.Stepped:Connect(function()
	local char = player.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local root = char:FindFirstChild("HumanoidRootPart")
	if godBtn:GetAttribute("State") and hum then
		hum.Health = hum.MaxHealth
		hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
	end
	if root and root.Position.Y < workspace.FallenPartsDestroyHeight then
		root.CFrame = CFrame.new(0, 10, 0)
		if hum then hum.Health = hum.MaxHealth end
	end
end)

-- Установка стандартной скорости при спавне
player.CharacterAdded:Connect(function(c)
	c:WaitForChild("Humanoid").WalkSpeed = 16
end)
