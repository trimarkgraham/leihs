require 'rails-assets-bootstrap'
require 'rails-assets-jquery-tokeninput'
require 'rails-assets-bootstrap-multiselect'
# require "font-awesome-sass"
require 'acts_as_tree'
require 'paperclip'
require 'remotipart'

module Procurement
  class Engine < ::Rails::Engine
    isolate_namespace Procurement

    initializer :append_migrations do |app|
      unless app.root.to_s == root.to_s
        config.paths['db/migrate'].expanded.each do |path|
          app.config.paths['db/migrate'].push(path)
        end
      end
    end

    initializer 'engine.assets.precompile' do |app|
      app.config.assets.precompile += %w(procurement/application.css
                                         procurement/application.js)
    end

  end
end
