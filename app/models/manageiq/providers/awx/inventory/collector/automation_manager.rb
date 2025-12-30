class ManageIQ::Providers::Awx::Inventory::Collector::AutomationManager < ManageIQ::Providers::Awx::Inventory::Collector
  def connection
    @connection ||= manager.connect
  end

  def config
    config, _status_code, _headers = AwxClient::ConfigApi.new(connection).config_retrieve_with_http_info(:debug_return_type => "String")
    JSON.parse(config)
  end

  def inventories
    inventories_api = AwxClient::InventoriesApi.new(connection)
    paginated_get { |page| inventories_api.inventories_list(:page => page) }
  end

  def hosts
    hosts_api = AwxClient::HostsApi.new(connection)
    paginated_get { |page| hosts_api.hosts_list(:page => page) }
  end

  def job_templates
    job_templates_api = AwxClient::JobTemplatesApi.new(connection)
    paginated_get { |page| job_templates_api.job_templates_list(:page => page) }
  end

  def job_template_survey_spec(job_template)
    job_templates_api = AwxClient::JobTemplatesApi.new(connection)
    data, _, _ = job_templates_api.job_templates_survey_spec_retrieve_with_http_info(job_template.id, :debug_return_type => "String")
    YAML.load(data)
  end

  def configuration_workflows
    workflow_job_templates_api = AwxClient::WorkflowJobTemplatesApi.new(connection)
    paginated_get { |page| workflow_job_templates_api.workflow_job_templates_list(:page => page) }
  end

  def workflow_job_template_survey_spec(workflow_job_template)
    workflow_job_templates_api = AwxClient::WorkflowJobTemplatesApi.new(connection)
    data, _, _ = workflow_job_templates_api.workflow_job_templates_survey_spec_retrieve_with_http_info(workflow_job_template.id, :debug_return_type => "String")
    YAML.load(data)
  end

  def projects
    projects_api = AwxClient::ProjectsApi.new(connection)
    paginated_get { |page| projects_api.projects_list(:page => page) }
  end

  def project_playbooks(project)
    projects_api = AwxClient::ProjectsApi.new(connection)
    playbook_names, _status_code, _headers = AwxClient::ProjectsApi.new(connection).projects_playbooks_retrieve_with_http_info(project.id, :debug_return_type => "String")
    JSON.parse(playbook_names)
  end

  def credentials
    credentials_api = AwxClient::CredentialsApi.new(connection)
    paginated_get { |page| credentials_api.credentials_list(:page => page) }
  end
end
