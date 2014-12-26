class CreateSystemSettings < ActiveRecord::Migration
  def change
    create_table :system_settings do |t|
      t.string :name
      t.string :tip
      t.string :value

      t.timestamps
    end
  end
end
