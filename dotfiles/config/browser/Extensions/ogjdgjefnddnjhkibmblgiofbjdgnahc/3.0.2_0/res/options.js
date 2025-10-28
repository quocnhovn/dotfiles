var getThisMessage=message=>chrome.i18n.getMessage(message),
byTag=tag=>document.getElementsByTagName(tag),
createElement=tag=>document.createElement(tag),
createElementNS=tag=>document.createElementNS('http://www.w3.org/2000/svg',tag),
createNode=txt=>document.createTextNode(txt);

document.addEventListener('DOMContentLoaded',function(){
	document.title=getThisMessage('optTitle');
	var settings=[0,1,2,3,4,5,6,7,8,9],
	options=['optNot','optNewTab','optClose','optRight','optLeft','optRefresh','optRestore','optNext','optPrev','optTop','optBottom','optCO','optPin','optCW','optMW','optDBL'],
	tips=['optMT','optMB','optMR','optML','optMTR','optMBL','optMBR','optMTL','optST','optSB'],
	pathD=(element0,vector)=>{
		var element2=createElementNS('path');
		element2.setAttributeNS(null,'d',vector);
		element2.setAttributeNS(null,'fill','#414141');
		element2.setAttributeNS(null,'stroke','#414141');
		element2.setAttributeNS(null,'stroke-width',3);
		element0.appendChild(element2)
	},
	paths=[
		element0=>{pathD(element0,'M21.5,42L21.5,5M20,5.5L21.5,4L23,5.5z')},
		element0=>{pathD(element0,'M21.5,0L21.5,37M20,37.5L21.5,39L23,37.5z')},
		element0=>{pathD(element0,'M2,21.5L39,21.5M40.5,20L42,21.5L40.5,23z')},
		element0=>{pathD(element0,'M42,21.5L5,21.5M4.5,20L3,21.5L4.5,23z')},
		element0=>{pathD(element0,'M7,36L38,5M38.5,4.5L37,4.5L38.5,6z')},
		element0=>{pathD(element0,'M7,36L38,5M5.5,37.5L5.5,36L7,37.5z')},
		element0=>{pathD(element0,'M7,6.5L38,37.5M37.5,37.5L37.5,36L36,37.5z')},
		element0=>{pathD(element0,'M7,6L38,37M5.5,4.5L7,4.5L5.5,6z')},
		element0=>{
			var element2=createElementNS('path');
			element2.setAttributeNS(null,'d','M21.5,13.5Q29.5,13.5 29.5,21.5L29.5,24.5L21.5,24.5L21.513.5z');
			element2.setAttributeNS(null,'fill','#ccc');
			element0.appendChild(element2);
			element2=createElementNS('path');
			element2.setAttributeNS(null,'d','M21.5 11L21.5 6M20 6.5L21.5 5L23 6.5zM21.5 13.5q8 0 8 8V32q0 8.5-8 8.5t-8-8v-11q0-8 8-8zm0 0q-8 0-8 8v11q0 8 8 8t8-11v-8q0-8-8-8zm-.5 10v-3q.5-.5 1 0v3q-.5.5-1 0z');
			element2.setAttributeNS(null,'fill','#414141');
			element2.setAttributeNS(null,'stroke','#414141');
			element2.setAttributeNS(null,'stroke-width',2.4);
			element2.setAttributeNS(null,'fill-rule','evenodd');
			element0.appendChild(element2)
		},
		element0=>{
			var element2=createElementNS('path');
			element2.setAttributeNS(null,'d','M21.5,13.5Q29.5,13.5 29.5,21.5L29.5,24.5L21.5,24.5L21.513.5z');
			element2.setAttributeNS(null,'fill','#ccc');
			element0.appendChild(element2);
			element2=createElementNS('path');
			element2.setAttributeNS(null,'d','M21.5 28L21.5 32M20 32.5L21.5 34L23 32.5zM21.5 13.5q8 0 8 8V32q0 8.5-8 8.5t-8-8v-11q0-8 8-8zm0 0q-8 0-8 8v11q0 8 8 8t8-11v-8q0-8-8-8zm-.5 10v-3q.5-.5 1 0v3q-.5.5-1 0z');
			element2.setAttributeNS(null,'fill','#414141');
			element2.setAttributeNS(null,'stroke','#414141');
			element2.setAttributeNS(null,'stroke-width',2.4);
			element2.setAttributeNS(null,'fill-rule','evenodd');
			element0.appendChild(element2)
		}
	],
	selectors=(element0,i)=>{
		var ops,element2=createElement('select');
		for(j=0;j<options.length;j++){
			ops=createElement('option');
			ops.setAttribute('value',j-1);
			ops.appendChild(createNode(getThisMessage(options[j])));
			element2.appendChild(ops)
		}
		element2.selectedIndex=parseInt(i,10)+1;
		element2.addEventListener("change",function(){
			var j,selector,resultArray=[],
			selector=byTag('select');
			for(j=0;j<selector.length;j++)
				resultArray.push(parseInt(selector[j].options[selector[j].selectedIndex].value,10))
			chrome.storage.local.set({wow:resultArray})
		});
		element0.appendChild(element2)
	},
	setOptions=resultArray=>{
		chrome.storage.local.set({wow:resultArray},function(){
			var j,selector=byTag('select');
			for(j=0;j<selector.length;j++)
				selector[j].selectedIndex=resultArray[j]+1;
		})
	};
	chrome.storage.local.get({wow:settings},function(request){
		var i,element0,element1,element2,element3,element4;
		element0=byTag('body');
		element2=createElement('header');
		element3=createElementNS('svg');
		element3.setAttributeNS(null,'width',45);
		element3.setAttributeNS(null,'height',45);
		element3.setAttributeNS(null,'viewBox','0 5 45 45');
		element4=createElementNS('path');
		element4.setAttributeNS(null,'d','M21.5 13.5q8 0 8 8V32q0 8.5-8 8.5t-8-8v-11q0-8 8-8zm0 0q-8 0-8 8v11q0 8 8 8t8-11v-8q0-8-8-8zm-.5 10v-3q.5-.5 1 0v3q-.5.5-1 0z');
		element4.setAttributeNS(null,'fill','#414141');
		element4.setAttributeNS(null,'stroke','#414141');
		element4.setAttributeNS(null,'stroke-width',2.4);
		element4.setAttributeNS(null,'fill-rule','evenodd');
		element3.appendChild(element4);
		element2.appendChild(element3);
		element3=createElement('h1');
		element3.appendChild(createNode(getThisMessage('extName')));
		element2.appendChild(element3);
		element0[0].appendChild(element2);
		for(i=0;i<request.wow.length;i++){
			if(i==0){
				element2=createElement('h3');
				element2.appendChild(createNode(getThisMessage('optMove')));
				element0[0].appendChild(element2)
			}else if(i==8){
					element2=createElement('h3');
					element2.appendChild(createNode(getThisMessage('optWheel')));
					element0[0].appendChild(element2)
				}
			element2=createElement('section');
			element3=createElementNS('svg');
			element3.setAttributeNS(null,'width',45);
			element3.setAttributeNS(null,'height',45);
			element3.setAttributeNS(null,'viewBox','0 0 45 45');
			paths[i](element3);
			element2.appendChild(element3);
			selectors(element2,request.wow[i]);
			element2.appendChild(element3);
			element3=createElement('p');
			element3.appendChild(createNode(getThisMessage('optHold')+getThisMessage(tips[i])));
			element2.appendChild(element3);
			element0[0].appendChild(element2)
		}
		element2=createElement('h3');
		element2.appendChild(createNode(getThisMessage('optTitle')));
		element0[0].appendChild(element2);
		element2=createElement('footer');
		element3=createElement('label');
		element4=createElement('button');
		element4.setAttribute('id','reset');
		element4.addEventListener('click',function(){
			chrome.storage.local.set({wow:[0,1,2,3,4,5,6,7,8,9]},function(){
				var j,s=byTag('select');
				for(j=0;j<s.length;j++){
					s[j].selectedIndex=j+1;
					if(s[j].style.backgroundColor.indexOf('rgb')!==-1)s[j].style.backgroundColor='transparent';
				}
			})
		});
		element4.appendChild(createNode(getThisMessage('optRes')));
		element3.appendChild(element4);
		element4=createElement('p');
		element4.appendChild(createNode(getThisMessage('optResDesc')));
		element3.appendChild(element4);
		element2.appendChild(element3);
		element3=createElement('label');
		element4=createElement('button');
		element4.setAttribute('id','import');
		element4.addEventListener('click',function(){
			var j,resultArray=[],
			selector=byTag('select');
			for(j=0;j<selector.length;j++)
				resultArray.push(parseInt(selector[j].options[selector[j].selectedIndex].value,10));
			var e=document.createElement('a');
			e.href='data:text/plain;charset=utf-8,'+JSON.stringify(resultArray);
			e.download='MouseGestureSettings.txt';
			document.body.appendChild(e);
			e.click();
			document.body.removeChild(e)
		});
		element4.appendChild(createNode(getThisMessage('optEx')));
		element3.appendChild(element4);
		element4=createElement('p');
		element4.appendChild(createNode(getThisMessage('optExDesc')));
		element3.appendChild(element4);
		element2.appendChild(element3);
		element3=createElement('input');
		element3.setAttribute('type','file');
		element3.setAttribute('id','rfile');
		element3.addEventListener('change',function(e){
			if(e.target.files&&e.target.files[0]){
				var reader=new FileReader();
				reader.onload=function(e){
					try{
						g=JSON.parse(e.target.result)
					}catch(e){return false}
					10==g.length && setOptions(g)
				},
				reader.readAsText(e.target.files[0]),
				this.value=''
			}
		});
		element3.setAttribute('class','hide');
		element2.appendChild(element3);
		element3=createElement('label');
		element4=createElement('button');
		element4.setAttribute('id','export');
		element4.addEventListener('click',function(){
			document.getElementById('rfile').click()
		});
		element4.appendChild(createNode(getThisMessage('optIm')));
		element3.appendChild(element4);
		element4=createElement('p');
		element4.appendChild(createNode(getThisMessage('optImDesc')));
		element3.appendChild(element4);
		element2.appendChild(element3);
		element0[0].appendChild(element2)
	})
});