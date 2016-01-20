require_relative 'QuestionsDatabase.rb'

class Reply < ModelBase
  def self.table_name
    "replies"
  end

  def self.find_by_user_id(user_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        u_id = ?
      SQL
    return nil if result.empty?

    result.map {|args| Reply.new(args)}
  end

  def self.find_by_question_id(question_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        q_id = ?
      SQL
    return nil if result.empty?

    result.map {|args| Reply.new(args)}
  end


  # def self.find_by_id(id)
  #   result = QuestionsDatabase.instance.execute(<<-SQL, id)
  #   SELECT
  #   *
  #   FROM
  #   replies
  #   WHERE
  #   id = ?
  #   SQL
  #   return nil if result.empty?
  #
  #   Reply.new(result.first)
  # end

  attr_accessor :id, :q_id, :parent_id, :u_id, :body

  def initialize(opt)
    @id, @q_id, @parent_id, @u_id, @body = opt.values_at('id', 'q_id', 'parent_id', 'u_id', 'body')
  end

  def author
    User.find_by_id(u_id)
  end

  def question
    Question.find_by_id(q_id)
  end

  def parent_reply
    Reply.find_by_id(parent_id)
  end

  def child_reply
    result = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_id = ?
    SQL

    return nil if result.empty?
    result.map { |args| Reply.new(args) }
  end

  def save
    QuestionsDatabase.instance.execute(<<-SQL, @q_id, @parent_id, @u_id, @body)
      INSERT INTO
        replies ('q_id', 'parent_id', 'u_id', 'body')
      VALUES
        (?, ?, ?, ?)
    SQL

    @id = QuestionsDatabase.instance.last_insert_row_id
  end

end
