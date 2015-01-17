class CreateSynths < ActiveRecord::Migration
  def change
    create_table :synths do |t|
      t.string :name
      t.string :osc_type
      t.float :attack_time
      t.float :decay_time
      t.float :sustain_level
      t.float :release_time
      t.boolean :muted
      t.integer :step_size
      t.integer :step_count

      t.timestamps
    end
  end
end
