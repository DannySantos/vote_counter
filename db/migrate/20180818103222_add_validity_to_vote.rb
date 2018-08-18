class AddValidityToVote < ActiveRecord::Migration[5.2]
  def change
    add_column :votes, :validity, :integer
  end
end
