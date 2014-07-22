module PipelineDeals
  class Comment < PipelineDeals::Resource
  	self.prefix = "/api/v3/notes/:note_id/"

    belongs_to :note, class_name: PipelineDeals::Note
  end
end