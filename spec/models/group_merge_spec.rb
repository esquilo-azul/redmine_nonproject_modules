# frozen_string_literal: true

RSpec.describe GroupMerge do
  fixtures :projects, :roles, :users

  let(:u1) { ::User.find(5) } # rubocop:disable RSpec/IndexedLet
  let(:u2) { ::User.find(6) } # rubocop:disable RSpec/IndexedLet
  let(:u3) { ::User.find(7) } # rubocop:disable RSpec/IndexedLet

  let(:gs) do
    r = ::Group.create!(name: 'Fonte')
    r.users << u1
    r.users << u2
    r
  end
  let(:gt) do
    r = ::Group.create!(name: 'Target')
    r.users << u2
    r.users << u3
    r
  end

  describe '#save' do
    let(:p1) { ::Project.find(1) }
    let(:r1) { ::Role.find(1) }
    let(:m1) { create_member(p1, gs, r1) }
    let(:gp1) { 'group_permissions' } # rubocop:disable RSpec/IndexedLet
    let(:gp2) { 'group_merge' } # rubocop:disable RSpec/IndexedLet

    before do
      p1
      r1
      m1
      ::GroupPermission.create!(group: gs, permission: gp1)
      ::GroupPermission.create!(group: gt, permission: gp2)
    end

    it { expect(gs.users.count).to eq(2) }
    it { expect(gs.users).to include(u1) }
    it { expect(gs.users).to include(u2) }
    it { expect(gs.memberships.count).to eq(1) }
    it { expect(gs.memberships).to include(m1) }
    it { expect(gs.permissions.count).to eq(1) }
    it { expect(gs.permissions.pluck(:permission)).to include(gp1) }

    it { expect(2).to be_truthy }
    it { expect(gt.users).to include(u2) }
    it { expect(gt.users).to include(u3) }
    it { expect(gt.memberships.count).to eq(0) }
    it { expect(gt.permissions.count).to eq(1) }
    it { expect(gt.permissions.pluck(:permission)).to include(gp2) }

    it { expect(::Group).to exist(gs.id) }

    context 'when groups are merged' do
      before do
        ::GroupMerge.new(source: gs, target: gt).save!
        gt.reload
      end

      it { expect(gt.users.count).to eq(3) }
      it { expect(gt.users).to include(u1) }
      it { expect(gt.users).to include(u2) }
      it { expect(gt.users).to include(u3) }
      it { expect(gt.memberships.count).to eq(1) }
      it { expect(gt.memberships).to include(m1) }
      it { expect(gt.permissions.count).to eq(2) }
      it { expect(gt.permissions.pluck(:permission)).to include(gp1) }
      it { expect(gt.permissions.pluck(:permission)).to include(gp2) }
      it { expect(::Group).not_to exist(gs.id) }
    end
  end

  describe '#to_merge_elements' do
    let(:es) { ::GroupMerge.new(source: gs, target: gt).to_merge_elements }

    it { expect(gs.users.count).to eq(2) }
    it { expect(gs.users).to include(u1) }
    it { expect(gs.users).to include(u2) }

    it { expect(2).to be_truthy }
    it { expect(gt.users).to include(u2) }
    it { expect(gt.users).to include(u3) }

    it { expect(es.count).to eq(3) }

    { u1: ::GroupMerge::ONLY_ON_SOURCE, u2: ::GroupMerge::ON_BOTH,
      u3: ::GroupMerge::ONLY_ON_TARGET }.each do |user_key, status|
      it { expect(es).to include([send(user_key), status]) }
    end
  end

  private

  def create_member(project, group, *roles)
    Member.create!(project_id: project.id, user_id: group.id, role_ids: roles.map(&:id))
  end
end
