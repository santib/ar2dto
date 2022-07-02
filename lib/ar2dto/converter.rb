# frozen_string_literal: true

module AR2DTO
  class Converter
    attr_reader :model, :options

    def initialize(model, options)
      @model = model
      @options = apply_configs(options)
    end

    def serializable_hash
      hash = model.serializable_hash(options&.except(:include))

      hash_with_associations(hash)
    end

    private

    def apply_configs(options)
      options[:except] = Array(model.class.ar2dto.except) | Array(options[:except])
      options
    end

    def hash_with_associations(hash)
      includes.each do |association, opts|
        records = model.send(association)
        hash[association.to_s] = records ? records_dto(records, opts) : nil
      end
      hash
    end

    def includes
      includes = options&.dig(:include)
      return includes if includes.is_a?(Hash)

      Array(includes).flat_map { |n| n.is_a?(Hash) ? n.to_a : [[n, {}]] }.to_h
    end

    def records_dto(records, opts)
      if records.respond_to?(:to_ary)
        records.to_ary.map { |a| a.to_dto(opts) }
      else
        records.to_dto(opts)
      end
    end
  end
end
