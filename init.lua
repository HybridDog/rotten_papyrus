local load_time_start = minetest.get_us_time()


local rotten_papyrus = {}
--rotten_papyrus = rawget(_G, "rotten_papyrus") or {}
rotten_papyrus.interval = 600
rotten_papyrus.chance = 10

rotten_papyrus.list = {
	{":default:papyrus",
		texture = "rotten_papyrus.png",
	},
	{"rotten_papyrus:dried1",
		description = "",
		texture = "rotten_papyrus_dried1.png",
		drop = "default:papyrus"
	},
	{"rotten_papyrus:dried2",
		description = "",
		texture = "rotten_papyrus_dried2.png",
		drop = "default:paper"
	}
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


for _,p in pairs(rotten_papyrus.list) do
	local tmp = table.copy(minetest.registered_nodes["default:papyrus"])
	tmp.description = p.description or tmp.description
	tmp.tiles = {p.texture}
	tmp.inventory_image = nil
	tmp.wield_image = nil
	tmp.drop = p.drop or tmp.drop

	tmp.drawtype = "nodebox"
	tmp.node_box = rotten_papyrus.NODEBOX
	tmp.selection_box = rotten_papyrus.NODEBOX

	minetest.register_node(p[1], tmp)
end


function rotten_papyrus.allow_papyrus(pos)
	if minetest.find_node_near(pos, 2, {"default:water_source","default:water_flowing"})
	or minetest.get_node{x=pos.x, y=pos.y-1, z=pos.z}.name == "default:papyrus" then
		return true
	end
	return false
end

minetest.register_abm {
	nodenames = {"default:papyrus","rotten_papyrus:dried1","rotten_papyrus:dried2"},
	interval = rotten_papyrus.interval,
	chance = rotten_papyrus.chance,
	action = function (pos, node)
		local nam = node.name

---------------stirbt ab
		if nam == "rotten_papyrus:dried2" then
			minetest.remove_node(pos)
			return
		end

		local papyrus_allowed = rotten_papyrus.allow_papyrus(pos)

---------------fault
		if nam == "default:papyrus" then
			if not papyrus_allowed then
				node.name = "rotten_papyrus:dried1"
				minetest.add_node(pos, node)
			end

---------------fault mehr
		else
			if papyrus_allowed then
				node.name = "default:papyrus"
			else
				node.name = "rotten_papyrus:dried2"
			end
			minetest.add_node(pos, node)
		end
	end,
}


local time = (minetest.get_us_time() - load_time_start) / 1000000
local msg = "[rotten_papyrus] loaded after ca. " .. time .. " seconds."
if time > 0.01 then
	print(msg)
else
	minetest.log("info", msg)
end
