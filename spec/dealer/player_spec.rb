require 'spec_helper'
require 'dealer/player'

describe Dealer::Player do
  subject(:player) { described_class.new }

  describe '#id' do
    it 'is 16 characters' do
      expect(player.id).to have(16).characters
    end

    it 'is sufficiently unique' do
      expect(100.times.map { described_class.new.id }.uniq.count).to eq(100)
    end
  end

  describe '#to_s' do
    it 'identifies the player' do
      expect(player.to_s).to match(/player\/\w{16}/)
    end
  end
end
