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
    canvas.style.width  = width  || container.clientWidth + "px"
    canvas.style.height = height || container.clientHeight + "px"
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

    setDataWithLimit: (data, limit, defaultValue=0.0) ->
      dataToSet = []
      if data.length > limit
        dataToSet = data.slice(data.length - limit, data.length)
      else
        console.log limit - 1 
        for i in [0..limit-1]
          dataToSet[i] = data[i] || defaultValue
      @setDataInterpolated(dataToSet)


    interpolateData: (data) ->

    setDataInterpolated: (data) ->
      total = data.length
      step = total / width
      interpolated = []
      avg = 0
      i = 0
      sauce = ->
        min = 0.85
        max = 1.3
        diff = max - min
        min + Math.random() * diff

      if step < 1
        c = 0
        while i < width
          interpolated.push data[Math.round(c)] * sauce()
          i += 1
          c += step
      else
        step = Math.floor(step)
        while i < total
          avg += data[i]
          if i % step is 0
            interpolated.push avg / step
            avg = 0
          i += 1
      @data = interpolated

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
        ctx.fillRect parseInt(t*i, 10), parseInt(middle - middle * d, 10), parseInt(t, 10), parseInt(middle * d * 2, 10)
        i++
  }
