seeds = YAML::load_file(File.join(Rails.root, 'db', 'seeds.yml'))

TimelineView.delete_all
seeds['views'].each do |v|
  TimelineView.create(v)
end
