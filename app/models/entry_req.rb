require "csv"

class EntryReq < ActiveRecord::Base
  attr_accessible :body, :category

  belongs_to :course

  def self.import(file)
    CSV.foreach(file) do |row|
      if course=Course.find_by_year_and_code("13/14",row[0])
        ["Numeracy","Literacy","General","Specialist","Additional"].each_with_index do |r,i|
          next if row[i+1].blank?
          next if course.entry_reqs.where(:category => r).first
          course.entry_reqs.create(:category => r,:body => row[i+1]) unless row[i+1] == "Please select"
        end
      end
    end
  end
end
