local t1 = os.clock()

rotten_papyrus = rotten_papyrus or {}
rotten_papyrus.interval = 600
rotten_papyrus.chance = 10

rotten_papyrus.list = {
	{":default:papyrus", "Papyrus", "rotten_papyrus.png", "default:papyrus"},
	{"rotten_papyrus:dried1", "", "rotten_papyrus_dried1.png", "default:papyrus"},
	{"rotten_papyrus:dried2", "", "rotten_papyrus_dried2.png", "default:paper"}
}

rotten_papyrus.NODEBOX = {
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


local tmp = minetest.registered_nodes["default:papyrus"]
local pt = tmp.paramtype
local wk = tmp.walkable
local gt = tmp.is_ground_content
local gp = tmp.groups
local sd = tmp.sounds
local adn = tmp.after_dig_node

for _,p in ipairs(rotten_papyrus.list) do

	minetest.register_node(p[1], {
		description = p[2],
		tiles = {p[3]},
		drop = p[4],

		drawtype = "nodebox",
		node_box = rotten_papyrus.NODEBOX,

		paramtype = pt,
		walkable = wk,
		is_ground_content = gt,
		groups = gp,
		sounds = sd,
		after_dig_node = adn,
	})

end


function rotten_papyrus.allow_papyrus(pos)
	if minetest.find_node_near(pos, 2, {"default:water_source","default:water_flowing"})
	or minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name == "default:papyrus" then
		return true
	end
	return false
end

minetest.register_abm ({
	nodenames = {"default:papyrus","rotten_papyrus:dried1","rotten_papyrus:dried2"},
	interval = rotten_papyrus.interval,
	chance = rotten_papyrus.chance,
	action = function (pos, node)
		local nam = node.name
		local papyrus_allowed = rotten_papyrus.allow_papyrus(pos)

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
