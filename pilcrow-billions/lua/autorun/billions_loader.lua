PW_Billions = PW_Billions or {}

print("Billions by Yogosh  - 76561198083488880")

local function loadFile(filePath)
  local fileName = filePath:GetFileFromFilename()

  fileName = fileName != "" and fileName or filePath

  if string.StartWith(fileName, "cl_") then
    if SERVER then
      AddCSLuaFile(filePath)
    end
    if CLIENT then
      include(filePath)
    end
  end
  if string.StartWith(fileName, "sv_") and SERVER then
      include(filePath)
      print("Billions: " .. filePath)
  end
  if string.StartWith(fileName, "sh_") then
    AddCSLuaFile(filePath)
    include(filePath)
    print("Billions: " .. filePath)
  end
end

local function loadFolder(folder)
  local files, folders = file.Find(folder .. "/*", "LUA")

  for k, v in pairs(files) do
    loadFile(folder .. "/" .. v)
  end
  for k,v in pairs(folders) do
    loadFolder(folder .. "/" .. v)
  end
end

print("Billions: Started loading files.")
print("Billions: Loading configuration files.")
loadFolder("billions-config")
print("Billions: Configuration files loaded.")
loadFolder("billions")
print("Billions: Files loaded")

print("Billions: Loading complete, have fun!")
