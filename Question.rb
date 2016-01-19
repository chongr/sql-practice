require_relative 'QuestionsDatabase.rb'

class Question
  def self.find_by_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL
    return nil if result.empty?

    Question.new(result.first)
  end

  def self.find_by_author_id(author_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, author_id)
    SELECT
    *
    FROM
    questions
    WHERE
    assoc_author = ?
    SQL
    return nil if result.empty?

    result.map {|args| Question.new(args)}
  end

  attr_accessor :id, :title, :body, :assoc_author

  def initialize(opt)
    @id, @title, @body, @assoc_author = opt.values_at('id', 'title', 'body', 'assoc_author')
  end

  def author
    User.find_by_id(assoc_author)
  end

  def replies
    Reply.find_by_question_id(id)
  end

  def followers
    Question_Follow.followers_for_question_id(id)
  end

  def most_followed(n)
    Question_Follow.most_followed_questions(n)
  end

end
