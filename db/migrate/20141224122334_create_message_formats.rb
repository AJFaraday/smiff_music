class CreateMessageFormats < ActiveRecord::Migration
  def change
    create_table :message_formats do |t|
      t.string :name
      t.string :regex
      t.string :action
      t.string :variables

      t.timestamps
    end
  end
end
