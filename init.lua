--------------------------------------Rotten Papyrus 0.5----------------------------------------
--Textures (edited with gimp) from gamiano.de
--nodebox from 3dforniture

local PAPYRUS_NODEBOX = {
			type = "fixed",
			fixed = {
				--papyrus 1
				{-0.03-0.1,-0.5,-0.03-0.1, 0.03-0.1,0.5,0.03-0.1},
				{-0.06-0.1,-0.02-0.1,-0.06-0.1, 0.06-0.1,0.02-0.1,0.06-0.1},
				--papyrus 2
				{-0.03-0.4,-0.5,-0.03-0.3, 0.03-0.4,0.5,0.03-0.3},
				{-0.06-0.4,-0.02-0.2,-0.06-0.3, 0.06-0.4,0.02-0.2,0.06-0.3},
				--papyrus 3
				{-0.03+0.4,-0.5,-0.03-0.3,0.03+0.4,0.5,0.03-0.3},
				{-0.06+0.4,-0.02+0.2,-0.06-0.3, 0.06+0.4,0.02+0.2,0.06-0.3},
				--papyrus 4
				{-0.03-0.4,-0.5,-0.03+0.4, 0.03-0.4,0.5,0.03+0.4},
				{-0.06-0.4,0.02+0.4,-0.06+0.4, 0.06-0.4,0.02+0.4,0.06+0.4},
				--papyrus 5
				{-0.03-0.2,-0.5,-0.03+0.2, 0.03-0.2,0.5,0.03+0.2},
				{-0.06-0.2,0.02-0.4,-0.06+0.2, 0.06-0.2,0.02-0.4,0.06+0.2},
				--papyrus 6
				{-0.03+0.1,-0.5,-0.03+0.2, 0.03+0.1,0.5,0.03+0.2},
				{-0.06+0.1,0.02+0.3,-0.06+0.2, 0.06+0.1,0.02+0.3,0.06+0.2},
				},
			}
local function papyrusnode(name, desc, img, drop)
	minetest.register_node(name,{
			description	=	desc,
			drawtype	=	"nodebox",
				tiles	=	{img},
			paramtype	=	"light",
	is_ground_content	=	true,
			walkable	=	false,
		drop 			= 	drop,
		node_box 		= 	PAPYRUS_NODEBOX,
		groups 			= 	{snappy = 3,flammable = 2},
		sounds 			= 	default.node_sound_leaves_defaults(),
	})
end

papyrusnode(":default:papyrus", "Papyrus", "mod_papyrus.png", "default:papyrus")
papyrusnode("rotten_papyrus:papyrus_rotten1", "", "mo_papyrus_rotten1.png", "default:papyrus")
papyrusnode("rotten_papyrus:papyrus_rotten2", "", "mo_papyrus_rotten2.png", "")

minetest.register_abm ({
	nodenames = {"rotten_papyrus:papyrus_rotten1","rotten_papyrus:papyrus_rotten2"},
	interval = 0,
	chance = 1,
	action = function (pos)
		if minetest.env:get_node({x=pos.x, y=pos.y-1, z=pos.z}).name == "air" then
			minetest.env:remove_node(pos)
		end
	end,
})
minetest.register_abm ({
	nodenames = {"default:papyrus","rotten_papyrus:papyrus_rotten1","rotten_papyrus:papyrus_rotten2"},
	interval = PAPYRUS_INTERVALL,
	chance = PAPYRUS_CHANCE,
	action = function (pos)
		local env = minetest.env
		local under = env:get_node({x=pos.x, y=pos.y-1, z=pos.z})

---------------fault
		if env:get_node(pos).name == "default:papyrus" then
			if env:find_node_near(pos, 1, {"default:water_source","default:water_flowing"})
			or under.name == "default:papyrus" then return
			else env: add_node (pos, {name = "rotten_papyrus:papyrus_rotten1"})
			end

---------------fault mehr
		elseif env:get_node(pos).name == "rotten_papyrus:papyrus_rotten1" then
			if env:find_node_near(pos, 1, {"default:water_source","default:water_flowing"})
			or under.name == "default:papyrus" then
				env: add_node (pos, {name = "default:papyrus"})
			else
				env: add_node (pos, {name = "rotten_papyrus:papyrus_rotten2"})
			end

---------------stirbt ab
		elseif env:get_node(pos).name == "rotten_papyrus:papyrus_rotten2" then
			env:remove_node(pos)
		end
	end,
})
