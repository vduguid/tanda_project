class AddOvernightToShift < ActiveRecord::Migration[7.0]
  def change
    add_column :shifts, :overnight, :boolean
  end
end
