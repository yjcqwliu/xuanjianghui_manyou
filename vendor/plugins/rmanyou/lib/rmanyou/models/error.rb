require "rmanyou/model"
 
module Rmanyou
  class Error < Model
    
    def self.elm_name
      "error_response"
    end
    
    def self.attr_names
      [
       :errCode,
       :errMessage,
       :args
      ]
    end
 
    for a in attr_names
      attr_accessor a
    end
    
  end
end