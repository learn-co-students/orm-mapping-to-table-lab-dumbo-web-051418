class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  attr_reader :id
  attr_accessor :name, :grade

  def initialize(name, grade)
    @name = name
    @grade = grade
    @id = nil
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      );
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE IF EXISTS students;
    SQL

    DB[:conn].execute(sql)
  end

  def save
    sql_insert = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?);
    SQL
    sql_retrieve = <<-SQL
      SELECT id FROM students ORDER BY id DESC LIMIT 1;
    SQL

    DB[:conn].execute(sql_insert, @name, @grade)
    @id = DB[:conn].execute(sql_retrieve)[0][0]

  end

  def self.create(attributes)
    student = Student.new(nil, nil)
    attributes.each do |key, value|
      student.respond_to?("#{key}") ? student.send("#{key}=", value) : nil
    end
    student.save
    student
  end

end
