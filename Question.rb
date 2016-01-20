require_relative 'QuestionsDatabase.rb'
require_relative 'ModelBase'

class Question < ModelBase
  def self.table_name
    "questions"
  end

  # def self.find_by_id(id)
  #   result = QuestionsDatabase.instance.execute(<<-SQL, id)
  #     SELECT
  #       *
  #     FROM
  #       questions
  #     WHERE
  #       id = ?
  #   SQL
  #   return nil if result.empty?
  #
  #   self.new(result.first)
  # end

  def self.most_liked(n)
    Question_Like.most_liked_questions(n)
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

  def likers
    Question_Like.likers_for_question_id(id)
  end

  def num_likes
    Question_Like.num_likes_for_question_id(id)
  end

  def save
    QuestionsDatabase.instance.execute(<<-SQL, @title, @body, @assoc_author)
      INSERT INTO
        questions ('title', 'body', 'assoc_author')
      VALUES
        (?, ?, ?)
    SQL

    @id = QuestionsDatabase.instance.last_insert_row_id
  end

end
