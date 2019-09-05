# Discourse Video Url

Discourse Video Url is a plugin to add `video_url` field, much like `image_url`, to Topics index/show serializers, taken from the first uploaded video (if any) to a Topic's original post.

## Installation

Follow [Install a Plugin](https://meta.discourse.org/t/install-a-plugin/19157)
how-to from the official Discourse Meta, using `git clone https://github.com/lingokids/discourse-video-url.git`
as the plugin command.

## Usage
The plugin is enabled by default.

By default it will take any `mp4` file, but more extensions can be added via the Admin -> Plugins -> Discourse Video Url (Settings). Remember to also allow these extensions under "Authorized Extensions" settings!

## Testing
To run tests:

`LOAD_PLUGINS=1 bundle exec rspec plugins/discourse-video-url/spec/`

## Feedback

If you have issues or suggestions for the plugin, please bring them up on
[Discourse Meta](https://meta.discourse.org).
