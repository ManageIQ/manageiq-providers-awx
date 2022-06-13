shared_context "uses tower_data.yml" do
  let(:tower_data) { YAML.load_file(ManageIQ::Providers::Awx::Engine.root.join("spec/support/tower_data.yml")) }
end
