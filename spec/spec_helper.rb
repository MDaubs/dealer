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
