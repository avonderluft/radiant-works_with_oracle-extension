module WorksWithOracle::ModelExtensions

  def self.included(base)
    base.class_eval do
      default_scope()
      named_scope :default, :order => "name"     
    end
  end
  
end
