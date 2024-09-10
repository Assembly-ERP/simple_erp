# clear run: crontab -r
# update cron: whenever --update-crontab
# update cron development: whenever --update-crontab --set environment='development'

set :output, "log/cron.log"

# Run every midnight
every '0 0 * * *' do
  runner "puts 'Midnight Runner'"
  runner "puts Time.now"
  runner "Order.recalculate_price"
end

# # Run every midnight
# every 1.minute do
#   runner "puts 'Midnight Runner'"
#   runner "puts Time.now"
#   runner "Order.recalculate_price"
# end

# Learn more: http://github.com/javan/whenever
