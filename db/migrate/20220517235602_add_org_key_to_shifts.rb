class AddOrgKeyToShifts < ActiveRecord::Migration[7.0]
  def change
    add_reference :shifts, :organization, null: true, foreign_key: true
  end
end
