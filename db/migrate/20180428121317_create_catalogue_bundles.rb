class CreateCatalogueBundles < ActiveRecord::Migration[5.1]
  def up
    create_table :catalogue_bundles do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.integer :quantity, null: false
      t.decimal :price, precision: 5, scale: 2, null: false
    end
  end

  def down
    drop_table :bundles
  end
end
