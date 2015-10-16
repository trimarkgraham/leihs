###

Internationalisation

This script provides functionalities for internationalisation in JavaScript.
 
###

window.i18n.jed = new Jed {"domain": "leihs", locale_data: i18n.locale_data}

window._jed = (args...)->

  isKeyPresent = (key)-> i18n.jed.options.locale_data.leihs[key]? and key.length

  if typeof args[0] == "number"
    if (key = args[1]) and isKeyPresent(key)
      i18n.jed.translate(args[1]).ifPlural(args[0], args[2]).fetch args[3]
    else
      key
  else
    if (key = args[0]) and isKeyPresent(key)
      i18n.jed.translate(args[0]).fetch args[1]
    else
      key
