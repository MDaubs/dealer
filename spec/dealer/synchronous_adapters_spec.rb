require 'spec_helper'
require 'dealer/adapters/synchronous'

describe 'synchronous adapters' do
  specify 'messages sent to the server adapter are received by the correct client adapter' do
    messages_received_by_client = {}

    server_adapter = Dealer::Adapters::Synchronous::ServerAdapter.new.tap do |s|
      s.on_message do |client, message|
        (messages_received_by_client[client] ||= []) << message
      end
    end

    Dealer::Adapters::Synchronous::ClientAdapter.new(server_adapter) {} << 'foo bar baz'
    Dealer::Adapters::Synchronous::ClientAdapter.new(server_adapter) {} << 'baz foo bar'

    expect(messages_received_by_client.values).to contain_exactly ['foo bar baz'], ['baz foo bar']
  end

  specify 'messages are sent to the correct client adapter' do
    messages_received_by_client1 = []
    messages_received_by_client2 = []
    clients = []

    Dealer::Adapters::Synchronous::ServerAdapter.new.on_connect(&clients.method(:push)).tap do |server_adapter|
      Dealer::Adapters::Synchronous::ClientAdapter.new(server_adapter, &messages_received_by_client1.method(:push))
      Dealer::Adapters::Synchronous::ClientAdapter.new(server_adapter, &messages_received_by_client2.method(:push))
    end

    clients[0].send_to_client 'foo bar baz'
    clients[1].send_to_client 'baz foo bar'

    expect(messages_received_by_client1).to eq ['foo bar baz']
    expect(messages_received_by_client2).to eq ['baz foo bar']
  end
end
