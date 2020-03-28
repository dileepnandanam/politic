class SiteSetting < ApplicationRecord
  def self.[](name)
    SiteSetting.find_or_create_by(name: name)
  end

  def self.[]=(name, val)
    self[name].update(value: val)
  end
end
