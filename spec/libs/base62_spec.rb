require 'spec_helper'

RSpec.describe Base62 do
  describe 'encoding' do
    context 'input is not numeric' do
      it 'throws an Argument Error' do
        expect { Base62.encode 'text' }.to raise_error(ArgumentError)
      end
    end
    context 'input is numeric' do
      it 'correctly encodes' do
        expect(Base62.encode 10).to be_a(String)
      end
    end
  end
  describe 'decoding' do
    context 'input is not alphanumeric' do
      it 'throws an Argument Error' do
        expect { Base62.decode '!(*^#' }.to raise_error(ArgumentError)
      end
    end
    context 'input is alphanumeric' do
      it 'correctly decodes' do
        expect(Base62.decode 'abc').to be_a(Integer)
      end
    end
  end
  it 'encodes & decodes safely' do
    expect(Base62.decode(Base62.encode 10)).to eq(10)
  end

end
