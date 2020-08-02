RSpec.describe SimpleFacade do
  let(:facade) { SimpleFacade::Base.new }

  it 'has a version number' do
    expect(SimpleFacade::VERSION).not_to be nil
  end

  it 'has collection inside' do
    expect(facade.instance_variables).to include(:@subjects)
  end

  it 'adds elements to end' do
    obj1 = Object.new
    obj2 = Object.new
    facade.push(:a, obj1)
    facade.push(:b, obj2)
    expect(facade.members).to eq({a: obj1, b: obj2})
  end

  it 'adds elements to head' do
    obj1 = Object.new
    obj2 = Object.new
    facade.enqueue(:a, obj1)
    facade.enqueue(:b, obj2)
    expect(facade.members).to eq({b: obj2, a: obj1})
  end

  it 'removes elements from the end' do
    obj1 = Object.new
    obj2 = Object.new
    facade.push(:a, obj1)
    facade.push(:b, obj2)
    facade.pop
    expect(facade.members).to eq({a: obj1})
  end

  it 'removes elements from the head' do
    obj1 = Object.new
    obj2 = Object.new
    facade.enqueue(:a, obj1)
    facade.enqueue(:b, obj2)
    facade.dequeue
    expect(facade.members).to eq({a: obj1})
  end

  it 'inserts elements' do
    obj1 = Object.new
    obj2 = Object.new
    obj3 = Object.new
    facade.enqueue(:a, obj1)
    facade.enqueue(:b, obj2)
    facade.insert(0, :c, obj3)
    expect(facade.members).to eq({a: obj1, c: obj3, b: obj2})
  end

  it 'removes elements' do
    obj1 = Object.new
    obj2 = Object.new
    obj3 = Object.new
    facade.enqueue(:a, obj1)
    facade.enqueue(:b, obj2)
    facade.enqueue(:c, obj3)
    facade.delete(:b)
    expect(facade.members).to eq({a: obj1, c: obj3})
  end
end
