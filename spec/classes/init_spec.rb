require 'spec_helper'
describe 'dell_omsa' do

  context 'with defaults for all parameters' do
    it { should contain_class('dell_omsa') }
  end
end
