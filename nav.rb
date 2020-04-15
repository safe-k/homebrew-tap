class Nav < Formula
  desc "Enables file system location aliasing and navigation"
  homepage "https://github.com/safe-k/nav"
  url "https://github.com/safe-k/nav/archive/v1.0.0.tar.gz"
  sha256 "fd3809a75fddd3ba83113d24a620e5c6a2a6a6b776f4d0a89980b0ddab6bf8a7"

  depends_on "bash"

  $nav_script = "nav.sh"
  $nav_script_path = "bin/#{$nav_script}"
  $bash_profile_path = "#{Etc.getpwuid.dir}/.bash_profile"
  $bash_profile_edited = false

  def install
    rm $nav_script_path, force: true
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
