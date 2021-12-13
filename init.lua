local wait, spawn, delay
do
  local _obj_0 = task
  wait, spawn, delay = _obj_0.wait, _obj_0.spawn, _obj_0.delay
end
local RunService = game:GetService('RunService')
local HttpService = game:GetService('HttpService')
local GUID
GUID = function()
  return HttpService:GenerateGUID(false)
end
local V3 = Vector3.new
local V2 = Vector2.new
local V3V2
V3V2 = function(V)
  return V2(V.X, V.Y)
end
local W2S = workspace.CurrentCamera.WorldToViewportPoint
local MUTEX = SHOW_MUTEX or { }
getgenv().SHOW_MUTEX = MUTEX
local Visual
do
  local _class_0
  local _base_0 = {
    startRenderLoop = function(self)
      if self.Rendering then
        return 
      end
      if not (self.update) then
        return 
      end
      self.Rendering = true
      self.GUID = GUID()
      return RunService:BindToRenderStep(self.GUID, 199, function()
        return self:update()
      end)
    end,
    stopRenderLoop = function(self)
      if not (self.Rendering) then
        return 
      end
      self.Rendering = false
      return RunService:UnbindFromRenderStep(self.GUID)
    end,
    expire = function(self, Time)
      return delay(Time, function()
        return self:Destroy()
      end)
    end,
    setVisible = function(self, Visible)
      if Visible == nil then
        Visible = true
      end
      if Visible then
        self:startRenderLoop()
      else
        self:stopRenderLoop()
      end
      return self:visible(Visible)
    end,
    openMutex = function(self)
      do
        local Mutex = self.Options.mutex
        if Mutex then
          do
            local Old = MUTEX[Mutex]
            if Old then
              Old:Destroy()
            end
          end
          MUTEX[Mutex] = self
        end
      end
    end,
    closeMutex = function(self)
      do
        local Mutex = self.Options.mutex
        if Mutex then
          MUTEX[Mutex] = nil
        end
      end
    end,
    Destroy = function(self)
      if self.Dead then
        return 
      end
      self.Dead = true
      self:closeMutex()
      self:stopRenderLoop()
      return self:destroy()
    end,
    destroy = function(self) end,
    visible = function(self) end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, ...)
      self.Camera = workspace.CurrentCamera
      if self.init then
        self:init(...)
      end
      self.Options = self.Options or { }
      self:openMutex()
      return self:startRenderLoop()
    end,
    __base = _base_0,
    __name = "Visual"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Visual = _class_0
end
local rad, sin, cos, atan2, pi
do
  local _obj_0 = math
  rad, sin, cos, atan2, pi = _obj_0.rad, _obj_0.sin, _obj_0.cos, _obj_0.atan2, _obj_0.pi
end
local angle
angle = function(dir, ang)
  ang = rad(ang)
  return V2((cos(ang) * dir.X - sin(ang) * dir.Y), sin(ang) * dir.X + cos(ang) * dir.Y)
end
local Correct = (CFrame.Angles(0, (rad(89.9)), 0)):vectorToWorldSpace(V3(0, 0, -1 / 10))
do
  local _class_0
  local _parent_0 = Visual
  local _base_0 = {
    init = function(self, Ray, Options)
      if Options == nil then
        Options = { }
      end
      self.Options = Options
      self.Origin = Ray.Origin
      self.Termination = self.Origin + Ray.Direction
      local color = self.Options.color or Color3.new(1, 1, 1)
      local opacity = self.Options.opacity or 1
      do
        local _with_0 = Drawing.new('Line')
        _with_0.Thickness = 1
        _with_0.Transparency = opacity
        _with_0.Color = color
        _with_0.Visible = true
        self.Line = _with_0
      end
      if self.Options.showOrigin or self.Options.advanced then
        do
          local _with_0 = Drawing.new('Circle')
          _with_0.NumSides = 14
          _with_0.Radius = 5
          _with_0.Thickness = 1
          _with_0.Transparency = opacity
          _with_0.Filled = false
          _with_0.Visible = true
          _with_0.Color = color
          self.Circle = _with_0
        end
      end
      if self.Options.showTermination or self.Options.advanced then
        self.Arrows = { }
        for i = 1, 2 do
          table.insert(self.Arrows, (function()
            do
              local _with_0 = Drawing.new('Line')
              _with_0.Thickness = 1
              _with_0.Transparency = opacity
              _with_0.Visible = true
              _with_0.Color = color
              return _with_0
            end
          end)())
        end
      end
    end,
    setRay = function(self, Ray)
      self.Origin = Ray.Origin
      self.Termination = self.Origin + Ray.Direction
    end,
    update = function(self)
      local C = self.Camera
      local Origin3, OriginVisible = W2S(C, self.Origin)
      if Origin3.Z < 0 then
        local OPos = C.CFrame:pointToObjectSpace(self.Origin)
        local AT = pi + atan2(OPos.Y, OPos.X)
        OPos = CFrame.Angles(0, 0, AT):vectorToWorldSpace(Correct)
        Origin3 = W2S(C, C.CFrame:pointToWorldSpace(OPos))
      end
      local Origin2 = V3V2(Origin3)
      local Termination3, TerminationVisible = W2S(C, self.Termination)
      if Termination3.Z < 0 then
        local OPos = C.CFrame:pointToObjectSpace(self.Termination)
        local AT = pi + atan2(OPos.Y, OPos.X)
        OPos = CFrame.Angles(0, 0, AT):vectorToWorldSpace(Correct)
        Termination3 = W2S(C, C.CFrame:pointToWorldSpace(OPos))
      end
      local Termination2 = V3V2(Termination3)
      do
        local _with_0 = self.Line
        _with_0.To = Origin2
        _with_0.From = Termination2
      end
      if self.Circle then
        do
          local _with_0 = self.Circle
          _with_0.Visible = OriginVisible
          if OriginVisible then
            _with_0.Position = Origin2
          end
        end
      end
      if self.Arrows then
        local Dir = (Termination2 - Origin2).unit * 10
        local _list_0 = self.Arrows
        for _index_0 = 1, #_list_0 do
          local A = _list_0[_index_0]
          do
            A.Visible = TerminationVisible
            if TerminationVisible then
              A.From = Termination2
            end
          end
        end
        if TerminationVisible then
          self.Arrows[1].To = Termination2 - angle(Dir, 20)
          self.Arrows[2].To = Termination2 - angle(Dir, -20)
        end
      end
    end,
    visible = function(self, Visible)
      if not (Visible) then
        self.Line.Visible = false
        if self.Circle then
          self.Circle.Visible = false
        end
        if self.Arrows then
          local _list_0 = self.Arrows
          for _index_0 = 1, #_list_0 do
            local A = _list_0[_index_0]
            A.Visible = false
          end
        end
      end
    end,
    destroy = function(self)
      self.Line:Remove()
      if self.Circle then
        self.Circle:Remove()
      end
      if self.Arrows then
        local _list_0 = self.Arrows
        for _index_0 = 1, #_list_0 do
          local A = _list_0[_index_0]
          A:Remove()
        end
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "Ray",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Visual.Ray = _class_0
end
do
  local _class_0
  local _parent_0 = Visual
  local _base_0 = {
    init = function(self, Point, Options)
      if Options == nil then
        Options = { }
      end
      self.Point, self.Options = Point, Options
      local color = self.Options.color or Color3.new(1, 1, 1)
      local opacity = self.Options.opacity or 1
      self.Radius = self.Options.radius or 5
      local Diameter = self.Radius * 2
      self.Shape = (self.Options.box and 'Square') or 'Circle'
      do
        local _with_0 = Drawing.new(self.Shape)
        _with_0.Thickness = 1
        _with_0.Transparency = opacity
        _with_0.Color = color
        _with_0.Visible = true
        _with_0.Filled = false
        if self.Shape == 'Circle' then
          _with_0.Radius = self.Radius
        else
          _with_0.Size = V2(Diameter, Diameter)
          self.Offset = V2(self.Radius, self.Radius)
        end
        self.Object = _with_0
      end
      return self:move()
    end,
    update = false,
    visible = function(self, Visible)
      self.Object.Visible = Visible
    end,
    move = function(self)
      if self.Shape == 'Circle' then
        self.Object.Position = self.Point
      else
        self.Object.Position = self.Point - self.Offset
      end
    end,
    setPosition = function(self, Point)
      self.Point = Point
      return self:move()
    end,
    destroy = function(self)
      return self.Object:Remove()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "Vector2",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Visual.Vector2 = _class_0
end
do
  local _class_0
  local _parent_0 = Visual.Vector2
  local _base_0 = {
    move = function(self) end,
    update = function(self)
      local C = self.Camera
      local Point3, PointVisible = W2S(C, self.Point)
      do
        local _with_0 = self.Object
        _with_0.Visible = PointVisible
        if PointVisible then
          local Point2 = V3V2(Point3)
          if self.Shape == 'Circle' then
            _with_0.Position = Point2
          else
            _with_0.Position = Point2 - self.Offset
          end
        end
        return _with_0
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "Vector3",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Visual.Vector3 = _class_0
end
do
  local _class_0
  local _parent_0 = Visual.Vector3
  local _base_0 = {
    init = function(self, Text, Options)
      if Options == nil then
        Options = { }
      end
      self.Options = Options
      local color = self.Options.color or Color3.new(1, 1, 1)
      local outline = self.Options.outline or Color3.new()
      local opacity = self.Options.opacity or 1
      local font = self.Options.font or Drawing.Fonts.Monospace
      local size = self.Options.size or 13
      do
        local _with_0 = Drawing.new('Text')
        _with_0.Font = font
        _with_0.Size = size
        _with_0.Transparency = opacity
        _with_0.Outline = outline ~= false
        if outline then
          _with_0.OutlineColor = outline
        end
        _with_0.Color = color
        _with_0.Visible = true
        self.Object = _with_0
      end
      self:setPosition(self.Options.position)
      return self:setText(Text)
    end,
    setText = function(self, Text)
      self.Text = Text
      self.Object.Text = self.Text
      local X, Y
      do
        local _obj_0 = self.Object.TextBounds
        X, Y = _obj_0.X, _obj_0.Y
      end
      local XC
      if self.Options.center then
        XC = X / 2
      else
        XC = 0
      end
      self.Offset = V2(XC, Y / 2)
    end,
    update = function(self)
      local C = self.Camera
      local Point3, PointVisible = W2S(C, self.Point)
      do
        local _with_0 = self.Object
        _with_0.Visible = PointVisible
        if PointVisible then
          local Point2 = V3V2(Point3)
          _with_0.Position = Point2 - self.Offset
        end
        return _with_0
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "Text",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Visual.Text = _class_0
end
return Visual
