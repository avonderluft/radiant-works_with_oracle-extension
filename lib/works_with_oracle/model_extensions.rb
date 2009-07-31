module WorksWithOracle::ModelExtensions

  def self.included(base)
    base.class_eval do
      default_scoping.clear
      named_scope :default, :order => "name"     
    end
  end

end
