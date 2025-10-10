require "json"

module Prosopo
  struct Result
    include JSON::Serializable

    getter? verified : Bool
    getter status : String?
    getter errors : Array(String)? = [] of String
    getter score : Float64?
  end
end
