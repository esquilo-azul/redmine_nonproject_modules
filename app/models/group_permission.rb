# frozen_string_literal: true

require 'eac_ruby_utils/simple_cache'

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
      permissions_hash.values
    end

    def add_permission(key, options = {})
      p = Permission.new(key, options)
      permissions_hash[p.key] = p unless permissions_hash.key?(p.key)
    end

    def permission_description(key)
      permission(key).description
    end

    def permission?(permission, user = false)
      return permission_by_hash?(permission, user) if permission.is_a?(Hash)

      permission(permission).user_has?(user || User.current)
    end

    def permission(key)
      key = key.to_s
      return permissions_hash[key] if permissions_hash.key?(key)

      raise "Not found \"#{key}\" in GroupPermission::permissions"
    end

    private

    def permissions_hash
      @permissions_hash ||= {}.with_indifferent_access
    end

    def permission_by_hash?(hash, user)
      raise 'Hasy should have :or parameter' if hash[:or].blank?

      ps = hash[:or].is_a?(Array) ? hash[:or] : [hash[:or]]
      ps.any? { |p| permission?(p, user) }
    end
  end

  class Permission
    include ::EacRubyUtils::SimpleCache

    class << self
      def sanitize_key(key)
        key.to_s.downcase
      end
    end

    attr_reader :key, :dependencies

    def initialize(key, options)
      @key = self.class.sanitize_key(key)
      @dependencies = (options[:dependencies] || []).map { |k| ::GroupPermission.permission(k) }
    end

    def description
      I18n.t("permission_#{key}_description")
    end

    def to_s
      key
    end

    def user_has?(user)
      return true if user.admin

      GroupPermission.where(group: user_groups(user), permission: depends_recursive.to_a).any?
    end

    def depends_recursive(visited = Set.new)
      return [] if visited.include?(key)

      r = Set.new([key])
      visited << key
      depends.each do |d|
        r += d.depends_recursive(visited)
      end
      r
    end

    def <=>(other)
      to_s <=> other.to_s
    end

    private

    def user_groups(user)
      return [Group.anonymous] if user.anonymous?

      [Group.anonymous, Group.non_member] + user.groups
    end

    def depends
      ::GroupPermission.permissions.select { |p| p.dependencies.include?(self) }
    end
  end
end
