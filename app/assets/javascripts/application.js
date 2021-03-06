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
//= require foundation
//= require_tree .


function switchOnOff (i) {
  var light = lights.find(function (el) {
    return el.id === i
  })
  changeUrl = '/lights/' + i + '/switch_on_off'
  $.post(changeUrl, function (data) {
    updateLights(data)
    renderLamps()
  })
}

function setSlidersFromBulb (id) {
  var light = lights.find(function (el) {
    return el.id === id
  })
  setSliders(Math.round(light.hue), Math.round(light.sat), Math.round(light.bri))
}

function setSliders(hue, sat, bri) {
  var hueSlider = document.getElementById('hue')
  hueSlider.value = hue
  var satSlider = document.getElementById('saturation')
  satSlider.value = sat
  var briSlider = document.getElementById('brightness')
  briSlider.value = bri
}

function runParty(){
	$(document.body).addClass('party-on')
}

function ruinParty(){
	$(document.body).removeClass('party-on')
}

function togglePartyMode(){
	$(document.body).toggleClass('party-on')
}

function sse_waiter() {
	var source = new EventSource('/sse_update')

	source.onmessage = function(event) {
    var data = JSON.parse(event.data)
    lights = data.lights
    isPartyOn = data.isPartyOn
		renderLamps()
    if (isPartyOn) {
      runParty()
    } else {
      ruinParty()
    }
	};
}

var ready = function () {
  renderLamps()
  renderPresetColors()
  draw_hue_canvas()
  draw_sat_canvas()
  draw_bri_canvas()
  var userAgent = navigator.userAgent || navigator.vendor || window.opera
  if (userAgent.match(/Android/i)) {
    changeThemeColor()
  }
  // sse_waiter();
}

var changeThemeColor = function() {
		var colors = ["#09cdda", "#9306ff", "#ff066f", "#0658ff", "#06ff93", "#b0ff06", "#ffcd06" ];
		var time = 250;
		var i = 0;
		var party = false;
		var defaultColor = "#09cdda";
		var changeColor = function() {
			$('meta[name=theme-color]').remove();
			$('head').append('<meta name="theme-color" content="' + colors[i] + ' ">');
			i++;
			if ( i == colors.length) {
				i = 0;
			}
			if (party) {
				setTimeout(changeColor, time);
			} else {
				$('meta[name=theme-color]').remove();
				$('head').append('<meta name="theme-color" content="' + defaultColor +'" >');
			}
		};
		$('#party_btn').click(function() {
			party = !party;
			if (party) {
				setTimeout(changeColor, time);
			} else {
			}
		});
}

$(function(){ $(document).foundation(); });
