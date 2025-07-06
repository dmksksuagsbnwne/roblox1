local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local toggleButton = Instance.new("TextButton", gui)
toggleButton.Size = UDim2.new(0,50,0,50)
toggleButton.Position = UDim2.new(0,0,0.5,-25)
toggleButton.BackgroundColor3 = Color3.new(1,1,1)
toggleButton.BorderColor3 = Color3.new(0,0,0)
toggleButton.Text = "❤"
toggleButton.TextScaled = true
local corner = Instance.new("UICorner", toggleButton)
corner.CornerRadius = UDim.new(1,0)
local menu = Instance.new("Frame", gui)
menu.Size = UDim2.new(0,200,0,160)
menu.Position = UDim2.new(0,60,0.5,-80)
menu.BackgroundColor3 = Color3.new(1,1,1)
menu.BorderColor3 = Color3.new(0,0,0)
menu.Visible = false
local function makeToggle(name,y)
	local b=Instance.new("TextButton",menu)
	b.Name=name
	b.Size=UDim2.new(1,-20,0,30)
	b.Position=UDim2.new(0,10,0,y)
	b.BackgroundColor3=Color3.new(0.9,0.9,0.9)
	b.BorderColor3=Color3.new(0,0,0)
	b.Text=name..": OFF"
	b.TextScaled=true
	b:SetAttribute("State",false)
	b.MouseButton1Click:Connect(function()
		local s=not b:GetAttribute("State")
		b:SetAttribute("State",s)
		b.Text=name..": "..(s and "ON" or "OFF")
	end)
	return b
end
local infJumpBtn = makeToggle("InfiniteJump",10)
local invBtn = makeToggle("Invincibility",50)
local speedLabel = Instance.new("TextLabel",menu)
speedLabel.Size = UDim2.new(1,-20,0,20)
speedLabel.Position = UDim2.new(0,10,0,90)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: 16"
speedLabel.TextScaled = true
local bar = Instance.new("Frame",menu)
bar.Size = UDim2.new(1,-40,0,10)
bar.Position = UDim2.new(0,20,0,120)
bar.BackgroundColor3 = Color3.new(0.8,0.8,0.8)
bar.BorderColor3 = Color3.new(0,0,0)
local handle = Instance.new("Frame",bar)
handle.Size = UDim2.new(0,1,1,0)
handle.BackgroundColor3 = Color3.new(1,1,1)
handle.BorderColor3 = Color3.new(0,0,0)
handle.Active = true
local dragging=false
handle.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true end end)
handle.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)
UserInputService.InputChanged:Connect(function(i)
	if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then
		local rel=math.clamp((i.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
		handle.Size=UDim2.new(rel,0,1,0)
		local sp=math.floor(1+rel*499)
		speedLabel.Text="Speed: "..sp
		local c=player.Character
		if c and c:FindFirstChild("Humanoid") then c.Humanoid.WalkSpeed=sp end
	end
end)
toggleButton.MouseButton1Click:Connect(function() menu.Visible = not menu.Visible end)
player.CharacterAdded:Connect(function(c) c:WaitForChild("Humanoid").WalkSpeed=16 end)
UserInputService.JumpRequest:Connect(function()
	if infJumpBtn:GetAttribute("State") then
		local h=player.Character and player.Character:FindFirstChild("Humanoid")
		if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
	end
end)
RunService.Stepped:Connect(function()
	if invBtn:GetAttribute("State") then
		local h=player.Character and player.Character:FindFirstChild("Humanoid")
		if h then h.Health=h.MaxHealth end
	end
end)
