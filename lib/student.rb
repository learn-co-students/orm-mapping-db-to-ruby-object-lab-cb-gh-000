class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new.tap do |student|
      student.id, student.name, student.grade = row[0], row[1], row[2]
    end
  end

  def self.all
    rs = DB[:conn].execute("SELECT * FROM students")
    rs.map { |row| new_from_db(row) }
  end

  def self.all_students_in_grade_x(grade)
    sql = "SELECT * FROM students WHERE grade = ?"
    DB[:conn].execute(sql, grade).map { |row| new_from_db(row) }
  end

  def self.count_all_students_in_grade_9
    DB[:conn].execute("SELECT * FROM students WHERE grade = 9").map { |row| new_from_db(row) }
  end

  def self.first_x_students_in_grade_10(x)
    sql = "SELECT * FROM students WHERE grade = 10 ORDER BY name LIMIT ?"
    DB[:conn].execute(sql, x).map { |row| new_from_db(row) }
  end

  def self.first_student_in_grade_10
    row = DB[:conn].execute("SELECT * FROM students WHERE grade = 10 ORDER BY id LIMIT 1")[0]
    self.new_from_db(row)
  end

  def self.find_by_name(name)
    rs = DB[:conn].execute("SELECT * FROM students WHERE name = ?", name)
    new_from_db(rs[0])
  end

  def self.students_below_12th_grade
    DB[:conn].execute("SELECT * FROM students WHERE grade < 12").map { |row| new_from_db(row) }
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
