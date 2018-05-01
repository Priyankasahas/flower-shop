require 'highline'
require 'rainbow'

# Client Interface Service
class CliService
  def initialize
    @service = HighLine.new
  end

  def get_input(message)
    ask = Rainbow(message +
                  '(Comma separated list)').green
    @service.ask(ask, ->(str) { str.split(/,\s*/) })
  end
end
