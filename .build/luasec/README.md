# OpenSSL 3.0.7

> Win32 OpenSSL Command Prompt\
> OpenSSL 3.0.7 1 Nov 2022 (Library: OpenSSL 3.0.7 1 Nov 2022)

## Install `luasec`

Copy absolute path to `.build/luasec` folder by running the following command in Command Prompt (cmd.exe):

```cmd
echo %cd%/.build/luasec
```

After that do the following:

1. Press `CTRL+SHIFT+A`
2. Type `>run task`
3. Select `Tasks: Run Task`
4. Select `LuaRocks install {packagename}`
5. Type `luasec OPENSSL_DIR={REPLACEwithPreviousCopiedAbsolutePath}/.build/luasec`
6. Press `Enter`
7. Done!
