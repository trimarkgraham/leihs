require "rails-assets-bootstrap"
# require "font-awesome-sass"
require "rails-assets-select2"
require "react-rails"

module LeihsAdmin
  class Engine < ::Rails::Engine
    isolate_namespace LeihsAdmin

    initializer "engine.assets.precompile" do |app|
      app.config.assets.precompile += %w(leihs_admin/admin.css
                                         leihs_admin/admin.js)
    end

  end
end
