RSpec.describe SimpleFacade do
  let(:facade) { SimpleFacade::Base.new }
  let(:a_class) { Class.new{ def a; 'a'; end} }
  let(:b_class) { Class.new{ def b; 'b'; end} }
  let(:c_class) { Class.new{ def c; 'c'; end} }

  it 'delegates methods to members' do
    obj1 = a_class.new
    obj2 = b_class.new
    obj3 = c_class.new
    facade.push(:a, obj1)
    facade.push(:b, obj2)
    facade.push(:c, obj3)
    expect(facade.a).to eq 'a'
    expect(facade.b).to eq 'b'
    expect(facade.c).to eq 'c'
    expect{ facade.d }.to raise_error(NoMethodError)
    facade.dequeue
    expect{ facade.a }.to raise_error(NoMethodError)
    facade.pop
    expect{ facade.c }.to raise_error(NoMethodError)
  end
end
