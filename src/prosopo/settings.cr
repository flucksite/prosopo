require "habitat"

module Prosopo
  Habitat.create do
    setting site_key : String
    setting secret_key : String
    setting endpoint : String = "https://api.prosopo.io/siteverify"
    setting timeout : Time::Span = 5.seconds
    setting retry_attempts : Int32 = 3
    setting retry_delays : Array(Float64 | Int32) = [0.5, 1, 2]
    setting script : String = "https://js.prosopo.io/js/procaptcha.bundle.js"
  end
end
