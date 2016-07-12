class GroupPermission < ActiveRecord::Base
  belongs_to :group

  validates :group, presence: true
  validates :permission, presence: true, uniqueness: { scope: [:group],
                                                       case_sensitive: false }

  def permission=(value)
    self[:permission] = value.downcase if value.is_a?(String)
  end

  class << self
    def permissions
      @permissions ||= {}
    end

    def add_permission(key, description)
      permissions[key.to_s.downcase] = description
    end
  end
end
