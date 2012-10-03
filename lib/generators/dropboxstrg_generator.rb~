require 'rails/generators'
require 'rails/generators/migration'

class CloudstrgGenerator < Rails::Generators::Base
  include Rails::Generators::Migration
  source_root File.expand_path('../../templates', __FILE__)

  def self.next_migration_number(path)
    Time.now.utc.strftime("%Y%m%d%H%M%S%6N")
  end

  def create_model_file
    template "cloudstrglist.rb", "app/models/cloudstrglist.rb"
    template "cloudstrguser.rb", "app/models/cloudstrguser.rb"
    migration_template "create_cloudstrglists.rb", "db/migrate/create_cloudstrglists.rb"
    migration_template "create_cloudstrgusers.rb", "db/migrate/create_cloudstrgusers.rb"
  end
end

