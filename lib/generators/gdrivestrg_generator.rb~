require 'rails/generators'
require 'rails/generators/migration'

class CloudstrgGenerator < Rails::Generators::Base
  include Rails::Generators::Migration
  source_root File.expand_path('../../templates', __FILE__)

  def self.next_migration_number(path)
    Time.now.utc.strftime("%Y%m%d%H%M%S%6N")
  end

  def create_model_file
    migration_template "create_dropboxstrgfields.rb", "db/migrate/create_dropboxstrgfields.rb"
  end
end

