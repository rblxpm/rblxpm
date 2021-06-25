--[[
    Roblox Package Manager
    by the rblxpm team
    
    contributors:
    windingtheropes
    
    RBLXPM is created to be a reliable, powerful and easy to use library to import modules. The only time you should use require in a full usage scenario is importing the module. 
    The remainder of importing can be done through RBLXPM's import function, which does everything that the require function does, and more.
    
    What RBLXPM does
    
    RBLXPM uses the require function to return modules, but the process in the middle is considerably different. RBLXPM works by using cached modules, which can either be loaded in a central script, or just cached as code is run.
    After a module is cached, using the import function will import the cached module.
    
    Benefits
    
    The main benefit of using RBLXPM is cached modules. This allows for a reliable connection between scripts. With RBLXPM, you can easily share information between scripts using modules, on runtime.
    
    In order for this to work, the RBLXPM folder must not be modified

    For reasons of security, you are more than welcome to investigate it, but it isn't recommended to modify it, as this would most likely break a section of RBLXPM.

    Functions:

    rblxpm:import()

    Used to import any module in 3 different methods:
    by ID
    by Instance (import a ModuleScript from ServerStorage)
    by Reference (a name used to identify the module)
    
    Getting Started

    Getting started with RBLXPM is quite easy, all you need is one module! This module must be imported into a place like ReplicatedStorage or ServerStorage. From there, you can require the module, and start importing modules!

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

function cacheModule(module, ref)
    local clonedModule = module:Clone()
    clonedModule.Name = ref
    clonedModule.Parent = cacheFolder
end

function rblxpm:import(ref)
   if typeof(ref) == 'string' then
        --RBLXPM name import
        --allows you to import something by name from the package index, or manually import something in the cache folder.
   elseif typeof(ref) == 'number' then
        --RBLXPM roblox id import
        local cached
        pcall(function()
            cached = cacheFolder:FindFirstChild('Id_' .. ref) 
        end)
        if cached then
            --Id is cached
            return importModuleFromCache('Id_' .. ref)
        else
            --Id isn't cached
            local insertedAsset
            pcall(function()
                insertedAsset = InsertService:LoadAsset(ref)
            end)
            if insertedAsset then
                local clonedModule
                if insertedAsset:IsA("ModuleScript") then
                    clonedModule = insertedAsset:Clone()
                    clonedModule.Name = "Id_" .. ref
                    clonedModule.Parent = cacheFolder
                    return importModuleFromCache('Id_' .. ref)
                else
                    local mainModule
                    pcall(function()
                        mainModule = insertedAsset:FindFirstChildWhichIsA("ModuleScript")
                    end)
                    if mainModule then
                        clonedModule = mainModule:Clone()
                        clonedModule.Name = "Id_" .. ref
                        clonedModule.Parent = cacheFolder
                        return importModuleFromCache('Id_' .. ref)
                    else
                        --Nothing found
                        warn("[RBLXPM] The requested asset is not a module, or it does not contain a main module.")
                    end
                end
            else
                --Failed to import
                warn("[RBLXPM] Failed to load Roblox asset " .. ref .. ".")
            end
        end
   elseif typeof(ref) == 'Instance'then
        --RBLXPM instance import
        local cached
        if ref:IsA("ModuleScript") then
             if isCached('Instance_' .. ref.Name) then
                return importModuleFromCache("Instance_" .. ref)
             else
                cacheModule(ref, "Instance_" .. ref.Name)
             end
        else
            local mainModule
            pcall(function()
                mainModule = ref:FindFirstChildWhichIsA("ModuleScript")
            end)
            if mainModule then
                if isCached("Instance_" .. mainModule.Name) then
                    return importModuleFromCache("Instance_" .. mainModule.Name)
                else
                    cacheModule(mainModule, "Instance_" .. mainModule.Name)
                end
            else
                warn("[RBLXPM] The passed instance is not a module script, or does not contain a main module.")
            end
        end
   else
       warn("[RBLXPM] The passed reference couldn't be imported.") 
       return nil 
   end 
end

return rblxpm