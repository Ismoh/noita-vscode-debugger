local GitHubFixes = {
    filesToFix = {
        --"package-lock.json",
        "debugger/debugger.ts",
        "debugger/lldebugger.lua",
        "debugger/lldebugger.ts",
        "debugger/protocol.d.ts",
        "extension/debugPipe.ts",
        "extension/launchConfig.ts",
        "extension/luaDebugSession.ts",
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

        self:applyFixes(relativeFilePath, body)

        if string.contains(relativeFilePath, "lldebugger.lua") then
            
        end
    end
    print("Successfully applied all fixes!")
end

function GitHubFixes:applyFixes(relativeFilePath, body)
    local file = assert(io.open(
            ("%s/%s"):format(self.fileUtils:getVSCodeExtensionPath(), relativeFilePath), "w"),
        ("Unable to find '%s'! Did you install the VSCode extension 'Local Lua Debugger'?"):format(relativeFilePath))
    file:write(body)
    file:close()
    print(("Successfully applied fixes to '%s'!"):format(relativeFilePath))
end

function GitHubFixes:updateLLDebbugerLua(body)
    local currentPath = os.getenv("CD")
    local file = assert(io.open(("%s/lldebugger.lua"):format(currentPath), "w+"),
        ("Unable to find '%s/lldebugger.lua'!"):format(currentPath))

    local content = file:write(body)
    file:close()
    print(("Successfully updated 'lldebugger.lua' in project directory!"))
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
