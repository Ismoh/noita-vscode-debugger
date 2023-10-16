---@class FileUtils
local FileUtils = {}

--- Contains on lower case
--- @param str string String
--- @param pattern string String, Char, Regex
--- @return boolean found: 'true' if found, else 'false'.
string.contains = function(str, pattern)
    if not str or str == "" then
        error("str must not be nil!", 2)
    end
    if not pattern or pattern == "" then
        error("pattern must not be nil!", 2)
    end
    local found = string.find(str:lower(), pattern:lower(), 1, true)
    if not found or found < 1 then
        return false
    else
        return true
    end
end

-- http://lua-users.org/wiki/SplitJoin
-- Function: Split a string with a pattern, Take Two
-- Compatibility: Lua-5.1
string.split    = function(str, pat)
    local t         = {}
    local fpat      = "(.-)" .. pat
    local last_end  = 1
    local s, e, cap = str:find(fpat, 1)
    while s do
        if s ~= 1 or cap ~= "" then
            table.insert(t, cap)
        end
        last_end  = e + 1
        s, e, cap = str:find(fpat, last_end)
    end
    if last_end <= #str then
        cap = str:sub(last_end)
        table.insert(t, cap)
    end
    return t
end

function FileUtils:fixPackagePath()
    local currentPath = io.popen('echo %CD%'):read("*l")
    print("current.path: " .. currentPath)
    local packagePath = (
        "%s/mods/noita-vscode-debugger/lua_modules/share/lua/5.1/?.lua;" ..
        "%s/mods/noita-vscode-debugger/lua_modules/share/lua/5.1/?/init.lua;" ..
        "%s/mods/noita-vscode-debugger/lua_modules/share/lua/5.1/?/core.lua;" ..
        "%s"):format(currentPath, currentPath, currentPath, package.path)
    local packageCPath = (
        "%s/mods/noita-vscode-debugger/lua_modules/lib/lua/5.1/?.dll;" ..
        "%s/mods/noita-vscode-debugger/lua_modules/lib/lua/5.1/?/init.dll;" ..
        "%s/mods/noita-vscode-debugger/lua_modules/lib/lua/5.1/?/core.dll;" ..
        "%s"):format(currentPath, currentPath, currentPath, package.cpath)
    package.path = packagePath
    package.cpath = packageCPath
    print("Successfully fixed package.path and package.cpath!")
    print("package.path: ")
    for key, value in pairs(string.split(package.path, ";")) do
        print(value)
    end

    print("package.cpath: ")
    for key, value in pairs(string.split(package.cpath, ";")) do
        print(value)
    end
end

---Searches for the extension path of the VSCode extension "Local Lua Debugger".
---@return string|nil extensionPath The path to the extension 'tomblind.local-lua-debugger-vscode-{version}'.
function FileUtils:getVSCodeExtensionPath()
    local fullPath = io.popen('echo %USERPROFILE%/.vscode/extensions'):read("*l")
    local paths = string.split(io.popen('dir /X /AD /B "%USERPROFILE%/.vscode/extensions/"'):read("*a"), "\n")
    local extensionName = "tomblind.local-lua-debugger-vscode-"
    local extensionPath = nil
    print(extensionName)
    for key, path in pairs(paths) do
        if string.contains(path, extensionName) then
            extensionPath = ("%s/%s"):format(fullPath, path)
            break
        end
    end
    return extensionPath
end

---Searches for the version of the VSCode extension "Local Lua Debugger" inside of 'lldebugger.lua'.
---@param extensionPath string The path to the extension 'tomblind.local-lua-debugger-vscode-{version}'. Required!
---@return string|nil version The version of the VSCode extension 'Local Lua Debugger'.
function FileUtils:getVSCodeExtensionVersion(extensionPath)
    local file = assert(io.open(("%s/debugger/lldebugger.lua"):format(extensionPath), "r"),
        ("Unable to find '%s/debugger/lldebugger.lua'! Did you install the VSCode extension 'Local Lua Debugger'?"):format(extensionPath))
    local content = file:read("*a")
    file:close()
    
    if string.contains(content, "--_VERSION") then
        local version = string.match(content, "(v%d+%.%d+%.%d+.%a+)")
        print(("Found `_VERSION` '%s'!"):format(version))
        return version
    else
        print(("Could not find version in '%s/debugger/lldebugger.lua'!"):format(extensionPath))
    end
    return nil
end

---FileUtils constructor.
---@return FileUtils fileUtils The FileUtils instance.
function FileUtils:new()
    ---@class FileUtils
    local fileUtils = setmetatable(self, FileUtils)

    return fileUtils
end

return FileUtils
