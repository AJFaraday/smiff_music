class AddWeightToMessageFormats < ActiveRecord::Migration
  def change
    add_column :message_formats, :weight, :integer, default: 0
  end
end
