/*

FPS controlled display loop.

Thanks to K3N for this solution
https://stackoverflow.com/a/19773537/657008

*/

(function(win) {

win.FpsCtrl = function (fps, callback) {
  var delay = 1000 / fps, // time per frame
      time = null, // start time
      frame = -1, // frame count
      tref; // rAF time reference

  function loop(timestamp) {
      if (time === null) time = timestamp;
      var seg = Math.floor((timestamp - time) / delay);
      if (seg > frame) { // moved to next frame?
          delta = seg - frame;
          frame = seg;
          callback({
              time: timestamp,
              frame: frame,
              delta: delta
          })
      }
      tref = requestAnimationFrame(loop)
  }

  // play status
  this.isPlaying = false;

  // set frame-rate
  this.frameRate = function(newfps) {
      if (!arguments.length) return fps;
      fps = newfps;
      delay = 1000 / fps;
      frame = -1;
      time = null;
  };

  // enable starting/pausing of the object
  this.start = function() {
      if (!this.isPlaying) {
          this.isPlaying = true;
          tref = requestAnimationFrame(loop);
      }
  };

  this.pause = function() {
      if (this.isPlaying) {
          cancelAnimationFrame(tref);
          this.isPlaying = false;
          time = null;
          frame = -1;
      }
  };
}

})(window);
