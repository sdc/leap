seeds = YAML::load_file(File.join(Rails.root, 'db', 'seeds.yml'))

View.create(seeds["views"])
