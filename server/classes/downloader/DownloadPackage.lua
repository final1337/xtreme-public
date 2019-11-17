DownloadPackage = inherit(Object)

function DownloadPackage:constructor(name)
    self.m_Name = name
    self.m_Files = {}
    self.m_FileData = {}

    -- POSSIBLE CALLBACKS
    -- self.onPackageReset
end

function DownloadPackage:doesFileExist(name)
    for key, value in pairs(self.m_Files) do
        if value == name then
            return true
        end
    end
    return false
end

function DownloadPackage:getDownloadFiles()
    return self.m_Files
end

function DownloadPackage:getName() return self.m_Name end
 
function DownloadPackage:reset()
    self.m_FileData = {}
    self.m_Files = {}
    if self.onPackageReset then
        self:onPackageReset(self.m_Name)
    end
end

function DownloadPackage:getFileData()
    return self.m_FileData
end

function DownloadPackage:addFiles(files)
    local affectedFiles = 0
    for key, value in ipairs(files) do
        if not self:doesFileExist(value) then
            table.insert(self.m_Files, value)
            affectedFiles = affectedFiles + 1
        end
    end
    if affectedFiles > 0 then
        self:generate()
    end
end

function DownloadPackage:generate()
    for key, value in ipairs(self.m_Files) do
        if not self.m_FileData[value] then
            if fileExists(value) then
                local file = fileOpen(value)
                self.m_FileData[value] = fileRead(file, fileGetSize(file))
                fileClose(file)
            end
        end
    end
end