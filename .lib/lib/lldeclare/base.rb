require "lldeclare"

class LLDeclare::Base

  def initialize(version)
    @version = version
  end

  def run(command, arg = nil)
    case command
    when "install", "vendorpath"
      send(command.to_sym)
    when "exec"
      send(command.to_sym, arg)
    else
      raise
    end
  end

private

  def shell(command)
  end

  def install
  end

  def exec(command)
    Kernel.exec(shell(command))
  end

  def vendorpath
    puts @vendorpath
  end

  def system(command)
    Kernel.system(shell(command))
  end

  def backtick(command)
    `#{shell(command)}`
  end

end
