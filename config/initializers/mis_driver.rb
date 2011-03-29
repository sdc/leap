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
