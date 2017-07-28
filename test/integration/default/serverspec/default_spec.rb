require_relative './spec_helper'

describe 'ansible-sudoers::default' do

  describe package('sudo') do
    it { should be_installed }
  end

  describe file('/etc/sudoers') do
    it { should exist }
    it { should be_mode 440 }
    it { should be_owned_by 'root' }
    its(:content) { should match(/#includedir \/etc\/sudoers.d/) }
    its(:content) { should match(/User_Alias ADMINS = %admin,%wheel/) }
  end

  describe file('/etc/sudoers.d/kitchen') do
    it { should exist }
    it { should be_mode 440 }
    it { should be_owned_by 'root' }
    its(:content) { should match(/kitchen ALL=\(ALL\) NOPASSWD: ALL/) }
  end

  describe file('/etc/sudoers.d/admins') do
    it { should exist }
    it { should be_mode 440 }
    it { should be_owned_by 'root' }
    its(:content) { should match(/ADMINS ALL=\(ALL\) ALL/) }
  end

end
