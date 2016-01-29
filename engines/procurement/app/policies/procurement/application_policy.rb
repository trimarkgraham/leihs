module Procurement
  class ApplicationPolicy
    attr_reader :user, :record

    ############# PUNDIT DEFAULTS ##################

    def initialize(user, record = nil)
      raise Pundit::NotAuthorizedError, 'You are not logged in' unless user
      @user = user
      @record = record
    end

    def index?
      false
    end

    def show?
      scope.where(:id => record.id).exists?
    end

    def create?
      false
    end

    def new?
      create?
    end

    def update?
      false
    end

    def edit?
      update?
    end

    def destroy?
      false
    end

    def scope
      Pundit.policy_scope!(user, record.class)
    end

    class Scope
      attr_reader :user, :scope

      def initialize(user, scope)
        @user = user
        @scope = scope
      end

      def resolve
        scope
      end
    end

    ################################################

    private

    def admin?
      Access.admin?(user)
    end
  end
end
