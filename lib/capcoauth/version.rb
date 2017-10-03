module Capcoauth
  def self.gem_version
    Gem::Version.new VERSION::STRING
  end

  module VERSION
    MAJOR = 0
    MINOR = 5
    PATCH  = 1

    STRING = [MAJOR, MINOR, PATCH].compact.join(".")
  end
end
