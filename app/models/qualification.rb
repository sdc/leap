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

class Qualification < Eventable

  attr_protected
  include ActiveModel::ForbiddenAttributesProtection   

  include MisQualification

  after_create  {|qual| qual.events.create!(:event_date => created_at, :transition => qual.predicted? ? :create : :complete)}

  def strong_params_validate
    [{:event_date => self.created_at, :transition => self.predicted? ? :create : :complete}]
  end

  before_save   {|q| q.predicted=true if (Person.user and !Person.user.staff?) }
               
  before_update {|q| q.events.first.update_attribute("event_date", q.created_at) }

  validates :title, :presence => true 

  belongs_to :person

  QOE_LAT = {
            "GNVQ"          => {"WEIGHT"=>4, "DISTINCTION"=>220, "MERIT"=>184, "PASS"=>160},
            "GCSE"          => {"A"=>7, "B"=>6, "C"=>5, "D"=>4, "WEIGHT"=>1, "E"=>3, "F"=>2, "G"=>1, "A*"=>8, "U"=>0,
                                "0"=>0, "1"=>1, "2"=>3, "3"=>4, "4"=>5, "5"=>5.67, "6"=>6.33, "7"=>7, "8"=>7.67, "9"=>8},
            "FIRST DIPLOMA" => {"WEIGHT"=>2, "DISTINCTION"=>136, "MERIT"=>112, "PASS"=>76},
            "DOUBLE GCSE"   => {"A*A*"=>16, "AA"=>14, "BB"=>12, "CC"=>10, "DD"=>8, "EE"=>6, "FF"=>4, "GG"=>2, "NN"=>0, "UU"=>0, "WEIGHT"=>2,
                                "9"=>16, "8"=>15.34, "7"=>14, "6"=>12.66, "5"=>11.34, "4"=>10, "3"=>8, "2"=>6, "1"=>2,
                                "A* A*"=>16, "A A"=>14, "B B"=>12, "C C"=>10, "D D"=>8, "E E"=>6, "F F"=>4, "G G"=>2,
                                "99"=>16, "98"=>15.67, "88"=>15.34, "87"=>14.67, "77"=>14, "76"=>13.33, "66"=>12.66, "65"=>12, "55"=>11.34, "54"=>10.67, "44"=>10, "43"=>9, "33"=>8, "32"=>7, "22"=>6, "21"=>4, "11"=>2,
                                "9 9"=>16, "9 8"=>15.67, "8 8"=>15.34, "8 7"=>14.67, "7 7"=>14, "7 6"=>13.33, "6 6"=>12.66, "6 5"=>12, "5 5"=>11.34, "5 4"=>10.67, "4 4"=>10, "4 3"=>9, "3 3"=>8, "3 2"=>7, "2 2"=>6, "2 1"=>4, "1 1"=>2,
                                "9-9"=>16, "9-8"=>15.67, "8-8"=>15.34, "8-7"=>14.67, "7-7"=>14, "7-6"=>13.33, "6-6"=>12.66, "6-5"=>12, "5-5"=>11.34, "5-4"=>10.67, "4-4"=>10, "4-3"=>9, "3-3"=>8, "3-2"=>7, "2-2"=>6, "2-1"=>4, "1-1"=>2,
                                "A*A"=>15, "AB"=>13, "BC"=>11, "CD"=>9, "DE"=>7, "EF"=>5, "FG"=>3,
                                "A* A"=>15, "A B"=>13, "B C"=>11, "C D"=>9, "D E"=>7, "E F"=>5, "F G"=>3},
            "SHORT GCSE"    => {"A"=>3.5, "B"=>3, "C"=>2.5, "D"=>2, "WEIGHT"=>0.5, "E"=>1.5, "F"=>1, "G"=>0.5, "A*"=>4, "U"=>0,
                                "9"=>4,"8"=>3.84, "7"=>3.5, "6"=>3.17, "5"=>2.84, "4"=>2.5, "3"=>2, "2"=>1.5, "1"=>0.5}
            }

  def body
    [self[:qual_type],self[:title]].reject{|x| x.blank?}.join ": "
  end

  def subtitle
    grade
  end

  def extra_panes
    if Person.user.staff? and Settings.quals_editing == "on"
      [["Edit","events/tabs/edit_qual"]]
    end
  end

  def icon_class
    "fa-certificate"
  end

  def status
    return :outstanding if import_type == 'la' || import_type == 'attainment'
    return :complete if seen?
    return :complete if !mis_id.blank?
    return :not_started if predicted?
    return :current
  end

  def title
    return ["Qualification", importedTitle] if seen?
    return ["Qualification", importedTitle] if !mis_id.blank?
    return ["Predicted","Grade", importedTitle] if predicted?
    return ["Qualification","(not_seen)", importedTitle] 
  end

  def importedTitle
    return 'EBS import' if import_type == 'la' || import_type == 'attainment'
    return ''
  end

  def lat_score
    begin
      # Only calc lat scores for quals with grades
      return "No Grade" if grade.blank?
      # Only calc lat_scores for quals on entry
      return "Imported Qual" if mis_id 
      # Don't include predicted grades
      return "Predicted Grade" if predicted?
      # Only quals acheived between 16 & 18 years count towards LAT
      #years = case person.age_on(Date.civil(MISC::MiscDates.start_of_acyr.year,9,1))
      #when 16 then 1
      #when 17 then 2
      #when 18 then 3
      #else 0
      #end
      #return "Ineligible Date" unless created_at.between?(Date.civil(MISC::MiscDates.start_of_acyr.year,8,1) - years.years,Date.today)#civil(MISC::MiscDates.start_of_acyr.year,9,1))
      # Only return LAT scores if we can work them out from the info we have
      return "No scores for qual type" unless QOE_LAT[qual_type.strip.upcase] 
      return "No scores for this grade" unless QOE_LAT[qual_type.strip.upcase][grade.strip.upcase]
      QOE_LAT[qual_type.strip.upcase][grade.strip.upcase]
    rescue
      return "Unexpected error!"
    end
  end

  def tile_attrs
    {:icon => "fa-certificate"}
  end 

  def is_deletable? 
    Person.user.admin? or (Time.now - Settings.delete_delay.to_i < eventable.updated_at and Person.user == eventable.updated_by)
  end

end
