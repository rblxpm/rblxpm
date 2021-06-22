local rblxpm = {}

local cacheFolder = script.cache
local packageIndexUrl = "https://raw.githubusercontent.com/rblxpm/rblxpm-packages/main/packageIndex.json"
local HttpService = game:GetService("HttpService")
local packageIndex

function rblxpm:init()
    
end

function rblxpm:updatePackageIndex()
    local data
    local response
    pcall(function ()
		response = HttpService:GetAsync(packageIndexUrl)
		data = HttpService:JSONDecode(response)
	end)
    if not data then
    else
    end
end

function rblxpm:import(moduleName)
   
end

return rblxpm