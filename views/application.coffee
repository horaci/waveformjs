$ ->
  d = []
  a = [0, 0.25, 0, 1, 0, 0.5, 0, 0.75]

  for v in a
    for i in [0..7]
      d.push v

  new Waveform
    container: $("#logo")[0]
    outerColor: "transparent"
    innerColor: "#FF6600"
    width: 56
    height: 100
    interpolate: false
    data: d  
