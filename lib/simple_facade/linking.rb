module SimpleFacade
  module Linking
    READERS = [
      SUCCESSOR = :successor,
      PREDECESSOR = :predecessor,
    ]

    class LinkingObserver
      attr_reader :current_object, :previous_step, :reader

      def initialize(reader = nil)
        @reader = reader
      end

      def double?
        reader.nil?
      end

      def single?
        !double?
      end

      def reverse?
        reader == SimpleFacade::Linking::PREDECESSOR
      end

      def direct?
        reader == SimpleFacade::Linking::SUCCESSOR
      end

      def on_new_object(accessor, object)
        @current_object = link(@current_object, object, @previous_step, accessor)
        @previous_step = accessor
      end

      def link(current_object, next_object, predecessor, successor)
        return next_object if predecessor.nil? || current_object.nil?

        link_predecessor(current_object, next_object, predecessor)
        link_successor(current_object, next_object, successor)

        next_object
      end

      def link_predecessor(current_object, next_object, predecessor)
        return if single? && direct?
        next_object.singleton_class.class_eval do
          attr_accessor :predecessor
        end
        next_object.predecessor = predecessor
        next_object.singleton_class.class_eval do
          attr_accessor next_object.predecessor
        end
        next_object.public_send(:"#{next_object.predecessor}=", current_object)
      end

      def link_successor(current_object, next_object, successor)
        return if single? && reverse?
        current_object.singleton_class.class_eval do
          attr_accessor :successor
        end
        current_object.successor = successor
        current_object.singleton_class.class_eval do
          attr_accessor current_object.successor
        end
        current_object.public_send(:"#{current_object.successor}=", next_object)
      end
    end

    def link_members
      link(PREDECESSOR)
    end

    def double_link_members
      link(nil)
    end

    private

    def link(reader)
      observer = LinkingObserver.new(reader)
      __subjects__.each do |k, v|
        observer.on_new_object(k, v)
      end
      observer.current_object
    end
  end
end
