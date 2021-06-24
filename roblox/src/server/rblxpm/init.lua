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
local libsFolder
local packageIndex
local packageCache

--Init

if not ServerStorage:FindFirstChild("RBLXPM") then
    rblxpmFolder = Instance.new("Folder")
    rblxpmFolder.Name = "RBLXPM"
    rblxpmFolder.Parent = ServerStorage

    libsFolder = Instance.new("Folder")
    libsFolder.Name = "Libs"
    libsFolder.Parent = rblxpmFolder

else
    pcall(function()
        rblxpmFolder = ServerStorage:FindFirstChild("RBLXPM")
    end)
    if rblxpmFolder then
        pcall(function()
            libsFolder = rblxpmFolder:FindFirstChild("Libs")
        end)
        if libsFolder then

        else
            libsFolder = Instance.new("Folder")
            libsFolder.Name = "Libs"
            libsFolder.Parent = rblxpmFolder
        end
    else
        rblxpmFolder = Instance.new("Folder")
        rblxpmFolder.Name = "RBLXPM"
        rblxpmFolder.Parent = ServerStorage

        libsFolder = Instance.new("Folder")
        libsFolder.Name = "Libs"
        libsFolder.Parent = rblxpmFolder
    end
end

--End init


--example table for packages [testing only]

local template = 
{
    ["Id"]={
        ["Reference"]="MyModule",
        ["RobloxId"] = 0,
        ["Installer"] = {
            ["MainModule"] = {
                ["Name"]="MainModule",
                ["Source"] = "https://cdn.coolwebsite.com/MainModule.lua",
                ["Children"] = {
                    ["ThisLibrary"] = {
                        ["Name"] = "ThisLibrary",
                        ["Type"] = "ModuleScript",
                        ["Source"] = "https://cdn.coolwebsite.com/ThisLibrary.lua",
                        ["Children"] = {}
                    },
                    ["ThisFolder"] = {
                        ["Name"] = "ThisFolder",
                        ["Type"] = "Folder",
                        ["Children"] = {}
                    },
                }
            }
        }
    }
}

--end

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