#= require jquery
#= require jquery.turbolinks
#= require jquery_ujs
#= require shared/bootstrap
#= require shared/underscore
#= require shared/backbone
#= require shared/pnotify.all.min
#= require shared/highlight
#= require shared/d3.min
#= require shared/cal-heatmap.min

# PNotify.prototype.options.styling = "jqueryui"

root = window || @

root.pnotify_xhr = (type, xhr, title=null) ->
  try
    message = xhr.responseJSON.message
  catch error
    message = xhr.responseText

  PNotify.removeAll()

  if type == 'error'
    title ||= 'Uh Oh!'
    new PNotify
      title: title,
      type: type,
      hide: false,
      text: message

  else
    title ||= 'Uh Wow!'
    new PNotify
      title: title,
      type: type,
      hide: true,
      text: message
