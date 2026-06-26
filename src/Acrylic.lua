local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local Acrylic = {}

function Acrylic.EnableBlur()
    local dof = Lighting:FindFirstChild("LibuDOF")
    if not dof then
        dof = Instance.new("DepthOfFieldEffect")
        dof.Name = "LibuDOF"
        dof.FarIntensity = 0
        dof.InFocusRadius = 0.1
        dof.NearIntensity = 1
        dof.Parent = Lighting
    end
end

function Acrylic.CreateBlur(Frame)
    Acrylic.EnableBlur()

    local camera = Workspace.CurrentCamera
    local blurPart = Instance.new("Part")
    blurPart.Name = "LibuBlur"
    blurPart.Material = Enum.Material.Glass
    blurPart.Transparency = 0.98
    blurPart.Color = Color3.new(0, 0, 0)
    blurPart.Anchored = true
    blurPart.CanCollide = false
    blurPart.CanQuery = false
    blurPart.CanTouch = false
    blurPart.CastShadow = false
    blurPart.Parent = Workspace

    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.Brick
    mesh.Parent = blurPart

    local function updatePosition()
        if not Frame or not Frame.Parent or not blurPart.Parent then return end
        if not camera then camera = Workspace.CurrentCamera return end

        local size = Frame.AbsoluteSize
        local pos = Frame.AbsolutePosition

        local topLeft = camera:ScreenPointToRay(pos.X, pos.Y, 0.001)
        local bottomRight = camera:ScreenPointToRay(pos.X + size.X, pos.Y + size.Y, 0.001)

        local worldTopLeft = topLeft.Origin + topLeft.Direction
        local worldBottomRight = bottomRight.Origin + bottomRight.Direction

        local distance = (worldBottomRight - worldTopLeft).Magnitude
        blurPart.Size = Vector3.new(distance * (size.X / size.Y), distance, 0.01)
        blurPart.CFrame = CFrame.new((worldTopLeft + worldBottomRight) / 2, camera.CFrame.Position)
    end

    local connection = RunService.RenderStepped:Connect(updatePosition)
    
    Frame.Destroying:Connect(function()
        connection:Disconnect()
        blurPart:Destroy()
    end)
    
    return blurPart
end

return Acrylic
