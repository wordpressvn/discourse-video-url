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

  let(:video_upload) { Fabricate(:video_upload) }

  before do
    SiteSetting.authorized_extensions = "#{SiteSetting.authorized_extensions}|mp4"
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
