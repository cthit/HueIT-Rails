# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
light_indices = [2..7]

$ ->
    $('.update').on 'input', (event) ->
        $(this).parent().find('.update').val(this.value)

    $('#select_all_btn').on 'click', (e) ->
        document.getElementById("lights_"+i).checked = true for i in light_indices
    $('#deselect_all_btn').on 'click', (e) ->
        document.getElementById("lights_"+i).checked = false for i in light_indices

    $('#toggle_all_btn').on 'click', (e) ->
        document.getElementById("lights_" + i).checked = !$("#lights_" + i + ":checked").val() for i in light_indices

    $('#party_canvas').on 'click', (e) ->
        $.ajax(url: 'lights/party_on_off')
        togglePartyMode()
