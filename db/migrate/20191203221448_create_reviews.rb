class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.integer :rating
      t.string  :comment
      t.integer :customer_id
      t.integer :restaurant_id
    end
  end
end
