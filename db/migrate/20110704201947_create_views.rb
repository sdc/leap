class CreateViews < ActiveRecord::Migration
  def self.up
    create_table :views do |t|
      t.string :transitions
      t.string :events
      t.string :icon_url
      t.string :affiliations
      t.string :name
      t.string :label
      t.string :controls
      t.integer :position
      t.timestamps
    end
    View.create(
      :label       => "All",
      :name        => "all",
      :transitions => ["create","start","overdue","complete","drop"],
      :events      => ["Attendance","ContactLog","PersonCourse","Disciplinary","Goal","Note","Target","Review","ReviewLine","Qualification"],
      :icon_url    => "icons/events.png",
      :affiliations=> ["staff","student","affiliate"],
      :controls    => nil,
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
      :position    => 3
    )
    View.create(
      :label       => 'Contact Logs',
      :name        => 'contact_logs',
      :transitions => ['create'],
      :events      => ['ContactLog'],
      :icon_url    => 'icons/contact_logs.png',
      :affiliations => ['staff','student','affiliate'],
      :controls    => ['contact_logs/new.html.haml'],
      :position    => 4
    )
    View.create(
      :label       => 'Positive Intervention',
      :name        => 'intevention',
      :transitions => ['create'],
      :events      => ['Disciplinary'],
      :icon_url    => 'icons/disciplinaries.png',
      :affiliations => ['staff','student','affiliate'],
      :controls    => ['disciplinaries/new.html.haml'],
      :position    => 5
    )
    View.create(
      :label       => 'Reviews',
      :name        => 'reviews',
      :transitions => ['create'],
      :events      => ['Review','ReviewLine'],
      :icon_url    => 'icons/reviews.png',
      :affiliations => ['staff'],
      :controls    => ['reviews/new.html.haml'],
      :position    => 6
    )
  end

  def self.down
    drop_table :views
  end
end
