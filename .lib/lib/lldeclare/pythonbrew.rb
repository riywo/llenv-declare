require "lldeclare"

class LLDeclare::Pythonbrew

  def initialize
    @pythonbrew_dir = File.join(ENV["HOME"], ".pythonbrew")
    @virtualenvwrapper = File.join(@pythonbrew_dir, "pythons/Python-2.7.3/bin/virtualenvwrapper.sh")
    @virtualenvdir = File.join(ENV["HOME"], ".virtualenvs/env")
  end

  def exec(command)
    shell = <<-EOF
      source "#{@pythonbrew_dir}/etc/bashrc"
      if [ -f "#{@virtualenvwrapper}" ]; then source "#{@virtualenvwrapper}"; fi
      workon env
      #{command}
    EOF
    system(shell)
  end

  def exec_bt(command)
    shell = <<-EOF
      source "#{@pythonbrew_dir}/etc/bashrc"
      if [ -f "#{@virtualenvwrapper}" ]; then source "#{@virtualenvwrapper}"; fi
      workon env
      #{command}
    EOF
    `#{shell}`
  end

  def install(version)
    unless File.directory?(@pythonbrew_dir)
      system("curl -kL http://xrl.us/pythonbrewinstall | bash")
    end

    if exec_bt("echo $PYTHONPATH") !~ /^Python-#{version}/
      exec("pythonbrew install #{version}")
      exec("pythonbrew switch #{version}")
    end

    unless File.exist?(@virtualenvwrapper)
      exec("pip install virtualenv virtualenvwrapper")
    end

    unless File.directory?(@virtualenvdir)
      exec("mkvirtualenv env")
    end

    exec("pip install -r requirements.txt")

  end

end
