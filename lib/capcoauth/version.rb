module Capcoauth
  def self.gem_version
    Gem::Version.new VERSION::STRING
  end
  module VERSION
    MAJOR = 1
    MINOR = 0
    PATCH  = 1

    STRING = [MAJOR, MINOR, PATCH].compact.join(".")
  end
end
