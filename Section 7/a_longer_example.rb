# The code here is adapted from Programming Languages Part C
# by University of Washington.

# Define and use a small class for rational numbers.
# Invariants:
# 1. Fractions cannot have a denominator that is equal to 0.
# 2. Fractions must always exist in their reduced/simplest form.

class MyRational
  def initialize(num, den=1)
    if den == 0
      raise "SyntaxError - fraction denominator cannot be 0"
    # Invariant: denominator cannot be < 0.
    # If denominator < 0, transfer the minus sign to the numerator
    elsif den < 0
      @num = -num
      @den = -den
    else
      @num = num
      @den = den
    end
    reduce # self.reduce() but it's private so we use the shorthand
  end

  # nil -> string
  # Converts the fraction to a string
  def to_s
    ans = @num.to_s
    if @den != 1
      ans += "/"
      ans += @den.to_s
    end
    ans
  end

  # 1st alternative to to_s
  def to_s2
    dens = ""
    dens += "/" + @den.to_s if @den != 1
    @num.to_s + dens
  end

  # 2nd alternative to_s using expression interpolation
  def to_s3
    "#{num}#{if @den == 1 then "" else "/" + @den.to_s end}"
  end

  # MyRational -> MyRational
  # Add another fraction to the instance's fraction.
  # This method is a non-functional addition;
  # it will mutate the instance's fraction.
  def add! r
    a = r.num
    b = r.den
    c = @num
    d = @den
    @num = (a * d) + (b * c)
    @den = b * d
    reduce
    self # good for stringing calls/chaining methods
  end

  # MyRational -> MyRational
  # Add another fraction to the instance's fraction.
  # This method is a functional addition;
  # it will return a new MyRational instance without
  # modifying the original instance.
  # We can use this function through r1.+ r2.
  # However, Ruby also has built-in syntactic sugar
  # that allows one to use methods called "+" with regular infix notation
  # i.e. r1 + r2
  def + r
    ans = MyRational.new(@num, @den)
    ans.add! r
    ans # technically not necessary as add! already returns self
  end

  protected

  # We will define the getter methods here.
  # No setter methods necessary.
  # Although it would be better for the getters to be private,
  # we can't do that due to the add! method (which calls the
  # getters of other fractions of the same MyRational class
  # in order to define a and b).
  # A variation of the getter methods and access modifier
  # that would be more concise would be as follows:
  # attr_reader :num, :den
  # protected :num, :den
  def num
    @num
  end

  def den
    @den
  end

  private

  def gcd(a,b)
    if a % b == 0
      b
    else
      gcd(b, a % b)
    end
  end

  def reduce
    if @num == 0
      @den == 1
    else
      # gcd's implementation requires @num and @den to be +ve
      factor = gcd(@num.abs, @den)
      @num = @num / factor
      @den = @den / factor
    end
  end
end

# test function
def test_rationals
  # r2 should be
  # 3/4 + 3/4 - 5/3
  # = 9/12 + 9/12 - 20/12
  # = 1/6
  r1 = MyRational.new(3,4)
  r2 = r1 + r1 + MyRational.new(-5,3)
  puts "r2 is #{r2.to_s}"

  # testing if add! successfully mutates a function
  # r2 should mutate to
  # = -1/6 + 3/4 -4/9
  # = -6/36 + 27/36 - 16/36
  # = 5/36
  (r2.add! r1).add! (MyRational.new(4,-9))
  # (MyRational.new(-1,6).add! MyRational.new(3,4)).add! MyRational.new(4,-9)
  puts "r2 is mutated to #{r2.to_s} (using to_s)"
  puts "r2 is mutated to #{r2.to_s2} (using to_s2)"
  puts "r2 is mutated to #{r2.to_s3} (using to_s3)"
end

test_rationals
