class Backend::OrdersController < Backend::BackendController
  
  before_filter :preload
  
  def index
    with = { :inventory_pool_id => current_inventory_pool.id }
    with[:user_id] = @user.id if @user
             
    scope = case params[:filter]
                when "submitted"
                  :sphinx_submitted
                when "approved"
                  :sphinx_approved
                when "rejected"
                  :rejected
              end
    
    @orders = Order.send(scope).search params[:query], { :star => true, :page => params[:page], :per_page => $per_page,
                                                         :with => with }
  end

  def show
      
  end
  
  
  private
  
  def preload
    params[:order_id] ||= params[:id] if params[:id]
    @order = current_inventory_pool.orders.find(params[:order_id]) if params[:order_id]
    @user = current_inventory_pool.users.find(params[:user_id]) if params[:user_id]
  end
  
end
