module ReactHelper

  def react(name, props, opts = {})
    defaults = { prerender: true }
    react_component("App.React.#{name}", props, defaults.merge(opts))
  end

end
