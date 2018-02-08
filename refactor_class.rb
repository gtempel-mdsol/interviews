# programming question: given the classes below, what can we do
# do reduce code-bloat?

class Student
  attr_accessor :first_term_participation, :first_term_test, :first_term_attendance
  attr_accessor :second_term_participation, :second_term_test, :second_term_attendance
  attr_accessor :third_term_participation, :third_term_test, :third_term_attendance

  def set_all_grades_to grade
    %w(first second third).each do |which_term|
      %w(participation test attendance).each do |criteria|
        send "#{which_term}_term_#{criteria}=".to_sym, grade
      end
    end
  end

  def first_term_grade
    (first_term_participation + first_term_test + first_term_attendance) / 3
  end

  def second_term_grade
    (second_term_participation + second_term_test + second_term_attendance) / 3
  end

  def third_term_grade
    (third_term_participation + third_term_test + third_term_attendance) / 3
  end
end


# ===========================

class StudentRefactored

  attr_reader :terms

  def initialize
    @terms = [
      Term.new(:first),
      Term.new(:second),
      Term.new(:third)
    ]
  end

  def set_all_grades_to grade
    terms.each { |term| term.set_all_grades_to(grade) }
  end

  def first_term_grade
    term(:first).grade
  end

  def second_term_grade
    term(:second).grade
  end

  def third_term_grade
    term(:third).grade
  end

  def term reference
    terms.find { |term| term.name == reference }
  end
end


class Term

  attr_reader :name, :participation, :test, :attendance

  def initialize name
    @name          = name
    @participation = 0
    @test          = 0
    @attendance    = 0
  end

  def set_all_grades_to grade
    @participation = grade
    @test          = grade
    @attendance    = grade
  end

  def grade
    (participation + test + attendance) / 3
  end
end