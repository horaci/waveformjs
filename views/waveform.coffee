window.Waveform = (options={}) ->
  patchCanvasForIE = (canvas) ->
    if typeof window.G_vmlCanvasManager != "undefined"
     canvas = window.G_vmlCanvasManager.initElement(canvas)
     oldGetContext = canvas.getContext
     canvas.getContext = (a) ->
       ctx = oldGetContext.apply(canvas, arguments)
       canvas.getContext = oldGetContext
       ctx

  createCanvas = (container) ->
    canvas = document.createElement("canvas")
    container.appendChild(canvas)
    canvas.width  = width  || container.clientWidth
    canvas.height = height || container.clientHeight
    canvas

  @container = options.container
  @canvas    = options.canvas
  @data      = options.data || []
  outerColor = options.outerColor || "#FFFFFF"
  innerColor = options.innerColor || "#000000"

  unless @canvas?
    if @container
      @canvas = createCanvas(@container)
    else
      throw "Either canvas or container option must be passed"

  patchCanvasForIE(@canvas)
  ctx = @canvas.getContext("2d")
  width  = parseInt ctx.canvas.width, 10
  height = parseInt ctx.canvas.height, 10

  { # Public
    canvas:    @canvas
    container: @container
    data:      @data
    clear: ->
      ctx.fillStyle = outerColor
      ctx.clearRect(0, 0, width, height)
      ctx.fillRect(0, 0, width, height)

    setData: (data) ->
      @data = data

    setDataInterpolated: (data) ->
      @data = @interpolateArray(data, width)

    expandData: (data, limit, defaultValue=0.0) ->
      dataToSet = []
      if data.length > limit
        dataToSet = data.slice(data.length - limit, data.length)
      else
        console.log limit - 1 
        for i in [0..limit-1]
          dataToSet[i] = data[i] || defaultValue
      dataToSet

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

    redraw: () ->
      @clear()
      ctx.fillStyle = innerColor
      middle = height / 2
      i = 0
      for d in @data
        t = width / @data.length
        ctx.fillStyle = innerColor(i/width, d) if typeof(innerColor) == "function"
        ctx.clearRect t*i, middle - middle * d, t, (middle * d * 2)
        #ctx.fillRect t*i, middle - middle * d, t, middle * d * 2

        # x y width height
        console.log(t,i)
        console.log parseInt(t*i, 10), parseInt(middle - middle * d, 10), parseInt(t, 10), parseInt(middle * d * 2, 10)

        ctx.fillRect parseInt(t*i, 10), parseInt(middle - middle * d, 10), parseInt(t, 10), parseInt(middle * d * 2, 10)
        i++
  }
