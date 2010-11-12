Dir.glob(File.join(File.dirname(__FILE__), 'apn_on_rails', '**/*.rb')).sort.each do |f|
  require File.expand_path(f)
end

class ApnOnRailsRailtie < Rails::Railtie
  generators do
    require File.join(File.dirname(__FILE__) , '..', 'generators/apn_migrations_generator.rb')
  end
  rake_tasks do
    load File.join(File.dirname(__FILE__), 'apn_on_rails/tasks/apn.rake')
  end
end