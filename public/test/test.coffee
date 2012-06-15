module "Waveform"

test "Should create new (fitting) canvas if container is passed", ->
  waveform = new Waveform
    container: document.getElementById("qunit-fixture")
  window.bla = waveform
  equal waveform.canvas.style.width, "100px"
  equal waveform.canvas.style.height, "100px"

test "Should reuse the existing canvas if passed", ->
  canvas = document.createElement("canvas")
  document.getElementById("qunit-fixture").appendChild(canvas)
  waveform = new Waveform
    canvas: canvas
  equal waveform.canvas, canvas

test "#expandData should fill up to limit", ->
  window.waveform = new Waveform
    container: document.getElementById("qunit-fixture")

  data = waveform.expandData([0.5, 0.8, 1.0], 5)
  deepEqual(data, [0.5, 0.8, 1.0, 0.0, 0.0])

#test "#setDataWithLimit should only set recent data if over limit", ->
#  waveform = new Waveform
#    container: document.getElementById("qunit-fixture")
#  waveform.setDataWithLimit([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], 5)
#  deepEqual(waveform.data, [2.0, 3.0, 4.0, 5.0, 6.0])

test "#interpolateArray interpolation 1", ->
  waveform = new Waveform
    container: document.getElementById("qunit-fixture")
  data = waveform.interpolateArray([0.8, 0.4, 0.0], 2)
  deepEqual(data, [0.8, 0])


test "#interpolateArray interpolation", ->
  waveform = new Waveform
    container: document.getElementById("qunit-fixture")
  data = waveform.interpolateArray([1, 0.75, 0.5, 0.25, 0], 3)
  deepEqual(data, [1, 0.5, 0])


test "#interpolateArray extrapolation", ->
  waveform = new Waveform
    container: document.getElementById("qunit-fixture")
  data = waveform.interpolateArray([0.8, 0.2], 3)
  deepEqual(data, [0.8, 0.5, 0.2])


test "#interpolateArray extrapolation 2", ->
  waveform = new Waveform
    container: document.getElementById("qunit-fixture")
  data = waveform.interpolateArray([0.8, 0.2], 4)
  deepEqual(data, [0.8, 0.6000000000000001, 0.4, 0.2])
