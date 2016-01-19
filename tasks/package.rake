desc "Package all"
task :package => ['package:clean',
                  'package:deb',
                  'package:rpm']

namespace :package do
  desc "Clean up package files"
  task :clean do
    sh "rm -rf #{BINARY_DIR}/*deb"
    sh "rm -rf #{BINARY_DIR}/*rpm"
  end

  desc "Create a DEB package"
  task :deb do
    create_deb('pkg', 'i386', 'linux-x86')
    create_deb('pkg', 'amd64', 'linux-x86_64')
  end

  desc "Create a RPM package"
  task :rpm do
    create_rpm('pkg', 'i386', 'linux-x86')
    create_rpm('pkg', 'x86_64', 'linux-x86_64')
  end
end

def create_deb(binary_dir, architecture, package_architecture)
  package_dir = package_dir_of(package_architecture)
  sh "fpm " + "-s tar " +
              "-t deb " +
              "--deb-no-default-config-files " +
              "--architecture #{architecture} " +
              "--name #{Photish::NAME} " +
              "--vendor \"Foinq\" " +
              "--maintainer \"#{Photish::CONTACT}>\" " +
              "--version #{Photish::VERSION} " +
              "--description \"#{Photish::DESCRIPTION}\" " +
              "--license \"#{Photish::LICENSE}\" " +
              "--prefix \"/usr/local/lib\" " +
              "--after-install #{update_after_install_script(package_dir)} " +
              "--package 'pkg' " +
              "--force " +
              "#{binary_dir}/#{package_dir}.tar.gz"
end

def create_rpm(binary_dir, architecture, package_architecture)
  package_dir = package_dir_of(package_architecture)
  sh "fpm " + "-s tar " +
              "-t rpm " +
              "--rpm-os linux " +
              "--architecture #{architecture} " +
              "--name #{Photish::NAME} " +
              "--vendor \"Foinq\" " +
              "--maintainer \"#{Photish::CONTACT}>\" " +
              "--version #{Photish::VERSION} " +
              "--description \"#{Photish::DESCRIPTION}\" " +
              "--license \"#{Photish::LICENSE}\" " +
              "--prefix \"/usr/local/lib\" " +
              "--epoch \"#{Time.now.to_i}\" " +
              "--after-install #{update_after_install_script(package_dir)} " +
              "--package 'pkg' " +
              "--force " +
              "#{binary_dir}/#{package_dir}.tar.gz"
end
