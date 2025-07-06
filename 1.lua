local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "CustomMenu"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local RunService = RS

local neonColor = Color3.fromRGB(0, 178, 255)
local darkColor = Color3.fromRGB(20, 20, 20)
local darkTransp = 0.2

-- Создаём значок (кружок справа по середине экрана)
local icon = Instance.new("TextButton", gui)
icon.Name = "MenuIcon"
icon.Size = UDim2.new(0, 50, 0, 50)
icon.Position = UDim2.new(1, -60, 0.5, -25)
icon.AnchorPoint = Vector2.new(0, 0)
icon.BackgroundColor3 = Color3.new(1, 1, 1)
icon.BackgroundTransparency = 0
icon.BorderSizePixel = 2
icon.BorderColor3 = Color3.new(0, 0, 0)
icon.Text = "1"
icon.TextColor3 = neonColor
icon.Font = Enum.Font.GothamBlack
icon.TextScaled = true
icon.AutoButtonColor = false
local iconCorner = Instance.new("UICorner", icon)
iconCorner.CornerRadius = UDim.new(1, 0)

-- Главное меню (с прозрачным тёмным фоном)
local menu = Instance.new("Frame", gui)
menu.Name = "MainMenu"
menu.Size = UDim2.new(0, 320, 0, 270)
menu.AnchorPoint = Vector2.new(0, 0)
menu.Position = UDim2.new(0.5, -160, 0.5, -135) -- центр экрана
menu.BackgroundColor3 = darkColor
menu.BackgroundTransparency = darkTransp
menu.BorderColor3 = neonColor
menu.Visible = false
menu.Active = true
local menuCorner = Instance.new("UICorner", menu)
menuCorner.CornerRadius = UDim.new(0, 12)

-- Заголовок меню
local title = Instance.new("TextLabel", menu)
title.Size = UDim2.new(1, -20, 0, 35)
title.Position = UDim2.new(0, 10, 0, 10)
title.BackgroundTransparency = 1
title.Text = "Custom Menu"
title.TextColor3 = neonColor
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left

-- Кнопка закрытия (X)
local closeBtn = Instance.new("TextButton", menu)
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -38, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
closeBtn.BorderColor3 = neonColor
closeBtn.Text = "X"
closeBtn.TextColor3 = neonColor
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextScaled = true
local closeCorner = Instance.new("UICorner", closeBtn)
closeCorner.CornerRadius = UDim.new(1, 0)

closeBtn.MouseButton1Click:Connect(function()
	menu.Visible = false
	icon.Position = menu.Position + UDim2.new(0, menu.Size.X.Offset + 10, 0, 10)
	icon.Visible = true
end)

icon.MouseButton1Click:Connect(function()
	menu.Position = icon.Position - UDim2.new(0, menu.Size.X.Offset + 10, 0, 10)
	menu.Visible = true
	icon.Visible = false
end)

-- Helper функция для создания переключателей
local function createToggle(text, y)
	local btn = Instance.new("TextButton", menu)
	btn.Size = UDim2.new(1, -20, 0, 35)
	btn.Position = UDim2.new(0, 10, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	btn.BorderColor3 = neonColor
	btn.Text = text .. ": OFF"
	btn.Font = Enum.Font.Gotham
	btn.TextColor3 = neonColor
	btn.TextScaled = true
	btn.AutoButtonColor = false
	btn:SetAttribute("State", false)
	
	btn.MouseButton1Click:Connect(function()
		local state = not btn:GetAttribute("State")
		btn:SetAttribute("State", state)
		btn.Text = text .. ": " .. (state and "ON" or "OFF")
	end)
	
	return btn
end

local infJumpBtn = createToggle("Infinite Jump", 60)
local godModeBtn = createToggle("God Mode", 110)

-- Label для скорости
local speedLabel = Instance.new("TextLabel", menu)
speedLabel.Size = UDim2.new(1, -20, 0, 25)
speedLabel.Position = UDim2.new(0, 10, 0, 160)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: 16"
speedLabel.TextColor3 = neonColor
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextScaled = true
speedLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Текстбокс для ввода скорости
local speedInput = Instance.new("TextBox", menu)
speedInput.Size = UDim2.new(0, 60, 0, 30)
speedInput.Position = UDim2.new(0, 10, 0, 190)
speedInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
speedInput.BorderColor3 = neonColor
speedInput.TextColor3 = neonColor
speedInput.Font = Enum.Font.Gotham
speedInput.TextScaled = true
speedInput.ClearTextOnFocus = false
speedInput.Text = "16"

-- Ползунок скорости
local speedBar = Instance.new("Frame", menu)
speedBar.Name = "SpeedBar"
speedBar.Size = UDim2.new(1, -90, 0, 15)
speedBar.Position = UDim2.new(0, 80, 0, 200)
speedBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
speedBar.BorderColor3 = neonColor
local speedBarCorner = Instance.new("UICorner", speedBar)
speedBarCorner.CornerRadius = UDim.new(0, 8)

local handle = Instance.new("Frame", speedBar)
handle.Size = UDim2.new(16/999, 1, 1, 0)
handle.BackgroundColor3 = neonColor
handle.BorderColor3 = neonColor
handle.Active = true
local handleCorner = Instance.new("UICorner", handle)
handleCorner.CornerRadius = UDim.new(0, 8)

-- Устанавливает скорость и обновляет UI
local function setSpeed(val)
	val = tonumber(val)
	if not val then return end
	val = math.clamp(val, 1, 999)
	speedLabel.Text = "Speed: " .. val
	speedInput.Text = tostring(val)
	handle.Size = UDim2.new(val/999, 0, 1, 0)
	
	local char = player.Character
	if char and char:FindFirstChild("Humanoid") then
		char.Humanoid.WalkSpeed = val
	end
end

-- Обработка клика по полосе скорости
speedBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		local relativeX = input.Position.X - speedBar.AbsolutePosition.X
		local relativePos = math.clamp(relativeX / speedBar.AbsoluteSize.X, 0, 1)
		setSpeed(math.floor(1 + relativePos * 998))
	end
end)

-- Обработка перетаскивания ручки
local draggingHandle = false
handle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingHandle = true
	end
end)
handle.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingHandle = false
	end
end)
UIS.InputChanged:Connect(function(input)
	if draggingHandle and input.UserInputType == Enum.UserInputType.MouseMovement then
		local relativeX = input.Position.X - speedBar.AbsolutePosition.X
		local relativePos = math.clamp(relativeX / speedBar.AbsoluteSize.X, 0, 1)
		setSpeed(math.floor(1 + relativePos * 998))
	end
end)

speedInput.FocusLost:Connect(function()
	setSpeed(speedInput.Text)
end)

-- Защита от падения в бездну
RunService.Stepped:Connect(function()
	local char = player.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local root = char:FindFirstChild("HumanoidRootPart")
	if godModeBtn:GetAttribute("State") and hum then
		hum.Health = hum.MaxHealth
		hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
	end
	if root and root.Position.Y < workspace.FallenPartsDestroyHeight then
		root.CFrame = CFrame.new(0, 10, 0)
		if hum then hum.Health = hum.MaxHealth end
	end
end)

-- Бесконечный прыжок
UIS.JumpRequest:Connect(function()
	if infJumpBtn:GetAttribute("State") then
		local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
		if h then
			h:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
end)

-- Инициализация скорости при респауне
player.CharacterAdded:Connect(function(c)
	c:WaitForChild("Humanoid").WalkSpeed = 16
end)

setSpeed(16)

-- Функция перетаскивания GUI
local function makeDraggable(frame, ignoreObjects)
	ignoreObjects = ignoreObjects or {}

	local dragging = false
	local dragStartPos = Vector2.new()
	local startPos = UDim2.new()

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			local mousePos = input.Position
			-- Проверка, что клик не по игнорируемым элементам (например, по ползунку)
			for _, obj in pairs(ignoreObjects) do
				local absPos = obj.AbsolutePosition
				local absSize = obj.AbsoluteSize
				if mousePos.X >= absPos.X and mousePos.X <= absPos.X + absSize.X and
				   mousePos.Y >= absPos.Y and mousePos.Y <= absPos.Y + absSize.Y then
					return
				end
			end
			dragging = true
			dragStartPos = mousePos
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStartPos
			frame.Position = UDim2.new(
				startPos.X.Scale,
				math.clamp(startPos.X.Offset + delta.X, 0, workspace.CurrentCamera.ViewportSize.X - frame.AbsoluteSize.X),
				startPos.Y.Scale,
				math.clamp(startPos.Y.Offset + delta.Y, 0, workspace.CurrentCamera.ViewportSize.Y - frame.AbsoluteSize.Y)
			)
		end
	end)
end

-- Делаем меню перетаскиваемым, игнорируя ползунок скорости
makeDraggable(menu, {speedBar})

-- Делаем значок перетаскиваемым (без исключений)
makeDraggable(icon)
