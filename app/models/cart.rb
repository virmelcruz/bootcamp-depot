class Cart < ApplicationRecord
    has_many :line_items, dependent: :destroy #associate cart with line_items, dependent destroy is like cascade?
end
