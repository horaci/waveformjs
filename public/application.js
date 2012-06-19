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

  var i = 0;
  var headerWaveform = new Waveform({
    container: $("#logo")[0],
    outerColor: "transparent",
    innerColor: function(x){
      if(i > x){
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
    i = 0.25;
    headerWaveform.redraw();
  }, 300);


  setTimeout(function(){
    i = 0.50;
    headerWaveform.redraw();
  }, 400);

  setTimeout(function(){
    i = 0.75;
    headerWaveform.redraw();
  }, 500);


  setTimeout(function(){
    i = 1;
    headerWaveform.redraw();
  }, 600);

});

