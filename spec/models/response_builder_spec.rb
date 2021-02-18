require 'rails_helper'

describe ResponseBuilder, type: :model do
  subject {ResponseBuilder}

  before :all do
    @user = create :user
  end

  before :each do
    @survey = Survey.create(name: 'Test Survey')
  end

  it 'should build valid response for line question' do
    question = @survey.questions.create(text: 'question', answer_type: 'line', required: true)
    params = {
      answers_attributes: {
        0 => {
          question_id: question.id,
          line: 'line answer'
        }
      },
      survey_id: @survey.id,
      user_id: @user.id
    }

    expect(subject.new(SurveyResponse, @survey, params).build).to be_valid

  end

  it 'should build invalid response for line question' do
    question = @survey.questions.create(text: 'question', answer_type: 'line', required: true)
    params = {
      answers_attributes: {
        0 => {
          question_id: question.id,
          line: ''
        }
      },
      survey_id: @survey.id,
      user_id: @user.id
    }

    expect(subject.new(SurveyResponse, @survey, params).build).to_not be_valid
  end

  it 'should build valid response for checkbox question' do
    question = @survey.questions.create(text: 'question', answer_type: 'checkbox', required: true)
    option = question.options.create(name: 'option 1')
    params = {
      answers_attributes: {
        0 => {
          question_id: question.id,
          choices_attributes: {
            0 => {
              option_id: option.id
            }
          }
        }
      },
      survey_id: @survey.id,
      user_id: @user.id
    }

    expect(subject.new(SurveyResponse, @survey, params).build).to be_valid

  end

  it 'should build invalid response for checkbox question' do
    question = @survey.questions.create(text: 'question', answer_type: 'checkbox', required: true)
    option = question.options.create(name: 'option 1')
    params = {
      answers_attributes: {
        0 => {
          question_id: question.id
        }
      },
      survey_id: @survey.id,
      user_id: @user.id
    }

    expect(subject.new(SurveyResponse, @survey, params).build).to_not be_valid

  end
end