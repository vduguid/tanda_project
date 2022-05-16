class DropOrgReference < ActiveRecord::Migration[7.0]
  def change
    remove_reference :shifts, :organization, null: false, foreign_key: true
  end
end
