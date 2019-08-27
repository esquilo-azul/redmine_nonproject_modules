# frozen_string_literal: true

require 'test_helper'

module RedmineNonprojectModules
  module Patches
    module Redmine
      class MenuManagerMapperPatchTest < ActiveSupport::TestCase
        def test_build
          expected = [:colaboradores, { controller: 'colaboradores', action: 'index', id: nil },
                      caption: :label_colaboradores,
                      if: nil]
          actual = ControllerEntry.new('colaboradores').build
          actual[2][:if] = nil
          assert_equal expected, actual
        end

        def test_build_with_action
          expected = [:lotacoes_arvore, { controller: 'lotacoes', action: 'arvore', id: nil },
                      caption: :label_lotacoes_arvore,
                      if: nil]
          actual = ControllerEntry.new('lotacoes', action: 'arvore').build
          actual[2][:if] = nil
          assert_equal expected, actual
        end
      end
    end
  end
end
