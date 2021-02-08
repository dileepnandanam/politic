class ResponseBuilder
  def initialize(survey, params)
    @survey = survey
    @params = params
  end

  def build
    @response = SurveyResponse.new
    @survey.questions.each do |q|
      answer = Answer.new({question_id: q.id}.merge(answer_for(q)))
      @response.answers << answer
      q.options.each do |opt|
        answer.choices << Choice.new({option_id: opt.id}.merge(check_status_for(q, opt)))
      end
    end
    @response
  end

  def answer_for(question)
    answer = @params[:answers_attributes].to_h.find{|i, ans| ans[:question_id] == question.id.to_s}.last
    return {
      :text   => answer[:text],
      :line   => answer[:line],
      :number => answer[:number]
    }
  end

  def check_status_for(question, option)
    answer = @params[:answers_attributes].to_h.find{|i, ans| ans[:question_id] == question.id.to_s}.last
    if answer[:choices_attributes] && choice = answer[:choices_attributes].find{|i, ch| ch[:option_id] == option.id.to_s}.try(:last)
      {
        line: choice[:line],
        checked: true
      }
    else
      {}
    end
  end
end