require 'rails_helper'

RSpec.describe Answer, type: :model do
  subject {
    described_class.new
  }

  it "should be valid with line answer type" do
    question = Question.create(text: 'Question 1', answer_type: 'line')
    subject.question = question
    subject.line = 'Line answer'
    expect(subject).to be_valid
  end

  it "should be valid with number answer type" do
    question = Question.create(text: 'Question 1', answer_type: 'number')
    subject.question = question
    subject.number = 1
    expect(subject).to be_valid
  end

  it "should be valid with text answer type" do
    question = Question.create(text: 'Question 1', answer_type: 'text')
    subject.question = question
    subject.text = 'long text'
    expect(subject).to be_valid
  end

  it "should be valid with checkbox answer type" do
    question = Question.create(text: 'Question 1', answer_type: 'checkbox')
    question.options.create name: 'Option 1'
    subject.question = question
    subject.choices << Choice.new(option_id: question.options.first.id, checked: true)
    expect(subject).to be_valid
  end

  it "should be valid with radio answer type" do
    question = Question.create(text: 'Question 1', answer_type: 'radio')
    question.options.create name: 'Option 1'
    subject.question = question
    subject.choices << Choice.new(option_id: question.options.first.id, checked: true)
    expect(subject).to be_valid
  end

  it "should be valid with multiline answer type" do
    question = Question.create(text: 'Question 1', answer_type: 'multiline')
    question.options.create name: 'sub question 1'
    subject.question = question
    subject.choices << Choice.new(option_id: question.options.first.id, line: 'Sub answer')
    expect(subject).to be_valid
  end
end
