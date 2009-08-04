# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'

class WorksWithOracleExtension < Radiant::Extension
  version "0.8.0"
  description "Various patches and hacks to facilitate better compatibility with Oracle"
  url "http://github.com/avonderluft/radiant-works_with_oracle-extension/tree"
  
  unless Radiant::Version.to_s < '0.8.0'
    extension_config do |config| 
      config.gem 'activerecord-oracle_enhanced-adapter', :lib => false
    end
  end
  
  def activate
    if ActiveRecord::Base.configurations[RAILS_ENV]['adapter'] == 'oracle_enhanced'
      # See http://blog.rayapps.com/2008/05/13/activerecord-oracle-enhanced-adapter/
      # and http://wiki.github.com/rsim/oracle-enhanced/usage
      # and http://rsim.lighthouseapp.com/projects/11468-oracle-enhanced/tickets
      ActiveRecord::ConnectionAdapters::OracleEnhancedAdapter.class_eval do
        self.default_sequence_start_value = 1
        #self.emulate_integers_by_column_name = true
        #self.emulate_booleans_from_strings = true
      end   

      # In 0.8 with Rails 2.3, sessions are now Rack based, which means CGI:Session is no longer valid.
      if Radiant::Version.to_s < '0.8.0'
        CGI::Session::ActiveRecordStore::Session.partial_updates = false
      else # Radiant 0.8 or higher
      # Radiant 0.8.0 with Rails 2.3.2 uses ActiveRecord default_scope,
      # which Oracle at present cannot handle, since it does not support 'order by' on UPDATE
      # See http://www.aeonscope.net/2009/06/09/default-scopes-with-oracle/
      # These are the radiant models which use default_scope:
        [User, Snippet, Layout, PagePart].each do |klass|
          klass.send :include, WorksWithOracle::ModelExtensions
        end
      end
    end
  end
  
  def deactivate
    # nothing needed
  end
  
end
