require "simple_facade/version"

module SimpleFacade
  class Error < StandardError; end

  class Base
    def initialize(*attrs)
      @__collection__ = []
      if attrs.size == 1 && attrs.first.is_a?(Hash)
        @__collection__ += attrs.first.to_a
      else
        @__collection__ += attrs.select {|el| el.is_a(Array) && el.size == 2}
      end
    end

    def members
      __collection__.to_h
    end

    def push(k, v)
      __collection__.push([k, v])
    end

    def pop
      __collection__.pop
    end

    def enqueue(k, v)
      __collection__.unshift([k, v])
    end

    def dequeue
      __collection__.shift
    end

    def method_missing(method_name, *attrs, &block)
      responder = members.values.detect { |obj| obj.respond_to?(method_name) }
      if responder
        responder.public_send(method_name, *attrs, &block)
      else
        super
      end
    end

    def respond_to_missing?(method_name, _include_private = false)
      members.values.any? { |obj| obj.respond_to?(method_name) }
    end

    private

    attr_reader :__collection__
  end
end
