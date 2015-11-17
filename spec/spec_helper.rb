$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'dealer'
require 'rspec/collection_matchers'

module Helpers
  def card_faces(length)
    a_string_matching(/[🂡-🃞]{#{length}}/)
  end

  def card_backs(length)
    a_string_matching(/🂠{#{length}}/)
  end
end

RSpec.configure do |c|
  c.include Helpers
end

RSpec::Matchers.define :a_card_having_rank do |expected_rank|
  match do |face|
    Dealer::Card.from_face(face).rank == expected_rank
  end
end
