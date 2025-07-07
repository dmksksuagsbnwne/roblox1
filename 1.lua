local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TS = game:GetService("TeleportService")
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "CustomMenu"; gui.IgnoreGuiInset = true; gui.ResetOnSpawn = false

local neonColor = Color3.fromRGB(0,178,255)
local darkColor = Color3.fromRGB(20,20,20)

local function center(w,h)
	local vp = workspace.CurrentCamera.ViewportSize
	return UDim2.new(0,(vp.X-w)/2,0,(vp.Y-h)/2)
end

local settings = {
	speed = 16,
	speedEnabled = true,
	infJump = false,
	god = false,
	noclip = false,
}

local joinData = TS:GetTeleportData()
if type(joinData)=="table" then
	for k,v in pairs(joinData) do settings[k]=v end
end

local icon = Instance.new("TextButton",gui)
icon.Size=UDim2.new(0,50,0,50)
icon.Position=UDim2.new(1,-60,0.5,-25)
icon.AutoButtonColor=true; icon.Text="1"; icon.Font=Enum.Font.GothamBold
icon.TextScaled=true; icon.TextColor3=neonColor
icon.BackgroundColor3=Color3.new(1,1,1); icon.BorderColor3=Color3.new(0,0,0)
Instance.new("UICorner",icon).CornerRadius=UDim.new(1,0)

local menu = Instance.new("Frame",gui)
menu.Size=UDim2.new(0,340,0,370)
menu.Position=center(340,370)
menu.BackgroundColor3=darkColor; menu.BackgroundTransparency=0.25
menu.BorderColor3=neonColor; menu.Visible=false; menu.Active=true
Instance.new("UICorner",menu).CornerRadius=UDim.new(0,12)

local title=Instance.new("TextLabel",menu)
title.Size=UDim2.new(1,-20,0,35); title.Position=UDim2.new(0,10,0,10)
title.BackgroundTransparency=1; title.Text="Custom Menu"
title.TextColor3=neonColor; title.Font=Enum.Font.GothamBold
title.TextScaled=true; title.TextXAlignment=Enum.TextXAlignment.Left

local closeBtn=Instance.new("TextButton",menu)
closeBtn.Size=UDim2.new(0,28,0,28); closeBtn.Position=UDim2.new(1,-38,0,10)
closeBtn.Text="X"; closeBtn.BackgroundColor3=Color3.fromRGB(40,40,40)
closeBtn.TextColor3=neonColor; closeBtn.Font=Enum.Font.GothamBold
closeBtn.TextScaled=true; closeBtn.BorderColor3=neonColor
Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(1,0)

local function makeToggle(name,y,key)
	local btn=Instance.new("TextButton",menu)
	btn.Size=UDim2.new(1,-20,0,35); btn.Position=UDim2.new(0,10,0,y)
	btn.BackgroundColor3=Color3.fromRGB(30,30,30); btn.BorderColor3=neonColor
	btn.Text=name..": "..(settings[key] and "ON" or "OFF")
	btn.Font=Enum.Font.Gotham; btn.TextColor3=neonColor; btn.TextScaled=true
	btn.AutoButtonColor=false
	btn.MouseButton1Click:Connect(function()
		settings[key] = not settings[key]
		btn.Text = name..": "..(settings[key] and "ON" or "OFF")
	end)
	return btn
end

local infBtn = makeToggle("Infinite Jump",60,"infJump")
local godBtn = makeToggle("God Mode",100,"god")
local noclipBtn = makeToggle("Noclip",140,"noclip")
local speedBtn = makeToggle("Enable Speed",180,"speedEnabled")

local speedLabel=Instance.new("TextLabel",menu)
speedLabel.Size=UDim2.new(1,-20,0,25); speedLabel.Position=UDim2.new(0,10,0,220)
speedLabel.BackgroundTransparency=1; speedLabel.TextColor3=neonColor
speedLabel.Font=Enum.Font.Gotham; speedLabel.TextScaled=true
speedLabel.TextXAlignment=Enum.TextXAlignment.Left

local speedInput=Instance.new("TextBox",menu)
speedInput.Size=UDim2.new(0,60,0,30); speedInput.Position=UDim2.new(0,10,0,250)
speedInput.BackgroundColor3=Color3.fromRGB(30,30,30); speedInput.TextColor3=neonColor
speedInput.Font=Enum.Font.Gotham; speedInput.TextScaled=true
speedInput.ClearTextOnFocus=false; speedInput.BorderColor3=neonColor

local bar=Instance.new("Frame",menu)
bar.Name="SpeedBar"; bar.Size=UDim2.new(1,-90,0,20); bar.Position=UDim2.new(0,80,0,260)
bar.BackgroundColor3=Color3.fromRGB(40,40,40); bar.BorderColor3=neonColor
Instance.new("UICorner",bar).CornerRadius=UDim.new(0,10)

local handle=Instance.new("Frame",bar)
handle.Size=UDim2.new(settings.speed/250,0,1,0)
handle.BackgroundColor3=neonColor; handle.BorderColor3=neonColor; handle.Active=true
Instance.new("UICorner",handle).CornerRadius=UDim.new(0,10)

local function setSpeed(val)
	val=math.clamp(tonumber(val) or settings.speed,1,250)
	settings.speed=val
	speedLabel.Text="Speed: "..val
	speedInput.Text=tostring(val)
	handle.Size=UDim2.new(val/250,0,1,0)
	if settings.speedEnabled then
		local h=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
		if h then h.WalkSpeed=val end
	end
end

speedInput.FocusLost:Connect(function() setSpeed(speedInput.Text) end)
bar.InputBegan:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then
		local rel=(i.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X
		setSpeed(1+math.floor( (rel>1 and 1 or rel<0 and 0 or rel)*(250-1) ))
	end
end)

local draggingSlider=false
handle.InputBegan:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then draggingSlider=true end
end)
handle.InputEnded:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then draggingSlider=false end
end)
UIS.InputChanged:Connect(function(i)
	if draggingSlider then
		local rel=(i.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X
		setSpeed(1+math.floor( (rel>1 and 1 or rel<0 and 0 or rel)*(250-1) ))
	end
end)

icon.MouseButton1Click:Connect(function()
	menu.Position=center(340,370); menu.Visible=true; icon.Visible=false
end)
closeBtn.MouseButton1Click:Connect(function()
	menu.Visible=false; icon.Position=UDim2.new(1,-60,0.5,-25); icon.Visible=true
end)

UIS.JumpRequest:Connect(function()
	if settings.infJump then
		local h=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
		if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
	end
end)

RS.Stepped:Connect(function()
	local char=player.Character
	if not char then return end
	local h=char:FindFirstChildOfClass("Humanoid")
	local root=char:FindFirstChild("HumanoidRootPart")

	if settings.god and h then
		h.Health=h.MaxHealth; h:SetStateEnabled(Enum.HumanoidStateType.Dead,false)
	end

	if root and root.Position.Y<workspace.FallenPartsDestroyHeight then
		root.CFrame=CFrame.new(0,10,0); if h then h.Health=h.MaxHealth end
	end

	if settings.noclip then
		for _,p in pairs(char:GetDescendants()) do
			if p:IsA("BasePart") then p.CanCollide=false end
		end
	else
		for _,p in pairs(char:GetDescendants()) do
			if p:IsA("BasePart") then p.CanCollide=true end
		end
	end

	local h2=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	if h2 and settings.speedEnabled then h2.WalkSpeed=settings.speed end
end)

player.CharacterAdded:Connect(function(c)
	c:WaitForChild("Humanoid").WalkSpeed=settings.speed
end)

local function save()
	TS:SetTeleportData(settings)
end

closeBtn.MouseButton1Click:Connect(save)
icon.MouseButton1Click:Connect(save)
game:BindToClose(save)

setSpeed(settings.speed)
