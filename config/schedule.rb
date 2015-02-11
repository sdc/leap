set :output, "log/cron_log.log"

every 1.day, at: '10:10pm' do
  runner "Person.resync('14/15')"
end

every 4.hours do
  runner "MdlGradeTrack.import_all"
  runner "MdlBadge.import_all"
end
