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
    if not version then
        print("Could not find VSCode extension version! We will try to apply the fixes anyway.")
        local gitHubFixes = require("mods/noita-vscode-debugger/github_fixes"):new(fileUtils)
        gitHubFixes:downloadAndApplyFixes()
    end

    lldebugger = require("lldebugger")
    lldebugger.start()
end

if not lldebugger then
    fixDebugger()
end

fileUtils = nil -- free as much memory as possible
fixDebugger = nil -- free as much memory as possible

lldebugger.pullBreakpoints()
lldebugger._VERSION = "v0.3.3"

print("Happy debugging!")
