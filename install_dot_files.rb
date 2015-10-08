#!/usr/bin/env ruby

require 'optparse'
require 'yaml'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: install.rb [options]"
  opts.on("-g", "--guest", "Install as guest") do
    options[:guest] = true
  end
  opts.on("-r", "--remove", "Remove all guest-installed packages") do
    options[:remove] = true
  end
  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
    options[:verbose] = true
  end
  opts.on("-f", "--force_remove", "Deletes everything installed by this script") do
    options[:force_remove] = true
  end
end.parse!

class Resource
  class << self
    def install_name
      self.name.downcase
    end

    def announce_install
      puts "Installing #{install_name}"
    end

    def announce_removal
      puts "Removing #{install_name}"
    end

    def install
      announce_install
      install_resource
    end

    def install_resource
      %x(./homebrew/bin/brew install #{install_name})
    end

    def remove
      announce_removal
      remove_resource
    end

    def remove_resource
      %x(./homebrew/bin/brew uninstall #{install_name} --force)
    end

    def installed?
      File.exists?("#{File.expand_path(".")}/homebrew/bin/#{install_name}")
    end
  end
end

class Brew < Resource
  class << self
    def install_resource
      %x{mkdir homebrew && curl -L https://github.com/Homebrew/homebrew/tarball/master | tar xz --strip 1 -C homebrew}
    end
    def remove_resource
      %x{rm -rf homebrew}
    end
    def installed?
      File.exists?("./homebrew")
    end
  end
end


# class CapsLockIsControl < Resource
# end

class SymLink < Resource
  class << self
    def installed?
      File.identical?(*[local_path, install_path].map(&File.method(:expand_path)))
    end
    def install_resource
      if File.exists?(File.expand_path(local_path))
        %x(mv #{local_path} #{local_path}.steggy_dotfile_bak)
      end
      %x(ln -s #{install_path} #{local_path})
    end
    def remove_resource
      %x(rm #{local_path} )
      if File.exists?(File.expand_path("#{local_path}.steggy_dotfile_bak"))
        %x(mv #{local_path}.steggy_dotfile_bak #{local_path})
      end
    end
  end
end

class PlayDir < Resource
  class << self
    def local_path
      File.expand_path("~/play")
    end
    def install_resource
      %x(mkdir -p #{local_path})
    end
    def remove_resource
      %x(rmdir #x{local_path})
    end
    def installed?
      File.exists?(local_path)
    end
  end
end

class Zshrc < SymLink
  class << self
    def local_path
      File.expand_path("~/.zshrc")
    end
    def install_path
      "#{Dir.pwd}/shell/zshrc"
    end
  end
end
class Dreamacs < SymLink
  class << self
    def local_path
      File.expand_path("~/play/dreamacs")
    end
    def install_path
      "#{Dir.pwd}/#{install_name}"
    end
    def install_resource
      super
      local_app_path = Dir.glob("#{File.expand_path("./")}/homebrew/Cellar/emacs/*/Emacs.app").first
      %x(open #{local_app_path})
    end
  end
end

class Dotemacs < SymLink
  class << self
    def install_name
      "custom_dotemacs"
    end
    def install_path
      "#{Dir.pwd}/#{install_name}"
    end
    def local_path
      "~/.emacs.d"
    end
  end
end

class Zshrc < SymLink

end


class Git < Resource; end
class Zsh < Resource; end
class Rbenv < Resource; end
class Direnv < Resource; end

class Emacs < Resource
  def self.install_resource
    %x(./homebrew/bin/brew install emacs --with-cocoa)
  end
end

class MikeyInstaller
  def initialize(resources)
    @resources = resources
  end
  def manifest_file
    "install_manifest.yml"
  end

  def guest
    installed = []
    @resources.each do |resource|
      unless resource.installed?
          resource.install
        installed << resource.install_name
      end
    end
    File.open(manifest_file, "a+") { |f| f.write(YAML.dump(installed)) }
  end
  def remove
    guest_installed_resources = YAML.load(File.open(manifest_file, "r"))
    @resources.each do |resource|
      if resource.installed? && guest_installed_resources.include?(resource.install_name)
          resource.remove
      end
    end
    File.delete(manifest_file)
  end

  def force_remove
    puts "Are you really, really sure you want to force remove?(y/N)"
    response = gets.strip
    if response.downcase == "y"
      @resources.each do |resource|
          resource.remove
      end
    end
    File.delete(manifest_file)
  end
end


installer = MikeyInstaller.new([Brew, Rbenv, Direnv, Emacs, Git, Zsh, Zshrc, Dotemacs, PlayDir, Dreamacs])


options.keys.each {|x| installer.send(x) }
