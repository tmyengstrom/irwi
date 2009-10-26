module Irwi::Extensions::Models::WikiPage
  
  module ClassMethods
    
    def find_by_path_or_new( path )
      self.find_by_path( path ) || self.new( :path => path, :title => path )
    end
    
  end
  
  module InstanceMethods
    
    # Retrieve number of last version
    def last_version_number
      last = versions.last
      last ? last.number : 0
    end
    
    protected
        
    def create_new_version
      n = last_version_number
      
      v = versions.build
      v.attributes = attributes.slice( *v.attribute_names )
      v.number = n + 1
      v.save!
    end
    
  end
  
  def self.included( base )
    base.send :extend, Irwi::Extensions::Models::WikiPage::ClassMethods
    base.send :include, Irwi::Extensions::Models::WikiPage::InstanceMethods
    
    base.send :attr_accessor, :comment, :previous_version_number
    
    base.belongs_to :creator, :class_name => Irwi.config.user_class_name
    base.belongs_to :updator, :class_name => Irwi.config.user_class_name
    
    base.has_many :versions, :class_name => Irwi.config.page_version_class_name, :foreign_key => Irwi.config.page_version_foreign_key, :order => 'id ASC'
    
    base.after_save :create_new_version
  end
  
end