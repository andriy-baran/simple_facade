require 'simple_facade/version'

module SimpleFacade
  class Error < StandardError; end

  class Base
    def initialize(*attrs)
      @subjects = []
      if attrs.size == 1 && attrs.first.is_a?(Hash)
        @subjects += attrs.first.to_a
      else
        @subjects += attrs.select {|el| el.is_a(Array) && el.size == 2}
      end
    end

    def members
      @members ||= subjects.to_h
    end

    def push(k, v)
      @members = nil
      subjects.push([k, v])
    end

    def pop
      @members = nil
      subjects.pop
    end

    def enqueue(k, v)
      @members = nil
      subjects.unshift([k, v])
    end

    def dequeue
      @members = nil
      subjects.shift
    end

    def insert(index, k, v)
      @members = nil
      subjects.insert(index, [k, v])
    end

    def delete(key)
      @members = nil
      subjects.delete_at(subjects.index { |el| el.first == key })
    end

    def method_missing(method_name, *attrs, &block)
      member = members[method_name]
      return member if member
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

    attr_reader :subjects
  end
end
