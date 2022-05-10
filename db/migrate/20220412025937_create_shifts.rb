class CreateShifts < ActiveRecord::Migration[7.0]
  def change
    create_table :shifts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :date
      t.string :start
      t.string :end
      t.integer :break
      t.references :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
