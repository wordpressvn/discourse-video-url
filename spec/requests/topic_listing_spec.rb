# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "topic listing" do
  let(:post) do
    raw = <<~RAW
      <p>Post with a video</p>
      <a href="#{video_upload.url}">
        <img src="/uploads/default/original/1X/1234567890123456.jpg">
      </a>
    RAW

    Fabricate(:post, raw: raw)
  end

  before do
    SiteSetting.authorized_extensions = "#{SiteSetting.authorized_extensions}|mp4"
  end

  context "with local storage" do
    let(:video_upload) { Fabricate(:video_upload) }
    let(:base_url) { Discourse.base_url }

    before { post.uploads << video_upload }

    it "includes video_url on topic listing" do
      get "/latest.json"

      topics = JSON.parse(response.body)["topic_list"]["topics"]

      expect(response.status).to eq(200)
      expect(topics.first["video_url"]).to eq("#{base_url}#{video_upload.url}")
    end

    it "includes video_url on topic show" do
      get "/t/#{post.topic.id}.json"

      post = JSON.parse(response.body).dig("post_stream", "posts").first

      expect(response.status).to eq(200)
      expect(post["video_url"]).to eq("#{base_url}#{video_upload.url}")
    end
  end

  context "with S3 storage" do
    let(:video_upload) { Fabricate(:upload_s3, original_filename: "video.mp4", extension: "mp4") }

    before do
      SiteSetting.enable_s3_uploads = true
      SiteSetting.s3_access_key_id = "key"
      SiteSetting.s3_secret_access_key = "secret"
      SiteSetting.s3_upload_bucket = "test-bucket"

      post.uploads << video_upload
    end

    it "includes video_url on topic listing" do
      get "/latest.json"

      topics = JSON.parse(response.body)["topic_list"]["topics"]

      expect(response.status).to eq(200)
      expect(topics.first["video_url"]).to eq(video_upload.url)
    end

    it "includes video_url on topic show" do
      get "/t/#{post.topic.id}.json"

      post = JSON.parse(response.body).dig("post_stream", "posts").first

      expect(response.status).to eq(200)
      expect(post["video_url"]).to eq(video_upload.url)
    end
  end

  context "with S3 storage" do
    let(:video_upload) { Fabricate(:upload_s3, original_filename: "video.mp4", extension: "mp4") }

    before do
      SiteSetting.enable_s3_uploads = true
      SiteSetting.s3_access_key_id = "key"
      SiteSetting.s3_secret_access_key = "secret"
      SiteSetting.s3_upload_bucket = "test-bucket"
      SiteSetting.s3_cdn_url = "https://assets.test.com"

      post.uploads << video_upload
    end

    it "includes video_url on topic listing" do
      get "/latest.json"

      topics = JSON.parse(response.body)["topic_list"]["topics"]

      expect(response.status).to eq(200)
      expect(topics.first["video_url"]).to eq(Discourse.store.cdn_url(video_upload.url))
    end

    it "includes video_url on topic show" do
      get "/t/#{post.topic.id}.json"

      post = JSON.parse(response.body).dig("post_stream", "posts").first

      expect(response.status).to eq(200)
      expect(post["video_url"]).to eq(Discourse.store.cdn_url(video_upload.url))
    end
  end
end
