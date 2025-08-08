class AddReactionTypeToReactions < ActiveRecord::Migration[7.2]
  def change
    add_column :reactions, :reaction_type, :string
  end
end
