class AddConstructorToSynth < ActiveRecord::Migration
  def change
    add_column(:synths, :constructor, :string, default: 'SimpleSynth')
  end
end
