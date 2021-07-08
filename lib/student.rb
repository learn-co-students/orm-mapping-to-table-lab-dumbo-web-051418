class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name,grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end

#do we call this on an obj or class?
  def self.create_table    #creates the table with the instance attributes
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students(
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
      )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table  #drops table if exists
    sql = "DROP TABLE IF EXISTS students";
    DB[:conn].execute(sql)
  end

  def save    #saves new student attributes to the students table
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")#Still don't know what this does
  end

  def self.create(name:, grade:)  #instantiates a new student and saves them to the sql database
    student = Student.new(name,grade)
    student.save
    student
  end
end
