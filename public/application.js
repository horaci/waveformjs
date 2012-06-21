$(function() {
  var a, d, i, v, _i, _j, _len;
  d = [];
  a = [0, 0.25, 0, 1, 0, 0.5, 0, 0.75];
  for (_i = 0, _len = a.length; _i < _len; _i++) {
    v = a[_i];
    for (i = _j = 0; _j <= 7; i = ++_j) {
      d.push(v);
    }
  }

  var i = 0, showWaves = [0, 0, 0, 0];
  var headerWaveform = new Waveform({
    container: $("#logo")[0],
    outerColor: "transparent",
    innerColor: function(x){
      if(showWaves[Math.floor(x / 0.25)]){
        return "#ff6600";
      }else{
        return "#333";
      }
    },
    width: 56,
    height: 100,
    interpolate: false,
    data: d
  });

  setTimeout(function(){
    showWaves = [1, 0, 0, 0];
    headerWaveform.redraw();
    setTimeout(function(){
      showWaves = [0, 1, 0, 0];
      headerWaveform.redraw();
    setTimeout(function(){
      showWaves = [0, 0, 1, 0];
      headerWaveform.redraw();
    setTimeout(function(){
      showWaves = [0, 0, 0, 1];
      headerWaveform.redraw();
    setTimeout(function(){
      showWaves = [0, 0, 1, 0];
      headerWaveform.redraw();
    setTimeout(function(){
      showWaves = [0, 1, 0, 0];
      headerWaveform.redraw();
    setTimeout(function(){
      showWaves = [1, 0, 0, 0];
      headerWaveform.redraw();
    setTimeout(function(){
      showWaves = [0, 0, 0, 0];
      headerWaveform.redraw();

    setTimeout(function(){
      showWaves = [1, 1, 1, 1];
      headerWaveform.redraw();
  }, 150); }, 150); }, 150); }, 150); }, 150); }, 150); }, 150); }, 150); }, 300);

});

