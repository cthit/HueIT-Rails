# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
    $('.update').on 'input', (event) ->
        $(this).parent().find('.update').val(this.value)

    $('#select_all_btn').on 'click', (e) ->
        $('.checkbox').prop 'checked', true
    $('#deselect_all_btn').on 'click', (e) ->
        $('.checkbox').prop 'checked', false

    $('#toggle_all_btn').on 'click', (e) ->
        $('.checkbox').each () ->
            $this = $(this)
            $this.prop 'checked', !$this.prop('checked')

    $('.party-button').on 'click', (e) ->
        togglePartyMode()

    $('.bulb').on 'click', (e) ->
      setSlidersFromBulb(parseInt(e.target.dataset.lightId))
      draw_hue_canvas()
      draw_sat_canvas()

    $('#change_btn').on 'click', (e) ->
        e.preventDefault()
        $.post '/lights/multi_update', $("#hue-form").serialize(), (data) ->
            updateLights(data)
            renderLamps()

    $('.link-btn').on 'click', (e) ->
        $.post e.target.dataset.url, (data) ->
            if data != ""
                updateLights(data)
                renderLamps()

    $('.update').on 'input', (e) ->
        draw_hue_canvas()
        draw_sat_canvas()

    $('#add-preset-color').on 'click', (e) ->
        $.post '/preset_colors', $("#hue-form").serialize(), (data) ->
            addNewPresetColor(data.preset_colors)
