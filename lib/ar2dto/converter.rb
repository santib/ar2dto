# frozen_string_literal: true

module AR2DTO
  class Converter
    ALLOWED_TYPES = [
      Symbol, BigDecimal, Regexp, IO, Range, Time, Date, DateTime,
      URI::Generic, Pathname, IPAddr, Process::Status, Exception,
      ActiveSupport::TimeWithZone
    ].freeze
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
        hash[method.to_s] = data_only(model.send(method))
      end
      hash
    end

    def data_only(object)
      if object.respond_to?(:to_dto)
        object.to_dto
      elsif object.is_a?(::AR2DTO::DTO) || ALLOWED_TYPES.include?(object.class)
        object
      else
        object.as_json
      end
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
