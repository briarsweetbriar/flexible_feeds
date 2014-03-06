module FlexibleFeeds
  class PopularityCalculator
    
    attr_accessor :pos, :n
    def initialize(pos, n)
      @pos = pos
      @n = n
    end

    def get_popularity
      return 0 if n == 0
      dividend / divisor
    end

    private
    def z
      1.96
    end

    def phat
      1.0 * pos / n
    end

    def dividend
      phat + z*z/(2*n) - z * sqrt
    end

    def sqrt
      Math.sqrt((phat*(1-phat)+z*z/(4*n))/n)
    end

    def divisor
      1+z*z/n
    end

  end
end
