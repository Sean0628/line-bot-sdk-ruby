require 'spec_helper'
require 'webmock/rspec'
require 'json'

describe Line::Bot::Client do
  it 'pushes the audio message' do
    uri_template = Addressable::Template.new Line::Bot::API::DEFAULT_ENDPOINT + '/bot/message/push'
    stub_request(:post, uri_template).to_return { |request| {body: request.body, status: 200} }

    client = Line::Bot::Client.new do |config|
      config.channel_token = 'channel_token'
    end

    user_id = 'user_id'
    message = {
      type: 'audio',
      originalContentUrl: 'https://example.com/audio.mp3',
      duration: 120000
    }
    response = client.push_message(user_id, message)

    expected = {
      to: user_id,
      messages: [
        message
      ]
    }.to_json
    expect(response.body).to eq(expected)
  end

  it 'pushes the audio message with additional payload' do
    uri_template = Addressable::Template.new Line::Bot::API::DEFAULT_ENDPOINT + '/bot/message/push'
    stub_request(:post, uri_template).to_return { |request| {body: request.body, status: 200} }

    client = Line::Bot::Client.new do |config|
      config.channel_token = 'channel_token'
    end

    user_id = 'user_id'
    message = {
      'type' => 'audio',
      'originalContentUrl' => 'https://example.com/audio.mp3',
      'duration' => 120000
    }
    response = client.push_message(user_id, message, payload: {'customAggregationUnits' => ['test']})

    expected = {
      'to' => user_id,
      'messages' => [
        message
      ],
      'customAggregationUnits' => ['test']
    }
    expect(JSON.parse(response.body)).to eq(expected)
  end

  it 'replies the audio message' do
    uri_template = Addressable::Template.new Line::Bot::API::DEFAULT_ENDPOINT + '/bot/message/reply'
    stub_request(:post, uri_template).to_return { |request| {body: request.body, status: 200} }

    client = Line::Bot::Client.new do |config|
      config.channel_token = 'channel_token'
    end

    reply_token = 'reply_token'
    message = {
      type: 'audio',
      originalContentUrl: 'https://example.com/audio.mp3',
      duration: 120000
    }
    response = client.reply_message(reply_token, message)

    expected = {
      replyToken: reply_token,
      messages: [
        message
      ]
    }.to_json
    expect(response.body).to eq(expected)
  end

  it 'multicasts the audio message' do
    uri_template = Addressable::Template.new Line::Bot::API::DEFAULT_ENDPOINT + '/bot/message/multicast'
    stub_request(:post, uri_template).to_return { |request| {body: request.body, status: 200} }

    client = Line::Bot::Client.new do |config|
      config.channel_token = 'channel_token'
    end

    user_ids = ['user1', 'user2']
    message = {
      type: 'audio',
      originalContentUrl: 'https://example.com/audio.mp3',
      duration: 120000
    }
    response = client.multicast(user_ids, message)

    expected = {
      to: user_ids,
      messages: [
        message
      ]
    }.to_json
    expect(response.body).to eq(expected)
  end

  it 'multicasts the audio message with additional payload' do
    uri_template = Addressable::Template.new Line::Bot::API::DEFAULT_ENDPOINT + '/bot/message/multicast'
    stub_request(:post, uri_template).to_return { |request| {body: request.body, status: 200} }

    client = Line::Bot::Client.new do |config|
      config.channel_token = 'channel_token'
    end

    user_ids = ['user1', 'user2']
    message = {
      'type' => 'audio',
      'originalContentUrl' => 'https://example.com/audio.mp3',
      'duration' => 120000
    }
    response = client.multicast(user_ids, message, payload: {'customAggregationUnits' => ['test']})

    expected = {
      'to' => user_ids,
      'messages' => [
        message
      ],
      'customAggregationUnits' => ['test']
    }
    expect(JSON.parse(response.body)).to eq(expected)
  end
end
