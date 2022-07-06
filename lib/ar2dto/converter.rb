# frozen_string_literal: true

module AR2DTO
  class Converter
    attr_reader :model, :options

    def initialize(model, options)
      @model = model
      @options = apply_configs(options)
    end

    def serializable_hash
      hash = model.serializable_hash(options&.except(:methods, :include))
      hash = add_methods(hash)
      add_associations(hash)
    end

    private

    def apply_configs(options)
      options[:except] = Array(model.class.ar2dto.except) | Array(options[:except])
      options
    end

    def add_methods(hash)
      options&.dig(:methods)&.each do |method|
        result = model.send(method)
        result = if result.respond_to?(:to_dto)
                   result.to_dto
                 else
                   result.as_json
                 end
        hash[method.to_s] = result
      end
      hash
    end

    def add_associations(hash)
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
