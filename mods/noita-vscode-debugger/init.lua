if not require then
    error("This mod is only meant to be used with unsafe mod mode. Allow it in `Mods`!", 2)
end
if not lldebugger then
    lldebugger = require("lldebugger")
    lldebugger.start()
end
lldebugger._VERSION = "v0.3.3"

print("Happy debugging!")
