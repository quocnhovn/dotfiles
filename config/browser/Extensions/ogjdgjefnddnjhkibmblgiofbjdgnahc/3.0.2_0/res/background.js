chrome.runtime.onMessage.addListener((request,sender,sendResponse)=>{
	if(request.msg=="reOpen"){
		chrome.sessions.getRecentlyClosed({maxResults:1},sessions=>{
			sessions.length && (sessions[0].tab?chrome.sessions.restore(sessions[0].tab.sessionId):chrome.sessions.restore(sessions[0].window.sessionId))
		})
	}else{
		chrome.tabs.query({active:true,currentWindow:true},tabs=>{
			switch(request.msg){
				case "newTab":
					chrome.tabs.create({index:tabs[0].index+1});
					break;
				case "closeTab":
					chrome.tabs.remove(tabs[0].id);
					break;
				case "prevTab":
					chrome.tabs.query({currentWindow:true},curTabs=>{
						var w=(tabs[0].index-1+curTabs.length)%curTabs.length;
                        chrome.tabs.update(curTabs[w].id,{active:true})
					});
					break;
				case "nextTab":
					chrome.tabs.query({currentWindow:true},curTabs=>{
						var n=(tabs[0].index+1)%curTabs.length;
                        chrome.tabs.update(curTabs[n].id,{active:true})
					});
					break;
				case "closeOther":
					chrome.tabs.query({currentWindow:true},curTabs=>{
						curTabs.forEach(tab=>{
							tab.id!==tabs[0].id&&!tab.pinned&&chrome.tabs.remove(tab.id)
						})
					});
					break;
				case "pinTab":
					chrome.tabs.update(tabs[0].id,{pinned:!tabs[0].pinned});
					break;
				case "closeWin":
					chrome.windows.remove(tabs[0].windowId);
					break;
				case "minWin":
					chrome.windows.update(tabs[0].windowId,{state:"minimized"});
					break;
				case "doubleTab":
					chrome.tabs.duplicate(tabs[0].id)
			}
		})
	}
});
chrome.runtime.onInstalled.addListener(details=>{
	"install"==details.reason&&(chrome.runtime.getPlatformInfo(info=>{chrome.storage.local.set({os:"win"==info.os?1:0})}),chrome.tabs.query({},function(t){for(var i=0;i<t.length;++i)chrome.scripting.executeScript({target:{tabId:t[i].id,allFrames:true},files:["res/add.js"]},()=>{chrome.runtime.lastError})}),chrome.runtime.openOptionsPage())
});
chrome.storage.onChanged.addListener(details=>{
	details.wow && chrome.tabs.query({},tabs=>{
		for(var i=0;i<tabs.length;++i)
			chrome.tabs.sendMessage(tabs[i].id,{
				message:"up",
				data:details.wow.newValue
			},()=>{
				chrome.runtime.lastError
			})
	})
});