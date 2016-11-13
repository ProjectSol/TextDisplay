textBoxes = {}
textDraw = {}
delayedText = {}
done = {}
text = ''
fullText = {}
local utf8 = require("utf8")
font = love.graphics.newFont()
titleFont = love.graphics.newFont("assets/wlm_carton.ttf", 36)
mainFont = love.graphics.newFont("assets/wlm_carton.ttf", 24)
function testing()
  print('test')
end




function textDraw:delayedNewText(string, subs)
  tbl = {}
  table.insert(delayedText, tbl)
  table.insert(fullText, text)

  for i = 1,string.len(string) do
    local e = string.sub(string, i, i)
    print(e)
    table.insert(delayedText[subs], e)
    table.insert(done, true)
  end
  t = love.timer:getTime()
end

function textDraw:delayDraw(subs, speed, x, y, Font)
  q = love.timer:getTime()
  love.graphics.setFont(Font)
  love.graphics.print(fullText[subs], x, y)
  for i = 1,#delayedText[subs] do
    if q >= t + i*speed then
      if done[i] then
        fullText[subs] = fullText[subs]..delayedText[subs][i]
        print(fullText[subs])
        print(subs)
        done[i] = false
      end
    end
  end
end

function love.textinput(t)
  text = text..t
end


function love.keypressed(key)
  if key == "return" then
    textDraw:delayedNewText(text, #delayedText+1)
    text = ''
  end
  if key == "backspace" then
    -- get the byte offset to the last UTF-8 character in the string.
    local byteoffset = utf8.offset(text, -1)

    if byteoffset then
      -- remove the last UTF-8 character.
      -- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
      text = string.sub(text, 1, byteoffset - 1)
    end
  end
end



textDraw:delayedNewText('You can make me type out anything', 1)
textDraw:delayedNewText('This is just me trying to write out a longer string than the original', 2)
print('test'..fullText[1])
print(fullText[2])

function love.draw()
    textDraw:delayDraw(1, 0.05, 10, 30, mainFont)
    textDraw:delayDraw(2, 0.05, 10, 45, mainFont)
    love.graphics.setFont(mainFont)
    love.graphics.print(text, 10, 80)

  if debug then
    love.graphics.setFont(font)
		love.graphics.setColor(255, 255, 255)
		fps = tostring(love.timer.getFPS())
		love.graphics.print("Current FPS: "..fps, 9, 10)
	end
end
