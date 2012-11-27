require "lldeclare"

class LLDeclare::Base

  def initialize(version)
    @version = version
  end

  def install
  end

  def exec(command)
    Kernel.exec(shell(command))
  end

private

  def shell(command)
  end

  def system(command)
    Kernel.system(shell(command))
  end

  def backtick(command)
    `#{shell(command)}`
  end

end
