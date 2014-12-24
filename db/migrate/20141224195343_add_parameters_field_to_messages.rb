class AddParametersFieldToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :parameters, :string
  end
end
