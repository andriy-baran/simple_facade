require 'simple_facade/version'

module SimpleFacade
  class Error < StandardError; end

  module Mixin
    def facade_push(k, v)
      return if v.nil? || k.nil? || key_exists?(k)
      @__members__ = nil
      __subjects__.push([k, v])
    end

    def facade_pop
      @__members__ = nil
      __subjects__.pop
    end

    def facade_enqueue(k, v)
      return if v.nil? || k.nil? || key_exists?(k)
      @__members__ = nil
      __subjects__.unshift([k, v])
    end

    def facade_dequeue
      @__members__ = nil
      __subjects__.shift
    end

    def facade_insert(index, k, v)
      return if v.nil? || k.nil? || index.nil? || key_exists?(k)
      @__members__ = nil
      __subjects__.insert(index, [k, v])
    end

    def facade_delete(key)
      return if key.nil?
      @__members__ = nil
      __subjects__.delete_at(__subjects__.index { |el| el.first == key })
    end

    def method_missing(method_name, *attrs, &block)
      member = __members__[method_name]
      return member if member
      responder = __members__.values.detect { |obj| obj.respond_to?(method_name) }
      if responder
        responder.public_send(method_name, *attrs, &block)
      else
        super
      end
    end

    def respond_to_missing?(method_name, _include_private = false)
      !__members__[method_name].nil? || __members__.values.any? { |obj| obj.respond_to?(method_name) }
    end

    private

    def __subjects__
      @__subjects__ ||= []
    end

    def __members__
      @__members__ ||= __subjects__.to_h
    end

    def key_exists?(key)
      __members__.keys.include?(key)
    end
  end

  class Base
    include Mixin

    def initialize(*attrs, **options)
      @__subjects__ = []
      @__subjects__ += options.to_a
      @__subjects__ += attrs.select {|el| el.is_a?(Array) && el.size == 2}
    end

    attr_reader :__subjects__
  end
end
