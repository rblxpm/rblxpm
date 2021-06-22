local rblxpm = {}

local cacheFolder = script.cache
local packageIndexUrl = "https://raw.githubusercontent.com/rblxpm/rblxpm-packages/main/packageIndex.json"
local httpService = game:GetService("HttpService")
local packageIndex

function rblxpm:init()
    packageIndex = httpService:GetAsync(packageIndexUrl)
    
end

function rblxpm:import(moduleName)
   
end

return rblxpm