# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
	$('.update').on 'change', (event) ->
		console.log event 
		$(this).parent().find('.update').val(this.value)