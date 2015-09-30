#!/usr/bin/env ruby

require 'optparse'
require 'yaml'
require 'byebug'

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
    def install
      %x(brew install #{install_name})
    end
    def remove
      %x(brew uninstall #{install_name} --force)
    end
    def installed?
      File.exists?("/usr/local/bin/#{install_name}")
    end
  end
end

# class CapsLockIsControl < Resource
# end

class SymLink < Resource
  def self.installed?
    File.identical?(*[local_path, install_path].map(&File.method(:expand_path)))
  end
end

class PlayDir < Resource
  class << self
    def local_path
      File.expand_path("~/play")
    end
    def install
      %x(mkdir -p #{local_path})
    end
    def remove
      %x(rmdir #x{local_path})
    end
    def installed?
      File.exists?(local_path)
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
    def install
      %x(ln -s #{install_path} #{local_path} && open /usr/local/Cellar/emacs/*/Emacs.app)
    end
    def remove
      %x(rm #{local_path})
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
    def install
      if File.exists?(File.expand_path(local_path))
        %x(mv #{local_path} #{local_path}.bak)
      end
      %x(ln -s #{install_path} #{local_path})
    end
    def remove
      %x(rm #{local_path} )
      if File.exists?(File.expand_path(local_path + ".bak"))
          %x(mv #{local_path}.bak #{local_path})
      end
    end
  end
end


class Git < Resource; end
class Zsh < Resource; end

class Emacs < Resource
  def self.install
    %x(brew install emacs --with-cocoa)
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
        puts "Installing #{resource}"
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
        puts "Removing #{resource}"
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
        puts "removing #{resource}"
        resource.remove
      end
    end
    File.delete(manifest_file)
  end
end
# TODO add iterm2
installer = MikeyInstaller.new([Emacs, Git, Zsh, Dotemacs, PlayDir, Dreamacs])
#installer = MikeyInstaller.new([Dotemacs, Dreamacs])

options.keys.each {|x| installer.send(x) }
