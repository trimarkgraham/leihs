module Procurement
  module ApplicationHelper

    # override money-rails helper
    def money_without_cents_and_with_symbol(value)
      number_to_currency(value.to_i, unit: "#{value.currency} ", separator: ".", delimiter: "'", precision: 0)
    end

  end
end
