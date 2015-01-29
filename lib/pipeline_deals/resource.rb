module PipelineDeals
  class Resource < ActiveResource::Base
    self.site = "https://api.pipelinedeals.com"
    self.prefix = "/api/v3/"
    self.collection_parser = PipelineDeals::Collection

    def self.find(*arguments)
      scope = arguments.slice!(0)
      options = arguments.slice!(0) || {}

      add_keys(options[:params] ||= {})

      super(scope, options)
    end

    # A scope for fetching deleted records
    # Acts like `.where(clauses = {})`
    def self.deleted(clauses = {})
      clauses[:since] = 0 unless clauses.has_key?(:since)
      find(:all, params: clauses, from: deleted_collection_path)
    end

    def save
      PipelineDeals::Resource.add_keys(prefix_options)
      self.include_root_in_json = true
      super
    end

    def self.add_keys(hash)
      hash[:app_key] = PipelineDeals.app_key if PipelineDeals.app_key
      hash[:app_version] = PipelineDeals.app_version if PipelineDeals.app_version
      hash[:api_key] = PipelineDeals.api_key
    end

    private

      def self.deleted_collection_path
        endpoint = "#{collection_name}/deleted"
        "#{prefix}#{endpoint}#{format_extension}"
      end

  end
end
