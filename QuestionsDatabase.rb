require 'singleton'
require 'sqlite3'
require_relative 'User'
require_relative 'Question'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.results_as_hash = true
    self.type_translation = true
  end

end

class Question_Like

  def self.query(table, arg)
    <<-SQL
      SELECT
        #{table}.*
      FROM
        questions
      JOIN
        questions_likes
      ON
        questions.id = questions_likes.ql_id
      JOIN
        users
      ON
        questions_likes.ul_id = users.id
      WHERE
        #{arg} = ?
      SQL
  end

  def self.likers_for_question_id(question_id)
    result = QuestionsDatabase.instance.execute(Question_Like.query('users', 'questions.id'), question_id)

    return nil if result.empty?
    result.map {|args| User.new(args)}
  end

  def self.num_likes_for_question_id(question_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        COUNT(*)
      FROM
        questions
      JOIN
        questions_likes
      ON
        questions.id = questions_likes.ql_id
      JOIN
        users
      ON
        questions_likes.ul_id = users.id
      WHERE
        questions.id = ?
      GROUP BY
        questions.id
      SQL

    return nil if result.empty?
    result.first["COUNT(*)"]
  end

  def self.liked_questions_for_user_id(user_id)
    result = QuestionsDatabase.instance.execute(Question_Like.query('questions', 'users.id'), user_id)

    return nil if result.empty?
    result.map { |args| Question.new(args) }
  end

end

class Question_Follow

  def self.query(table, arg)
    <<-SQL
      SELECT
        #{table}.*
      FROM
        questions
      JOIN
        questions_follows
      ON
        questions.id = questions_follows.q_id
      JOIN
        users
      ON
        questions_follows.u_id = users.id
      WHERE
        #{arg} = ?
      SQL
  end

  def self.followers_for_question_id(question_id)
    result = QuestionsDatabase.instance.execute(Question_Follow.query('users', 'questions.id'), question_id)

    return nil if result.empty?
    result.map {|args| User.new(args)}
  end


  def self.followed_questions_for_user_id(user_id)
    result = QuestionsDatabase.instance.execute(Question_Follow.query('questions', 'users.id'), user_id)

    return nil if result.empty?
    result.map {|args| Question.new(args)}
  end

  def self.most_followed_questions(n)
    result = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        questions.*
      FROM
        questions
      JOIN
        questions_follows
      ON
        questions.id = questions_follows.q_id
      JOIN
        users
      ON
        questions_follows.u_id = users.id
      GROUP BY
        questions.id
      ORDER BY
        Count(*) DESC
      LIMIT ?
    SQL

    return nil if result.empty?

    result.map{|args| Question.new(args)}
  end

  # def self.followers_for_question_id(question_id)
  #   result = QuestionsDatabase.instance.execute(<<-SQL, question_id)
  #     SELECT
  #       users.*
  #     FROM
  #       questions
  #     JOIN
  #       questions_follows
  #     ON
  #       questions.id = questions_follows.q_id
  #     JOIN
  #       users
  #     ON
  #       questions_follows.u_id = users.id
  #     WHERE
  #       questions.id = ?
  #     SQL
  #
  #     return nil if result.empty?
  #
  #     result.map {|args| User.new(args)}
  #
  # end

  # def self.followed_questions_for_user_id(user_id)
  #   result = QuestionsDatabase.instance.execute(<<-SQL, user_id)
  #     SELECT
  #       questions.*
  #       --questions.id, questions.title, questions.body, questions.assoc_author
  #     FROM
  #       questions
  #     JOIN
  #       questions_follows
  #     ON
  #       questions.id = questions_follows.q_id
  #     JOIN
  #       users
  #     ON
  #       questions_follows.u_id = users.id
  #     WHERE
  #       users.id = ?
  #     SQL
  #
  #     return nil if result.empty?
  #
  #     result.map {|args| Question.new(args)}
  #
  # end

end
