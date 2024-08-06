# frozen_string_literal: true

# lib/tasks/migration_generator.rake
namespace :db do
  desc 'Generate migrations for a specific table based on its current schema'
  task :generate_migration, [:table_name] => :environment do |_t, args|
    require 'fileutils'
    table_name = args[:table_name]
    columns = ActiveRecord::Base.connection.columns(table_name)

    # Directory where migrations are stored
    migration_dir = Rails.root.join('db/migrate')

    # Regex to match migration files that add columns to the specific table
    regex = Regexp.new("add_columns_to_#{table_name.downcase}.rb")

    # Delete previous migration files that match the regex
    Dir.entries(migration_dir).each do |file|
      if file.match(regex)
        puts "Deleting old migration file: #{file}"
        FileUtils.rm(migration_dir.join(file))
      end
    end

    timestamp = Time.zone.now.strftime('%Y%m%d%H%M%S')
    migration_filename = "#{timestamp}_add_columns_to_#{table_name}.rb"
    migration_path = migration_dir.join(migration_filename)

    File.open(migration_path, 'w') do |file|
      file.puts "class AddColumnsTo#{table_name.camelize} < ActiveRecord::Migration[6.0]"
      file.puts '  def change'
      columns.each do |column|
        file.puts "    add_column :#{table_name}, :#{column.name}, :#{column.type}"
      end
      file.puts '  end'
      file.puts 'end'

      puts "Migration generated: #{migration_filename}"
    end
  end
end
