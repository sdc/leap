class InitialReview < Eventable

  attr_protected
  include ActiveModel::ForbiddenAttributesProtection
  
  # attr_accessible :body, :created_at, :created_by_id, :progress_id, :target_grade

  validate :check_unique
  belongs_to :person, :foreign_key => "created_by_id"
  belongs_to :progress, :foreign_key => "progress_id"
  before_save :set_values
  validates :body, :presence => true

  after_create do |line|
    line.events.create!(:event_date => created_at, :transition => :create, :person_id => person_id)
  end

  def set_values
  	self.created_at ||= Time.now
  	self.created_by_id ||= Person.user.id
  end

  def status
    return :complete
  end

  def icon_class
    "fa-clipboard"
  end

  def check_unique
    if InitialReview.exists? ["progress_id = ? AND id != ?", self.progress_id, self.id]
      self.errors.add(:progress_id, 'Error, please contact IT')
    end
  end

  def pretty_created_at
    return self.created_at.to_formatted_s(:long)
  end

  def pretty_body
    return self[:body].blank? ? 'No comments' : self[:body]
  end

  def countdown_enddate
    enddate = self.updated_at + Settings.par_edit_window.to_i if Settings.par_window_type == "Edit Window"
    enddate = DateTime.strptime( InitialReview::par_date_range()[:to] + ' 23:59:59', '%d/%m/%Y %T' ) if Settings.par_window_type == "Date Range" && InitialReview::par_date_range().present? && InitialReview::par_date_range()[:to].present?
    return enddate.strftime('%b, %d, %Y, %H:%M') if enddate.present?
    return nil
  end

  def is_editable
    return true if ( Person.user.superuser? or Person.user.admin? )
    # return false if ( Person.user.id != self.created_by_id && Settings.par_window_type.present? )
    return ( (Time.now - Settings.par_edit_window.to_i) < self.updated_at ) if Settings.par_window_type == "Edit Window"
    return ( InitialReview::par_date_range_active() ) if Settings.par_window_type == "Date Range"
    return true
  end

  private

  def self.par_is_active?
    return false if ( Settings.par_restrict_active == 'on' && !Settings.par_active.split(',').reject(&:empty?).include?('I') )
    return true
  end

  def self.par_is_enabled?
    return true if Person.user.superuser?
    return false if !Person.user.staff?
    return false if !par_is_active?
    par_date_range_active()
  end

  def self.par_date_range_active
    return true if !Settings.par_restrict_date_ranges.split(',').reject(&:empty?).include?('I')
    par_date_range().present?
  end

  def self.par_date_range
    par_dates = []
    Settings.par_date_ranges.split("|").each{|x| b=x.split(';'); par_dates << { :rev => b[0], :from => b[1], :to => b[2] } if b[0] == 'I' && ( b[1].blank? || Date.strptime(b[1], '%d/%m/%Y') <= Date.today ) && ( b[2].blank? || Date.strptime(b[2], '%d/%m/%Y') >= Date.today ) && ( b[3].blank? || b[3] == MISC::MiscDates.acyr ) }
    par_dates.sort_by! { | d | [d[:from], d[:to]] }
    par_dates.last if par_dates.last.present?
  end

end
