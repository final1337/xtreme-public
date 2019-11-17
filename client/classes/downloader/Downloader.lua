Downloader = inherit(Singleton)

addEvent("Downloader:receiveFile", true)
addEvent("Downloader:updateDownloadProgress", true)
addEvent("Downloader:wrapperReset", true)

function Downloader:constructor()
	self.m_DownloadProgress = 0
	self.m_MaxDownloadAmount = 0

	self.m_Package = {}
	self.m_MainDownloaded = false

	self.m_Init = false

	triggerServerEvent("DownloadManager:requestStartFiles", resourceRoot)

	addEventHandler("Downloader:receiveFile", root, bind(self.Event_FinishedFile, self))
	addEventHandler("Downloader:updateDownloadProgress", root, bind(self.Event_UpdateDownloadProgress, self))
	addEventHandler("Downloader:wrapperReset", root, bind(self.Event_OnWrapperReset, self))
end

function Downloader:Event_UpdateDownloadProgress(maxAmount)
	self.m_MaxDownloadAmount = maxAmount
end

function Downloader:Event_OnWrapperReset(name)
	triggerEvent("RP:Wrapper:reset", root)
end

function Downloader:Event_FinishedFile(name, fileContent, path, count, maxCount)

	if path:sub(0,1) == ":" then
		path = path:gsub(":", "")
		path = "downloaded/" .. path
	end

	local file
	if fileExists(path) then
		file = fileOpen(path)
	else
		file = fileCreate(path)
	end
	fileWrite(file, fileContent)
	fileClose(file)


	if count == 1 then
		self.m_Package[name] = {}
	end

	table.insert( self.m_Package[name],{Name = name, Path = path, Count = count, maxCount})


	triggerServerEvent("DownloadManager:fileFinished", resourceRoot, name)
	self.m_DownloadProgress = self.m_DownloadProgress + 1
	-- outputChatBox(("[DOWNLOAD] Package"):format(self.m_DownloadProgress, self.m_MaxDownloadAmount, path), 0, 255, 0)
	-- localPlayer:sendMessage(_"PACKAGE_DOWNLOAD_PROGRESS", 255, 255, 255, name, count, maxCount, path)

	if count >= maxCount then
		-- localPlayer:sendMessage(loc"COMPLETED_PACKAGE_DOWNLOAD", 0, 255, 0, name)
		if name == PROJECT_NAME.."_MAIN" and not self.m_MainDownloaded then
			core:afterDownload()
			self.m_MainDownloaded = true
		elseif name == PROJECT_NAME.."_MAIN" and self.m_MainDownloaded then 
			itemmanager:loadTemplateItems()
		elseif name:find("LOBBYDOWNLOAD_") then
			-- LOAD CSTM Resource
			local resourcename = split(path, "/")[2]
			local partof;
			for key, value in ipairs(self.m_Package[name]) do
				if value.Path:find(".lua") then
					partof = string.sub(value.Path, string.find(value.Path, "/", string.len("downloaded/".. resourcename))+1, #value.Path);
					triggerEvent("RP:Wrapper:load", root, partof, resourcename, localPlayer:getLobby():getDimension())
				elseif value.Path:find(".map") then
					local mainNode = xmlLoadFile(value.Path)
					for key, value in ipairs(xmlNodeGetChildren(mainNode)) do
						localPlayer:getLobby():useMapFile(value)
					end
					xmlUnloadFile(mainNode)
				end
			end
		end
		-- Job's done for the temp-saving tableinsert.
		self.m_Package[name] = nil
	end	
end
