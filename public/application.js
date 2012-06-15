(function() {

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
    return new Waveform({
      container: $("#logo")[0],
      outerColor: "transparent",
      innerColor: "#FF6600",
      width: 56,
      height: 100,
      interpolate: false,
      data: d
    });
  });

}).call(this);