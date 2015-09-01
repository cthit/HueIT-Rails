// Constants for the triangle from http://www.developers.meethue.com/documentation/core-concepts
RedCornerX = 0.675
RedCornerY = 0.322
GreenCornerX = 0.4091
GreenCornerY = 0.518
BlueCornerX = 0.167
BlueCornerY = 0.04

BlueGreenLineK = 1.97439075;
BlueGreenLineM = 0.28972325;
BlueRedLineK = 0.5511811;
BlueRedLineM = 0.0527047;
GreenRedLineK = -0.73711922;
GreenRedLineM = 0.81955547198;



/**
* Converts an HSL color value to RGB. Conversion formula
* adapted from http://en.wikipedia.org/wiki/HSL_color_space.
* Assumes h, s, and l are contained in the set [0, 1] and
* returns r, g, and b in the set [0, 255].
*
* @param   Number  h       The hue
* @param   Number  s       The saturation
* @param   Number  l       The lightness
* @return  Array           The RGB representation
*/
function hslToRgb(h, s, l){
	var r, g, b;

	if(s == 0){
		r = g = b = l; // achromatic
	}else{
		function hue2rgb(p, q, t){
			if(t < 0) t += 1;
			if(t > 1) t -= 1;
			if(t < 1/6) return p + (q - p) * 6 * t;
			if(t < 1/2) return q;
			if(t < 2/3) return p + (q - p) * (2/3 - t) * 6;
			return p;
		}

		var q = l < 0.5 ? l * (1 + s) : l + s - l * s;
		var p = 2 * l - q;
		r = hue2rgb(p, q, h + 1/3);
		g = hue2rgb(p, q, h);
		b = hue2rgb(p, q, h - 1/3);
	}

	return [r * 255, g * 255, b * 255];
}
/**
* draw() is called first when the body loads, and then on each change of value (hue,bri,sat).
* Correct is a boolean for if the given value should be corrected to the triangle
* the h,s,l value is taken from each light
*/
function draw(id,hue,sat,light,correct){
	var canvas = document.getElementById(id);
	var ctx = canvas.getContext("2d");
	var rgb = null;
	var light = get_light();

	if(correct) {
		rgb = get_limited_rgb(hue, sat, light);
	} else {
		rgb = hslToRgb(hue, sat, light)
	}
	
	rgb[0] = Math.round(rgb[0]);
	rgb[1] = Math.round(rgb[1]);
	rgb[2] = Math.round(rgb[2]);

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
		draw("color_shower_" + id, 0, 0, 1, false);
	} else {
		draw("color_shower_" + id, hue / 65535, sat / 254, bri / 254, true);
	}
}
//Returns the value of the hue slider normalized.
function get_hue() {
	var range = document.getElementById("hue_range")
	return range.value / range.max
}
//Returns the value of the saturation slider normalized.
function get_sat() {
	var range = document.getElementById("sat_range")
	return range.value / range.max;
}

function get_light() {
	return 0.5;
}

//Returns hue, sat, and light parameters and limits them to the values that our bulbs can display.
function get_limited_rgb(hue, sat, light) {
	var rgb = hslToRgb(hue, sat, light);
	// Here we go from rgb to XY, limit the XY values to the red triangle and then go back to rgb
	var XY = rgb_to_XY(rgb[0], rgb[1], rgb[2]);
	XY = limit_XY_values(XY[0], XY[1]);
	rgb = XY_to_rgb(XY[0], XY[1], light);

	rgb[0] = Math.round(rgb[0]);
	rgb[1] = Math.round(rgb[1]);
	rgb[2] = Math.round(rgb[2]);

	return rgb
}

//Draws the square that shows the value of the hue and saturation sliders
function draw_shower(){
	var canvas = document.getElementById("color_shower");
	var context = canvas.getContext("2d");

	var rgb = get_limited_rgb(get_hue(), get_sat(), get_light())
	/**
	* So here we create a half circle and we set the fillStyle to the current color of Hue, Saturation and Brightness level
	*/
	context.beginPath();
	context.rect(0, 40, 200, 150);
	context.fillStyle = "rgb(" + rgb[0] + "," + rgb[1] + "," + rgb[2] + ")";
	context.fill();
	context.lineWidth = 3;
	context.strokeStyle = '#EDEDED';
	context.stroke();
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
		var sat = x * Math.round(256 / canvas.width) / 256;
		var rgb = get_limited_rgb(get_hue(), sat, get_light())
		draw_vertical_line_on_x(context, x, canvas.height, rgb)
	};
}

//Draws the canvas behind the hue slider with an approximation of what colour the lights will have at that position.
function draw_hue_canvas(){
	var canvas = document.getElementById("hue_canvas");
	var context = canvas.getContext("2d");

	for (var x = 0; x < canvas.width; x += 1) {
		var hue = x * Math.round(65535 / canvas.width) / 65535;
		var rgb = get_limited_rgb(hue, get_sat(), get_light())
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

// Function that returns the value of the line in the triangle that goes from blue to green
// Left line
// http://www.developers.meethue.com/documentation/core-concepts
function blueGreenLine(x) {
	return BlueGreenLineK * x - BlueGreenLineM;
}
// Function that returns the value of the line in the triangle that goes from green to red
// Right line
// http://www.developers.meethue.com/documentation/core-concepts
function blueRedLine(x) {
	return BlueRedLineK * x - BlueRedLineM;
}
// Function that returns the value of the line in the triangle that goes from green to red
// Lower line
// http://www.developers.meethue.com/documentation/core-concepts
function greenRedLine(x) {
	return GreenRedLineK * x + GreenRedLineM;
}

function limit_XY_values(x,y) {
	//Limits the x values to the red triangle in http://www.developers.meethue.com/documentation/core-concepts


	if (x < GreenCornerX && blueGreenLine(x) < y) {
		var k = -BlueGreenLineK;
		x = (-k * x + y + BlueGreenLineM) / (BlueGreenLineK - k);
		// If the value is outside of the triangle (i.e. )
		if (x > GreenCornerX) {
			x = GreenCornerX;
		} else if (x < BlueCornerX) {
			x = BlueCornerX;
		}
		y = blueGreenLine(x);
	}
	else if (x >= BlueCornerX && x <= RedCornerX && blueRedLine(x) > y) {
		var k = -BlueRedLineK;
		x = (-k * x + y + BlueRedLineM) / (BlueRedLineK - k);
		if (x > RedCornerX) {
			x = RedCornerX;
		} else if (x < BlueCornerX) {
			x = BlueCornerX;
		}
		y = blueRedLine(x);
	}
	else if (x >= GreenCornerX && greenRedLine(x) < y) {
		var k = -GreenRedLineK;
		x = (-k * x + y - GreenRedLineM) / (GreenRedLineK - k);
		if (x > RedCornerX) {
			x = RedCornerX;
		} else if (x < GreenCornerX) {
			x = GreenCornerX;
		}
		y = greenRedLine(x);
	}

	return [x, y];
}

// Takes RGB values and returns array with XY values
function rgb_to_XY(red, green, blue){
	// For the hue bulb the corners of the triangle are:
	// -Red: 0.675, 0.322
	// -Green: 0.4091, 0.518
	// -Blue: 0.167, 0.04
	var normalizedToOne = [red / 255, green / 255, blue / 255]

	var red, green, blue;

	red = normalizedToOne[0];
	green = normalizedToOne[1];
	blue = normalizedToOne[2];

	// Make red more vivid
	/*if (normalizedToOne[0] > 0.04045) {
	    red = Math.pow(
	            (normalizedToOne[0] + 0.055) / (1.0 + 0.055), 2.4);
	} else {
	    red =  (normalizedToOne[0] / 12.92);
	}

	// Make green more vivid
	if (normalizedToOne[1] > 0.04045) {
	    green =  Math.pow((normalizedToOne[1] + 0.055) / (1.0 + 0.055), 2.4);
	} else {
	    green = (normalizedToOne[1] / 12.92);
	}

	// Make blue more vivid
	if (normalizedToOne[2] > 0.04045) {
	    blue =  Math.pow((normalizedToOne[2] + 0.055) / (1.0 + 0.055), 2.4);
	} else {
	    blue = (normalizedToOne[2] / 12.92);
	}*/

	if ( red > 0.04045 ) {
		red = Math.pow(( ( red + 0.055 ) / 1.055 ), 2.4);
	}
	else {
		red = red / 12.92;
	}
	if ( green > 0.04045 ) {
		green = Math.pow(( (green + 0.055) / 1.055 ),2.4);
	}
	else {
		green = green / 12.92;
	}
	if ( blue > 0.04045 ) {
		blue = Math.pow((blue + 0.055 ) / 1.055, 2.4);
	}
	else {
		blue = blue / 12.92;
	}

	red = red * 100;
	green = green * 100;
	blue = blue * 100;

	//Observer. = 2°, Illuminant = D65
	X = red * 0.4124 + green * 0.3576 + blue * 0.1805;
	Y = red * 0.2126 + green * 0.7152 + blue * 0.0722;
	Z = red * 0.0193 + green * 0.1192 + blue * 0.9505;


	/*var X = red * 0.4360747 + green * 0.3850649 + blue * 0.1430804;
	var Y = red * 0.2225045 + green * 0.7168786 + blue * 0.0606169;
	var Z = red * 0.0139322 + green * 0.0971045 + blue * 0.7141733;*/
	//console.log(X + " " + Y + " " + Z);

	var x = X / (X + Y + Z);
	var y = Y / (X + Y + Z);

	return [x, y];
}

function XY_to_rgb(x,y,light) {
	// Based on https://github.com/PhilipsHue/PhilipsHueSDK-iOS-OSX/commit/f41091cf671e13fe8c32fcced12604cd31cceaf3
	var z = 1.0 - x - y;
	var Y = light;
	var X = (Y / y) * x;
	var Z = (Y / y) * z;
	// calculate rgb values
	var r = X  * 1.4628067 - Y * 0.1840623 - Z * 0.2743606;
    var g = -X * 0.5217933 + Y * 1.4472381 + Z * 0.0677227;
    var b = X  * 0.0349342 - Y * 0.0968930 + Z * 1.2884099;

    // Apply gamma correction
    /*if (r <= 0.0031308) {
    	r = 12.92 * r;
    } else {
    	r = (1.0 + 0.055) * Math.pow(r, (1.0 / 2.4)) - 0.055;
    }

    if (g <=  0.0031308) {
    	g = 12.92 * g; 
    } else {
    	g = (1.0 + 0.055) * Math.pow(g, (1.0 / 2.4)) - 0.055;
    }

    if (b <= 0.0031308) {
    	b = 12.92 * b;
    } else {
    	b = (1.0 + 0.055) * Math.pow(b, (1.0 / 2.4)) - 0.055;
    }*/

    return [r * 255, g * 255, b * 255];
}