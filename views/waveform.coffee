window.Waveform = class Waveform
  constructor: (options) ->
    @container = options.container
    @canvas    = options.canvas
    @data      = options.data || []
    @outerColor = options.outerColor || "transparent"
    @innerColor = options.innerColor || "#000000"
    @interpolate = true
    @interpolate = false if options.interpolate == false
    unless @canvas?
      if @container
        @canvas = @createCanvas(@container, options.width || @container.clientWidth, options.height || @container.clientHeight)
      else
        throw "Either canvas or container option must be passed"

    @patchCanvasForIE(@canvas)
    @ctx = @canvas.getContext("2d")
    @width  = parseInt @ctx.canvas.width, 10
    @height = parseInt @ctx.canvas.height, 10

    if options.data
      @update(options)

  setData: (data) ->
    @data = data

  setDataInterpolated: (data) ->
    @setData @interpolateArray(data, @width)

  setDataCropped: (data) ->
    @setData @expandArray(data, @width)

  update: (options) ->
    @interpolate = false if options.interpolate?
    if @interpolate == false
      @setDataCropped(options.data)
    else
      @setDataInterpolated(options.data)
    @redraw()

  redraw: () =>
    @clear()
    @ctx.fillStyle = @innerColor
    middle = @height / 2
    i = 0
    for d in @data
      t = @width / @data.length
      @ctx.fillStyle = @innerColor(i/@width, d) if typeof(@innerColor) == "function"
      @ctx.clearRect t*i, middle - middle * d, t, (middle * d * 2)
      @ctx.fillRect t*i, middle - middle * d, t, middle * d * 2
      i++

  clear: ->
    @ctx.fillStyle = @outerColor
    @ctx.clearRect(0, 0, @width, @height)
    @ctx.fillRect(0, 0,  @width, @height)

  # rather private helpers:

  patchCanvasForIE: (canvas) ->
    if typeof window.G_vmlCanvasManager != "undefined"
     canvas = window.G_vmlCanvasManager.initElement(canvas)
     oldGetContext = canvas.getContext
     canvas.getContext = (a) ->
       ctx = oldGetContext.apply(canvas, arguments)
       canvas.getContext = oldGetContext
       ctx

  createCanvas: (container, width, height) ->
    canvas = document.createElement("canvas")
    container.appendChild(canvas)
    canvas.width  = width 
    canvas.height = height
    canvas

  expandArray: (data, limit, defaultValue=0.0) ->
    newData = []
    if data.length > limit
      newData = data.slice(data.length - limit, data.length)
    else
      for i in [0..limit-1]
        newData[i] = data[i] || defaultValue
    newData

  linearInterpolate: (before, after, atPoint) ->
    before + (after - before) * atPoint

  interpolateArray: (data, fitCount) ->
    newData = new Array()
    springFactor = new Number((data.length - 1) / (fitCount - 1))
    newData[0] = data[0]
    i = 1

    while i < fitCount - 1
      tmp = i * springFactor
      before = new Number(Math.floor(tmp)).toFixed()
      after = new Number(Math.ceil(tmp)).toFixed()
      atPoint = tmp - before
      newData[i] = @linearInterpolate(data[before], data[after], atPoint)
      i++
    newData[fitCount - 1] = data[data.length - 1]
    newData
