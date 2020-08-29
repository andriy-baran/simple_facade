RSpec.describe SimpleFacade do
  let(:facade) { SimpleFacade::Base.new(d: 'e', f: 'g') }

  it 'has a version number' do
    expect(SimpleFacade::VERSION).not_to be nil
  end

  it 'has collection inside' do
    expect(facade.instance_variables).to include(:@__subjects__)
  end

  it 'adds elements to end' do
    obj1 = Object.new
    obj2 = Object.new
    facade.facade_push(:a, obj1)
    facade.facade_push(:b, obj2)
    expect(facade.send(:__subjects__)).to eq([[:d, 'e'], [:f, 'g'], [:a, obj1], [:b, obj2]])
  end

  it 'adds elements to head' do
    obj1 = Object.new
    obj2 = Object.new
    facade.facade_enqueue(:a, obj1)
    facade.facade_enqueue(:b, obj2)
    expect(facade.send(:__subjects__)).to eq([[:b, obj2], [:a, obj1], [:d, 'e'], [:f, 'g']])
  end

  it 'removes elements from the end' do
    obj1 = Object.new
    obj2 = Object.new
    facade.facade_push(:a, obj1)
    facade.facade_push(:b, obj2)
    facade.facade_pop
    expect(facade.send(:__subjects__)).to eq([[:d, 'e'], [:f, 'g'], [:a, obj1]])
  end

  it 'removes elements from the head' do
    obj1 = Object.new
    obj2 = Object.new
    facade.facade_enqueue(:a, obj1)
    facade.facade_enqueue(:b, obj2)
    facade.facade_dequeue
    expect(facade.send(:__subjects__)).to eq([[:a, obj1], [:d, 'e'], [:f, 'g']])
  end

  it 'inserts elements' do
    obj1 = Object.new
    obj2 = Object.new
    obj3 = Object.new
    facade.facade_enqueue(:a, obj1)
    facade.facade_enqueue(:b, obj2)
    facade.facade_insert(0, :c, obj3)
    expect(facade.send(:__subjects__)).to eq([[:c, obj3], [:b, obj2], [:a, obj1], [:d, 'e'], [:f, 'g']])
  end

  it 'removes elements' do
    obj1 = Object.new
    obj2 = Object.new
    obj3 = Object.new
    facade.facade_enqueue(:a, obj1)
    facade.facade_enqueue(:b, obj2)
    facade.facade_enqueue(:c, obj3)
    facade.facade_delete(:b)
    expect(facade.send(:__subjects__)).to eq([[:c, obj3], [:a, obj1], [:d, 'e'], [:f, 'g']])
  end
end
