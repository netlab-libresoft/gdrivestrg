class CreateGdrivestrgfields < ActiveRecord::Migration
  def up
    add_column :cloudstrgusers, :gdrive_refresh_token, :string 
    add_column :cloudstrgusers, :gdrive_expires_in, :integer 
    add_column :cloudstrgusers, :gdrive_issued_at, :date
    
    Cloudstrglist.create :plugin_name => "gdrive"
  end

  def down
    remove_column :cloudstrgusers, :gdrive_refresh_token
    remove_column :cloudstrgusers, :gdrive_expires_in
    remove_column :cloudstrgusers, :gdrive_issued_at

    Cloudstrglist.delete_all :plugin_name => "gdrive"
  end
end
