class ModelBase

  def self.table_name
  end

  def self.find_by_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        id = ?
    SQL
    return nil if result.empty?

    self.new(result.first)
  end

  def self.all
    result = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
    SQL
    return nil if result.empty?

    result.map { |args| self.new(args) }
  end

  def self.where(opt = {})
    opt.each do |k, v| "#{k} = #{v}".join_by(", ")
      result = QuestionsDatabase.instance.execute(<<-SQL, k, v)
        SELECT
          *
        FROM
          #{self.table_name}
        WHERE
          ? = ?
      SQL
    end

    return nil if result.empty?
    result.map { |args| self.new(args) }
  end


  # def save # TODO disaster
  #   ivars = self.instance_variables[1..-1]
  #   instance_variable_values = ivars.map {|ivar| "'#{self.instance_variable_get(ivar)}'"}.join(", ")
  #   puts instance_variable_values
  #   puts "#{self.class.table_name} (#{ivars.map(&:to_s).map {|ivar| ivar = "'#{ivar[1..-1]}'"}.join(', ')})"
  #   QuestionsDatabase.instance.execute(<<-SQL, ivars)
  #     INSERT INTO
  #       #{self.class.table_name} (#{ivars.map(&:to_s).map {|ivar| ivar = ivar[1..-1]}.join(', ')})
  #     VALUES
  #       (#{instance_variable_values})
  #   SQL
  #
  #   @id = QuestionsDatabase.instance.last_insert_row_id
  # end


  def initialize
  end

end
