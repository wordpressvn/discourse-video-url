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

    url = object
            .first_post
            .uploads
            .order(created_at: :desc)
            .where(extension: SiteSetting.discourse_video_url_allowed_extensions.split("|"))
            .first
            &.url

    return if url.blank?

    if Discourse.store.external?
      url.start_with?("//") ? Discourse.store.cdn_url(url) : "#{Discourse.base_url}#{url}"
    else
      "#{Discourse.base_url}#{url}"
    end
  end

  add_to_serializer :post, :video_url do
    return if object&.uploads.blank?

    url = object
            .uploads
            .order(created_at: :desc)
            .where(extension: SiteSetting.discourse_video_url_allowed_extensions.split("|"))
            .first
            &.url

    return if url.blank?

    if Discourse.store.external?
      url.start_with?("//") ? Discourse.store.cdn_url(url) : "#{Discourse.base_url}#{url}"
    else
      "#{Discourse.base_url}#{url}"
    end
  end
end
