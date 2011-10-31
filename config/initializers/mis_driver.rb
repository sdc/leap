#require 'mis_connectors/no_connector'
require 'mis_connectors/ebs_connector'
Ilp2::Application.config.mis_photo_path = "/media/photos"
Ilp2::Application.config.mis_progress_codes = {"CA"   => :complete,
                                               "CNA"  => :incomplete,
                                               "X"    => :incomplete,
                                               "W"    => :incomplete,
                                               "T"    => :incomplete,
                                               "A"    => :current
                                              }
Ilp2::Application.config.mis_progress_codes.default = :unknown
Ilp2::Application.config.mis_usage_codes = {"A" => :complete,
                                            "L" => :current,
                                            "E" => :current,
                                            "0" => :incomplete,
                                            "O" => :incomplete,
                                            "K" => :complete,
                                            "C" => :complete
           }
Ilp2::Application.config.mis_usage_codes.default = :unknown
