# frozen_string_literal: true

# lib/tasks/routes.rake

namespace :routes do
  desc 'Print out all defined routes'
  task print: :environment do
    Rails.application.routes.routes.each do |route|
      puts route.path.spec
    end
  end
end
