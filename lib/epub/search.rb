require 'epub/search/version'
require 'shellwords'
require 'epub/parser'
require 'groonga'
require 'listen'
require 'highline'

module EPUB
  module Search
    DEFAULT_CONFIG = {
      :config_path => File.join(Dir.home, '.epub-search/config.yaml'),
      :db_dir      => File.join(Dir.home, '.epub-search/db')
    }

    class << self
      def config(config_file=nil)
        return @config if @config
        config_file = config_file ||
          (File.file?('.epub-searchrc') ? '.epub-searchrc' : DEFAULT_CONFIG[:config_path])
        conf = YAML.load_file(config_file) if File.file? config_file
        @config = DEFAULT_CONFIG.merge(conf || {})
      end
    end
  end
end

require 'epub/search/database'
require 'epub/search/formatter'
require 'epub/search/server'
