class AddPitchArrayToSynth < ActiveRecord::Migration
  def change
    add_column :synths, :pitches, :string
  end
end
