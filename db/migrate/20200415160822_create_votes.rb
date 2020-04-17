class CreateVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.integer :value, null: false
      t.references :user, null: false, foreign_key: true
      t.references :votable, polymorphic: true

      t.timestamps
    end
  end
end
