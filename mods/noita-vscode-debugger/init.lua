if not require then
    error("This mod is only meant to be used with unsafe mod mode.", 2)
end

local fileUtils = require("mods/noita-vscode-debugger/file_utils"):new()
fileUtils:fixPackagePath()

local fixDebugger = function()
    print("Looks like VSCode extension fixes needs to be applied..")

    local extensionPath = fileUtils:getVSCodeExtensionPath()
    if not extensionPath then
        error("Could not find VSCode extension path!", 2)
    end

    local version = fileUtils:getVSCodeExtensionVersion(extensionPath)
    if not version or version ~= "v0.3.3-IsmohFixes" then
        print("Could not find VSCode extension version! We will try to apply the fixes anyway.")
    else
        print(("Found lldebugger version: %s"):format(version))
    end
    print("Updating lldebugger.lua anyways. No matter the version.")

    ---@type GitHubFixes
    local gitHubFixes = require("mods/noita-vscode-debugger/github_fixes"):new(fileUtils)
    gitHubFixes:downloadAndApplyFixes()
end

if not lldebugger then
    fixDebugger()
    lldebugger = require("lldebugger")
    lldebugger.start()
    lldebugger.pullBreakpoints()
    lldebugger._VERSION = "v0.3.3-IsmohFixes"
end

fileUtils = nil   -- free as much memory as possible
fixDebugger = nil -- free as much memory as possible

print("\27[32m Happy debugging! \27[0m")
print("\27[33m Make sure to disable this mod again, after the first run! (optional) \27[0m")


function OnWorldPreUpdate()
    lldebugger.pullBreakpoints()
end
