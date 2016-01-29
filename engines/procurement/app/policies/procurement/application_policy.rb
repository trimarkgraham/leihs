module Procurement
  class ApplicationPolicy
    attr_reader :user

    def initialize(user, application)
      @user = user
    end

    def authenticated?
      not user.nil?
    end

    def admins_defined?
      Access.admins.exists?
    end
  end
end
