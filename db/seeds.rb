    View.create(
      :label       => "All",
      :name        => "all",
      :transitions => ["create","start","overdue","complete","drop","to_start"],
      :events      => ["Attendance","ContactLog","PersonCourse","Disciplinary","Goal","Note","Target","Review","ReviewLine","Qualification","SupportRequest","SupportHistory","InitialReview","SupportStrategy","Absence"],
      :icon_url    => "icons/events.png",
      :affiliations=> ["student","affiliate"],
      :controls    => nil,
      :in_list     => true,
      :position    => 1
    )
    View.create(
      :label       => "All",
      :name        => "all",
      :transitions => ["create","start","overdue","complete","drop","hidden","to_start"],
      :events      => ["Attendance","ContactLog","PersonCourse","Disciplinary","Goal","Note","Target","Review","ReviewLine","Qualification","SupportRequest","SupportHistory","InitialReview","SupportStrategy","Absence"],
      :icon_url    => "icons/events.png",
      :affiliations=> ["staff"],
      :controls    => nil,
      :in_list     => true,
      :position    => 1
    )
    View.create(
      :label       => "Courses",
      :name        => "courses",
      :transitions => ["start"],
      :events      => ["PersonCourse"],
      :icon_url    => 'icons/courses.png',
      :affiliations => ['staff','student','affiliate'],
      :controls    => nil,
      :in_list     => true,
      :position    => 2
    )
    View.create(
      :label       => 'Targets',
      :name        => 'targets',
      :transitions => ['overdue'],
      :events      => ['Target'],
      :icon_url    => 'icons/targets.png',
      :affiliations => ['staff','student','affiliate'],
      :controls    => nil,
      :in_list     => true,
      :position    => 3
    )
    View.create(
      :label       => 'Contact Logs',
      :name        => 'contact_logs',
      :transitions => ['create'],
      :events      => ['ContactLog'],
      :icon_url    => 'icons/contact_logs.png',
      :affiliations => ['staff','student','affiliate'],
      :controls    => 'events/create/contact_log',
      :in_list     => true,
      :position    => 4
    )
    View.create(
      :label       => 'Positive Intervention',
      :name        => 'intevention',
      :transitions => ['create'],
      :events      => ['Disciplinary'],
      :icon_url    => 'icons/disciplinaries.png',
      :affiliations => ['staff','student','affiliate'],
      :controls    => 'events/create/disciplinary',
      :in_list     => true,
      :position    => 5
    )
    View.create(
      :label       => "Qualifications",
      :name        => "qualifications",
      :transitions => ["create"],
      :events      => ["Qualification"],
      :icon_url    => "icons/qualifications.png",
      :affiliations => ["staff","student","affiliate"],
      :controls    => nil,
      :in_list     => true,
      :position    => 6
    )
    View.create(
      :label       => 'Reviews',
      :name        => 'reviews',
      :transitions => ['create','hidden','start'],
      :events      => ['Review'],
      :icon_url    => 'icons/reviews.png',
      :affiliations => ['staff','student','affiliate'],
      :in_list     => true,
      :controls    => 'events/create/review',
      :position    => 7
    )
    View.create(
      :label       => 'Support',
      :name        => 'support',
      :transitions => ['create'],
      :events      => ['SupportRequest','SupportHistory',"SupportStrategy"],
      :icon_url    => 'icons/support_requests.png',
      :affiliations => ['staff','student','affiliate'],
      :controls    => {"Support Request" => 'events/create/support_request', "Support History" => 'events/create/support_history'},
      :in_list     => true,
      :position    => 8
    )
    View.create(
      :name        => "timetable",
      :transitions => ['complete','start','overdue','create'],
      :events      => ['Qualifications','Attendance', "Absence"],
      :affiliations=> ['staff','student','affiliate'],
      :in_list     => false
    )
