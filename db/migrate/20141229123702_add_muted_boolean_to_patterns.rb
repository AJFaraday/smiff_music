class AddMutedBooleanToPatterns < ActiveRecord::Migration
  def change
    add_column :patterns, :muted, :boolean, :default => false
  end
end
