# frozen_string_literal: true

module AR2DTO
  class ModelConfig
    attr_reader :model, :configs

    def initialize(model)
      @model = model
    end

    def setup_config(configs)
      @configs = AR2DTO::Config.instance.as_json.merge(configs.as_json)
    end

    def except
      configs["except"]
    end

    def class_name
      configs["class_name"] ||
        model_name.sub(/#{configs["replace_suffix"]["from"]}$/, configs["replace_suffix"]["to"].to_s)
    end

    def namespace
      @namespace ||= model.name.deconstantize.presence&.constantize || Object
    end

    def namespaced_class_name
      "#{namespace}::#{class_name}"
    end

    private

    def model_name
      model.name.split("::").last
    end
  end
end
