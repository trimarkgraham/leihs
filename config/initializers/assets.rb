# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Paths, that should be browserified. We browserify everything, that
# matches (===) one of the paths. So you will most likely put lambdas
# regexes in here.
#
# By default only files in /app and /node_modules are browserified,
# vendor stuff is normally not made for browserification and may stop
# working.
# config.browserify_rails.paths << %r{vendor/assets/javascripts/module.js}

# we `require` locale yaml files with browserify, so explicitly watch them:
config.watchable_files.concat(Dir["#{Rails.root}/locale/**/*.yml"])

# Environments, in which to generate source maps
# The default is none
config.browserify_rails.source_map_environments << 'development'

# Command line options used when running browserify
# NOTE: all browserify config itself is in `package.json`
# config.browserify_rails.commandline_options = []

# Should the node_modules directory be evaluated for changes on page load
#
# The default is `false`
config.browserify_rails.evaluate_node_modules = true

# react-rails config:
# Settings for the pool of renderers:
# config.react.server_renderer_pool_size  ||= 1  # ExecJS doesn't allow more than one on MRI
# config.react.server_renderer_timeout    ||= 20 # seconds
# config.react.server_renderer = React::ServerRendering::SprocketsRenderer
config.react.server_renderer_options = {
  files: ['react-server-side.js'], # files to load for prerendering
  replay_console: false,                # if true, console.* will be replayed client-side
}
# since we use non-standard `.cjsx` files, we need to explicitly watch them
config.watchable_files.concat(Dir["#{Rails.root}/app/assets/javascripts/**/*.cjsx*"])
config.react.variant = :production


# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# NOTE: JS: all top-level files are bundles, rest are modules
Rails.application.config.assets.precompile += %w( javascripts/*.*
                                                  borrow.js
                                                  manage.js
                                                  application.css
                                                  print.css
                                                  i18n/locale/*
                                                  simile_timeline/*
                                                  timeline.css
                                                  upload.js
                                                  timecop/timecop-0.1.1.js
                                                )
