module Capcoauth
  def self.gem_version
    Gem::Version.new VERSION::STRING
  end

  module VERSION
    MAJOR = 0
    MINOR = 6
    PATCH  = 2

    STRING = [MAJOR, MINOR, PATCH].compact.join(".")
  end
end
