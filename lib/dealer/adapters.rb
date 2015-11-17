module Dealer
  module Adapters
    @@adapter_classes = { client: {}, server: {} }

    def self.client(adapter_name)
      @@adapter_classes[:client][adapter_name] ||= load_adapter(adapter_name, :client)
    end

    def self.server(adapter_name)
      @@adapter_classes[:server][adapter_name] ||= load_adapter(adapter_name, :server)
    end

    private

    def self.load_adapter(adapter_name, client_or_server)
      require "dealer/adapters/#{adapter_name}"
      adapter_class_name = adapter_name.to_s.gsub(/([a-z])[a-z]*/) { $&.capitalize }.delete('_')
      @@adapter_classes[client_or_server][adapter_name] = Dealer::Adapters.const_get(adapter_class_name).const_get("#{client_or_server.capitalize}Adapter")
    end
  end
end
