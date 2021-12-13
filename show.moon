-- show.moon
-- SFZILabs 2021

import wait, spawn, delay from task

RunService = game\GetService 'RunService'
HttpService = game\GetService 'HttpService'
GUID = -> HttpService\GenerateGUID false

V3 = Vector3.new
V2 = Vector2.new

V3V2 = (V) -> V2 V.X, V.Y
W2S = workspace.CurrentCamera.WorldToViewportPoint

MUTEX = SHOW_MUTEX or {}
getgenv!.SHOW_MUTEX = MUTEX

class Visual
    new: (...) =>
        @Camera = workspace.CurrentCamera
        @init ... if @init
        @Options or= {}
        @openMutex!
        @startRenderLoop!

    startRenderLoop: =>
        return if @Rendering
        return unless @update
        @Rendering = true
        @GUID = GUID!
        RunService\BindToRenderStep @GUID, 199, -> @update!

    stopRenderLoop: =>
        return unless @Rendering
        @Rendering = false
        RunService\UnbindFromRenderStep @GUID

    expire: (Time) =>
        delay Time, -> @Destroy!

    setVisible: (Visible = true) =>
        if Visible
            @startRenderLoop!
        else @stopRenderLoop!
        @visible Visible

    openMutex: =>
        if Mutex = @Options.mutex
            if Old = MUTEX[Mutex]
                Old\Destroy!

            MUTEX[Mutex] = @

    closeMutex: =>
        if Mutex = @Options.mutex
            MUTEX[Mutex] = nil

    Destroy: =>
        return if @Dead
        @Dead = true
        @closeMutex!
        @stopRenderLoop!
        @destroy!

    destroy: =>
    visible: =>

import rad, sin, cos, atan2, pi from math

angle = (dir, ang) ->
    ang = rad ang
    V2 (cos(ang)*dir.X - sin(ang)*dir.Y), sin(ang)*dir.X + cos(ang)*dir.Y

Correct = (CFrame.Angles 0, (rad 89.9), 0)\vectorToWorldSpace V3 0, 0, -1/10

class Visual.Ray extends Visual
    init: (Ray, @Options = {}) =>
        @Origin = Ray.Origin
        @Termination = @Origin + Ray.Direction
        color = @Options.color or Color3.new 1, 1, 1
        opacity = @Options.opacity or 1
        @Line = with Drawing.new 'Line'
            .Thickness = 1
            .Transparency = opacity
            .Color = color
            .Visible = true

        if @Options.showOrigin or @Options.advanced
            @Circle = with Drawing.new 'Circle'
                .NumSides = 14
                .Radius = 5
                .Thickness = 1
                .Transparency = opacity
                .Filled = false
                .Visible = true
                .Color = color

        if @Options.showTermination or @Options.advanced
            @Arrows = {}
            for i = 1, 2
                table.insert @Arrows, with Drawing.new 'Line'
                    .Thickness = 1
                    .Transparency = opacity
                    .Visible = true
                    .Color = color

    setRay: (Ray) =>
        @Origin = Ray.Origin
        @Termination = @Origin + Ray.Direction

    update: =>
        C = @Camera
        Origin3, OriginVisible = W2S C, @Origin
        if Origin3.Z < 0
            OPos = C.CFrame\pointToObjectSpace @Origin
            AT = pi + atan2 OPos.Y, OPos.X
            OPos = CFrame.Angles(0, 0, AT)\vectorToWorldSpace Correct
            Origin3 = W2S C, C.CFrame\pointToWorldSpace OPos

        Origin2 = V3V2 Origin3

        Termination3, TerminationVisible = W2S C, @Termination
        if Termination3.Z < 0
            OPos = C.CFrame\pointToObjectSpace @Termination
            AT = pi + atan2 OPos.Y, OPos.X
            OPos = CFrame.Angles(0, 0, AT)\vectorToWorldSpace Correct
            Termination3 = W2S C, C.CFrame\pointToWorldSpace OPos

        Termination2 = V3V2 Termination3

        with @Line
            .To = Origin2
            .From = Termination2

        if @Circle
            with @Circle
                .Visible = OriginVisible
                if OriginVisible
                    .Position = Origin2

        if @Arrows
            Dir = (Termination2 - Origin2).unit * 10

            for A in *@Arrows
                with A
                    .Visible = TerminationVisible
                    if TerminationVisible
                        .From = Termination2

            if TerminationVisible
                @Arrows[1].To = Termination2 - angle Dir, 20
                @Arrows[2].To = Termination2 - angle Dir, -20

    visible: (Visible) =>
        unless Visible
            @Line.Visible = false
            @Circle.Visible = false if @Circle
            if @Arrows
                for A in *@Arrows
                    A.Visible = false
        
    destroy: =>
        @Line\Remove!
        @Circle\Remove! if @Circle
        if @Arrows
            A\Remove! for A in *@Arrows

class Visual.Vector2 extends Visual
    init: (@Point, @Options = {}) =>
        color = @Options.color or Color3.new 1, 1, 1
        opacity = @Options.opacity or 1
        @Radius = @Options.radius or 5
        Diameter = @Radius * 2
        @Shape = (@Options.box and 'Square') or 'Circle'
        @Object = with Drawing.new @Shape
            .Thickness = 1
            .Transparency = opacity
            .Color = color
            .Visible = true
            .Filled = false
            if @Shape == 'Circle'
                .Radius = @Radius
            else
                .Size = V2 Diameter, Diameter
                @Offset = V2 @Radius, @Radius

        @move!

    update: false
    visible: (Visible) => @Object.Visible = Visible

    move: =>
        @Object.Position = if @Shape == 'Circle'
            @Point
        else @Point - @Offset

    setPosition: (@Point) => @move!

    destroy: =>
        @Object\Remove!

class Visual.Vector3 extends Visual.Vector2
    move: =>

    update: =>
        C = @Camera
        Point3, PointVisible = W2S C, @Point
        with @Object
            .Visible = PointVisible
            if PointVisible
                Point2 = V3V2 Point3
                .Position = if @Shape == 'Circle'
                    Point2
                else Point2 - @Offset

Visual
