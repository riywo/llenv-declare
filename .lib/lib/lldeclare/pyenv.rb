require "lldeclare"

class LLDeclare::Pyenv

  def initialize
    @pyenv_dir = File.join(ENV["HOME"], ".pyenv")
    @venv_dir = "./venv"
  end

  def exec(command)
    shell = <<-EOF
      export PATH="#{@pyenv_dir}/bin:$PATH"
      eval "$(pyenv init -)" 2>/dev/null
      if [ -f "#{@venv_dir}/bin/activate" ]; then source "#{@venv_dir}/bin/activate"; fi
      #{command}
    EOF
    system(shell)
  end

  def exec_bt(command)
    shell = <<-EOF
      export PATH="#{@pyenv_dir}/bin:$PATH"
      eval "$(pyenv init -)" 2>/dev/null
      if [ -f "#{@venv_dir}/bin/activate" ]; then source "#{@venv_dir}/bin/activate"; fi
      #{command}
    EOF
    `#{shell}`
  end

  def install(version)
    unless File.directory?(@pyenv_dir)
      system("git clone git://github.com/yyuu/pyenv.git #{@pyenv_dir}")
    end

    exec("pyenv rehash")

    if exec_bt("pyenv version") !~ /^#{version}/
      exec("pyenv install #{version}")
      exec("pyenv global #{version}")
      exec("pyenv rehash")
    end

    if exec_bt("pyenv which virtualenv") == ""
      exec("pip install virtualenv")
      exec("pyenv rehash")
    end

    unless File.directory?(@venv_dir)
      exec("virtualenv --distribute #{@venv_dir}")
    end

    exec("pip install -r requirements.txt")
    exec("pyenv rehash")

  end

end
