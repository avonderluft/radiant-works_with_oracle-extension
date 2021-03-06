namespace :radiant do
  namespace :extensions do
    namespace :works_with_oracle do
      
      desc "Runs the migration of the Works With Oracle extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          WorksWithOracleExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          WorksWithOracleExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Works With Oracle to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        puts "Copying assets from WorksWithOracleExtension"
        Dir[WorksWithOracleExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(WorksWithOracleExtension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory, :verbose => false
          cp file, RAILS_ROOT + path, :verbose => false
        end
      end  
    end
  end
end
