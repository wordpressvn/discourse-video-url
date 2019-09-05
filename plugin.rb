# name: Discourse Video Url
# about: Add video_url to Topics serializers, taken from the Topic's OP first video (if any)
# version: 0.1
# authors: Lingokids
# url: https://github.com/lingokids

enabled_site_setting :discourse_video_url_enabled

PLUGIN_NAME ||= "DiscourseVideoUrl".freeze

after_initialize do
  add_to_serializer :topic_list_item, :video_url do
    return if object&.first_post&.uploads.blank?

    object
      .first_post
      .uploads
      .order(created_at: :desc)
      .where(extension: SiteSetting.discourse_video_url_allowed_extensions.split("|"))
      .first
      &.url
  end

  add_to_serializer :post, :video_url do
    return if object&.uploads.blank?

    object
      .uploads
      .order(created_at: :desc)
      .where(extension: SiteSetting.discourse_video_url_allowed_extensions.split("|"))
      .first
      &.url
  end
end
