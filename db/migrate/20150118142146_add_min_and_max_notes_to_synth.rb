class AddMinAndMaxNotesToSynth < ActiveRecord::Migration
  def change
    add_column :synths, :min_note, :integer
    add_column :synths, :max_note, :integer
  end
end
