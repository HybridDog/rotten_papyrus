local t1 = os.clock()
local PAPYRUS_INTERVALL = 600
local PAPYRUS_CHANCE = 10

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

papyrusnode(":default:papyrus", "Papyrus", "rotten_papyrus.png", "default:papyrus")
papyrusnode("rotten_papyrus:dried1", "", "rotten_papyrus_dried1.png", "default:papyrus")
papyrusnode("rotten_papyrus:dried2", "", "rotten_papyrus_dried2.png", "default:paper")

local function allow_papyrus(pos)
	if minetest.find_node_near(pos, 2, {"default:water_source","default:water_flowing"})
	or minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name == "default:papyrus" then
		return true
	end
	return false
end

minetest.register_abm ({
	nodenames = {"default:papyrus","rotten_papyrus:dried1","rotten_papyrus:dried2"},
	interval = PAPYRUS_INTERVALL,
	chance = PAPYRUS_CHANCE,
	action = function (pos, node)
		local nam = node.name
		local papyrus_allowed = allow_papyrus(pos)

---------------fault
		if nam == "default:papyrus" then
			if not papyrus_allowed then
				minetest.add_node(pos, {name = "rotten_papyrus:dried1"})
			end
			return
		end

---------------fault mehr
		if nam == "rotten_papyrus:dried1" then
			if papyrus_allowed then
				minetest.add_node(pos, {name = "default:papyrus"})
			else
				minetest.add_node(pos, {name = "rotten_papyrus:dried2"})
			end
			return
		end

---------------stirbt ab
		minetest.remove_node(pos)
	end,
})

print(string.format("[rotten_papyrus] loaded after ca. %.2fs", os.clock() - t1))
