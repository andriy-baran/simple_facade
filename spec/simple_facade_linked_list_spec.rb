RSpec.describe SimpleFacade do
  let(:facade) { SimpleFacade::Base.new.extend(SimpleFacade::Linking) }
  let(:a_class) { Class.new{ def a; 'a'; end} }
  let(:b_class) { Class.new{ def b; 'b'; end} }
  let(:c_class) { Class.new{ def c; 'c'; end} }

  context 'reverse doubly linked list' do
    it 'creates links to predecessors and successors' do
      obj1 = a_class.new
      obj2 = b_class.new
      obj3 = c_class.new
      facade.facade_push(:oa, obj1)
      facade.facade_push(:ob, obj2)
      facade.facade_push(:oc, obj3)
      facade.double_link_members
      expect(facade.oa).to eq obj1
      expect(facade.oa.ob).to eq obj2
      expect(facade.oa.ob.oc).to eq obj3
      expect(facade.ob).to eq obj2
      expect(facade.ob.oa).to eq obj1
      expect(facade.ob.oc).to eq obj3
      expect(facade.oc).to eq obj3
      expect(facade.oc.ob).to eq obj2
      expect(facade.oc.ob.oa).to eq obj1
      expect(facade.ob.predecessor).to eq :oa
      expect(facade.ob.successor).to eq :oc
      expect(facade.oc.predecessor).to eq :ob
      expect(facade.oa.successor).to eq :ob
      expect{ facade.oc.successor }.to raise_error(NoMethodError)
      expect{ facade.oa.predecessor }.to raise_error(NoMethodError)
    end

    it 'returns linked list' do
      obj1 = a_class.new
      obj2 = b_class.new
      obj3 = c_class.new
      facade.facade_push(:oa, obj1)
      facade.facade_push(:ob, obj2)
      facade.facade_push(:oc, obj3)
      linked_list = facade.double_link_members
      expect(linked_list).to eq obj3
      expect(linked_list.ob).to eq obj2
      expect(linked_list.ob.oa).to eq obj1
    end
  end

  context 'direct single linked list' do
    it 'creates links to predecessors and successors' do
      obj1 = a_class.new
      obj2 = b_class.new
      obj3 = c_class.new
      facade.facade_enqueue(:oa, obj1)
      facade.facade_enqueue(:ob, obj2)
      facade.facade_enqueue(:oc, obj3)
      facade.link_members
      expect(facade.oa).to eq obj1
      expect(facade.oa.ob).to eq obj2
      expect(facade.oa.ob.oc).to eq obj3
      expect(facade.ob.oc).to eq obj3
      expect(facade.ob).to eq obj2
      expect{ facade.ob.successor }.to raise_error(NoMethodError)
      expect(facade.ob.predecessor).to eq :oc
      expect{ facade.oc.successor }.to raise_error(NoMethodError)
      expect{ facade.oc.predecessor }.to raise_error(NoMethodError)
      expect(facade.oa.predecessor).to eq :ob
      expect{ facade.oa.successor }.to raise_error(NoMethodError)
    end

    it 'returns linked list' do
      obj1 = a_class.new
      obj2 = b_class.new
      obj3 = c_class.new
      facade.facade_enqueue(:oa, obj1)
      facade.facade_enqueue(:ob, obj2)
      facade.facade_enqueue(:oc, obj3)
      linked_list = facade.link_members
      expect(linked_list).to eq obj1
      expect(linked_list.ob).to eq obj2
      expect(linked_list.ob.oc).to eq obj3
    end
  end
end
