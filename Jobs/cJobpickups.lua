

Jobs = {};

addEvent("Jobs.openWindow",true)
addEventHandler("Jobs.openWindow",root,function(job)
	if(isWindowOpen())then
		Jobs.selectedJob = job;
		Elements.window[1] = Window:create(1627, 801, 283, 269,Jobs.selectedJob,1920,1080);
		Elements.rectangle[1] = Rectangle:create(1627, 861, 283, 20,240,100,0,200,1920,1080);
		Elements.button[1] = Button:create(1701, 1023, 134, 31,"Starten","Jobs.start",1920,1080);
		Elements.image[1] = Image:create(1701, 880, 134, 123,"Files/Images/Job.png",1920,1080);
		setWindowDatas();
	end
end)

function Jobs.start()
	triggerServerEvent(Jobs.selectedJob..".start",localPlayer);
end