module ReactHelper

  def react(name, props, opts = {})
    defaults = { prerender: true }
    react_component(name, props, defaults.merge(opts))
  end

end
