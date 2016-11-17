require 'gosu'

class WhackATrump < Gosu::Window
	def initialize
		super(800,600)
		self.caption = 'Whack the Trump!'
		@image = Gosu::Image.new('images/trump.png')
		@image_two = Gosu::Image.new('images/trumpHair.png')
		@x = 200
		@y = 200
		@x_two = 400
		@y_two = 300
		@width = 100
		@height = 100
		@width_two = 100
		@height_two = 100
		@velocity_x = 4
		@velocity_y = 4
		@velocity_x_two = -4
		@velocity_y_two = -4
		@visible = 0
		@visible_two = 0
		@hammer_image = Gosu::Image.new('images/hammer.png')
		@hit = 0
		@font = Gosu::Font.new(30)
		@font_large = Gosu::Font.new(60)
		@score = 0
		@playing = true
		@start_time = 0
	end

	def button_down(id)
		if @playing
			if (id == Gosu::MsLeft)
				if Gosu.distance(mouse_x, mouse_y, @x, @y) < 50 && @visible >= 0
					@hit = 1
					@score += 5
				elsif Gosu.distance(mouse_x, mouse_y, @x_two, @y_two) < 50 && @visible_two >= 0
					@hit = 1
					@score += 5
				else
					@hit = -1
					@score -= 1
				end
			end
		else
			if (id == Gosu::KbSpace)
				@playing = true
				@visible = -10
				@start_time = Gosu.milliseconds
				@score = 0
			end
		end
	end

	def update
		if @playing
			@x += @velocity_x
			@y += @velocity_y
			@x_two += @velocity_x_two
			@y_two += @velocity_y_two
			@velocity_x *= -1 if @x + @width / 2 > 800 || @x - @width / 2 < 0
			@velocity_y *= -1 if @y + @height / 2 > 600 || @y - @height /2 < 0
			@velocity_x_two *= -1 if @x_two + @width_two / 2 > 800 || @x_two - @width_two / 2 < 0
			@velocity_y_two *= -1 if @y_two + @height_two / 2 > 600 || @y_two - @height_two / 2 < 0
			@visible -= 1
			@visible_two -= 1
			@visible = 30 if @visible < -7 && rand < 0.03
			@visible_two = 30 if @visible_two < -7 && rand < 0.03
			@time_left = (60 - ((Gosu.milliseconds - @start_time) / 1000))
			@playing = false if @time_left < 0
		end
	end

	def draw
		if @visible > 0
			@image.draw(@x - @width / 2, @y - @height / 2, 1)
		end

		if @visible_two > 0
			@image_two.draw(@x_two - @width_two / 2, @y_two - @height_two / 2, 1)
		end

		@hammer_image.draw(mouse_x - 40, mouse_y - 10, 1)

		if @hit == 0
			c = Gosu::Color::NONE
		elsif @hit == 1
			c = Gosu::Color::GREEN
		elsif @hit == -1
			c = Gosu::Color::RED
		end
		
		draw_quad(0, 0, c, 800, 0, c, 800, 600, c, 0, 600, c)
		@hit = 0
		@font.draw("Score: " + @score.to_s, 660, 20, 2)
		@font.draw("Time left: " + @time_left.to_s + "s", 20, 20, 2)
		
		unless @playing
			@time_left = 0
			@font_large.draw("Game Over", 270, 250, 3)
			@font.draw("Press the Space Bar to Play Again", 200, 320, 3)
			@visible = 20
			@visible_two = 20
		end
	end
end

window = WhackATrump.new
window.show