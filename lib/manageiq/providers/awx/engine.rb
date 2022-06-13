module ManageIQ
  module Providers
    module Awx
      class Engine < ::Rails::Engine
        isolate_namespace ManageIQ::Providers::Awx

        config.autoload_paths << root.join('lib').to_s

        initializer :append_secrets do |app|
          app.config.paths["config/secrets"] << root.join("config", "secrets.defaults.yml").to_s
          app.config.paths["config/secrets"] << root.join("config", "secrets.yml").to_s
        end

        def self.vmdb_plugin?
          true
        end

        def self.plugin_name
          _('Awx Provider')
        end

        def self.init_loggers
          $awx_log ||= Vmdb::Loggers.create_logger("awx.log")
        end

        def self.apply_logger_config(config)
          Vmdb::Loggers.apply_config_value(config, $awx_log, :level_awx)
        end
      end
    end
  end
end
