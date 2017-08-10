class Cart < ApplicationRecord
	has_many :line_items, dependent: :destroy #associate cart with line_items, dependent destroy is like cascade?

	def add_product(product) #method name add_product
		current_item = line_items.find_by(product_id: product.id) #checks from all line_items using id
		if current_item #if there is line_item just add +1
				current_item.quantity += 1
		else #if not push it to the line_item
				current_item = line_items.build(product_id: product.id)
		end

		current_item
	end

	def total_price
		line_items.to_a.sum { |item| item.total_price }
	end
end
