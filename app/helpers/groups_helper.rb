module GroupsHelper
  def user_is_leader_of?(object)
    # object can be either group or meeting
    object.leaders.include? current_user
  end

  def group_is_deletable?(group)
    user_is_leader_of?(group) && group.group_members.count == 1
  end

  def edit_group_link(group)
    link_to t('groups.index.edit'), edit_group_path(group),
            class: 'small_margin_right'
  end

  def leader_link(leader)
    name = leader == current_user ? t('.self') : leader.name
    link_to name, profile_index_path(uid: leader.uid)
  end

  def delete_group_link(group, attrs = {})
    link_to t('.delete'), group,
            { method: :delete,
              data: { confirm: t('.confirm') }
            }.merge(attrs)
  end

  def leave_group_link(group, attrs = {})
    link_to t('.leave'), leave_groups_path(groupid: group.id),
            { id: 'leave' }.merge(attrs)
  end

  def join_group_link(group, attrs = {})
    link_to t('.join'), join_groups_path(groupid: group.id),
            { id: 'join' }.merge(attrs)
  end

  def edit_meeting_link(meeting, html_options = {})
    return unless user_is_leader_of? meeting
    link_to edit_meeting_path(meeting), html_options do
      raw '<i class="fa fa-pencil"></i>'
    end
  end

  def render_group_member_partial(members)
    render partial: '/notifications/members',
           locals: { data: members }
  end

  def render_meeting_partial(meeting)
    render partial: '/shared/meeting_info',
           locals: { meeting: meeting, is_leader: user_is_leader_of?(meeting) }
  end
end
