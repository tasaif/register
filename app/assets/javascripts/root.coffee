$ ->
  $('.entry input').on 'keyup', (ev) ->
    key = ev.keyCode
    ENTER_KEY = 13
    if (key == ENTER_KEY)
      money_pattern = /^\d.*\.\d{2}$/
      entry = ev.target.value.trim()
      if (money_pattern.test(entry))
        console.log 'create item'
      else if (entry.length == 12)
        console.log "barcode: #{entry}"
      else
        console.log 'show error'
