class AddTypeAndSynthIdToPattern < ActiveRecord::Migration
  def change
    add_column :patterns, :purpose, :string, default: 'event'
    add_column :patterns, :synth_id, :integer
  end
end
