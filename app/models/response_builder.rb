class ResponseBuilder
  def initialize(response_model, form_tool, params)
    @response_model = response_model
    @form_tool = form_tool
    @params = params
  end

  def build
    @response = @response_model.new(:user_id => @params[:user_id], form_key => @params[form_key])
    @form_tool.questions.each do |q|
      answer = Answer.new({question_id: q.id}.merge(answer_for(q)))
      @response.answers << answer
      q.options.each do |opt|
        answer.choices << Choice.new({option_id: opt.id}.merge(check_status_for(q, opt)))
      end
    end
    @response
  end

  def form_key
    "#{@form_tool.class.name.underscore}_id".to_sym
  end

  def answer_for(question)
    answer = @params[:answers_attributes].to_h.find{|i, ans| ans[:question_id].to_i == question.id}.last
    return {
      :text   => answer[:text],
      :line   => answer[:line],
      :number => answer[:number]
    }
  end

  def check_status_for(question, option)
    answer = @params[:answers_attributes].to_h.find{|i, ans| ans[:question_id].to_i == question.id.to_i}.last
    if answer[:choices_attributes] && choice = answer[:choices_attributes].find{|i, ch| ch[:option_id].to_i == option.id}.try(:last)
      {
        line: choice[:line],
        checked: true
      }
    else
      {}
    end
  end
end