# frozen_string_literal: true

module AR2DTO
  # Extensions to `ActiveRecord::Base`.
  module HasDTO
    def self.included(base)
      base.extend ::AR2DTO::HasDTO::ClassMethods
    end

    module ClassMethods
      # Declare this in your model to expose the DTO helpers.
      #
      # @api public
      def has_dto
        include ::AR2DTO::HasDTO::InstanceMethods
        namespace = name.deconstantize.presence&.constantize || Object
        class_name = "#{name.split("::").last}DTO"

        return if namespace.const_defined?(class_name)

        namespace.const_set(class_name, AR2DTO::DTO[self])
      end

      # @api public
      def to_dto(options = {})
        all.map { |record| record.to_dto(options) }
      end
    end

    # Wrap the following methods in a module so we can include them only in the
    # ActiveRecord models that declare `has_dto`.
    module InstanceMethods
      # @api public
      def to_dto(options = {})
        options = apply_global_configs(options)

        hash = serializable_hash(options&.except(:include))
        hash = add_associations(hash, options&.dig(:include))

        "#{self.class.name}DTO".constantize.new(hash)
      end

      private

      def apply_global_configs(options)
        options[:except] = AR2DTO::Config.instance.except + Array(options[:except])
        options
      end

      def add_associations(hash, includes)
        includes_to_dto(includes) do |association, records, opts|
          hash[association.to_s] = if records.respond_to?(:to_ary)
                                     records.to_ary.map { |a| a.to_dto(opts) }
                                   else
                                     records.to_dto(opts)
                                   end
        end
        hash
      end

      def includes_to_dto(includes)
        unless includes.is_a?(Hash)
          includes = Array(includes).flat_map { |n| n.is_a?(Hash) ? n.to_a : [[n, {}]] }.to_h
        end

        includes.each do |association, opts|
          records = send(association)

          yield association, records, opts if records
        end
      end
    end
  end
end
