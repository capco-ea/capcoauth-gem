module Capcoauth
  def self.gem_version
    Gem::Version.new VERSION::STRING
  end

  module VERSION
    MAJOR = 0
    MINOR = 4
    PATCH  = 0

    STRING = [MAJOR, MINOR, PATCH].compact.join(".")
  end
end
