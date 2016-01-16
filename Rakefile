Dir.glob('tasks/*.rake').each { |r| import r }

desc 'Clean output folders'
task :clean do
  FileUtils.rm_rf('coverage')
end

task :default => [:clean,
                  :spec,
                  :features,
                  :gather_coverage]
