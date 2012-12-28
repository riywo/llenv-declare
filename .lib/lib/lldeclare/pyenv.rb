require "lldeclare"
require "lldeclare/base"

class LLDeclare::Pyenv < LLDeclare::Base

  def initialize(version)
    super(version.gsub(/^python-/, ""))
    @pyenv_dir = File.join(ENV["HOME"], ".pyenv")
    @vendorpath = "venv"
  end

private

  def install
    unless File.directory?(@pyenv_dir)
      Kernel.system("git clone git://github.com/yyuu/pyenv.git #{@pyenv_dir}")
    end

    system("pyenv rehash")

    if backtick("pyenv version") !~ /^#{@version}/
      system("pyenv install #{@version}")
      system("pyenv global #{@version}")
      system("pyenv rehash")
    end

    if backtick("pyenv which virtualenv") == ""
      system("pip install virtualenv")
      system("pyenv rehash")
    end

    unless File.directory?(@venv_dir)
      system("virtualenv --distribute ./#{@vendorpath}")
    end

    system("pip install -r requirements.txt")
    system("pyenv rehash")
  end

  def shell(command)
    shell = <<-EOF
      export PATH="#{@pyenv_dir}/bin:$PATH"
      eval "$(pyenv init -)" 2>/dev/null
      if [ -f "#{@vendorpath}/bin/activate" ]; then source "#{@vendorpath}/bin/activate"; fi
      #{command}
    EOF
    shell
  end

end
