$ ->
  # Only run this script on root controller's neutral action
  if ($("body[data-action='neutral'][data-controller='root']").length == 0)
    return

  set_receipt_id_callback = (ev, receipt_id) ->
    $container = $(@)
    $receipt_id_inputs = $container.find("input[name='receipt_id']")
    $receipt_id_inputs.val(receipt_id)

  set_scan_display_callback = (ev, selector) ->
    $container = $(@)
    $container.children().hide()
    $container.find(selector).show()

  update_receipt_callback = (ev, receipt_id) ->
    $form = $("[action='receipt_display']")
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
        @trigger 'set_receipt_id', data.receipt.id
        @trigger 'set_scan_display', "[action='add_item']"
        @trigger 'update_receipt_display', data.receipt.id
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
          create_item_form = $("form[action='create_item']")
          if (item.id == null)
            create_item_form.find("input[name='barcode']").val(item.barcode)
            $("div.scancode").trigger 'set_scan_display', "[action='create_item']"
          else if (data.weight_requested)
            $(this).find("[name='weight']")
              .attr('disabled', false)
              .attr('hidden', false)
          else
            $(this).find("[name='weight']")
              .attr('disabled', true)
              .attr('hidden', true)
            @trigger 'set_receipt_id', receipt.id
            @trigger 'update_receipt_display', receipt.id
          #console.log data
          #console.log textStatus
          #console.log jqXHR
        error: (jqXHR, textStatus, errorThrown) ->
          console.log jqXHR
          console.log textStatus
          console.log errorThrown
    return false

  weight_ticked_callback = (ev) ->
    $form = $(@).closest("form")
    $weight = $form.find(".weight")
    $weight.attr('hidden', !@checked)
    true

  $("form[action='add_item']").on 'submit', add_item_submit_callback
  $("form[action='create_item']").on 'submit', create_item_submit_callback
  $("form[action='create_item']").on 'change', "input[name='pp']", null, weight_ticked_callback
  $("div.scancode").on 'update_receipt_display', update_receipt_callback
  $("div.scancode").on 'set_scan_display', set_scan_display_callback
  $("div.scancode").on 'set_receipt_id', set_receipt_id_callback
