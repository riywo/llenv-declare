require "lldeclare"
require "lldeclare/base"

class LLDeclare::Rbenv < LLDeclare::Base

  def initialize(version)
    super(version.gsub(/^ruby-/, ""))
    @rbenv_dir = File.join(ENV["HOME"], ".rbenv")
    @ruby_build_dir = File.join(@rbenv_dir, "plugins/ruby-build")
    @vendorpath = "vendor/bundle"
  end

private

  def install
    unless File.directory?(@rbenv_dir)
      Kernel.system("git clone git://github.com/sstephenson/rbenv.git #{@rbenv_dir}")
    end

    unless File.directory?(@ruby_build_dir)
      Kernel.system("git clone git://github.com/sstephenson/ruby-build.git #{@ruby_build_dir}")
    end

    system("rbenv rehash")

    if backtick("rbenv version") !~ /^#{@version}/
      system("rbenv install #{@version}")
      system("rbenv global #{@version}")
      system("rbenv rehash")
    end

    if backtick("gem list bundler | grep bundler") == ""
      system("gem install bundler")
      system("rbenv rehash")
    end

    system("bundle install --path=#{@vendorpath}")
    system("rbenv rehash")
  end

  def shell(command)
    shell = <<-EOF
      export PATH="#{@rbenv_dir}/bin:$PATH"
      eval "$(rbenv init -)" 2>/dev/null
      #{command}
    EOF
    shell
  end

end
