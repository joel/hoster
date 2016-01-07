require 'spec_helper'

describe RedisProxy do
  let(:instance) { described_class.new }

  describe '#list' do
    it 'should give the entirely list' do
      expect(instance.list).to eql(['Alexandra', 'AntoineQ', 'Joel', 'Krzysztof', 'Lukasz', 'Steve'])
    end
  end

  describe '#add' do
    it 'blacklist person added' do
      expect { instance.add('AntoineQ') }.to change {
        instance.white_list
      }.from(
        ['Alexandra', 'AntoineQ', 'Joel', 'Krzysztof', 'Lukasz', 'Steve']
      ).to(
        ['Alexandra', 'Joel', 'Krzysztof', 'Lukasz', 'Steve']
      )
    end
    it 'do nothing if person is not on the list' do
      expect { instance.add('John Doe') }.to_not change { instance.white_list }
    end
    it 'add with custom time' do
      expect_any_instance_of(MockRedis).to receive(:expire).with('HOST::BLACK_LIST_KEY::Steve', T_2_WEEKS)
      instance.add('Steve', T_2_WEEKS)
    end
  end

  describe '#get' do
    shared_context 'fake list of names' do
      before { expect(instance).to receive(:white_list) { double(sample: 'Joel') } }
    end

    context 'dry == true' do
      let(:dry) { true }
      include_context 'fake list of names'
      it 'shouldn\'t push the name on the blacklist' do
        expect(instance.get(dry)).to eql('Joel')
        expect(instance.send(:black_list)).to be_empty
      end
    end

    context 'dry == false' do
      let(:dry) { false }
      include_context 'fake list of names'
      it 'should push the name on the blacklist' do
        expect(instance.get(dry)).to eql('Joel')
        expect(instance.send(:black_list)).to eql(['Joel'])
      end
    end
  end

  describe '#add_to_black_list' do
    before do
      expect_any_instance_of(MockRedis).to receive(:set).with('HOST::BLACK_LIST_KEY::JOEL', 'JOEL')
      expect_any_instance_of(MockRedis).to receive(:expire).with('HOST::BLACK_LIST_KEY::JOEL', T_3_WEEKS)
    end
    it { expect(instance.send(:add_to_black_list, 'JOEL')).to eql('JOEL') }
  end

  describe '#black_list' do
    context 'with a name pushed on the blacklist' do
      before do
        instance.send(:add_to_black_list, 'Joel')
        expect(instance.send(:black_list)).to eql(['Joel'])
      end
      describe '#reset_black_list' do
        it 'should give the name blacklisted' do
          expect { instance.reset }.to change { instance.send(:black_list) }.from(['Joel']).to([])
        end
      end
    end
  end

  describe '#black_list_with_time' do
    context 'with a name pushed on the blacklist' do
      before do
        instance.send(:add_to_black_list, 'Joel')
        expect(instance.send(:black_list)).to eql(['Joel'])
        expect_any_instance_of(MockRedis).to receive(:ttl).with('HOST::BLACK_LIST_KEY::Joel') { 1814352 }
      end
      it 'should give the name blacklisted with left time' do
        expect(instance.black_list_with_time).to eql([['Joel', '20 days, 23 hours, 59 minutes and 12 seconds']])
      end
    end
  end

  describe '#white_list' do
    context 'without black_list' do
      it 'should give the entirely list' do
        expect(instance.white_list).to eql(['Alexandra', 'AntoineQ', 'Joel', 'Krzysztof', 'Lukasz', 'Steve'])
      end
    end
    context 'with black_list' do
      before { expect(instance).to receive(:black_list) { ['Alexandra', 'AntoineQ', 'Joel'] } }
      it 'should give list without black listed persons' do
        expect(instance.white_list).to eql(['Krzysztof', 'Lukasz', 'Steve'])
      end
    end
  end
end
