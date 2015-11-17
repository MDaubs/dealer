module Dealer
  module Adapters
    @@adapter_classes = {}

    def self.[](adapter_name)
      @@adapter_classes[adapter_name] ||= load_adapter(adapter_name)
    end

    private

    def self.load_adapter(adapter_name)
      require "dealer/adapters/#{adapter_name}"
      adapter_class_name = adapter_name.to_s.gsub(/([a-z])[a-z]*/) { $&.capitalize }.delete('_')
      @@adapter_classes[adapter_name] = Dealer::Adapters.const_get(adapter_class_name).const_get('ClientAdapter')
    end
  end
end
