require 'watir-webdriver'
require 'selenium-webdriver'

module Gless
  # A very minor wrapper on the Watir::Browser class to use
  # Gless's config file system. Other than that it just adds logging
  # at this point.  It might do more later.
  class Gless::Browser
    # The underlying Watir::Browser
    attr_reader :browser

    # Takes a Gless::EnvConfig object, which it uses to
    # decide what kind of browser to launch, and launches a browser.
    #
    # @param [Gless::EnvConfig] config A Gless::EnvConfig which has
    #   :global => :browser => :type defined.
    #
    # @return [Gless::Browser]
    def initialize( config )
      @config = config
      type=@config.get :global, :browser, :type
      browser=@config.get :global, :browser, :browser
      port=@config.get :global, :browser, :port
      Logging.log.debug "Launching some browser; #{type}, #{port}, #{browser}"

      if type == 'remote'
        Logging.log.info "Launching remote browser #{browser} on port #{port}"
        capabilities = Selenium::WebDriver::Remote::Capabilities.new( :browser_name => browser, :javascript_enabled=>true, :css_selectors_enabled=>true, :takes_screenshot=>true, :native_events=>true )
        @browser = Watir::Browser.new(:remote, :url => "http://127.0.0.1:#{port}/wd/hub", :desired_capabilities => capabilities)
      else
        Logging.log.info "Launching local browser #{browser}"
        @browser = Watir::Browser.new :browser
      end
    end

    # Pass everything else through to the Watir::Browser
    # underneath.
    def method_missing(m, *args, &block)
      @browser.send(m, *args, &block)
    end
  end
end