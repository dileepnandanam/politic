class SampleQuestion
  def initialize(question_type, text, o1, o2)
    @question_type = question_type
    @text = text
  end

  def question
    send @question_type
  end

  def line
    @question = Question.create(text: @text, answer_type: 'line')
    @question
  end

  def text
    @question = Question.create(text: @text, answer_type: 'text')
    @question
  end

  def radio
    question = Question.create(text: @text, answer_type: 'radio')
    option_1 = Option.create(name: o1)
    option_2 = Option.create(name: o2)
    @question.options << option_1
    @question.options << option_2
    @question
  end

  def checkbox
    question = Question.create(text: text, answer_type: 'checkbox')
    option_1 = Option.create(name: o1)
    option_2 = Option.create(name: o2)
    question.options << option_1
    question.options << option_2
    question
  end
end