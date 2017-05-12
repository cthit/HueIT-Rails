function findPresetColor(id) {
  return presetColors.find(function (el) {
    return el.id === id
  })
}

function createPresetColor(id, colors) {
  const $div = $('<div/>')
    .prop('id', 'preset-color-' + id)
    .addClass('preset-color shadow')
    .attr('data-preset-color-id', id)
    .css('background-color', RGBtoCSS(colors))

  const $a = $('<a/>')
    .addClass('remove-preset-color')
    .attr('data-remote', true)
    .prop('rel', 'nofollow')
    .attr('data-method', 'delete')
    .attr('href', '/preset_colors/' + id)
    .click(function(e) {removePresetColor(parseInt(e.currentTarget.parentElement.dataset.presetColorId))})

  const $span = $('<span/>').prop('aria-hidden', true).append("&times;")
  $a.append($span)

  return $div.append($a)
}

function renderPresetColors() {
  presetColors.forEach(function (preset_color) {
    draw('#preset-color-' + preset_color.id, preset_color.hue / 65535, preset_color.saturation / 255, preset_color.brightness / 255)
  })
}

function setSlidersFromPresetColor (id) {
  const presetColor = findPresetColor(id)
  setSliders(
    Math.round(presetColor.hue),
    Math.round(presetColor.saturation),
    Math.round(presetColor.brightness)
  )
}

function addPresetColor(preset_colors) {
  const presetColor = preset_colors[preset_colors.length - 1]
  presetColors = preset_colors
  $(".preset-color-list").append(createPresetColor(presetColor.id, HSVtoRGB(presetColor.hue / 65535, presetColor.saturation / 255, presetColor.brightness / 255)))
}

function removePresetColor(id) {
  $("#preset-color-" + id).remove()
}
