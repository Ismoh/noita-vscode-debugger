# 10 bullet points to debug Noita

1. Install [Noita](https://noitagame.com/) from [Steam](https://store.steampowered.com/app/881100/Noita/)
2. Install [lldebugger](https://marketplace.visualstudio.com/items?itemName=tomblind.local-lua-debugger-vscode) as VSCode extension and make sure to let some love to the author by giving a star to the [project](https://github.com/tomblind/local-lua-debugger-vscode).
3. Download [noita-vscode-debugger](https://github.com/Ismoh/noita-vscode-debugger/releases) mod and\
    go to `C:\Program Files (x86)\Steam\steamapps\common\Noita\mods\` and extract it there. [need help?](https://noita.wiki.gg/wiki/How_to_install_mods#Manual)
4. Open your current own project in VSCode and add the following to your `launch.json` file:
    <https://github.com/Ismoh/noita-vscode-debugger/blob/4dbdf6fd7b458466cefed01cda94b919d930bb28/.vscode/launch.json#L1-L19>
5. Double check if `"cwd"` needs to be changed to Noita installation path. [need help?](https://help.steampowered.com/en/faqs/view/4BD4-4528-6B2E-8327#:~:text=Navigate%20to%20your%20Steam%20client,installations%20can%20be%20installed%20there.)
6. Press `F5` to start debugging.
7. Make sure `noita-vscode-debugger` mod is enabled in the mod list\
    and above any other mod that you want to debug.
8. Enable unsafe mode in Noita\
    [need help?](https://noita.wiki.gg/wiki/How_to_install_mods#Enabling) and [still no clue?](https://noita.wiki.gg/wiki/Modding:_Lua_API#Lua_Tables)
    ![unsafe-mode-enabled-screenshot](res/unsafe-mode-enabled.png)
9. Click on `Start a new game with enabled mods active`\
    or click on `Continue` if you already have a save file with the mod enabled\
    or finally click on `New Game`.
10. Enjoy debugging!

## Help

Need help with the debugger itself? [Go ahead!](https://github.com/tomblind/local-lua-debugger-vscode)

Need help reading the logs? [Go ahead!](https://steamcommunity.com/workshop/filedetails/?id=2124936579)\
I am using `powershell`:

```powershell
cd 'C:\Program Files (x86)\Steam\steamapps\common\Noita'; Get-Content -Path "logger.txt" -Wait
```

## In case of issues

- First delete `noita-vscode-debugger` mod from `C:\Program Files (x86)\Steam\steamapps\common\Noita\mods\` and download the [latest release](https://github.com/Ismoh/noita-vscode-debugger/releases/latest).

- Second make sure\
`"args": ["-debug_lua", "-no-console", "-luadebugger"],` and\
`"pullBreakpointsSupport": true,`\
are set in `.vscode/launch.json`\
You can copy and paste [launch.json](.vscode/launch.json) from this repository, **BUT** make sure to change `noita-vscode-debugger` to your own mod name / mod string id.

- Open windows file explorer with\
`%USERPROFILE%/.vscode/extensions/tomblind.local-lua-debugger-vscode-0.3.3/debugger/`\
and remove the first line of `lldebugger.lua`, which is

    > --_VERSION = "v0.3.3-IsmohFixes"

- After that rerun Noita with enabled `noita-vscode-debugger` and take a look for the following in logs:
    > Successfully fixed package.path and package.cpath!\
    > Successfully applied all fixes!\
    > Happy debugging!

- Disable `noita-vscode-debugger` mod in Noita.

- Then the fun part begins!\
**You only need to run `noita-vscode-debugger` once, to apply all fixes.**\
After that you need to make sure the debugger is able to be initialized correctly and is able to pull breakpoints
  - Initialization:\
    This is done by your `launch.json` property args `"-luadebugger"`.\
    **But** you only want the debugger to be available, when debugging:
    This is why, you should add the following snippet in **your own** mod `init.lua`

    ```lua
    if not lldebugger then
        -- lldebugger is not initialized, so mock functions to avoid errors
        lldebugger = {} -- or _G.lldebugger = {}
        lldebugger.pullBreakpoints = function() end
        print("Debugger disabled, because Noita wasn't started from VSCode!")
    else
        -- lldebugger is only initialized, when starting Noita with VSCode debugger
        -- by adding the following to launch.json: "args": ["-luadebugger"]
        lldebugger.start(true)
        print("Debugger initialized! YAY! Happy debugging!")
    end
    ```

  - Pull breakpoints:\
    In addition to let VSCode know, there are breakpoints added during runtime, you need to add the following snippet in **your own** mod `init.lua`.\
    Use any of Noitas `[A-Z][a-z]{Pre|Post}Update()` functions, to make sure the breakpoints are pulled on runtime:\
    `OnPausePreUpdate` **and/or** `OnPausePreUpdate` **and/or** `OnPausePostUpdate` **and/or** `OnWorldPostUpdate`:

    ```lua
    function OnWorldPreUpdate()
        --if lldebugger then
            lldebugger.pullBreakpoints()
        --end
    end
    ```

Still no luck?\
[Go ahead to Discord forum!](https://discord.com/channels/453998283174576133/1161334163387994162)
