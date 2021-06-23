local rblxpm = {}

local cacheFolder = script.cache
local importsCache = script.importsCache
local packageIndexUrl = "https://raw.githubusercontent.com/rblxpm/rblxpm-packages/main/packageIndex.json"
local HttpService = game:GetService("HttpService")
local packageIndex = script.packageIndex
local InsertService = game:GetService("InsertService")

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
        --RBLXPM name import
   elseif typeof(ref) == 'number' then
        --RBLXPM roblox id import
        local asset
        pcall(function()
            asset = InsertService:LoadAsset(ref)
        end)
        if asset then
            local mainModule
            pcall(function()
                --Main module doesnt have to be called mainmodule, but it has to exist.
                mainModule = asset:FindFirstChildWhichIsA("ModuleScript")
            end)
            if mainModule then
                return require(mainModule)
            else
                warn("[RBXPM] No main module found.")
            end 
        else
            warn("[RBXPM] Error importing module: asset does not exist.")
        end
       
   elseif typeof(ref) == 'Instance'then
        if ref:IsA("ModuleScript") then
            return require(ref)
        else
            local mainModule
            pcall(function()
                mainModule = ref:FindFirstChildWhichIsA("ModuleScript")
            end)
            if mainModule then
                return require(mainModule)
            else
                warn("[RBLXPM] No main module found.")
            end
                
        end
   end 
end

return rblxpm