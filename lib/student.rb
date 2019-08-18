class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    stu = self.new
    stu.id = row[0]
    stu.name = row[1]
    stu.grade = row[2]
    stu
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = "SELECT * FROM students"
    ar = []
    DB[:conn].execute(sql).each do |s|
      ar << self.new_from_db(s)
    end
    ar
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students where name = ?
    SQL
    row = DB[:conn].execute(sql, name)[0]
    self.new_from_db(row)
  end

  def self.all_students_in_grade_9
    sql = "SELECT * FROM students WHERE grade = 9"
    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = "SELECT * FROM students WHERE grade < 12"
    ar = []
    DB[:conn].execute(sql).each do |s|
      ar << self.new_from_db(s)
    end
    ar
  end

  def self.first_X_students_in_grade_10(x)
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT ?"
    ar = []
    DB[:conn].execute(sql, x).each do |s|
      ar << self.new_from_db(s)
    end
    ar
  end

  def self.first_student_in_grade_10()
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT  1"
    self.new_from_db(DB[:conn].execute(sql)[0])
  end

  def self.all_students_in_grade_X(x)
    sql = "SELECT * FROM students WHERE grade = ?"
    ar = []
    DB[:conn].execute(sql, x).each do |s|
      ar << self.new_from_db(s)
    end
    ar
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
