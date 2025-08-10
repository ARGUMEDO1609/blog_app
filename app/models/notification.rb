class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  after_create_commit -> {
    broadcast_prepend_later_to(
      "notifications_#{user_id}",
      partial: "notifications/notification",
      locals: { notification: self },
      target: "notifications"
    )
    broadcast_replace_later_to(
      "notifications_count_#{user_id}",
      target: "notifications_count",
      partial: "notifications/count",
      locals: { count: user.notifications.where(read: false).count }
    )
  }
end
