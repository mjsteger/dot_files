Installer for my personal computer configuration

Configuration is all stored in ```install_dot_files.rb```, a ruby file that describes the different resources that I like to use and how to add/remove them. When installing in "guest" mode(-g), a manifest of the installed changes will be kept, allowing these changes to be removed after using the machine, thus preventing interference with the owners workflow.

To use, simply clone and run ```install_script_mac.sh```, which will run the above ruby file in guest mode, as well as initializing the git submodules and installing/setting up my keyboard layout.

To remove all the installed packages, use ```./install_dot_files.rb -r```, which will only remove things added and registered in the install manifest.

That's about it! There's some basic tests to make sure that things install/uninstall correctly, but there's a lot of ground that could be covered trying between different versions of OSX. Unfortunately, I don't have access to other versions, making it rather difficult to test.
