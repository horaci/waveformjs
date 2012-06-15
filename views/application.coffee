$(function(){
  window.waveform = new Waveform({
  container: $(".waveform")[0],
  outerColor: "transparent",
  innerColor: function(percentageX, percentageY){
    return '#'+Math.floor(percentageX*16777215).toString(16);
  }
});

$.getJSON("http://waveform.herokuapp.com/w?callback=?",{
    url: "http://w1.sndcdn.com/EQyi2vpPOMvG_m.png",
  }, function(d){
    //waveform.setDataInterpolated(d);
    waveform.setDataInterpolated([1,2,1,0.5,0]);
    waveform.redraw();
  });
});
