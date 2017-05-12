function createPresetColor(id, colors) {
  let div = '<div class="preset-color" ' +
            'id="preset-color-' + id +
            'style="background-color: ' + RGBtoCSS(colors) + '"">' +
            '</div>'

  return div
}

function renderPresetColors() {
  presetColors.forEach(function (preset_color) {
    draw('#preset-color-' + preset_color.id, preset_color.hue / 65535, preset_color.saturation / 255, preset_color.brightness / 255)
  })
}

function setSlidersFromPresetColor (id) {
  let presetColor = presetColors.find(function (el) {
    return el.id === id
  })
  setSliders(
    Math.round(presetColor.hue),
    Math.round(presetColor.saturation),
    Math.round(presetColor.brightness)
  )
}

function removePresetColor(id) {
  $("#preset-color-" + id).remove()
}
