#= require jquery
#= require jquery-ui
#= require jquery-ujs
#= require bootstrap
#= require select2
#
#= require leihs_admin/pagination
#
#= require riotjs
# $ find . -name "*.tag.haml" -exec haml {} {}.tag \; && riot . all.js && find . -name "*.tag.haml.tag" -exec rm {} \;
#= require ./riotjs_tags/all.js
#
#= require_self

$(document).ready ->
  riot.mount('*')
