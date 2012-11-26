require "lldeclare"

class LLDeclare::Nvm

  def initialize
    @nvm_dir = File.join(ENV["HOME"], "nvm")
  end

  def exec(version, command)
    shell = <<-EOF
      source "$HOME/nvm/nvm.sh"
      export PATH="./node_modules/.bin:$PATH"
      nvm use #{version} > /dev/null
      #{command}
    EOF
    system(shell)
  end

  def exec_bt(version, command)
    shell = <<-EOF
      source "$HOME/nvm/nvm.sh"
      export PATH="./node_modules/.bin:$PATH"
      nvm use #{version} > /dev/null
      #{command}
    EOF
    `#{shell}`
  end

  def install(version)
    unless File.directory?(@nvm_dir)
      system("git clone git://github.com/creationix/nvm.git #{@nvm_dir}")
    end

    unless File.directory?(File.join(@nvm_dir, version))
      exec(version, "nvm install #{version}")
    end

    exec(version, "npm install")

  end

end
