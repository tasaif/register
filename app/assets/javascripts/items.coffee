$ ->
  $('input').get(1).focus()
  $('form#new_item input').on 'keydown', (ev) ->
    key = ev.keyCode
    ENTER = 13
    if (key == ENTER)
      next = $(@).parent().next()
      if (next.length == 0)
        $(@).closest('form').submit()
        return true
      else
        next.find("input").last().focus()
        return false
