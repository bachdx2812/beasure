# Beasure , a simple gem to measure your ruby code

### Usage

First, require the gem
~~~~
require 'beasure'
~~~~
Second, you just have to wrap your ruby code
inside and let the gem does it's job

~~~~
Beasure.perform do
  require 'benchmark'
    
  num_rows = 100000
  num_cols = 10
    
  data = Array.new(num_rows) {Array.new(num_cols) {"x" * 1000}}
    
  time = Benchmark.realtime do
    csv = data.map {|row| row.join(',')}.join('\n')
  end
end
~~~~

Output:

~~~~
{"2.4.1":{"gc":"enabled","time":3.25,"gc_count":72,"memory":"2973 MB"}}
=> nil
~~~~