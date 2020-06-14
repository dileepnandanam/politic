class QueryRecorder
  def initialize(query)
    @query = query.strip
  end

  def record
    super_query = Query.where("queries.string like '%#{@query}%'")
    if !super_query.present?
      Query.create(string: @query)
    else
      super_query.update(count: super_query.count + 1)
    end

  end
end