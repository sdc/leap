class Grade

  SCHEMES = {:btec =>  [:refer,
                        :pass,
                        :merit,
                        :distinction],
           :letter =>  [:"a*",
                        :a,
                        :b,
                        :c,
                        :d,
                        :e,
                        :f,
                        :g],
           :percent => [0..100]
          }
  
  include Comparable  

  attr_accessor :grade
  
  def initialize(grade)
    return nil if grade.nil?
    @grade = grade.downcase.to_sym
  end

  def <=>(other)
    return nil unless scheme and other.scheme and scheme == other.scheme
    return 0 if grade == other.grade
    return -1 if SCHEMES[scheme].detect{|g| g == grade or g == other.grade} == grade
    return 1
  end

  def to_s
    grade.to_s.titlecase
  end

  def scheme
    SCHEMES.detect{|k,v| v.include? grade}.try :first
  end

end
