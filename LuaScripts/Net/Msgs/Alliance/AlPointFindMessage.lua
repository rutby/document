local AlPointFindMessage = BaseClass("AlPointFindMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, ...)
	base.OnCreate(self)

	if ... ~= nil then
		print(...)
		local op = ...
		self.sfsObj:PutInt("op", op)
	end
end

return AlPointFindMessage