#entrada de nuestra aplicacion

require_relative "view/ruby2d"
require_relative "model/state"
require_relative "actions/actions"

# view = View::Ruby2dView.new
# initial_state = Model::initial_state
# view.start(initial_state)
# view.render(initial_state)

class App
  def initialize
    @state = Model::initial_state
  end

  def start
    @view = View::Ruby2dView.new(self)
    #initial_state = Model::initial_state
    timer_thread = Thread.new { init_timer(@view) }
    @view.start(@state)
    timer_thread.join
  end

  def init_timer(view)
    loop do
      #trigger movement
      if @state.game_finished
        puts "Juego finalizado"
        puts "Puntaje: #{@state.snake.positions.length}"
        break
      end
      @state = Actions::move_snake(@state)
      view.render(@state)
      sleep 0.5
    end
  end

  def send_action(action, params)
    new_state = Actions.send(action, @state, params)
    if new_state.hash != @state.hash
      @state = new_state
      @view.render(@state)
    end
  end
end

app = App.new
app.start
