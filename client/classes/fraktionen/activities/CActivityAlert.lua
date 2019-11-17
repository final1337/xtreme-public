ActivityAlert = inherit(Singleton)

addEvent("XTM:Acitivity:showAlert", true)


function ActivityAlert:constructor()
	
	
	addEventHandler("XTM:Acitivity:showAlert", root, bind(self.Event_ShowAlert, self))
end

function ActivityAlert:Event_ShowAlert(text)
	
end

function ActivityAlert:destructor()
	
end