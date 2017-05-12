
function createPresetColor(id, colors) {
  var div = '<div class="preset-color" ' +
            'style="background-color: ' + RGBtoCSS(colors) + '"">' +
            '</div>'

  return div
}

function renderPresetColors() {
  presetColors.forEach(function (preset_color) {
    draw('#preset_color_' + preset_color.id, preset_color.hue / 65535, preset_color.saturation / 255, preset_color.brightness / 255)
  })
}

function setSlidersFromPresetColor (id) {
  var presetColor = presetColors.find(function (el) {
    return el.id === id
  })
  setSliders(
    Math.round(presetColor.hue),
    Math.round(presetColor.saturation),
    Math.round(presetColor.brightness)
  )
}
