require 'mis_connectors/ebs_connector'
Ilp2::Application.config.mis_photo_path = "/media/photos"
Ilp2::Application.config.mis_progress_codes = {"success" => ["CA"],
                                               "fail"    => ["CNA","X","W","T"],
                                               "active"  => ["A"]
                                              }
