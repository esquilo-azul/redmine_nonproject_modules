# frozen_string_literal: true

require 'i18n/backend/recursive_lookup'
I18n::Backend::Simple.include I18n::Backend::RecursiveLookup
