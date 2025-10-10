module Prosopo
  module Tags
    def prosopo_script(
      async : Bool = true,
      defer : Bool = true,
      **attrs,
    )
      String.build do |io|
        io << %(<script type="module" src="#{Prosopo.settings.script}")
        io << " async" if async
        io << " defer" if defer
        prosopo_args_to_attrs(io, attrs)
        io << %(></script>)
      end
    end

    def lucky_prosopo_script(**attrs)
      raw prosopo_script(**attrs)
    end

    def prosopo_container(
      class_name : String? = nil,
      **attrs,
    )
      site_key = Prosopo.settings.site_key
      String.build do |io|
        io << %(<div class="procaptcha #{class_name}" data-sitekey="#{site_key}")
        prosopo_args_to_attrs(io, attrs)
        io << %(></div>)
      end
    end

    def lucky_prosopo_container(**attrs)
      raw prosopo_container(**attrs)
    end

    private def prosopo_args_to_attrs(io, attrs)
      attrs.each do |name, value|
        io << ' '
        io << name.to_s.gsub(/_/, '-')
        io << %(=")
        io << value
        io << %(")
      end
    end
  end
end
