(function(){
	var coordinates=null,
	mouseUp=false,
	wheelFlag=false,
	osFlag=false,
	osTimer,
	settings=[],
	send=message=>chrome.runtime.sendMessage(message),
	trust=event=>event.isTrusted,
	prevent=event=>{
		return event.preventDefault(),
		osFlag=false,
		coordinates=null,
		mouseUp=true,
		true
	},
	heights=()=>document.body.scrollHeight||document.documentElement.scrollHeight,
	events=[
		()=>{send({msg:"newTab"})},
		()=>{send({msg:"closeTab"})},
		()=>{send({msg:"nextTab"})},
		()=>{send({msg:"prevTab"})},
		()=>{location.reload()},
		()=>{send({msg:"reOpen"})},
		()=>{history.forward()},
		()=>{history.back()},
		()=>{window.scrollBy(0,-heights())},
		()=>{window.scrollBy(0,heights())},
		()=>{send({msg:"closeOther"})},
		()=>{send({msg:"pinTab"})},
		()=>{send({msg:"closeWin"})},
		()=>{send({msg:"minWin"})},
		()=>{send({msg:"doubleTab"})}
	],
	letsMath=(start,end)=>{
		var x=end.x-start.x,
		y=end.y-start.y,
		h=Math.sqrt(Math.pow(x,2)+Math.pow(y,2));
		if(x==0)return[y>0?3:7,h];
		var a=Math.atan(y/x)*180/Math.PI;
		a=x>0?a+90:a+270;
		a=a-23<0?360-a:a-23;
		a=Math.floor(a/45);
		return [a,h]
	};
	chrome.storage.local.get({wow:[0,1,2,3,4,5,6,7,8,9],os:1},request=>{
		settings=request.wow,
		
		(events[settings[8]]||events[settings[9]]) && window.addEventListener("wheel",event=>{
			coordinates && trust(event) && event.deltaY && (wheelFlag=true,event.deltaY<0 ? events[settings[8]] && prevent(event) && events[settings[8]]():events[settings[9]] && prevent(event) && events[settings[9]]())
		},{passive:false}),

		window.addEventListener("contextmenu",event=>{
			trust(event) && (request.os?mouseUp && event.preventDefault():(osFlag?coordinates=null:event.preventDefault(),osFlag=true,clearTimeout(osTimer),osTimer=setTimeout(()=>{osFlag=false},500)))
		},true),

		window.addEventListener("mouseup",event=>{
			if(2===event.button && coordinates && trust(event)){
				var mathResult=letsMath(coordinates,{x:event.clientX,y:event.clientY});
				if(mouseUp=true,coordinates=null,wheelFlag||mathResult[1]<6)return void(wheelFlag||(mouseUp=false));
				var magic=[4,2,6,1,5,3,7,0];
				events[settings[magic[mathResult[0]]]] && events[settings[magic[mathResult[0]]]](),
				osFlag=false
			}
		},true),
		
		chrome.runtime.onMessage.addListener((request,sender,sendResponse)=>{
			"up"==request.message && request.data && 10==request.data.length && (settings=request.data)
		})
	}),
	window.addEventListener("mousedown",event=>{
		trust(event) && (2!==event.button||coordinates||(wheelFlag=false,coordinates={x:event.clientX,y:event.clientY}))
	},true)
})();