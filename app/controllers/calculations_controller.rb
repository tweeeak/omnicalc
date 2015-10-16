class CalculationsController < ApplicationController

    def word_count
        @text = params[:user_text]
        @special_word = params[:user_word]

        # ================================================================================
        # Your code goes below.
        # The text the user input is in the string @text.
        # The special word the user input is in the string @special_word.
        # ================================================================================

        # I don't know how but i messed all the alignment... tried to fix it....

        @character_count_with_spaces = @text.length.to_s

        @character_count_without_spaces = @text.tr(' ','').length.to_s


        #Count number of spaces
        #space_count = @text.count(' ') - @text.index(/[^ ]/) - @text.reverse.index(/[^ ]/)+ 1
        #Eliminate spaces in begining or end.
        #have to make it so all double spaces become one... TODO
        #s.index(/[^ ]/)              # Number of spaces at the beginning of s
        #s.reverse.index(/[^ ]/)      # Number of spaces at the end of s
        #@word_count = space_count.to_s
        # So much effort... all i had to do was stack overflow :(
            @word_count = @text.split.size

        #

        word_count_hash = Hash.new 0
        @text.split(/\W+/).each{|word| word_count_hash[word.downcase] += 1 }
        @occurrences = word_count_hash[@special_word]


        # ================================================================================
        # Your code goes above.
        # ================================================================================

        render("word_count.html.erb")
    end

    def loan_payment
        @apr = params[:annual_percentage_rate].to_f
        @years = params[:number_of_years].to_i
        @principal = params[:principal_value].to_f

        # ================================================================================
        # Your code goes below.
        # The annual percentage rate the user input is in the decimal @apr.
        # The number of years the user input is in the integer @years.
        # The principal value the user input is in the decimal @principal.
        # ================================================================================


        #P = (Pv*R) / [1 - (1 + R)^(-n)]
        #Pv  = Present Value (beginning value or amount of loan)
        #APR = Annual Percentage Rate (one year time period)
        #R   = Periodic Interest Rate = APR/ # of interest periods per year
        #P   = Monthly Payment
        #n   = # of interest periods for overall time period (i.e., interest
        #periods per year * number of years)
        #rate = @apr/ 12
        #n = 12*@years
        #@monthly_payment = @principal*rate/(1-(1+rate#)**(-n))

        #was using wrong formula.
        # using this now:http://www.1728.org/loanform.htm
        rate = @apr/1200
        @monthly_payment = (rate+(rate/((1+rate)**(12*@years)-1)))*@principal

        # ================================================================================
        # Your code goes above.
        # ================================================================================

        render("loan_payment.html.erb")
    end

    def time_between
        @starting = Chronic.parse(params[:starting_time])
        @ending = Chronic.parse(params[:ending_time])

        # ================================================================================
        # Your code goes below.
        # The start time is in the Time @starting.
        # The end time is in the Time @ending.
        # Note: Ruby stores Times in terms of seconds since Jan 1, 1970.
        #   So if you subtract one time from another, you will get an integer
        #   number of seconds as a result.
        # ================================================================================

        @seconds = @ending - @starting
        @minutes = @seconds / 60
        @hours = @minutes / 60
        @days = @hours / 24
        @weeks = @days / 7
        @years = @weeks / 52

        # ================================================================================
        # Your code goes above.
        # ================================================================================

        render("time_between.html.erb")
    end

    def descriptive_statistics
        @numbers = params[:list_of_numbers].gsub(',', '').split.map(&:to_f)

        # ================================================================================
        # Your code goes below.
        # The numbers the user input are in the array @numbers.
        # ================================================================================

        @sorted_numbers = @numbers.sort

        @count = @numbers.length

        @minimum = @numbers.min

        @maximum = @numbers.max

        @range = @maximum - @minimum

        #straight from Stack overflow
        def median(array)
          sorted = array.sort
          len = sorted.length
          return (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
      end

      @median = median(@numbers)

      @sum = @numbers.sum

      @mean = @sum/@count
      def mean(array)
        array.inject(0) { |sum, x| sum += x } / array.size.to_f
    end
    def variance(array)
        m = mean(array)
        variance = array.inject(0) { |variance, x| variance += (x - m) ** 2 }
        return variance/10
    end
    def standard_deviation(array)
        m = mean(array)
        variance = variance(array)*10
        return Math.sqrt(variance/(array.size-1))
    end

    @variance = variance(@numbers)

    @standard_deviation = standard_deviation(@numbers)

    def mode(array)
        counter = Hash.new(0)

        array.each do |i|
            counter[i] += 1
        end

        mode_array = []

            counter.each do |k, v| # iterate over each value of the hash
                if v == counter.values.max # Check if the value is equal to the max key value
                     mode_array << k # Push the key of the values that match the highest value into mode_array.
                 end
             end

             return mode_array
         end

         @mode = mode(@numbers)

        # ================================================================================
        # Your code goes above.
        # ================================================================================

        render("descriptive_statistics.html.erb")
    end

end
