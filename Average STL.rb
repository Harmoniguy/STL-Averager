def tau_calc (stl)
  #this method converts STL to tau, a linear value
  tau = 1.0 / (10.0 ** (stl / 10.0))
  return tau
end
def sample_fill (sample)
  #this method fills the sample array
  i = 0 #set iterator to 0
  sample_number = FREQ.size #setting the single sample size to the default number of frequencies used
  sample.each do #iterate through the sample array filling it with desired STL values in dB.
    puts "What is the STL reading for #{FREQ[i]}Hz?"
    x = gets.to_f #sets dummy var to given value
    if i == sample_number #loops until the array is full
    then
      break
    else
      sample[i] = x #sets the array at index i to the given number
    end
    i += 1 #iterates i
  end
end
def sample_calc (full_sample)
  full_sample.map{|stl|tau_calc(stl)}
  #uses the tau calc method on the sample array to give a tau array
end
def total_fill (sample,total)
  #sums each of the taus per frequency
  i = 0 #sets iterator to 0
  sample.each do #for each index adds the newest tau array to the total
    total[i] += sample[i]
    i+=1
  end
  return total
end
def all_samples (sample_size)
  #this method sets up the tau array to go into the total fill method
  tau_filler = Array.new(14, 0) #initializes array tau filler as the dummy array for the total array
  i=0 #sets iterator to 0
  until i == sample_size do #iterate over the number of desired measurements
    full_sample = sample_fill(Array.new(14)) #initializes an array full sample, and fills it using sample fill method
    tau_sample = sample_calc (full_sample) #initiallizes an array tau sample, and fills it using the previously used full sample and run through the sample calc method
    tau_total = total_fill(tau_sample,tau_filler) #initiallizes an array tau total as the sum of all of the tau samples per frequency, fills by sending tau sample array and dummy array, tau filler through total fill method
    i += 1 #increases iterator
  end
  return tau_total
end
def average_calc(total,x)
  #this method averages each of the tau total array values over the number of measurements
  total.map{|i|i = i / x}
end
def stl_average_calc(average)
  #this method takes the average tau array and converts each value back into STL in dB
  average.map{|i| i = 10*Math.log10(1/i)}
end
FREQ = [250, 315, 400, 500, 630, 800, 1000, 1250, 1600, 2000, 2500, 3150, 4000, 5000] #the default frequencies used for the measurement
puts "How many measurements?"
sample_size = gets.to_f #sets sample size to the number of measurements
tau_total = all_samples(sample_size) #fills tau total array using all samples method
average_tau = average_calc(tau_total,sample_size) #runs the average calculation on the average tau array
average_stl = stl_average_calc(average_tau) #converts the average tau array back to STL in dB
puts average_stl #displays the average STL measurements
