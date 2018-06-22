class CreateMotorcycles < ActiveRecord::Migration
  def change
    create_table :motorcycles do |t|
      t.string :make
      t.string :model
      t.integer :year
      t.integer :size
      t.integer :user_id
    end
  end
end
