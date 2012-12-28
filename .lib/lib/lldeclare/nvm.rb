require "lldeclare"
require "lldeclare/base"

class LLDeclare::Nvm < LLDeclare::Base

  def initialize(version)
    super("v" + version.gsub(/^node-/, ""))
    @nvm_dir = File.join(ENV["HOME"], "nvm")
  end

private

  def install
    unless File.directory?(@nvm_dir)
      Kernel.system("git clone git://github.com/creationix/nvm.git #{@nvm_dir}")
    end

    unless File.directory?(File.join(@nvm_dir, @version))
      system("nvm install #{@version}")
    end

    system("npm install")
  end

  def vendorpath
    puts File.expand_path("./node_modules")
  end

  def shell(command)
    shell = <<-EOF
      source "$HOME/nvm/nvm.sh"
      export PATH="./node_modules/.bin:$PATH"
      nvm use #{@version} > /dev/null
      #{command}
    EOF
    shell
  end

end
