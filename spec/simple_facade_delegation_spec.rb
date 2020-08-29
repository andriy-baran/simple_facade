RSpec.describe SimpleFacade do
  let(:facade) { Class.new { include SimpleFacade::Mixin }.new }
  let(:a_class) { Class.new{ def a; 'a'; end} }
  let(:b_class) { Class.new{ def mb; 'b'; end} }
  let(:c_class) { Class.new{ def mc; 'c'; end} }

  it 'delegates methods to members' do
    obj1 = a_class.new
    obj2 = b_class.new
    obj3 = c_class.new
    facade.facade_push(:a, obj1)
    facade.facade_push(:b, obj2)
    facade.facade_push(:c, obj3)
    expect(facade).to respond_to(:a)
    expect(facade).to respond_to(:b)
    expect(facade).to respond_to(:c)
    expect(facade.a).to eq obj1
    expect(facade.b).to eq obj2
    expect(facade.c).to eq obj3
    expect(facade.a.a).to eq 'a'
    expect(facade.mb).to eq 'b'
    expect(facade.mc).to eq 'c'
    expect{ facade.d }.to raise_error(NoMethodError)
    facade.facade_dequeue
    expect{ facade.a }.to raise_error(NoMethodError)
    facade.facade_pop
    expect{ facade.c }.to raise_error(NoMethodError)
    expect(facade.mb).to eq 'b'
  end
end
