--[[
    2021 The RBLXPM Authors
    Contributors:
    WindingTheRopes

    Documentation:

]]
local rblxpm = {}

--Services

local HttpService = game:GetService("HttpService")
local InsertService = game:GetService("InsertService")
local ServerStorage = game:GetService("ServerStorage")


--Variables

local packageIndexUrl = "https://raw.githubusercontent.com/rblxpm/rblxpm-packages/main/packageIndex.json"

--Empty variables

local rblxpmFolder
local cacheFolder
local packageIndex = script.packageIndex
local packageCache = script.importsCache

--Init

if not ServerStorage:FindFirstChild("RBLXPM") then
    rblxpmFolder = Instance.new("Folder")
    rblxpmFolder.Name = "RBLXPM"
    rblxpmFolder.Parent = ServerStorage

    cacheFolder = Instance.new("Folder")
    cacheFolder.Name = "Libs"
    cacheFolder.Parent = rblxpmFolder

else
    pcall(function()
        rblxpmFolder = ServerStorage:FindFirstChild("RBLXPM")
    end)
    if rblxpmFolder then
        pcall(function()
            cacheFolder = rblxpmFolder:FindFirstChild("Libs")
        end)
        if cacheFolder then

        else
            cacheFolder = Instance.new("Folder")
            cacheFolder.Name = "Libs"
            cacheFolder.Parent = rblxpmFolder
        end
    else
        rblxpmFolder = Instance.new("Folder")
        rblxpmFolder.Name = "RBLXPM"
        rblxpmFolder.Parent = ServerStorage

        cacheFolder = Instance.new("Folder")
        cacheFolder.Name = "Libs"
        cacheFolder.Parent = rblxpmFolder
    end
end

function rblxpm:updatePackageIndex()
    local data
    local response
    pcall(function()
		response = HttpService:GetAsync(packageIndexUrl)
		data = HttpService:JSONDecode(response)
	end)
    if data then
        print("[RBLXPM] Package cache updated.")
        packageIndex = data
    else
        warn("[RBLXPM] There was an error gettting or JSON Decoding the Package Index. Retrying in 5 seconds.")
        wait(5)
        rblxpm:updatePackageIndex()
    end
end

function importModuleFromCache(ref)
    local imported
    pcall(function()
        imported = cacheFolder:FindFirstChild(ref)
    end)
    if not imported:IsA("ModuleScript") then
        warn("[RBLXPM] Module is not a ModuleScript.")
        return nil
    end
    if imported then
        return require(imported)
    else
        warn("[RBLXPM] Module not found.")
    end
end

function isCached(ref)
    if cacheFolder:FindFirstChild(ref) then
        return true
    else
        return false
    end
end

function cacheModule(module, ref, clone)
    local moduleCacheId
    moduleCacheId = math.random(1, 65535)
    if cacheFolder:FindFirstChild(tostring(moduleCacheId)) then
        cacheModule(module, ref, clone)
    else
        local moduleCacheFolder = Instance.new("Folder")
        moduleCacheFolder.Name = tostring(moduleCacheId)
        moduleCacheFolder.Parent = cacheFolder

        if clone == false or clone == nil then
            module.Parent = moduleCacheFolder
        elseif clone == true then
            module:Clone().Parent = moduleCacheFolder
        else
        end
    end
end

function rblxpm:import(ref, clone)
   --Update the package index before potentially using it 
   rblxpm:updatePackageIndex()

   --Check what type of import it is and handle it accordingly
   if typeof(ref) == 'string' then
        --Import a module by name
        
   elseif typeof(ref) == 'number' then
        --Import module by Roblox Id
        

   elseif typeof(ref) == 'Instance' then
        --Directly import a modulescript
        --Deletes the original modulescript on runtime, this can be cancelled by passing opt true
        
        if ref:IsA("ModuleScript") then
            if clone == false or clone == nil then
                --Move the modulescript

            elseif clone == true then
                --Clone the modulescript
            else
                
            end
        else
            warn("[RBLXPM] The passed instance is not a module script.")
        end
       
   else

       warn("[RBLXPM] The passed reference couldn't be imported.") 
       return nil 
   end 
end

return rblxpm