class Supplier < ActiveRecord::Base
  audited

  validates_presence_of :name
  validates_uniqueness_of :name, case_sensitive: false

  has_many :items, dependent: :restrict_with_exception

  def to_s
    name
  end

  def self.filter(params)
    suppliers = search(params[:search_term]).order(:name)
    suppliers = suppliers.where(id: params[:ids]) if params[:ids]
    suppliers
  end

  scope :search, lambda { |query|
                 sql = all
                 return sql if query.blank?

                 query.split.each { |q|
                   q = "%#{q}%"
                   sql = sql.where(arel_table[:name].matches(q))
                 }
                 sql
               }

  def as_json(options = nil)
    h = super({ only: [:id, :name] }.merge(options || {}))
    h[:items_count] = items.count
    h[:can_destroy] = h[:items_count].zero? #tmp# can_destroy?
    h
  end
end

