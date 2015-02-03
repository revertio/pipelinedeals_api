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
    # Take a required param `since` where the value is a date or timestamp "YYYY-MM-DD hh:mm:ss". Default: 0
    def self.deleted(clauses = {})
      add_keys(clauses)
      clauses[:since] = 0 unless clauses.has_key?(:since)

      # The API only returns IDs. We have to wrap them ourselves.
      response = get(:deleted, clauses)
      response["entries"].collect do |entry_id|
        instantiate_record(id: entry_id)
      end
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

  end
end
