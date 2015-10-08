require 'test_helper'
require 'minitest'


class ResourceTest < Minitest::Test
  def setup
    Brew.install unless Brew.installed?
  end

  def test_resource_install
    descendents = ObjectSpace.each_object(Resource.singleton_class).to_a - [Resource]
    descendents.each do |resource|
      require 'byebug'; byebug
      if resource.installed?
        resource.remove
      end
      refute(resource.installed?, "Couldn't delete #{resource.install_name}")
      resource.install
      assert(resource.installed?, "Couldn't install #{resource.install_name}")
    end
  end

  def test_symlinks_respect_bak
    Zshrc.remove if Zshrc.installed?
    File.open(Zshrc.local_path, 'w') {|f| f.write("Foo")}
    Zshrc.install
    Zshrc.remove
    assert_equal(File.open(Zshrc.local_path, 'r').read, "Foo")
    File.delete(Zshrc.local_path)
    Zshrc.install
  end

  def test_zshrc_has_path
    zshrc_path = Zshrc.local_path
    lines = File.open(zshrc_path, "r+") { |f| f.readlines }
    lines.reject! { |line| line =~ /#{Zshrc.bin_path}/ }
    File.open(zshrc_path, "w") { |f| lines.each(&f.method(:write)) }
    Zshrc.remove
    Zshrc.install
    refute(File.open(zshrc_path, "r+") { |f| f.readlines }.select { |line| line =~ /#{Zshrc.bin_path}/ }.empty?)
  end
end
