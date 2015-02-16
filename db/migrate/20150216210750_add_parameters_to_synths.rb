class AddParametersToSynths < ActiveRecord::Migration
  def change
    add_column :synths, :parameters, :string
  end
end
