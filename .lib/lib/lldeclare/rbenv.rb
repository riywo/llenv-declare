require "lldeclare"

class LLDeclare::Rbenv

  def initialize
    @rbenv_dir = File.join(ENV["HOME"], ".rbenv")
    @ruby_build_dir = File.join(@rbenv_dir, "plugins/ruby-build")
  end

  def exec(command)
    shell = <<-EOF
      export PATH="$HOME/.rbenv/bin:$PATH"
      eval "$(rbenv init -)"
      #{command}
    EOF
    system(shell)
  end

  def exec_bt(command)
    shell = <<-EOF
      export PATH="$HOME/.rbenv/bin:$PATH"
      eval "$(rbenv init -)"
      #{command}
    EOF
    `#{shell}`
  end

  def install(version)
    unless File.directory?(@rbenv_dir)
      system("git clone git://github.com/sstephenson/rbenv.git #{@rbenv_dir}")
    end

    unless File.directory?(@ruby_build_dir)
      system("git clone git://github.com/sstephenson/ruby-build.git #{@ruby_build_dir}")
    end

    exec("rbenv rehash")

    if exec_bt("rbenv version") !~ /^#{version}/
      exec("rbenv install #{version}")
      exec("rbenv global #{version}")
      exec("rbenv rehash")
    end

    if exec_bt("gem list bundler | grep bundler") == ""
      exec("gem install bundler")
      exec("rbenv rehash")
    end

    exec("bundle install --path=vendor/bundle")
    exec("rbenv rehash")

  end

end
