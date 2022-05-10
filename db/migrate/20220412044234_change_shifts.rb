class ChangeShifts < ActiveRecord::Migration[7.0]
  def change
    remove_reference :shifts, :user, null: false, foreign_key: true
    add_reference :shifts, :user, null: true, foreign_key: true
  end
end
