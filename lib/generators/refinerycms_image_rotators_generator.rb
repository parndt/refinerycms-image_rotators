require 'rails/generators/migration'

class RefinerycmsImageRotatorsGenerator < Rails::Generators::NamedBase
  include Rails::Generators::Migration
  
  source_root File.expand_path('../templates/', __FILE__)
  argument :name, :type => :string, :default => 'image_rotators', :banner => ''
  argument :attributes, :type => :array, :default => ["name:string"]

  def generate
    # seed file
    template 'db/seeds/image_rotators.rb', Rails.root.join('db/seeds/refinerycms-image_rotators.rb')

    migration_template('db/migrate/create_image_rotators.rb', 'db/migrate/create_image_rotators.rb')

     puts "------------------------"
     puts "Now run:"
     puts "rake db:migrate"
     puts "------------------------"
  end

  # Implement the required interface for Rails::Generators::Migration.
  def self.next_migration_number(dirname) #:nodoc:
    next_migration_number = current_migration_number(dirname) + 1
    if ActiveRecord::Base.timestamped_migrations
      [Time.now.utc.strftime("%Y%m%d%H%M%S"), "%.14d" % next_migration_number].max
    else
      "%.3d" % next_migration_number
    end
  end
  
end

# Below is a hack until this issue:
# https://rails.lighthouseapp.com/projects/8994/tickets/3820-make-railsgeneratorsmigrationnext_migration_number-method-a-class-method-so-it-possible-to-use-it-in-custom-generators
# is fixed on the Rails project.

require 'rails/generators/named_base'
require 'rails/generators/migration'
require 'rails/generators/active_model'
require 'active_record'

module ActiveRecord
  module Generators
    class Rails::Generators::NamedBase #:nodoc:
      include Rails::Generators::Migration

      # Implement the required interface for Rails::Generators::Migration.
      def self.next_migration_number(dirname) #:nodoc:
        next_migration_number = current_migration_number(dirname) + 1
        if ActiveRecord::Base.timestamped_migrations
          [Time.now.utc.strftime("%Y%m%d%H%M%S"), "%.14d" % next_migration_number].max
        else
          "%.3d" % next_migration_number
        end
      end
    end
  end
end