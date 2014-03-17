--
-- The intro menu
--

Menu = {}

function Menu:enter()
	bg = g.newImage("gamestates/menu/bg.jpg")
end

function Menu:draw()
	g.draw(bg, 0, 0)
	
	g.setColor(0,0,0,200)
	g.rectangle("fill", width/2 - 200, height/2 - 200, 250, 200)
	
	g.setColor(255, 255, 255)
	local font = g.newFont("fonts/orangejuice20.ttf", 24) 
	g.setFont(font)	

	local instructions = 
	"HOW TO PLAY\n"..
	"x - jump\n"..
	"right arrow - go right\n"..
	"left arrow: - go left\n"..
	"space bar - shoot"..
	"\n\n\n"..
	"Press Enter to continue"
	
	g.print(instructions, width/2 - 200, height/2 - 200)
end

function Menu:keyreleased(key, code)
    if key == 'return' then
        Gamestate.switch(Game)
    end
end