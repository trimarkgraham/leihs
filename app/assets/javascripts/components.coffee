###
For server-side render, only this file is loaded, so needs to include dependencies!
Alternative: configuring react-rails to directly use the application.js,
but that breaks as soon as a library is loaded that doesn't like
to be in a non-browser environment (like accessing `document` etc).

```rb
Rails.application.config.react.server_renderer_options = {
  files: ['application.js'], # files to load for prerendering
  replay_console: true,      # if true, console.* will be replayed client-side
}
```
###

# Dependencies for react components
#= require jed/jed
#= require_tree ./i18n/locale
#= require_tree ./i18n/formats
#= require lib/i18n
#= require moment

# all the react components. they need to attach themselfes to `window`
#= require_tree ./components
