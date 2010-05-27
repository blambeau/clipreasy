require 'rubygems'
require 'sequel'
require 'yargi'
require 'rubyrel'

require 'clipreasy/ext'
require 'clipreasy/errors'
require 'clipreasy/lang'
require 'clipreasy/hmsc'
require 'clipreasy/enactment'
require 'clipreasy/persistence'
require 'clipreasy/engine'
require 'clipreasy/commands'

#
# Main module of Clinical Process Made Easy
#
module CliPrEasy
  
  # Current version
  VERSION = "0.1.0".freeze
  
  # Default plugins to install on all process instances
  DEFAULT_PLUGINS = [::CliPrEasy::Enactment]
  
  # Installs the default plugins on a process instance
  def install_default_plugins
    DEFAULT_PLUGINS.each do |plugin|
      [:Node, :Activity, :Decision, :Parallel, :Sequence, :Until, 
       :When, :While, :Process, :Forall].each do |modname|
         target = ::CliPrEasy::Lang.const_get(modname)
         source = plugin.const_get(modname)
         target.instance_eval { include(source) }
       end
    end
  end
  module_function :install_default_plugins

end
CliPrEasy.install_default_plugins