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
      @permissions.keys
    end

    def add_permission(key, description = nil)
      permissions_hash[key.to_s.downcase] = description
    end

    def permission_description(key)
      assert_permission_exist(key)
      permissions_hash[key] || I18n.t("permission_#{key}_description")
    end

    def permission?(permission, user = false)
      assert_permission_exist(permission)
      user ||= User.current
      return true if user.admin
      user.groups.any? { |g| g.permissions.where(permission: permission).any? }
    end

    private

    def permissions_hash
      @permissions ||= {}
    end

    def assert_permission_exist(key)
      return if permissions_hash.include?(key)
      fail "Not found \"#{key}\" in GroupPermission::permissions"
    end
  end
end
