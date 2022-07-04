# frozen_string_literal: true

module AR2DTO
  class ModelConfig
    attr_reader :model, :model_config

    def initialize(model)
      @model = model
    end

    def setup_config(model_config)
      @model_config ||= model_config
    end

    def active_model_compliance
      @active_model_compliance ||= global_config.active_model_compliance
    end

    def except
      @except ||= Array(global_config.except) | Array(model_config[:except])
    end

    def class_name
      @class_name ||= namespaced_class_name.split("::").last
    end

    def namespace
      @namespace ||= namespaced_class_name.deconstantize.presence&.constantize || Object
    end

    def namespaced_class_name
      @namespaced_class_name ||= model_config[:class_name] || model_name_replaced_suffix
    end

    private

    def model_name_replaced_suffix
      "#{model.name.delete_suffix(global_config.delete_suffix.to_s)}#{global_config.add_suffix}"
    end

    def global_config
      AR2DTO::Config.instance
    end
  end
end
