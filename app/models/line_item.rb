class LineItem < ApplicationRecord
  belongs_to :product #if you want to create association
  belongs_to :cart
end
