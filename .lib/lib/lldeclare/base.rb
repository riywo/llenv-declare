require "lldeclare"

class LLDeclare::Base

  def initialize(version)
    @version = version
  end

  def install
  end

  def exec(command)
    set_env
    Kernel.exec(shell(command))
  end

private

  def set_env
    home = ENV["HOME"]
    ENV.clear
    ENV["HOME"] = home
    ENV["SHELL"] = "/bin/bash"
  end

  def shell(command)
  end

  def system(command)
    set_env
    Kernel.system(shell(command))
  end

  def backtick(command)
    set_env
    `#{shell(command)}`
  end

end
