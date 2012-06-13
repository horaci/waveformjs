$(function(){
  window.waveform = new Waveform({
  container: $(".waveform")[0],
  outerColor: "transparent",
  innerColor: function(percentageX, percentageY){
    return '#'+Math.floor(Math.random()*16777215).toString(16);
  }
});

$.getJSON("/w?callback=?",{
    url: "http://w1.sndcdn.com/EQyi2vpPOMvG_m.png",
  }, function(d){
    waveform.setDataInterpolated(d);
    waveform.redraw();
  });
});