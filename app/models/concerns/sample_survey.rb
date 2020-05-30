class SampleSurvey
  def initialize(object, name, description)
    @object = object
    @object.update name: name, description: description
  end

  def prepare
    if @object.is_a?(Survey)
      prepare_survey_questions
    elsif @object.is_a?(Group)
      prepare_signup_questions
    end
  end

  def prepare_survey_questions
    @object.questions << SampleQuestion.new('text', 'How may I help you', nil, nil).question
    @object.questions << SampleQuestion.new('line', 'contact phone no.', nil, nil).question
  end

  def prepare_signup_questions
    @object.questions << SampleQuestion.new('text', 'address', nil, nil).question
    @object.questions << SampleQuestion.new('radio', 'gender', 'male', 'female').question
  end
end