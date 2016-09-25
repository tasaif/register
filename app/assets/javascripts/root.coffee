$ ->
  # Only run this script on root controller's neutral action
  if ($("body[data-action='neutral'][data-controller='root']").length == 0)
    return

  update_receipt_display = (receipt_id) ->
    $form = $("form[action='receipt_display']").first()
    $receipt_input = $form.find("input[name='receipt_id']")
    $receipt_input.val receipt_id
    data = $form.serialize()
    $.ajax
      method: 'POST'
      url: 'update_receipt_display'
      data: data
      success: (data, textStatus, jqXHR) ->
        $receipt_display = $("form[action='receipt_display']").first()
        $receipt_display.replaceWith(data)
        #$new_item_form = $(data)
        #console.log data
        #console.log textStatus
        #console.log jqXHR
      error: (jqXHR, textStatus, errorThrown) ->
        console.log jqXHR
        console.log textStatus
        console.log errorThrown
    return false

  create_item_submit_callback = (ev) ->
    form = ev.target
    $form = $(form)
    data = $form.serialize()
    $.ajax
      method: 'POST'
      url: form.action
      data: data
      context: $form
      success: (data, textStatus, jqXHR) ->
        update_receipt_display data.receipt.id
        #$new_item_form = $(data)
        #console.log data
        #console.log textStatus
        #console.log jqXHR
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
          receipt = data.receipt
          item = data.item
          add_item_form = $("form[action='add_item']")
          create_item_form = $("form[action='create_item']")
          if (item.id == null)
            create_item_form.find("input[name='barcode']").val(item.barcode)
            add_item_form.hide()
            create_item_form.show()
          else
            update_receipt_display receipt.id
          #console.log data
          #console.log textStatus
          #console.log jqXHR
        error: (jqXHR, textStatus, errorThrown) ->
          console.log jqXHR
          console.log textStatus
          console.log errorThrown
    return false

  $("form[action='add_item']").on 'submit', add_item_submit_callback
  $("form[action='create_item']").on 'submit', create_item_submit_callback
