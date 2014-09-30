set :output, "log/cron_log.log"

every 1.day, :at => '10:10pm' do
  runner "Person.resync('14/15')"
end
