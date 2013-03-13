class AddUserIdToGdrivestrgFolders < ActiveRecord::Migration
  def change
    add_column :gdrivestrg_folders, :user_id, :integer
  end
end
