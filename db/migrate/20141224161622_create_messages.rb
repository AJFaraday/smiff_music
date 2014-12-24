class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :source_text
      t.string :source_type
      t.string :source
      t.string :action
      t.integer :status
      t.integer :message_format_id

      t.timestamps
    end
  end
end
