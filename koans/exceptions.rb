class RemoveKoanHarness
  def filter(backtrace)
    backtrace = backtrace.reject do |call|
      call.include?('start.rb')
    end
    backtrace << '<< Hidden calls in Koan Harness >>'
    backtrace
  end
end

class RemoveRSpecStackTrace
  def filter(backtrace)
    backtrace = backtrace.reject do |call|
      call.include?('gems/rspec-')
    end

    backtrace.prepend '<< Hidden calls in gem >>'
    backtrace
  end
end

class BacktracePrinter
  def initialize
    @filters = []
  end

  def add_filter(filter)
    @filters << filter
  end

  def execute(backtrace)
    @filters.each do |f|
      backtrace = f.filter(backtrace)
    end

    stacktrace = backtrace.map do |call|
      if parts = call.match(/^(?<file>.+):(?<line>\d+):in `(?<code>.*)'$/)
        file = parts[:file].sub /^#{Regexp.escape(File.join(Dir.getwd, ''))}/, ''
        line = "#{colorize(file, 36)} #{colorize('(', 37)}#{colorize(parts[:line], 32)}#{colorize('): ', 37)} #{colorize(parts[:code], 31)}"
      else
        line = colorize(call, 31)
      end
      line
    end

    stacktrace.each { |line| puts line }
  end
end
