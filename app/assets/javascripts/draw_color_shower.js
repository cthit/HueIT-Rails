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
			function draw(id){
				var canvas = document.getElementById(id);
				var ctx = canvas.getContext("2d");
				h = document.getElementById("hue").value/65535;
				s = document.getElementById("sat").value/254;
				l = document.getElementById("bri").value/254;
				if(l>0.8) {
					l = 0.8;
				}else if(l<0.2) {
					l = 0.2;
				}

				rgb = hslToRgb(h,s,l);
				r = Math.round(rgb[0]);
				g = Math.round(rgb[1]);
				b = Math.round(rgb[2]);

				/**
				* So here we create a half circle and we set the fillStyle to the current color of Hue, Saturation and Brightness level
				*/
				ctx.beginPath();
				ctx.arc(75,75,70,Math.PI,0,false);
				ctx.closePath();
				ctx.fillStyle= "rgb(" + r + "," + g + "," + b + ")";
				ctx.fill();
				ctx.lineWidth=2;
				ctx.strokeStyle='black';
				ctx.stroke();

				//Cone
				ctx.beginPath();
				ctx.moveTo(6,75);
				ctx.lineTo(50,150);
				ctx.lineTo(100,150);
				ctx.lineTo(144,75);
				ctx.closePath();
				ctx.fillStyle="lightgray";
				ctx.fill();
				ctx.stroke();

				//Bottom box
				ctx.beginPath();
				ctx.moveTo(50,150);
				ctx.lineTo(50,190);
				ctx.lineTo(100,190);
				ctx.lineTo(100,150);
				ctx.closePath();
				ctx.fillStyle = "gray";
				ctx.fill();
				ctx.stroke();

				//Bottom line
				ctx.beginPath();
				ctx.moveTo(60, 193);
				ctx.lineTo(90, 193);
				ctx.closePath();
				ctx.lineWidth=3;
				ctx.stroke();

				//Coils
				ctx.beginPath();
				ctx.moveTo(55, 150);
				ctx.lineTo(100, 160);
				ctx.moveTo(50, 160);
				ctx.lineTo(100, 170);
				ctx.moveTo(50, 170);
				ctx.lineTo(100, 180);
				ctx.moveTo(50, 180);
				ctx.lineTo(100, 190);
				ctx.closePath();
				ctx.lineWidth=1;
				ctx.stroke();
			}
