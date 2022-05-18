class AddStatusToShifts < ActiveRecord::Migration[7.0]
  def change
    add_column :shifts, :status, :string
  end
end
