class LineItem < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :product, optional: true #if you want to create association
  belongs_to :cart

  def total_price
    product.price * quantity
  end
end
