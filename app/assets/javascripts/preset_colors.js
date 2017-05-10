
function createPresetColor(id, colors) {
  var div = '<div class="preset-color" ' +
            'style="background-color: ' + RGBtoCSS(colors) + '"">' +
            '</div>'

  return div
}

function renderPresetColors() {
  preset_colors.forEach(function (preset_color) {
    draw('#preset_color_' + preset_color.id, preset_color.hue / 65535, preset_color.saturation / 255, preset_color.brightness / 255)
  })
}
