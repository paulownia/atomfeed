def f(name)
   File.join(File.dirname(__FILE__), name)
end


def fs(name)
  data = [] 
  File.foreach(f name) { |line|
    data << line.chomp
  }
  data.join
end

