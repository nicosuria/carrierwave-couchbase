# encoding: utf-8

require 'carrierwave'
require 'couchbase'
require 'couchbase-model'
require 'carrierwave/validations/active_model'

module CarrierWave
  module Couchbase
    include CarrierWave::Mount
    ##
    # See +CarrierWave::Mount#mount_uploader+ for documentation
    #
    def mount_uploader(column, uploader=nil, options={}, &block)
      #field options[:mount_on] || column

      super

      alias_method :read_uploader, :read_attribute
      alias_method :write_uploader, :write_attribute
      public :read_uploader
      public :write_uploader

      include CarrierWave::Validations::ActiveModel

      validates_integrity_of  column if uploader_option(column.to_sym, :validate_integrity)
      validates_processing_of column if uploader_option(column.to_sym, :validate_processing)

      after_save :"store_#{column}!"
      before_save :"write_#{column}_identifier"
      before_update :"store_previous_model_for_#{column}"
      after_save :"remove_previously_stored_#{column}"

      class_eval <<-RUBY, __FILE__, __LINE__+1
        def #{column}=(new_file)
          column = _mounter(:#{column}).serialization_column
          # send(:"\#{column}_will_change!")
          super
        end



        def serializable_hash(options=nil)
          hash = {}
          self.class.uploaders.each do |column, uploader|
            if (!options[:only] && !options[:except]) || (options[:only] && options[:only].include?(column)) || (options[:except] && !options[:except].include?(column))
              hash[column.to_s] = _mounter(:#{column}).uploader.serializable_hash
            end
          end
          super(options).merge(hash)
        end

      RUBY
    end
  end # Couchbase-Model
end # CarrierWave

Couchbase::Model.extend CarrierWave::Couchbase