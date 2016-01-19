require_relative 'QuestionsDatabase.rb'

class User

  def self.find_by_name(first, last)
    result = QuestionsDatabase.instance.execute(<<-SQL, first, last)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND lname = ?
      SQL
    return nil if result.empty?

    result.map {|args| User.new(args)}

  end

  def self.find_by_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
    *
    FROM
    users
    WHERE
    id = ?
    SQL
    return nil if result.empty?

    User.new(result.first)
  end

  attr_accessor :id, :fname, :lname

  def initialize(opt)
    @id, @fname, @lname = opt.values_at('id', 'fname', 'lname')
  end

  def authored_questions
    Question.find_by_author_id(id)
  end

  def authored_replies
    Reply.find_by_user_id(id)
  end

  def followed_questions
    Question_Follow.followed_questions_for_user_id(id)
  end

end
