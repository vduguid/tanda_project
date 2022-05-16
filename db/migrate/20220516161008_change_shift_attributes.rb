class ChangeShiftAttributes < ActiveRecord::Migration[7.0]
  def change
    remove_column :shifts, :start 
    add_column :shifts, :start, :datetime
    remove_column :shifts, :end 
    add_column :shifts, :finish, :datetime
    remove_column :shifts, :date 
  end
end
