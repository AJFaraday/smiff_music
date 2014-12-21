class CreatePatterns < ActiveRecord::Migration
  def change
    create_table :patterns do |t|
      t.string :name
      t.integer :step_size
      t.integer :step_count
      t.string :instrument_name
      t.integer :bits
      t.boolean :active

      t.timestamps
    end
  end
end
