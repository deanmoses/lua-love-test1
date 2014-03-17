--
-- The intro menu
--

Menu = {}

function Menu:enter()
	bg = g.newImage("gamestates/menu/bg.jpg")
	
	instructions = {
		width = 240,
		height = 220
	}
	
	pressEnter = { x=200, y=0, text = "Press Enter to continue" }
	tween(4, pressEnter, { y=300 }, 'outBounce')
	
	rect = { color=0 }
	tween(4, rect, { color=255 }, 'linear')
end

function Menu:update(dt)
	tween.update(dt)	
end

function Menu:draw()
	g.draw(bg, 0, 0)
	
	
	
	g.setColor(0,0,0,rect.color)
	g.rectangle("fill", 190, 100, instructions.width + 20, instructions.height)
	
	g.setColor(255, 255, 255)
	local font = g.newFont("fonts/orangejuice20.ttf", 24) 
	g.setFont(font)	

	local instructions = 
	"HOW TO PLAY\n"..
	"x - jump\n"..
	"right arrow - go right\n"..
	"left arrow: - go left\n"..
	"space bar - shoot"

	g.print(instructions, width/2 - 200, height/2 - 200)
	
	g.print(pressEnter.text, pressEnter.x, pressEnter.y)
end

function Menu:keyreleased(key, code)
    if key == 'return' then
        Gamestate.switch(Game)
    end
end