$ ->
  # Only run this script on root controller's neutral action
  if ($("body[data-action='neutral'][data-controller='root']").length == 0)
    return

  window.register = {}
  window.register.current_receipt = -1

  new_item_submit_callback = (ev) ->
    form = ev.target
    $form = $(form)
    data = $form.serialize()
    $.ajax
      method: 'POST'
      url: form.action
      data: data
      context: $form
      success: (data, textStatus, jqXHR) ->
        $new_item_form = $(data)
        console.log data
        console.log textStatus
        console.log jqXHR
        #@replaceWith($new_item_form)
        #$new_item_form.submit new_item_submit_callback
      error: (jqXHR, textStatus, errorThrown) ->
        console.log jqXHR
        console.log textStatus
        console.log errorThrown
    return false

  add_item_submit_callback = (ev) ->
    form = ev.target
    $form = $(form)
    source = $form.find('input.source').val().trim()
    if (source == "barcode")
      data = $form.serialize()
      $.ajax
        method: 'POST'
        url: form.action
        data: data
        context: $form
        success: (data, textStatus, jqXHR) ->
          item = data 
          debugger
          0
          #console.log data
          #console.log textStatus
          #console.log jqXHR
        error: (jqXHR, textStatus, errorThrown) ->
          console.log jqXHR
          console.log textStatus
          console.log errorThrown
    return false

  $("form[action='add_item']").on 'submit', add_item_submit_callback
