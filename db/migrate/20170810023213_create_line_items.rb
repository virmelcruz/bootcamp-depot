class CreateLineItems < ActiveRecord::Migration[5.1]
  def change
    create_table :line_items do |t|
      t.references :product, foreign_key: true #reference to product tables
      t.belongs_to :cart, foreign_key: true #belongs_to reference to cart 

      t.timestamps
    end
  end
end
