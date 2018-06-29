module GroupMergeHelper
  def group_merge_elements_sorted(group_merge)
    r = group_merge.to_merge_elements.map do |x|
      [group_merge_type_element_label(x[0]),
       group_merge_element_label(x[0]),
       group_merge_element_class(x)]
    end
    r.sort_by { |x| [x[0], x[1]] }
  end

  def group_merge_element_class(x)
    "GroupMergeHelper_element_#{x[1]}"
  end

  def group_merge_type_element_label(element)
    t("label_#{element.class.model_name.param_key}")
  end

  def group_merge_element_label(element)
    m = "group_merge_#{element.class.model_name.param_key}_element_label"
    respond_to?(m) ? send(m, element) : element.to_s
  end

  def group_merge_member_element_label(m)
    "#{t(:label_project)}: #{m.project} (#{m.roles.to_a.join(', ')})"
  end

  def group_merge_group_permission_element_label(gp)
    gp.permission
  end
end
