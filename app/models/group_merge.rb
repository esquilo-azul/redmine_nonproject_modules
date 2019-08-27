# frozen_string_literal: true

require 'virtus'

class GroupMerge
  include ActiveModel::Model
  include Virtus.model
  include ActiveModel::Associations

  ONLY_ON_TARGET = :only_on_target
  ONLY_ON_SOURCE = :only_on_source
  ON_BOTH = :on_both

  attribute :source_id, Integer
  attribute :target_id, Integer
  belongs_to :source, class_name: 'Group'
  belongs_to :target, class_name: 'Group'

  validates :source, presence: true
  validates :target, presence: true

  def [](attr)
    send(attr)
  end

  def []=(attr, value)
    send("#{attr}=", value)
  end

  def to_merge_elements
    (target_elements + source_elements).uniq.map do |x|
      [x[0], element_on_status(x)]
    end
  end

  def save!
    ActiveRecord::Base.transaction do
      source_new_elements.each { |x| add_element_to_target(x[0], x[1]) }
      source.destroy!
    end
  end

  def associations_to_merge
    %i[users memberships permissions]
  end

  private

  def element_on_status(element)
    return ON_BOTH if target_elements.include?(element) && source_elements.include?(element)
    return ONLY_ON_TARGET if target_elements.include?(element)
    return ONLY_ON_SOURCE if source_elements.include?(element)

    raise "Element is neither on source nor on target: #{element}"
  end

  def target_elements
    @target_elements ||= elements(:target)
  end

  def source_elements
    @source_elements ||= elements(:source)
  end

  def elements(sender)
    associations_to_merge.flat_map do |a|
      send(sender).send(a).map do |e|
        [e, a]
      end
    end
  end

  def source_new_elements
    source_elements.reject do |x|
      target_elements.include?(x)
    end
  end

  def add_element_to_target(element, association_name)
    method = "add_#{association_name}_element_to_target"
    if respond_to?(method, true)
      send(method, element)
    else
      target.send(association_name) << element
    end
  end

  def add_permissions_element_to_target(permission)
    target.add_permission(permission)
  end
end
