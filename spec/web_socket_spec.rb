require 'spec_helper'
require 'dealer/adapters/web_socket'
require_relative '../samples/go_fish'

describe "web socket integration" do
  it 'allows a player to connect and be assigned a player id' do
    Dealer::Server.new(GoFish.new, Dealer::Adapters::WebSocket::ServerAdapter.new(9292))
    sleep 0.1
    client1 = Dealer::Client.new(Dealer::Adapters::WebSocket::ClientAdapter, "ws://localhost:9292/")
    sleep 0.1
    expect(client1.player_id).to_not be_nil
  end
end
