local GitHubFixes = {
    filesToFix = {
        --"package-lock.json",
        "debugger/debugger.ts",
        "debugger/lldebugger.lua.map", -- not needed
        "debugger/lldebugger.lua",
        "debugger/lldebugger.ts",
        "debugger/protocol.d.ts",

        "extension/debugAdapter.js",
        "extension/debugPipe.js",
        "extension/debugPipe.ts",
        "extension/extension.js",
        "extension/launchConfig.js",
        "extension/launchConfig.ts",
        "extension/luaDebugSession.js",
        "extension/luaDebugSession.ts",
        "extension/message.js",

        "package.json"
    }
}

---Downloads the fixes from GitHub and applies them.
function GitHubFixes:downloadAndApplyFixes()
    for key, relativeFilePath in pairs(self.filesToFix) do
        local lldebuggerUrlRaw =
            ("https://raw.githubusercontent.com/Ismoh/local-lua-debugger-vscode/master/%s"):format(relativeFilePath)

        local body, code = self.http.request(lldebuggerUrlRaw)
        if code ~= 200 then
            error("Could not download 'lldebugger.lua' from GitHub! Code: " .. code, 2)
        end
        print(("Successfully downloaded '%s' from GitHub!"):format(relativeFilePath))

        if string.contains(relativeFilePath, "lldebugger.lua") then
            body = [[--_VERSION = "v0.3.3-IsmohFixes"
]] .. body
            self:updateLLDebbugerLua(body)
        end
        self:applyFixes(relativeFilePath, body)
    end
    print("Successfully applied all fixes!")

    GamePrintImportant("Restart your debug session!", "Successfully applied all fixes to Local Lua Debugger! Make sure to restart your debug session!")
end

function GitHubFixes:applyFixes(relativeFilePath, body)
    local file = assert(io.open(
            ("%s/%s"):format(self.fileUtils:getVSCodeExtensionPath(), relativeFilePath), "w"),
        ("Unable to find '%s'! Did you install the VSCode extension 'Local Lua Debugger'?"):format(relativeFilePath))
    file:write(body)
    file:flush()
    file:close()
    print(("Successfully applied fixes to '%s'!"):format(relativeFilePath))
end

function GitHubFixes:updateLLDebbugerLua(body)
    local currentPath = io.popen("cd"):read("*l")
    local file = assert(io.open(("%s/mods/noita-vscode-debugger/lldebugger.lua"):format(currentPath), "w+"),
        ("Unable to find '%s/mods/noita-vscode-debugger/lldebugger.lua'!"):format(currentPath))
    file:write(body)
    file:flush()
    file:close()
    print(("Successfully updated 'lldebugger.lua' in project directory '%s/mods/noita-vscode-debugger'!"):format(currentPath))
end

---GitHubFixes constructor.
---@param fileUtils FileUtils
---@return GitHubFixes githubFixes The GitHubFixes instance.
function GitHubFixes:new(fileUtils)
    ---@class GitHubFixes
    local gitHubFixes = setmetatable(self, GitHubFixes)

    if not gitHubFixes.http then
        gitHubFixes.http = require("socket.http")
    end

    if not gitHubFixes.fileUtils then
        gitHubFixes.fileUtils = fileUtils or require("mods/noita-vscode-debugger/file_utils"):new()
    end

    return gitHubFixes
end

return GitHubFixes
