class SetLeaderIdToNullable < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :team_id, :integer, :null => true
  end
end
