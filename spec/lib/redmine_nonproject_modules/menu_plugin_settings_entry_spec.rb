# frozen_string_literal: true

RSpec.describe RedmineNonprojectModules::MenuPluginSettingsEntry do
  let(:configurable_plugin) do
    instance_double(Redmine::Plugin, id: :configurable_plugin, configurable?: true)
  end
  let(:not_configurable_plugin) do
    instance_double(Redmine::Plugin, id: :not_configurable_plugin, configurable?: false)
  end

  describe '#build' do
    let(:expected) do
      [:plugin_settings,
       { controller: 'settings', action: 'plugin', id: 'configurable_plugin' },
       { caption: :label_settings, icon: 'settings', html: { class: 'icon icon-settings' },
         if: nil }]
    end
    let(:actual) do
      r = described_class.new(configurable_plugin).build
      r[2][:if] = nil
      r
    end

    it { expect(actual).to eq(expected) }
  end

  describe '#build with options' do
    let(:actual) { described_class.new(configurable_plugin, caption: :label_other).build }

    it { expect(actual[2][:caption]).to eq(:label_other) }
  end

  describe '#initialize with not configurable plugin' do
    it do
      expect { described_class.new(not_configurable_plugin) }.to raise_error(ArgumentError)
    end
  end
end
