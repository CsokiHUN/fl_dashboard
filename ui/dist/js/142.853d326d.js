"use strict";(self["webpackChunkdashboard"]=self["webpackChunkdashboard"]||[]).push([[142],{4142:function(e,t,n){n.r(t),n.d(t,{default:function(){return p}});var a=n(3396),c=n(9242),o=n(7139);const s=e=>((0,a.dD)("data-v-f2ec4864"),e=e(),(0,a.Cn)(),e),d=s((()=>(0,a._)("h4",null,"Beállítások",-1))),l={class:"form-check form-switch"},u=["onUpdate:modelValue","onChange"];function r(e,t,n,s,r,i){return(0,a.wg)(),(0,a.iD)("div",null,[d,(0,a._)("ul",null,[((0,a.wg)(!0),(0,a.iD)(a.HY,null,(0,a.Ko)(i.settings,((e,t)=>((0,a.wg)(),(0,a.iD)("li",{key:t},[(0,a._)("div",l,[(0,a.wy)((0,a._)("input",{class:"form-check-input",type:"checkbox","onUpdate:modelValue":t=>e.value=t,onChange:e=>i.updateSetting(e,t),checked:""},null,40,u),[[c.e8,e.value]]),(0,a.Uk)(" "+(0,o.zw)(e.label),1)])])))),128))])])}var i={name:"SettingsView",computed:{settings(){return this.$root.settings}},methods:{updateSetting(e,t){const{checked:n}=e.target;fetch(`https://${GetParentResourceName()}/updateSetting`,{method:"POST",body:JSON.stringify({name:t,checked:n})}),localStorage.setItem("dashboard:"+t,n)}}},h=n(89);const g=(0,h.Z)(i,[["render",r],["__scopeId","data-v-f2ec4864"]]);var p=g}}]);
//# sourceMappingURL=142.853d326d.js.map