module ManageIQ
  module Providers
    module Awx
      class Engine < ::Rails::Engine
        isolate_namespace ManageIQ::Providers::Awx

        config.autoload_paths << root.join('lib').to_s

        def self.vmdb_plugin?
          true
        end

        def self.plugin_name
          _('AWX Provider')
        end

        def self.init_loggers
          $awx_log ||= Vmdb::Loggers.create_logger("awx.log", Vmdb::Loggers::ProviderSdkLogger)
        end

        def self.apply_logger_config(config)
          Vmdb::Loggers.apply_config_value(config, $awx_log, :level_awx)
        end
      end
    end
  end
end
