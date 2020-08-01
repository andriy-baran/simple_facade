RSpec.describe SimpleFacade do
  let(:facade) { SimpleFacade::Base.new }

  it 'has a version number' do
    expect(SimpleFacade::VERSION).not_to be nil
  end

  it 'has collection inside' do
    expect(facade.instance_variables).to include(:@__collection__)
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
end
