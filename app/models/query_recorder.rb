class QueryRecorder
  def initialize(query)
    @query = query.strip
  end

  def record
    super_query = Query.where("queries.string like '%#{@query}%'")
    if !super_query.present?
      Query.create(string: @query, count: @query.split(' ').length) if complete_query
    end
  end

  def complete_query
    ActsAsTaggableOn::Tag.where(name: @query.split(' ').last).first.present?
  end
end