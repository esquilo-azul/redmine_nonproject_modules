class GroupPermission < ActiveRecord::Base
  belongs_to :group

  validates :group, presence: true
  validates :permission, presence: true, uniqueness: { scope: [:group],
                                                       case_sensitive: false }

  def permission=(value)
    self[:permission] = Permission.sanitize_key(value)
  end

  class << self
    def permissions
      @permissions.keys
    end

    def add_permission(key, options = {})
      p = Permission.new(key, options)
      permissions_hash[p.key] = p unless permissions_hash.key?(p.key)
    end

    def permission_description(key)
      assert_permission_exist(key).description
    end

    def permission?(permission, user = false)
      return permission_by_hash?(permission, user) if permission.is_a?(Hash)
      assert_permission_exist(permission).user_has?(user || User.current)
    end

    private

    def permissions_hash
      @permissions ||= {}.with_indifferent_access
    end

    def assert_permission_exist(key)
      key = key.to_s
      return permissions_hash[key] if permissions_hash.key?(key)
      fail "Not found \"#{key}\" in GroupPermission::permissions"
    end

    def permission_by_hash?(hash, user)
      fail 'Hasy should have :or parameter' unless hash[:or].present?
      ps = hash[:or].is_a?(Array) ? hash[:or] : [hash[:or]]
      ps.any? { |p| permission?(p, user) }
    end
  end

  class Permission
    class << self
      def sanitize_key(k)
        k.to_s.downcase
      end
    end

    attr_reader :key

    def initialize(key, options)
      @key = self.class.sanitize_key(key)
      @options = options.with_indifferent_access
    end

    def description
      I18n.t("permission_#{key}_description")
    end

    def to_s
      key
    end

    def user_has?(user)
      return true if user.admin
      GroupPermission.where(group: user_groups(user), permission: key).any?
    end

    def <=>(other)
      to_s <=> other.to_s
    end

    private

    def user_groups(user)
      return [Group.anonymous] if user.anonymous?
      [Group.anonymous, Group.non_member] + user.groups
    end
  end
end
