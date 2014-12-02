local sharecart = require('sharecart')

if not sharecart.valid('.') then
  error("tests aren't being run from a valid directory")
end

local cart_data = sharecart.load('.')

function setup()
  cart_data.MapX = 0
  cart_data.MapY = 0
  cart_data.Misc0 = 0
  cart_data.Misc1 = 0
  cart_data.Misc2 = 0
  cart_data.Misc3 = 0
  cart_data.PlayerName = 'empty'
  cart_data.Switch0 = false
  cart_data.Switch1 = false
  cart_data.Switch2 = false
  cart_data.Switch3 = false
  cart_data.Switch4 = false
  cart_data.Switch5 = false
  cart_data.Switch6 = false
  cart_data.Switch7 = false
end

setup()

function should_fail(fn)
  assert(not pcall(fn))
  io.write('.')
end

function should_equal(a, b)
  assert(a == b)
  io.write('.')
end

-- Map keys
for _, k in ipairs({'MapX', 'MapY'}) do
  -- integers in [0, 1023] should be saved
  cart_data[k] = 512
  should_equal(cart_data[k], 512)

  cart_data[k] = 0
  should_equal(cart_data[k], 0)

  cart_data[k] = 1023
  should_equal(cart_data[k], 1023)

  -- anything less than 0 should fail
  should_fail(function()
    cart_data[k] = -1
  end)

  should_fail(function()
    cart_data[k] = -512
  end)

  -- anything greater than 1023 should fail
  should_fail(function()
    cart_data[k] = 1024
  end)

  should_fail(function()
    cart_data[k] = 65535
  end)

  -- booleans can't be saved to map keys
  should_fail(function()
    cart_data[k] = true
  end)

  should_fail(function()
    cart_data[k] = false
  end)

  -- strings can't be saved to map keys
  should_fail(function()
    cart_data[k] = 'blah'
  end)

  -- should still have last saved value
  should_equal(cart_data[k], 1023)
end

-- Misc keys
for _, k in ipairs({'Misc0', 'Misc1', 'Misc2', 'Misc3'}) do
  -- integers in [0, 65535] should be saved
  cart_data[k] = 1024
  should_equal(cart_data[k], 1024)

  cart_data[k] = 0
  should_equal(cart_data[k], 0)

  cart_data[k] = 65535
  should_equal(cart_data[k], 65535)

  -- anything less than 0 should fail
  should_fail(function()
    cart_data[k] = -1
  end)

  should_fail(function()
    cart_data[k] = -512
  end)

  -- anything greater than 65535 should fail
  should_fail(function()
    cart_data[k] = 65536
  end)

  -- booleans can't be saved to map keys
  should_fail(function()
    cart_data[k] = true
  end)

  should_fail(function()
    cart_data[k] = false
  end)

  -- strings can't be saved to map keys
  should_fail(function()
    cart_data[k] = 'blah'
  end)

  -- fractional numbers can't be saved to map keys
  should_fail(function()
    cart_data[k] = 0.1
  end)

  -- should still have last saved value
  should_equal(cart_data[k], 65535)
end

-- PlayerName
cart_data.PlayerName = 'cool'
should_equal(cart_data.PlayerName, 'cool')

cart_data.PlayerName = 'other name'
should_equal(cart_data.PlayerName, 'other name')

-- booleans can't be saved to PlayerName
should_fail(function()
  cart_data.PlayerName = true
end)
should_fail(function()
  cart_data.PlayerName = false
end)

-- numbers can't be saved to PlayerName
should_fail(function()
  cart_data.PlayerName = 0
end)
should_fail(function()
  cart_data.PlayerName = 0.1
end)

-- should still have last saved value
should_equal(cart_data.PlayerName, 'other name')


-- Switches
for _, k in ipairs({'Switch0', 'Switch1', 'Switch2', 'Switch3', 'Switch4', 'Switch5', 'Switch6', 'Switch7'}) do
  -- booleans can be written to Switches
  cart_data[k] = true
  should_equal(cart_data[k], true)

  cart_data[k] = false
  should_equal(cart_data[k], false)

  -- numbers can't be saved to Switches
  should_fail(function()
    cart_data[k] = 0
  end)

  should_fail(function()
    cart_data[k] = 0.1
  end)

  -- strings can't be saved to Switches
  should_fail(function()
    cart_data[k] = 'blah'
  end)

  -- should still have last saved value
  should_equal(cart_data[k], false)
end

-- nonexistent keys should fail
should_fail(function()
  cart_data.Garbage = 'garbage'
end)

should_fail(function()
  cart_data.HotGarbage = true
end)


print('\nDone!')