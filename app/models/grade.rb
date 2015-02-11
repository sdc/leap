class Grade
  SCHEMES = { pmd: [:refer,
                        :pass,
                        :merit,
                        :distinction],
              letter: [:"a*",
                        :a,
                        :b,
                        :c,
                        :d,
                        :e,
                        :f,
                        :g]
          }

  include Comparable

  attr_accessor :grade, :scheme

  def initialize(grade)
    if grade.kind_of? Integer
      @grade = grade
      @scheme = :number
    elsif grade.kind_of? String
      @grade = grade.downcase.to_sym
      @scheme = SCHEMES.detect { |k, v| v.include? @grade }.try :first
    end
  end

  def <=>(other)
    return nil unless scheme && other.scheme && scheme == other.scheme
    return 0 if grade == other.grade
    return -1 if SCHEMES[scheme].detect { |g| g == grade || g == other.grade } == grade
    return 1
  end

  def to_s
    @grade.to_s.titlecase
  end

  def blank?; @grade.blank? end
  def nil?; @grade.nil? end
end

