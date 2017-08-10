class LineItem < ApplicationRecord
  belongs_to :product #if you want to create association
  belongs_to :cart

  def total_price
    product.price * quantity
  end
end
