local toolbar = plugin:CreateToolbar("Roblox Package Manager")
local open = toolbar:CreateButton("Open Package Manager", "Open the Package Manager GUI", "rbxassetid://4458901886")
open.ClickableWhenViewportHidden = true

-- Create new "DockWidgetPluginGuiInfo" object
local widgetInfo = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Float,  -- Widget will be initialized in floating panel
	true,   -- Widget will be initially enabled
	false,  -- Don't override the previous enabled state
	400,    -- Default width of the floating window
	300,    -- Default height of the floating window
	250,    -- Minimum width of the floating window
	250     -- Minimum height of the floating window
)
 
-- Create new widget GUI
local pmGui = plugin:CreateDockWidgetPluginGui("RBLXPM", widgetInfo)
pmGui.Title = "Roblox Package Manager"  
pmGui.Enabled = true

local background = Instance.new("ScrollingFrame")
background.AnchorPoint = Vector2.new(0.5, 0.5)
background.Size = UDim2.new(1,0,1,0)
background.Position = UDim2.new(0.5,0,0.5,0)
background.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainBackground)
background.Parent = pmGui
background.ScrollBarThickness = 2.5

open.Click:Connect(function()
   

end)

