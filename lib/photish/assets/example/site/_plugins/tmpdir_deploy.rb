class Photish::Plugin::TmpdirDeploy

  def initialize(config, log)
    @config = config
    @log = log
  end

  def deploy_site
    tmpdir = Dir.mktmpdir
    FileUtils.cp_r(config.output_dir, tmpdir)

    log.info "Static site deployed to directory: #{tmpdir}"
    log.info "Deployment to tmpdir successful"
  end

  private

  attr_reader :config,
              :log

  def self.is_for?(type)
    [
      Photish::Plugin::Type::Deploy
    ].include?(type)
  end

  def self.engine_name
    'tmpdir'
  end
end
