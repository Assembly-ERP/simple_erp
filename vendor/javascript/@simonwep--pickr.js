var t={};!function(u,h){t=h()}(self,(()=>(()=>{var t={d:(u,h)=>{for(var d in h)t.o(h,d)&&!t.o(u,d)&&Object.defineProperty(u,d,{enumerable:!0,get:h[d]})},o:(t,u)=>Object.prototype.hasOwnProperty.call(t,u),r:t=>{"undefined"!=typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(t,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(t,"__esModule",{value:!0})}},u={};t.d(u,{default:()=>E});var h={};function n(t,u,h,d,m={}){u instanceof HTMLCollection||u instanceof NodeList?u=Array.from(u):Array.isArray(u)||(u=[u]),Array.isArray(h)||(h=[h]);for(const S of u)for(const u of h)S[t](u,d,{capture:!1,...m});return Array.prototype.slice.call(arguments,1)}t.r(h),t.d(h,{adjustableInputNumbers:()=>p,createElementFromString:()=>r,createFromTemplate:()=>a,eventPath:()=>l,off:()=>m,on:()=>d,resolveElement:()=>c});const d=n.bind(null,"addEventListener"),m=n.bind(null,"removeEventListener");function r(t){const u=document.createElement("div");return u.innerHTML=t.trim(),u.firstElementChild}function a(t){const e=(t,u)=>{const h=t.getAttribute(u);return t.removeAttribute(u),h},o=(t,u={})=>{const h=e(t,":obj"),d=e(t,":ref"),m=h?u[h]={}:u;d&&(u[d]=t);for(const u of Array.from(t.children)){const t=e(u,":arr"),h=o(u,t?{}:m);t&&(m[t]||(m[t]=[])).push(Object.keys(h).length?h:u)}return u};return o(r(t))}function l(t){let u=t.path||t.composedPath&&t.composedPath();if(u)return u;let h=t.target.parentElement;for(u=[t.target,h];h=h.parentElement;)u.push(h);return u.push(document,window),u}function c(t){return t instanceof Element?t:"string"==typeof t?t.split(/>>/g).reduce(((t,u,h,d)=>(t=t.querySelector(u),h<d.length-1?t.shadowRoot:t)),document):null}function p(t,u=(t=>t)){function o(h){const d=[.001,.01,.1][Number(h.shiftKey||2*h.ctrlKey)]*(h.deltaY<0?1:-1);let m=0,S=t.selectionStart;t.value=t.value.replace(/[\d.]+/g,((t,h)=>h<=S&&h+t.length>=S?(S=h,u(Number(t),d,m)):(m++,t))),t.focus(),t.setSelectionRange(S,S),h.preventDefault(),t.dispatchEvent(new Event("input"))}d(t,"focus",(()=>d(window,"wheel",o,{passive:!1}))),d(t,"blur",(()=>m(window,"wheel",o)))}const{min:S,max:L,floor:B,round:P}=Math;function f(t,u,h){u/=100,h/=100;const d=B(t=t/360*6),m=t-d,S=h*(1-u),L=h*(1-m*u),P=h*(1-(1-m)*u),x=d%6;return[255*[h,L,S,S,P,h][x],255*[P,h,h,L,S,S][x],255*[S,S,P,h,h,L][x]]}function v(t,u,h){const d=(2-(u/=100))*(h/=100)/2;return 0!==d&&(u=1===d?0:d<.5?u*h/(2*d):u*h/(2-2*d)),[t,100*u,100*d]}function b(t,u,h){const d=S(t/=255,u/=255,h/=255),m=L(t,u,h),B=m-d;let P,x;if(0===B)P=x=0;else{x=B/m;const d=((m-t)/6+B/2)/B,S=((m-u)/6+B/2)/B,L=((m-h)/6+B/2)/B;t===m?P=L-S:u===m?P=1/3+d-L:h===m&&(P=2/3+S-d),P<0?P+=1:P>1&&(P-=1)}return[360*P,100*x,100*m]}function y(t,u,h,d){u/=100,h/=100;return[...b(255*(1-S(1,(t/=100)*(1-(d/=100))+d)),255*(1-S(1,u*(1-d)+d)),255*(1-S(1,h*(1-d)+d)))]}function g(t,u,h){u/=100;const d=2*(u*=(h/=100)<.5?h:1-h)/(h+u)*100,m=100*(h+u);return[t,isNaN(d)?0:d,m]}function _(t){return b(...t.match(/.{2}/g).map((t=>parseInt(t,16))))}function w(t){t=t.match(/^[a-zA-Z]+$/)?function(t){if("black"===t.toLowerCase())return"#000";const u=document.createElement("canvas").getContext("2d");return u.fillStyle=t,"#000"===u.fillStyle?null:u.fillStyle}(t):t;const u={cmyk:/^cmyk\D+([\d.]+)\D+([\d.]+)\D+([\d.]+)\D+([\d.]+)/i,rgba:/^rgba?\D+([\d.]+)(%?)\D+([\d.]+)(%?)\D+([\d.]+)(%?)\D*?(([\d.]+)(%?)|$)/i,hsla:/^hsla?\D+([\d.]+)\D+([\d.]+)\D+([\d.]+)\D*?(([\d.]+)(%?)|$)/i,hsva:/^hsva?\D+([\d.]+)\D+([\d.]+)\D+([\d.]+)\D*?(([\d.]+)(%?)|$)/i,hexa:/^#?(([\dA-Fa-f]{3,4})|([\dA-Fa-f]{6})|([\dA-Fa-f]{8}))$/i},o=t=>t.map((t=>/^(|\d+)\.\d+|\d+$/.test(t)?Number(t):void 0));let h;t:for(const d in u)if(h=u[d].exec(t))switch(d){case"cmyk":{const[,t,u,m,S]=o(h);if(t>100||u>100||m>100||S>100)break t;return{values:y(t,u,m,S),type:d}}case"rgba":{let[,t,,u,,m,,,S]=o(h);if(t="%"===h[2]?t/100*255:t,u="%"===h[4]?u/100*255:u,m="%"===h[6]?m/100*255:m,S="%"===h[9]?S/100:S,t>255||u>255||m>255||S<0||S>1)break t;return{values:[...b(t,u,m),S],a:S,type:d}}case"hexa":{let[,t]=h;4!==t.length&&3!==t.length||(t=t.split("").map((t=>t+t)).join(""));const u=t.substring(0,6);let m=t.substring(6);return m=m?parseInt(m,16)/255:void 0,{values:[..._(u),m],a:m,type:d}}case"hsla":{let[,t,u,m,,S]=o(h);if(S="%"===h[6]?S/100:S,t>360||u>100||m>100||S<0||S>1)break t;return{values:[...g(t,u,m),S],a:S,type:d}}case"hsva":{let[,t,u,m,,S]=o(h);if(S="%"===h[6]?S/100:S,t>360||u>100||m>100||S<0||S>1)break t;return{values:[t,u,m,S],a:S,type:d}}}return{values:null,type:null}}function A(t=0,u=0,h=0,d=1){const i=(t,u)=>(h=-1)=>u(~h?t.map((t=>Number(t.toFixed(h)))):t),m={h:t,s:u,v:h,a:d,toHSVA(){const t=[m.h,m.s,m.v,m.a];return t.toString=i(t,(t=>`hsva(${t[0]}, ${t[1]}%, ${t[2]}%, ${m.a})`)),t},toHSLA(){const t=[...v(m.h,m.s,m.v),m.a];return t.toString=i(t,(t=>`hsla(${t[0]}, ${t[1]}%, ${t[2]}%, ${m.a})`)),t},toRGBA(){const t=[...f(m.h,m.s,m.v),m.a];return t.toString=i(t,(t=>`rgba(${t[0]}, ${t[1]}, ${t[2]}, ${m.a})`)),t},toCMYK(){const t=function(t,u,h){const d=f(t,u,h),m=d[0]/255,L=d[1]/255,B=d[2]/255,P=S(1-m,1-L,1-B);return[100*(1===P?0:(1-m-P)/(1-P)),100*(1===P?0:(1-L-P)/(1-P)),100*(1===P?0:(1-B-P)/(1-P)),100*P]}(m.h,m.s,m.v);return t.toString=i(t,(t=>`cmyk(${t[0]}%, ${t[1]}%, ${t[2]}%, ${t[3]}%)`)),t},toHEXA(){const t=function(t,u,h){return f(t,u,h).map((t=>P(t).toString(16).padStart(2,"0")))}(m.h,m.s,m.v),u=m.a>=1?"":Number((255*m.a).toFixed(0)).toString(16).toUpperCase().padStart(2,"0");return u&&t.push(u),t.toString=()=>`#${t.join("").toUpperCase()}`,t},clone:()=>A(m.h,m.s,m.v,m.a)};return m}const $=t=>Math.max(Math.min(t,1),0);function C(t){const u={options:Object.assign({lock:null,onchange:()=>0,onstop:()=>0},t),_keyboard(t){const{options:h}=u,{type:d,key:m}=t;if(document.activeElement===h.wrapper){const{lock:h}=u.options,S="ArrowUp"===m,L="ArrowRight"===m,B="ArrowDown"===m,P="ArrowLeft"===m;if("keydown"===d&&(S||L||B||P)){let d=0,m=0;"v"===h?d=S||L?1:-1:"h"===h?d=S||L?-1:1:(m=S?-1:B?1:0,d=P?-1:L?1:0),u.update($(u.cache.x+.01*d),$(u.cache.y+.01*m)),t.preventDefault()}else m.startsWith("Arrow")&&(u.options.onstop(),t.preventDefault())}},_tapstart(t){d(document,["mouseup","touchend","touchcancel"],u._tapstop),d(document,["mousemove","touchmove"],u._tapmove),t.cancelable&&t.preventDefault(),u._tapmove(t)},_tapmove(t){const{options:h,cache:d}=u,{lock:m,element:S,wrapper:L}=h,B=L.getBoundingClientRect();let P=0,x=0;if(t){const u=t&&t.touches&&t.touches[0];P=t?(u||t).clientX:0,x=t?(u||t).clientY:0,P<B.left?P=B.left:P>B.left+B.width&&(P=B.left+B.width),x<B.top?x=B.top:x>B.top+B.height&&(x=B.top+B.height),P-=B.left,x-=B.top}else d&&(P=d.x*B.width,x=d.y*B.height);"h"!==m&&(S.style.left=`calc(${P/B.width*100}% - ${S.offsetWidth/2}px)`),"v"!==m&&(S.style.top=`calc(${x/B.height*100}% - ${S.offsetHeight/2}px)`),u.cache={x:P/B.width,y:x/B.height};const R=$(P/B.width),D=$(x/B.height);switch(m){case"v":return h.onchange(R);case"h":return h.onchange(D);default:return h.onchange(R,D)}},_tapstop(){u.options.onstop(),m(document,["mouseup","touchend","touchcancel"],u._tapstop),m(document,["mousemove","touchmove"],u._tapmove)},trigger(){u._tapmove()},update(t=0,h=0){const{left:d,top:m,width:S,height:L}=u.options.wrapper.getBoundingClientRect();"h"===u.options.lock&&(h=t),u._tapmove({clientX:d+S*t,clientY:m+L*h})},destroy(){const{options:t,_tapstart:h,_keyboard:d}=u;m(document,["keydown","keyup"],d),m([t.wrapper,t.element],"mousedown",h),m([t.wrapper,t.element],"touchstart",h,{passive:!1})}},{options:h,_tapstart:S,_keyboard:L}=u;return d([h.wrapper,h.element],"mousedown",S),d([h.wrapper,h.element],"touchstart",S,{passive:!1}),d(document,["keydown","keyup"],L),u}function k(t={}){t=Object.assign({onchange:()=>0,className:"",elements:[]},t);const u=d(t.elements,"click",(u=>{t.elements.forEach((h=>h.classList[u.target===h?"add":"remove"](t.className))),t.onchange(u),u.stopPropagation()}));return{destroy:()=>m(...u)}}const x={variantFlipOrder:{start:"sme",middle:"mse",end:"ems"},positionFlipOrder:{top:"tbrl",right:"rltb",bottom:"btrl",left:"lrbt"},position:"bottom",margin:8,padding:0},O=(t,u,h)=>{const d="object"!=typeof t||t instanceof HTMLElement?{reference:t,popper:u,...h}:t;return{update(t=d){const{reference:u,popper:h}=Object.assign(d,t);if(!h||!u)throw new Error("Popper- or reference-element missing.");return((t,u,h)=>{const{container:d,arrow:m,margin:S,padding:L,position:B,variantFlipOrder:P,positionFlipOrder:R}={container:document.documentElement.getBoundingClientRect(),...x,...h},{left:D,top:H}=u.style;u.style.left="0",u.style.top="0";const j=t.getBoundingClientRect(),F=u.getBoundingClientRect(),N={t:j.top-F.height-S,b:j.bottom+S,r:j.right+S,l:j.left-F.width-S},T={vs:j.left,vm:j.left+j.width/2-F.width/2,ve:j.left+j.width-F.width,hs:j.top,hm:j.bottom-j.height/2-F.height/2,he:j.bottom-F.height},[M,U="middle"]=B.split("-"),V=R[M],z=P[U],{top:I,left:X,bottom:G,right:K}=d;for(const t of V){const h="t"===t||"b"===t;let d=N[t];const[S,B]=h?["top","left"]:["left","top"],[P,x]=h?[F.height,F.width]:[F.width,F.height],[R,D]=h?[G,K]:[K,G],[H,M]=h?[I,X]:[X,I];if(!(d<H||d+P+L>R))for(const R of z){let H=T[(h?"v":"h")+R];if(!(H<M||H+x+L>D)){if(H-=F[B],d-=F[S],u.style[B]=`${H}px`,u.style[S]=`${d}px`,m){const t=h?j.width/2:j.height/2,u=2*t<x?j[B]+t:H+x/2;d<j[S]&&(d+=P),m.style[B]=`${u}px`,m.style[S]=`${d}px`}return t+R}}}return u.style.left=D,u.style.top=H,null})(u,h,d)}}};class E{static utils=h;static version="1.9.0";static I18N_DEFAULTS={"ui:dialog":"color picker dialog","btn:toggle":"toggle color picker dialog","btn:swatch":"color swatch","btn:last-color":"use previous color","btn:save":"Save","btn:cancel":"Cancel","btn:clear":"Clear","aria:btn:save":"save and close","aria:btn:cancel":"cancel and close","aria:btn:clear":"clear and close","aria:input":"color input field","aria:palette":"color selection area","aria:hue":"hue selection slider","aria:opacity":"selection slider"};static DEFAULT_OPTIONS={appClass:null,theme:"classic",useAsButton:!1,padding:8,disabled:!1,comparison:!0,closeOnScroll:!1,outputPrecision:0,lockOpacity:!1,autoReposition:!0,container:"body",components:{interaction:{}},i18n:{},swatches:null,inline:!1,sliders:null,default:"#42445a",defaultRepresentation:null,position:"bottom-middle",adjustableNumbers:!0,showAlways:!1,closeWithKey:"Escape"};_initializingActive=!0;_recalc=!0;_nanopop=null;_root=null;_color=A();_lastColor=A();_swatchColors=[];_setupAnimationFrame=null;_eventListener={init:[],save:[],hide:[],show:[],clear:[],change:[],changestop:[],cancel:[],swatchselect:[]};constructor(t){this.options=t=Object.assign({...E.DEFAULT_OPTIONS},t);const{swatches:u,components:h,theme:d,sliders:m,lockOpacity:S,padding:L}=t;["nano","monolith"].includes(d)&&!m&&(t.sliders="h"),h.interaction||(h.interaction={});const{preview:B,opacity:P,hue:x,palette:R}=h;h.opacity=!S&&P,h.palette=R||B||P||x,this._preBuild(),this._buildComponents(),this._bindEvents(),this._finalBuild(),u&&u.length&&u.forEach((t=>this.addSwatch(t)));const{button:D,app:H}=this._root;this._nanopop=O(D,H,{margin:L}),D.setAttribute("role","button"),D.setAttribute("aria-label",this._t("btn:toggle"));const j=this;this._setupAnimationFrame=requestAnimationFrame((function e(){if(!H.offsetWidth)return requestAnimationFrame(e);j.setColor(t.default),j._rePositioningPicker(),t.defaultRepresentation&&(j._representation=t.defaultRepresentation,j.setColorRepresentation(j._representation)),t.showAlways&&j.show(),j._initializingActive=!1,j._emit("init")}))}static create=t=>new E(t);_preBuild(){const{options:t}=this;for(const u of["el","container"])t[u]=c(t[u]);this._root=(t=>{const{components:u,useAsButton:h,inline:d,appClass:m,theme:S,lockOpacity:L}=t.options,l=t=>t?"":'style="display:none" hidden',c=u=>t._t(u),B=a(`\n      <div :ref="root" class="pickr">\n\n        ${h?"":'<button type="button" :ref="button" class="pcr-button"></button>'}\n\n        <div :ref="app" class="pcr-app ${m||""}" data-theme="${S}" ${d?'style="position: unset"':""} aria-label="${c("ui:dialog")}" role="window">\n          <div class="pcr-selection" ${l(u.palette)}>\n            <div :obj="preview" class="pcr-color-preview" ${l(u.preview)}>\n              <button type="button" :ref="lastColor" class="pcr-last-color" aria-label="${c("btn:last-color")}"></button>\n              <div :ref="currentColor" class="pcr-current-color"></div>\n            </div>\n\n            <div :obj="palette" class="pcr-color-palette">\n              <div :ref="picker" class="pcr-picker"></div>\n              <div :ref="palette" class="pcr-palette" tabindex="0" aria-label="${c("aria:palette")}" role="listbox"></div>\n            </div>\n\n            <div :obj="hue" class="pcr-color-chooser" ${l(u.hue)}>\n              <div :ref="picker" class="pcr-picker"></div>\n              <div :ref="slider" class="pcr-hue pcr-slider" tabindex="0" aria-label="${c("aria:hue")}" role="slider"></div>\n            </div>\n\n            <div :obj="opacity" class="pcr-color-opacity" ${l(u.opacity)}>\n              <div :ref="picker" class="pcr-picker"></div>\n              <div :ref="slider" class="pcr-opacity pcr-slider" tabindex="0" aria-label="${c("aria:opacity")}" role="slider"></div>\n            </div>\n          </div>\n\n          <div class="pcr-swatches ${u.palette?"":"pcr-last"}" :ref="swatches"></div>\n\n          <div :obj="interaction" class="pcr-interaction" ${l(Object.keys(u.interaction).length)}>\n            <input :ref="result" class="pcr-result" type="text" spellcheck="false" ${l(u.interaction.input)} aria-label="${c("aria:input")}">\n\n            <input :arr="options" class="pcr-type" data-type="HEXA" value="${L?"HEX":"HEXA"}" type="button" ${l(u.interaction.hex)}>\n            <input :arr="options" class="pcr-type" data-type="RGBA" value="${L?"RGB":"RGBA"}" type="button" ${l(u.interaction.rgba)}>\n            <input :arr="options" class="pcr-type" data-type="HSLA" value="${L?"HSL":"HSLA"}" type="button" ${l(u.interaction.hsla)}>\n            <input :arr="options" class="pcr-type" data-type="HSVA" value="${L?"HSV":"HSVA"}" type="button" ${l(u.interaction.hsva)}>\n            <input :arr="options" class="pcr-type" data-type="CMYK" value="CMYK" type="button" ${l(u.interaction.cmyk)}>\n\n            <input :ref="save" class="pcr-save" value="${c("btn:save")}" type="button" ${l(u.interaction.save)} aria-label="${c("aria:btn:save")}">\n            <input :ref="cancel" class="pcr-cancel" value="${c("btn:cancel")}" type="button" ${l(u.interaction.cancel)} aria-label="${c("aria:btn:cancel")}">\n            <input :ref="clear" class="pcr-clear" value="${c("btn:clear")}" type="button" ${l(u.interaction.clear)} aria-label="${c("aria:btn:clear")}">\n          </div>\n        </div>\n      </div>\n    `),P=B.interaction;return P.options.find((t=>!t.hidden&&!t.classList.add("active"))),P.type=()=>P.options.find((t=>t.classList.contains("active"))),B})(this),t.useAsButton&&(this._root.button=t.el),t.container.appendChild(this._root.root)}_finalBuild(){const t=this.options,u=this._root;if(t.container.removeChild(u.root),t.inline){const h=t.el.parentElement;t.el.nextSibling?h.insertBefore(u.app,t.el.nextSibling):h.appendChild(u.app)}else t.container.appendChild(u.app);t.useAsButton?t.inline&&t.el.remove():t.el.parentNode.replaceChild(u.root,t.el),t.disabled&&this.disable(),t.comparison||(u.button.style.transition="none",t.useAsButton||(u.preview.lastColor.style.transition="none")),this.hide()}_buildComponents(){const t=this,u=this.options.components,h=(t.options.sliders||"v").repeat(2),[d,m]=h.match(/^[vh]+$/g)?h:[],s=()=>this._color||(this._color=this._lastColor.clone()),S={palette:C({element:t._root.palette.picker,wrapper:t._root.palette.palette,onstop:()=>t._emit("changestop","slider",t),onchange(h,d){if(!u.palette)return;const m=s(),{_root:S,options:L}=t,{lastColor:B,currentColor:P}=S.preview;t._recalc&&(m.s=100*h,m.v=100-100*d,m.v<0&&(m.v=0),t._updateOutput("slider"));const x=m.toRGBA().toString(0);this.element.style.background=x,this.wrapper.style.background=`\n                        linear-gradient(to top, rgba(0, 0, 0, ${m.a}), transparent),\n                        linear-gradient(to left, hsla(${m.h}, 100%, 50%, ${m.a}), rgba(255, 255, 255, ${m.a}))\n                    `,L.comparison?L.useAsButton||t._lastColor||B.style.setProperty("--pcr-color",x):(S.button.style.setProperty("--pcr-color",x),S.button.classList.remove("clear"));const R=m.toHEXA().toString();for(const{el:u,color:h}of t._swatchColors)u.classList[R===h.toHEXA().toString()?"add":"remove"]("pcr-active");P.style.setProperty("--pcr-color",x)}}),hue:C({lock:"v"===m?"h":"v",element:t._root.hue.picker,wrapper:t._root.hue.slider,onstop:()=>t._emit("changestop","slider",t),onchange(h){if(!u.hue||!u.palette)return;const d=s();t._recalc&&(d.h=360*h),this.element.style.backgroundColor=`hsl(${d.h}, 100%, 50%)`,S.palette.trigger()}}),opacity:C({lock:"v"===d?"h":"v",element:t._root.opacity.picker,wrapper:t._root.opacity.slider,onstop:()=>t._emit("changestop","slider",t),onchange(h){if(!u.opacity||!u.palette)return;const d=s();t._recalc&&(d.a=Math.round(100*h)/100),this.element.style.background=`rgba(0, 0, 0, ${d.a})`,S.palette.trigger()}}),selectable:k({elements:t._root.interaction.options,className:"active",onchange(u){t._representation=u.target.getAttribute("data-type").toUpperCase(),t._recalc&&t._updateOutput("swatch")}})};this._components=S}_bindEvents(){const{_root:t,options:u}=this,h=[d(t.interaction.clear,"click",(()=>this._clearColor())),d([t.interaction.cancel,t.preview.lastColor],"click",(()=>{this.setHSVA(...(this._lastColor||this._color).toHSVA(),!0),this._emit("cancel")})),d(t.interaction.save,"click",(()=>{!this.applyColor()&&!u.showAlways&&this.hide()})),d(t.interaction.result,["keyup","input"],(t=>{this.setColor(t.target.value,!0)&&!this._initializingActive&&(this._emit("change",this._color,"input",this),this._emit("changestop","input",this)),t.stopImmediatePropagation()})),d(t.interaction.result,["focus","blur"],(t=>{this._recalc="blur"===t.type,this._recalc&&this._updateOutput(null)})),d([t.palette.palette,t.palette.picker,t.hue.slider,t.hue.picker,t.opacity.slider,t.opacity.picker],["mousedown","touchstart"],(()=>this._recalc=!0),{passive:!0})];if(!u.showAlways){const m=u.closeWithKey;h.push(d(t.button,"click",(()=>this.isOpen()?this.hide():this.show())),d(document,"keyup",(t=>this.isOpen()&&(t.key===m||t.code===m)&&this.hide())),d(document,["touchstart","mousedown"],(u=>{this.isOpen()&&!l(u).some((u=>u===t.app||u===t.button))&&this.hide()}),{capture:!0}))}if(u.adjustableNumbers){const u={rgba:[255,255,255,1],hsva:[360,100,100,1],hsla:[360,100,100,1],cmyk:[100,100,100,100]};p(t.interaction.result,((t,h,d)=>{const m=u[this.getColorRepresentation().toLowerCase()];if(m){const u=m[d],S=t+(u>=100?1e3*h:h);return S<=0?0:Number((S<u?S:u).toPrecision(3))}return t}))}if(u.autoReposition&&!u.inline){let t=null;const m=this;h.push(d(window,["scroll","resize"],(()=>{m.isOpen()&&(u.closeOnScroll&&m.hide(),null===t?(t=setTimeout((()=>t=null),100),requestAnimationFrame((function e(){m._rePositioningPicker(),null!==t&&requestAnimationFrame(e)}))):(clearTimeout(t),t=setTimeout((()=>t=null),100)))}),{capture:!0}))}this._eventBindings=h}_rePositioningPicker(){const{options:t}=this;if(!t.inline&&!this._nanopop.update({container:document.body.getBoundingClientRect(),position:t.position})){const t=this._root.app,u=t.getBoundingClientRect();t.style.top=(window.innerHeight-u.height)/2+"px",t.style.left=(window.innerWidth-u.width)/2+"px"}}_updateOutput(t){const{_root:u,_color:h,options:d}=this;if(u.interaction.type()){const t=`to${u.interaction.type().getAttribute("data-type")}`;u.interaction.result.value="function"==typeof h[t]?h[t]().toString(d.outputPrecision):""}!this._initializingActive&&this._recalc&&this._emit("change",h,t,this)}_clearColor(t=!1){const{_root:u,options:h}=this;h.useAsButton||u.button.style.setProperty("--pcr-color","rgba(0, 0, 0, 0.15)"),u.button.classList.add("clear"),h.showAlways||this.hide(),this._lastColor=null,this._initializingActive||t||(this._emit("save",null),this._emit("clear"))}_parseLocalColor(t){const{values:u,type:h,a:d}=w(t),{lockOpacity:m}=this.options,S=void 0!==d&&1!==d;return u&&3===u.length&&(u[3]=void 0),{values:!u||m&&S?null:u,type:h}}_t(t){return this.options.i18n[t]||E.I18N_DEFAULTS[t]}_emit(t,...u){this._eventListener[t].forEach((t=>t(...u,this)))}on(t,u){return this._eventListener[t].push(u),this}off(t,u){const h=this._eventListener[t]||[],d=h.indexOf(u);return~d&&h.splice(d,1),this}addSwatch(t){const{values:u}=this._parseLocalColor(t);if(u){const{_swatchColors:t,_root:h}=this,m=A(...u),S=r(`<button type="button" style="--pcr-color: ${m.toRGBA().toString(0)}" aria-label="${this._t("btn:swatch")}"/>`);return h.swatches.appendChild(S),t.push({el:S,color:m}),this._eventBindings.push(d(S,"click",(()=>{this.setHSVA(...m.toHSVA(),!0),this._emit("swatchselect",m),this._emit("change",m,"swatch",this)}))),!0}return!1}removeSwatch(t){const u=this._swatchColors[t];if(u){const{el:h}=u;return this._root.swatches.removeChild(h),this._swatchColors.splice(t,1),!0}return!1}applyColor(t=!1){const{preview:u,button:h}=this._root,d=this._color.toRGBA().toString(0);return u.lastColor.style.setProperty("--pcr-color",d),this.options.useAsButton||h.style.setProperty("--pcr-color",d),h.classList.remove("clear"),this._lastColor=this._color.clone(),this._initializingActive||t||this._emit("save",this._color),this}destroy(){cancelAnimationFrame(this._setupAnimationFrame),this._eventBindings.forEach((t=>m(...t))),Object.keys(this._components).forEach((t=>this._components[t].destroy()))}destroyAndRemove(){this.destroy();const{root:t,app:u}=this._root;t.parentElement&&t.parentElement.removeChild(t),u.parentElement.removeChild(u),Object.keys(this).forEach((t=>this[t]=null))}hide(){return!!this.isOpen()&&(this._root.app.classList.remove("visible"),this._emit("hide"),!0)}show(){return!this.options.disabled&&!this.isOpen()&&(this._root.app.classList.add("visible"),this._rePositioningPicker(),this._emit("show",this._color),this)}isOpen(){return this._root.app.classList.contains("visible")}setHSVA(t=360,u=0,h=0,d=1,m=!1){const S=this._recalc;if(this._recalc=!1,t<0||t>360||u<0||u>100||h<0||h>100||d<0||d>1)return!1;this._color=A(t,u,h,d);const{hue:L,opacity:B,palette:P}=this._components;return L.update(t/360),B.update(d),P.update(u/100,1-h/100),m||this.applyColor(),S&&this._updateOutput(),this._recalc=S,!0}setColor(t,u=!1){if(null===t)return this._clearColor(u),!0;const{values:h,type:d}=this._parseLocalColor(t);if(h){const t=d.toUpperCase(),{options:m}=this._root.interaction,S=m.find((u=>u.getAttribute("data-type")===t));if(S&&!S.hidden)for(const t of m)t.classList[t===S?"add":"remove"]("active");return!!this.setHSVA(...h,u)&&this.setColorRepresentation(t)}return!1}setColorRepresentation(t){return t=t.toUpperCase(),!!this._root.interaction.options.find((u=>u.getAttribute("data-type").startsWith(t)&&!u.click()))}getColorRepresentation(){return this._representation}getColor(){return this._color}getSelectedColor(){return this._lastColor}getRoot(){return this._root}disable(){return this.hide(),this.options.disabled=!0,this._root.button.classList.add("disabled"),this}enable(){return this.options.disabled=!1,this._root.button.classList.remove("disabled"),this}}return u.default})()));var u=t;const h=t.Pickr;export{h as Pickr,u as default};
