module RHC
  module VERSION #:nocov:
    STRING = Gem.loaded_specs['startapp'].version.to_s rescue '0.0.0'
  end
end
