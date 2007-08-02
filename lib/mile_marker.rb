module Thoughtbot
  module MileMarkerHelper
    def mile(detail="")
      return unless MileMarker.enabled?
      "mile=\"" + (detail.is_a?(Fixnum) ? "Milestone " : "") + "#{detail}\""
    end
  
    def initialize_mile_marker(request = nil)
      return unless MileMarker.enabled?
      MileMarker.initialize_mile_marker()
    end
  
    def add_initialize_mile_marker()
      init_code = initialize_mile_marker()
      return if init_code.blank?
      response.body.gsub! /<\/(head)>/i, init_code + '</\1>' if response.body.respond_to?(:gsub!)
    end
  end
    
  class MileMarker  
    # The environments in which to enable the Mile Marker functionality to run.  Defaults
    # to 'development' only.
    @@environments = ['development']
    cattr_accessor :environments

    # Return true if the Mile Marker functionality is enabled for the current environment
    def self.enabled?
      environments.include?(ENV['RAILS_ENV'])
    end
    
    def self.enable
      environments.push ENV['RAILS_ENV']
    end
    
    def self.disable
      environments.delete ENV['RAILS_ENV']
    end
    
    def self.initialize_mile_marker()
      %Q~
<script type="text/javascript">
//<![CDATA[
  function over(element) {
    element.setStyle({opacity: 1.0});
  }
  function init_miles() {
    $$('*[mile]').each(function(block, index) {
      html = '<div id="mile_'+index+'" style="display: none; z-index: 1000; position: absolute; background-color: #000; opacity: 0.4; filter: alpha(opacity=40); color: #eee; font-family: Lucida Sans, Helvetica; font-size: 10px; font-weight: bold; white-space: nowrap; overflow: hidden;"><p style="padding: 3px 5px; background-color: #000; opacity: 1.0; filter: alpha(opacity=100); display: inline; color: #f3f3f3;">'+block.getAttribute('mile')+'</p></div>'
      new Insertion.Before($(block), html);
      Position.clone($(block), $('mile_'+index));
      $('mile_'+index).observe("mouseover", function(event) {
        element = Event.element(event); 
        if(element.immediateDescendants()[0]) 
        {
          element.setStyle({opacity: 0.75});
          if(element.style.filters) element.style.filters.alpha.opacity=75; 
        }
        else
        {
          element.up().setStyle({opacity: 0.75}); 
          if(element.up().style.filters) element.up().style.filters.alpha.opacity=75; 
        }
      });
      $('mile_'+index).observe("mouseout", function(event) {
        element = Event.element(event); 
        if(element.immediateDescendants()[0]) 
        {
          element.setStyle({opacity: 0.4}); 
          if(element.style.filters) element.style.filters.alpha.opacity=40; 
        }
        else
        {
          element.up().setStyle({opacity: 0.4}); 
          if(element.up().style.filters) element.up().style.filters.alpha.opacity=40; 
        }
      });
      $('mile_'+index).toggle();
    });
  }
  Event.observe(window, 'load', init_miles, false);
//]]>
</script>
~
    end 
  end
end