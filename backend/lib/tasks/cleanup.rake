# rake weather:cleanup
# This rake task will remove all weather records older than 1 day.
namespace :weather do
  desc "Remove weather records older than 1 day"
  task cleanup: :environment do
    Weather.cleanup_old_records
    puts "Old weather records cleaned up"
  end
end
