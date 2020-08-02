require 'simple_facade/version'

module SimpleFacade
  class Error < StandardError; end

  def initialize(*attrs)
    @__sf_collection__ = []
    if attrs.size == 1 && attrs.first.is_a?(Hash)
      @__sf_collection__ += attrs.first.to_a
    else
      @__sf_collection__ += attrs.select {|el| el.is_a(Array) && el.size == 2}
    end
    super
  end

  def members
    __sf_collection__.to_h
  end

  def push(k, v)
    __sf_collection__.push([k, v])
  end

  def pop
    __sf_collection__.pop
  end

  def enqueue(k, v)
    __sf_collection__.unshift([k, v])
  end

  def dequeue
    __sf_collection__.shift
  end

  def insert(index, k, v)
    __sf_collection__.insert(index, [k, v])
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

  attr_reader :__sf_collection__

  class Base
    include SimpleFacade
  end
end
