require 'spec_helper'

class DummyClass
  include ControlSpecHelper
end

describe 'control_spec_helper' do
  before do
    @dummy_class = DummyClass.new
  end

  it 'should have a default basepath' do
    expect(@dummy_class.basepath).to eq('site')
  end

  it 'should allow you to set basepath' do
    @dummy_class.basepath = 'dist'
    expect(@dummy_class.basepath).to eq('dist')
  end

  it 'should have a default basebranch' do
    expect(@dummy_class.basebranch).to eq('master')
  end

  it 'should allow you to set basebranch' do
    @dummy_class.basebranch = 'production'
    expect(@dummy_class.basebranch).to eq('production')
  end

  describe 'when debug environmental variable is set' do
    it 'should print properly-formatted debugging messages' do
      cached_env_debug = ENV['debug']
      ENV['debug'] = 'true'
      expect { @dummy_class.debug('spec') }.to output("DEBUG: spec\n").to_stderr
      ENV['debug'] = cached_env_debug
    end
  end

  describe 'when debug environmental variable is not set' do
    it 'should suppress debugging messages' do
      cached_env_debug = ENV['debug']
      ENV.delete('debug')
      expect { @dummy_class.debug('spec') }.to_not output('DEBUG: spec')
        .to_stderr
      ENV['debug'] = cached_env_debug
    end
  end

  it 'should print the puppet command' do
    cmd = "puppet apply manifests/site.pp \\\n      --modulepath " \
          '$(echo `pwd`/modules:`pwd`/site) --hiera_config hiera.yaml'
    expect(@dummy_class.puppet_cmd).to eq(cmd)
  end

  context 'if role_path is already set' do
    it 'should return the predefined role_path' do
      @dummy_class.instance_variable_set(:@role_path, '/role')
      @dummy_class.basepath = 'dist'
      expect(@dummy_class.role_path).to eq('/role')
    end
  end

  context 'if role_path is not locally set' do
    it 'should return a role_path based on basepath' do
      @dummy_class.instance_variable_set(:@root, '/projroot')
      @dummy_class.basepath = 'dist'
      expect(@dummy_class.role_path).to eq('/projroot/dist/role')
    end
  end

  context 'if profile_path is already set' do
    it 'should return the predefined profile_path' do
      @dummy_class.instance_variable_set(:@profile_path, '/prof')
      @dummy_class.basepath = 'dist'
      expect(@dummy_class.profile_path).to eq('/prof')
    end
  end

  context 'if profile_path is not locally set' do
    it 'should return a profile_path based on basepath' do
      @dummy_class.instance_variable_set(:@root, '/projroot')
      @dummy_class.basepath = 'dist'
      expect(@dummy_class.profile_path).to eq('/projroot/dist/profile')
    end
  end
end
