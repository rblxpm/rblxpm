local rblxpm = {}

local cacheFolder = script.cache
local importsCache = script.importsCache
local packageIndexUrl = "https://raw.githubusercontent.com/rblxpm/rblxpm-packages/main/packageIndex.json"
local HttpService = game:GetService("HttpService")
local packageIndex = script.packageIndex

function rblxpm:init()
    
end

function rblxpm:updatePackageIndex()
    local data
    local response
    pcall(function()
		response = HttpService:GetAsync(packageIndexUrl)
		data = HttpService:JSONDecode(response)
	end)
    if data then
        packageIndex = data
    else
        warn("[RBLXPM] There was an error gettting or JSON Decoding the Package Index. Retrying in 5 seconds.")
        wait(5)
        rblxpm:updatePackageIndex()
    end
end

function rblxpm:import(ref)
   if typeof(ref) == 'string' then
   elseif typeof(ref) == ''
end

return rblxpm