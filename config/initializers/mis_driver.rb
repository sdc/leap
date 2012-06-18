#require 'mis_connectors/no_connector'
require 'mis_connectors/ebs_connector'
Ilp2::Application.config.mis_progress_codes = {
  "ACTREG"     => :current,    #  Active on Course
  "TRANSREG"   => :incomplete, #  Transfer to another Learner Aim
  "DNSREG"     => :incomplete, #  DNS - Left before 1st Census
  "FINREG"     => :complete,   #  Finished Course
  "WDRCH"      => :incomlete,  #  Withdrawn - Change of Circumstances
  "WDRSD"      => :incomplete, #  Withdrawn - Student Dissatisfaction
  "WDRDATA"    => :incomplete, #  Withdrawn by Data Team
  "FINREGNV"   => :complete,   #  Finished Non Voc Course only
  "WDRLA"      => :incomplete, #  Withdrawn Learn Agree/Census/ Sign Off
  "LEARNERENR" => :current,    #  Learner enrolment
  "DNSENR"     => :incomplete, #  DNS - Enrolled but never attended
  "DNSLP"      => :incomplete, #  DNS - enrolled via LP and did not pay
  "DECLINED"   => :incomplete, #  Declined Payment by Netbanx
  "DNSXFR"     => :incomplete, #  DNS on this course but still at College.
  "WDRNCC"     => :incomplete, #  Withdrwn-Class Closed after Census Point
  "DNSCC"      => :incomplete, #  DNS - Class closed B4 census Point
  "DNSPD"      => :incomplete, #  DNS - Learner Portal Duplicate
  "DNSDATA"    => :incomplete,  # DNS - Enrolled but never attended (CIS)
  "CA"   => :complete,
  "CNA"  => :incomplete,
  "X"    => :incomplete,
  "W"    => :incomplete,
  "T"    => :incomplete,
  "A"    => :current
}
Ilp2::Application.config.mis_progress_codes.default = :unknown
Ilp2::Application.config.mis_usage_codes = {
  "A" => :complete,
  "L" => :current,
  "E" => :current,
  "0" => :incomplete,
  "O" => :incomplete,
  "K" => :complete,
  "C" => :complete
}
Ilp2::Application.config.mis_usage_codes.default = :unknown
