local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local neonColor = Color3.fromRGB(0, 178, 255)

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "CustomMenu"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

local toggleButton = Instance.new("TextButton", gui)
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(1, -60, 0.5, -25)
toggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleButton.BorderColor3 = neonColor
toggleButton.Text = "1"
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.GothamBlack
toggleButton.TextColor3 = neonColor
toggleButton.Name = "ToggleButton"
Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(1, 0)

local menu = Instance.new("Frame", gui)
menu.Size = UDim2.new(0, 300, 0, 230)
menu.Position = toggleButton.Position
menu.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
menu.BackgroundTransparency = 0.25
menu.BorderColor3 = neonColor
menu.Visible = false
menu.Name = "MainMenu"
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 12)

local function makeToggle(name, y)
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

local infJumpBtn = makeToggle("Infinite Jump", 10)
local invBtn = makeToggle("God Mode", 50)

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
bar.Size = UDim2.new(1, -90, 0, 10)
bar.Position = UDim2.new(0, 80, 0, 125)
bar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
bar.BorderColor3 = neonColor

local handle = Instance.new("Frame", bar)
handle.Size = UDim2.new(0, 1, 1, 0)
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

local dragging = false
handle.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
end)
handle.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

UserInputService.InputChanged:Connect(function(i)
	if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
		local rel = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
		setSpeed(math.floor(1 + rel * 998))
	end
end)

toggleButton.MouseButton1Click:Connect(function()
	menu.Position = toggleButton.Position
	menu.Visible = true
	toggleButton.Visible = false
end)

local function makeDraggable(frame)
	local dragging, dragInput, dragStart, startPos
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			frame.Position = startPos + UDim2.new(0, delta.X, 0, delta.Y)
		end
	end)
end

makeDraggable(menu)
makeDraggable(toggleButton)

local closeButton = Instance.new("TextButton", menu)
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
closeButton.BorderColor3 = neonColor
closeButton.Text = "X"
closeButton.TextColor3 = neonColor
closeButton.Font = Enum.Font.GothamBold
closeButton.TextScaled = true
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(1, 0)
closeButton.MouseButton1Click:Connect(function()
	menu.Visible = false
	toggleButton.Position = menu.Position
	toggleButton.Visible = true
end)

UserInputService.JumpRequest:Connect(function()
	if infJumpBtn:GetAttribute("State") then
		local h = player.Character and player.Character:FindFirstChild("Humanoid")
		if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
	end
end)

RunService.Stepped:Connect(function()
	if invBtn:GetAttribute("State") then
		local h = player.Character and player.Character:FindFirstChild("Humanoid")
		if h then
			h.Health = h.MaxHealth
			h:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
			if h.Health <= 0 then h.Health = h.MaxHealth end
		end
	end
	local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if root and root.Position.Y < workspace.FallenPartsDestroyHeight then
		local h = player.Character:FindFirstChild("Humanoid")
		if h then
			h.Health = h.MaxHealth
			root.CFrame = CFrame.new(0, 10, 0)
		end
	end
end)

player.CharacterAdded:Connect(function(c)
	c:WaitForChild("Humanoid").WalkSpeed = 16
end)
