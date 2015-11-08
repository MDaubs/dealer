require 'spec_helper'
require_relative '../samples/go_fish'

describe Dealer do
  it 'plays go fish' do
    server = Dealer::Server.new(GoFish.new, 9292).start
    sleep 0.1
    player1 = Dealer::Client.new('ws://localhost:9292/')
    sleep 0.1
    player2 = Dealer::Client.new('ws://localhost:9292/').take_action(:start_game)
    sleep 0.1

    expect(player1.game_state).to match(/My Hand: .{7}/)
    expect(player2.game_state).to match(/My Hand: .{7}/)

    server.stop
  end
end
