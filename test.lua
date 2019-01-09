require("yieldhook")

do
  local sethook, time = debug.sethook, os.clock
  coroutine.settimeout = function(cr, to, count)
    if not count then
      count = 1000000
    end
    if type(to) == 'number' then
      to = to + time()
      sethook(cr, function()
        if time() > to then
          sethook()
          return true
        end
      end, 'y', count)
    else
      sethook(cr)
    end
  end
  local resume, yield = coroutine.resume, coroutine.yield
  local status = coroutine.status
  coroutine.yield = function(...)
    yield(true, ...)
  end
  coroutine.resume = function(cr, ...)
    res = {resume(cr, ...)}
    if status(cr) == 'dead' then
      return table.unpack(res)
    elseif res[2] then
      return table.unpack(res, 2)
    end
  end
end



local realprint = print
function print(...)
  realprint(os.date(), ...)
end



local function sleep(s)
  local d = os.time() + s
  while os.time() < d do end
end



local cr = {2, 3, 5, 7}

for i, t in ipairs(cr) do
  cr[i] = coroutine.create(function()
    local i, t = i, t
    for j = 1, 4 do
      print(i, j)
      coroutine.yield(j)
      sleep(t)
    end
    return 'done'
  end)
end

local f = true
while f do
  f = false
  for i, t in ipairs(cr) do
    if coroutine.status(t) ~= 'dead' then
      coroutine.settimeout(t, 0.5)
      local r, v = coroutine.resume(t)
      if r == nil then
        print(i, 'timed out')
      elseif r then
        print(i, 'yielded:', v)
      else
        print(i, 'crashed:', v)
      end
      f = true
    end
  end
end
