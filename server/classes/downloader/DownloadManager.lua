DownloadManager = inherit(Singleton)

addEvent("DownloadManager:fileFinished", true)
addEvent("DownloadManager:requestStartFiles", true)

-- TODO: at .zip /tar2 support for more files
-- / less file spam

-- REWORK DOWNLOAD SYSTEM

function DownloadManager:constructor()
	self.m_DownloadPackages = {}
	self.m_PlayerDownloadPack = {}
	
	self:loadMainFiles()

	addEventHandler("DownloadManager:fileFinished", root, bind(self.Event_FileFinished, self))
	addEventHandler("DownloadManager:requestStartFiles", root, bind(self.requestStartFiles, self))
end

function DownloadManager:requestStartFiles()
	if not client then return end
	self:downloadPackage(client, PROJECT_NAME.."_MAIN")
end

function DownloadManager:loadMainFiles()

	if self.m_DownloadPackages[PROJECT_NAME.."_MAIN"] then
		self.m_DownloadPackages[PROJECT_NAME.."_MAIN"]:reset();
	end

	local rootNode = xmlLoadFile("meta.xml")

	local files = {}

	local i = 0

	while xmlFindChild(rootNode, "rpfile", i) do

		table.insert(files, xmlNodeGetAttribute(xmlFindChild(rootNode, "rpfile", i), "src"))

		i = i + 1;
	end	

	self:prepareDownloadPackage(PROJECT_NAME.."_MAIN", files)

end

-- key == userdata(player), value == boolean
function DownloadManager:getDownloadingPlayer(packageName)
	return self.m_PlayerDownloadPack[packageName]
end

function DownloadManager:Event_FileFinished(name)
	if not client then return end
	if client.m_CurrentDownloads[name].CurrentDownload ~= client.m_CurrentDownloads[name].MaxFileDownload then
		self:intern_downloadPackage(client, name)
	else
		if client.m_CurrentDownloads[name].SuccessCallback then
			client.m_CurrentDownloads[name].SuccessCallback(client, name)
		end
		client.m_CurrentDownloads[name] = nil
	end
end

function DownloadManager:prepareDownloadPackage(name, files)
	if not self.m_DownloadPackages[name] then
		self.m_DownloadPackages[name] = DownloadPackage:new(name)
		self.m_PlayerDownloadPack = {}
		self.m_DownloadPackages[name]:addFiles(files)
	else
		self.m_DownloadPackages[name]:addFiles(files)
	end
	return self.m_DownloadPackages[name]
end

function DownloadManager:removePackage(name)
	self.m_DownloadPackages[name]:delete()
	self.m_DownloadPackages[name] = nil
end

function DownloadManager:downloadPackage(player, name, successCallback, abortCallback, resetCallback)
	if self.m_DownloadPackages[name] then
		if not self.m_PlayerDownloadPack[name] then
			self.m_PlayerDownloadPack[name] = {}
		end
		self.m_PlayerDownloadPack[name][player] = true
		-- player:sendMessage(loc("INIT_DOWNLOAD_PACKAGE", player), 0, 255, 0, name)
		player.m_CurrentDownloads[name] = {MaxFileDownload = #(self.m_DownloadPackages[name]:getDownloadFiles()), CurrentDownload = 0, 
										   SuccessCallback = successCallback, AbortCallback = abortCallback, ResetCallback = resetCallback}
		self:intern_downloadPackage(player, name)
	end
end

function DownloadManager:intern_downloadPackage(player, name)
	local tbl = player.m_CurrentDownloads[name]
	player.m_CurrentDownloads[name].CurrentDownload = tbl.CurrentDownload + 1
	local fileNames = self.m_DownloadPackages[name]:getDownloadFiles()
	local fileData = self.m_DownloadPackages[name]:getFileData()[fileNames[tbl.CurrentDownload]] 				-- NAME	FILEDATA,  FILEPATH,					 	FILECOUNT, 				MAXFILE
	triggerLatentClientEvent(player,"Downloader:receiveFile", 999999999, false, root, name, fileData, fileNames[tbl.CurrentDownload], tbl.CurrentDownload, tbl.MaxFileDownload)
end

function DownloadManager:destructor()

end