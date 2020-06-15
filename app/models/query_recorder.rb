class QueryRecorder
  def initialize(query)
    @query = query.strip
  end

  def record
    super_query = Query.where("queries.string = '#{@query}'").last
    if super_query.blank?
      Query.create(string: @query, count: @query.split(' ').length) if complete_query
    end
  end

  def complete_query
    ActsAsTaggableOn::Tag.where(name: @query.split(' ').last).first.present?
  end
end