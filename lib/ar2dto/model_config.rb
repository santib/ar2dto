# frozen_string_literal: true

module AR2DTO
  class ModelConfig
    attr_reader :model, :configs

    def initialize(model)
      @model = model
    end

    def setup_config(configs)
      @configs = AR2DTO::Config.instance.as_json.merge(configs.as_json).symbolize_keys
    end

    def except
      configs[:except]
    end

    def class_name
      configs[:class_name] ||
        "#{configs[:class_prefix]}#{model.name.split("::").last}#{configs[:class_suffix]}"
    end

    def namespace
      @namespace ||= model.name.deconstantize.presence&.constantize || Object
    end

    def namespaced_class_name
      "#{namespace}::#{class_name}"
    end
  end
end
