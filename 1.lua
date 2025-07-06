local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "CheatMenu"
gui.ResetOnSpawn = false

local toggleButton = Instance.new("TextButton", gui)
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0, 10, 0.5, -25)
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
toggleButton.Text = "❤"
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextColor3 = Color3.new(0, 0, 0)
local corner = Instance.new("UICorner", toggleButton)
corner.CornerRadius = UDim.new(1, 0)

local menu = Instance.new("Frame", gui)
menu.Size = UDim2.new(0, 240, 0, 180)
menu.Position = UDim2.new(0, 70, 0.5, -90)
menu.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
menu.BorderColor3 = Color3.fromRGB(0, 0, 0)
menu.Visible = false
local menuCorner = Instance.new("UICorner", menu)
menuCorner.CornerRadius = UDim.new(0, 12)

local resizeHandle = Instance.new("Frame", menu)
resizeHandle.Size = UDim2.new(0, 20, 0, 20)
resizeHandle.AnchorPoint = Vector2.new(1, 1)
resizeHandle.Position = UDim2.new(1, 0, 1, 0)
resizeHandle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
resizeHandle.BorderColor3 = Color3.fromRGB(100, 100, 100)
Instance.new("UICorner", resizeHandle).CornerRadius = UDim.new(1, 0)

local function makeToggle(name, y)
	local b = Instance.new("TextButton", menu)
	b.Name = name
	b.Size = UDim2.new(1, -20, 0, 30)
	b.Position = UDim2.new(0, 10, 0, y)
	b.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
	b.BorderColor3 = Color3.fromRGB(0, 0, 0)
	b.Text = name .. ": OFF"
	b.TextScaled = true
	b.Font = Enum.Font.Gotham
	b.TextColor3 = Color3.new(0, 0, 0)
	b:SetAttribute("State", false)
	b.MouseButton1Click:Connect(function()
		local s = not b:GetAttribute("State")
		b:SetAttribute("State", s)
		b.Text = name .. ": " .. (s and "ON" or "OFF")
	end)
	return b
end

local infJumpBtn = makeToggle("InfiniteJump", 10)
local invBtn = makeToggle("Invincibility", 50)

local speedLabel = Instance.new("TextLabel", menu)
speedLabel.Size = UDim2.new(1, -20, 0, 20)
speedLabel.Position = UDim2.new(0, 10, 0, 90)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: 16"
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextColor3 = Color3.new(0, 0, 0)

local bar = Instance.new("Frame", menu)
bar.Size = UDim2.new(1, -40, 0, 10)
bar.Position = UDim2.new(0, 20, 0, 120)
bar.BackgroundColor3 = Color3.fromRGB(210, 210, 210)
bar.BorderColor3 = Color3.fromRGB(0, 0, 0)

local handle = Instance.new("Frame", bar)
handle.Size = UDim2.new(0, 1, 1, 0)
handle.BackgroundColor3 = Color3.new(1, 1, 1)
handle.BorderColor3 = Color3.fromRGB(0, 0, 0)
handle.Active = true

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
		handle.Size = UDim2.new(rel, 0, 1, 0)
		local sp = math.floor(1 + rel * 499)
		speedLabel.Text = "Speed: " .. sp
		local char = player.Character
		if char and char:FindFirstChild("Humanoid") then
			char.Humanoid.WalkSpeed = sp
		end
	end
end)

toggleButton.MouseButton1Click:Connect(function()
	menu.Visible = not menu.Visible
end)

player.CharacterAdded:Connect(function(c)
	c:WaitForChild("Humanoid").WalkSpeed = 16
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
		if h then h.Health = h.MaxHealth end
	end
end)

local function makeDraggable(frame)
	local dragToggle, dragInput, startPos, dragStart = nil, nil, nil, nil
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragToggle = true
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragToggle = false end
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement and dragToggle then
			local delta = input.Position - dragStart
			frame.Position = startPos + UDim2.new(0, delta.X, 0, delta.Y)
		end
	end)
end

makeDraggable(menu)
makeDraggable(toggleButton)

resizeHandle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		local startSize = menu.Size
		local startPos = input.Position
		local con
		con = UserInputService.InputChanged:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseMovement then
				local diff = i.Position - startPos
				menu.Size = UDim2.new(0, math.max(150, startSize.X.Offset + diff.X), 0, math.max(100, startSize.Y.Offset + diff.Y))
			end
		end)
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				if con then con:Disconnect() end
			end
		end)
	end
end)
