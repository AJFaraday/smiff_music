class RemoveOscTypeFromSynths < ActiveRecord::Migration
  def change
    remove_column :synths, :osc_type, :string
  end
end
