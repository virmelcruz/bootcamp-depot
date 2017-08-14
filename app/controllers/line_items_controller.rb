class LineItemsController < ApplicationController
  include CurrentCart
  before_action :set_cart, only: [:create]
  before_action :set_line_item, only: [:show, :edit, :update, :destroy] #keyword on rails, like before_destroy, before any action it will call the set_all_line_item

  # GET /line_items
  # GET /line_items.json
  def index #index defines line_items then query all the line items then pass it to it
    @line_items = LineItem.all
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
  end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end

  # GET /line_items/1/edit
  def edit
  end

  # POST /line_items - not api
  # POST /line_items.json - api
  def create
    product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product)
    respond_to do |format| #respond to uses to support type of request
      if @line_item.save
        format.html { redirect_to store_index_url } #redirects to line_item show page passing notice data
        format.js   { @current_item = @line_item }
        format.json { render :show, status: :created, location: @line_item } #like res.json() in node.js that passes back to the call
      else
        format.html { render :new } #redirects to render new page
        format.json { render json: @line_item.errors, status: :unprocessable_entity } #returns an error for api, all models have errors
      end
    end
  end

  # PATCH/PUT /line_items/1 #not rest api
  # PATCH/PUT /line_items/1.json #rest api
  def update
    respond_to do |format|
      if @line_item.update(line_item_params)
        format.html { redirect_to @line_item, notice: 'Line item was successfully updated.' }
        format.json { render :show, status: :ok, location: @line_item }
      else
        format.html { render :edit } 
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    @line_item.destroy
    respond_to do |format|
      format.html { redirect_to line_items_url, notice: 'Line item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      @line_item = LineItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def line_item_params #strong parameters
      params.require(:line_item).permit(:product_id) #filters all just the fields, looking for line_item if valid, permit = checks if there is product_id and cart_id
    end
end
