/**
* Converts an HSV color value to RGB. Conversion formula
* adapted from http://en.wikipedia.org/wiki/HSL_color_space.
* Assumes h, s, and v are contained in the set [0, 1] and
* returns r, g, and b in the set [0, 255].
*
* @param   Number  h       The hue
* @param   Number  s       The saturation
* @param   Number  v       The brightness
* @return  Array           The RGB representation
*/
function HSVtoRGB(h, s, v) {
    var r, g, b, i, f, p, q, t;
    if (arguments.length === 1) {
        s = h.s, v = h.v, h = h.h;
    }
    i = Math.floor(h * 6);
    f = h * 6 - i;
    p = v * (1 - s);
    q = v * (1 - f * s);
    t = v * (1 - (1 - f) * s);
    switch (i % 6) {
        case 0: r = v, g = t, b = p; break;
        case 1: r = q, g = v, b = p; break;
        case 2: r = p, g = v, b = t; break;
        case 3: r = p, g = q, b = v; break;
        case 4: r = t, g = p, b = v; break;
        case 5: r = v, g = p, b = q; break;
    }
    return [Math.round(r * 255), Math.round(g * 255), Math.round(b * 255)];
}

function RGBtoCSS(rgb) {
  return "rgb(" + rgb[0] + ", " + rgb[1] + ", " + rgb[2] + ")"
}

function createLinearGradient(stops) {
  return 'linear-gradient(to right, ' + stops.join(',') + ')';
}

function updateLights (state) {
  lights = state.lights
  isPartyOn = state.isPartyOn
  isLocked = state.isLocked
}

function renderLamps () {
  lights.forEach(function (light) {
    drawLamp(light)
    $('#switch_' + light.id).prop('checked', light.on)
  })
  if (isPartyOn) {
    runParty()
  } else {
    ruinParty()
  }
}
/**
* draw() is called first when the body loads, and then on each change of value (hue,bri,sat).
* Correct is a boolean for if the given value should be corrected to the triangle
* the h,s,l value is taken from each light.
*/
function draw (id, hue, sat, brightness) {
  var rgb = HSVtoRGB(hue, sat, brightness)
  $(id).css("background-color", RGBtoCSS(rgb))
}

// Used when disregarding the value of the selectors, only wanting to draw the color of the bulb or if it is off
function drawLamp (light) {
  if (!light.on) {
    draw('#color_shower_' + light.id, 0, 0, 0.5)
  } else {
    draw('#color_shower_' + light.id, light.hue / 65535, light.sat / 254, light.bri / 254)
  }
}
//Returns the value of the hue slider normalized.
function getHue() {
	return getNormalizedRangeValue("hue");
}
//Returns the value of the saturation slider normalized.
function getSat() {
	return getNormalizedRangeValue("saturation");
}

//Returns the value of the brightness slider normalized.
function getBri() {
	return getNormalizedRangeValue("brightness");
}

function getNormalizedRangeValue(elementId) {
	var range = document.getElementById(elementId)
	return range.value / range.max;
}

//Draws the canvas behind the brightness slider to visualize how the brightness changes
function draw_bri_canvas() {
  var slider = $(".bri-show");
  slider.css('background', 'linear-gradient(to right, black, white)');
}

//Draws the canvas behind the saturation slider with an approximation of what colour the lights will have at that position.
function draw_sat_canvas() {
	var slider = $(".sat-show");
  var hue = getHue()
  var bri = getBri()
  var stops = [HSVtoRGB(hue, 0, bri), HSVtoRGB(hue, 1, bri)].map(RGBtoCSS)
  slider.css('background', createLinearGradient(stops));
}

//Draws the canvas behind the hue slider with an approximation of what colour the lights will have at that position.
function draw_hue_canvas(){
  var slider = $(".hue-show");
	// var context = canvas.getContext("2d");
  var numberStops = 20
  var stops = []
  var sat = getSat()
  var bri = getBri()

  for (var i = 0; i < numberStops; i++) {
    stops.push(i / numberStops);
  }

  stops = stops.map(function(hue) {
    return RGBtoCSS(HSVtoRGB(hue, sat, bri));
  });

  slider.css('background', createLinearGradient(stops))
}
