seeds = YAML::load_file(File.join(Rails.root, 'db', 'seeds.yml'))

TimelineView.delete_all
seeds['views'].each {|v| TimelineView.create(v) }

Category.delete_all
seeds['categories'].each {|c| Category.create(c) }

