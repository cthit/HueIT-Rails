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
			* the h,s,l value is taken from each
			*/
			function draw(id,hue,sat,light){
				var canvas = document.getElementById(id);
				var ctx = canvas.getContext("2d");
				if(light>0.8) {
					light = 0.8;
				}else if(light<0.2) {
					light = 0.2;
				}

				rgb = hslToRgb(hue,sat,light);
				r = Math.round(rgb[0]);
				g = Math.round(rgb[1]);
				b = Math.round(rgb[2]);

				/**
				* So here we create a half circle and we set the fillStyle to the current color of Hue, Saturation and Brightness level
				*/
				ctx.beginPath();
				ctx.arc(15,15,14,0,2*Math.PI,false);
				ctx.fillStyle= "rgb(" + r + "," + g + "," + b + ")";
				ctx.fill();
				ctx.lineWidth=2;
				ctx.strokeStyle='#EDEDED';
				ctx.stroke();
			}

			function redraw() {
				for (var i = 1; i <= 6; i++) {
					if (!document.getElementById("switch_" + i).checked) {
						draw("color_shower_" + i, 0, 0, 1);
					} else if (document.getElementById("lights_" + i).checked) {
						draw("color_shower_" + i, 
							document.getElementById("hue").value/65535,
							document.getElementById("sat").value/254,
							document.getElementById("bri").value/254);
					} 
				};
			}

			function colorLamp(id, hue, sat, bri) {
				if (!document.getElementById("lights_" + id).checked) {
						draw("color_shower_" + id, 
							document.getElementById("hue").value/65535,
							document.getElementById("sat").value/254,
							document.getElementById("bri").value/254);
					} else {
						draw("color_shower_" + id, hue/65535, sat/254, bri/254);
					}
			}
