require "lldeclare"
require "lldeclare/base"

class LLDeclare::Perlbrew < LLDeclare::Base

  def initialize(version)
    super(version)
    @perlbrew_dir = File.join(ENV["HOME"], "perl5/perlbrew")
    @vendorpath = "local"
  end

private

  def install
    unless File.directory?(@perlbrew_dir)
      Kernel.system("curl -kL http://install.perlbrew.pl | bash")
    end

    if backtick("echo $PERLBREW_PERL") !~ /^#{@version}/
      system("perlbrew install #{@version} -n -j 2")
      system("perlbrew switch #{@version}")
    end

    if backtick("which cpanm") == ""
      system("curl -L http://cpanmin.us | perl - App::cpanminus")
    end

    system("cpanm -l #{@vendorpath} --installdeps .")
  end

  def shell(command)
    shell = <<-EOF
      source #{@perlbrew_dir}/etc/bashrc
      export PERL5OPT="-Mlib=./#{@vendorpath}/lib/perl5"
      export PATH="./#{@vendorpath}/bin:$PATH"
      #{command}
    EOF
    shell
  end

end
