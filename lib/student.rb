class Student
  attr_accessor :id, :name, :grade

  @@all = []

  def self.new_from_db(row)
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students
    SQL
    students = DB[:conn].execute(sql)
    students.each do |student|
      @@all << Student.new_from_db(student)
    end
    @@all
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = ?
      LIMIT 1
    SQL
    row = DB[:conn].execute(sql, name)[0]
    self.new_from_db(row)
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT COUNT(*) FROM students
      WHERE GRADE = '9'
    SQL
    students_in_9 = []
    rows = DB[:conn].execute(sql)
    rows.each do |student|
      students_in_9 << Student.new_from_db(student)
    end
    students_in_9
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT COUNT(*) FROM students
      WHERE GRADE < 12
    SQL
    students_below_12 = []
    rows = DB[:conn].execute(sql)
    rows.each do |student|
      students_below_12 << Student.new_from_db(student)
    end
    students_below_12
  end

  def self.first_x_students_in_grade_10(x)
    sql = <<-SQL
      SELECT * FROM students
      WHERE GRADE = '10'
      LIMIT ?
    SQL
    first_x_students_in_grade_10 = []
    rows = DB[:conn].execute(sql, x)
    rows.each do |student|
      first_x_students_in_grade_10 << Student.new_from_db(student)
    end
    first_x_students_in_grade_10
  end

  def self.first_student_in_grade_10
    first_x_students_in_grade_10(1).first
  end

  def self.all_students_in_grade_x(grade)
    sql = <<-SQL
      SELECT * FROM students
      WHERE GRADE = ?
    SQL
    all_students_in_grade_x = []
    rows = DB[:conn].execute(sql, grade)
    rows.each do |student|
      all_students_in_grade_x << Student.new_from_db(student)
    end
    all_students_in_grade_x
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
