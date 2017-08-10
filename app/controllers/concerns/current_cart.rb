module CurrentCart #when we create a utility helper we use module not class, we just need to include it.
    private #private = can only access same module or same class
    def set_cart #by default we can access session
        @cart = Cart.find(session[:cart_id]) #.find is method of Active Record, 
    rescue ActiveRecord::RecordNotFound # = when no found return
        @cart = Cart.create
        session[:cart_id] = @cart.id #creates new cart
    end
end