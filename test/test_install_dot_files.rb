require 'test_helper'
require 'minitest'


class ResourceTest < Minitest::Test
  # def test_brew_install
  #   if Brew.installed?
  #     Brew.remove
  #   end
  #   refute Brew.installed?
  #   Brew.install
  #   assert Brew.installed?
  # end

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

end
class MikeyInstallerTest < Minitest::Test

end
