require 'rails/generators/base'
# Generates the migrations necessary for APN on Rails.
# This should be run upon install and upgrade of the 
# APN on Rails gem.
# 
#   $ ruby script/generate apn_migrations
class ApnMigrationsGenerator < Rails::Generators::Base
  include Rails::Generators::Migration
  
  #Can't think of a better way to do it, but I'm sure there is.
  @@more_than_one_migration = false
  def self.next_migration_number(dirname)
    if ActiveRecord::Base.timestamped_migrations
      timestamp = Time.now.utc.strftime("%Y%m%d%H%M%S")
      if "%.3d" % current_migration_number(dirname) == timestamp || @@more_than_one_migration
        @@more_than_one_migration = true
        "%.3d" % (current_migration_number(dirname) + 1)
      else
        return timestamp
      end
    else
      "%.3d" % (current_migration_number(dirname) + 1)
    end
  end
  
  def create_migration_files
    timestamp = Time.now.utc.strftime("%Y%m%d%H%M%S")
    db_migrate_path = File.join('db', 'migrate')

    Dir.glob(File.join(File.dirname(__FILE__), 'templates', 'apn_migrations', '*.rb')).sort.each_with_index do |f, i|
      f = File.basename(f)
      f.match(/\d+\_(.+)/)
      timestamp = timestamp.succ
      if Dir.glob(File.join(db_migrate_path, "*_#{$1}")).empty?
        migration_template(File.join(File.dirname(__FILE__), 'templates', 'apn_migrations', f), File.join(db_migrate_path, "#{$1}"), {:collision => :skip})
      end
    end
  end
  
  # def manifest # :nodoc:
  #     #record do |m|
  #       timestamp = Time.now.utc.strftime("%Y%m%d%H%M%S")
  #       db_migrate_path = File.join('db', 'migrate')
  #       
  #      # m.directory(db_migrate_path)
  #       m.directory(db_migrate_path)
  #       
  #       Dir.glob(File.join(File.dirname(__FILE__), 'templates', 'apn_migrations', '*.rb')).sort.each_with_index do |f, i|
  #         f = File.basename(f)
  #         f.match(/\d+\_(.+)/)
  #         timestamp = timestamp.succ
  #         if Dir.glob(File.join(db_migrate_path, "*_#{$1}")).empty?
  #         #  m.file(File.join('apn_migrations', f), 
  #           migration_template (File.join('apn_migrations', f), File.join(db_migrate_path, "#{timestamp}_#{$1}"), {:collision => :skip})
  #         end
  #       end
  #       
  #     # end # record
  #     
  #   end # manifest
  
end # ApnMigrationsGenerator