class Beasure
  require "json"
  require "benchmark"

  def self.perform(&block)
    no_gc = (ARGV[0] == "--no-gc")
    if no_gc
      GC.disable
    else
      # collect memory allocated during library loading
      # and our own code before the measurement
      GC.start
    end
    memory_before = `ps -o rss= -p #{Process.pid}`.to_i / 1024
    gc_stat_before = GC.stat
    time = Benchmark.realtime do
      yield
    end
    GC.start(full_mark: true, immediate_sweep: true, immediate_mark: false) unless no_gc
    gc_stat_after = GC.stat
    memory_after = `ps -o rss= -p #{Process.pid}`.to_i / 1024

    puts("*******************************************************")
    puts("Ruby Version: #{RUBY_VERSION}")
    puts("Execution Time: #{time.round(2)}")
    puts("Garbage Collection Infos:")
    puts("  Usage: #{no_gc ? 'disabled' : 'enabled'}")
    puts("  Counter: #{gc_stat_after[:count] - gc_stat_before[:count]}")
    puts("  Memory: #{'%d MB' % (memory_after - memory_before)}")
    puts("*******************************************************")
  end
end