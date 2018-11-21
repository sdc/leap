# Leap - Electronic Individual Learning Plan Software
# Copyright (C) 2011 South Devon College

# Leap is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# Leap is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with Leap.  If not, see <http://www.gnu.org/licenses/>.

class ProgressReview < Eventable

  attr_protected
  include ActiveModel::ForbiddenAttributesProtection

  validate :check_unique
  belongs_to :person, :foreign_key => "created_by_id"
  belongs_to :progress, :foreign_key => "progress_id"
  before_save :set_values
  validates :body, :presence => true

  # after_create do |line|
  #   line.events.create!(:event_date => created_at, :transition => :create, :person_id => person_id)
  # end

  def strong_params_validate
    [{:event_date => self.created_at, :transition => :create, :person_id => self.person_id}]
  end  

  def set_values
  	self.created_at ||= Time.now
  	self.created_by_id ||= Person.user.id
  end

  def status
    begin
      if self.level == 'purple'
        return :outstanding
      elsif self.level == 'green'
        return :complete
      elsif self.level == 'amber'
        return :current
      elsif self.level == 'red'
        return :incomplete
      end
    end
  end

  def ragp_desc
    begin
      if self.level == 'purple'
        return "Consistently achieving at least one grade above target"
      elsif self.level == 'green'
        return "On target and making expected progress"
      elsif self.level == 'amber'
        return "One grade below target"
      elsif self.level == 'red'
        return "Two grades below target"
      end
    end
  end

  def icon_class
    "fa-pencil-square-o"
  end

  def check_unique
    if ProgressReview.exists? ["progress_id = ? AND number = ? AND id != ?", self.progress_id, self.number.to_i, self.id]
      self.errors.add( :progress_id, 'Error, please contact IT')
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
    enddate = DateTime.strptime( ProgressReview::par_date_range( self.number )[:to] + ' 23:59:59', '%d/%m/%Y %T' ) if Settings.par_window_type == "Date Range" && ProgressReview::par_date_range( self.number ).present? && ProgressReview::par_date_range( self.number )[:to].present?
    return enddate.strftime('%b, %d, %Y, %H:%M') if enddate.present?
    return nil
  end

  def is_editable
    return true if ( Person.user.superuser? or Person.user.admin? )
    # return false if ( Person.user.id != self.created_by_id && Settings.par_window_type.present? )
    return ( (Time.now - Settings.par_edit_window.to_i) < self.updated_at ) if Settings.par_window_type == "Edit Window"
    return ( ProgressReview::par_date_range_active( self.number ) ) if Settings.par_window_type == "Date Range"
    return true
  end

  private

  def self.par_is_active?( revno )
    return false if ( Settings.par_restrict_active == 'on' && !Settings.par_active.split(',').reject(&:empty?).include?(revno.to_s) )
    return true
  end

  def self.par_is_enabled?( revno )
    return true if Person.user.superuser?
    return false if !Person.user.staff?
    return false if !par_is_active?( revno )
    par_date_range_active( revno )
  end

  def self.par_date_range_active( revno )
    return true if !Settings.par_restrict_date_ranges.split(',').reject(&:empty?).include?(revno.to_s)
    par_date_range(revno).present?
  end

  def self.par_date_range( revno )
    par_dates = []
    Settings.par_date_ranges.split("|").each{|x| b=x.split(';'); par_dates << { :rev => b[0], :from => b[1], :to => b[2] } if b[0] == revno.to_s && ( b[1].blank? || Date.strptime(b[1], '%d/%m/%Y') <= Date.today ) && ( b[2].blank? || Date.strptime(b[2], '%d/%m/%Y') >= Date.today ) && ( b[3].blank? || b[3] == MISC::MiscDates.acyr ) }
    par_dates.sort_by! { | d | [d[:from], d[:to]] }
    par_dates.last if par_dates.last.present?
  end

  def self.par_guidance_title( revno )
    t = []
    Settings.par_guidance.split("|||").each{|x| b=x.split('||'); t = b[0].split('#')[1] if b[0].split('#')[0].split(',').include? revno.to_s}
    return t if t.present?
    return 'Guidance:'
  end

  def self.par_guidance_text( revno )
    gt = []
    Settings.par_guidance.split("|||").each{|x| b=x.split('||'); gt = b[1].split('|').map{|y| { :text => y.split('#')[0], :class => y.split('#')[1]} } if b[0].split('#')[0].split(',').include? revno.to_s}
    return gt
  end

end
