# frozen_string_literal: true

RSpec.describe GroupPermission, type: :feature do
  class << self
    def test_not_converted(*args); end
  end

  fixtures :users

  before do
    described_class.add_permission('dummy_permission')
    described_class.add_permission('include', dependencies: [:dummy_permission])
  end

  context 'when admin access protected page' do
    include_context 'with logged user', 'admin'

    before do
      visit '/group_permissions'
    end

    it { expect(described_class).to be_permission('group_permissions') }
    it { expect(page.status_code).to eq(200) }
  end

  context 'when no admin access protected page' do
    include_context 'with logged user', 'jsmith'

    let(:no_admin) { users(:users_002) } # rubocop:disable Naming/VariableNumber

    before do
      visit '/group_permissions'
    end

    it { expect(described_class).not_to be_permission('group_permissions') }
    it { expect(page.status_code).to eq(403) }

    context 'when permission is added' do
      let(:g) do
        r = Group.create!(name: 'My group')
        r.users << no_admin
        r
      end

      before do
        described_class.create!(group: g, permission: 'group_permissions')
        visit '/group_permissions'
      end

      it { expect(described_class).to be_permission('group_permissions') }
      it { expect(page.status_code).to eq(200) }
    end
  end

  describe 'permission dependency' do
    let(:no_admin) { users(:users_002) } # rubocop:disable Naming/VariableNumber
    let(:g) do
      r = Group.create!(name: 'My group')
      r.users << no_admin
      r.save!
      r
    end

    def assert_dummy_includes(user, dummy, include)
      e = { dummy_permission: dummy, include: include }
      a = e.keys.to_h { |p| [p, user.permission?(p)] }
      expect(a).to eq(e)
    end

    it { assert_dummy_includes(no_admin, false, false) }

    context 'when "dummy_permission" permission is given to group' do
      before do
        described_class.create!(group: g, permission: 'dummy_permission')
      end

      it { assert_dummy_includes(no_admin, true, false) }
    end

    context 'when "include" permission is given to group' do
      before do
        described_class.create!(group: g, permission: 'include')
      end

      it { assert_dummy_includes(no_admin, true, true) }
    end
  end

  it 'blocks no existing dependencies' do
    expect { described_class.add_permission('recursive1', dependencies: %w[not_exist]) }
      .to raise_error(StandardError)
  end

  describe 'no redefine dependencies' do
    let(:key) { 'permission1' }

    before { described_class.add_permission(key) }

    it { expect(described_class.permission(key).dependencies.count).to be_zero }

    context 'when permission is re-added' do
      before { described_class.add_permission(key, dependencies: %w[dummy_permission]) }

      it('re-adding has no effect') do
        expect(described_class.permission(key).dependencies.count).to be_zero
      end
    end
  end
end
