##This code was written to take a set of STL (sound transmission loss) values and put them in individually
#the code then converts them to a linear value (tau) so that it can average them, then converts them back
#to dB as an average.
def tau_calc (stl)
  #this method converts STL, a logarithmic value to tau, a linear value
  1.0 / (10.0 ** (stl / 10.0))
end
def sample_fill
  #this method fills the sample array
  #creates an array to iterate through frequencies and grab desired numbers, then ungroups the frequencies and desired numbers to return a single dimension array
  sample = Array.new(14,1)
  frequencies = [250, 315, 400, 500, 630, 800, 1000, 1250, 1600, 2000, 2500, 3150, 4000, 5000]
  sample.zip(frequencies).map do |pair|
    sample, frequencies = pair
    prompt("What is the STL reading for #{frequencies}Hz?")*sample
  end
end
def sample_calc (full_sample)
  #runs the tau calc method over an array to convert an array to a tau array
  full_sample.map{|i|tau_calc(i)}
end
def total_fill (sample,total)
  total.zip(sample).map{|i|i.reduce(:+)}
  #sums each of the taus per frequency
#  i = 0
#  sample.each do #for each index adds the newest tau array to the total
#    total[i] += sample[i]
#    i+=1
#  end
#  return total
end
def all_samples (sample_size)
  #this method sets up the tau array to go into the total fill method
  tau_filler = Array.new(14,0)
  i=0
  until i == sample_size do #iterate over the number of desired measurements
    full_sample = sample_fill
    tau_sample = sample_calc(full_sample)
    tau_total = total_fill(tau_sample,tau_filler)
    i += 1
  end
  return tau_total
end
def average_calc(total,x)
  #this method averages each of the tau total array values over the number of measurements
  total.map{|i| i / x}
end
def stl_average_calc(average)
  #this method takes the average tau array and converts each value back into dB for STL
  average.map{|i| 10*Math.log10(1/i)}
end
def prompt (statement)
  #This method is a helper method to return a value when prompted
  puts "#{statement}"
  gets.to_f
end
sample_size = prompt('How many measurements?')
tau_total = all_samples(sample_size) #fills tau total array using all samples method
average_tau = average_calc(tau_total,sample_size) #runs the average calculation on the average tau array
average_stl = stl_average_calc(average_tau) #converts the average tau array back to STL in dB
puts average_stl
