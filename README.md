Instructions
------------

You should call `sharecart.valid` with the current working directory to
determine if you're in a valid sharecart location. You'll need your game to be
running in a directory that's a sibling to a `/dat` directory that contains a
proper `o_o.ini` file.

    /dat
       o_o.ini
    /GAMENAME
       GAMEEXECUTABLE

`sharecart.valid` will return a boolean describing if you're in a sharecart
compatible directory. If it isn't, it's up to your game to decide what to do.
Maybe you create a sibling directory? Maybe you bail out and let the player
know they should move the game? I don't know. Your call.

The Sharecart save file permits only specifc keys and restricted values for them

- MapX (0-1023)
- MapY (0-1023)
- Misc0 (0-65535)
- Misc1 (0-65535)
- Misc2 (0-65535)
- Misc3 (0-65535)
- PlayerName (1023 characters max)
- Switch0 (TRUE/FALSE)
- Switch1 (TRUE/FALSE)
- Switch2 (TRUE/FALSE)
- Switch3 (TRUE/FALSE)
- Switch4 (TRUE/FALSE)
- Switch5 (TRUE/FALSE)
- Switch6 (TRUE/FALSE)
- Switch7 (TRUE/FALSE)

Writing to the sharecart save file is easy

```lua
local cart_data = sharecart.load(cwd)
cart_data.PlayerName = 'Stephen'
```

Doing this will immediately write that value to `dat/o_o.ini`. If you want to defer writing the value, for now you'll have to wrap the cart_data setters on your own.

If you set a non-sharecart key on the table, it'll blow up
```lua
cart_data.Name = 'Not a real key'
-->> lua: sharecart.lua:118: Key "Name" isn't a sharecart save key
```

Similarly, if you don't follow the restrictions for the key's data type, it'll also blow up.
```lua
cart_data.MapX = -5
-->> lua: sharecart.lua:122: Key "MapX" can't store the given value (-5)
```

Ideally you wouldn't write bad stuff to the shared file. Sometimes bugs happen. To protect yourself from writing bad data without crashing your game, you can do something like the following

```lua
function save_position(position)
	return function()
		cart_data.x = position.x
		cart_data.y = position.y
	end
end

if not pcall(save_position(position)) then
	-- handle failure case
end
```

I'm not psyched about that pattern, but I'd rather not let me wreck the save data.

Let me know if this is terrible. I'll make an example game shortly in its own repo.