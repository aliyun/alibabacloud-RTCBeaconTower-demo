import Vue from "vue";
import Router from "vue-router";
import store from "../vuex/index";

Vue.use(Router);

//主路由
const routes = [
  {
    path: "/",
    component: resolve => require(["../views/login/login.vue"], resolve)
  },
  {
    path: "/meet",
    component: resolve => require(["../views/home/index.vue"], resolve)
  }
  // 全不匹配的情况下，返回404，路由按顺序从上到下，依次匹配。最后一个*能匹配全部，
];

const router = new Router({
  hashbang: true,
  history: true,
  transitionOnLoad: true,
  routes
});
/*页面刷新重新赋值commmon*/
//给公共参数重新赋值
if (hgetStore("hvuex")) {
  store.dispatch("hvuex", JSON.parse(hgetStore("hvuex")));
}
//方便修改
export async function hvuex(obj) {
  return store.dispatch("hvuex", obj);
}
window.hvuex = hvuex;
//拦截
router.beforeEach((to, from, next) => {
  next();
  if(to.path=='/'&&from.path!='/'){
    setTimeout(()=>{
      window.location.reload();
    },200);
  }
});

export default router;
