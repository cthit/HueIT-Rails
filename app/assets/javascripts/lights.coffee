# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
	$('.update').on 'input', (event) ->
		console.log event
		$(this).parent().find('.update').val(this.value)

$ ->
	$('#select_all_btn').on 'click', (e) ->
		document.getElementById("lights_"+i).checked = true for i in [1..6]
$ ->
	$('#deselect_all_btn').on 'click', (e) ->
		document.getElementById("lights_"+i).checked = false for i in [1..6]

$ ->
  $('#party_canvas').on 'click', (e) ->
    $.ajax(url: 'lights/party_on_off')
    togglePartyMode()
