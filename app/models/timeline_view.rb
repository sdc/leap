class TimelineView < ActiveRecord::Base
  #attr_accessible :id,:icon,:title,:home,:topic_person,:topic_course,
  #                :controls,:events,:url,:aff_affiliate,:aff_applicant,
  #                :aff_staff,:aff_student,:admin_only,:parent_id
  serialize :events, Hash
  serialize :controls, Array
end
