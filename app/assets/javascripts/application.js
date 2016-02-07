// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

function switchOnOff(i,hue,sat,bri) {
	drawLamp(i,hue,sat,bri);
	changeUrl = "/lights/" + parseInt(i) + "/switchOnOff"
	$.ajax({
		url: changeUrl,
		type: 'GET'
	});
}
//Converts to color HSB object (code from here http://www.csgnetwork.com/csgcolorsel4.html with some improvements)
function rgb2hsb(r, g, b){    
	r /= 255; g /= 255; b /= 255; // Scale to unity.   
	var minVal = Math.min(r, g, b),
	maxVal = Math.max(r, g, b),
	delta = maxVal - minVal,
	HSB = {hue:0, sat:0, bri:maxVal},
	del_R, del_G, del_B;

	if( delta !== 0 ){
		HSB.sat = delta / maxVal;
		del_R = (((maxVal - r) / 6) + (delta / 2)) / delta;
		del_G = (((maxVal - g) / 6) + (delta / 2)) / delta;
		del_B = (((maxVal - b) / 6) + (delta / 2)) / delta;

		if (r === maxVal) {HSB.hue = del_B - del_G;}
		else if (g === maxVal) {HSB.hue = (1 / 3) + del_R - del_B;}
		else if (b === maxVal) {HSB.hue = (2 / 3) + del_G - del_R;}

		if (HSB.hue < 0) {HSB.hue += 1;}		
		if (HSB.hue > 1) {HSB.hue -= 1;}
	}

	HSB.hue *= 65535;
	HSB.sat *= 254;
	HSB.bri *= 254;

	return HSB;
}

function setSliders(id) {
	var canvas = document.getElementById("color_shower_" + id);
	var ctx = canvas.getContext("2d");
	var imgd = ctx.getImageData(7,7,1,1);
	var r = imgd.data[0];
	var g = imgd.data[1];
	var b = imgd.data[2];
	var HSB = rgb2hsb(r,g,b);
	var hueSlider = document.getElementById("hue_range");
	var hueText = document.getElementById("hue_text");
	hueSlider.value = Math.round(HSB.hue);
	hueText.value = Math.round(HSB.hue);
	var satSlider = document.getElementById("sat_range");
	var satText = document.getElementById("sat_text");
	satSlider.value = Math.round(HSB.sat);
	satText.value = Math.round(HSB.sat);
	var briSlider = document.getElementById("bri_range");
	var briText = document.getElementById("bri_text");
	briSlider.value = Math.round(HSB.bri);
	briText.value = Math.round(HSB.bri);
}
function runParty(){
	if (!!!document.getCSSCanvasContext) {
		console.log("Your browser does not support document.getCSSCanvasContext");
   } else {
		delta = 1000 / 60;
		ctx = document.getCSSCanvasContext("2d", "party_btn", 400, 400);
		var x=-100;
	   var partyLoop = function() {
	 		var rainbow_gradient=ctx.createLinearGradient(x,0,200+x,70);
			rainbow_gradient.addColorStop(0,"red");
			rainbow_gradient.addColorStop(0.09,"orange");
			rainbow_gradient.addColorStop(0.18,"yellow");
			rainbow_gradient.addColorStop(0.27,"green");
			rainbow_gradient.addColorStop(0.36,"cyan");
			rainbow_gradient.addColorStop(0.45,"blue");

			rainbow_gradient.addColorStop(0.54,"red");
			rainbow_gradient.addColorStop(0.63,"orange");
			rainbow_gradient.addColorStop(0.72,"yellow");
			rainbow_gradient.addColorStop(0.81,"green");
			rainbow_gradient.addColorStop(0.9,"cyan");
			rainbow_gradient.addColorStop(1,"blue");
	 		ctx.fillStyle = rainbow_gradient;
	 		ctx.fillRect (0, 0, 300, 300);
	 		x+=2;
	 		if(x>=20){
	 			x=-100;
	 		}	
	 	};
   	loopInterval = setInterval(partyLoop, delta);
	}
}
function ruinParty(){
	if (!!!document.getCSSCanvasContext) {
		console.log("Your browser does not support document.getCSSCanvasContext")
	} else {
		ctx = document.getCSSCanvasContext("2d", "party_btn", 400, 400);
		ctx.fillStyle = "brown";
		ctx.fillRect(0,0,300,300);
	}
}
function togglePartyMode(){
	if (typeof partyOn !== 'undefined') {
    	if(partyOn){
    		partyOn = false;
    		console.log("partyOFF");
    		clearInterval(loopInterval);
    		ruinParty();
    	}else{
    		partyOn = true;
			console.log("PARTYON");
    		runParty();
    	}
	}else{
		partyOn = true;
		console.log("PARTYON");
		runParty();
	}
}

function sse_waiter() {
	source = new EventSource('/sse_update')

	source.onmessage = function(event) {
    data = JSON.parse(event.data);
		for (var i = 1; i <= 6; i++) {
			drawLamp(i, data.hue[i-1], data.sat[i-1], 255);
		}
	};
	party_ready();
}

var ready = function() {
	ruinParty();
	ruby_ready();
	party_ready();
	draw_hue_canvas();
	draw_sat_canvas();
	draw_bri_canvas();
	// sse_waiter();
}

$(document).on('page:load', ready);
$(document).ready(ready);
