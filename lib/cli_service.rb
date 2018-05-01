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

  def self.get_input(message)
    $/ = 'e'
    Rainbow(message).green
    user_input = STDIN.gets
    valid_input = user_input.split(/\n\s*/)
    valid_input.delete('e')
    valid_input.delete('')
    valid_input
  end
end
