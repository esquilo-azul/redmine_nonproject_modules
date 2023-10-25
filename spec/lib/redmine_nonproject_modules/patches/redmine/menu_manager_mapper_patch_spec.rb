# frozen_string_literal: true

RSpec.describe RedmineNonprojectModules::Patches::Redmine::MenuManagerMapperPatch do
  let(:controller_entry_class) { RedmineNonprojectModules::Patches::Redmine::ControllerEntry }

  describe 'build' do
    let(:expected) do
      [:colaboradores, { controller: 'colaboradores', action: 'index', id: nil },
       { caption: :label_colaboradores,
         if: nil }]
    end
    let(:actual) do
      r = controller_entry_class.new('colaboradores').build
      r[2][:if] = nil
      r
    end

    it { expect(actual).to eq(expected) }
  end

  describe 'build with action' do
    let(:expected) do
      [:lotacoes_arvore, { controller: 'lotacoes', action: 'arvore', id: nil },
       { caption: :label_lotacoes_arvore,
         if: nil }]
    end
    let(:actual) do
      r = controller_entry_class.new('lotacoes', action: 'arvore').build
      r[2][:if] = nil
      r
    end

    it { expect(actual).to eq(expected) }
  end
end
