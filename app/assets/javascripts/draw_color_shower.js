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

/**
* draw() is called first when the body loads, and then on each change of value (hue,bri,sat).
* Correct is a boolean for if the given value should be corrected to the triangle
* the h,s,l value is taken from each light.
*/
function draw(id, hue, sat, brightness){
	var canvas = document.getElementById(id);
	var ctx = canvas.getContext("2d");
	var rgb = null;
	rgb = HSVtoRGB(hue, sat, brightness)

	/**
	* So here we create a half circle and we set the fillStyle to the current color of Hue, Saturation and Brightness level
	*/
	ctx.beginPath();
	ctx.arc(15, 15, 14, 0, 2 * Math.PI, false);
	ctx.fillStyle = "rgb(" + rgb[0] + "," + rgb[1] + "," + rgb[2] + ")";
	ctx.fill();
	ctx.lineWidth = 2;
	ctx.strokeStyle = '#EDEDED';
	ctx.stroke();
}

// Used when disregarding the value of the selectors, only wanting to draw the color of the bulb or if it is off
function drawLamp(id, hue, sat, bri) {
	if (!document.getElementById("switch_" + id).checked) {
		draw("color_shower_" + id, 0, 0, 1);
	} else {
		draw("color_shower_" + id, hue / 65535, sat / 254, bri / 254);
	}
}
//Returns the value of the hue slider normalized.
function get_hue() {
	return get_normalized_range_value("hue_range");
}
//Returns the value of the saturation slider normalized.
function get_sat() {
	return get_normalized_range_value("sat_range");
}

//Returns the value of the brightness slider normalized.
function get_bri() {
	return get_normalized_range_value("bri_range");
}

function get_normalized_range_value(elementId) {
	var range = document.getElementById(elementId)
	return range.value / range.max;
}

//Draws the canvas behind the brightness slider to visualize how the brightness changes
function draw_bri_canvas() {
	var canvas = document.getElementById("bri_canvas");
	var context = canvas.getContext("2d");

	var gradient = context.createLinearGradient(0, 0, canvas.width, 0);
	gradient.addColorStop(0, "black");
	gradient.addColorStop(1, "white");

	context.fillStyle = gradient;
	context.fillRect(0, 0, canvas.width, canvas.height);
}

//Draws the canvas behind the saturation slider with an approximation of what colour the lights will have at that position.
function draw_sat_canvas() {
	var canvas = document.getElementById("sat_canvas");
	var context = canvas.getContext("2d");

	for (var x = 0; x < canvas.width; x += 1) {
		var sat = x / canvas.width;
		var rgb = HSVtoRGB(get_hue(), sat, get_bri())
		draw_vertical_line_on_x(context, x, canvas.height, rgb)
	};
}

//Draws the canvas behind the hue slider with an approximation of what colour the lights will have at that position.
function draw_hue_canvas(){
	var canvas = document.getElementById("hue_canvas");
	var context = canvas.getContext("2d");

	for (var x = 0; x < canvas.width; x += 1) {
		var hue = x / canvas.width;
		var rgb = HSVtoRGB(hue, get_sat(), get_bri())
		draw_vertical_line_on_x(context, x, canvas.height, rgb)
	};
}

function draw_vertical_line_on_x(context, x, y, color) {
	context.strokeStyle = "rgb(" + color[0] + "," + color[1] + "," + color[2] + ")";
	context.beginPath();
	context.moveTo(x, 0);
	context.lineTo(x, y);
	context.closePath();
	context.stroke();
}
