require "lldeclare"

class LLDeclare::Perlbrew

  def initialize
    @perlbrew_dir = File.join(ENV["HOME"], "perl5/perlbrew")
  end

  def install(version)
    unless File.directory?(@perlbrew_dir)
      system("curl -kL http://install.perlbrew.pl | bash")
    end

    if exec_bt("echo $PERLBREW_PERL") !~ /^#{version}/
      exec("perlbrew install #{version} -n -j 2")
      exec("perlbrew switch #{version}")
    end

    if exec_bt("which cpanm") == ""
      exec("curl -L http://cpanmin.us | perl - App::cpanminus")
    end

    exec("cpanm -l local --installdeps .")
  end

  def exec(command)
    system(exec_shell(command))
  end

private

  def exec_shell(command)
    shell = <<-EOF
      source #{@perlbrew_dir}/etc/bashrc
      export PERL5OPT="-Mlib=./local/lib/perl5"
      export PATH="./local/bin:$PATH"
      #{command}
    EOF
    shell
  end

  def exec_bt(command)
    `#{exec_shell(command)}`
  end

end
