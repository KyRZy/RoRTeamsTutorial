class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      t.string :name
      t.string :encrypted_password
      t.string :salt
      t.integer :leader_id

      t.timestamps
    end
  end
end
