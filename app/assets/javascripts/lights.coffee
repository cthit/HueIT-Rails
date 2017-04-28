# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
    $('.update').on 'input', (event) ->
        $(this).parent().find('.update').val(this.value)

    $('#select_all_btn').on 'click', (e) ->
        $('.toggl-switch').prop 'checked', true
    $('#deselect_all_btn').on 'click', (e) ->
        $('.toggl-switch').prop 'checked', false

    $('#toggle_all_btn').on 'click', (e) ->
        $('.toggl-switch').each () ->
            $this = $(this)
            $this.prop 'checked', !$this.prop('checked')

    $('#party_canvas').on 'click', (e) ->
        $.ajax(url: 'lights/party_on_off')
        togglePartyMode()

    $('.bulb').on 'click', (e) ->
      setSliders(parseInt(e.target.dataset.lightId))

    $('#change_btn').on 'click', (e) ->
        e.preventDefault()
        $.post '/lights/multi_update', $("#hue-form").serialize(), (data) ->
            updateLights(data)
            renderLamps()

    $('.link-btn').on 'click', (e) ->
        $.post e.target.dataset.url, (data) ->
            updateLights(data)
            renderLamps()
