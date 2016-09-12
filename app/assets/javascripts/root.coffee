$ ->
  $('form.entry').on 'submit', (ev) ->
    entry = $(ev.target).find('input.data').val().trim()
    money_pattern = /^\d.*\.\d{2}$/
    if (money_pattern.test(entry))
      console.log "dollar_amount"
    else
      console.log "barcode: #{entry}"
    return true
