class Nav < Formula
  desc "Enables file system location aliasing and navigation"
  homepage "https://github.com/seifkamal/nav"
  url "https://github.com/seifkamal/nav/archive/v1.1.0.tar.gz"
  sha256 "74fc668ca839bc5c4e42ded4efed615776f6739e4b2411274d6ddbbc43bd2ee4"

  depends_on "bash"

  $nav_script = "nav.sh"
  $nav_script_path = "bin/#{$nav_script}"
  $bash_profile_path = "#{Etc.getpwuid.dir}/.bash_profile"
  $bash_profile_edited = false

  def install
    bin.install $nav_script
  end

  def post_install
    $installation_command = "if [ -f $(brew --prefix)/bin/nav.sh ]; then source $(brew --prefix)/bin/nav.sh; fi"

    begin
      if File.readlines($bash_profile_path).grep(/#{$nav_script_path}/).size === 0
        File.write($bash_profile_path, "# This was added automatically during the Homebrew installation", mode: "a")
        File.write($bash_profile_path, $installation_command, mode: "a")
        $bash_profile_edited = true
      else
        puts "Script already sourced in #{$bash_profile_path}"
      end

    rescue Errno::EPERM, Errno::ENOENT
      puts <<-MSG
Could not find and/or edit your bash profile (used path: #{$bash_profile_path}).
You'll need to manually source the script by adding the following line to your .bash_profile:
#{$installation_command}
      MSG
    end
  end

  def caveats;
    if $bash_profile_edited
      <<-EOS
A couple of lines have been added to #{$bash_profile_path} in order to source the script; They are safe
to leave even if the script does not exist anymore. This means that you'll have to remove them manually
if you decide to uninstall.
      EOS
    end
  end

  test do
    system "nav", "help"
  end
end
