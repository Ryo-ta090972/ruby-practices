(1..20).each do |x|

    fizz = (x % 3).zero?
    buzz = (x % 5).zero?

    if fizz && buzz
        puts "FizzBuzz"
    elsif fizz
        puts "Fizz"
    elsif buzz
        puts "Buzz"
    else
        puts x
    end    
end
